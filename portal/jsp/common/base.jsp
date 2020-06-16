<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="session" />

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Cache-Control" content="no-cache" /> 
<meta http-equiv="Pragma" content="no-cache" /> 
<meta http-equiv="Expires" content="0" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta name="keywords" content="${myUser.user.extMap.sys.sysName}">
<title>${myUser.user.extMap.sys.sysName}</title>

<%-- <link rel="shortcut icon" href="${ctx}/favicon.ico"> --%>
<link href="${ctx}/css/font-awesome/css/font-awesome.min.css?v=4.7.0" rel="stylesheet">
<link href="${ctx}/css/animate/animate.css?v=3.5.2" rel="stylesheet">

<script>var ctx="${ctx}";</script>
<script src="${ctx}/js/jquery.min.js?v=2.1.4"></script>
<script src="${ctx}/js/jquery-ui/jquery-ui.min.js?v=1.12.1"></script>

<script src="${ctx}/js/plugins/prettyfile/bootstrap-prettyfile.js?v=2.0"></script>
<script src="${ctx}/js/plugins/layer/layer.js?v=3.0.3"></script>
<script src="${ctx}/js/jquery.form.js"></script>
<script src="${ctx}/js/jquery.formautofill.js"></script>

<script src="${ctx}/js/public.js"></script>

<link href="${ctx}/js/bootstrap/css/bootstrap.min.css?v=3.3.7" rel="stylesheet">
<script src="${ctx}/js/bootstrap/js/bootstrap.min.js?v=3.3.7"></script>

<link href="${ctx}/js/plugins/dataTables/css/jquery.dataTables.css" rel="stylesheet">
<link href="${ctx}/js/plugins/dataTables/css/dataTables.bootstrap.css" rel="stylesheet">
<script src="${ctx}/js/plugins/dataTables/js/jquery.dataTables.min.js?v=1.10.15"></script>
<script src="${ctx}/js/plugins/dataTables/js/dataTables.bootstrap.min.js?v=3"></script>

<link href="${ctx}/js/plugins/validation-engine/validationEngine.jquery.css" rel="stylesheet">
<script src="${ctx}/js/plugins/validation-engine/jquery.validationEngine.js"></script>
<script src="${ctx}/js/plugins/validation-engine/jquery.validationEngine-zh_CN.js"></script>

<link href="${ctx}/js/plugins/ztree/css/zTreeStyle/zTreeStyle.css?v=3.5.19" rel="stylesheet">
<script src="${ctx}/js/plugins/ztree/jquery.ztree.all.min.js?v=3.5.29"></script>

<link href="${ctx}/js/hplus/style.css?v=4.1.0" rel="stylesheet">
<script src="${ctx}/js/hplus/content.js?v=1.0.0"></script>

<link href="${ctx}/js/plugins/pace/pace.css?v=1.0.2" rel="stylesheet">
<script src="${ctx}/js/plugins/pace/pace.min.js?v=1.0.2"></script>

<script src="${ctx}/js/plugins/other/clipboard.min.js"></script>
<script src="${ctx}/js/jquery.base64.js"></script>
<style type="text/css">
body {
	font-family: "微软雅黑" !important;
}
.dataTables_wrapper .table th {
	border-bottom: 1px solid #111 !important;
}
.dataTables_wrapper .dataTables_info {
	margin-top: 4px !important;
}
.dataTables_wrapper .dataTables_length {
	margin-top: 0 !important;
}
.dataTables_wrapper .dataTables_paginate {
	margin-top: 3px !important;
}
.dataTables_wrapper .dataTables_paginate .paginate_button {
	border: 0 !important;
}
.form-control[disabled], fieldset[disabled] .form-control {
	background-color: #f3f3f3;
	background-image: none;
}
.form-control[readonly] {
	background-color: #f9f9f9;
}
[class*="validate\[required"],[class*="validate\[groupRequired\["] {
    padding-right:20px;
	background-image: url("${ctx}/images/icon_star.png");
    background-position: calc(100% - 5px);
    background-repeat: no-repeat;
}
select[class*="validate\[required"] {
	appearance:none;
	-moz-appearance:none;
	-webkit-appearance:none;
	line-height:20px;
}
select[class*="validate\[required"]::-ms-expand {
	display:none;
}
.bootstrap-select button {
	border-radius: 0px;
	height: 30px;
}
/**
.delFile_{
	position:absolute;
}**/
</style>

