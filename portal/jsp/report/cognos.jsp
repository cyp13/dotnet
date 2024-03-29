<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="page" />

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Cache-Control" content="no-cache" /> 
<meta http-equiv="Pragma" content="no-cache" /> 
<meta http-equiv="Expires" content="0" />
<title>报表分析</title>
<link href="${ctx}/css/animate/animate.css?v=3.5.2" rel="stylesheet">
<script>var ctx="${ctx}";</script>
<script src="${ctx}/js/jquery.min.js?v=2.1.4"></script>
<script src="${ctx}/js/plugins/layer/layer.js?v=3.0.3"></script>
<script src="${ctx}/js/plugins/WdatePicker/WdatePicker.js"></script>
<link href="${ctx}/js/plugins/ztree/css/zTreeStyle/zTreeStyle.css?v=3.5.19" rel="stylesheet">
<script src="${ctx}/js/plugins/ztree/jquery.ztree.all.min.js?v=3.5.29"></script>
<script src="${ctx}/js/report/jquery.select.js"></script>
<script src="${ctx}/js/jquery.formautofill.js"></script>
<script src="${ctx}/js/jquery.form.min.js"></script>
<script src="${ctx}/js/public.js"></script>
<script src="${ctx}/js/report/CognosServer.js"></script>
<style type="text/css">
body {
	margin:0px;
	padding:0px;
	background-color:#f3f3f3;
}
.searchbar {
	width:100%;
	height:35px;
	font-size:13px;
	font-family: "微软雅黑";
	background-color:#e9e9e9;
	border-bottom:1px solid #ccc;
}
.searchbar  * {
	vertical-align: middle;
	display: inline-block;
}
.toolbar input, .toolbar select, .toolbar button {
	height:30px;
	line-height: 30px;
	border: 1px solid #ccc;
	outline: none;
}
.toolbar input:focus, .toolbar select:focus, .toolbar button:focus {
	border: 1px solid #3399FF;
}
.toolbar input {
	width:130px;
}
.toolbar button {
	width:30px;
	cursor:pointer;
	background-color:#f3f3f3;
}
.toolbar button:hover {
	background-color:#fff;
}
.toolbar button[disabled] { 
    -webkit-filter: grayscale(100%);
    -moz-filter: grayscale(100%);
    -ms-filter: grayscale(100%);
    -o-filter: grayscale(100%);
    filter: grayscale(100%);
    filter: gray;
}
[class*="validate\[required"] {
    padding-right:20px;
	background-image: url("${ctx}/images/icon_star.png");
    background-position: calc(100% - 5px);
    background-repeat: no-repeat;
}
::-webkit-scrollbar {
    width: 6px;
    height: 6px;
    background-color: #f3f3f3;
}
::-webkit-scrollbar-thumb {
    background-color: #ccc;
}
</style>
<script>
	var queryMenuParamUrl = "${ctx}/api/report/queryMenuParam.do";
	var queryParamBySqlUrl = "${ctx}/api/report/queryParamBySql.do";

	$(window).resize(function() {
		$("#reportDiv").css("height",document.body.clientHeight-35);
		if(("0" == "${param.toolbar_}" || "0" == $("#toolbar_").val()) && "1" != "${param.toolbar_}") {
			$("#reportDiv").css("height",document.body.clientHeight);
		}
	});

	$(window).load(function() {
		$("#reportDiv").css("height",document.body.clientHeight-35);

		if("0" != "${param.toolbar_}" && "0" != "${param.param_}") {
			queryParam();
		}
		
		if(("0" == "${param.toolbar_}" || "0" == $("#toolbar_").val()) && "1" != "${param.toolbar_}") {
			$("#reportDiv").css("height",document.body.clientHeight-30);
			$("#reportDiv").css("margin-top","0px");
			$(".searchbar").hide();
		}
		
		/* if(("0" == "${param.toolbar_}" || "0" == $("#toolbar_").val()) && "1" != "${param.toolbar_}") {
			$("#reportDiv").css("height",document.body.clientHeight);
			$("#reportDiv").css("margin-top","0px");
			$(".searchbar").hide();
		} else {
			queryParam();
		} */
		
		if(("0" == "${param.load_}" || "0" == $("#load_").val()) && "1" != "${param.load_}") {
			$("#reportViewer").contents().find("body").html('<span style="font-size:13px;">请点击查询按钮！</span>');
		} else {
			formSub("b0");
		}
		
		$(".date_select").on("click", function() {
			var format = $(this).attr("format");
			format = isNull(format) ? "yyyy-MM-dd HH:mm:ss" : format;
	 		WdatePicker({el:this,dateFmt:format});
		});

		$(".org_select").on("click", function() {
			showOrgTree(this, "1", function(treeId, treeNode) {
				var nodes = orgDivTree.getCheckedNodes(true);
				var names = [], ids = [];
				if(nodes) {
					$.each(nodes, function(index,node) {
						names.push(node.orgName);
						ids.push(node.id);
				  	});
				}
				$(".orgName").val(names.join(","));
				$(".orgId").val(ids.join(","));
			});
		});
		
		$(".dict_select").on("click", function() {
			showDictTree(this, function(treeId, treeNode) {
				var nodes = dictDivTree.getCheckedNodes(true);
				var names = [], ids = [];
				if(nodes) {
					$.each(nodes, function(index,node) {
						names.push(node.dictName);
						ids.push(node.dictValue);
				  	});
				}
				$(".dictName").val(names.join(","));
				$(".dictValue").val(ids.join(","));
			});
		});
		
		$("#a-back").on("click", function() {
			history.back();
		});
		
		try {
			$("body").bind("mousedown", function(event) {
				if(3 == event.which) {
					layer.closeAll("loading");
				}
			});
		} catch(e) {
		}
	});
	
	var queryParam = function() {
		var obj = new Object();
		obj.async = false;
		obj.url = queryMenuParamUrl;
		obj.menuId = "${param.rid}";
 		ajax(obj, function(result) {
 			if ("error" == result.resCode) {
 				layer.msg(result.resMsg, {icon: 2});
 				return false;
			} else {
				if($.isEmptyObject(result.datas)) {
					return false;
				}
				$.each(result.datas, function(index, o) {
					var dvalue = o.dvalue ? o.dvalue : "";
					var pvalue = o.pvalue ? o.pvalue : "";
					var validFlag = "1" == o.validFlag ? "validate[required]" : "";
					if("1" == o.controlType) {
						$("#paramSpan").append(o.cname+':<input type="text" id="'+o.ename+'" name="'+o.ename+'" value="'+dvalue+'" title="'+o.ename+'" class="'+validFlag+'" placeholder="请输入">');
					} else if('3' == o.controlType) {
						$("#paramSpan").append('<input type="hidden" id="'+o.ename+'" name="'+o.ename+'" value="'+dvalue+'" class="'+validFlag+'">');
					} else if('4' == o.controlType) {
						$("#paramSpan").append(o.cname+':<input type="text" id="'+o.ename+'" name="'+o.ename+'" value="'+dvalue+'" title="'+o.ename+'" format="'+pvalue+'" class="date_select '+validFlag+'" autocomplete="off" placeholder="请选择">');
					} else if('5' == o.controlType) {
						$("#paramSpan").append(o.cname+':<input type="text" id="'+o.ename+'_desc" name="'+o.ename+'_desc" value="'+dvalue+'" title="'+o.ename+'" readonly="readonly" class="org_select orgName '+validFlag+'" autocomplete="off" placeholder="请选择">');
						$("#paramSpan").append('<input type="hidden" id="'+o.ename+'" name="'+o.ename+'" value="'+dvalue+'" class="org_select orgId '+validFlag+'" autocomplete="off">');
					} else if('6' == o.controlType) {
						$("#paramSpan").append(o.cname+':<input type="text" id="'+o.ename+'_desc" name="'+o.ename+'_desc" value="'+dvalue+'" title="'+o.ename+'" readonly="readonly" class="dict_select dictName '+validFlag+'" pvalue="'+pvalue+'" autocomplete="off" placeholder="请选择">');
						$("#paramSpan").append('<input type="hidden" id="'+o.ename+'" name="'+o.ename+'" value="'+dvalue+'" class="dict_select dictValue '+validFlag+'" autocomplete="off">');
					} else if('2' == o.controlType) {
						$("#paramSpan").append(o.cname+':<input type="text" id="'+o.ename+'_desc" name="'+o.ename+'_desc" value="'+dvalue+'" title="'+o.ename+'" class="'+validFlag+'" autocomplete="off" placeholder="请选择">');
						$("#paramSpan").append('<input type="hidden" id="'+o.ename+'" name="'+o.ename+'" value="'+dvalue+'" class="'+validFlag+'" autocomplete="off">');
						try {
							var datas = [];
							if("1" == o.valueType) {
								if(pvalue && "" != $.trim(pvalue)) {
									var selects = pvalue.split(";");
									$.each(selects, function(index, select) {
										var s = select.split(":");
										if(s.length > 1) {
											var o = new Object();
											o.id = s[0];
											o.text = s[1];
				 							datas.push(o);
										}
									}); 
								}
							} else if("2" == o.valueType) {
								o.driverUrl = o.url;
								datas = queryParamBySql(o);
							}
							$.selectSuggest(o.ename+"_desc",datas,function() {
							  	$("#"+o.ename).val($(this).attr("ids"));	//this.innerHTML
							}, o.remark);
						} catch(e) {
						}
					}
					$("#paramSpan").append(" ");
				});
				
				$("#thisform").attr("action", "${ctx}/jsp/common/el.do");
				ajaxSubmit("#thisform", {async:false}, function(rs) {
					if ("error" == rs.resCode) {
						layer.msg(rs.resMsg, {icon: 2});
					} else {
						$("#paramSpan").fill(rs.datas);
					}
				});
			}
		});
		var outputFormat = '输出:<select id="run.outputFormat" name="run.outputFormat" style="width:60px;">';
		outputFormat += '<option value="HTML">HTML</option>';
		outputFormat += '<option value="singleXLS">XLS</option>';
		outputFormat += '<option value="CSV">CSV</option>';
		outputFormat += '<option value="PDF">PDF</option>';
		outputFormat += '</select>';
		$("#paramSpan").append(outputFormat);
	}

	var queryParamBySql = function(obj) {
		obj.async = false;
		obj.url = queryParamBySqlUrl;
		var datas = [];
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
				return false;
			} else {
				datas = result.datas;
			}
		});
		return datas;
	}
	
	var formSub = function(action) {
		try {
			$("#reportViewer").contents().find("body").html('<span style="font-size:13px;">加载中...</span>');
		} catch(e) {
		}
	//	var serverUrl = "http://10.6.10.79:9300/p2pd/servlet/dispatch";
		var serverUrl = "${report.extMap.ds.url}";
		if(serverUrl) {
			var userName = "${report.extMap.ds.userName}";
			var password = "${report.extMap.ds.password}";
			var namespace = "${report.extMap.ds.driverClass}";
			var server = new CognosServer(serverUrl);
			if(userName || password || namespace) {
				if(!server.login(userName,password,namespace)) {
					$("#reportViewer").contents().find("body").html('<span style="font-size:13px;">登录报表服务失败！</span>');
					return false;
				}
			}
			var report=new CognosReport(server,"${report.extPath}","Q");
			var params = getParameterStr();
			if(!(("0" == "${param.toolbar_}" || "0" == $("#toolbar_").val()) && "1" != "${param.toolbar_}")) {
				params += "&" + $("#paramSpan :input").serialize();
			}
			showReport(report,1,params,"reportViewer");
		}
	}
</script>
<link href="${ctx}/js/tree/divTree.css" rel="stylesheet">
<script src="${ctx}/js/tree/orgTree.js"></script>
<script src="${ctx}/js/tree/dictTree.js"></script>
</head>

<body class="animated fadeIn" style="overflow:hidden;">
	<div class="searchbar">
		<div class="toolbar" style="position:fixed;top:2px;left:0px;z-index:999">
			<form id="thisform" method="post" onsubmit="return false;">
				<span id="paramSpan" style="position:relative;padding-left:5px;"></span>
				<button id="b0" class="b0" onclick="formSub('b0');" title="查询">
					<img src="${ctx}/images/report/icon_search.gif">
				</button>
			</form>
		</div>
	</div>
	<div id="reportDiv" style="overflow:hidden;">
		<iframe id="reportViewer" name="reportViewer" style="width:100%; height:100%; display:block; border:0px;"></iframe>
	</div>
	<div id="orgDiv" style="display:none;position:absolute;z-index:9999">
		<ul id="orgDivTree" class="ztree divTree"></ul>
	</div>
</body>
</html>
