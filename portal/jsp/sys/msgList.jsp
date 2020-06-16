<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/baseMsgList.jsp"></jsp:include>
<link href="${ctx}/js/plugins/select/bootstrap-select.css" rel="stylesheet"  />
<link href="${ctx}/js/plugins/other/wangEditor-fullscreen-plugin.css" rel="stylesheet"  />
<script src="${ctx}/js/plugins/select/bootstrap-select.js"></script>
<script src="${ctx}/js/plugins/select/defaults-zh_CN.js"></script>
<script src="${ctx}/js/plugins/other/wangEditor.js"></script>
<script src="${ctx}/js/plugins/other/wangEditor-fullscreen-plugin.js"></script>
<script src="${ctx}/js/plugins/WdatePicker/WdatePicker.js"></script>
<script src="${ctx}/js/plugins/prettyfile/bootstrap-prettyfile.local.js?v=2.0"></script>
<script src="${ctx}/js/plugins/ztree/jquery.ztree.exhide.js?v=3.5.37"></script>
<script src="${ctx}/js/plugins/ztree/jquery.ztree.id.search.js?v=3.5.37"></script>
<script>
	var queryUrl = "queryMsg.do";
    var insertUrl = "insertMsg.do";
	var updateUrl = "updateMsg.do";
	var deleteUrl = "deleteMsg.do";
	var queryUserUrl = "queryUser.do";
	var queryMsgRecordUrl = "queryMsgRecord.do";
	var deleteFileUrl = "deleteFile.do";
	var exportMsgUrl = "exportMsg.do";
	//var queryRoleUrl = ctx + "/jsp/sys/queryRole.do";
	//var queryRoleUrl = ctx + "/api/sys/queryRole.do";
	var queryRoleUrl = "queryRole.do";
	var queryOrgTreeUrl = "queryOrg.do";

	var sysId = "${myUser.user.extMap.sys.id}";
	sysId = "" == sysId ? "${myUser.user.sysId}" : sysId;
	
	var orgDivTree = null;
	
	$(window).ready(function() {
		var table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": false,
			"autoWidth": false,
			"processing": true,
			"serverSide": true,
			"ajax": {
				"dataSrc": "datas",
				"url": queryUrl,
				"data": function (d) {
					return $.extend( {}, d, {
						"sysId": sysId,
						"keywords": $("#keywords").val(),
						"startTime": $("#startTime").val(),
						"endTime": $("#endTime").val()
					});
				}
			},
			"aoColumnDefs": [ {
				"targets": [ 0 ],
				"data":"id",
				"render": function (data, type, row) {
					var s = '<input type="checkbox" ';
					if("1" == row.rowDefault) {
						s = s + 'disabled="disabled" '; 
					} else {
						s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
					}
					return s +'style="margin:0px;"/>';
				}
			}, {
				"targets": [ 1 ],
				"data":"msgTitle",
				"render": function( data, type, row ){
					return '<a href="javascript:void(0);" class="edit-href" msgid="'+row.id+'">'+data+'</a>';
				}
			}<%-- 成都消息通知不需要类型和级别 --%><c:if test="${myUser.user.org.ext1 eq 'CD'}">, {
				"targets": [ 2 ],
				"data":"modified",
				"render": function (data, type, row) {
					return '<span title="'+row.modifier+'">'+data+'</span>';
				}
			}, {
				"targets": [ 3 ],
				"data":"msgStatus",
				"render": function (data, type, row) {
                    if('1' == data) {
                    	return "<i class='fa fa-save' style='color:#DAA520'> 草稿</i>";
                    } else if('2' == data) {
						return "<i class='fa fa-send-o' style='color:#008B00'> 发布</i>";
                    }
                    return data;
				}
			}, {
				"targets": [ 4 ],
				"render": function (data, type, row) {
					return row.ext2+'/'+row.ext1;
				}
			}, {
				"targets": [ 5 ],
				"data":"id",
				"render": function (data, type, row) {
					var msgStatus=row['msgStatus'];
                    if('1' == msgStatus) { 
						return '<a href="msgRecord.do?msgId='+data+'">记录</a>';
                    } else if('2' == msgStatus) { 
						return '<a href="msgRecord.do?msgId='+data+'">记录</a>&nbsp;&nbsp;&nbsp;<a onclick="exportOr(\''+data+'\')">导出</a>';
                    }				}
			}</c:if><c:if test="${myUser.user.org.ext1 ne 'CD'}">, {
				"targets": [ 2 ],
				"data":"extMap.msgType",
				"render": function (data, type, row) {
					if(data) {
						return data;
					}
					return row.msgType;
				}
			}, {
				"targets": [ 3 ],
				"data":"extMap.msgLevel",
				"render": function (data, type, row) {
					if(data) {
						return data;
					}
					return row.msgLevel;
				}
			}, {
				"targets": [ 4 ],
				"data":"modified",
				"render": function (data, type, row) {
					return '<span title="'+row.modifier+'">'+data+'</span>';
				}
			}, {
				"targets": [ 5 ],
				"data":"msgStatus",
				"render": function (data, type, row) {
                    if('1' == data) {
                    	return "<i class='fa fa-save' style='color:#DAA520'> 草稿</i>";
                    } else if('2' == data) {
						return "<i class='fa fa-send-o' style='color:#008B00'> 发布</i>";
                    }
                    return data;
				}
			}, {
				"targets": [ 6 ],
				"render": function (data, type, row) {
					return row.ext2+'/'+row.ext1;
				}
			}, {
				"targets": [ 7 ],
				"data":"id",
				"render": function (data, type, row) {
					var msgStatus=row['msgStatus'];
                    if('1' == msgStatus) { 
						return '<a href="msgRecord.do?msgId='+data+'">记录</a>';
                    } else if('2' == msgStatus) { 
						return '<a href="msgRecord.do?msgId='+data+'">记录</a>&nbsp;&nbsp;&nbsp;<a onclick="exportOr(\''+data+'\')">导出</a>';
                    }
				}
			}
			</c:if>]
		});
        
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				var param = {
					"sysId": sysId,
					"keywords": $("#keywords").val(),
					"startTime": $("#startTime").val(),
					"endTime": $("#endTime").val(),
					"msgType": $("#queryForm select[name=msgType]").val()
				};
				table.api().settings()[0].ajax.data = param;
				table.api().ajax.reload();
			}
       	});
		
		$("#btn-insert").on("click", function() {
			$(".files").html("");
			$("#editForm").attr("action", insertUrl);
			$("#myModal").modal("show");
			$("#editForm").find("input,select,textarea").attr("disabled", false);
			$("#btn-ok").attr("disabled", false);
			//queryUser();
			editor.txt.clear();
			editor.$textElem.attr('contenteditable', true);
			//删除多余的多文件输入框。
			$(".diyFile").find('a[onclick="$deleteFile(this)"]').click();
			queryRole();
       	});

		$("#btn-update").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size != 1) {
				layer.msg("请选择需要修改的一行数据！", {icon: 0});
				return;
			}
			openEditData( $(".ids_:checkbox:checked").val() );
       	});
		
		$("#datas").on("click", ".edit-href", function(){
			openEditData( $(this).attr("msgid") );
		});
		
		
		
		
		
	

		function openEditData( msgId ){
			$(".files").html("");
			$("#editForm").attr("action", updateUrl);
			$("#myModal").modal("show");
			$("#editForm").find("input,select,textarea").attr("disabled", false);
			$("#btn-ok").attr("disabled", false);
			
			//queryUser($(".ids_:checkbox:checked").val());
			editor.txt.clear();
			editor.$textElem.attr('contenteditable', true);
			
			queryRole();
			//将删除多余的多文件输入框。
			$(".diyFile").find('a[onclick="$deleteFile(this)"]').click();
			
			var obj = new Object();
			obj.url = queryUrl;
			obj.ext3 = "ext3";
			obj.id = msgId;
			
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					$("#editForm").fill(result.datas[0]);
					editor.txt.html(result.datas[0].msgContent);
					
					var orgIds = result.datas[0].ext4;
					if( orgIds && orgIds.length > 0 ){
						$("#ext1").val( orgIds );
					}else{
						$("#ext1").val("");
					}
					
					var orgNames = result.datas[0].ext6;
					if( orgNames && orgNames.length > 0 ){
						$("#orgNames").val( orgNames );
					}
					
					var roleIds = result.datas[0].ext5;
					if( roleIds && roleIds.length > 0 ){
						$("#ext2").selectpicker("val", roleIds.split(","));
					}else{
						$("#ext2").val("");
					}
					
					
					if("2" == result.datas[0].msgStatus) {
						$("#editForm").find("input,select,textarea").attr("disabled", true);
						$("#editForm").find(".selectpicker,.bs-searchbox input").attr("disabled", true);
						$("#btn-ok").attr("disabled", true);
						editor.$textElem.attr('contenteditable', false);
					}
					
					var files = result.datas[0].extMap.files;
					if(files && files.length > 0) {
						getFiles( files, $(".files"), false );
					}
				}
			});
		}
          
		$("#btn-delete").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size < 1) {
				layer.msg("请选择需要删除的数据！", {icon: 0});
				return;
			}
			
			layer.confirm('您确定要删除数据吗？', {icon: 3}, function() {
				var ids = [];
				$(".ids_:checkbox:checked").each(function(index, o){
					ids.push($(this).val());
				});
				var obj = new Object();
				obj.url = deleteUrl;
				obj.id = ids.join(",");
				ajax(obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						table.api().ajax.reload();
					}
				});
			});
		});
		
		$("#btn-ok").on("click", function() {
			
			var ext1Val = $("#ext1").val();
			var ext2Val = $("#ext2").selectpicker("val");
			
			if( ( !ext1Val || ext1Val.length <= 0 ) && ( !ext2Val || ext2Val.length <= 0 ) ){
				layer.msg("机构和角色至少需要指配一项!", {icon: 2});
				return;
			}
			
			if( ext1Val.length > 100000 ){// 成都2.6W不够，定西4w也不够
				layer.msg("机构指配太多,已超出容量上限,请精简后再提交!", {icon: 2});
				return;
			}
			
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				var obj = new Object();
				obj.msgContent = editor.txt.html();
				ajaxSubmit("#editForm", obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						$("#myModal").modal("hide");
						//$("#endTime").val( formatDate(new Date()) );   这个注解中的内容属于bug。逻辑不对
						table.api().ajax.reload();
					}
				});
			}
		});
		
		var orgAllLoadsetting = {
			async: {
				enable: true,
				url: queryOrgTreeUrl,
				autoParam:["id"],
				otherParam : { "flag_" : "tree", parentId: '-1'},
				dataFilter: function(treeId, parentNode, result) {
					if("error" != result.resCode) {
						return result;
					}
				}
			},
			check : {
				enable : true,
				chkStyle : "checkbox",
				chkboxType : {
					"Y" : "s",
					"N" : "ps"
				}
			},
			data : {
				key : {
					name : "orgName", title : "id"
				},
				simpleData : {
					enable : true,
					idKey : "id",
					pIdKey : "parentId",
				}
			},
			callback: {
				beforeAsync: beforeAsync,
				onAsyncSuccess: onAsyncSuccess,
				onAsyncError: onAsyncError,
				onCheck : onCheck
			}
		};
		
		function filter(treeId, parentNode, childNodes) {
			if (!childNodes) return null;
			for (var i=0, l=childNodes.length; i<l; i++) {
				childNodes[i].name = childNodes[i].name.replace(/\.n/g, '.');
			}
			return childNodes;
		}

		function beforeAsync() {
			curAsyncCount++;
		}
		
		var layerLoad = null;
		
		function onAsyncSuccess(event, treeId, treeNode, msg) {
			
			layerLoad = layer.load(2, {shade: [0.3, '#393D49']});
			
			msg = $.parseJSON( msg );
			if( "error" == msg.resCode) {
				layer.close(layerLoad);
				layer.msg("机构查询异常:"+msg.resMsg, {icon: 2});
				return;
			}
			
			curAsyncCount--;
			if ( curStatus == "expand" && treeNode && treeNode.children ) {
				expandNodes(treeNode.children);
			} else if ( curStatus == "async" && treeNode && treeNode.children ) {
				asyncNodes(treeNode.children);
			}
			if (curAsyncCount <= 0) {
				if (curStatus != "init" && curStatus != "") {
					asyncForAll = true;
					selectOrgNode();
				}
				curStatus = "";
				layer.close(layerLoad);
			}
		}

		function onAsyncError(event, treeId, treeNode, XMLHttpRequest, textStatus, errorThrown) {
			curAsyncCount--;
			if (curAsyncCount <= 0) {
				curStatus = "";
				if (treeNode!=null) asyncForAll = true;
			}
		}

		var curStatus = "init", curAsyncCount = 0, asyncForAll = false,
		goAsync = false;
		function expandAll() {
			if (!check()) {
				return;
			}
			var zTree = $.fn.zTree.getZTreeObj("orgDivTree");
			if (asyncForAll) {
				zTree.expandAll(true);
			} else {
				expandNodes(zTree.getNodes());
				if (!goAsync) {
					curStatus = "";
				}
			}
		}
		function expandNodes(nodes) {
			if (!nodes) return;
			curStatus = "expand";
			var zTree = $.fn.zTree.getZTreeObj("orgDivTree");
			for (var i=0, l=nodes.length; i<l; i++) {
				zTree.expandNode(nodes[i], true, false, false);
				if (nodes[i].isParent && nodes[i].zAsync) {
					expandNodes(nodes[i].children);
				} else {
					goAsync = true;
				}
			}
		}

		function asyncAll() {
			if (!check()) {
				return;
			}
			var zTree = $.fn.zTree.getZTreeObj("orgDivTree");
			if (asyncForAll) {
				
			} else {
				asyncNodes(zTree.getNodes());
				if (!goAsync) {
					curStatus = "";
				}
			}
		}
		function asyncNodes(nodes) {
			if (!nodes) return;
			curStatus = "async";
			var zTree = $.fn.zTree.getZTreeObj("orgDivTree");
			for (var i=0, l=nodes.length; i<l; i++) {
				if (nodes[i].isParent && nodes[i].zAsync) {
					asyncNodes(nodes[i].children);
				} else {
					goAsync = true;
					zTree.reAsyncChildNodes(nodes[i], "refresh", true);
				}
			}
		}
		function check() {
			if (curAsyncCount > 0) {
				return false;
			}
			return true;
		}
		
		function onCheck(){
			var zTree = $.fn.zTree.getZTreeObj("orgDivTree");
			var nodes = zTree.getNodesByParam("checked", true, null);
			var id = [],name = [];
			for( var i = 0 ; i < nodes.length ; i++ ){
				id.push( nodes[i].id );
				name.push( nodes[i].orgName );
			}
			$("#ext1").val( id.join(",") );
			$("#orgNames").val( name.join(",") );
		}
		
		function selectOrgNode(){
			var ids = $("#ext1").val();
			var zTree = $.fn.zTree.getZTreeObj("orgDivTree");
			if( zTree && ids && ids.length > 0 ){
				var idArr = ids.split(",");
				for( var i = 0 ; i < idArr.length ; i++ ){
					var node = zTree.getNodeByParam("id", idArr[i]);
					if( node && null != node ){
						zTree.checkNode(node, true, false);
					}
				}
			}
		}
		
		function bindOrgTreeEvent(){
			$("body").bind("mousedown", function(event) {
				if (!(event.target.id == "orgDiv"
						|| $(event.target).parents("#orgDiv").length > 0 
						|| event.target == $("#orgNames"))) {
						$("#orgDiv").fadeOut("fast");
						$("body").unbind("mousedown");
				}
			});
		}
		
		$("#orgNames").on("click", function() {
			orgDivTree = $.fn.zTree.init($("#orgDivTree"), orgAllLoadsetting);
			$("body").unbind("mousedown");
			if ($("#orgDiv").is(":hidden")) {
				$("#orgDiv ul").width(500).height(150);
				$("#orgDiv").css({
					left : "15px",
					top : "30px"
				}).fadeIn("fast", function() {
					orgDivTree = !orgDivTree ? $.fn.zTree.init($("#orgDivTree"), orgAllLoadsetting) : orgDivTree;
					$("#orgTreeKey").val("");
					idFuzzySearch("orgDivTree", "#orgTreeKey", false, false);
					asyncForAll = false;
					asyncAll();
/* 					setTimeout(function(){
						asyncForAll = false;
						asyncAll();
					}, 100); */
					setTimeout(function(){
						bindOrgTreeEvent();
					}, 1000);
				});
			}
			
		});
		
		
		
		try {
			E = window.wangEditor;
			editor = new E('.editor');
			editor.customConfig.uploadImgShowBase64 = true;
			editor.customConfig.menus = [
                'head',  // 标题
			    'bold',  // 粗体
			    'fontSize',  // 字号
			    'fontName',  // 字体
			    'italic',  // 斜体
			    'underline',  // 下划线
			    'strikeThrough',  // 删除线
			    'foreColor',  // 文字颜色
			    'backColor',  // 背景颜色
			    'link',  // 插入链接
			    'list',  // 列表
			    'justify',  // 对齐方式
			  //'emoticon',  // 表情
			    'image',  // 图片
			    'table',  // 表格
			    'code',  // 插入代码
			    'undo',  // 撤销
			    'redo'  // 重复
            ];
			editor.create();
			E.fullscreen.init('.editor');
		} catch(ex) {}
		
	});
	
	var queryUser = function(msgId) {
		var obj = new Object();
		obj.url = queryUserUrl;
		obj.rowValid = "1";
		obj.async = true;
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			} else {
				$("#users").empty();
			//	$("#users").append("<option value=''>请选择</option>");
				$.each(result.datas, function(i,o) {
					var orgName = o.extMap.org ? "-"+o.extMap.org.orgName : "";
					$("#users").append("<option value='"+o.id+"'>"+o.userName+"-"+o.userAlias+orgName+"</option>");
				});
				$("#users").selectpicker("render");
				$("#users").selectpicker("refresh");
				queryMsgRecord(msgId);
			}
		});
	}
	
	
	var queryRole = function(){
		var obj = new Object();
		obj.async = false;
		obj.url = queryRoleUrl;
		obj.rowValid = "1";
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg("角色查询异常:"+result.resMsg, {icon: 2});
			} else {
				$("#ext2").empty();
				$.each(result.datas, function(i,o) {
					$("#ext2").append("<option value='"+o.id+"'>"+o.roleName+"</option>");    
				});
				$("#ext2").selectpicker("render");
				$("#ext2").selectpicker("refresh");
			}
		});
	}
	
	var queryMsgRecord = function(msgId) {
		if(msgId) {
			var obj = new Object();
			obj.url = queryMsgRecordUrl;
			obj.msgId = msgId; 
			obj.flag_ = "all"; 
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					var users = [];
					$.each(result.datas, function(i,o) {
						users.push(o.userId);
					});
				    $("#users").selectpicker("val", users);
				}
			});
		}
	}

	var deleteFile = function(id) {
		if(id) {
			layer.confirm('您确定要删除数据吗？', {icon: 3}, function() {
				var obj = new Object();
				obj.url = deleteFileUrl;
				obj.id = id;
				ajax(obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						$("#"+id).html("");
						layer.msg("数据处理成功！", {icon: 1});
					}
				});
			});
		}
	}
	
	
	function exportOr(msgId){ 
		var exportMsgUrlPC = exportMsgUrl+'?msgId='+msgId+'&sysId='+sysId_;
		var exportMsgUrlWebPc = "exportRewardSurveyUrl.do";
		//导出 
		var portalUrl = '${s:getSysConstant("HOST_PORTAL")}'; 
		 
		window.open(exportMsgUrlPC);
	  
	}
	
	/**
	 * 取消webPC
	 */
	/* function exportOr(msgId){ 
		var exportMsgUrlPC = exportMsgUrl+'?msgId='+msgId+'&sysId='+sysId_;
		var exportMsgUrlWebPc = "exportRewardSurveyUrl.do";
		//导出 
		var portalUrl = '${s:getSysConstant("HOST_PORTAL")}'; 
		try {
			//pc端导出 
			var host = window.top.location.host; 
			if( host && portalUrl.indexOf(host) > -1 ){ 
				window.open(exportMsgUrlPC);
			}
		} catch (e) {
			//webpc导出 
			try { 
				var obj = new Object();
				obj.url = '${ctx}/api/sys/exportRewardSurveyUrl.do?msgId=' + msgId+'&sysId='+sysId_;
				obj.dataType = "html";
				obj.async = false;
				ajax(obj, function(result){
					//result = $.parseJSON(result);
					if ("error" == result.resCode) { 
						layer.msg(result.resMsg, {icon: 2});
					} else { 
						var filename = result.fileName;
						var realUrl = portalUrl+"/files/portal/"+sysId_+"/"+filename;
						var msg = {
						    "type": "DOWNLOAD_FILE",    //  当前操作名称
						    "data": realUrl,   //  对应的data，例如： 附件url、查看大图的url,
						    "original_name": "ORDER_SYSTEM"    //  当前iframe名称----不可随意修改
						};
						
						window.top.postMessage(JSON.stringify(msg),msgdownloadUrl);
					}
				});
			} catch (e) {
				layer.msg("操作失败!", {icon: 2});
			}
		}
	 
		
	} */
