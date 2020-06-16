<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
	var queryUrl = "${ctx}/jsp/sys/queryDs.do";
    var insertUrl = "${ctx}/jsp/sys/insertDs.do";
	var updateUrl = "${ctx}/jsp/sys/updateDs.do";
	var deleteUrl = "${ctx}/jsp/sys/deleteDs.do";

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
				"url": queryUrl
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
				"data":"dsName"
			}, {
				"targets": [ 2 ],
				"data":"dsType",
				"render": function (data, type, row) {
					if("1" == data) {
						return "数据库";
					}
					return data;
				}
			}, {
				"targets": [ 3 ],
				"data":"url",
				"render": function (data, type, row) {
				//	return data;
					return '<div style="width:300px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;" title="'+data+'">'+data+'</div>'; 
				}
			}, {
				"targets": [ 4 ],
				"data":"modified",
				"render": function (data, type, row) {
					return '<span title="'+row.modifier+'">'+data+'</span>';
				}
			}, {
				"targets": [ 5 ],
				"data":"extMap.rowValid",
				"render": function (data, type, row) {
					if("0" == row.rowValid) {
						return '<span style="color:#FF0000">'+data+'<span/>';	
					}
					return data;
				}
			}, {
				"targets": [ 6 ],
				"data":"remark",
				"render": function (data, type, row) {
					return data ? data : "";
				}
			}]
		});
        
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				var param = {};
				param.keywords = $("#keywords").val();
				table.api().settings()[0].ajax.data = param;
				table.api().ajax.reload();
			}
       	});
		
		$("#btn-insert").on("click", function() {
			$("#editForm")[0].reset();
			$("#editForm").attr("action", insertUrl);
			$("#myModal").modal("show");
			$("#dsType").change();
       	});

		$("#btn-update").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size != 1) {
				layer.msg("请选择需要修改的一行数据！", {icon: 0});
				return;
			}

			$("#editForm")[0].reset();
			$("#editForm").attr("action", updateUrl);
			$("#myModal").modal("show");

			var obj = new Object();
			obj.url = queryUrl;
			obj.id = $(".ids_:checkbox:checked").val();
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					$("#editForm").fill(result.datas[0]);
					$("#dsType").change();
				}
			});
       	});
          
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
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				ajaxSubmit("#editForm", function(result) {
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
		
		$("#dsType").change(function () {
			var dsType = $(this).val();
			if("1" == dsType) {
				$(".driver").html("驱动程序");
				$("#driverClass").addClass("validate[required]");
				$("#userName").addClass("validate[required]");
				$("#password").addClass("validate[required]");
			} else if("2" == dsType) {
				$(".namespace").html("名称空间");
				$("#driverClass").removeClass("validate[required]");
				$("#userName").removeClass("validate[required]");
				$("#password").removeClass("validate[required]");
			}
		});
	});
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-database"></i> 服务源列表</h5>
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
						<div class="form-horizontal clearfix">
							<div class="col-sm-6 col-sm-offset-0 pl0">
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
							
							<div class="col-sm-6 form-inline" style="padding-right:0; text-align:right">
								<form id="queryForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
									<input type="text" placeholder="关键字" class="input-sm form-control validate[custom[tszf]]" id="keywords">
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
									<th>服务源名称</th>
									<th>类型</th>
									<th>URL</th>
									<th>修改时间</th>
									<th>状态</th>
									<th>备注</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

	<!-- edit start-->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:70%;">
	        <div class="modal-content ibox">
                <form id="editForm" class="form-horizontal key-13" role="form">
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
	                  <input type="text" id="rowVersion" name="rowVersion" style="display:none"/>
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">服务源名称</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="dsName" id="dsName" maxlength="16">
					    </div>
					    <label class="col-sm-2 control-label">类型</label>
					    <div class="col-sm-4">
					      <select id="dsType" name="dsType" class="input-sm form-control">
					      	<option value="1">数据库</option>
					      </select>
					    </div>
					  </div>

					  <div class="form-group">
					    <label  class="col-sm-2 control-label">URL</label>
					    <div class="col-sm-10">
					      <input type="text" class="input-sm form-control validate[required]" name="url" id="url" >
					    </div>
					  </div>
					  
					  <div class="form-group">
					  	<label class="col-sm-2 control-label driver namespace">驱动程序</label>
					    <div class="col-sm-10">
					      <input type="text" class="input-sm form-control validate[required]" name="driverClass" id="driverClass" >
					    </div>
					  </div>
	
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">用户名</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="userName" id="userName" maxlength="16">
					    </div>
					    <label  class="col-sm-2 control-label">口令</label>
					    <div class="col-sm-4">
					      <input type="password" class="input-sm form-control validate[required]" name="password" id="password" maxlength="16" autocomplete="off">
					    </div>
					  </div>

					  <div class="form-group">
					    <label  class="col-sm-2 control-label">状态</label>
					    <div class="col-sm-4">
					      <label><input type="radio" name="rowValid" value="1" checked="checked">有效</label>
					      <label><input type="radio" name="rowValid" value="0">禁用</label>
					    </div>
					  </div>
	
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">备注</label>
					    <div class="col-sm-10">
					      <textarea class="form-control" name="remark" maxlength="200" id="remark" ></textarea>
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
</body>
</html>