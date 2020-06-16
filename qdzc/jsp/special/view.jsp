<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script> 
var queryUrl = "${ctx}/jsp/work/querySpecial.do";
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
				var a = data.Rows[0].work_type;
				if(a==1){//开户
					$("#work_kaihu").show();
					$("#work_kaihu").find(":input").attr("disabled", false);
					$("#work_biangeng").hide();
					$("#work_biangeng").find(":input").attr("disabled", true);
					$("#work_xiaohu").hide();
					$("#work_xiaohu").find(":input").attr("disabled", true);
					$("#type_2_3").hide();
					$("#type_2_3").find(":input").attr("disabled", true);  
					$(".dataForm input[type='type'], .dataForm textarea, .dataForm select, .dataForm input[type='radio']").attr('disabled', 'disabled'); 
			
				}else if (a==3){//销户
					
					$("#work_kaihu").hide();
					$("#work_kaihu").find(":input").attr("disabled", true);
					$("#work_biangeng").hide();
					$("#work_biangeng").find(":input").attr("disabled", true);
					$("#work_xiaohu").show();
					$("#work_xiaohu").find(":input").attr("disabled", false);
					$("#type_2_3").show();
					$("#type_2_3").find(":input").attr("disabled", false);
					
					 
					$(".dataForm input, .dataForm textarea, .dataForm select, .dataForm input[type='radio']").attr('disabled', 'disabled');
					 
				}else{
					$("#work_kaihu").hide();
					$("#work_kaihu").find(":input").attr("disabled", true);
					$("#work_biangeng").show();
					$("#work_biangeng").find(":input").attr("disabled", false);
					$("#work_xiaohu").hide();
					$("#work_xiaohu").find(":input").attr("disabled", true); 
					$("#type_2_3").show();
					$("#type_2_3").find(":input").attr("disabled", false);
					  
					$(".dataForm input, .dataForm textarea, .dataForm select, .dataForm input[type='radio']").attr('disabled', 'disabled');
				}
	 
				$("#editForm").fill(row); 
				 
				initFormTypeSmall($('select[name=service_type] option:selected').attr('data-id'),row.service_type_detail);
				 
			 	 
			 	 if (row.files) {//附件处理  flag等于3时  就可以删除附件
				  getFiles(row.files, "#fileList",3);//3代表不显示删除
					 
			 	 }
			 	 
				if(row.service_type){
					$("#ywlx").removeClass('hide');
					
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
 				"width":"30%",
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
					 
							  </div>
	 
	 
									<!-- 可变字段 -->
 	  <!-- 开户start -->
				 			<div id="work_kaihu" style="display:none;" >
				 				<div class="form-group">
				 					<label class="col-sm-1 control-label col-sm-offset-1">业务小类</label>
									<div class="col-sm-4">
										<s:dict dictType="zxgd_sj" name="work_type" type="select" clazz="validate[required] form-control" ></s:dict>
									</div> 
				 				</div>
				 				 <div class="form-group">
								    <!--集团单位名称-->
								    <label class="col-sm-2 control-label ">集团单位名称</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required]" name="group_name" maxlength="30" placeholder="请输入30字以内得集团名称" readonly>
								    </div>
								    <!--装机地址-->
								    <label class="col-sm-1 control-label ">装机地址</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required]" name="install_address" placeholder="请输入装机地址"  readonly >
								    </div> 
								</div > 
								 <div class="form-group">
								    <!--装机联系人-->
								    <label class="col-sm-2 control-label ">装机联系人(客户)</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required]" name="install_name" readonly placeholder="请输入装机联系人姓名">
								    </div>
								    <!--装机联系手机-->
								    <label class="col-sm-1 control-label ">装机联系手机(客户)</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required,custom[mobile]]" name="install_phone" maxlength="11" readonly  placeholder="请输入手机号码">
								    </div>
								</div>
									
								 <div class="form-group">
								    <!--集团单位法人-->
								    <label class="col-sm-2 control-label ">集团单位法人</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control    " name="group_mainname" readonly  placeholder="无" >
								    </div>
								    <!--法人手机-->
								    <label class="col-sm-1 control-label ">法人手机</label>
								    <div class="col-sm-4">
								        <input type="text" class=" input-sm form-control validate[custom[mobile]]   " name="mainphone" maxlength="11" readonly  placeholder="无">
								    </div>
								</div>
									
								 <div class="form-group">
								    <!--优惠比例-->
								    <label class="col-sm-2 control-label ">优惠比例(%)</label>
								    <div class="col-sm-4">
								        <input type="number" min="0" max="100" maxlength="3" class="input-sm form-control validate[required,custom[discount_rate]]" name="discount_rate"  readonly placeholder="请输入0到100之间得整数" >
								    </div> 
								</div>
								
								
								
								<div class="form-group">
										  	<label class="col-sm-2 control-label">产品大类</label>
										    <div class="col-sm-4">
										    	<s:dict dictType="zxgdmaxmin" clazz="form-control validate[required]" name="service_type"  />
										    </div>
									      
											
									     	<label class="col-sm-1 control-label">产品小类</label>
											<div class="col-sm-4">
												<select id="service_type_detail" class="form-control validate[required]"
													name="service_type_detail">
														  
													</select> 
													 
													<input type="text"
													class="hide" name="service_type_detail_name"
													id="service_type_detail_name">
											   
											</div>
							     </div>
							     
   								<div class="form-group">
								    <label class="col-sm-2 control-label  ">专线号</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[custom[specialnumber]]" name="specialnumber"   maxlength="11" placeholder="未处理">
								    </div>
								    <!-- <label class="col-sm-1 control-label " id="change1">集团编码</label>
									<div class="col-sm-4" id="change2">
										<input type="text" class=" form-control   validate[custom[group_code]]" name="group_code" maxlength="10"
											placeholder="未处理">
									</div>  -->
								</div>
				 			</div>
				 			<!-- 开户end -->
	 
	 						    <!-- 变更start -->
				 			<div   id="work_biangeng" style="display: none;">
				 			
					 			<div class="form-group">
				 			 		 <label class="col-sm-1 control-label col-sm-offset-1">业务小类</label>
									<div class="col-sm-4">
										<s:dict dictType="zxgd_sj" name="work_type" type="select" clazz="validate[required] form-control" ></s:dict>
									</div> 
								    <!--专线号-->
								    <label class="col-sm-1 control-label ">专线号</label>
								    <div class="col-sm-4">
								       <input type="text" class="input-sm form-control validate[required,custom[specialnumber]]" name="specialnumber"   maxlength="11" placeholder="请填写100开头的11位数专线号">
								    </div>
	    						</div>
    
				 				 <div class="form-group">
								    <!--集团单位名称-->
								    <label class="col-sm-2 control-label ">集团单位名称</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required]" name="group_name" maxlength="30" placeholder="请输入30字以内得集团名称" >
								    </div>
								    <!--装机地址-->
								    <label class="col-sm-1 control-label ">装机地址</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required]" placeholder="请输入装机地址"  name="install_address"  >
								    </div>  
								</div >
								 
								 <div class="form-group">
								    <!--装机联系人-->
								    <label class="col-sm-2 control-label ">变更联系人</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required]" name="install_name" placeholder="请输入变更联系人姓名" >
								    </div>
								    <!--装机联系手机-->
								    <label class="col-sm-1 control-label ">变更联系手机</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required,custom[mobile]]" maxlength="11" name="install_phone"  placeholder="请输入手机号码" >
								    </div>
								</div>
									
								 <div class="form-group">
								    <!--集团单位法人-->
								    <label class="col-sm-2 control-label ">集团单位法人</label>
								    <div class="col-sm-4">
								        <input type="text" class=" form-control  " name="group_mainname"  placeholder="无"  >
								    </div>
								    <!--法人手机-->
								    <label class="col-sm-1 control-label ">法人手机</label>
								    <div class="col-sm-4">
								        <input type="text" class=" form-control validate[custom[mobile]] " name="mainphone" maxlength="11" placeholder="无" >
								    </div>
								</div>
								
 
							     
									 
				 			</div>
				 			<!--变更end -->

						    <!-- 销户start -->
				 			<div style="display:none;" id="work_xiaohu">
				 			
					 			<div class="form-group">
									<label class="col-sm-1 control-label col-sm-offset-1">业务小类</label>
									<div class="col-sm-4">
										<s:dict dictType="zxgd_sj" name="work_type" type="select" clazz="validate[required] form-control" ></s:dict>
									</div> 
								    <!--专线号-->
								    <label class="col-sm-1 control-label  ">专线号</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required,custom[specialnumber]]" name="specialnumber"   maxlength="11" placeholder="请填写100开头的11位数专线号">
								    </div>
	    						</div>	
    
				 				 <div class="form-group">
								    <!--集团单位名称-->
								    <label class="col-sm-2 control-label ">集团单位名称</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required]" name="group_name"  maxlength="30" placeholder="请输入30字以内得集团名称">
								    </div>
								    <!--装机地址-->
								    <label class="col-sm-1 control-label ">装机地址</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required]" placeholder="请输入装机地址"  name="install_address"  >
								    </div>  
								</div >
								 
								 <div class="form-group">
								    <!--装机联系人-->
								    <label class="col-sm-2 control-label ">销户联系人</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required]" name="install_name" placeholder="请输入销户联系人姓名">
								    </div>
								    <!--装机联系手机-->
								    <label class="col-sm-1 control-label ">销户联系手机</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required,custom[mobile]]" maxlength="11" name="install_phone"  placeholder="请输入手机号码" >
								    </div>
								</div>
									
								 <div class="form-group">
								    <!--集团单位法人-->
								    <label class="col-sm-2 control-label ">集团单位法人</label>
								    <div class="col-sm-4">
								        <input type="text" class=" form-control  " name="group_mainname"  placeholder="无" >
								    </div>
								    <!--法人手机-->
								    <label class="col-sm-1 control-label ">法人手机</label>
								    <div class="col-sm-4">
								        <input type="text" class=" form-control validate[custom[mobile]] " maxlength="11" name="mainphone"  placeholder="无" >
								    </div>
								</div>
	 
									 
				 			</div>
				 			<!--销户end -->		
							<div class="form-group">
								<label class="col-sm-2 control-label">描述说明</label>
								<div class="col-sm-9">
									<textarea class="form-control" name="remark" id="remark" maxlength="500" placeholder="此处可填写受理业务其他说明或描述（非必填项） "></textarea>
								</div>
							</div>	
							<div class="form-group">
								<label class="col-xs-2 control-label">附件：</label>
								<div class="col-xs-9 control-label" id="fileList"
									style="text-align: left;"></div>
							</div>
							
							  <!--  <table id="datas" class="table display" style="width:80%">
				                  <thead>
				                      <tr>
										<th>开始时间</th>
										<th>结束时间</th>
										<th>处理人</th>
										<th>结果</th>
										<th>意见</th>
				                      </tr>
				                  </thead>
				              </table> -->
							  
							</form>
			            </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>