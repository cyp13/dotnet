<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<link href="${ctx}/js/plugins/select/bootstrap-select.css" rel="stylesheet"  />
<script src="${ctx}/js/plugins/select/bootstrap-select.js"></script>
<script src="${ctx}/js/plugins/select/defaults-zh_CN.js"></script>
<script>
	var queryTaskUrl = "${ctx}/api/jbpm/queryTask.do";
	var insertAssigneeUrl = "${ctx}/api/jbpm/insertAssignee.do";
	var updateAssigneeUrl = "${ctx}/api/jbpm/updateAssignee.do";
	var completeTaskUrl = "${ctx}/api/jbpm/completeTask.do";

	var sysId = "${myUser.user.extMap.sys.id}";
	sysId=""==sysId?"${myUser.user.sysId}":sysId;
		
	var queryUserUrl = "${ctx}/api/sys/queryUser.do";
	if("true" == "${myUser.user.userName ne s:getSysConstant('ADMIN_USER')}") {
		queryUserUrl+=("true"=="${s:getProp('sys.aync')}"?"":"?sysId="+sysId);
	}
	var table, complateMap, complateModel;
	var portal_local_ = '${s:getDict("host","zhu")}';
	$(window).ready(function() {
		//取消new
		parent.cancelNew();
		$.ajax({
			url: '${ctx}/js/jbpm/json/complateModel.json'
			,type: 'get', dataType: 'json', async: false
			,success: function(data){
				complateModel = data;
			}
			,error: function(arg1, arg2, arg3){
			}
		});
		table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"aLengthMenu" : [20, 50, 100], //更改显示记录数选项  
            "iDisplayLength" : 20, //默认显示的记录数
			"searching": false,
			"ordering": true,
			"autoWidth": false,
			"processing": true,
			"serverSide": false,
			"stateSave":true,
			"ajax": {
				"dataSrc": "datas",
				"url": queryTaskUrl,
				"data": function (d) {
					return $.extend( {}, d, {
						"sysId": sysId,
						"userName" : "${myUser.username}"
					});
				}
			},
			"aaSorting": [[ 5, "asc" ]],
			"aoColumnDefs": [ {
				"bSortable": false,
				"aTargets": [ 0, 1, 2, 3, 4, 6, 7, 8, 9, 10 ]
			}, {
				"targets": [ 0 ],
				"data":"id",
				"title":"<input type=\"checkbox\" id=\"checkAll_\" style=\"margin:0px;\">",
				"render": function (data, type, row) {
					var s = '<input type="checkbox" ';
					if('suspended' == row.state) {
						s = s + 'disabled="disabled" '; 
					} else {
						s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
					}
					return s +'style="margin:0px;"/>';
				}
			}, {
				"targets": [ 1 ],
				"data":"formCode",
				"title":"工单号",
				"render": function (data, type, row) {
					if(data){
						return "<span title='"+row.eId+"'>"+data+"</span>";
					}
				}
			}, {
				"targets": [ 2 ],
				"data":"pId",
				"title":"工单类型",
				"render": function (data, type, row) {
					var pdName = data.substring(0,data.lastIndexOf("."));
					var formTypeSmall = row['formTypeSmall'];
					if(formTypeSmall){
						pdName = pdName + '(' + formTypeSmall + ')';
					}
					return "<span title='"+row.pdId+"'>"+pdName+"</span>";
				//	return "<span title='"+row.pdId+"'>"+data.substring(0,data.indexOf("."))+"</span>";
				}
			}, {
			<c:if test="${'MY' eq myUser.user.extMap.org.ext1 || 'LUZ' eq myUser.user.extMap.org.ext1}">
				"targets": [ 3 ],
				"data":"formTitle",
				"title":"工单关键字",
				"render": function (data, type, row) {
					if(data){
						return data;
					}
				}
			}, {
			</c:if>
			<c:if test="${'GY' eq myUser.user.extMap.org.ext1}">
				"targets": [ 3 ],
				"data":"formTitle",
				"title":"工单主题",
				"render": function (data, type, row) {
					if(data){
						return data;
					}
				}
			}, {
			</c:if>
				"targets": [ 4 ],
				"data":"userAlias",
				"title":"发起人",
				"render": function (data, type, row) {
					if(data) {
						return "<span title='"+row.owner+"'>"+data+"</span>";
					} else {
						return row.owner;
					}
				}
			}, {
				"targets": [ 5 ],
				"data":"createTime",
				"title":"开始时间"
			}, {
				"targets": [ 6 ],
				"data":"name",
				"title":"环节",
				"render": function (data, type, row) {
					var assignee = row.assignee ? row.assignee : "";
					return "<span title='"+assignee+"'>"+data+"</span>";
				}
			}, {
				"targets": [ 7 ],
				"title":"<span title='分钟'>剩余时长</span>",
				"render": function (data, type, row) {
					try{
						if(row.priority && 0 != row.priority) {
							var currDate = new Date().getTime() - new Date(row.createTime).getTime();
							currDate = row.priority - currDate/60/1000;
							if(currDate > 0) {
								return "<span title='时效："+row.priority+"分钟'>"+parseInt(currDate)+"</span>";
							}
							return "<span style='color:#DAA520' title='时效："+row.priority+"分钟'>"+parseInt(currDate)+"</span>";
						}
						return "<span>-</span>";
					} catch (e) {}
				}
			}, {
				"targets": [ 8 ],
				"data":"assigneeDesc",
				"title":"处理人",
				"render": function (data, type, row) {
					if(!data){
						return '';
					}else{
						var assignee = row.assignee ? row.assignee : "";
						return "<span title='"+assignee+"'>"+data+"</span>";
					}
				}
			}, {
				"targets": [ 9 ],
				"data":"state",
				"title":"状态",
				"render": function (data, type, row) {
					if(data) {
						var taskId = row.id ? row.id : "";
						if('suspended' == data) {
							return "<span style='color:#DAA520' title='"+taskId+"'><i class='fa fa-pause-circle-o'></i> 挂起</span>";
	                    } else {
	                    	return "<span style='color:#008B00' title='"+taskId+"'><i class='fa fa-play-circle-o'></i> 正常</span>";
	                    }
					}
					return "";
				}
			}, {
				"targets": [ 10 ],
				"title":"操作",
				"render": function (data, type, row) {
					return '<a onclick="actionUrl(this)" action-id="${ctx}/api/jbpm/taskInfo.do?procdefid_='+row.pdId+'&pId='+encodeURI(row.pId)+'&taskId='+row.id+'&page=${param.page}" href="javascript:void(0)">详情</a>';
				}
			}, {
				"targets": [ 11 ],
				"data":"detail_",
				"title":"工单概况",
				"render": function (data, type, row) {
					var r = '';
					for(var key in data){
						r += key + ': ' + data[key] + '; ';
					}
					return r;
				}
			}]
			,"initComplete": function( settings, json ) {
				$("#checkAll_,.checkAll_").on("click", function() {
					$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
				});
				var tableDatas = json.datas;//待办列表数据
				complateMap = new Object();//筛选后的数据complateMap，先new一个空
				var dataRow, dataPtype, dataNode;
				for(var i in tableDatas){//遍历待办列表
					dataRow = tableDatas[i];//获取一条待办
					dataPtype = dataRow['pId'].substring(0,dataRow['pId'].lastIndexOf("."));//本条待办的ptype
					dataNode = dataRow['name'];//本条待办的node
					if(!complateMap[dataPtype]){//如果complateMap中没有该ptype
						var found = false;
						for(var ctype in complateModel){//并且在配置中有该ptype，则将ptype放入结果
							found = (dataPtype==ctype);
							if(found){//标记设置为找到
								break;
							}
						}
						if(found){//如果找到，则创建一个数组，用于存放node
							complateMap[dataPtype] = new Array();
						}
					}
					if(!complateMap[dataPtype]){//如果没找到，说明未配置，则跳过
						continue;
					}
					var found = false;
					for(var cnodei in complateModel[dataPtype]){//在配置文件中遍历
						var cnode = complateModel[dataPtype][cnodei];
						if(dataNode==cnode.name){//找到本node
							found = cnode;
							break;
						}
					}
					if(found){//如果找到
						var gogogo = true;
						for(var index in complateMap[dataPtype]){//判断complateMap中是否已存在该节点
							if(found==complateMap[dataPtype][index]){
								gogogo = false;//存在则跳过
							}
						}
						if(gogogo){//不跳过则新增
							complateMap[dataPtype].push(found);
						}
					}
				}
				for(var ptypeTmp in complateMap){//将complateMap中的空的ptype移除
					if(complateMap[ptypeTmp].length<=0){
						delete complateMap[ptypeTmp];
					}
				}
				var showBatch = false;//默认不展示相关组件
				var ptype, node;
				for(var ptypeTmp in complateMap){
					if(ptype != ptypeTmp){
						showBatch = true;
						ptype = ptypeTmp;
						$('#ptype').append('<option value="'+ptype+'">'+ptype+'</option>');
					}
				}
				$('#ptype').change(function(){
					var value = $(this).val();
					$('.added').remove();
					for(var i in complateMap[value]){
						var row = complateMap[value][i];
						$('#node').append('<option class="added" value="'+row.name+'" complateType="' + row.type + '">'+row.name+'</option>');
					}
				});
				$('#node').change(function(){
					$('#btn-query').click();
				});
				if(showBatch){
					$('.showBatch').css('visibility', 'visible');
				}
			}
		});
        
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				var param = {
					"sysId": sysId,
					"userName" : "${myUser.username}",
					"keywords": $("#keywords").val(),
					"PROCDEFID_": $("#PROCDEFID_").val()
					, "ptype": $('#ptype').val()
					, "node": $('#node').val()
				};
				table.api().settings()[0].ajax.data = param;
				table.api().ajax.reload();
			}
       	});
		
		$(".set-user").on("click", function() {
			var val = $(".ids_:radio:checked").val();
            if(!val) {
            	if("btn-update" == this.id) {
	            	layer.msg("请选择需要转办的数据！", {icon: 0});
            	} else {
	            	layer.msg("请选择需要加签的数据！", {icon: 0});
	            }
				return;
            }
            
			$("#editForm")[0].reset();
			if("btn-update" == this.id) {
				$("#id").val("btn-update");
				$("#user-s").css("display", "block");
				$("#users-s").css("display", "none");
			} else {
				$("#id").val("btn-insert");
				$("#user-s").css("display", "none");
				$("#users-s").css("display", "block");
			}
			$("#myModal").modal("show");
			queryUser(this.id);
       	});

		$("#btn-complete").on("click", function() {
			var val = $(".ids_:radio:checked").val();
            if(!val) {
            	layer.msg("请选择需要处理的数据！", {icon: 0});
				return;
            }
			$("#completeForm")[0].reset();
            $("#completeModal").modal("show");

            $("#result").val("完成");
    		$("#result").attr("placeholder", "完成、回退、驳回、终止");
    		$("#desc").attr("placeholder", "请输入意见");
            queryUser(this.id);
       	});
		
		$("#btn-ok").on("click", function() {
			var url = insertAssigneeUrl;
			if("btn-update" == $("#id").val()) {
				$("#userNames").val($("#user").val());
				url = updateAssigneeUrl;
			} else {
				$("#userNames").val($("#users").val());
			}
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				var obj = new Object();
				obj.url = url;
				obj.taskId = $(".ids_:radio:checked").val();
				obj.userName = $("#userNames").val();
				ajax(obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						$("#myModal").modal("hide");
						table.api().ajax.reload();
					}
				});
			}
		});

		$("#btn-complete-ok").on("click", function() {
			var b = $("#completeForm").validationEngine("validate");
			if(b) {
				var obj = new Object();
				obj.url = completeTaskUrl;
				obj.taskId = $(".ids_:radio:checked").val();
				obj.userName = "${myUser.username}";
				obj.assignee = $("#assignee").val();
				obj.result = $("#result").val();
				obj.desc = $("#desc").val();
				ajax(obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						$("#completeModal").modal("hide");
						table.api().ajax.reload();
					}
				});
			}
		});

		var preUrl = document.referrer;
		if(preUrl.indexOf("taskInfo.do")==-1){
			var s = "${s:getDate('yyyyMMdd')}";
			$("#keywords").val(s);
			//当前页面不是从返回页面来  //此次报错，不清楚原因，如有其他问题请查询验证
			//table.clear().draw();
			//table.api().state.clear(); 
			//table.api().ajax.reload()
		}else{
			
			}
		
	});



	function actionUrl($this){
		var action_url = $($this).attr("action-id");//需要跳转的url地址
		window.location.href=action_url;
		}


	
	var queryUser = function(id) {
		var obj = new Object();
		obj.url = queryUserUrl;
		obj.rowValid = "1";
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			} else {
				$("#user").empty();
				$("#users").empty();
				$("#assignee").empty();
				var select;
				if("btn-update" == id) {
					$("#myModal h5").html("<i class='fa fa-share'></i> 转办");
					select = $("#user");
					$("#user").append("<option value=''>请选择（必选）</option>");
				} else if("btn-insert" == id) {
					$("#myModal h5").html("<i class='fa fa-user-plus'></i> 加签");
					select = $("#users");
				} else if("btn-complete" == id) {
					select = $("#assignee");
					$("#assignee").append("<option value=''>下一任务处理人（非必选）</option>");    
				}
				if(select) {
					$.each(result.datas, function(i, o) {
					//	select.append("<option value='"+o.id+"'>"+o.givenName+"</option>");
						var orgName = o.extMap.org ? "-"+o.extMap.org.orgName : "";
						select.append("<option value='"+o.userName+"'>"+o.userName+"-"+o.userAlias+orgName+"</option>");
					});
					select.selectpicker({
					//	actionsBox: true,
						style: "btn-white"
					});
					select.selectpicker("render");
					select.selectpicker("refresh");
				}
			}
		});
	}
