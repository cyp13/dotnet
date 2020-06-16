<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<jsp:include page="/jsp/apply/xiezuoBase.jsp"></jsp:include>
<script>
var queryUrl = "${ctx}/jsp/work/queryCarry.do";

var queryTaskHisUrl = host_+"/api/jbpm/queryHisTask.do";
var queryXiezuoHisUrl = "${ctx}/jsp/work/queryCarryExt.do";
var pid = '${param.pId}';

var downloadUrl = host_+"/api/sys/downloadFile.do";

var table;
var zpTable;

 	$(window).ready(function() {
 		//默认不能编辑
 		$(".dataForm input,.dataForm textarea").attr('readonly','readonly');
 		$(".dataForm select,.dataForm input[type='radio']").attr('disabled','disabled');
 		
 		//填充数据
 		if(pid){
			var obj = new Object();
			//实例ID
			obj.pid=pid;
			obj.url=queryUrl;
			obj.token=token_;
			ajax(obj, function(data){
				var row = data.Rows[0];
				$("#editForm").fill(row);
				if(row.opinions){
					getOpinionsAndFiles(row.opinions,"#filesAndOpinion",1);
				}
				if(row.ext2){
					$("#zpry").removeClass("hide");
				}
				if(row.tag_ifsuccess){
					$("#tag").removeClass("hide");
				}
			});
		}
 		//获取任务历史
 		queryHisTask();
 		//转派历史
 		queryZPHisTask();
		
 	});
 	
 	var queryHisTask = function() {
 		table = $("#datas").dataTable({
 			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
 			"dom": 'rt<"bottom"iflp<"clear">>',
 			"pagingType": "full_numbers",
 			"bLengthChange": false,
 			"searching": false,
 			"info": false,
 			"paging":false,
 			"ordering": true,
 			"order":[[0,"asc"],[1,"asc"]],
 			"autoWidth": false,
 			"processing": true,
 			"serverSide": false,
 			"ajax": {
 				"dataSrc": "datas",
 				"url": queryTaskHisUrl,
 				"data": function (d) {
 					return $.extend( {}, d, {
 						"pId" : "${param.pId}",
 						"token":token_,
 						"sysId":sysId_
 					});
 				}
 			},
 			"aaSorting": [],
 			"aoColumnDefs": [ {
 				"bSortable": false
 				
 			},  {
 				"targets": [ 0 ],
 				"data":"create",
 				"render": function (data, type, row) {
 					return data;
 				}
 			}, {
 				"targets": [ 1 ],
 				"data":"end",
 				"render": function (data, type, row) {
 					return data ? data : "";
 				}
 			}, {
 				"targets": [ 2 ],
 				"data":"userAlias",
 				"orderable":false,
 				"render": function (data, type, row) {
 					var desc = row.desc;
 					if(desc&&desc.indexOf("会签")>-1){
 						var arr = desc.split("-");
 						if(arr.length>2){
 							return arr[2];
 						}else{
 							var userAlias = row.userAlias ? row.userAlias : row.assignee;
 		 					return userAlias ? userAlias : "";
 						}
 					}else{
	 					var userAlias = row.userAlias ? row.userAlias : row.assignee;
	 					return userAlias ? userAlias : "";
 					}
 				}
 			}, {
 				"targets": [ 3 ],
 				"data":"result",
 				"orderable":false,
 				"render": function (data, type, row) {
 					if('不同意' == data || '回退' == data || '驳回' == data || '终止' == data || '结束' == data || '撤回' == data || '驳回归档' == data) {
 						return "<span style='color:#FF0000'>"+data+"</span>";
 	                }
 					return data ? data : "";
 				}
 			}, {
 				"targets": [ 4 ],
 				"data":"desc",
 				"orderable":false,	
 				"width":"40%",
 				"render": function (data, type, row) {
 					if(data) {
 						if(row.activityName=="协作人员"&&data.indexOf("会签")>-1){
 	 						var arr = data.split("-");
 	 						if(arr.length==4){
 	 							return '<div style="overflow:hidden;" title="'+arr[3]+'">'+arr[3]+'</div>';
 	 						}
 	 					}else{
	 						return '<div style="overflow:hidden;" title="'+data+'">'+data+'</div>';
 	 					}
 					}
 					return "";
 				}
 			}]
 		});
 	}
 	
	var queryZPHisTask = function() {
		zpTable = $("#zp_datas").dataTable({
 			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
 			"dom": 'rt<"bottom"iflp<"clear">>',
 			"pagingType": "full_numbers",
 			"bLengthChange": false,
 			"searching": false,
 			"info": false,
 			"paging":false,
 			"ordering": true,
 			"order":[[0,"asc"],[1,"asc"]],
 			"autoWidth": false,
 			"processing": true,
 			"serverSide": false,
 			"ajax": {
 				"dataSrc": "Rows",
 				"url": queryXiezuoHisUrl,
 				"data": function (d) {
 					return $.extend( {}, d, {
 						"pId" : "${param.pId}",
 						"token":token_,
 					});
 				}
 			},
 			"aaSorting": [],
 			"aoColumnDefs": [ {
 				"bSortable": false
 				
 			},  {
 				"targets": [ 0 ],
 				"data":"created",
 				"render": function (data, type, row) {
 					return data;
 				}
 			}, {
 				"targets": [ 1 ],
 				"data":"execute_time",
 				"render": function (data, type, row) {
 					return data ? data : "";
 				}
 			}, {
 				"targets": [ 2 ],
 				"data":"org_name",
 				"orderable":false,
 				"render": function (data, type, row) {
 					return data ? data+"("+row.org_id+")" : "";
 				}
 			}, {
 				"targets": [ 3	 ],
 				"data":"role_name",
 				"orderable":false,
 				"render": function (data, type, row) {
 					return data ? data : "";
 				}
 			}, {
 				"targets": [ 4 ],
 				"data":"status",
 				"orderable":false,
 				"render": function (data, type, row) {
 					if("1"==data){
 						return "<span style='color:#FF0000'>待处理</span>";
 					}else if("2"==data){
 						return "<span class='green'>已处理</span>";
 					}
 					return "";
 				}
 			}, {
 				"targets": [ 5 ],
 				"data":"executor_name",
 				"orderable":false,
 				"render": function (data, type, row) {
 					return data ? data : "";
 				}
 			}, {
 				"targets": [ 6 ],
 				"data":"result",
 				"orderable":false,
 				"render": function (data, type, row) {
 					if('不同意' == data || '回退' == data || '驳回' == data || '终止' == data || '结束' == data || '撤回' == data || '驳回归档' == data) {
 						return "<span style='color:#FF0000'>"+data+"</span>";
 	                }
 					return data ? data : "";
 				}
 			}, {
 				"targets": [ 7 ],
 				"data":"opinion",
 				"orderable":false,	
 				"width":"40%",
 				"render": function (data, type, row) {
 					if(data) {
 						return '<div style="overflow:hidden;" title="'+data+'">'+data+'</div>';
 					}
 					return "";
 				}
 			}]
 		});
 	};
 	
	
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
			
		            <div class="ibox-content">
                       <form id="editForm"  class="form-horizontal key-13" >
			                  <input type="text" id="id" name="id" style="display:none"/>
			                  <div class="dataForm">
							   <div class="form-group">
							   		 <label class="col-sm-2 control-label">工单主题</label>
								    <div class="col-sm-4">
								    	<s:dict dictType="carry_title" name="title" type="select" clazz="validate[required] form-control" ></s:dict>
								    </div>
								    <label class="col-sm-1 control-label">工单编号</label>
								    <div class="col-sm-4">
								    	<input class="input-sm form-control validate[required] readonly" name="form_code" id="form_code"/>
								    </div>
							   </div>
							  <div class="form-group">
								  <label class="col-sm-2 control-label">区县</label>
								    <div class="col-sm-4">
								    	<input type="text" class="input-sm form-control readonly"  name="county_name" id="county_name" readonly>
								    	<input type="text" class="hide" name="county" id="county" >
								    </div>
							  
							    <label class="col-sm-1 control-label">分局</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control readonly"  name="branch_office_name"  id="branch_office_name" readonly>
							    	<input type="text" class="hide" name="branch_office" id="branch_office" >
							    </div>
							  </div>
		
							  <div class="form-group">
							    <label class="col-sm-2 control-label">发起人</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control readonly"  name="publisher" id="publisher" readonly>
							    </div>
							    <label class="col-sm-1 control-label">发起时间</label>
							    <div class="col-sm-4">
							    	<input type="text"  readonly="readonly"  class="input-sm  form-control readonly"  name="publish_time" id="publish_time" >
							    </div>
							  </div>
		
							  <div class="form-group">
							    <label class="col-sm-2 control-label">联系方式</label>
							    <div class="col-sm-4">
							     	<input type="number" class="input-sm form-control readonly"   readonly name="user_phone" id="user_phone" >
							    </div>
							    <label class="col-sm-1 control-label">工单类型</label>
							    <div class="col-sm-4">
							    	<s:dict dictType="xzgd_type" clazz="form-control validate[required]" name="service_type"></s:dict>
							   		<input type="text" class="hide" id="service_type_name" name="service_type_name" />
							    </div>
							    </div>
							    
							   <div class="form-group">
							     <label class="col-sm-2 control-label">完成时限</label>
							    <div class="col-sm-4">
							    	<input type="text"  readonly="readonly"  class="input-sm  form-control date_time" format="yyyy-MM-dd"  name="finish_date" id="finish_date" >
							    </div>
							  </div>
							
							  <div class="form-group">
							    <label  class="col-sm-2 control-label">描述说明</label>
							    <div class="col-sm-9">
							      <textarea rows="5" class="form-control validate[required]" name="description" id="description" maxlength="200"></textarea>
							    </div>
							  </div>
							  <div class="form-group hide" id="tag">
							  <label  class="col-sm-2 control-label">是否成功办理</label>
							    <div class="col-sm-9">
							      <input type="text" class="input-sm form-control " id="tag_ifsuccess" name="tag_ifsuccess" />
							    </div>
							  </div>
							  <div class="form-group hide" id="zpry">
							    <label  class="col-sm-2 control-label">转派人员</label>
							    <div class="col-sm-9">
							      <textarea rows="5" class="form-control " name="ext2" id="ext2" ></textarea>
							    </div>
							  </div>
							   <div class="form-group">
								<label class="col-xs-2 control-label">附件：</label>
								<div class="col-xs-9 control-label" id="fileList" style="text-align: left;">
								</div>
							</div>
								<div id="filesAndOpinion"></div>
							  </div>
						 </div>
						 <fieldset>
						   	<legend>转派详情</legend>
							   <table id="zp_datas" class="table display" style="width:100%">
				                  <thead>
				                      <tr>
										<th>开始时间</th>
										<th>结束时间</th>
										<th>转派机构</th>
										<th>转派人员（角色）</th>
										<th>处理状态</th>
										<th>处理人</th>
										<th>结果</th>
										<th>意见</th>
				                      </tr>
				                  </thead>
				              </table>
				              </fieldset>
						 
						    <fieldset>
						   	<legend>任务历史</legend>
							   <table id="datas" class="table display" style="width:100%">
				                  <thead>
				                      <tr>
										<th>开始时间</th>
										<th>结束时间</th>
										<th>处理人</th>
										<th>结果</th>
										<th>意见</th>
				                      </tr>
				                  </thead>
				              </table>
				              </fieldset>
							</form>
			            </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>