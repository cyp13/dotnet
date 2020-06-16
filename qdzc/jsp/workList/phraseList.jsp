<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
var insertUrl = "${ctx}/jsp/work/insertPhrase.do";
var updateUrl = "${ctx}/jsp/work/updatePhrase.do";
var deleteUrl = "${ctx}/jsp/work/deletePhrase.do";
var queryUrl = "${ctx}/jsp/work/queryPhrase.do";
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
 		var ifManager = false;//默认非管理员
 		var userRoles_ = '${myUser.extMap.roles}';
 		$.each(eval("("+userRoles_+")"),function(i,o){
 			if(managerRoleId_==o.id){//判断是否为系统管理员
 				$("#propRadio").removeClass("hide");
 				ifManager = true;
 				return false;
 			}
 		});
 		
		table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": false,
			"order":[[6,"desc"]],
			"autoWidth": false,
			"processing": true,
			"serverSide": true,
			  
			"ajax": {
				"dataSrc": "Rows",
				"type":"post",
				"url": queryUrl,
				"data":{"userName":userName_,
					"corporate_identify":enterprise_flag_
				}  
			},
			"aoColumnDefs": [ {
				"targets": [ 0 ],
				"data":"id",
				"orderable": false,
				"render": function (data, type, row) {
					var s = '<input type="checkbox" ';
					if("1" == row.property&&!ifManager) {//非管理员无权限修改公共数据
						s = s + 'disabled="disabled" '; 
					} else {
						s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
					}
					return s +'style="margin:0px;"/>';
				}
			}, {
				"targets": [ 1 ],
			
				"data":"title"
			}, {
				"targets": [ 2 ],
				"data":"corporate_identify"
				
			}, {
				"targets": [ 3 ],
				"data":"type_name"
				
			}, {
				"targets": [ 4 ],
			
				"data":"property_name"
			}, {
				"targets": [ 5 ],
			
				"data":"modifier",
				
			}, {
				"targets": [ 6 ],
			
				"data":"modified",
				
			},{
				
				"targets": [ 7 ],
				"data":"row_valid_name",
					"render": function (data, type, row) {
						if("0" == row.row_valid) {
							return '<span style="color:red">禁用<span/>';	
						} else {
							return '启用';
						}
					}
			}]
		});
		
        
		$("#btn-query").on("click", function() {
			var param = {
				"keywords": $("#keywords").val(),
				 "userName": userName_   
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
	                    <h5><i class="fa fa-leanpub"></i> 常用语列表</h5>
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
								<input type="text" placeholder="标题" class="input-sm form-control" id="keywords">
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
	                                <th>标题</th>
									<th>企业标识</th>
									<th>类型</th>
									<th>属性</th>
									<th>修改人</th>
									<th>修改时间</th>
									<th>状态</th>
									
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
	                  <input type="number" id="rowVersion" name="rowVersion" style="display:none"/>
	                  <input type="text" id="parentId" name="parentId" style="display:none"/>
	                  <input type="text" id="corporate_identify" value="${myUser.org.ext1}"  name="corporate_identify" style="display:none"/>
	                  
					  <div class="form-group">
					   <label class="col-sm-2 control-label">标题</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="title" id="title" >
					    </div>
					    <div id="propRadio" class="hide">
					     <label  class="col-sm-2 control-label">属性</label>
						    <div class="col-sm-4">
						      <s:dict dictType="phraseProperty" value="2" type="radio" name="property"></s:dict>
						    </div>
					   </div>
					  </div>
					  
					  <div class="form-group">
					  	
					  	 <label  class="col-sm-2 control-label">类型</label>
					    	<div class="col-sm-4">
					      	<s:dict dictType="phraseType" type="radio" name="type"></s:dict>
					    </div>
					  <label  class="col-sm-2 control-label">状态</label>
							    <div class="col-sm-4">
							      <s:dict dictType="rowValid" type="radio" name="row_valid"></s:dict>
							 </div>
					   
					  </div>
	
						  <div class="form-group">
						    <label  class="col-sm-2 control-label">内容</label>
						    <div class="col-sm-10">
						      <textarea rows="5" class="form-control validate[required]" style="resize:none"  name="content" id="content" ></textarea>
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