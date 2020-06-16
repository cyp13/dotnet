<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<style type="text/css">
ul.divTree {
	width: 232px;
	height: 300px;
	border: 1px solid #ccc;
	background: #f3f3f3;
	overflow: auto;
}
</style>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<jsp:include page="/jsp/apply/xiezuoBase.jsp"></jsp:include>
<script src="${ctx}/js/plugins/ztree/jquery.ztree.exhide.js"></script>
<script src="${ctx}/js/plugins/ztree/jquery.ztree.id.search.js"></script>
<script src="${ctx}/js/ztree.xiezuo.js"></script>
<script>

	var queryUrl = "${ctx}/jsp/work/queryXiezuo.do";
	var queryXiezuoHisUrl = "${ctx}/jsp/work/queryXiezuoExt.do";
	
	var pid = '${param.pId}';
	var flag = '${param.flag}';
	var taskId = '${param.taskId}';
	var taskName = '${param.taskName}';

 	$(window).ready(function() {
 		
 		//获取常用语
 		getPhraseToPage();
 		$(".phrase_").typeahead({
	 		 source: phrases
	 	});	
 		
 		//设置初始化意见栏label值
 		$("#desc").text("意见");
 		
 		//默认不能编辑
 		$(".dataForm input,.dataForm textarea").attr('readonly','readonly');
 		$(".dataForm select,.dataForm input[type='radio']").attr('disabled','disabled');
 		
 		$("#flag").val(flag);
 		$("#taskId").val(taskId); 
 		$("#taskName").val(taskName); 
 		$("#pid").val(pid); 
 		
 		if(flag=="2"){
	 		var param = new Object();
	 		param.roleName = "协作人员";
	 		getUserByRoleAndOrgPath(param,function(data){
	 			formatData(data, "userName", "userAlias", "select", "#zhuanjia_", "orgName");
	 		});
 		}

 		//填充数据
 		if(pid){
			var obj = new Object();			
			obj.pid=pid;//实例ID
			obj.url=queryUrl;
			obj.token=token_;
			
			ajax(obj, function(data){
				var row = data.Rows[0];
				$("#editForm").fill(row);
				
				if(row.opinions){
					if(flag!='4'){
						getOpinionsAndFiles(row.opinions,"#filesAndOpinion");
					}else{
						getOpinionsAndFiles(row.opinions,"#filesAndOpinion",1);
					}
				}
				
				if(row.tag_ifsuccess&&flag=='1'){
					$("#tag").removeClass("hide");
				}
				
				if(row.status=="2"){//表示已解决
					$(".ibox-content input,.ibox-content textarea,.ibox-content select").attr('disabled','disabled');
				}
				
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
				
				if(row.service_type){
					$("#ywlx").removeClass('hide');
					$("#service_type,#service_type_detail").attr("disabled","disabled");
					if(flag=="2"){
						$("#service_type,#service_type_detail").removeAttr("disabled");
					}
					
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
 			$("#opinion").addClass('hide');
 			$("#result").removeClass('validate[required]');
 			$("#desc").removeClass('validate[required]');
 			$("#evaluate").removeClass('hide');
			$(".hs").removeClass("hide");
 			
 			var param = new Object();
 			param.pId=pid;
 			param.key="ActivityPath_";
 			queryProcessVariable(param,function(datas){
 				if(datas){
					if('[]' == datas){
						$("#sub1").removeClass('hide');
 					}else if(datas.length>2){
 						$("#confirm").html("归档");
 					}
 				}else{
						$("#sub1").removeClass('hide');
					}
 			});
 			
 		}else{
 			$("#finish_date").attr("disabled",true);
 			$(".ext1").attr("disabled",true);
 			if(flag!='4'){
 				$("#opinion").removeClass('hide');
 				$("#yijian").removeClass('hide');
 	 			$("#desc").addClass('validate[required]');
 	 			$("#service_type").addClass('validate[required]');
 	 			$("#fileUpload").removeClass("hide");
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
 		 		$("#finish_date").removeAttr('disabled');
 		 		$("#fileUpload").removeClass("hide");
 			}
 			else{
 				$(".dataForm input,.dataForm textarea").attr('readonly','readonly');
 		 		$(".dataForm select").attr('disabled','disabled');
 		 		$("#finish_date").attr('disabled','disabled');
 		 		$("#fileUpload").addClass("hide");
 			}
 		});
 		
 		//转派联动
			$("#result").on("change",function(){
	 			if($(this).val()=="转派"){
	 				$("#zhuanpai").removeClass("hide");
	 				$("#orgNames").addClass("validate[required]");
	 		 		$("#xzry_").addClass("validate[required]");
	 				
	 			}
	 			else{
	 				$("#zhuanpai").addClass("hide");
	 		 		$("#orgNames").removeClass("validate[required]");
	 		 		$("#xzry_").removeClass("validate[required]");
	 			}
	 		});
 		
 		
			$("#orgNames").on("click", function() {
				orgDivTree = $.fn.zTree.init($("#orgDivTree"), orgAllLoadsetting);
				$("body").unbind("mousedown");
				if ($("#orgDiv").is(":hidden")) {
					$("#orgDiv ul").width(500).height(150);
					$("#orgDiv").css({
						top : "30px"
					}).fadeIn("fast", function() {
						orgDivTree = !orgDivTree ? $.fn.zTree.init($("#orgDivTree"), orgAllLoadsetting) : orgDivTree;
						$("#orgTreeKey").val("");
						idFuzzySearch("orgDivTree", "#orgTreeKey", false, false);
						asyncForAll = false;
						asyncAll();
						setTimeout(function(){
							bindOrgTreeEvent();
						}, 1000);
					});
				}
				
			});
 		
		$("#btn-ok").on("click", function() {
			$(this).attr("disabled","disabled");
			if($("#xzry_").val()!=""){
				$("#xzry_name").val($(".filter-option").html());
			}
 			if(!$(".delFile")&&!$("#file").val()){
				$("#file").addClass("validate[required]");
  			}
 			for(var key in deleteFileIds){
				$("#editForm").append('<input type="hidden" name="deleteFileIds" value="'+key+'" />');
			}
			
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				ajaxSubmit("#editForm", function(data) {
					if ("error" == data.resCode) {
						layer.msg(data.resMsg, {icon: 2});
						$("#btn-ok").removeAttr("disabled");
					} else {
						layer.msg("数据处理成功！", {icon: 1},function(){
							back_();
						});
					}
				});
			}else{
				$("#btn-ok").removeAttr("disabled");
			}
		});
		
		$(".date_time").on("click", function() {
			var format = $(this).attr("format");
			var date = formatDate(new Date());
			if(!format){
				format = "yyyy-MM-dd HH:mm:ss";
			}
			WdatePicker({
				dateFmt:format,
				minDate:date
			});
		});
		
		<c:if test="${param.taskName.indexOf('支撑')>-1}">
		var queryZPHisTask = function() {
			var zpTable = $("#zp_datas").dataTable({
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
	 	queryZPHisTask();
		</c:if>
		
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
 	});
	
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
			
		            <div class="ibox-content">
                       <form id="editForm" action="${ctx}/jsp/work/subXiezuo.do"  method="post" class="form-horizontal key-13" >
			                  <input type="text" id="id" name="id" style="display:none"/>
			                  <input type="text" id="pid" name="pid" style="display:none"/>
			                  <input type="text" id="flag" name="flag" style="display:none"/>
			                  <input type="text" id="taskId" name="taskId" style="display:none"/>
			                  <input type="text" id="taskName" name="taskName" style="display:none"/>
			                  <div class="dataForm">
								  <div class="form-group">
								   		 <label class="col-sm-2 control-label">工单主题</label>
									    <div class="col-sm-4">
									    	<input class="input-sm form-control validate[required]"  name="title" id="title"/>
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
								    	<input type="text" class="input-sm form-control readonly" readonly id="service_type_name" name="service_type_name" />
								    </div>
								  </div>
								
								  <div class="form-group">
								  	 <label class="col-sm-2 control-label">用户号码</label>
								    <div class="col-sm-4">
								    	<input type="text"  readonly="readonly" disabled="disabled"  class="input-sm  readonly form-control date_time"  name="user_phone" id="user_phone" >
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
								      <textarea rows="5" class="form-control " name="description" id="description" ></textarea>
								    </div>
								  </div>
								  
								  <!-- 打标签DOM BEGIN-->							 
								
								<div id="filesAndOpinion"></div>
								
								<div class="form-group" style="padding-top:30px;">		
									<label class="col-sm-2 control-label">&nbsp;</label>
									<div class="col-sm-9">
										<span>打标签</span>
										<hr style="border-color:#ddd;">												
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
								<div class="form-group code">
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
							    
							    <!-- 打标签DOM END-->	
							    							
							  </div>
							  
							  <div id="sub1" class="sub hide">
							  		<hr>
								   <div class="form-group">
								   	<label  class="col-sm-2 control-label">是否重发</label>
								   	<div class="col-sm-4">
									   	 <input type="radio" class="action" value="归档" name="action" checked="checked"/>放弃
									   	 <input type="radio" class="action" value="发布" name="action"/>重发
								  	</div>
								  </div>
							  </div>
							  
							  <div class="form-group" style="margin-top:50px;">
							  	<label class="col-sm-2 control-label">&nbsp;</label>
								<div class="col-sm-9">
									<span>转派详情</span>
									<hr style="border-color:#ddd;">												
								</div>
							  	<label class="col-sm-2 control-label"></label>
							  	<div class="col-sm-9">
								   	<c:if test="${param.taskName.indexOf('支撑')>-1}">
									  <table id="zp_datas" class="table display" style="width:100%;border-bottom: 1px solid #ddd;">
							                  <thead>
							                      <tr style="color:#999;">
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
								   	</c:if>
							   	</div>
							  </div>
						  			
							   <div id="opinion" class="hide">
							
							   	<div class="form-group"  style="margin-top:0px;">
								   	<label class="col-sm-2 control-label">&nbsp;</label>
									<div class="col-sm-9">
										<span>我的回复</span>
										<hr style="border-color:#ddd;">												
									</div>
								  	<label  class="col-sm-2 control-label">处理结果</label>
									<c:if test="${param.taskName.indexOf('支撑')>-1}">
									    <div class="col-sm-4">
										  <select name="result" id="result"  class="form-control">
											  	<option value="回复">回复</option>
											  	<option value="转派">转派</option>
											  	<option value="驳回">驳回</option>
										  	</select>
										 </div>
									 	<label class="col-sm-1 control-label">是否办理成功</label>
								   		<div class="col-sm-4">
									   		<select name="tag_ifsuccess" id="tag_ifsuccess" class="form-control validate[required]">
									   			<option value="">请选择</option>
									   			<option value="是">是</option>
									   			<option value="否">否</option>
									   		</select>
								   		</div>
									  </c:if>
									  	
									  <c:if test="${param.taskName.indexOf('协作人员')>-1 }">
									  	<div class="col-sm-4">
										  	 <select name="result" id="result"  class="form-control">
										  	 	<option value="回复">回复</option>
										  	 	<option value="驳回">驳回</option>
										  	 </select>
										 </div>
									  </c:if>
								  </div>
						
								</div>
								
								<div id="zhuanpai" class="form-group hide">
									  	<label class="col-sm-2 control-label">机构指配</label>
											    <div class="col-sm-4">
											      <input type="text" class="input-sm form-control" name="orgNames" id="orgNames" readonly="readonly" >
											      <input type="text" name="orgIds_" id="orgIds" class="input-sm form-control" style="display:none" >
											      <div id="orgDiv" style="display:none;position:absolute;z-index:8888">
													<input type="text" class="input-sm form-control" id="orgTreeKey" placeholder="输入机构代码进行搜索" />
													<ul id="orgDivTree" class="ztree divTree">
													</ul>
												  </div>
							    				</div> 
				                		 <label  class="col-sm-1 control-label">指定人员</label>
								    <div class="col-sm-4">
								    	<select name="xzry_" id="xzry_" class="form-control selectpicker multiple">
								    	</select>
								    	<input type="text" class="hide" id="xzry_name" name="xzry_name"/>
									 </div>
								  </div>
								<div id="yijian" class="hide">
								  <div class="form-group">
								  <c:if test="${param.taskName eq '渠道人员'}">
								  	<input type="text" value="完成" name="result" class="hide"/>
								  </c:if>
								    <label  class="col-sm-2 control-label">意见</label>
								    <div class="col-sm-8">
								      <textarea rows="5" rows="5" class="form-control phrase_" name="desc" id="desc" ></textarea>
								    </div>
								    <a id="addPhrase"><i class="fa fa-plus" style="margin-top: 18px;">设为常用语</i></a>
								  </div>
							  </div>
							  <div id="fileUpload" class="hide">
								  <%-- <c:if test="${param.taskName eq '渠道人员'}"> --%>
								  	<div class="form-group">
								   	<label  class="col-sm-2 control-label">文件上传</label>
								    <div class="col-sm-9">
								    	<input type="file" class="input-sm form-control" multiple name="file" id="file" >
								    </div>
								   </div>	
								  <%-- </c:if> --%>
							  </div>
							  <div class="form-group hide hs">
							  	<label class="col-sm-2 control-label">处理意见</label>
							  	<div class="col-sm-9">
							  		<textarea rows="5" class="col-sm-12" name="handling_suggestion" maxlength="200"></textarea>
							  	</div>
							  </div>
							   <div class="form-group">
								   	<div class="col-sm-9 col-sm-offset-2">
								   		<button type="button" class="btn btn-sm btn-success btn-13" id="btn-ok">
						                	<i class="fa fa-check"></i> <span id="confirm">确定</span>
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