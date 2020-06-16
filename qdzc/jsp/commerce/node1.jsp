<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
var queryTaskHisUrl = host_+"/api/jbpm/queryHisTask.do";
var queryUrl = "${ctx}/jsp/work/queryCommerce.do";
var queryDictUrl = "${ctx}/jsp/sys/queryDict.do";
var pid = '${param.pId}';
var flag = '${param.flag}';
var taskId = '${param.taskId}';
var workType="0";
 	$(window).ready(function() {
 		//获取常用语
 		getPhraseToPage();
 		$(".phrase_").typeahead({
	 		 source: phrases
	 	});	
 		
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
				
				workType=row.work_type+"";
				 
				
				if("6"==row.work_statis) {
					$("#isyesorno").val(1);
					//解决老工单的兼容问题
					var procdefid_ = '${param.procdefid_}';
					var i = procdefid_.lastIndexOf('-');
					var procversion_ = procdefid_.substring(i+1);
					if (1 == procversion_) {
						console.log(1);
						$("#archive").removeAttr('checked');
						$("#archive").attr('disabled',true);
					}
				}else if ("5"==row.work_statis) {
					$("#isyesorno").val(2);
				}
				var a = data.Rows[0].work_type; 
				if(a==1){//开户(阻止提交)
					$("#work_kaihu").show();
					$("#isnotype").show();
					$("#work_kaihu").find(":input").attr("disabled", false);
					$("#isnotype").find(":input").attr("disabled", false);
					$("#work_biangeng").hide();
					$("#work_biangeng").find(":input").attr("disabled", true);
					$("#work_xiaohu").hide();
					$("#work_xiaohu").find(":input").attr("disabled", true); 
					
					
					$("#isnotype").find(":input").attr("disabled", true); 
				// 	$("#isnotype").hide();
					
					//$(".dataForm input[type='type'], .dataForm textarea, .dataForm select, .dataForm input[type='radio']").attr('disabled', 'disabled'); 
			
				}else if(a==2){ //变更 
					$("#work_kaihu").hide();
					$("#work_kaihu").find(":input").attr("disabled", true);
					$("#work_biangeng").show();
					$("#work_biangeng").find(":input").attr("disabled", false);
					$("#work_xiaohu").hide();
					$("#work_xiaohu").find(":input").attr("disabled", true);  
					  
				//	$(".dataForm input, .dataForm textarea, .dataForm select, .dataForm input[type='radio']").attr('disabled', 'disabled');
				 
				}else if (a==3){//销户
					
					$("#work_kaihu").hide();
					$("#work_kaihu").find(":input").attr("disabled", true);
					$("#work_biangeng").hide();
					$("#work_biangeng").find(":input").attr("disabled", true);
					$("#work_xiaohu").show();
					$("#work_xiaohu").find(":input").attr("disabled", false); 
					 
				//	$(".dataForm input, .dataForm textarea, .dataForm select, .dataForm input[type='radio']").attr('disabled', 'disabled');
					 
				}
				//$(".dataForm input[type='type'], .dataForm textarea, .dataForm select, .dataForm input[type='radio']").attr('disabled', 'disabled'); 
				$("#editForm").fill(row); 
				 
				
		 
				
				
			 	 //获取小类
				initFormTypeSmall($('select[name=service_type] option:selected').attr('data-id'),row.service_type_detail);
		 		
			 	 
				 if (row.files) {//附件处理  flag等于3时  就可以删除附件
						if (flag != '3') {
							getFiles(row.files, "#fileList");
						} else {
							getFiles(row.files,
									"#fileList", flag);
						}
			 	 }
				 	 
			 	 
				if(row.service_type){
					$("#ywlx").removeClass('hide');
					$("#service_type,#service_type_detail").attr("disabled","disabled");
					if(flag=="2"){
						$("#service_type,#service_type_detail").removeAttr("disabled");
					}
					
				}
				if(row.status=="2"){//表示已解决
					//$("#evaluate").removeClass('hide');
					$(".ibox-content input,.ibox-content textarea,.ibox-content select").attr('disabled','disabled');
					$('#archive').attr('disabled',false);
					$('#id').attr('disabled',false);
					$('#taskId').attr('disabled',false);
					$('#node').attr('disabled',false);
					$('#isyesorno').attr('disabled',false);
				}else if (row.status=="3") {
					$(".ibox-content input,.ibox-content textarea,.ibox-content select").attr('disabled','disabled');
					$('#archive').attr('disabled',false);
					$('#id').attr('disabled',false);
					$('#taskId').attr('disabled',false);
					$('#node').attr('disabled',false);
					$('#isyesorno').attr('disabled',false);
				}else{
					
				}
				
				
			});
		}
 		
 		
 		if(flag=='1'){
 			
 			$("#fileUpload").addClass("hide");
 			$("#sub1").removeClass('hide');
 			$("#opinion").addClass('hide');
 			$("#result").removeClass('validate[required]');
 			$("#desc").removeClass('validate[required]');
 			//$("#evaluate").removeClass('hide');	
 		}else{ 
 			$("#liquidated_damages").removeClass("validate[min[0],max[9999.99]]");
 			$(".ext1").attr("disabled",true);
 			if(flag!='3'){
 				$("#opinion").removeClass('hide');
 				$("#ywlx").removeClass('hide');
 				//$("#isnotype").addClass('hide');
 				//$("#evaluate").removeClass('hide');
				//$("#evaluate").find(":input").attr("disabled",true);	
 	 			$("#desc").addClass('validate[required]');
 	 			$("#service_type").addClass('validate[required]');
 	 			$("#service_type_detail").addClass('validate[required]');
 	 			$("#fileUpload").addClass('hide'); 
 			}
 			else{
 				$("#btn-ok").hide();
 				$("#fileUpload").addClass("hide");
 			}
 			
 		}
 		
 	 
 		/**
 		 *确定
 		 */
 		$("#btn-ok").on("click", function() {
			$(this).attr("disabled","disabled");
			 var b = $("#editForm").validationEngine("validate"); 
			 
			 if($('#fileList').children().length<=0){
					$('#file').addClass('validate[required]');
				}else{
					var found = false;
					$('#fileList').children().each(function(){
						found = $(this).attr('state')=='normal';	
					});
					if(found){
						$('#file').removeClass('validate[required]');
					}else{
						$('#file').addClass('validate[required]');
					}
				} 
			for(var key in deleteFileIds){
				$("#editForm").append('<input type="hidden" name="deleteFileIds" value="'+key+'" />');
			}
			 
			 
			if(b) {
				//$("#service_name").val($("#service_type option:checked").text());
				var pa = new Object();
				pa.token = token_;  
				//pa.isyesorno=$("#isyesorno").val();
				ajaxSubmit("#editForm",pa, function(data) {
					if ("error" == data.resCode) {
						layer.msg(data.resMsg, {icon: 2});
						$("#btn-ok").removeAttr("disabled");
					} else {
							layer.msg("数据处理成功！", 
									{icon: 1},function(){
									//closeCurPage();
										back_();
								}
							)
						}
				});
			} 
			else{
				$("#btn-ok").removeAttr("disabled");
			}
			
			
		});
		 
		queryHisTask();
		
		
		
		$('input[name=IN_CONTROL]').change(function(){
			if($(this).val()=="归档"){//未解决才可编辑数据
 				
	 			//$("#evaluate").removeClass('hide');	
				//$("#evaluate").find(":input").attr("disabled",false);	  
				$("#remark").attr("disabled",true); 
				
	 			$("#fileUpload").addClass('hide');	 
	 			$("#work_type").val(workType+"");  
	 			if("1"==workType){ 
	 				$("#work_kaihu").show();
					$("#work_kaihu").find(":input").attr("disabled",true); 
					$("#work_biangeng").hide();
					$("#work_biangeng").find(":input").attr("disabled", true);
					$("#work_xiaohu").hide();
					$("#work_xiaohu").find(":input").attr("disabled", true);
					$("#work_type").val(null);
					 
					$("#isnotype").show();
					$("#isnotype").find(":input").attr("disabled", true);
				}else if("2"==workType){  
				 
					$("#work_kaihu").hide();
					$("#work_kaihu").find(":input").attr("disabled",true);
					$("#work_biangeng").show();
					$("#work_biangeng").find("input").attr("disabled",true);
					$("#work_xiaohu").hide();
					$("#work_xiaohu").find(":input").attr("disabled", true);
					$("#work_type").find("option[value='2']").attr("selected", "selected")
				}else if("3"==workType){
					$("#work_kaihu").hide();
					$("#work_kaihu").find(":input").attr("disabled",true);
					$("#work_biangeng").hide();
					$("#work_biangeng").find(":input").attr("disabled", true);
					$("#work_xiaohu").show();
					$("#work_xiaohu").find(":input").attr("disabled", false);
					$("#work_type").find("option[value='3']").attr("selected", "selected")
			 	}
				 
				///* $("#work_type").find("option[value='3']").attr("selected", "selected");
				$("#work_type").find("select").attr("disabled",true); 
				//$("#isokok").hide(); //归档时显示确定按钮
				
				
				
			} else{  
				$("#remark").removeAttr("readonly"); 
				$("#remark").attr("disabled",false); 
				//$("#evaluate").addClass('hide');	
				//$("#evaluate").find(":input").attr("disabled",true);	
				$("#fileUpload").removeClass('hide');	
				
 				if($('#fileList').children().length<=0){
					$('#file').addClass('validate[required]');
				}else{
					$('#file').removeClass('validate[required]');
				}
				
					
 				$("#work_type").find("select").removeAttr("disabled");  
 				$("#work_type").val(workType); 
 				
 				$("#isokok").show(); 
				
 				if("1"==workType){  
					$("#work_kaihu").show();
					$("#work_kaihu").find(":input").attr("disabled",false);
					$("#work_kaihu").find("input").removeAttr("readonly");
					
					
					$("#isnotype").hide();
					$("#isnotype").find(":input").attr("disabled", true);
					
					$("#work_biangeng").hide();
					$("#work_biangeng").find(":input").attr("disabled", true);
					$("#work_xiaohu").hide();
					$("#work_xiaohu").find(":input").attr("disabled", true);
				}else if("2"==workType){  
				 
					$("#work_kaihu").hide();
					$("#work_kaihu").find(":input").attr("disabled",true);
					$("#work_biangeng").show();
					$("#work_biangeng").find("input").removeAttr("disabled");
					$("#work_biangeng").find("input").removeAttr("readonly");
					$("#work_xiaohu").hide();
					$("#work_xiaohu").find(":input").attr("disabled", true);
				}else if("3"==workType){
					$("#work_kaihu").hide();
					$("#work_kaihu").find(":input").attr("disabled",true);
					$("#work_biangeng").hide();
					$("#work_biangeng").find(":input").attr("disabled", true);
					$("#work_xiaohu").show();
					$("#work_xiaohu").find(":input").attr("disabled", false);
					$("#work_xiaohu").find("input").removeAttr("readonly");
				}else{
					$("#work_kaihu").hide();
					$("#work_kaihu").find(":input").attr("disabled",true);
					$("#work_biangeng").hide();
					$("#work_biangeng").find(":input").attr("disabled", true);
					$("#work_xiaohu").hide();
					$("#work_xiaohu").find(":input").attr("disabled", true);
				}
 				
 				
				}
		});
		$('.ext1').change(function(){
			var score = $(this).val();
			if(score<4){
				$('#ext2').addClass('validate[required]');
			}else{
				$('#ext2').removeClass('validate[required]');
			};
		});
		
		
		
		
		
		
		
		
		$("select[name=work_type]").change(function() 
				{  
					var work_type=$("select[name=work_type]").val() 
					if(work_type==null){
						$("#work_kaihu").hide();
						$("#work_kaihu").find(":input").attr("disabled", true);
						$("#work_biangeng").hide();
						$("#work_biangeng").find(":input").attr("disabled", true);
						$("#work_xiaohu").hide();
						$("#work_xiaohu").find(":input").attr("disabled", true);
						return;
					}else if(parseInt(work_type)==1){  
						$("#work_kaihu").show();
						$("#work_kaihu").find(":input").attr("disabled",false);
						$("#work_biangeng").hide();
						$("#work_biangeng").find(":input").attr("disabled", true);
						$("#work_xiaohu").hide();
						
						$("#isnotype").hide();
						$("#isnotype").find(":input").attr("disabled", true);
						
						$("#work_xiaohu").find(":input").attr("disabled", true);
						$("#work_kaihu").find("input").removeAttr("readonly");
					 

					}else if(parseInt(work_type)==2){  
						$("#work_kaihu").hide();
						$("#work_kaihu").find(":input").attr("disabled",true);
						$("#work_biangeng").show();
						$("#work_biangeng").find(":input").attr("disabled", false);
						$("#work_xiaohu").hide();
						$("#work_xiaohu").find(":input").attr("disabled", true);
						$("#work_biangeng").find("input").removeAttr("readonly");
					}else if(parseInt(work_type)==3){
						$("#work_kaihu").hide();
						$("#work_kaihu").find(":input").attr("disabled",true);
						$("#work_biangeng").hide();
						$("#work_biangeng").find(":input").attr("disabled", true);
						$("#work_xiaohu").show();
						$("#work_xiaohu").find(":input").attr("disabled", false);
						$("#work_xiaohu").find("input").removeAttr("readonly");
					}else{
						$("#work_kaihu").hide();
						$("#work_kaihu").find(":input").attr("disabled",true);
						$("#work_biangeng").hide();
						$("#work_biangeng").find(":input").attr("disabled", true);
						$("#work_xiaohu").hide();
						$("#work_xiaohu").find(":input").attr("disabled", true); 
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
                       <form id="editForm" action="${ctx}/jsp/work/subCommerce.do"  method="post" class="form-horizontal key-13" >
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
								    	<input type="text" class="input-sm form-control readonly"  name="county_name" id="county_name" readonly>
								    	<input type="text" class="hide" name="county" id="county" >
								    </div>
							  
							    <label class="col-sm-1 control-label">分局</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control readonly"  name="branch_office_name"  id="branch_office_name" readonly>
							    	<input type="text" class="hide" name="branch_office" id="branch_office">
							    </div>
							  </div>
		
							  <div class="form-group">
							    <label class="col-sm-2 control-label">渠道</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control readonly"  name="channel_name" id="channel_name" readonly>
							    </div>
							    <label class="col-sm-1 control-label">渠道编码</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control readonly"  value="121" name="channel"  id="channel" readonly>
							    </div>
							  </div>
		
							  <div class="form-group">
							    <label class="col-sm-2 control-label">渠道联系方式</label>
							    <div class="col-sm-4">
							     	<input type="number" class="input-sm form-control readonly"  readonly name="channel_phone" id="channel_phone" >
							    </div>
									<label class="col-sm-1 control-label ">业务小类</label>
									<div class="col-sm-4" id="work_type">
										<s:dict dictType="zxgd" name="work_type"  type="select" clazz="validate[required] form-control" ></s:dict>
									</div> 
							  </div>
		
							<!-- 	<div class="form-group">

								</div> -->
		 	<!-- 可变字段 -->


	  <!-- 开户start -->
				 			<div id="work_kaihu" style="display:none;" > 
				 				 <div class="form-group">
							    <!--集团单位名称-->
							    <label class="col-sm-2 control-label ">集团单位名称</label>
							    <div class="col-sm-4">
							        <input type="text" class="input-sm form-control validate[required]" name="group_name" maxlength="30" placeholder="请输入30字以内得集团名称" readonly>
							    </div>
							    <!--装机地址-->
							    <label class="col-sm-1 control-label ">装机地址</label>
							    <div class="col-sm-4">
							        <input type="text" class="input-sm form-control validate[required]" name="install_address" maxlength="50" placeholder="请输入装机地址"  readonly >
							    </div>
							    

								</div >
								 
								 <div class="form-group">
								    <!--装机联系人-->
								    <label class="col-sm-2 control-label ">装机联系人(客户)</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required]" name="install_name" maxlength="5" readonly placeholder="请输入装机联系人姓名">
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
								        <input type="text" class="input-sm form-control    " name="group_mainname" readonly  placeholder="无" maxlength="5">
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
								
								
								
<div id="isnotype">

								<div class="form-group">
										  	<label class="col-sm-2 control-label">产品大类</label>
										    <div class="col-sm-4">
										    	<s:dict dictType="zqsdhsw" clazz="form-control validate[required]" name="service_type"  />
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
									<label class="col-sm-2 control-label ">集团编码</label>
									<div class="col-sm-4">
										<input type="text" class=" form-control  validate[custom[group_code]]" name="group_code" maxlength="10"
											placeholder="未处理">
									</div>  
								</div>
   								<div class="form-group"> 
								    <label class="col-sm-2 control-label  ">专线号（V网产品）</label>
								    <div class="col-sm-9">  
								        <textarea class="form-control validate[required]" name="specialnumber" maxlength="30" ></textarea>
								    </div>
								</div>
</div>
				 			</div>
				 			<!-- 开户end -->
	 
	 						    <!-- 变更start -->
				 			<div   id="work_biangeng" style="display: none;">
				 			
					 			<div class="form-group">

								    <!--专线号（V网产品）-->
								    <label class="col-sm-2 control-label ">专线号（V网产品）</label>
								    <div class="col-sm-9">  
								        <textarea class="form-control validate[required]" name="specialnumber" maxlength="30" ></textarea>
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
								        <input type="text" class="input-sm form-control validate[required]" placeholder="请输入装机地址" maxlength="50" name="install_address"  >
								    </div>  
								</div >
								 
								 <div class="form-group">
								    <!--装机联系人-->
								    <label class="col-sm-2 control-label ">变更联系人</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required]" name="install_name" maxlength="5" placeholder="请输入变更联系人姓名" >
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
								        <input type="text" class=" form-control  " name="group_mainname"  placeholder="无" maxlength="5" >
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
								 
								    <!--专线号（V网产品）-->
								    <label class="col-sm-2 control-label  ">专线号（V网产品）</label>
								    <div class="col-sm-9">  
								        <textarea class="form-control validate[required]" name="specialnumber" maxlength="30" ></textarea>
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
								        <input type="text" class="input-sm form-control validate[required]" placeholder="请输入装机地址" maxlength="50"  name="install_address"  >
								    </div>  
								</div >
								 
								 <div class="form-group">
								    <!--装机联系人-->
								    <label class="col-sm-2 control-label ">销户联系人</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required]" name="install_name" maxlength="5" placeholder="请输入销户联系人姓名">
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
								        <input type="text" class=" form-control  " name="group_mainname"  placeholder="无" maxlength="5">
								    </div>
								    <!--法人手机-->
								    <label class="col-sm-1 control-label ">法人手机</label>
								    <div class="col-sm-4">
								        <input type="text" class=" form-control validate[custom[mobile]] " maxlength="11" name="mainphone"  placeholder="无" >
								    </div>
								</div>
	 
									 
				 			</div>
				 			<!--销户end -->		
								
	  
	 
	<!-- end -->
			<!-- 固定字段开始 -->
							<div class="form-group">
								<label class="col-sm-2 control-label">描述说明</label>
								<div class="col-sm-9">
									<textarea class="form-control" name="remark" id="remark" maxlength="500" placeholder="此处可填写受理业务其他说明或描述（非必填项） "></textarea>
								</div>
							</div>	
							  </div>
							  <div class="form-group">
								<label class="col-xs-2 control-label">附件：</label>
								<div class="col-xs-9 control-label" id="fileList" style="text-align: left;">
								</div>
							</div>
							<div id="ywlx" class="hide">
 
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
				              </table>
  -->
						 
