<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="page" />

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Cache-Control" content="no-cache" /> 
<meta http-equiv="Pragma" content="no-cache" /> 
<meta http-equiv="Expires" content="0" />
<title>流程图</title>
<link href="${ctx}/css/animate/animate.css?v=3.5.2" rel="stylesheet">
<script>var ctx="${ctx}";</script>
<script src="${ctx}/js/jquery.min.js?v=2.1.4"></script>
<script src="${ctx}/js/designer/raphael-min.js"></script>
<script src="${ctx}/js/designer/myflow.js"></script>
<script src="${ctx}/js/designer/myflow.jpdl4.js"></script>
<script src="${ctx}/js/plugins/layer/layer.js?v=3.0.3"></script>
<script src="${ctx}/js/public.js"></script>
<style type="text/css">
body {
	font-size: 12px;
	font-family: "微软雅黑" !important;
	background-color: #fff;
}
::-webkit-scrollbar {
    width: 6px;
    height: 6px;
    background-color: #fff;
}
::-webkit-scrollbar-thumb {
    background-color: #f3f3f3;
}
</style>
<script type="text/javascript">
	$(window).load(function() {
		var obj = new Object();
		obj.url = "${ctx}/api/jbpm/queryHisProcessDefinition.do",
		obj.pId = "${param.pId}";
		if(obj.pId && "" != obj.pId) {
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					var svg = $("#myflow").myflow($.extend(true,{
						editable : false,
						restore : eval("(" + result.datas.actives + ")"),
						activeRects : result.datas.activeRects,
						historyRects : result.datas.historyRects
						})
					);
					
				 	$('text[font-size="13px"] tspan').on("click", function() {
				 		if(!$(this).text()) {
				 			return;
				 		}
				 		var thiz = this;
				 		obj = new Object();
						obj.pId = "${param.pId}";
						obj.activityName = $(this).text();
				 		jQuery.ajax({
							url : "${ctx}/api/jbpm/queryHisTaskDetail.do",
							data : obj,
							type : "POST",
							dataType : "json",
							success : function(result) {
								if ("error" == result.resCode) {
									layer.msg(result.resMsg, {icon: 2});
								} else if(result.datas) {
									var userAlias = result.datas.userAlias ? result.datas.userAlias : result.datas.assignee;
									userAlias = userAlias ? userAlias : "";
									if("" == userAlias) {
										userAlias = result.datas.user ? result.datas.user : "";
									}
									if("" == userAlias) {
										userAlias = result.datas.users ? result.datas.users : "";
									}
									if("" == userAlias) {
										userAlias = result.datas.groups ? "<u>"+result.datas.groups+"</u>" : "";
									}
									var taskId = result.datas.taskId ? result.datas.taskId : "";
									var create = result.datas.create ? result.datas.create : "";
									var end = result.datas.end ? result.datas.end : "";
									var r = result.datas.result ? result.datas.result : "";
									var msg = "任务ID：" + taskId + "<br>";
									msg += "处理人：" + userAlias + "<br>";
									msg += "开始时间：" + create + "<br>";
									msg += "结束时间：" + end + "<br>";
									msg += "处理结果：" + r + "<br>";
									if("" == taskId && "" != userAlias) {
										msg = "处理人：" + userAlias;
									}
									layer.tips(msg, thiz, {
										tips: [1, "#4974A4"],
										area: ["220px", "auto"],
										time: 10000,
										closeBtn: 1
									});
								}
							},
							error : function(result) {
								layer.msg("网络连接错误！", {icon: 2});
							}
						});
				   });
				}
			});
		}
		
		try {
			$("body").bind("mousedown", function(event) {
				if(3 == event.which) {
					layer.closeAll("loading");
				}
			});
		} catch(ex) {
		}
	});
</script>
</head>

<body class="animated fadeIn">
	<div id="myflow"></div>
</body>
</html>