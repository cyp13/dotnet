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
<title>流程定义设计</title>
<link href="${ctx}/css/animate/animate.css?v=3.5.2" rel="stylesheet">
<script>var ctx="${ctx}";</script>
<script src="${ctx}/js/jquery.min.js?v=2.1.4"></script>
<link href="${ctx}/js/jquery-ui/jquery-ui.min.css?v=1.12.1" rel="stylesheet">
<link href="${ctx}/js/jquery-ui/jquery-ui.theme.min.css?v=1.12.1" rel="stylesheet">
<script src="${ctx}/js/jquery-ui/jquery-ui.min.js?v=1.12.1"></script>
<script src="${ctx}/js/designer/raphael-min.js"></script>
<script src="${ctx}/js/designer/myflow.js"></script>
<script src="${ctx}/js/designer/myflow.jpdl4.js"></script>
<script src="${ctx}/js/designer/myflow.editors.js"></script>
<script src="${ctx}/js/jquery.form.js"></script>
<script src="${ctx}/js/json2.js"></script>
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
    height: 12px;
    background-color: #fff;
}
::-webkit-scrollbar-thumb {
    background-color: #f3f3f3;
}
.node {
	width: 70px;
	margin-top: 1px;
	padding-top: 3px;
	padding-bottom: 3px;
	text-align: center;
}
.node img {
	margin-right: 8px;
}
.mover, .selected {
	background-color: #e9e9e9;
}
#myflow_props th,td {
	padding: 5px;
}
</style>

