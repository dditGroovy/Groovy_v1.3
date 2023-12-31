<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<sec:authentication property="principal" var="CustomUser"/>

<script src="https://cdnjs.cloudflare.com/ajax/libs/sockjs-client/1.4.0/sockjs.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/stomp.js/2.3.3/stomp.min.js"></script>
<link href="/resources/css/chat/chat.css" rel="stylesheet"/>
<div class="content-container">
    <header id="tab-header">
        <h1><a href="${pageContext.request.contextPath}/chat" class="on">채팅</a></h1>
    </header>
    <main>
        <div class="main-inner">
            <div class="card card-df chat-card">
                <section id="chat-list">
                    <div class="content-header">
                        <h2 class="main-title">채팅함</h2>
                        <button type="button" id="newBtn" class="btn create-chat btn-modal invite-chat" data-name="createRoom">채팅방 생성</button>
                    </div>
                    <div class="content-body">
                        <div id="chatRoomList">

                        </div>
                    </div>
                </section>
                <section id="chat-detail">
                    <div id="chatRoom">

                    </div>
                </section>
                <%--<button type="button" id="cancelBtn">취소</button>--%>
            </div>

    </div>
    </main>
</div>
<div id="modal" class="modal-dim">
    <div class="dim-bg"></div>
    <div class="modal-layer card-df sm createRoom">
        <div class="modal-top">
            <h3 class="modal-title"><i class="icon i-user i-3d"></i>대화상대 선택</h3>
            <button type="button" class="modal-close btn js-modal-close">
                <i class="icon i-close close">X</i>
            </button>
        </div>
        <div class="modal-container">
            <ul id="employeeList">

            </ul>
            <div for="receive" style="width: 100%">
                <div class="receive input-l modal-input">
                </div>
            </div>
        </div>
        <div class="modal-footer btn-wrapper">
            <button class="btn btn-fill-wh-sm close">취소</button>
            <button id="createRoomBtn" class="btn btn-fill-bl-sm">확인</button>
            <button id="inviteEmplBtn" class="btn btn-fill-bl-sm" style="display:none;">확인</button>
        </div>
    </div>
