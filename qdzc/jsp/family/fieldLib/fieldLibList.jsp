<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
	var fieldLibListUrl = "${ctx}/FCFieldLib/FCFieldLibList.do";
	var fieldAddOrUpdateUrl = "${ctx}/FCFieldLib/fieldAddOrUpdate.do";
	var queryFieldById =  "${ctx}/FCFieldLib/queryFieldById.do";
	var deleteFieldById = "${ctx}/FCFieldLib/deleteFieldById.do";
	var table = $("#datas");
	$(window).ready(function() {
		/* var now = formatDate(new Date(),"yyyy-MM-dd");
		var firstDay = formatDate(new Date(),"yyyy-MM")+"-01"; */
		/* layer.alert('功能临时下线', {icon: 6},
				function () {
		            window.history.back(-1); 
		        }); */
        layer.alert(
                '功能临时下线', 
                {icon: 2,closeBtn: 0 },
                function () {
                    console.info('');
                    window.close();
                });
		
		return;
		 table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": false,
			"autoWidth": false,
			"processing": true,
			"serverSide": true,
			"ajax": {
				"dataSrc": "data",
				"url": fieldLibListUrl,
				"data":{
					"queryStatus":0
				}
			},
			"aaSorting": [[ 0, "asc" ]],
			"aoColumnDefs": [ {
				"bSortable": false,
				//"aTargets": [ 0, 1, 2, 4, 5, 7 ]
			}, {
				"targets": [ 0 ],
				"data":"id",
			}, {
				"targets": [ 1 ],
				"data":"name"
			},{
				"targets": [ 2 ],
				"data":"CREATER"
			}, {
				"targets": [ 3 ],
				"data":"CREATED"
			}, {
				"targets": [ 4 ],
				"data":"status"
			},{
				"targets": [ 5 ],
				"data":"id",
				 "render":function (data, type, row) {
					console.log(type);
					 if(row.status=='启用'){
						 return '<a id="fieldDelete" data-val="'+row.id+'" data-status="'+row.status+'" onclick="deleteField(this);" >禁用</a>'
						 		+'|'
								+'<a id="fieldUpdate" data-val="'+row.id+'" onclick="updateField(this);" >修改</a>';
					 }else{
						 return '<a id="fieldDelete" data-val="'+row.id+'"  data-status="'+row.status+'" onclick="deleteField(this);" >启用</a>'
						 		+'|'
								+'<a id="fieldUpdate" data-val="'+row.id+'" onclick="updateField(this);" >修改</a>';
					 }
					
				}
			}]
			   
		});
        
		//添加
		$("#btn-add").on("click",function(){
			$("#editForm")[0].reset();
			$("#editForm").attr("action",fieldAddOrUpdateUrl );
			$("#myModal").modal("show");
		});
		
		//删除
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
				obj.url = deleteFCUrl;
				obj.ids = ids.join(",");
				ajax(obj, function(data) {
					if ("error" == data.code) {
						layer.msg(data.msg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						table.api().ajax.reload();
					}
				});
			});
		});
		

		$(".date_time").on("click", function() {
			var thiz = $(this);
			var other_date = $(this).attr("other_date");
			var format = $(this).attr("format");
			var date = formatDate(new Date());
			if(!format){
				format = "yyyy-MM-dd HH:mm:ss";
			}
			WdatePicker({
				dateFmt:format,
				onpicked:function(dp){
	 				dateChange(thiz,other_date);
				},
				maxDate:date
			});
		});
		
		function dateChange(ele,other_date){
			if(other_date&&$(other_date).val()){
				switch (other_date) {
				case "#end_date":
					if($(ele).val()>$(other_date).val()){
						alert("开始时间不能大于结束时间");
						$(ele).val("");
						return;
					}
					break;
					
				case "#start_date":
					if($(ele).val()<$(other_date).val()){
						alert("开始时间不能大于结束时间");
						$(ele).val("");
						return;
					}
					
					break;

				default:
					break;
				}
			}
		}
		
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
		
		$("#btn-export").on("click", function() {
			location.href = exportUrl+"?start_date="+$("#start_date").val()+"&end_date="+$("#end_date").val();
		});
		
		$("#btn-ok").on("click", function() {
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				ajaxSubmit("#editForm", function(data) {
					if ("error" == data.code) {
						layer.msg(data.msg, {icon: 2});
					}else if("1" == data.code){
						layer.msg(data.msg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						$("#myModal").modal("hide");
						table.api().ajax.reload();
					}
				});
			}
		});
		
		$("#btn-clear").on("click",function(){
			$("#start_date").val("");
			$("#end_date").val("");
			$("#phone_no").val("");
		});
		
	/* 	$("#queryStatus").on("onchange",function(){
			
		}); */
		
	});
	function updateField(aval){
		aval = $(aval);
		console.log(aval.attr("data-val"));
		$.ajax({
            type: "GET",
            url: queryFieldById,
            data: {"id":aval.attr("data-val")},
            success: function(data){
           	var resObj = eval('(' + data + ')');
               if(resObj.code == '0'){
            	 $("#editForm")[0].reset();
            	 $("#myModal").modal("show");
            	 $("#editForm").attr("action",fieldAddOrUpdateUrl );
           		 $("#id").val(resObj.ret.id);
           		 $("#name").val(resObj.ret.name);
               }else if (resObj.code != '1') {
            	   layer.msg(data.msg, {icon: 2});
				}else{
					error(data.msg);
				}
            }
        }); 
	};
	
	function deleteField(aval){
		aval = $(aval);
		//console.log(aval.attr("data-val"));
		$.ajax({
            type: "GET",
            url:deleteFieldById ,
            data: {"id":aval.attr("data-val"),"status":aval.attr("data-status")},
            success: function(data){
            	layer.msg("数据处理成功！", {icon: 1});
				$("#importModal").modal("hide");
				//table.api().ajax.reload();
				window.location.reload();
            }
        }); 
	};
	
	function queryStatus(){
		var param = {
				"queryStatus": $("#queryStatus").val(),
			};
			table.api().settings()[0].ajax.data = param;
			table.api().ajax.reload();
	}
	
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeInDown">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-history"></i> 字段库管理列表</h5>
                    	<div class="ibox-tools">
	                        <a class="a-reload">
	                            <i class="fa fa-repeat"></i> 刷新
	                        </a>
	                    </div>
	                </div>
	                
                    <div class="ibox-content">
                        <!-- search star -->
						<div class="form-horizontal clearfix key-13">
							<div class="col-sm-3 pl0">
								<button class="btn btn-sm btn-success" id="btn-add">
									<i class="fa fa-edit"></i> 添加
								</button>
							</div>
	
						</div>
						<div class="col-sm-9 form-inline" style="padding-right:0; text-align:right">
								<label id="lable-query" style="font-size:16px;">
									 状态查询
								</label>
									<select id="queryStatus" onchange="queryStatus()" class="btn btn-sm btn-success btn-13" >
										<option value="0">启用</option>
										<option value="1">禁用</option>
										<option value="all">全部</option>
									</select>
                                <!-- <button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
									<i class="fa fa-search"></i> 查询
								</button>
								 <button id="btn-clear" type="button" class="btn btn-sm btn-clear btn-13">
									清除
								</button> -->
							</div>
						<!-- search end -->
                        
                        <table id="datas" class="table display" style="width:100%">
                            <thead>
                                <tr>
									<th>ID</th>
									<th>字段名称</th>
									<th>创建人</th>
									<th>创建时间</th>
									<th>状态</th>
									<th>操作</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" >
    	<div class="modal-dialog" style="width:70%;">
    	<div class="modal-content ibox">
                <form id="editForm" class="form-horizontal key-13" role="form">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i> 编辑数据</h5>
	                </div>
	
		            <div class="ibox-content">
	                  <input type="text" id="id" name="id" style="display:none"/>
   						<legend>字段库</legend> 
					  <div class="form-group">
							<label class="col-sm-1 control-label">字段名称</label>
						    <div id="inpDiv" class="col-sm-4">
						    	<input type="text" class="input-sm form-control validate[required]" maxlength="6" name="name" id="name" >
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
					    <label class="col-sm-2 control-label">
					    	<a href="${ctx}/files/templet/phone_number_templet.xlsx">模板下载</a>
					    </label>
					    <div class="col-sm-10">
					      <input type="file" name="file" id="file" class="validate[required]">
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