</script>
<style type="text/css">
.multiple {
	z-index: 10001!important;
}
</style>
<link href="${ctx}/js/tree/divTree.css" rel="stylesheet">
<%-- <script src="${ctx}/js/tree/orgTree.js"></script> --%>
</head>
<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-bell-o"></i> 消息列表</h5>
                    	<div class="ibox-tools">
	                        <a class="a-reload">
	                            <i class="fa fa-repeat"></i> 刷新
	                        </a>
	                    </div>
	                </div>
	                
                    <div class="ibox-content">
                        <!-- search star -->
						<div class="form-horizontal clearfix">
							<div class="col-sm-3 col-sm-offset-0 pl0">
								<button class="btn btn-sm btn-success" id="btn-insert">
									<i class="fa fa-plus"></i> 新增
								</button>
								<button class="btn btn-sm btn-success" id="btn-update">
									<i class="fa fa-edit"></i> 修改
								</button>
								<button class="btn btn-sm btn-success" id="btn-delete">
									<i class="fa fa-trash-o"></i> 删除
								</button>
							</div>
							
							<div class="col-sm-9 form-inline" style="padding-right:0; text-align:right">
								<form id="queryForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
								 	<c:if test="${myUser.user.org.ext1 ne 'CD'}">
									<s:dict dictType="msgType" clazz="input-sm form-control"/>
									</c:if>
									<input type="text" placeholder="关键字" class="input-sm form-control validate[custom[tszf]]" id="keywords" name="keywords">
	                                <input type="text" placeholder="开始时间" class="input-sm form-control date_select" id="startTime" name="startTime" readonly="readonly" value="${s:getDate('yyyy-MM-dd 00:00:00')}">
	                                <input type="text" placeholder="结束时间" class="input-sm form-control date_select" id="endTime" id="endTime" readonly="readonly" value="${s:getDate('yyyy-MM-dd 23:59:59')}">
	                                <button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
										<i class="fa fa-search"></i> 查询
									</button>
								</form>
							</div>
						</div>
						<!-- search end -->
                        
                        <table id="datas" class="table display" style="width:100%">
                            <thead>
                                <tr>
	                                <th><input type="checkbox" id="checkAll_" style="margin:0px;"></th>
									<th>标题</th>
									<%-- 成都消息通知不需要类型和级别 --%>
					  				<c:if test="${myUser.user.org.ext1 ne 'CD'}">
									<th>类型</th>
									<th>级别</th>
									</c:if>
									<th>修改时间</th>
									<th>状态</th>
									<th>查阅情况</th>
									<th>操作</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

	<!-- edit start-->
	<div class="modal fade" id="myModal" role="dialog" >
	    <div class="modal-dialog" style="width:70%;">
	        <div class="modal-content ibox">
	        	<form id="editForm" class="form-horizontal key-13" role="form" method="post" enctype="multipart/form-data">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i> 编辑数据</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
		            
		            <div class="ibox-content">
	                  <input type="text" id="id" name="id" style="display:none"/>
	                  <input type="text" id="sysId" name="sysId" value="${myUser.user.extMap.sys.id}" style="display:none"/>
	                  <input type="text" id="rowValid" name="rowValid" value="1" style="display:none"/>
	                  <input type="text" id="rowVersion" name="rowVersion" style="display:none"/>
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">标题</label>
					    <div class="col-sm-10">
					      <input type="text" class="input-sm form-control validate[required]" name="msgTitle" id="msgTitle" maxlength="64">
					    </div>
					  </div>
					  
					  <%-- 成都消息通知不需要类型和级别 --%>
					  <c:if test="${myUser.user.org.ext1 ne 'CD'}">
					  <div class="form-group">
					    <label class="col-sm-2 control-label">类型</label>
					    <div class="col-sm-4">
					      <s:dict dictType="msgType" clazz="input-sm form-control validate[required]"/>
					    </div>
					    <label class="col-sm-2 control-label">级别</label>
					    <div class="col-sm-4">
					      <s:dict dictType="msgLevel" clazz="input-sm form-control  validate[required]"></s:dict>
					    </div>
					  </div>
					  </c:if>
					 <c:if test="${myUser.user.org.ext1 eq 'CD'}">
					 	<input type="hidden" name="msgType" value='0'><!-- 属于无类型 -->
					 </c:if>
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">内容</label>
					    <div class="col-sm-10">
					      <div class="editor"></div>
					    </div>
					  </div>
					  
			          <div class="form-group">
						<label class="col-sm-2 control-label">附件</label>
						<div class="col-sm-10">
						  <input type="file" id="file" name="file" class="input-sm form-control" multiple="multiple"  accept=".xls,.xlsx,.doc,.txt,.pdf,.jpg,.jepg"/>
						</div>
					  </div>
					  
					  <div class="form-group" style="position:relative;">
	                	<label class="col-sm-2 control-label">机构指配</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control" name="orgNames" id="orgNames" readonly="readonly" >
					      <input type="text" name="ext1" id="ext1" class="input-sm form-control" style="display:none" >
					      <div id="orgDiv" style="display:none;position:absolute;z-index:8888">
							<input type="text" class="input-sm form-control" id="orgTreeKey" placeholder="输入机构代码进行搜索" />
							<ul id="orgDivTree" class="ztree divTree">
							</ul>
						  </div>
					    </div>
					    <label  class="col-sm-2 control-label">角色指配</label>
					    <div class="col-sm-4">
					      <select id="ext2" name="ext2" class="input-sm form-control selectpicker multiple"></select>
					      <!-- 
					      <input type="text" name="roleIds" id="roleIds" style="display:none" >
					      <input type="text" name="roleNames" id="roleNames" style="display:none" >
					      -->
					    </div>
		              </div>
					  
					  <div class="form-group">
					  	<!-- 
					    <label  class="col-sm-2 control-label">接收人</label>
					    <div class="col-sm-5">
					      <select id="users" name="users" class="form-control selectpicker multiple"></select>
					    </div>
					     -->
					    <label class="col-sm-2 control-label">状态</label>
					    <div class="col-sm-10">
					      <label><input type="radio" name="msgStatus" value="1" checked="checked">草稿</label>
					      <label><input type="radio" name="msgStatus" value="2">发布</label>
					    </div>
					  </div>

					  <div class="form-group">
					    <label class="col-sm-12 control-label files"></label>
					  </div>
		            </div>
							
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-ok">
		                	<i class="fa fa-check"></i> 确定
		                </button>
		                <button type="button" class="btn btn-sm btn-default" id="btn-cancel" data-dismiss="modal">
		                	<i class="fa fa-ban"></i> 取消
		                </button>
		            </div>
				</form>
	        </div>
	    </div>
	</div>
	<!-- edit end-->
	<!-- 
	<div id="orgDiv" style="display:none;position:absolute;z-index:8888">
		<input type="text" class="input-sm form-control" id="orgTreeKey" placeholder="输入机构代码进行搜索" />
		<ul id="orgDivTree" class="ztree divTree">
		</ul>
	</div>
	-->
</body>
</html>