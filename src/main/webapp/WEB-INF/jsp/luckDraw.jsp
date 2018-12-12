<%--
  Created by IntelliJ IDEA.
  User: wuhanxue5@sina.com
  Date: 2018/12/5
  Time: 13:55
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>佳利达抽奖系统</title>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <script type="text/javascript" src="../../js/jquery.min.js"></script>
    <link href="../../css/bootstrap/3.3.6/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../../css/style.css">
    <script src="../../js/bootstrap/3.3.6/bootstrap.min.js"></script>
    <script type="text/javascript" src="../../js/webJs/luckDraw.js"></script>
    <style>
        body {
            font-size: 20px;
        }
    </style>
</head>
<body onload="loadNumber()">
<div class='luck-back'><!--背景图-->
    <div class="luck-content ce-pack-end"><!--透明框-->
            <table id="table" style="width: 80%;height: 450px;border: 0;" align="center">
                <tr id="class1">
                    <!--几等奖，动态-->
                    <td class="text-center" colspan="4"><p style="font-size: 80px;color: #ff3f4b"><span
                            id="prize">一等奖</span>
                    </p></td>
                </tr>
            </table>
        <%--提示面板--%>
        <div class="panel panel-default" id="newPanel" hidden>
            <div class="panel-body">
                <span id="message" class="text-center"></span>
            </div>
            <div class="panel-footer">
                <button type="button" class="btn btn-danger" onclick="closed()">
                    关闭
                </button>
            </div>
        </div>
        <div class="text-center">
            <a class="btn btn-success" id="begin" style="width: 100px;height: 55px;font-size: 30px"
               onclick="beginRndNum(this)">开始</a>
            <a class="btn btn-danger" id="list" onclick="save();"
               style="display:none;width: 100px;height: 55px;font-size: 30px">名单</a>
        </div>
    </div>
</div>
</body>
<script>

    /**
     * 根据抽奖人数加载抽奖框
     */
    function loadNumber() {
        list = [];  // 清零
        tableList = [];
        listWinner = [];
        <c:forEach items="${seatList}" var="a">
        var tableId = ${a.tableId};
        var locationId = ${a.locationId};
        list.push([tableId, locationId]);
        var add1 = false;
        for (k1 in tableList) {  //检查桌号LIST中是否存在该桌号
            if (tableList[k1][0] === ${a.tableId}) {
                add1 = true;
                break;
            }
        }
        if (!add1) {  // 如果不存在添加
            tableList.push([${a.tableId}, parseInt(localStorage.everyTableNumber)]);
        }
        </c:forEach>
        console.log("tableList");
        console.log(tableList);
        if (localStorage.prizeMode === "true") { // 随机抽奖
            console.log("抽奖人数：");
            console.log(localStorage.winnerNumber);
            winnerNumber = localStorage.winnerNumber;  // 获取抽奖人数
            $("#prize").text(localStorage.prizeLevel + "：" + localStorage.prizeName); // 设置奖品等级和名称
            add = false;  // 将新增状态设置为未新增
            // 获取所有参与抽奖的员工数据
            if (list.length === 0) {
                $("#message").text("请重置中奖人！");
                $('#newPanel').show(1000);
                setTimeout(function () {  // 三秒后自动跳转至抽奖设置页面
                    window.location.href = "luckDrawSetting";
                }, 3000);
            } else if (winnerNumber > list.length) { // 当抽奖人数大于参加人数时自动赋值为参加人数
                $("#message").text("中奖人数大于参加人数");
                $('#newPanel').show(1000);
                winnerNumber = list.length;
            }
            $("#class1").nextAll().remove();  // 删除旧数据
            for (var i = 0; i < winnerNumber; i++) { // 根据中奖人数插入抽奖框
                if (i % 2 === 0) {
                    var tr = "<tr >\n" +
                        "</tr>";
                    $("#table").append(tr);
                }
                var td = "<td class=\"text-center\">\n" +
                    "<div class=\"slot\"><span style='font-size: 25px;margin-right: 15px'>桌号：</span><span title=\"\" id='tableId" + i + "' style='display: inline-block;margin: 0;width: 45px;font-size: 25px'>--</span>\n" +
                    "<span style='font-size: 25px;margin-left: 15px'>座号：</span><span title=\"\" id='locationId" + i + "' style='display: inline-block;margin: 0;width: 45px;font-size: 25px'>--</span>\n" +
                    "</div></td>";
                $("#table").find("tr:last").append(td);   // 将td 插入到最新的tr中
                $("#list").text("名单");
            }
        } else {  //按桌抽奖
            var k = 0;
            for (var i = 0; i < localStorage.tableNumber; i++) {// 抽取桌数
                for (var j = 0; j < localStorage.everyTableNumber; j++) { // 每桌抽取人数
                    if (k % 2 === 0) {
                        var tr = "<tr>\n" +
                            "</tr>";
                        $("#table").append(tr);
                    }
                    var td = "<td class=\"text-center\">\n" +
                        "<span style='font-size: 25px;margin-right: 15px'>桌号：</span><span title=\"\" id='tableId" + k + "' style='display: inline-block;margin: 0;width: 45px;font-size: 25px'>--</span>\n" +
                        "<span style='font-size: 25px;margin-left: 15px'>座号：</span><span title=\"\" id='locationId" + k + "' style='display: inline-block;margin: 0;width: 45px;font-size: 25px'>--</span>\n" +
                        "</td>";
                    $("#table").find("tr:last").append(td);   // 将td 插入到最新的tr中
                    k++;
                }
            }
        }
    }
</script>
</html>

