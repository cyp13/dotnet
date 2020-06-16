define(["jquery", "util", "config", "operate", "ajax"], function() {
    var token = $('#token').val();
    var app = navigator.appName;
    jQuery.support.cors = true;
    //列表数据
    function refresh(type, pageIndex, workOrder, startTime, endTime, formType) { //typeId,index,workOrder,startTime,endTime
        var option = {
            url: request.baseUrl + request.worklist,
            type: "get",
            data: {
                type: type,
                from: request.from,
                pageIndex: pageIndex,
                pageSize: request.pageSize,
                serialNumber: workOrder || "",
                startDate: startTime || "",
                endDate: endTime || "",
                formType: formType || ""
            },
            headers: {
                token: token
            },
            dataType: "json",
            successCb: function(result) {
                $(".content table").html("");
                if (result.Success) {
                    var resultData = result.Data;
                    var allCount = parseInt(resultData.TotalCount);
                    $(".pageTotal").text(allCount);
                    if (allCount % request.pageSize == 0) {
                        var pageCount = allCount / request.pageSize;
                    } else {
                        var pageCount = parseInt(allCount / request.pageSize) + 1;
                    }
                    $(".pageYeshu").text(pageCount);
                    $(".pageOpBox .nowPage").val(pageIndex);
                    if (allCount > 0) {
                        resultData = result.Data.Tasks;
                        var resultLength = resultData.length;
                        var html = "<tr><th>序号</th><th>工单编号</th><th>工单类型</th><th>工单主题</th><th>业务类型</th><th>发布时间</th><th>工单状态</th><th>操作</th></tr>";
                        for (var i = 0; i < resultLength; i++) {
                            var status = util.getStatus(resultData[i].RunStatus);
                            var createTime = util.formatTime(resultData[i].CreateDate);
                            var bizTypeName = resultData[i].BizTypeName || "无"
                            html += '<tr><td data-workid="' + resultData[i].WorkOrderID + '">' + (request.pageSize * (pageIndex - 1) + (i + 1)) + '</td><td data-formid="' + resultData[i].FormID + '">' + resultData[i].SerialNumber + '</td><td>' + resultData[i].FormName + '</td><td>' + resultData[i].Subject + '</td><td>' + bizTypeName + '</td><td>' + createTime + '</td><td>' + resultData[i].StatusDesc + '</td><td><a class="getDetail" href="javascript:void(0)">查看</a></td></tr>';
                        };
                        $(".content table").append(html);
                        operate.backgroudColor($('.content'));
                    } else {
                        $(".content table").append('<p >没有数据！</p>');
                    }
                } else {
                    $(".pageTotal").text(0);
                    $(".pageYeshu").text(0);
                    $(".pageOpBox .nowPage").val(0);
                    $(".content table").append('<p style="color:red">' + result.Msg + '</p>');
                }
            },
            errorCb: function(err) {
                $(".content table").html('').append('<p style="color:red">获取列表数据失败请刷新重试!</p>');
            },
            completeCb: function() {
                console.log("complete");
            }
        };
        req.requst(option);
    }
    //获取详情
    function getDetail(formid, workid, typeId, nodes) {
        var _url = typeId == 2 ? request.detailProcess : request.detailGD;
        var option = {
            url: request.baseUrl + _url,
            type: "get",
            data: {
                formId: formid,
                workOrderId: workid
            },
            headers: {
                token: token
            },
            dataType: "json",
            successCb: function(result) {
                if (result.Success) {
                    var str = "",
                        str1 = "",
                        str2 = "";
                    result = result.Data;
                    $(".addErrorMsg").text("");
                    var formData = result.FormFields;
                    var replyInfo = result.ReplyInfo;
                    var formDataLength = formData.length;
                    for (var i = 0; i < formDataLength; i++) {
                        if (formData[i].TagKey === 8) {
                            var value = formData[i].FiledValue;
                            str1 = operate.getFj(value);
                        } else {
                            str += '<tr><td>' + formData[i].FieldName + '</td><td>' + formData[i].FiledValue + '</td></tr>';
                        }
                    }
                    if (!str1) str1 = "无";
                    str += '<tr><td>附件</td><td>' + str1 + '</td></tr>';
                    $(".baseInfo table").append(nodes);
                    $(".baseInfo table").append(str);
                    operate.backgroudColor($('.baseInfo'));
	       			if(typeId == 2 && $('.collect-file-btn').length === 0){
	       				$('.addFoot').append('<button type="button" class="collect-file-btn">归档</button>')
	       			}
                } else {
                    var tip = "<h5 style='color:red'>"+ resullt.Msg +"</h5>"
                    $(".baseInfo table").append(tip);
                }
            },
            errorCb: function() {
                var tip = "<h5 style='color:red'>获取详情数据失败</h5>"
                $(".baseInfo table").append(tip);
            },
            completeCb: function() {
                console.log("complete");
            }
        };
        req.requst(option);
    }
    //获取流程信息详情
    function getProcess(workid, typeId) {
        var option = {
            url: request.baseUrl + request.processInfo,
            type: "get",
            data: {
                workOrderId: workid
            },
            headers: {
                token: token
            },
            dataType: "json",
            successCb: function(result) {
                if (result.Success) {
                    data = result.Data;
                    var html = [];
                    if (data.length > 0) {
                        html.push("<tr style='background-color:#f2f2f2;'><th>序号</th><th>接受人</th><th>接受时间</th><th>操作状态</th></tr>");
                        $.each(data, function(index, item) {
                            var str = "<tr><td>" + (index + 1) + "</td><td>" + item.ReceiverName + "</td><td>" + util.formatTime(item.ReceiveDate) + "</td><td>" + item.StatusDesc + "</td></tr>"
                            html.push(str)
                        })
                        $('.process-info table').append(html.join(''));
                        operate.backgroudColor($('.process-info'));
                    } else {
                        $('.process-info table').append("<p style='color:red'>没有相关流程信息数据！</p>");
                    }
                } else {
                    $('.process-info table').append("<p style='color:red'>" + result.Msg + "</p>");
                }
            },
            errorCb: function(err) {
                $('.process-info table').append("<p style='color:red'>获取流程数据信息失败！</p>");
            },
            completeCb: function() {
                console.log("complete");
            }
        };
        req.requst(option);
    }
    //获取工单类型
    function getType() {
        var option = {
            url: request.baseUrl + request.workOrderType,
            type: "get",
            headers: {
                token: token
            },
            successCb: function(result) {
                console.log(result)
                if (result.Success) {
                    var data = result.Data;
                    var resultLength = data.length;
                    var html = "";
                    for (var i = 0; i < resultLength; i++) {
                        html += "<option value=" + data[i].ID + ">" + data[i].Name + "</option>";
                    };
                    $("#typeSelect").append(html);
                } else {
                    $(".comfirmBox .addErrorMsg").text(result.Msg);
                    $(".comfirmBox").show();
                }
            },
            errorCb: function(err) {
                $(".comfirmBox .addErrorMsg").text("获取工单类型失败！");
                $(".comfirmBox").show();
            },
            completeCb: function() {
                console.log("complete");
            }
        }
        req.requst(option);
    }
    function exportOrder(starttime,endtime,status,formId) {
        var option = {
            url: request.baseUrl + request.exportOrder,
            type: "get",
            data:{
                startDate: starttime,
                endDate: endtime,
                status: status,
                formId:formId
            },
            headers: {
                token: token
            },
            successCb: function(result) {
                result = JSON.parse(result);
                if (result.Success) {
                    var data = result.Data;
                    var DownloadLink = data.DownloadLink.substring(1);
                    var url  = request.baseUrl + DownloadLink;
                    if(app.indexOf('Microsoft Internet Explorer') > -1){
                        var $eleForm = $("<form method='get'></form>");
                        $eleForm.attr("action", url);
                        $(document.body).append($eleForm);
                        //提交表单，实现下载
                        $eleForm.submit();
                    }else{
                        window.open(url,'_self');
                    }
                } else {
                    $(".comfirmBox .comfirmContent").css('text-align','center').text(result.Msg);
                    $(".keepOutBox").show();
                    $(".comfirmBox").show();
                }
            },
            errorCb: function(err) {
                $(".comfirmBox .comfirmContent").css('text-align','center').text("工单报表导出失败！");
                $(".keepOutBox").show();
                $(".comfirmBox").show();
            },
            completeCb: function() {
                console.log("complete");
            }
        }
        req.requst(option);
    }
    function submitGd(workOrderId){
        var option ={
            url: request.baseUrl + request.submitGD,
            type: "post",
            data:{
                EventKey : 4,
                FlowId   : "46ad3663-c2fc-4084-8751-6dcbaf3e962d",  
                WorkOrderId : workOrderId,
                IsAdmin  :true
            },
            headers: {
                token: token
            },
            successCb: function(result) {
                result = JSON.parse(result);
                if (result.Success) {
                   window.location.reload();
                } else {
                    $(".comfirmBox .comfirmContent").css('text-align','center').text(result.Msg);
                    $(".keepOutBox").show();
                    $(".comfirmBox").show();
                }
            },
            errorCb: function(err) {
                $(".comfirmBox .comfirmContent").css('text-align','center').text("工单归档失败！");
                $(".keepOutBox").show();
                $(".comfirmBox").show();
            },
            completeCb: function() {
                console.log("complete");
            }
        }
        req.requst(option);
    }
    function getReplyInfo(workOrderId){
        var option ={
            url: request.huifu + request.replyInfo,
            type: "get",
            data:{
                WorkOrderId : workOrderId,
            },
            headers: {
                token: token
            },
            successCb: function(result) {
                result = JSON.parse(result);
                if (result.Success) {
                    var data = result.Data;
                    var str = "";
                    if(data.length >0){
                        for (var i = 0; i < data.length; i++) {
                            var content = data[i].Contents ? data[i].Contents : "无";
                            var fujian = data[i].Files !="" ? operate.getFj(data[i].Files) : "无";
                            var creator = data[i].CreatorName ? data[i].CreatorName : "未知";
                            str += '<tr><td>'+creator+'</td><td><div><p style="display:inline-block;text-align:left">回复文本：'+content+'</p></div><div><p style="display:inline-block;text-align:left">回复附件：'+fujian+'</p></div></td><td>'+util.formatTime(data[i].CreateDate)+'</td></tr>'
                        }
                    }else{
                        $('.respond-info .table-head').hide();
                        str += '<p style="padding-left:10px">无数据</p>';
                    }
                    $('.respond-info table').append(str);
                    var height = $(".table-body").height();
                    var height1 = $(".table-body table").height();
                    if(height1 > height){
                        $('.more').show();
                    }
                    $('.more').click(function () {
                       $(this).hide();
                       $('.table-body').css("overflow","auto");
                    })
                    operate.backgroudColor($('.respond-info'));
                } else {
                    $('.respond-info .table-head').hide();
                    $('.respond-info table').append('<p style="padding-left:10px">'+result.Msg+'</p>');;
                }
            },
            errorCb: function(err) {
                $(".comfirmBox .comfirmContent").css('text-align','center').text("获取回复信息失败！");
                $(".keepOutBox").show();
                $(".comfirmBox").show();
            },
            completeCb: function() {
                console.log("complete");
            }
        }
        req.requst(option);
    }
    return fetch = {
        getList: refresh,
        getDetail: getDetail,
        getProcess: getProcess,
        getType: getType,
        exportOrder:exportOrder,
        submitGd:submitGd,
        getReplyInfo:getReplyInfo
    }
})