<%@ page language="java" import="java.io.File" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="page" />

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Cache-Control" content="no-cache" /> 
<meta http-equiv="Pragma" content="no-cache" /> 
<meta http-equiv="Expires" content="0" />
<title>表单预览</title>
<link href="${ctx}/css/animate/animate.css?v=3.5.2" rel="stylesheet">
<script>var ctx="${ctx}";</script>
<script src="${ctx}/js/jquery.min.js"></script>
<script src="${ctx}/js/plugins/layer/layer.js?v=3.0.3"></script>
<script src="${ctx}/js/jquery.formautofill.js"></script>
<script src="${ctx}/js/jquery.form.min.js"></script>
<script src="${ctx}/js/public.js"></script>
<style type="text/css">
body {
	margin:0px;
	padding:0px;
	background-color: #fff;
}
input[type='text'], textarea, select, button {
	border: 1px solid #ccc;
	outline: none;
}
input:focus, textarea:focus, select:focus, button:focus {
	border: 1px solid #3399FF;
}
#content {
	padding: 5px;
	padding-bottom: 30px;
}
#content table td {
	padding: 5px;
}
#content .hide {
	display: none;
}
.footer {
	position: fixed; 
	width: 100%;
	bottom: 0;
	z-index: 999; 
	text-align: center;
	background-color: #fff;
	border-top: 1px dashed #ccc;
	padding: 3px;
}
.footer  * {
	vertical-align: middle;
	display: inline-block;
	
}
.footer input, .footer select {
	height: 30px;
	line-height: 30px;
}
.footer button {
	height: 30px;
	cursor:pointer;
	background-color: #f3f3f3;
}
.footer button:hover {
	background-color: #fff;
}
.readonly {
	color: #000 !important;
	resize: none !important;
	border: none !important;
	background-color: transparent !important;
	box-shadow: inset 0 0px 0px rgba(0, 0, 0, 0) !important;
	-webkit-appearance: none !important;
	opacity: 1 !important;
	overflow: auto;
}
select[class*="readonly"]::-ms-expand {
	display: none;
}
select[class*="readonly"] {
	appearance: none;
	-moz-appearance: none;
	-webkit-appearance: none;
	line-height: 20px;
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
<script>
	var formDesignerUrl = "${ctx}/jsp/jbpm/formDesigner.do";
	var queryVariableUrl = "${ctx}/jsp/jbpm/queryVariable.do";
	var startProcessInstanceUrl = "${ctx}/jsp/jbpm/startProcessInstance.do?ajax=1";
	var completeTaskUrl = "${ctx}/jsp/jbpm/completeTask.do?ajax=1";
	var o = {action:"click", target:".a-back"};

	$(window).load(function() {
		document.oncontextmenu = function() {
			return true;
		}
		
		$("#result").val("完成");
		$("#result").attr("placeholder", "完成、回退、驳回、终止");
		$("#desc").attr("placeholder", "请输入意见");
		
		if(("view" == "${param.flag}") || ("" == "${param.taskId}" && "" != "${param.pId}")) {
			$("#footer").css("display", "none");
		} else if("" == "${param.taskId}" && "" == "${param.pId}") {
			$("#btn-submit").html('<img src="${ctx}/images/report/icon_yes.gif"> <span>提交</span>');
			$(".complete").attr("disabled", true);
			$(".complete").css("display", "none");
			o.action = "closeItem";
			o.target = "${ctx}/jsp/jbpm/form.jsp?formCode=${param.formCode}";
		}
		
		$("#btn-submit").click(function(){
			completeTask();
		});

		$("#btn-cancel").click(function(){
			window.parent.postMessage(o, "*");
		});

		$("#btn-print").click(function(){
		//	doPrint("content");
			$("#footer").css("display", "none");
			window.self.focus();
			window.self.print();
			$("#footer").css("display", "block");
		});
		
		try {
			$("body").bind("mousedown", function(event) {
				if(3 == event.which) {
					layer.closeAll("loading");
				}
			});
		} catch(e) {
		}
		
		getFormContent();
	})

	var getFormContent = function() {
		var obj = new Object();
		obj.formCode = "${param.formCode}";
		obj.url = formDesignerUrl;
		if("" == "${param.taskId}" && "" == "${param.pId}") {
			obj.rowValid = "1";
		}
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
				$("#footer").css("display", "none");
			} else {
				$("#content").html(result.datas.formParse);
				if("" == "${param.pId}" && "" == "${param.taskId}") {
					$("#thisform").attr("action", "${ctx}/jsp/common/el.do");
					ajaxSubmit("#thisform", {async:false}, function(rs) {
						if ("error" == rs.resCode) {
							layer.msg(rs.resMsg, {icon: 2});
						} else {
							$("#content").fill(rs.datas);
						}
					});
					try {jsCallback();} catch(e) {}
				} else {
					loadDate();
				}
			}
		});
	}
	
	var loadDate = function() {
		var obj = new Object();
		obj.pId = "${param.pId}";
		obj.taskId = "${param.taskId}";
		if("edit" != "${param.flag}") {
			$("input[type='text'],input[type='file'],select,textarea", $("#content")).addClass("readonly");
			$("input[type='file']", $("#content")).css("display", "none");
			$("*", $("#content")).attr("disabled","disabled");
			$("*", $("#content")).removeAttr("checked");
		}
		obj.url = queryVariableUrl;
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			} else {
				$("#content").fill(result.datas);
				$("#content").find("input[type='file']:last").after("${s:getFile(param.pId)}");
				if(result.datas.ActivityPath_ && 0 == result.datas.ActivityPath_.length) {
					$("#btn-submit").html('<img src="${ctx}/images/report/icon_yes.gif"> <span>提交</span>');
					$(".complete").attr("disabled", true);
					$(".complete").css("display", "none");
					
					$("input[type='file']", $("#content")).css("display","block");
					$("*", $("#content")).removeClass("readonly");
					$("*", $("#content")).removeAttr("disabled");
				}
				try {jsCallback();} catch(e) {}
			}
		});
	}
	
	var completeTask = function() {
		$("#thisform").attr("action", completeTaskUrl);
		
		var obj = new Object();
		obj.taskId = "${param.taskId}";
		if("" == "${param.pId}" && "" == "${param.taskId}") {
			$("#thisform").attr("action", startProcessInstanceUrl);
			obj.sysId_ = "${myUser.user.extMap.sys.id}";
			obj.owner_ = "${myUser.user.userName}";
			obj.form_ = "/jsp/jbpm/form.jsp?formCode=${param.formCode}&flag=view";
			if("" == $("#pdId").val()) {
				alert("提交失败，缺少参数pdId！");
				return false;
			}
			if("" == obj.sysId_) {
				alert("提交失败，缺少参数sysId_！");
				return false;
			}
			if("" == obj.owner_) {
				alert("提交失败，缺少参数owner_！");
				return false;
			}
			
		} else {
			obj.userName = "${myUser.user.userName}";
		}
		
		var checkboxs = $("#content").find("input[type='checkbox']");
		$.each(checkboxs, function(i, o) { //非常重要
			if(!$(o).prop("checked") && !$(o).prop("disabled")) {
				obj[$(o).attr("name")] = "";
			}
		})

		ajaxSubmit("#thisform", obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			} else {
				layer.msg("数据处理成功！", {icon: 1}, function() {
					window.parent.postMessage(o, "*");
				});
			}
		});
	}
</script>
</head>
<body class="animated fadeIn">
	<form id="thisform" method="post" onsubmit="return false;">
		<div id="content" class="content"></div>
		<div id="footer" class="footer">
			<input type="text" id="result" name="result" class="validate[required] complete" list="datalist_result" title="完成、回退、驳回、终止" style="width:100px;" autocomplete="on">
			<datalist id="datalist_result" style="display:none">
				<option value="完成">
				<option value="回退">
				<option value="驳回">
				<option value="终止">
			</datalist>
			<s:dict dictType="desc" type="datalist" clazz="validate[required] complete" style="width:400px;"/>
			<button type="button" id="btn-submit"><img src="${ctx}/images/report/icon_yes.gif"> <span>确定</span></button>
			<button type="button" id="btn-cancel"><img src="${ctx}/images/report/icon_cancel.gif"> <span>取消</span></button>
			<%-- <button type="button" id="btn-print"><img src="${ctx}/images/report/icon_print.gif"> <span>打印</span></button> --%>
		</div>
	</form>
</body>
</html>