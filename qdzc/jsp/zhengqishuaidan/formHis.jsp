<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
var queryUrl = "${ctx}/jsp/work/queryGovEntAgency.do";
var queryTaskHisUrl = host_+"/api/jbpm/queryHisTask.do";
var pid = '${param.pId}';
var flag = '${param.flag}';
var taskId = '${param.taskId}';
 	$(window).ready(function() {
 		//默认不能编辑
 		$(".dataForm input,.dataForm textarea").attr('readonly','readonly');
 		$(".dataForm select,.dataForm input[type='radio']").attr('disabled','disabled');
 		
 		$("#flag").val(flag);
 		$("#taskId").val(taskId); 
 		$("#pid").val(pid); 
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
				if(row.service_type_detail){
					$("#service_type").change();
					$("#service_type_detail").val(row.service_type_detail);
				}
				if(row.files){
					getFiles(row.files,"#fileList",1);
					
				}
				if(row.service_type){
					$("#ywlx").removeClass('hide');
					
				}
				console.log(row.tag_ifsuccess);
				console.log(typeof row.tag_ifsuccess);
				if (row.tag_ifsuccess != "" && row.tag_ifsuccess !=null) {
 					$("#tag_ifsuccess").attr('disabled','disabled');
				}else {
					$(".tag_ifsuccess").remove();
				}
			});
		}
 		
 		//获取任务历史
 		queryHisTask();
 		
 		//业务类型联动
			$("#service_type").on("change",function(){
	 			if($(this).val()){
	 				var dictType = $("#service_type option:checked").data("id");
	 				getDictToPage(dictType,"#service_type_detail");
	 			}
	 			else{
	 				$("#service_type_detail").html("");
	 			}
	 		});
 		
			
		
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
 					var userAlias = row.userAlias ? row.userAlias : row.assignee;
 					return userAlias ? userAlias : "";
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
 						return '<div style="overflow:hidden;" title="'+data+'">'+data+'</div>';
 					}
 					return "";
 				}
 			}]
 		});
 	}
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
			                  <input type="text" id="pid" name="pid" style="display:none"/>
			                  <input type="text" id="flag" name="flag" style="display:none"/>
			                  <input type="text" id="taskId" name="taskId" style="display:none"/>
			                  <div class="dataForm">
							  <div class="form-group">
							   		 <label class="col-sm-2 control-label">工单主题</label>
								    <div class="col-sm-4">
								    	<input class="input-sm form-control validate[required]" name="title" id="title"/>
								    </div>
								    <label class="col-sm-1 control-label">工单编号</label>
								    <div class="col-sm-4">
								    	<input class="input-sm form-control validate[required] readonly" name="form_code" id="form_code"/>
								    </div>
							   </div>
							  <div class="form-group">
								  <label class="col-sm-2 control-label">区县</label>
								    <div class="col-sm-4">
								    	<input type="text" class="input-sm form-control readonly" value="${myUser.extMap.org.extMap.parent.extMap.parent.orgName}" name="county_name" id="county_name" readonly>
								    	<input type="text" class="hide" name="county" id="county" value="${myUser.extMap.org.extMap.parent.extMap.parent.id}">
								    </div>
							  
							    <label class="col-sm-1 control-label">分局</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control readonly" value="${myUser.extMap.org.extMap.parent.orgName}" name="branch_office_name"  id="branch_office_name" readonly>
							    	<input type="text" class="hide" name="branch_office" id="branch_office" value="${myUser.extMap.org.extMap.parent.id}">
							    </div>
							  </div>
		
							  <div class="form-group">
							    <label class="col-sm-2 control-label">渠道</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control readonly" value="${myUser.extMap.org.orgName}" name="channel_name" id="channel_name" readonly>
							    </div>
							    <label class="col-sm-1 control-label">渠道编码</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control readonly" value="${myUser.extMap.org.id}" name="channel"  id="channel" readonly>
							    </div>
							  </div>
		
							  <div class="form-group">
							    <label class="col-sm-2 control-label">渠道联系方式</label>
							    <div class="col-sm-4">
							     	<input type="number" class="input-sm form-control readonly" value="${myUser.extMap.org.outsideLine}"  readonly name="channel_phone" id="channel_phone" >
							    </div>
							 	<label class="col-sm-1 control-label">用户手机号码</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control validate[required,custom[mobile]]" name="user_phone" id="user_phone">
							    </div>
							  </div>
		
							  <div class="form-group">
							    
							  	<label class="col-sm-2 control-label">代办业务名称</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control validate[required]" name="service_name" id="service_name">
							    </div>
							    <label class="col-sm-1 control-label">违约金金额</label>
							    <div class="col-sm-4">
							    	<input type="number" class="input-sm form-control validate[required,custom[number],min[0],max[9999.99]]" name="liquidated_damages" id="liquidated_damages">
							    </div>
							  </div>
		
							  <div class="form-group">
							  	
							  	<label class="col-sm-2 control-label">是否申请减免</label>
							    <div class="col-sm-4">
							    	<s:dict dictType="boolean" type="radio" name="if_apply_reduction"/>
							    </div>
							  </div>
							  
							  <div class="form-group">
							    <label  class="col-sm-2 control-label">描述说明</label>
							    <div class="col-sm-9">
							      <textarea rows="5" class="form-control" name="description" id="description" ></textarea>
							    </div>
							  </div>
							  <div class="form-group">
								<label class="col-xs-2 control-label">附件：</label>
								<div class="col-xs-9 control-label" id="fileList" style="text-align: left;">
								</div>
							</div>
							<div id="ywlx" class="hide">
								<div class="form-group">
							  	<label class="col-sm-2 control-label">业务类型</label>
							    <div class="col-sm-4">
							    	<s:dict dictType="mydbgd" clazz="form-control" name="service_type"/>
							    </div>
							    
							  	<label class="col-sm-1 control-label">业务小类</label>
							    <div class="col-sm-4">
							    	<select id="service_type_detail" class="form-control" name="service_type_detail"></select>
							    </div>
							  </div>
							</div>
							<div class="form-group tag_ifsuccess">
						   		<label class="col-sm-2 control-label">是否办理成功</label>
						   		<div class="col-sm-4">
							   		<select name="tag_ifsuccess" class="form-control validate[required]" id="tag_ifsuccess">
							   			<option value="">请选择</option>
							   			<option value="是">是</option>
							   			<option value="否">否</option>
							   		</select>
						   		</div>
						    </div>
							  
							  	<div class="form-group">
							  	  <label  class="col-sm-2 control-label">评分</label>
							  	  <div class="col-sm-9">
							  	  	<s:dict dictType="score" name="ext1" title="请给本次服务打分！" value="5" type="radio" clazz="control-label "></s:dict>
							  	  </div>
							  	 </div>
							  	 <div class="form-group">
							  	  <label  class="col-sm-2 control-label">评价</label>
								    <div class="col-sm-9">
								      <textarea rows="5" class="form-control" name="ext2" id="ext2" ></textarea>
								    </div>
							  	 </div>
							  	 </div>
							   
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
							  
							</form>
			            </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>