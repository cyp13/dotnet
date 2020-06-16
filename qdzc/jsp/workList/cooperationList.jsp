<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
var insertUrl = "${ctx}/jsp/work/insertCooperation.do";
var updateUrl = "${ctx}/jsp/work/updateCooperation.do";
var deleteUrl = "${ctx}/jsp/work/deleteCooperation.do";
var queryUrl = "${ctx}/jsp/work/queryCooperation.do";
var subUrl = "${ctx}/jsp/work/subCooperation.do";
var table ;
function sub(id){
	layer.confirm('确认提交吗？', {icon: 3}, function() {
		var obj = new Object();
		obj.url = subUrl;
		obj.id = id;
		obj.flag = "1";
		ajax(obj, function(data) {
			if ("error" == data.resCode) {
				layer.msg(data.resMsg, {icon: 2});
			} else {
				layer.msg("数据处理成功！", {icon: 1});
				table.api().ajax.reload();
			}
		});
	});
}

 	$(window).ready(function() {
		table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": true,
			"order":[[1,"desc"]],
			"autoWidth": false,
			"processing": true,
			"serverSide": true,
			"ajax": {
				"dataSrc": "Rows",
				"type":"post",
				"url": queryUrl
			},
			"aoColumnDefs": [ {
				"targets": [ 0 ],
				"data":"id",
				"orderable": false,
				"render": function (data, type, row) {
					var s = '<input type="checkbox" ';
					if("3" == row.status) {
						s = s + 'disabled="disabled" '; 
					} else {
						s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
					}
					return s +'style="margin:0px;"/>';
				}
			}, {
				"targets": [ 1 ],
				"data":"county_name"
			}, {
				"targets": [ 2 ],
				"data":"branch_office_name",
				"render": function (data, type, row) {
					data = data ? data : "";
					return '<div class="a-copy" style="width:150px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;" title="'+data+'" >'+data+'</div>'; 
				}
			}, {
				"targets": [ 3 ],
				"data":"channel_name",
				"render": function (data, type, row) {
					data = data ? data : "";
					return '<div class="a-copy" style="width:150px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;" title="'+data+'" >'+data+'</div>'; 
				}
			}, {
				"targets": [ 4 ],
				"data":"channel_phone"
			}, {
				"targets": [ 5 ],
				"data":"user_phone"
			}, {
				"targets": [ 6 ],
				"data":"service_type_name"
			}, {
				"targets": [ 7 ],
				"data":"created"
			}, {
				"targets": [ 8 ],
				"data":"id",
				"orderable": false,
				"render":function (data, type, row) {
					var rs = '<a class="showDetail" data-id="'+data+'">详情</a>';
					if(row.status=='1'){
						rs+='<br><a style="color:red;" onclick="sub(\''+row.id+'\')">提交审核</a>';
					}
					return rs;
				}
			}]
		});
		
        
		$("#btn-query").on("click", function() {
			var param = {
				"keywords": $("#keywords").val()
			};
			table.api().settings()[0].ajax.data = param;
			table.api().ajax.reload();
       	});
		
		$("#btn-insert").on("click", function() {
			$("#editForm")[0].reset();
			$("#editForm").attr("action", insertUrl);
			$("#myModal").modal("show");

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
			ajax(obj, function(data) {
				if ("error" == data.resCode) {
					error(data.resMsg);
					//layer.msg(data.resMsg, {icon: 2});
				} else {
					$("#editForm").fill(data.Rows[0]);
					setDataToSelect(data.Rows[0]);
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
				ajax(obj, function(data) {
					if ("error" == data.resCode) {
						layer.msg(data.resMsg, {icon: 2});
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
				ajaxSubmit("#editForm", function(data) {
					if ("error" == data.resCode) {
						layer.msg(data.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						$("#myModal").modal("hide");
						table.api().ajax.reload();
					}
				});
			}
		});
 	});
	
</script>
<style type="text/css">
	ul.ztree {
		width: 232px;
		height: 300px;
		border: 1px solid #ccc;
		background: #f9f9f9;
		overflow: auto;
	}
</style> 
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeInDown">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-leanpub"></i> 运维建议计划列表</h5>
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
								<input type="text" placeholder="年度" class="input-sm form-control" id="keywords">
                                <button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
									<i class="fa fa-search"></i> 查询
								</button>
							</div>
						</div>
						<!-- search end -->
                        
                        <table id="datas" class="table display" style="width:100%">
                            <thead>
                                <tr>
	                                <th><input type="checkbox" id="checkAll_" style="margin:0px;"></th>
									<th>区县</th>
									<th>分局</th>
									<th>渠道</th>
									<th>渠道联系号码</th>
									<th>用户号码</th>
									<th>业务类型</th>
									<th>创建时间</th>
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
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:70%;">
	        <div class="modal-content ibox">
                <form id="editForm" class="form-horizontal key-13" role="form">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i> 编辑数据</h5>
	                </div>
	
		            <div class="ibox-content">
	                  <input type="text" id="id" name="id" style="display:none"/>
	                  
					  <div class="form-group">
					 
						  <label class="col-sm-2 control-label">区县</label>
						    <div class="col-sm-4">
						    	<input type="text" class="input-sm form-control validate[required]" name="county" id="county" readonly>
						    </div>
					  
					    <label class="col-sm-2 control-label">分局</label>
					    <div class="col-sm-4">
					    	<input type="text" class="input-sm form-control validate[required]" name="branch_office" id="branch_office" readonly>
					    </div>
					  </div>

					  <div class="form-group">
					    <label class="col-sm-2 control-label">渠道</label>
					    <div class="col-sm-4">
					    	<input type="text" class="input-sm form-control validate[required]" name="channel" id="channel" readonly>
					    </div>
					 
					    <label class="col-sm-2 control-label">渠道联系方式</label>
					    <div class="col-sm-4">
					     	<input type="number" class="input-sm form-control validate[required]"  readonly name="channel_phone" id="channel_phone" >
					    </div>
					 
					  </div>
					  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">业务类型</label>
					    <div class="col-sm-4">
					    	<s:dict dictType="phraseType" clazz="form-control" name="service_type"/>
					    </div>
					    <div id="ywxl" class="hide">
					    	 <label class="col-sm-2 control-label">业务小类</label>
					    	 <select id="service_type_detail" class="form-control validate[required] selectpicker" name="service_type_detail"></select>
					    </div>
					  </div>

					  <div class="form-group">
					  	<label class="col-sm-2 control-label">用户手机号码</label>
					    <div class="col-sm-4">
					    	<input type="text" class="input-sm form-control validate[required]" name="user_phone" id="user_phone" readonly>
					    </div>
					  </div>
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">堵点描述</label>
					    <div class="col-sm-10">
					      <textarea rows="5" class="form-control validate[required]" name="problem" id="problem" ></textarea>
					    </div>
					  </div>
					   <div class="form-group">
					   	<label  class="col-sm-2 control-label">文件上传</label>
					    <div class="col-sm-10">
					    	<input type="file" class="input-sm form-control" name="file" id="file" >
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