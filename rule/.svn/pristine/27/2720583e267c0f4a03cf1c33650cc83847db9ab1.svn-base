define(["jquery", "viewer", "fetch", "config"], function() {
    var typeId = $('#typeId').val();
    var comId = $('#comId').val();
    //文件下载
    $(".addBox").on('click', '.isfile', function() {
        var url = $(this).prev().attr('href');
        var test = window.open(url);
    })
    $(".addBox").on('click', '.icon-xiazai', function() {
        var url = $(this).prev().attr('href');
        var $eleForm = $("<form method='get'></form>");
        $eleForm.attr("action", url);
        $(document.body).append($eleForm);
        //提交表单，实现下载
        $eleForm.submit();
    })
    //图片预览
    $(".addBox").on('click', '.ispic', function() {
        var src = $(this).prev().attr('href');
        $('#pic').attr('src', src);
        $('#pic').attr('alt', $(this).prev().text());
        //清空div中的图片
        $("#imgWin").empty();
        //退出预览
        $("#imgWin").viewer('destroy');
        $("#image").viewer({
            shown: function() {
                $("#image").viewer('view', 0);
            }
        });
        $("#image").viewer('show');
    })
    //关闭详情弹框
    $(".offBtn,.comfireClose").on('click', function() {
        $('.table-body').css("overflow","hidden");
        $(".keepOutBox").hide();
        $(".addBox").hide();
    })
    $(".closebox,.okBtn").on('click', function() {
        var isShow = $(".addBox").css('display') == "block" ? true : false;
        if(!isShow) {
            $(".keepOutBox").hide();
        }
        $(".comfirmBox").hide();
    })

    //手动改变页数
    $(".nowPage").bind("input propertychange", function() {
        var thisIndex = Number($(this).val());
        var allCount = Number($(".pageYeshu").text());
        if (thisIndex > allCount) {
            $(this).val(allCount);
        } else if (thisIndex < 1) {
            $(this).val(1);
        }
    })
    //搜索
    $(".buttonGroup").delegate(".searchBtn", "click", function() {
        var workOrder = $('#workOrder').val(),
            startTime = $('#inpstart').val(),
            // formType = $('#typeSelect').val(),
            formType = "",
            endTime = $('#inpend').val();
        fetch.getList(typeId, 1, workOrder, startTime, endTime, formType)
    })
    //查看详情
    $(".content").delegate(".getDetail", "click", function() {
        $(".baseInfo table").html("");
        $('.process-info table').html("");
        $('.respond-info table').html("");
        $('.respond-info .table-head').show();
        var str = "";
        str += "<tr><td>工单编号</td><td>" + $(this).parents("tr").find("td").eq(1).text() + "</td></tr>"
        str += "<tr><td>工单类型</td><td>" + $(this).parents("tr").find("td").eq(2).text() + "</td></tr>"
        str += "<tr><td>工单主题</td><td>" + $(this).parents("tr").find("td").eq(3).text() + "</td></tr>"
        str += "<tr><td>工单状态</td><td>" + $(this).parents("tr").find("td").eq(5).text() + "</td></tr>"

        var formid = $(this).parents("tr").find("td").eq(1).attr("data-formid");
        var workid = $(this).parents("tr").find("td").eq(0).attr("data-workid");
        $(".addBox").show();
        $(".keepOutBox").show();
        localStorage.setItem("workid",workid);
        fetch.getDetail(formid, workid, typeId, str);
        fetch.getProcess(workid, typeId);
        fetch.getReplyInfo(workid);
    })
    $(window).resize(function() {
        $("body").css("height", $(window).height());
    })
    //工单导出
    $(".downloadBtn").click(function() {
        var starttime = $("#inpstart").val();
        var endtime = $("#inpend").val();
        var status = typeId == 2 ? 1 : 2;
        if (starttime != "" && endtime != "") {
            fetch.exportOrder(starttime, endtime, status, "");
        } else {
            $('.comfirmBox .comfirmContent').css('text-align', 'center').text('请选择报表导出起止时间段！');
            $(".keepOutBox").show();
            $('.comfirmBox').show();
        }
    })

})