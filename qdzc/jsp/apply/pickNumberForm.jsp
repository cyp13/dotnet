<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
var queryUrl = "${ctx}/jsp/work/queryPickNumber.do";
var queryDictUrl = "${ctx}/jsp/sys/queryDict.do";
var pid = '${param.pId}';
var flag = '${param.flag}';
var taskId = '${param.taskId}';
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
				$("#editForm").fill(row);
				if(row.service_type_detail){
					$("#service_type").change();
					$("#service_type_detail").val(row.service_type_detail);
				}
				if(row.files){
					if(flag!='3'){
						getFiles(row.files,"#fileList");
					}else{
						getFiles(row.files,"#fileList",flag);
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
					$("#evaluate").removeClass('hide');
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
 			$("#liquidated_damages").removeClass("validate[min[0],max[9999.99]]");
 			$(".ext1").attr("disabled",true);
 			if(flag!='3'){
 				$("#opinion").removeClass('hide');
 				$("#ywlx").removeClass('hide');
 				$("#evaluate").addClass("hide");
 			}
 			else{
 				$("#btn-ok").hide();
 				$("#fileUpload").addClass("hide");
 			}
 			
 		}
 		//处理失败时，意见为必填
 		$(".ifSuccess").on("change",function(){
 			if($(this).val()=="0"){
 				$("#desc").addClass('validate[required]');
 			}else{
 				$("#desc").removeClass('validate[required]');
 			}
 		});
 		$(".action").on("change",function(){
 			//未解决才可编辑数据
 			if($(this).val()=="0"){
 				$(".dataForm input,.dataForm textarea").removeAttr('readonly');
 				$(".readonly").attr('readonly','readonly');
 		 		$(".dataForm select,.dataForm input[type='radio']").removeAttr('disabled');
 		 		$("#evaluate").addClass("hide");
 		 		$(".ext1").attr("disabled",true);
 				$("#fileUpload").removeClass("hide");
 			}
 			else{
 				$(".dataForm input,.dataForm textarea").attr('readonly','readonly');
 		 		$(".dataForm select").attr('disabled','disabled');
 				$("#fileUpload").addClass("hide");
 				$(".ext1").removeAttr("disabled");
 				$("#evaluate").removeClass("hide");
 			}
 		});
 		
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
 		
 		
		$("#btn-ok").on("click", function() {
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
			
			if(!$(".delFile")&&!$("#file").val()){
				$("#file").addClass("validate[required]");
  			}
			
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				if(flag=="2"){
					$("#service_type_detail_name").val($("#service_type_detail option:checked").text());
				}
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
	
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
			
		            <div class="ibox-content">
                       <form id="editForm" action="${ctx}/jsp/work/subPickNumber.do"  method="post" class="form-horizontal key-13" >
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
							 	<label class="col-sm-1 control-label">选中号码</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control validate[required,custom[mobile]]" name="user_phone" id="user_phone">
							    </div>
							  </div>
		
							  <div class="form-group">
							    
							  	<label class="col-sm-2 control-label">客户姓名</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control" name="user_name" id="user_name">
							    </div>
							    <label class="col-sm-1 control-label">身份证号码</label>
							    <div class="col-sm-4">
							    	<input type="number" class="input-sm form-control " name="china_id" id="china_id">
							    </div>
							  </div>
		
							  <div class="form-group">
							  	
							  	<label class="col-sm-2 control-label">客户地址</label>
							    <div class="col-sm-4">
							    	<input type="text" maxlength="50" class="input-sm form-control" name="user_address" id="user_address">
							    </div>
							  </div>
							  </div>
							  <div class="form-group">
								<label class="col-xs-2 control-label">附件：</label>
								<div class="col-xs-9 control-label" id="fileList" style="text-align: left;">
								</div>
							</div>
							  <div id="sub1" class="sub hide">
							  <hr>
								   <div class="form-group">
								   	<label  class="col-sm-2 control-label">是否已解决</label>
								   	<div class="col-sm-4">
								   		<s:dict dictType="boolean" type="radio" name="action"></s:dict>
								  	</div>
								  </div>
							  </div>
							  <div id="fileUpload">
								  <c:if test="${param.taskName eq '渠道人员'}">
								  	<div class="form-group">
								   	<label  class="col-sm-2 control-label">文件上传</label>
								    <div class="col-sm-9">
								    	<input type="file" class="input-sm form-control" multiple name="file" id="file" >
								    </div>
								   </div>	
								  </c:if>
							  </div>
							  
							  <div id="evaluate" class="hide">
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
							   
							   <div id="opinion" class="hide">
							   <hr>
							    <c:if test="${param.taskName eq '支撑人员'}">
								  <div class="form-group">
								  	<label  class="col-sm-2 control-label">办理结果</label>
								  	<input type="text" value="完成" name="result" class="hide"/>
								    <div class="col-sm-4">
								    	<input type="radio" name="ifSuccess" class="ifSuccess" checked="checked"  value="1">成功
								    	<input type="radio" name="ifSuccess" class="ifSuccess"   value="0">失败
									  <%-- <select name="ifSuccess"  class="form-control ifSuccess">
									  	<option value="1">成功</option>
									  	<option value="0">失败</option>
									  </select> --%>
									  </div>
								  </div>
								  </c:if>
								  <div class="form-group">
								  <c:if test="${param.taskName eq '渠道人员'}">
								  	<input type="text" value="完成" name="result" class="hide"/>
								  </c:if>
								    <label  class="col-sm-2 control-label">意见</label>
								    <div class="col-sm-8">
								      <textarea rows="5" class="form-control phrase_" name="desc" id="desc" ></textarea>
								    </div>
								    <a id="addPhrase"><i class="fa fa-plus" style="margin-top: 18px;">设为常用语</i></a>
								  </div>
							  </div>
							  
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