</div>
<script src="/resources/js/modal.js"></script>
<script>

    const emplId = ${CustomUser.employeeVO.emplId};
    const emplNm = "${CustomUser.employeeVO.emplNm}";
    const msg = $("#msg");
    const chatRoomMessages = {};
    const subscribedRooms = new Set();

    let sockJS = new SockJS("/chat");
    let client = Stomp.over(sockJS);

    let currentRoomNo;
    let currentRoomNm;

    let emplsToInvite = []
    let chttRoomMem = []

    function connectToStomp() {
        return new Promise(function (res, rej) {
            client.connect({}, function () {
                res();
            });
        });
    }

    connectToStomp().then(function () {
        $("#chatRoom").on("keyup", "#msg",function (event) {
            console.log($("#msg").val())
            if (event.keyCode === 13) {
                sendMessage();
            }
        });

        $("#chatRoom").on("click",".btn", function () {
            sendMessage();
        });

        function sendMessage() {
            const msg = $("#msg");
            let message = msg.val();
            let date = new Date();

            if (message.length == 0) return;

            let chatVO = {
                chttNo: 0,
                chttRoomNo: currentRoomNo,
                chttMbrEmplId: emplId,
                chttMbrEmplNm: emplNm,
                chttCn: message,
                chttInputDate: date,
                proflPhotoFileStreNm : "${CustomUser.employeeVO.proflPhotoFileStreNm}"
            }

            client.send('/public/chat/message', {}, JSON.stringify(chatVO));
            console.log("chatVO", chatVO);
            $.ajax({
                url: "/chat/inputMessage",
                type: "post",
                data: JSON.stringify(chatVO),
                contentType: "application/json;charset:utf-8",
                success: function (result) {
                },
                error: function (request, status, error) {
                    alert("채팅 전송 실패")
                }
            })
            msg.val('');
        }

        function enterRoom(currentRoomNo, currentRoomNm) {
            emplsToInvite = [];
            chttRoomMem = [];
            $("input[type='checkbox'][name='employees']").prop("disabled", false).prop("checked", false);
            $("#inviteEmplBtn").hide();
            $("#createRoomBtn").show();
            $("#chatRoom").html("");
            $("#chatRoom").append(`
                <div id="msgArea">
                            <div class="content-header">
                                <h3 class="chat-user-info">\${currentRoomNm}</h3>
                                <button type="button" id="inviteBtn" class="btn invite-chat btn-modal" data-name="inviteEmpl">채팅방 초대</button>
                            </div>
                <div class="content-body">
                <div class="myroom" id="room\${currentRoomNo}"></div>
                </div>
                <div class="content-footer btn-free-white">
                                                <input type="text" id="msg">
                                                <button type="button" id="sendBtn" class="btn">전송</button>
                                            </div>
            `)

            $.ajax({
                url: `/chat/loadRoomMessages/\${currentRoomNo}`,
                type: "get",
                dataType: "json",
                success: function (messages) {
                    $.each(messages, function (idx, obj) {
                        if (obj.chttMbrEmplId == emplId) {
                            let code = `
                                        <div id="\${obj.chttNo}" class="me chat-user">
                                            <img src="/uploads/profile/\${obj.proflPhotoFileStreNm}" class="thum" />
                                            <p class="chat-msg card-df">\${obj.chttCn}</p>
                                        </div>
                        </div>`;
                            $(`#room\${currentRoomNo}`).append(code);
                        } else {
                            let code = `<div id="\${obj.chttNo}" class="other chat-user">
                                            <img src="/uploads/profile/\${obj.proflPhotoFileStreNm}" class="thum" />
                                            <p class="chat-msg card-df">\${obj.chttCn}</p>
                                        </div>
                        </div>`;
                            $(`#room\${currentRoomNo}`).append(code);
                        }
                       /* scrollToBottom();*/
                    });
                },
                error: function (request, status, error) {
                    alert("채팅 로드 실패")
                }
            })

            $.ajax({
                url: `/chat/loadRoomMembers/\${currentRoomNo}`,
                type: "get",
                success: function (members) {
                    $.each(members, function (idx, obj) {
                        chttRoomMem.push(obj);
                    })
                },
                error: function (request, status, error) {
                    alert("채팅방 멤버 로드 실패")
                }
            })

            msg.val('');

        }
        $("#newBtn").on("click",function(){
            $("#createRoomBtn").show();
            $("#inviteEmplBtn").hide();
        });
        $("#chatRoom").on("click", "#inviteBtn",function () {
            modalOpen("createRoom");
            $("#createRoomBtn").hide();
            $("#inviteEmplBtn").show();
        })

        $("#inviteEmplBtn").on("click", function () {
            let selectedEmplIds = [];
            $("input[name='employees']:checked").each(function () {
                let employees = $(this).val();
                let splitResult = employees.split("/");
                if (splitResult.length === 2) {
                    let emplId = splitResult[0];
                    emplsToInvite.push(emplId);
                    selectedEmplIds.push(emplId);
                }
            });

            let newMem = {
                chttRoomNo: currentRoomNo,
                chttRoomNm: currentRoomNm,
                employees: emplsToInvite
            }

            if (emplsToInvite.length > 0) {
                $.ajax({
                    url: "/chat/inviteEmpls",
                    type: "post",
                    data: JSON.stringify(newMem),
                    contentType: "application/json;charset:utf-8",
                    success: function (result) {
                        if (result == 1) {
                            //알림 보내기
                            $.get("/alarm/getMaxAlarm")
                                .then(function (maxNum) {
                                    maxNum = parseInt(maxNum) + 1;
                                    let url = '/chat';
                                    let content = `<div class="alarmBox">
                                        <a href="\${url}" class="aTag" data-seq="\${maxNum}">
                                            <h1>[채팅]</h1>
                                            <p>\${emplNm}님이 채팅방에 초대하셨습니댜.</p>
                                        </a>
                                        <button type="button" class="readBtn">읽음</button>
                                    </div>`;
                                    let alarmVO = {
                                        "ntcnSn": maxNum,
                                        "ntcnUrl": url,
                                        "ntcnCn": content,
                                        "commonCodeNtcnKind": 'NTCN015',
                                        "selectedEmplIds": selectedEmplIds
                                    };

                                    //알림 생성 및 페이지 이동
                                    $.ajax({
                                        type: 'post',
                                        url: '/alarm/insertAlarmTargeList',
                                        data: alarmVO,
                                        success: function (rslt) {
                                            if (socket) {
                                                //알람번호,카테고리,url,보낸사람이름,받는사람아이디리스트
                                                let msg = `\${maxNum},chat,\${url},\${emplNm},\${selectedEmplIds}`;
                                                socket.send(msg);
                                            }
                                            loadRoomList();
                                            alert("초대 성공");
                                        },
                                        error: function (xhr) {
                                            console.log(xhr.status);
                                        }
                                    });
                                })
                                .catch(function (error) {
                                    console.log("최대 알람 번호 가져오기 오류:", error);
                                });
                        } else {
                            alert("초대 실패")
                        }
                    },
                    error: function (request, status, error) {
                        alert("오류로 인한 초대 실패")
                    }
                });
                $("input[name='employees']:checked").prop("checked", false);
            } else {
                alert("초대할 사원을 선택해주세요.")
            }
        });

        function scrollToBottom() {
            const scrollRoom = document.getElementById("room" + currentRoomNo);
            scrollRoom.scrollTop = scrollRoom.scrollHeight;
        }

        $("#chatRoomList").on("click", ".rooms", function () {

            let selectedRoom = $(this);
            let chttRoomNo = selectedRoom.find(".chttRoomNo").val();
            let chttRoomTy = selectedRoom.find(".chttRoomTy").val();
            let chttRoomNm = selectedRoom.find(".chttRoomNm").text();

            currentRoomNo = chttRoomNo;
            currentRoomNm = chttRoomNm;
            enterRoom(currentRoomNo, currentRoomNm);

        });

        function subscribeToChatRoom(chttRoomNo) {
            if(!subscribedRooms.has(chttRoomNo)) {
                client.subscribe("/subscribe/chat/room/" + chttRoomNo, function (chat) {
                    let content = JSON.parse(chat.body);

                    let chttRoomNo = content.chttRoomNo;
                    let chttMbrEmplId = content.chttMbrEmplId;
                    let chttMbrEmplNm = content.chttMbrEmplNm;
                    let chttCn = content.chttCn;
                    let chttInputDate = content.chttInputDate;
                    let proflPhotoFileStreNm = content.proflPhotoFileStreNm;

                    if (chttMbrEmplId == emplId) {
                        let code = `
                            <div class="me chat-user">
                                            <img src="/uploads/profile/\${proflPhotoFileStreNm}" class="thum" />
                                            <p class="chat-msg card-df">\${chttCn}</p>
                                        </div>`;
                        $(`#room\${chttRoomNo}`).append(code);
                        scrollToBottom();
                    } else {
                        let code = `<div class="other chat-user">
                                            <img src="/uploads/profile/\${proflPhotoFileStreNm}" class="thum" />
                                            <p class="chat-msg card-df">\${chttCn}</p>
                                        </div>`;
                        $(`#room\${chttRoomNo}`).append(code);
                        scrollToBottom();
                    }

                    updateLatestChttCn(chttRoomNo, chttCn, chttInputDate);
                    updateChatRoomList(chttRoomNo, chttCn);
                });
                subscribedRooms.add(chttRoomNo);
            }
        }

        function updateLatestChttCn(chttRoomNo, chttCn, chttInputDate) {
            for (let i = 0; i < chatRoomList.length; i++) {
                if (chatRoomList[i].chttRoomNo === chttRoomNo) {
                    chatRoomList[i].latestChttCn = chttCn;
                    chatRoomList[i].latestInputDate = chttInputDate;
                    break;
                }
            }
            renderChatRoomList();
        }

        function updateChatRoomList(chttRoomNo, latestChttCn) {
            let chatRoom = $("#chatRoomList" + chttRoomNo);
            chatRoom.find("#latestChttCn").text(latestChttCn);
        }
            let groupedEmployees = {};
            let deptNm
            <c:forEach items="${emplListForChat}" var="employee">
            deptNm = "${employee.deptNm}";
            if (!groupedEmployees[deptNm]) {
                groupedEmployees[deptNm] = [];
            }
            groupedEmployees[deptNm].push({
                emplId: "${employee.emplId}",
                emplNm: "${employee.emplNm}",
                clsfNm: "${employee.clsfNm}"
                proflPhotoFileStreNm: "${employee.proflPhotoFileStreNm}"
            });
            </c:forEach>

            let ul = $("#employeeList");
            for (let deptNm in groupedEmployees) {
                let li = $("<li class='department'>");
                let a = $("<a href='#'>").text(deptNm);
                li.append(a);
                ul.append(li);

                let ulSub = $("<ul>");
                groupedEmployees[deptNm].forEach(function (employee) {
                    let liSub = $("<li>");
                    let label = $("<label>");
                    let img = $(`<img src="/uploads/profile/\${employee.proflPhotoFileStreNm}" class="thum">`)
                    let input = $("<input>").attr({
                        type: "checkbox",
                        name: "employees",
                        value: employee.emplId + "/" + employee.emplNm
                    });
                    label.append(input);
                    label.append(img);
                    label.append(document.createTextNode(employee.emplNm + " " + employee.clsfNm));
                    liSub.append(label);
                    ulSub.append(liSub);
                });
                li.append(ulSub);
            }
        $("#createRoomBtn").click(function () {
            let roomMemList = [];
            let selectedEmplIds = [];

            $("input[name='employees']:checked").each(function () {
                let employees = $(this).val()
                let splitResult = employees.split("/");

                if (splitResult.length === 2) {
                    let emplId = splitResult[0];
                    let emplNm = splitResult[1];
                    selectedEmplIds.push(emplId);
                    let EmployeeVO = {
                        emplId: emplId,
                        emplNm: emplNm
                    };

                    roomMemList.push(EmployeeVO);
                }
            });

            if(roomMemList.length > 0) {
                $.ajax({
                    url: "/chat/createRoom",
                    type: "post",
                    data: JSON.stringify(roomMemList),
                    contentType: "application/json;charset:utf-8",
                    success: function (result) {
                        if (result == 1) {
                            //알림 보내기
                            $.get("/alarm/getMaxAlarm")
                                .then(function (maxNum) {
                                    maxNum = parseInt(maxNum) + 1;
                                    let url = '/chat';
                                    let content = `<div class="alarmBox">
                                        <a href="\${url}" class="aTag" data-seq="\${maxNum}">
                                            <h1>[채팅]</h1>
                                            <p>\${emplNm}님이 채팅방에 초대하셨습니댜.</p>
                                        </a>
                                        <button type="button" class="readBtn">읽음</button>
                                    </div>`;
                                    let alarmVO = {
                                        "ntcnSn": maxNum,
                                        "ntcnUrl": url,
                                        "ntcnCn": content,
                                        "commonCodeNtcnKind": 'NTCN015',
                                        "selectedEmplIds": selectedEmplIds
                                    };

                                    //알림 생성 및 페이지 이동
                                    $.ajax({
                                        type: 'post',
                                        url: '/alarm/insertAlarmTargeList',
                                        data: alarmVO,
                                        success: function (rslt) {
                                            if (socket) {
                                                //알람번호,카테고리,url,보낸사람이름,받는사람아이디리스트
                                                let msg = `\${maxNum},chat,\${url},\${emplNm},\${selectedEmplIds}`;
                                                socket.send(msg);
                                            }
                                            loadRoomList();
                                            alert("채팅방 개설 성공");
                                            modalClose();
                                        },
                                        error: function (xhr) {
                                            console.log(xhr.status);
                                        }
                                    });
                                })
                                .catch(function (error) {
                                    console.log("최대 알람 번호 가져오기 오류:", error);
                                });
                        } else {
                            alert("이미 존재하는 1:1 채팅방입니다")
                        }
                    },
                    error: function (request, status, error) {
                        alert("채팅방 개설 실패")
                    }
                });

                $("input[name='employees']:checked").prop("checked", false);
            } else {
                alert("채팅방 개설을 위한 최소 인원 미달")
            }

        });

        loadRoomList();

        function loadRoomList() {
            $.ajax({
                url: "/chat/loadRooms",
                type: "get",
                dataType: "json",
                success: function (result) {
                    result.sort((a, b) => b.latestInputDate - a.latestInputDate);

                    chatRoomList = result;

                    for (let i = 0; i < chatRoomList.length; i++) {
                        let chttRoomNo = chatRoomList[i].chttRoomNo;
                        subscribeToChatRoom(chttRoomNo);
                    }
                    renderChatRoomList();
                },
                error: function (request, status, error) {
                    alert("채팅방 목록 로드 실패")
                }
            })
        }

        let chatRoomList = [];

        function renderChatRoomList() {
            $("#chatRoomList").html('');

            chatRoomList.forEach(room => room.latestInputDate = new Date(room.latestInputDate));
            chatRoomList.sort((a, b) => b.latestInputDate - a.latestInputDate);

            code = "";
            $.each(chatRoomList, function (idx, obj) {
                code += `<button class="rooms btn" id="chatRoom\${obj.chttRoomNo}">
            <img src="/uploads/profile/\${obj.chttRoomThumbnail}" alt="\${obj.chttRoomThumbnail}" class="thum" />
            <div class="user-info">
                <p class="chttRoomNm">\${obj.chttRoomNm}</p>
                <p class="latestChttCn">\${obj.latestChttCn}</p>
            </div>
            <input class="chttRoomNo" type="hidden" value="\${obj.chttRoomNo}">
            <input class="chttRoomTy" type="hidden" value="\${obj.chttRoomTy}">
            </button>`;
            });
            $("#chatRoomList").html(code);
        }

        $("#cancelBtn").on("click", function () {
            $("input[type='checkbox'][name='employees']").prop("disabled", false).prop("checked", false);
            $("#inviteEmplBtn").hide();
            $("#createRoomBtn").show();
            emplsToInvite = [];
        });

    });

    /*  조직도 */
    const modal = $("#modal");
    modal.on("click",".department > a",function(){
        $(".department").removeClass("on");
        $(this).parent(".department").toggleClass("on");
    })
    modal.on("click","label",function(){
        const employees = $(this).find("input[type=checkbox]");
        let str = ``;
        if(employees.is(':checked')){
            const val = employees.attr("value");
            let parts = val.split("/");
            const emplId = parts[0];
            const emplNm = parts[1];

            let empl = {
                emplId,
                emplNm
            }
            str += `<span class="badge emplBadge" data-id="\${empl.emplId}"> \${empl.emplNm} <button type="button" class="close-empl btn"><i class="icon i-close"></i></button> </span>`;
            $(".receive").append(str);
        }
    })
    modal.on("click",".close-empl",function(){
        $(this).parent("span").remove();
    })
    $(".close").on("click",function(){
        $(".department").removeClass("on");
        $(".receive").html("");
    })
    /*const checkboxes = popup.document.querySelectorAll("input[name=orgCheckbox]");
    let str = ``;
    checkboxes.forEach((checkbox) => {
        if (checkbox.checked) {
            const label = checkbox.closest("label");
            const emplId = checkbox.id;
            const emplNm = label.querySelector("span").innerText;

            let empl = {
                emplId,
                emplNm
            }
            str += `<span data-id="${empl.emplId}"> ${empl.emplNm} <button type="button" class="close-empl btn">X</button> </span>`;
        }
    });*/
</script>