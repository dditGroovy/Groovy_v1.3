<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<sec:authorize access="isAuthenticated()">
    <sec:authentication property="principal" var="CustomUser"/>
    <div class="content-container">
        <header id="tab-header">
            <h1><a href="${pageContext.request.contextPath}/vacation" class="on">내 휴가</a></h1>
            <h1><a href="${pageContext.request.contextPath}/salary/paystub/checkPassword">내 급여</a></h1>
            <h1><a href="${pageContext.request.contextPath}/vacation/request">휴가 기록</a></h1>
        </header>
        <button type="button" class="btn btn-out-sm btn-modal" data-name="requestVacation" data-action="request">휴가 신청하기
        </button>
        <br><br>
        <div>
            <h3 class="content-title font-b">휴가 신청 기록</h3>
            <table border="1">
                <tr>
                    <td>신청 번호</td>
                    <td>휴가 기간</td>
                    <td>휴가 구분</td>
                    <td>휴가 종류</td>
                    <td>결재 상태</td>
                </tr>
                <c:forEach var="recodeVO" items="${vacationRecord}" varStatus="stat">
                    <tr>
                        <td><a href="#" data-name="detailVacation" data-seq="${recodeVO.yrycUseDtlsSn}"
                               class="detailLink">${stat.count}</a></td>
                        <td>${recodeVO.yrycUseDtlsBeginDate} - ${recodeVO.yrycUseDtlsEndDate}</td>
                        <td>${recodeVO.commonCodeYrycUseKind}</td>
                        <td>${recodeVO.commonCodeYrycUseSe}</td>
                        <td>${recodeVO.commonCodeYrycState}</td>

                    </tr>
                </c:forEach>
            </table>
        </div>
    </div>

    <div id="modal" class="modal-dim">
        <div class="dim-bg"></div>
        <div class="modal-layer card-df sm requestVacation">
            <div class="modal-top">
                <div class="modal-title">휴가 신청</div>
                <button type="button" class="modal-close btn js-modal-close">
                    <i class="icon i-close close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <form action="${pageContext.request.contextPath}/vacation/request" method="post"
                      id="vacationRequestForm">
                    <div class="modal-content input-wrap">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <table class="form">
                            <input type="hidden" name="yrycUseDtlsEmplId" value="${CustomUser.employeeVO.emplId}"/>
                            <tr>
                                <th>휴가 구분</th>
                                <td>
                                    <input type="radio" name="commonCodeYrycUseKind" value="YRYC010">
                                    <label for="vacation1">연차</label>

                                    <input type="radio" name="commonCodeYrycUseKind" value="YRYC011">
                                    <label for="vacation2">공가</label>
                                </td>
                            </tr>
                            <tr>
                                <th>종류</th>
                                <td>
                                    <input type="radio" name="commonCodeYrycUseSe" value="YRYC020">
                                    <label for="morning">오전 반차</label>
                                    <input type="radio" name="commonCodeYrycUseSe" value="YRYC021">
                                    <label for="afternoon">오후 반차</label>
                                    <input type="radio" name="commonCodeYrycUseSe" value="YRYC022">
                                    <label for="allDay">종일</label>
                                </td>
                            </tr>
                            <tr>
                                <th>기간</th>
                                <td>
                                    <input type="date" name="yrycUseDtlsBeginDate" placeholder="시작 날짜"> ~
                                    <input type="date" name="yrycUseDtlsEndDate" placeholder="끝 날짜">
                                </td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td>
                                <textarea name="yrycUseDtlsRm" cols="30" rows="10"
                                          placeholder="내용"></textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                </form>
            </div>
            <div class="modal-footer btn-wrapper">
                <button type="submit" class="btn btn-fill-bl-sm" id="requestCard">확인</button>
                <button type="button" class="btn btn-fill-wh-sm close">취소</button>
            </div>
        </div>


            <%--   디테일/수정 모달     --%>
        <div class="modal-layer card-df sm detailVacation">
            <div class="modal-top">
                <div class="modal-title">휴가 신청 내용</div>
                <button type="button" class="modal-close btn js-modal-close">
                    <i class="icon i-close close">X</i>
                </button>
            </div>
            <div class="modal-container">
                <form action="${pageContext.request.contextPath}/vacation/modify/request" method="post"
                      id="vacationModifyForm">
                    <div class="modal-content input-wrap">
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <table class="form">
                            <input type="hidden" name="yrycUseDtlsEmplId" value="${CustomUser.employeeVO.emplId}"/>
                            <input type="hidden" name="yrycUseDtlsSn" id="sanctionNum"/>
                            <tr>
                                <th>휴가 구분</th>
                                <td>
                                    <input type="radio" name="commonCodeYrycUseKind" value="YRYC010" id="vacation1">
                                    <label for="vacation1">연차</label>

                                    <input type="radio" name="commonCodeYrycUseKind" value="YRYC011" id="vacation2">
                                    <label for="vacation2">공가</label>
                                </td>
                            </tr>
                            <tr>
                                <th>종류</th>
                                <td>
                                    <input type="radio" name="commonCodeYrycUseSe" id="morning" value="YRYC020">
                                    <label for="morning">오전 반차</label>
                                    <input type="radio" name="commonCodeYrycUseSe" id="afternoon" value="YRYC021">
                                    <label for="afternoon">오후 반차</label>
                                    <input type="radio" name="commonCodeYrycUseSe" id="allDay" value="YRYC022">
                                    <label for="allDay">종일</label>
                                </td>
                            </tr>
                            <tr>
                                <th>기간</th>
                                <td>
                                    <input type="date" name="yrycUseDtlsBeginDate" id="startDay" placeholder="시작 날짜"> ~
                                    <input type="date" name="yrycUseDtlsEndDate" id="endDay" placeholder="끝 날짜">
                                </td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td>
                                <textarea name="yrycUseDtlsRm" id="content" cols="30" rows="10"
                                          placeholder="내용"></textarea>
                                </td>
                            </tr>
                        </table>
                    </div>
                </form>
            </div>
            <div class="modal-footer btn-wrapper">
                <div id="beforeBtn">
                    <button type="button" class="btn btn-fill-bl-sm" id="modifyVacation">수정하기</button>
                    <button type="button" class="btn btn-fill-bl-sm" id="startSanction">결재하기</button>
                </div>
                <div id="submitBtn" style="display: none">
                    <button type="submit" class="btn btn-fill-bl-sm" id="modifySubmit" form="vacationRequestForm">저장하기
                    </button>
                    <button type="button" class="btn btn-fill-wh-sm close">취소</button>
                </div>
                <button type="button" class="btn btn-fill-wh-sm close" id="closeBtn" hidden="hidden">닫기</button>
            </div>
        </div>
    </div>

    <script src="${pageContext.request.contextPath}/resources/js/modal.js"></script>
    <script src="${pageContext.request.contextPath}/resources/js/validate.js"></script>
    <script>
        const startDateName = "yrycUseDtlsBeginDate";
        const endDateName = "yrycUseDtlsEndDate";

        setDate(startDateName)
        setDate(endDateName)
        setMinDate(startDateName)
        setMinDate(endDateName)

        const detailVacation = document.querySelector(".detailVacation");
        const detailLink = document.querySelectorAll(".detailLink");

        detailLink.forEach(link => {
            link.addEventListener("click", e => {
                const num = link.getAttribute("data-seq");
                loadDetail(num);
            })
        })

        // 결재하기 시작
        let param;
        let vacationKind;
        if (vacationKind === 'YRYC010') {
            param = 'SANCTN_FORMAT011'
        } else {
            param = 'SANCTN_FORMAT012'
        }
        $("#startSanction").on("click", function () {
            $("#modifyVacation").prop("disabled", true)
            window.open(`/sanction/format/DEPT010/\${param}`, "결재", "width = 1200, height = 1200")
        })

        function refreshParent() {
            location.reload(); // 새로고침
        }

        // 수정 후 제출
        $("#modifySubmit").on("click", function () {
            event.preventDefault();
            if (validateDate("vacationModifyForm", startDateName, endDateName) && validateEmpty("vacationModifyForm")) {
                submitAjax("vacationModifyForm");
            }
        })
        // 사용 신청 제출
        $("#requestCard").on("click", function () {
            event.preventDefault();
            if (validateDate("vacationRequestForm", startDateName, endDateName) && validateEmpty("vacationRequestForm")) {
                submitAjax("vacationRequestForm");
            }
        })

        function submitAjax(formId) {
            let formData = $("#" + formId).serialize();
            $.ajax({
                type: "POST",
                url: $("#" + formId).attr("action"),
                data: formData,
                success: function (res) {
                    alert("ajax 성공");
                    close()
                    resetModal();
                },
                error: function (error) {
                    alert("ajax 실패");
                }
            });
        }

        function loadDetail(num) {
            $.ajax({
                type: "GET",
                url: `/vacation/loadData/\${num}`,
                success: function (data) {
                    modalOpen();
                    detailVacation.classList.add("on");
                    let form = $("#vacationModifyForm");
                    vacationKind = data.commonCodeYrycUseKind;
                    for (let key in data) {
                        if (data.hasOwnProperty(key)) {
                            let value = data[key];
                            let inputElements = form.find(`input[name="\${key}"]`);
                            let textareaElement = form.find(`textarea[name="\${key}"]`);
                            let radioElements = form.find(`input[name="\${key}"][type="radio"]`);


                            if (radioElements.length) {
                                radioElements.each(function () {
                                    if ($(this).val() === value) {
                                        $(this).prop("checked", true);
                                    }
                                });
                            } else {
                                inputElements.val(value);
                            }
                            if (textareaElement.length) {
                                textareaElement.val(value);
                                textareaElement.css("border", "none");
                            }
                        }
                    }
                    if (data['commonCodeYrycState'] === 'YRYC030') {
                        $('#beforeBtn').css("display", "");
                        $('#closeBtn').prop("hidden", true);
                    } else {
                        $('#beforeBtn').css("display", "none");
                        $('#closeBtn').prop("hidden", false);
                    }

                },
                error: function (error) {
                    console.log("loadDatail 실패")
                }
            });
        }

        // 수정하기 버튼 클릭 시
        $("#modifyVacation").on("click", function () {
            let form = $("#vacationModifyForm");
            let inputElements = form.find("input, textarea");
            inputElements.each(function () {
                $(this).removeAttr("disabled");
                $(this).css("border", "");
            });
            $("#beforeBtn").css("display", "none");
            $("#submitBtn").css("display", "");
        });

        $(".close").on("click", function () {
            resetModal();
        });

        function resetModal() {
            $("#beforeBtn").css("display", "");
            $("#submitBtn").css("display", "none");
            let form = $("#vacationModifyForm");
            let inputElements = form.find("input, textarea");
            inputElements.each(function () {
                $(this).css("border", "none");
            });
        }
    </script>
</sec:authorize>