<script>
$.fn.dataTable.ext.errMode = "none";
var portal_host_ = '${s:getDict("host","portal")}';
var sysId_  = '${myUser.user.sysId}';
var userName_ = '${myUser.user.userName}';
var msgdownloadUrl='${s:getProp("msg.downloadUrl")}';//集成PC下载url
$(window).ready(function() {
	$("#checkAll_,.checkAll_").on("click", function() {
		$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
	});
	
 	$(".a-reload").on("click", function() {
		location.reload();
	});

 	$(".a-back").on("click", function() {
		var href = location.href;
		var refer = document.referrer;
		if(href==refer){
				history.back();
			}else{
				location.href=refer;
			}
 	 	
	});

 	$(".a-go").on("click", function() {
 		history.back();
	});

 	try {
 		$(".date_select").on("click", function() {
			var format = $(this).attr("format");
			format = isNull(format) ? "yyyy-MM-dd HH:mm:ss" : format;
	 		WdatePicker({el:this,dateFmt:format});
		});
 	} catch(ex) {
	}
	
	try {
		$("input[type='file']").prettyFile();
	} catch(ex) {
	//	console.log(ex);
	}
	
	try {
		$(".key-13").bind("keypress", function(event) {
		    var theEvent = event || window.event;
		    var keyCode = theEvent.keyCode || theEvent.which || theEvent.charCode;
		    if (keyCode == 13 && (!($(":focus").is("textarea")) && !($(":focus").is(".w-e-text")))) {
		      	$(this).find(".btn-13").click();
		    }
		});
		
		$("button").on("click", function() {
	 		$(this).blur();
		});
		
		$(document).bind("keyup", function(event) {
			var theEvent = event || window.event;
		    var keyCode = theEvent.keyCode || theEvent.which || theEvent.charCode;
			if(keyCode == 13) {//enter
				$("a.layui-layer-btn0").click();
			} else if(keyCode == 27) {//escap
				$("a.layui-layer-btn1").click();
				layer.closeAll("loading");
			}
		});
		
		$("body").bind("mousedown", function(event) {
			if(3 == event.which) {
				layer.closeAll("loading");
			}
		});
	} catch(ex) {
	}
	
	try {
		$(".modal-dialog").draggable({
			handle: ".ibox-title"
		});
	} catch(ex) {
	}
	
	try {
		$(".modal").on("shown.bs.modal", function() {
	 		$(this).find(":text:enabled:visible:first").focus();
		});
		
	 	$(".modal").on("hidden.bs.modal", function() {
	 		$(this).find("form").resetForm();
	 		$(this).find("form").validationEngine("hideAll");
	 		
	 		var selects = $(this).find(".selectpicker");
			if(selects && selects.length > 0){
				$.each(selects,function(index, o){
					$(o).selectpicker("val", "");
				});
			}
		});
	} catch(ex) {
	}

	try {
		$(".selectpicker").attr("data-live-search","true");
		$(".multiple").attr("multiple","multiple");
		$(".selectpicker").selectpicker({
			noneSelectedText: "请选择",
			actionsBox: true,
			style: "btn-white"
		});
		$(".selectpicker").selectpicker("val", "");
		$(".selectpicker").selectpicker("render");
		$(".selectpicker").selectpicker("refresh");
	} catch(ex) {
	}
	
	try {
	//	window.parent.postMessage(obj,'*');
		window.addEventListener("message", function(e){
			var obj = e.data;
			if(obj && "menuItem" == obj.action) {
				 top.menuItem(obj.name, obj.target);
			} else if(obj && "closeItem" == obj.action) {
				top.closeItem(obj.target);
			} else if(obj && "refreshItem" == obj.action) {
				top.refreshItem(obj.target);
			} else if(obj && "click" == obj.action) {
				$(obj.target).click();
			}
		}, false);
	} catch(ex) {
	}
});

var fillSelect = function(obj, data) {
	try {
		var selects = $(obj).find(".selectpicker");
		if(selects && selects.length > 0){
			$.each(selects,function(index, o){
				var name = $(o).attr("name");
				$(o).selectpicker("val", data[name]);
			});
		}
	} catch(ex) {
	}
}