<script type="text/javascript">
	var designerUrl = "${ctx}/jsp/jbpm/designer.jsp";
	designerUrl+="${param.deploymentId}"?"?deploymentId=${param.deploymentId}":"";
	
	$(window).load(function() {
		var obj = new Object();
		obj.url = "${ctx}/jsp/jbpm/getProcessDefinition.do";
		obj.deploymentId = "${param.deploymentId}";
		if("" != obj.deploymentId) {
			ajax(obj, function(result) {
				if("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					init(result.datas);
				}
			});
		} else {
			init();
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
	
	var init = function(data) {
		$(".save").unbind();
		var myflow = $("#myflow").myflow({
			restore : eval("("+data+")"),
			tools : {
				publish : {
					onclick : function(send, deploymentId) {
						var msg = "您确定要发布流程吗？";
						if(deploymentId && (typeof deploymentId !== "undefined")) {
							msg = "该流程下存在多个实例，建议《发布》新版本流程，继续保存可能带来严重的错误，您确定要保存流程吗？";
						}
						layer.confirm(msg, {icon:3}, function() {
							var obj = new Object();
							obj.url = "${ctx}/jsp/jbpm/insertProcessDefinition.do";
							obj.jsonValue = send;
							if(deploymentId && (typeof deploymentId !== "undefined")) {
								obj.deploymentId = deploymentId;
							}
							ajax(obj, function(result) {
								if ("error" == result.resCode) {
									layer.msg(result.resMsg, {icon: 2});
								} else {
									layer.msg(result.resMsg, {icon: 1});
								}
							});
						});
					}
				},
				import_ : {
					onclick : function(send) {
						$("#importform")[0].reset();
						$("#importdiv").dialog({
							modal : true,
							buttons : {
								"确定" : function() {
									var xmlValue = $('#xmlValue').val();
									if(xmlValue) {
										ajaxSubmit("#importform", {async: false}, function(result) {
											if ("error" == result.resCode) {
												layer.msg(result.resMsg, {icon: 2});
											} else if(result.datas) {
												init(result.datas);
												$("#importdiv").dialog("close");
											}
										});
									} else {
										layer.msg("请选择流程定义文件！");
									}
								},
								"取消" : function() {
									$(this).dialog("close");
								}
							}
						});
					}
				},
				export_ : {
					onclick : function(send) {
						$("#jsonValue").val(send);
						$("#exportform").submit();
					}
				}
			}
		});
	}
</script>
</head>
<body class="animated fadeIn">
	<div id="myflow_tools" class="ui-widget-content" style="position:absolute;width:70px;padding:2px;cursor:default;">
		<div id="myflow_tools_handle" class="ui-widget-header" style="text-align:center;">工具栏</div>
		<div class="node save" id="myflow_publish">
			<img src="${ctx}/js/designer/img/16/icon_publish.gif" align="absbottom">发布
		</div>
		<%-- <div class="node save" id="myflow_save" deploymentId="${param.deploymentId}">
			<img src="${ctx}/js/designer/img/16/icon_save.png" align="absbottom">保存
		</div> --%>
		<div class="node" id="myflow_import_">
			<img src="${ctx}/js/designer/img/16/icon_import.png" align="absbottom">导入
		</div>
		<div class="node" id="myflow_export_">
			<img src="${ctx}/js/designer/img/16/icon_export.png" align="absbottom">导出
		</div>
		<div class="node" onclick="layer.confirm('您确定要刷新设计器吗？',{icon:3},function(){location.reload();});">
			<img src="${ctx}/js/designer/img/16/icon_refresh.gif" align="absbottom">刷新
		</div>
		<hr>
		<div class="node selectable" id="pointer">
			<img src="${ctx}/js/designer/img/16/icon_arrow.gif" align="absbottom">选择
		</div>
		<div class="node selectable" id="path">
			<img src="${ctx}/js/designer/img/16/flow_sequence.png" align="absbottom">连线
		</div>
		<hr>
		<div class="node state" id="start" type="start">
			<img src="${ctx}/js/designer/img/16/start_event_empty.png" align="absbottom">开始
		</div>
		<div class="node state" id="end" type="end">
			<img src="${ctx}/js/designer/img/16/end_event_terminate.png" align="absbottom">结束
		</div>
		<div class="node state" id="task" type="task">
			<img src="${ctx}/js/designer/img/16/task_empty.png" align="absbottom">任务
		</div>
		<div class="node state" id="decision" type="decision">
			<img src="${ctx}/js/designer/img/16/gateway_exclusive.png" align="absbottom">决策
		</div>
		<div class="node state" id="fork" type="fork">
			<img src="${ctx}/js/designer/img/16/gateway_parallel.png" align="absbottom">分支
		</div>
		<div class="node state" id="join" type="join">
			<img src="${ctx}/js/designer/img/16/gateway_parallel.png" align="absbottom">合并
		</div>
		<hr>
		<div class="node" onclick="layer.confirm('您确定要关闭设计器吗？',{icon:3},function(){parent.closeItem(designerUrl);});">
			<img src="${ctx}/js/designer/img/16/icon_exit.png" align="absbottom">关闭
		</div>
	</div>
	
	<div id="myflow_props" class="ui-widget-content" style="position:absolute;width:230px;padding:2px;">
		<div id="myflow_props_handle" class="ui-widget-header" style="text-align:center;">属性</div>
		<table style="width:100%; border-collapse:collapse;margin-top:1px" border="1"></table>
		<li style="color:#FF5252;list-style-type:none;">★ 流程中除连线外名称必须保证唯一性</li>
		<li style="color:#DAA520;list-style-type:none;">★ 在编辑属性时请谨慎使用Delete键</li>
	</div>
	
	<div id="myflow"></div>
	
	<div id="importdiv" title="导入流程定义" style="display:none;">
		<form action="${ctx}/jsp/jbpm/import.do?ajax=1" method="POST" id="importform" enctype="multipart/form-data" onsubmit="return false;">
			<input type="file" id="xmlValue" name="xmlValue" accept=".xml">
		</form>
	</div>
	
	<form action="${ctx}/jsp/jbpm/export.do" method="POST" id="exportform">
		<input type="hidden" id="jsonValue" name="jsonValue">
	</form>
</body>
</html>