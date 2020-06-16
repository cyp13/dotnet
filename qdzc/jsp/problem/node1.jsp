<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<jsp:include page="/jsp/apply/rewardBase.jsp"></jsp:include>

<script>
var queryUrl = "${ctx}/jsp/work/queryProblem.do";

var queryTaskHisUrl = "${ctx}/jsp/work/queryOpinion.do";
var pid = '${param.pId}';
var flag = '${param.flag}';
var taskId = '${param.taskId}';
var taskName = '${param.taskName}';
 	$(window).ready(function() {
 		if(flag=="2"){
	 		var param = new Object();
	 		param.roleName = "二级酬金问题工单支撑";
	 		getUserByRoleAndOrgPath(param,function(data){
	 			formatData(data, "userName", "userAlias", "select", "#zhuanjia_", "orgName");
	 		});
 		}
 		
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
 		$("#taskName").val(taskName); 
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
				console.log(row);
				$("#editForm").fill(row);
				
				if(row.opinions){
					if(flag!='4'){
						getOpinionsAndFiles(row.opinions,"#filesAndOpinion");
					}else{
						getOpinionsAndFiles(row.opinions,"#filesAndOpinion",1);
					}
				}
				if(row.service_type){
					$("#service_type").attr("disabled","disabled");
					/* if(flag=="2"){
						$("#service_type").removeAttr("disabled");
					} */
					
				}
				if(row.status=="2"){//表示已解决
					$(".ibox-content input,.ibox-content textarea,.ibox-content select").attr('disabled','disabled');
				}
				
			});
		}
 		$(".sub").addClass('hide');
 		
 		
 		if(flag=='1'){
 			
 			$("#fileUpload").addClass("hide");
 			$("#sub1").removeClass('hide');
 			$("#opinion").addClass('hide');
 			$("#result").removeClass('validate[required]');
 			$("#desc").removeClass('validate[required]');
 			$("#evaluate").removeClass('hide');	
 		}else{
 			$(".ext1").attr("disabled",true);
 			if(flag!='4'){
 				$("#opinion").removeClass('hide');
 				$("#yijian").removeClass('hide');
 	 			$("#desc").addClass('validate[required]');
 	 			$("#service_type").addClass('validate[required]');
 			}
 			else{
 				$("#btn-ok").hide();
 				$("#fileUpload").addClass("hide");
 			}
 			
 		}
 		
 		$(".action").on("change",function(){
 			//未解决才可编辑数据
 			if($(this).val()=="发布"){
 				$(".dataForm input,.dataForm textarea").removeAttr('readonly');
 				$(".readonly").attr('readonly','readonly');
 		 		$(".dataForm select,.dataForm input[type='radio']").removeAttr('disabled');
 				$("#fileUpload").removeClass("hide");
 				$("#yijian").removeClass("hide");
 				$("#desc").addClass('validate[required]');
 			}
 			else{
 				$(".dataForm input,.dataForm textarea").attr('readonly','readonly');
 		 		$(".dataForm select").attr('disabled','disabled');
 				$("#fileUpload").addClass("hide");
 				$("#yijian").addClass("hide");
 				$("#desc").removeClass('validate[required]');
 			}
 		});
 		
 		//转派联动
			$("#result").on("change",function(){
	 			if($(this).val()=="转派"){
	 				$("#exzj").removeClass("hide");
	 				$("#zhuanjia_").addClass("validate[required]");
	 				
	 			}
	 			else{
	 				$("#exzj").addClass("hide");
	 				$("#zhuanjia_").removeClass("validate[required]");
	 			}
	 		});
 		
 		
		$("#btn-ok").on("click", function() {
			
 			if(!$(".delFile")&&!$("#file").val()){
				$("#file").addClass("validate[required]");
  			}
 			for(var key in deleteFileIds){
				$("#editForm").append('<input type="hidden" name="deleteFileIds" value="'+key+'" />');
			}
			
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				$("#service_type_name").val($("#service_type option:checked").text());
				ajaxSubmit("#editForm", function(data) {
					if ("error" == data.resCode) {
						layer.msg(data.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1},function(){
							back_();
						});
					}
				});
			}
		});
		
 	});
 	var downloadUrl = host_+"/api/sys/downloadFile.do";
	
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
			
		            <div class="ibox-content">
                       <form id="editForm" action="${ctx}/jsp/work/subProblem.do"  method="post" class="form-horizontal key-13" >
			                  <input type="text" id="id" name="id" style="display:none"/>
			                  <input type="text" id="pid" name="pid" style="display:none"/>
			                  <input type="text" id="flag" name="flag" style="display:none"/>
			                  <input type="text" id="taskId" name="taskId" style="display:none"/>
			                  <input type="text" id="taskName" name="taskName" style="display:none"/>
			                  <div class="dataForm">
							  <div class="form-group">
							   		 <label class="col-sm-2 control-label">工单主题</label>
								    <div class="col-sm-4">
								    	<input class="input-sm form-control validate[required] readonly"  name="title" id="title"/>
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
							    <label class="col-sm-2 control-label">渠道</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control readonly"  name="channel_name" id="channel_name" readonly>
							    </div>
							    <label class="col-sm-1 control-label">渠道编码</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control readonly"  name="channel"  id="channel" readonly>
							    </div>
							  </div>
		
							  <div class="form-group">
							    <label class="col-sm-2 control-label">渠道联系方式</label>
							    <div class="col-sm-4">
							     	<input type="number" class="input-sm form-control readonly"   readonly name="channel_phone" id="channel_phone" >
							    </div>
							    <label class="col-sm-1 control-label">工单类型</label>
							    <div class="col-sm-4">
							    	<s:dict dictType="cjproblem" clazz="form-control validate[required]" name="service_type"></s:dict>
							   		<input type="text" class="hide" id="service_type_name" name="service_type_name" />
							    </div>
							  </div>
							
							  <div class="form-group">
							    <label  class="col-sm-2 control-label">描述说明</label>
							    <div class="col-sm-9">
							      <textarea rows="5" class="form-control validate[required]" name="description" id="description" maxlength="200"></textarea>
							    </div>
							  </div>
							  </div>
							  <div class="form-group">
								<label class="col-xs-2 control-label">附件：</label>
								<div class="col-xs-9 control-label" id="fileList" style="text-align: left;">
								</div>
							</div>
							<div id="filesAndOpinion">
								
							</div>
							
							  <div id="sub1" class="sub hide">
							  <hr>
								   <div class="form-group">
								   	<label  class="col-sm-2 control-label">是否已解决</label>
								   	<div class="col-sm-4">
								   		<input type="radio" class="action" name="action" value="归档" checked="checked"/>是
								   		<input type="radio" class="action" name="action" value="发布"/>否
								  	</div>
								  </div>
							  </div>
						  			
							   <div id="opinion" class="hide">
							   <fieldset>
							   	<legend>我的回复</legend>
							   	<div class="form-group">
								  	<label  class="col-sm-2 control-label">处理结果</label>
								    <div class="col-sm-4">
									  <select name="result" id="result"  class="form-control">
									   <c:if test="${param.taskName eq '酬金问题工单支撑'}">
										  	<option value="回复">回复</option>
										  	<option value="转派">转派</option>
										  	<option value="驳回">驳回</option>
									  	</c:if>
									  	 <c:if test="${param.taskName eq '二级酬金问题工单支撑'}">
									  	 	<option value="回复">回复</option>
										  	<option value="回退">回退</option>
									  	 </c:if>
									  </select>
									 </div>
									 <div id="exzj" class="hide">
										 <label  class="col-sm-1 control-label">转派给</label>
									    <div class="col-sm-4">
										  <select name="zhuanjia_" id="zhuanjia_" class="form-control">
										  </select>
									 </div>
									 </div>
								  </div>
							   </fieldset>
								</div>
								<div id="yijian" class="hide">
								  <div class="form-group">
								  <c:if test="${param.taskName eq '渠道人员'}">
								  	<input type="text" value="完成" name="result" class="hide"/>
								  </c:if>
								    <label  class="col-sm-2 control-label">意见</label>
								    <div class="col-sm-8">
								      <textarea rows="5" rows="5" class="form-control phrase_" name="desc" id="desc" maxlength="200"></textarea>
								    </div>
								    <a id="addPhrase"><i class="fa fa-plus" style="margin-top: 18px;">设为常用语</i></a>
								  </div>
							  </div>
							  <c:if test="${param.flag ne '4'}">
							  <div id="fileUpload">
								  <div class="form-group">
									   	<label  class="col-sm-2 control-label">文件上传</label>
									    <div class="col-sm-9">
									    	<input type="file" class="input-sm form-control" multiple name="file" id="file" >
									    </div>
								   </div>
								</div>
							   </c:if>
							  
							   <div class="form-group">
								   	<div class="col-sm-9 col-sm-offset-2">
								   		<button type="button" class="btn btn-sm btn-success btn-13" id="btn-ok">
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