var type;
function doBatchView(){
	var selectedRows = table.fnGetNodes();
	var selectedPtype, selectedNode;
	for(var i in selectedRows){
		var row = selectedRows[i];
		if($(row).find('.ids_:checkbox:checked').length>0){
			var dataRow = table.fnGetData(row);
			var dataPtype = dataRow['pId'].substring(0,dataRow['pId'].lastIndexOf("."));
			var dataNode = dataRow['name'];
			selectedPtype = selectedPtype?selectedPtype:dataPtype;
			selectedNode = selectedNode?selectedNode:dataNode;
			if(selectedPtype!=selectedPtype || selectedNode!=dataNode){
				layer.msg('请选择相同的流程和节点进行处理', {icon: 0});
				return;
			}
		}
	}
	var found = false;
	for(var i in complateMap){
		if(selectedPtype==i){
			for(var j in complateMap[i]){
				if(selectedNode==complateMap[i][j]['name']){
					type = complateMap[i][j]['type'];
					found = true;
					break;
				}
			}
		}
		if(found){
			break;
		}
	}
	if(!found){
		layer.msg('不支持批量处理：' + selectedPtype + '-' + selectedNode, {icon: 0});
		return;
	}
	var taskIds= '';
	$(".ids_:checkbox:checked").each(function(){
		taskIds += $(this).val() + ',';
	});
	if(!taskIds || taskIds.length<=0){
		layer.msg('未选择任何任务', {icon: 0});
		return;
	}
	$("#model-" + type).modal("show");
}
function doBatchComplateNormal(result){
	var b = $("#model-" + type).find('form').validationEngine("validate");
	if(!b) {
		return;
	}
	var obj = new Object();
	obj.url = completeTaskUrl;
	var taskIds = '';
	$(".ids_:checkbox:checked").each(function(){
		taskIds += $(this).val() + ',';
	});
	obj.taskId = taskIds;
	obj.userName = "${myUser.username}";
	obj.result = result;
	obj.desc = $("#model-" + type).find('textarea[name=desc]').val();
	ajax(obj, function(result) {
		if ("error" == result.resCode) {
			layer.msg(result.resMsg, {icon: 2});
		} else {
			layer.msg("数据处理成功！", {icon: 1});
			$("#model-" + type).modal("hide");
			table.api().ajax.reload();
		}
	});
}
function doBatchComplateNormalGiveMoney(result){
	var b = $("#model-" + type).find('form').validationEngine("validate");
	if(!b) {
		return;
	}
	var obj = new Object();
	obj.url = completeTaskUrl;
	var taskIds = '';
	$(".ids_:checkbox:checked").each(function(){
		taskIds += $(this).val() + ',';
	});
	obj.taskId = taskIds;
	obj.action = '同意'==result?'同意':'不同意';
	obj.userName = "${myUser.username}";
	obj.result = result;
	obj.desc = $("#model-" + type).find('textarea[name=desc]').val();
	ajax(obj, function(result) {
		if ("error" == result.resCode) {
			layer.msg(result.resMsg, {icon: 2});
		} else {
			layer.msg("数据处理成功！", {icon: 1});
			$("#model-" + type).modal("hide");
			table.api().ajax.reload();
		}
	});
}
</script>
<style type="text/css">
.showBatch{
	visibility: hidden;
}
</style>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
                	
                	<c:if test="${'mywork' ne param.page}">
	   					<div class="ibox-title">
		                    <h5><i class="fa fa-flag-o"></i> 待办列表</h5>
	                    	<div class="ibox-tools">
		                        <a class="a-reload">
		                            <i class="fa fa-repeat"></i> 刷新
		                        </a>
		                        <!-- <a class="collapse-link">
		                            <i class="fa fa-chevron-up"></i>
		                        </a>
		                        <a class="close-link">
		                            <i class="fa fa-times"></i>
		                        </a> -->
		                    </div>
		                </div>
                	</c:if>
	                
                    <div class="ibox-content">
                        <!-- search star -->
						<div class="form-horizontal clearfix key-13">
							<div class="col-sm-2 pl0 form-inline">
						   		<button class="btn btn-sm btn-success showBatch" onclick="doBatchView();">
									<i class="fa fa-check-square-o"></i> 批量处理
								</button>
							</div>
	
							<div class="col-sm-10 form-inline" style="padding-right:0; text-align:right">
							   	<form id="queryForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
							   		<select class="input-sm form-control showBatch" id="ptype">
							   			<option value="">请选择工单类型</option>
							   		</select>
							   		<select class="input-sm form-control showBatch" id="node">
							   			<option value="">请选择节点</option>
							   		</select>
								   	<input type="hidden" placeholder="超类" class="input-sm form-control" id="PROCDEFID_">
								   	<input type="text" placeholder="关键字" class="input-sm form-control validate[custom[tszf]]" id="keywords">
	                             	<button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
										<i class="fa fa-search"></i> 查询
									</button>
								</form>
							</div>
						</div>
						<!-- search end -->
                        
                        <table id="datas" class="table display" style="width:100%">
                            <!-- <thead>
                                <tr>
	                                <th><input type="radio" disabled="disabled" style="margin:0px;"/></th>
									<th>工单号</th>
									<th>工单类型</th>
									<th>发起人</th>
									<th>开始时间</th>
									<th>环节</th>
									<th>处理人</th>
									<th>状态</th>
									<th>操作</th>
                                </tr>
                            </thead> -->
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- edit start-->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:60%;">
	        <div class="modal-content ibox">
                <form id="editForm" class="form-horizontal key-13" role="form">
	           		<div class="ibox-title">
	                    <h5>转办/加签</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
		            
		            <div class="ibox-content">
	                  <input type="text" id="id" name="id" style="display:none"/>
		                  
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">人员信息</label>
					    <div class="col-sm-10">
					      <span id="user-s">
					      	<select id="user" name="user" class="input-sm form-control" data-live-search="true"></select>
					      </span>
					      <span id="users-s">
					      	<select id="users" name="users" class="input-sm form-control" data-live-search="true" multiple></select>
					      </span>
					      <input type="text" class="input-sm form-control" name="userNames" id="userNames" style="display:none" >
					    </div>
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

    <!-- edit start-->
	<div class="modal fade" id="completeModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:60%;">
	        <div class="modal-content ibox">
	            <form id="completeForm" class="form-horizontal key-13" role="form">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-check-square-o"></i> 处理</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
		            
		            <div class="ibox-content">
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">处理方式</label>
					    <div class="col-sm-10">
					      <input type="text" id="result" name="result" class="form-control validate[required]" list="datalist_result" title="完成、回退、驳回、终止">
						  <datalist id="datalist_result" style="display:none">
							<option value="完成">
							<option value="回退">
							<option value="驳回">
							<option value="终止">
						  </datalist>
					    </div>
					  </div>

					  <div class="form-group">
					    <label  class="col-sm-2 control-label">责任人</label>
					    <div class="col-sm-10">
					      <select id="assignee" name="assignee" class="form-control" data-live-search="true"></select>
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">意见</label>
					    <div class="col-sm-10">
					      <textarea class="form-control" rows="3" name="desc" id="desc" ></textarea>
					    </div>
					  </div>
		            </div>
		            
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-complete-ok">
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
</body>

