<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
var queryUrl = "${ctx}/jsp/work/queryAgency.do";
var queryDictUrl = "${ctx}/jsp/sys/queryDict.do";
//var queryPreviousNodeHistTaskUrl = "${ctx}/jsp/work/queryPreviousNodeHistTask.do";
var queryPreviousNodeHistTaskUrl = host_+"/api/jbpm/queryHisTask.do";
var pid = '${param.pId}';
var flag = '${param.flag}';
var taskId = '${param.taskId}';
var stepName = '${param.taskName}';
 	$(window).ready(function() {
 		//获取常用语
 		getPhraseToPage();
 		$(".phrase_").typeahead({
	 		 source: phrases
	 	});	
 		//设置初始化意见栏label值
 		$("#yjlabel").text("意见");
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
					$("#service_type_detail").change();
					
					//操作代码回显
					var obje = new Object();
					obje.pid=pid;
					obje.url=queryUrl;
					obje.token=token_;
					ajax(obje, function(data){
						var row = data.Rows[0];
						var operCode=row.oper_code.split(',');
						for (var i = 0; i < operCode.length; i++) {
							if (i == 0) {
								$("#oper_code").val(operCode[i]);
							}else {
							addInputReturn(operCode[i]);
							}
						}
					});
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
				//回填bosscode
				if(!$("#boss_code").val()){
					$("#boss_code").val(data.boss_code);					
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
 			
 			var obj = new Object();
			obj.pid=pid;
			obj.url=queryUrl;
			obj.token=token_;
			ajax(obj, function(data){
				var row = data.Rows[0];
				if (row.tag_ifsuccess != "" && row.tag_ifsuccess !=null) {
 					$("#tag_ifsuccess").attr('disabled','disabled');
				}else {
					$(".tag_ifsuccess").remove();
				}
			});
 		}else{
 			$("#liquidated_damages").removeClass("validate[min[0],max[9999.99]]");
 			$(".ext1").attr("disabled",true);
 			if(flag!='3'){
 				$("#opinion").removeClass('hide');
 				$("#ywlx").removeClass('hide');
 				$("#evaluate").addClass("hide");
 	 			$("#desc").addClass('validate[required]');
 	 			$("#service_type").addClass('validate[required]');
 	 			$("#service_type_detail").addClass('validate[required]');
 			}
 			else{
 				$("#btn-ok").hide();
 				$("#fileUpload").addClass("hide");
 			}
 			
 		}
 		
 		$(".action").on("change",function(){
 			//未解决才可编辑数据
 			if($(this).val()=="0"){
 				//获取上一节点，支撑人员的处理结果
 				$.ajax({
 					url:queryPreviousNodeHistTaskUrl,
 					async:false,
 					type:"get",
 					data:{"pId":pid,"token":token_},
 					success:function(data){
 						var dataObj = eval('(' + data + ')');
 	 					var row = dataObj.datas[1];
 	 					if (row.result=='回复') {
 	 	 					$("#evaluate").addClass("hide");
 	 	 					$("#opinion").removeClass('hide');
 	 	 					$("#desc").addClass('validate[required]');
 	 	 					$("#yjlabel").text("未解决原因");
 	 	 					$("#desc").attr("disabled",false);
 	 	 					$("#yjdiv").removeClass("hide");
 	 					}else{
 	 						$(".dataForm input,.dataForm textarea").removeAttr('readonly');
 	 	 	 				$(".readonly").attr('readonly','readonly');
 	 	 	 		 		$(".dataForm select,.dataForm input[type='radio']").removeAttr('disabled');
 	 	 	 		 		$("#evaluate").addClass("hide");
 	 	 	 		 		$("#user_phone").addClass("validate[required,custom[mobile]]");
 	 	 	 		 		$(".ext1").attr("disabled",true);
 	 	 	 				$("#fileUpload").removeClass("hide");
 	 					}
 					}
 				})
 				
 			}
 			else{
 				$(".dataForm input,.dataForm textarea").attr('readonly','readonly');
 		 		$(".dataForm select").attr('disabled','disabled');
 				$("#fileUpload").addClass("hide");
 				$(".ext1").removeAttr("disabled");
 				$("#evaluate").removeClass("hide");
 				$("#yjdiv").addClass("hide");
 				$("#desc").attr("disabled",true);
 			}
 		});
 		//存储第一级列表对象
 		var levelOneSelete = {};
 		
 		    //业务类型联动
			$("#service_type").on("change",function(){
	 			if($(this).val()){
	 				var dictType = $("#service_type option:checked").data("id");
	 				getDictToPageForMy(dictType,"#service_type_detail");
	 			}
	 			else{
	 				//清除下拉选项
	 				$("#service_type_detail").html("");
	 				$('#oper_code').val('');
	 			}
	 		});
 		   //二级联动处理操作码
 		   $("#service_type_detail").on("change",function(){
 			  var selectText = $(this).get(0).options[$(this).get(0).selectedIndex].text;
			  var parentId = fetchIndex(selectText).dictType;
			  modifyOperCode(parentId); 
 		   });
 		
			//获取选中文本在原数组中的下标
			function fetchIndex(text){
				for(var i = 0; i < levelOneSelete.Rows.length; i++){
					if(text == levelOneSelete.Rows[i].dictName){
						return levelOneSelete.Rows[i];
					}
				}
			}
 		   
			//获取字典并生成下拉选项
			function getDictToPageForMy(parentId,element){
				var pa = new Object();
					pa.url='${ctx}/jsp/sys/queryDict.do';
					pa.parentId = parentId;
					pa.rowValid = "1";
					pa.async = false;
					ajax(pa, function(data){
						if("success"==data.resCode){
							levelOneSelete = data;
							formatData(data.Rows,"dictValue","dictName","select",element);//eval('('+userList+')')
							var selectText = $(element).get(0).options[$(element).get(0).selectedIndex].text;
							var parentId = fetchIndex(selectText).dictType;
							modifyOperCode(parentId);
						}
					});
			}
			//修改操作码
			function modifyOperCode(parentId){
				var inO = new Object();
				inO.url='${ctx}/jsp/sys/queryOpercode.do';
				inO.parentId = parentId;
				inO.async = false;
				ajax(inO, function(inData){
					if(null != inData && inData.Rows[0] && inData.Rows[0].DICT_CODE){
						$('#oper_code').val(inData.Rows[0].DICT_CODE);
					}else{
						$('#oper_code').val('');
					}
				});
			}
 		
 		
			//评分设置是否必填
	 		$('.ext1').on("click",function(){
	 			//input[name=ext1]
	 			var v = $(this).val();//$('input[name="ext1"]:checked').val();
				if(v<5){
					$('#ext2').addClass('validate[required]');
				}else{
					$('#ext2').removeClass('validate[required]');
				}
	 		});
			
		$("#btn-ok").on("click", function() {
			for(var key in deleteFileIds){
				$("#editForm").append('<input type="hidden" name="deleteFileIds" value="'+key+'" />');
			}
			
			if(!$(".delFile")&&!$("#file").val()){
				$("#file").addClass("validate[required]");
  			}
			
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				if(flag=="2"){
					$("#service_type_name").val($("#service_type option:checked").text());
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
		
		/**
		 * 动态添加事件
		 */
		$("body").on('click','.addInputReturn',function(){
	 	    var operCode = "";
	 	    addInputReturn(operCode);
	 	});
		
		function addInputReturn(operCode){
			var html = "";
	 	    
	 	    html += '<div class="form-group code">';
	 	    html += '<label class="col-sm-2 control-label"></label>';
	 	    html += '<div class="col-sm-4">';
	 	    html += '<input type="text" class="input-sm form-control validate[custom[number]]" name="oper_code" id="oper_code" value="'+operCode+'">';
	 	    html += '</div>';
	 	    html += '<a href="javascript:;" class="delInput" >';
	 	    html += '<span class="glyphicon glyphicon-minus"></span>';
	 	    html += '</a>';
	 	    html += '</div>';
	 	 
	 	    $(".code:last").after(html);
		}
		
		/**
		 * 删除事件
		 */
		$("body").on('click','.delInput',function () {
		    //获取当前点击的元素的父级的父级进行删除
		    $(this).parent().remove();
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
                       <form id="editForm" action="${ctx}/jsp/work/subAgency.do"  method="post" class="form-horizontal key-13" >
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
							 	<label class="col-sm-1 control-label">用户手机号码</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control " name="user_phone" id="user_phone">
							    </div>
							  </div>
		
							  <div class="form-group">
							    
							  	<label class="col-sm-2 control-label">代办业务名称</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control validate[required]" name="service_name" id="service_name">
							    </div>
							    <label class="col-sm-1 control-label">违约金金额</label>
							    <div class="col-sm-4">
							    	<input type="number" class="input-sm form-control validate[required,custom[number] validate[min[0],max[9999.99]]" name="liquidated_damages" id="liquidated_damages">
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
							    	<input type="text" class="hide" name="service_type_name" id="service_type_name">
							    </div>
							    
							  	<label class="col-sm-1 control-label">业务小类</label>
							    <div class="col-sm-4">
							    	<select id="service_type_detail" class="form-control" name="service_type_detail"></select>
							    	<input type="text" class="hide" name="service_type_detail_name" id="service_type_detail_name">
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
							    
								  	<label class="col-sm-2 control-label">boss工号</label>
								    <div class="col-sm-4">
								    	<input type="text" class="input-sm form-control" name="boss_code" id="boss_code" value="${myUser.user.userAlias}">
								    </div>
								  </div>
								  <div class="form-group code">
								    <label class="col-sm-2 control-label">操作代码</label>
								    <div class="col-sm-4">
								    	<input type="text" class="input-sm form-control validate[custom[number]]" name="oper_code" id="oper_code">
								    </div>
								    <a href="javascript:;" class="addInputReturn" >
										<span class="glyphicon glyphicon-plus"></span>
						        	</a>
								  </div>
								  <div class="form-group">
								  	<label  class="col-sm-2 control-label">处理结果</label>
								    <div class="col-sm-4">
									  <select name="result"  class="form-control">
									  	<option value="完成">完成</option>
									  	<option value="驳回">驳回</option>
									  </select>
									  </div>
								  </div>
								  </c:if>
								  <div class="form-group">
								  <c:if test="${param.taskName eq '渠道人员'}">
								  	<input type="text" value="完成" name="result" class="hide"/>
								  </c:if>
								   <div id="yjdiv">
									   	<label id="yjlabel" class="col-sm-2 control-label">意见</label>
									    <div class="col-sm-8">
									      <textarea rows="5" class="form-control phrase_" name="desc" id="desc" ></textarea>
									    </div>
									    <a id="addPhrase"><i class="fa fa-plus" style="margin-top: 18px;">设为常用语</i></a>
								   </div>
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