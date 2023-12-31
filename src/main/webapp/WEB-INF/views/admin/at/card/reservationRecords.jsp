<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script defer src="https://unpkg.com/ag-grid-community/dist/ag-grid-community.min.js"></script>
<div class="content-container">
    <header>
        <h1><a href="${pageContext.request.contextPath}/card/manage">회사 카드 관리</a></h1>
        <h1><a href="${pageContext.request.contextPath}/card/reservationRecords">대여 내역 관리</a></h1>
    </header>
    <main>
        <div id="reservationRecords">
            <select name="cprCardNm" onchange="onSelectFilterChanged()" id="selectFilter">
                <option value="">카드 선택</option>
                <c:forEach items="${cardName}" var="card">
                    <option value="${card}">${card}</option>
                </c:forEach>
            </select>
            <input type="text" oninput="onQuickFilterChanged()" id="quickFilter" placeholder="검색어를 입력하세요"/>
            <div id="recordGrid" class="ag-theme-alpine"></div>
        </div>
    </main>
</div>
<script>

    class ClassComp {
        init(params) {
            let data = params.node.data;
            let cprCardResveSn = data.cprCardResveSn;
            let cprCardNo = data.cprCardNo;
            let cprCardResveRturnAt = data.cprCardResveRturnAt;

            let modifyData = {
                cprCardResveSn: cprCardResveSn,
                cprCardNo: cprCardNo
            };

            this.eGui = document.createElement('div');
            let cell = this.eGui
            if (data.cprCardResveRturnAt == 0) {
                cell.innerHTML = "<button id='returnChkBtn'>반납 확인</button>";
            } else {
                cell.innerHTML = "<p>반납 완료</p>";
            }

            this.returnChkBtn = this.eGui.querySelector("#returnChkBtn");
            if (this.returnChkBtn != null) {
                this.returnChkBtn.onclick = () => {
                    $.ajax({
                        url: "/card/returnChecked",
                        type: "post",
                        data: JSON.stringify(modifyData),
                        contentType: "application/json;charset:utf-8",
                        success: function (result) {
                            cprCardResveRturnAt = 1;
                            cell.innerHTML = "<p>반납 완료</p>";
                            gridOptions.api.refreshCells();
                            alert("카드 반납 완료 처리하였습니다.");
                        },
                        error: function (xhr) {
                            alert("오류로 인한 처리 실패");
                            console.log(xhr.responseText);
                        }
                    });
                };
            }
        }

        getGui() {
            return this.eGui;
        }

        destroy() {
        }
    }


    function returnChkFnc() {

    }

    const getMedalString = function (param) {
        const str = `${param} `;
        return str;
    };
    const MedalRenderer = function (params) {
        return getMedalString(params.value);
    };

    function onQuickFilterChanged() {
        gridOptions.api.setQuickFilter(document.getElementById('quickFilter').value);
    }

    function onSelectFilterChanged() {
        gridOptions.api.setQuickFilter(document.getElementById('selectFilter').value);
    }

    function refreshRow(rowNode, api) {
        var millis = frame++ * 100;
        var rowNodes = [rowNode];
        var params = {
            force: isForceRefreshSelected(),
            suppressFlash: isSuppressFlashSelected(),
            rowNodes: rowNodes,
        };
        callRefreshAfterMillis(params, millis, api);
    }

    const columnDefs = [
        {
            headerName: "순번",
            valueGetter: "node.rowIndex + 1",
        },
        {
            field: "cprCardResveSn", headerName: "예약 순번", hide: true, getQuickFilterText: (params) => {
                return getMedalString(params.value);
            }
        },
        {field: "cprCardNo", headerName: "대여 카드 번호", hide: true},
        {field: "cprCardNm", headerName: "대여 카드"},
        {field: "cprCardResveBeginDate", headerName: "사용 시작 일자"},
        {field: "cprCardResveClosDate", headerName: "사용 마감 일자"},
        {field: "cprCardUseLoca", headerName: "사용처"},
        {field: "cprCardUsePurps", headerName: "사용 목적"},
        {field: "cprCardUseExpectAmount", headerName: "사용 예상 금액"},
        {field: "cprCardResveEmplIdAndName", headerName: "사원명(사번)"},
        {field: "cprCardResveRturnAt", headerName: "반납 여부", hide: true},
        {field: "cardReturnChk", headerName: "카드 반납", cellRenderer: ClassComp},
    ];

    const rowData = [];
    <c:forEach items="${records}" var="resve">
    <fmt:formatDate var= "cprCardResveBeginDate" value="${resve.cprCardResveBeginDate}" type="date" pattern="yyyy-MM-dd" />
    <fmt:formatDate var= "cprCardResveClosDate" value="${resve.cprCardResveClosDate}" type="date" pattern="yyyy-MM-dd" />
    <fmt:formatNumber var= "cprCardUseExpectAmount" value="${resve.cprCardUseExpectAmount}" type="number" maxFractionDigits="3" />
    rowData.push({
        cprCardResveSn: "${resve.cprCardResveSn}",
        cprCardNo: "${resve.cprCardNo}",
        cprCardNm: "${resve.cprCardNm}",
        cprCardResveBeginDate: "${cprCardResveBeginDate}",
        cprCardResveClosDate: "${cprCardResveClosDate}",
        cprCardUseLoca: "${resve.cprCardUseLoca}",
        cprCardUsePurps: "${resve.cprCardUsePurps}",
        cprCardUseExpectAmount: "${cprCardUseExpectAmount}원",
        cprCardResveEmplIdAndName: "${resve.cprCardResveEmplNm}(${resve.cprCardResveEmplId})",
        cprCardResveRturnAt: "${resve.cprCardResveRturnAt}"
    })
    </c:forEach>

    const gridOptions = {
        columnDefs: columnDefs,
        rowData: rowData
    };

    document.addEventListener('DOMContentLoaded', () => {
        const gridDiv = document.querySelector('#recordGrid');
        new agGrid.Grid(gridDiv, gridOptions);

    });
</script>