<div class="modal fade" id="model-normal" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:40%; margin-top: 200px;">
	<div class="modal-content ibox">
	<form id="form-normal" class="form-horizontal key-13" role="form">
		<div class="ibox-title">
			<h5><i class="fa fa-pencil-square-o"></i> 批量审批</h5>
			<div class="ibox-tools">
				<a class="close-link" data-dismiss="modal">
				<i class="fa fa-times"></i>
				</a>
			</div>
		</div>
		<div class="ibox-content">
			<div class="form-group">
				<div class="col-sm-12">
					<textarea class="form-control validate[required]" name="desc" placeholder="请输入意见" rows="5" autofocus="autofocus" maxlength="500"></textarea>
				</div>
			</div>
			<div class="form-group">
				<div class="col-sm-12" style="text-align: center;">
					<button type="button" class="btn btn-sm btn-success btn-13" onclick="doBatchComplateNormal('同意');">
					<i class="fa fa-check"></i> 同意
					</button>
					<button type="button" class="btn btn-sm btn-success btn-13" onclick="doBatchComplateNormal('驳回');">
						<i class="fa fa-close"></i> 驳回
					</button>
				</div>
			</div>
		</div>
	</form>
	</div>
	</div>
</div>

<div class="modal fade" id="model-NormalGiveMoney" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:40%; margin-top: 200px;">
	<div class="modal-content ibox">
	<form id="form-NormalGiveMoney" class="form-horizontal key-13" role="form">
		<div class="ibox-title">
			<h5><i class="fa fa-pencil-square-o"></i> 批量审批</h5>
			<div class="ibox-tools">
				<a class="close-link" data-dismiss="modal">
				<i class="fa fa-times"></i>
				</a>
			</div>
		</div>
		<div class="ibox-content">
			<div class="form-group">
				<div class="col-sm-12">
					<textarea class="form-control validate[required]" name="desc" placeholder="请输入意见" rows="5" autofocus="autofocus" maxlength="500"></textarea>
				</div>
			</div>
			<div class="form-group">
				<div class="col-sm-12" style="text-align: center;">
					<button type="button" class="btn btn-sm btn-success btn-13" onclick="doBatchComplateNormalGiveMoney('同意');">
					<i class="fa fa-check"></i> 同意
					</button>
					<button type="button" class="btn btn-sm btn-success btn-13" onclick="doBatchComplateNormalGiveMoney('驳回');">
						<i class="fa fa-close"></i> 驳回
					</button>
				</div>
			</div>
		</div>
	</form>
	</div>
	</div>
</div>

</html>