var downloadUrl = portal_host_+"/api/sys/downloadFile.do?sysId=" + sysId_;
var deleteFileIds = new Object();
//生成附件
function getFiles(fileList,element,flag){//flag存在则文件不可删除
	$(element).html('<div id="imgDiv_"></div><div id="fileDiv_"></div>');
	$.each(fileList,function(index,o){
		var url_ = downloadUrl+"&id="+o.id;
		//var fileHtml = "<a state='normal' href='"+url_+"' target='_blank'>"+o.fileName+"."+o.fileExt+"</a>";
		var fileHtml = "";
		var imgHtml = "";
		var ext = o.fileExt.toLowerCase();
		var images = ['png','jpg','bmp','jpeg','gif','webp'];//常见图片格式
		var ifImage = false;

		var portalUrl = '${s:getProp("host.ip")}';
		var fileId = o.id+"."+o.fileExt;
		var fileUploadDir = '${s:getSysConstant("FILE_UPLOAD_DIR")}';
		var realUrl = portalUrl+fileUploadDir;
		if(o.ext3){
			//realUrl = portalUrl + "/files/portal/" + o.ext3 ;
			realUrl += o.ext3 ;
		}else{
			//realUrl = portalUrl+"/files/portal/"+sysId_+"/"+fileId;
			realUrl += sysId_+"/"+fileId;
		}

		for (var i = 0; i < images.length; i++) {
			if(ext==images[i]){

				imgHtml += imgHtml+="&nbsp;&nbsp;<a state='normal' id='img_"+index+"' onclick='downloadFile(this,true)' data-yu='"+realUrl+"' data-id='"+o.id+"."+o.fileExt+"' data-url='"+url_+"' href='javascript:void(0);' target='_blank'><img width='80px'  src='"+realUrl+"' /></a>";


				if(!flag && userName_==o.creater){//可删除
					imgHtml+= "<a class='delFile_' state='normal' style='margin-left:20px;' fileId='"+o.id+"' href='javascript:void(0);' "
						+ "onclick='modifyFile($(this));'><span  style=\"color: red;\"><i class='fa fa-remove delFile'>删除</i></span></a>";
				}
				ifImage=true;
				break;
			}
		}
		if(!ifImage){
			fileHtml += "<a state='normal' title='点击下载' onclick='downloadFile(this)' data-yu='"+realUrl+"' data-id='"+o.id+"."+o.fileExt+"' data-url='"+url_+"' href='javascript:void(0);' target='_blank'>"+o.fileName+"."+o.fileExt+"</a>";
			if(!flag && userName_==o.creater){
				fileHtml += "&nbsp;&nbsp;<a state='normal' fileId='"+o.id+"' href='javascript:void(0);' "
				+ "onclick='modifyFile($(this));'><span style=\"color: red;\"><i class='fa fa-remove delFile'></i>刪除</span></a>";
			}
		}
		
		fileHtml +="&nbsp;&nbsp;";
		imgHtml +="&nbsp;&nbsp;";
		$("#imgDiv_").append(imgHtml);
		$("#fileDiv_").append(fileHtml);
	});
}
function downloadFile(ele,flag){
	try{
		var realUrl = $(ele).attr('data-yu');
		if( flag && realUrl){
			//预览
			window.open(realUrl);
		}else{
			//下载
			window.open($(ele).attr('data-url'));
		}
	}catch(e){
		
	}
}
function modifyFile(ele){
	var state = ele.attr('state'), fileId = ele.attr('fileId');
	if(state=='normal'){
		ele.html('<span style="color: gray;"><i class="fa fa-mail-reply"></i>恢复</span>');
		ele.attr('state', 'deleted');
		ele.prev('a').attr('state', 'deleted');
		ele.prev('a').css('color', 'gray');
		deleteFileIds[fileId] = fileId;
	}else{
		ele.html('<span style="color: red;"><i class="fa fa-remove"></i>删除</span>');
		ele.attr('state', 'normal');
		ele.prev('a').attr('state', 'normal');
		ele.prev('a').css('color', '');
		delete deleteFileIds[fileId];
	}
}
</script>