<div class="form-group">
		<label  class="col-sm-2 control-label">是否重新发起工单</label>
		<div class="col-sm-4">
			<label>
				<input type="radio" name="IN_CONTROL" value="归档" checked="checked" id="archive"/><span style="padding: 0px 10px 0px 5px;">归档</span>
			</label>
			<label>
				<input type="radio" name="IN_CONTROL" value="异议"/><span style="padding: 0px 10px 0px 5px;">重新发起</span>
			</label> 
		</div>
	</div>
								  <div id="fileUpload" >
								<%--   <c:if test="${param.taskName eq '渠道人员'}"> --%>
								  	<div class="form-group">
								   	<label  class="col-sm-2 control-label">文件上传</label>
								    <div class="col-sm-9">
								    	<input type="file" class="input-sm form-control" multiple name="file" id="file" >
								    </div>
								   </div>	
								 <%--  </c:if> --%>
							  </div>
<%-- 	<div id="evaluate">
	<div class="form-group">
		<label  class="col-sm-2 control-label">评分</label>
		<div class="col-sm-9">
			<s:dict dictType="score" name="ext1" title="请给本次服务打分！" value="5" type="radio" clazz="control-label "></s:dict>
		</div>
	</div>
	<div class="form-group">
		<label  class="col-sm-2 control-label">评价</label>
		<div class="col-sm-9">
			<textarea rows="5" class="form-control" name="ext2" id="ext2" placeholder="请填写评价" maxlength="200"></textarea>
		</div>
	</div>
	</div>
	 --%>
	
	
							<input type="hidden" value="0" name="isyesorno" id="isyesorno"> <!-- 默认为0是归档，代表是否被驳回 -->
 							<input type="hidden" value="1" name="node" id="node"><!-- 代表渠道节点 -->
							<div class="form-group" id="isokok">
								   	<div class="col-sm-9 col-sm-offset-2">
								   		<button type="button" class="btn btn-sm btn-success btn-13" id="btn-ok" >
						                	<i class="fa fa-check"></i> 确定
						                </button>
								   	</div>
							   </div>
							</form>
			            </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>