<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link rel="stylesheet" href="/resources/css/common.css">
<link rel="stylesheet" href="/resources/css/commonStyle.css">

<style>
    h1 {
        text-align: center;
    }

    .dtsmtDate, .sign {
        text-align: right;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        border: 2px solid navy;
    }

    #display {
        display: flex;
    }

    th {
        background: var(--color-bg-sky);
        color: black;
    }

    th, td {
        height: 45px
    }

    .leftTable {
        border-left: none;
    }

    .borderCenter {
        border-right: 2px solid navy;
    }

    .fitSize {
        width: 150px;
    }

    .thanks {
        text-align: center;
    }

    .lastThing {
        border-bottom: 2px solid white;
        border-left: 2px solid white;
        border-top: 2px solid navy;
    }

    .pMargin {
        margin-top: 50px;
        margin-bottom: 20px;
    }

</style>
<h1>\${result.month}월 그루비 급여명세서</h1>
<p class="dtsmtDate pMargin">지급일: \${formattedDate}</p>
<table border="1">
    <tr>
        <th class="fitSize">사번</th>
        <td class="borderCenter">\${result.salaryEmplId}</td>
        <th class="fitSize">성명</th>
        <td>\${result.salaryEmplNm}</td>
    </tr>
    <tr>
        <th class="fitSize">소속</th>
        <td class="borderCenter">\${result.deptNm}팀</td>
        <th class="fitSize">직급</th>
        <td>\${result.clsfNm}</td>
    </tr>
</table>
<p class="pMargin">급여내역</p>
<div id="display">
    <table border="1" class="rightTable">
        <tr>
            <th colspan="2">지급 내역</th>
        </tr>
        <tr>
            <th class="fitSize">기본급</th>
            <td>\${formattedBslry}원</td>
        </tr>
        <tr>
            <th class="fitSize">초과근무수당</th>
            <td>\${formattedOvtimeAllwnc}원</td>
        </tr>
        <tr>
            <th class="fitSize"></th>
            <td></td>
        </tr>
        <tr>
            <th class="fitSize"></th>
            <td></td>
        </tr>
        <tr>
            <th class="fitSize"></th>
            <td></td>
        </tr>
        <tr>
            <th class="fitSize"></th>
            <td></td>
        </tr>
        <tr>
            <th class="fitSize">총지급액</th>
            <td>\${formattedPymntTotamt}원</td>
        </tr>
        <tr class="lastThing">
        </tr>
    </table>
    <table border="1" class="leftTable">
        <tr>
            <th colspan="2">공제 내역</th>
        </tr>
        <tr>
            <th class="fitSize">국민연금</th>
            <td>\${formattedSisNp}원</td>
        </tr>
        <tr>
            <th class="fitSize">건강보험</th>
            <td>\${formattedSisHi}원</td>
        </tr>
        <tr>
            <th class="fitSize">고용보험</th>
            <td>\${formattedSisEi}원</td>
        </tr>
        <tr>
            <th class="fitSize">산재보험</th>
            <td>\${formattedSisWci}원</td>
        </tr>
        <tr>
            <th class="fitSize">소득세</th>
            <td>\${formattedIncmtax}원</td>
        </tr>
        <tr>
            <th class="fitSize">지방소득세</th>
            <td>\${formattedLocalityIncmtax}원</td>
        </tr>
        <tr>
            <th class="fitSize">총공제액</th>
            <td>\${formattedDdcTotamt}원</td>
        </tr>
        <tr>
            <th class="fitSize">실수령액</th>
            <td>\${formattedNetPay}원</td>
        </tr>
    </table>
</div>
<p class="thanks pMargin">\${result.salaryEmplNm}님의 노고에 감사드립니다</p>
<p class="sign">그루비 (인)</p>