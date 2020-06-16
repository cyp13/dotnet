<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
	var queryUrl = "${ctx}/jsp/jbpm/queryProcessDefinition.do";
	var deleteUrl = "${ctx}/jsp/jbpm/deleteProcessDefinition.do";
	var designerUrl = "${ctx}/jsp/jbpm/designer.jsp";
	var suspendDeploymentUrl = "${ctx}/jsp/jbpm/suspendDeployment.do";
	var resumeDeploymentUrl = "${ctx}/jsp/jbpm/resumeDeployment.do";
	var startProcessInstanceUrl = "${ctx}/jsp/jbpm/startProcessInstance.do";
	var importUrl = "${ctx}/jsp/jbpm/deploy.do";

	$(window).ready(function() {
		table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": true,
			"autoWidth": false,
			"processing": true,
			"serverSide": false,
			"ajax": {
				"dataSrc": "datas",
				"url": queryUrl
			},
			"aaSorting": [],
			"aoColumnDefs": [ {
				"bSortable": false,
				"aTargets": [ 0, 4, 5 ]
			}, {
				"targets": [ 0 ],
				"data":"deploymentId",
				"render": function (data, type, row) {
					return '<input type="checkbox" class="ids_" name="ids_" value="'+data+'" pdId="'+row.id+'" style="margin:0px;"/>';
				}
			}, {
				"targets": [ 1 ],
				"data": "id"
			}, {
				"targets": [ 2 ],
				"data": "version"
			}, {
				"targets": [ 3 ],
				"data": "deploymentTime"
			}, {
				"targets": [ 4 ],
				"data": "suspended",
				"render": function (data, type, row) {
					var s = '<span cursor onclick="updateState('+row.deploymentId+','+data+');" ';
					if(data) {
						s += 'style="color:#DAA520;cursor:pointer;"><i class="fa fa-pause-circle-o"></i> 挂起';	
					} else {
						s += 'style="color:#008B00;cursor:pointer;"><i class="fa fa-play-circle-o"></i> 正常';
					}
					return s + "<span/>";
				}
			}, {
				"targets": [ 5 ],
				"data": "description",
				"render": function (data, type, row) {
					return data ? data : "";
				}
			}]
		});
          
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				var param = {
					"pdId": $("#pdId_").val()
				};
				table.api().settings()[0].ajax.data = param;
				table.api().ajax.reload();
			}
       	});
		
		$("#btn-insert").on("click", function() {
			try {
				parent.menuItem("流程设计", designerUrl);
			} catch(e) {
				window.open(designerUrl);
			}
       	});

		$("#btn-update").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size != 1) {
				layer.msg("请选择需要修改的一行数据！", {icon: 0});
				return;
			}
			
			var deploymentId = $(".ids_:checkbox:checked").val();
			if(deploymentId) {
				try {
					parent.menuItem("流程设计", designerUrl+"?deploymentId="+deploymentId);
				} catch(e) {
					window.open(designerUrl+"?deploymentId="+deploymentId);
				}
			}
       	});

		<c:if test="${param.ifDelete eq 'true'}">
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
		</c:if>
		
		$("#btn-import").on("click", function() {
			$("#importForm").attr("action", importUrl);
			$("#importModal").modal("show");
		});
		
		$("#btn-import-ok").on("click", function() {
			var b = $("#importForm").validationEngine("validate");
			if(b) {
				ajaxSubmit("#importForm", function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						$("#importModal").modal("hide");
						table.api().ajax.reload();
					}
				});
			}
		});
		
		$("#btn-start").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size != 1) {
				layer.msg("请选择需要启动的一个流程！", {icon: 0});
				return;
			}
			
			var obj = new Object();
			obj.url = startProcessInstanceUrl;
			obj.sysId_ = "${myUser.user.extMap.sys.id}";
			obj.pdId = $(".ids_:checkbox:checked").attr("pdId");
			obj.owner_ = "${myUser.username}";
			
		//	obj.j = 1500;
		//	obj.roleNames_ = "dbca2965-6f86-4dc7-8490-4a9e04fd4630.超级管理员";
		//	obj.form_ = "${ctx}/jsp/report/report.do?rid=3e2b4136-0616-4fdf-b5bc-087e69d6675a&P_RES_ID=ccf08067-b426-45b9-810e-566eaae3143e&toolbar_=0";
		//	obj.orgIds_ = "0";
			
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
					return;
				} else {
					layer.msg("流程启动成功！", {icon: 1});
				}
			});
       	});
	});
		
	var updateState = function(deploymentId, suspended) {
		var msg = '您确定要恢复流程吗？';
		var obj = new Object();
		obj.id = deploymentId;
		if(suspended) {
			obj.url = resumeDeploymentUrl;
		} else {
			obj.url = suspendDeploymentUrl;
			msg = '您确定要挂起流程吗？';
		}
		layer.confirm(msg, {
			icon: 3
		}, function() {
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					layer.msg("数据处理成功！", {icon: 1});
					table.api().ajax.reload();
				}
			});
		});
	}
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-recycle"></i> 定义列表</h5>
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
	                
                    <div class="ibox-content">
                        <!-- search star -->
						<div class="form-horizontal clearfix key-13">
							<div class="col-sm-6 pl0">
								<a class="btn btn-sm btn-success " id="btn-insert">
									<i class="fa fa-plus"></i> 新增
								</a>
								<button class="btn btn-sm btn-success" id="btn-update">
									<i class="fa fa-edit"></i> 修改
								</button>
								<c:if test="${param.ifDelete eq 'true'}">
									<button class="btn btn-sm btn-success" id="btn-delete">
										<i class="fa fa-trash-o"></i> 删除
									</button> 
								</c:if>
								<!-- <button class="btn btn-sm btn-success" id="btn-import">
									<i class="fa fa-download"></i> 导入
								</button>
								<button class="btn btn-sm btn-success" id="btn-start">
									<i class="fa fa-play"></i> 测试
								</button> -->
							</div>
	
							<div class="col-sm-6 form-inline" style="padding-right:0; text-align:right">
								<form id="queryForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
									<input type="text" placeholder="流程定义" class="input-sm form-control validate[custom[tszf]]" id="pdId_">
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
									<th>流程定义</th>
									<th>版本</th>
									<th>发布时间</th>
									<th>状态</th>
									<th>描述</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- edit start-->
	<div class="modal fade" id="importModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:50%;">
	        <div class="modal-content ibox">
                <form id="importForm" class="form-horizontal key-13" role="form" >
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-download"></i> 导入数据</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
		            
		            <div class="ibox-content">
					  <div class="form-group">
					    <div class="col-sm-12">
					      <input type="file" name="file" id="file" class="validate[required]" accept=".xls,.xlsx">
					      <input type="text" name="sysId" value="${myUser.user.extMap.sys.id}" class="validate[required]" style="display: none;" >
					    </div>
					  </div>
		            </div>
		            
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-import-ok">
		                	<i class="fa fa-check"></i> 确定
		                </button>
		                <button type="button" class="btn btn-sm btn-default" id="btn-import-cancel" data-dismiss="modal">
		                	<i class="fa fa-ban"></i> 取消
		                </button>
		            </div>
				</form>
	        </div>
	    </div>
	</div>
</body>
</html>