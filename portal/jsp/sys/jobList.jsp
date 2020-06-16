<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
    var insertUrl = "${ctx}/jsp/sys/insertJob.do";
	var updateUrl = "${ctx}/jsp/sys/updateJob.do";
	var deleteUrl = "${ctx}/jsp/sys/deleteJob.do";
	var queryUrl = "${ctx}/jsp/sys/queryJob.do";

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
				"data":"jobName"
			}, {
				"targets": [ 2 ],
				"data":"cronExpression"
			}, {
				"targets": [ 3 ],
				"data":"beanMethod"
			}, {
				"targets": [ 4 ],
				"data":"sortNo"
			}, {
				"targets": [ 5 ],
				"data":"modified",
				"render": function (data, type, row) {
					return '<span title="'+row.modifier+'">'+data+'</span>';
				}
			}, {
				"targets": [ 6 ],
				"data":"extMap.rowValid",
				"render": function (data, type, row) {
					if("0" == row.rowValid) {
						return '<span style="color:#FF0000">'+data+'<span/>';	
					}
					return data;
				}
			}, {
				"targets": [ 7 ],
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

			$("#jobName").removeAttr("readonly");
			$("#sortNo").val("1");
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

			$("#jobName").attr("readonly","readonly");
			
			var obj = new Object();
			obj.url = queryUrl;
			obj.id = $(".ids_:checkbox:checked").val();
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					$("#editForm").fill(result.datas[0]);
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
		
		$("#btn-ok").click(function(){
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

		$("#btn-download").click(function(){
			if(!$("#jar").val()) {
				layer.msg("请选择jar！", {icon: 0});
				return false;
			}
			layer.confirm('如已有同名的jar将不会上传，上传后应用服务器可能需要重启，您确定要上传吗？', {
				icon: 3
			}, function() {
				var obj = new Object();
				obj.flag_ = "jar";
				$("#jarForm").attr("action", insertUrl);
				ajaxSubmit("#jarForm", obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						$("#jarForm")[0].reset();
						layer.msg("jar上传成功！", {icon: 1});
					}
				});
			});
		});
		
		$(".input-large").attr("title","如已有同名的jar将不会上传，上传后应用服务器可能需要重启，请慎重操作！");
		$(".input-large").attr("placeholder","如已有同名的jar将不会上传，上传后应用服务器可能需要重启，请慎重操作！");
	});
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-calendar-check-o"></i> 任务列表</h5>
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
									<th>任务名称</th>
									<th>Cron表达式</th>
									<th>方法名</th>
									<th>排序</th>
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
           		<div class="ibox-title">
                    <h5><i class="fa fa-pencil-square-o"></i> 编辑数据</h5>
                    <div class="ibox-tools">
                        <a class="close-link" data-dismiss="modal">
                            <i class="fa fa-times"></i>
                        </a>
                    </div>
                </div>
                
			  	<!-- <form id="jarForm" class="form-horizontal" role="form" onsubmit="return false;">
	            	<div class="ibox-content" style="padding: 15px 20px 0px 20px;">
	                  <div class="form-group">
					    <label class="col-sm-2 control-label">外部Jar</label>
					  	<div class="col-sm-8">
					      	<input type="file" name="jar" id="jar" accept=".jar">
					    </div>
					  	<div class="col-sm-2">
					      <button type="button" class="btn btn-sm btn-success" id="btn-download">
		                	<i class="fa fa fa-download"></i> 上传
		                  </button>
					    </div>
					  </div>
			    	</div>
			     </form> -->
			    
              	 <form id="editForm" class="form-horizontal key-13" role="form">
		            <div class="ibox-content">
					  <input type="text" id="id" name="id" style="display:none"/>
	                  <input type="text" id="sysId" name="sysId" value="${myUser.user.extMap.sys.id}" style="display:none"/>
	                  <input type="text" id="rowVersion" name="rowVersion" style="display:none"/>
	                  <input type="text" id="concurrentFlag" name="concurrentFlag" value="0" style="display:none"/>
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">任务名称</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="jobName" id="jobName" maxlength="16">
					    </div>
					    <label class="col-sm-2 control-label">Cron表达式</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="cronExpression" id="cronExpression" placeholder="0/1 * * * * ?" maxlength="32">
					    </div>
					  </div>
	
					  <div class="form-group">
					    <!-- <label class="col-sm-2 control-label">BeanId</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[groupRequired[bean]]" name="beanId" id="beanId" placeholder="BeanId或BeanClass选填其一" maxlength="16">
					    </div> -->
					    <label class="col-sm-2 control-label">类</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[groupRequired[bean]]" name="beanClass" id="beanClass"
					      value="cn.scihi.commons.util.HttpUtils"
					      placeholder="cn.scihi.sys.controller.Class" maxlength="64">
					    </div>
					    <label class="col-sm-2 control-label">方法</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]"
					      value="http"
					      name="beanMethod" id="beanMethod" maxlength="16">
					    </div>
					  </div>
	
					  <div class="form-group">
					    <label class="col-sm-2 control-label">参数</label>
					    <div class="col-sm-10">
					      <textarea class="form-control" name="parameters" id="parameters"></textarea>
					    </div>
					  </div>

					  <div class="form-group">
					  	<label  class="col-sm-2 control-label">排序号</label>
					    <div class="col-sm-4">
					      <input type="number" class="input-sm form-control validate[required,custom[integer]]" name="sortNo" id="sortNo" >
					    </div>
					    <label  class="col-sm-2 control-label">状态</label>
					    <div class="col-sm-4">
					      <label><input type="radio" name="rowValid" value="1" checked="checked">有效</label>
					      <label><input type="radio" name="rowValid" value="0">禁用</label>
					    </div>
					  </div>
	
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">备注</label>
					    <div class="col-sm-10">
					      <textarea class="form-control" name="remark" maxlength="200" id="remark"></textarea>
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