<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script src="${ctx}/js/plugins/ztree/jquery.ztree.exhide.js"></script>
<script src="${ctx}/js/plugins/ztree/jquery.ztree.id.search.js"></script>
<script src="${ctx}/js/ztree.governmentResources.js"></script>
<script>
//var yibanUrl = '${ctx}/jsp/';//已办列表URL
 	$(window).ready(function() {
 		ifOnWork("#editForm *");
 		
		$("#btn-ok").on("click", function() {
			$(this).attr("disabled","disabled");
			 var b = $("#editForm").validationEngine("validate"); 
			if(b) {
				//$("#service_name").val($("#service_type option:checked").text());
				var pa = new Object();
				pa.token = token_;
				console.log(1);
				ajaxSubmit("#editForm",pa, function(data) {
					if ("error" == data.resCode) {
						layer.msg(data.resMsg, {icon: 2});
						$("#btn-ok").removeAttr("disabled");
					} else {
							layer.msg("数据处理成功！", 
									{icon: 1},function(){
									closeCurPage();
								}
							)
						}
				});
			} 
			else{
				$("#btn-ok").removeAttr("disabled");
			}
		});
		
		 $('#bussiness_small_type').change(function(){
			if ($('#bussiness_small_type').val() == "移机") {
				$('#specialnumber').show();
				$('input[name=special_number]').addClass('validate[required]');
			}else {
				$('#specialnumber').hide();
				$('input[name=special_number]').removeClass('validate[required]');
				$('#specialnumber').attr("disabled",true);
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
 	
 	});
 	
	
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
   						<p>政企资源业务工单</p>
	                </div>
			
		            <div class="ibox-content">
                       <form id="editForm" action="${ctx}/jsp/work/insertGovernmentResources.do"  method="post" class="form-horizontal key-13" >
			                  <input type="text" id="id" name="id" style="display:none"/>
			                  <input type="text" id="taskName" name="taskName" value="渠道人员" style="display:none"/>
			                  <input type="text" value="政企资源业务工单"  name="form_type" id="form_type" style="display:none"/>
 			                  
							   <div class="form-group">
							   		 <label class="col-sm-2 control-label">发起人</label>
								    <div class="col-sm-4">
								    	<input class="input-sm form-control validate[required]"  name="originator" value="${myUser.userAlias}" id="originator" readonly>
								    </div>
								    <label class="col-sm-1 control-label">发起人所属机构</label>
								    <div class="col-sm-4">
								    	<input type="text" class="input-sm form-control "  name="organization_name" value="${myUser.org.orgName}" id="organization_name" readonly>
								    </div>
							   </div>
		
							  <div class="form-group">
								    <label class="col-sm-2 control-label">发起人联系方式</label>
								    <div class="col-sm-4">
								     	<input type="number" class="input-sm form-control validate[required]" title="请确认您的个人信息中移动电话是否填写！" value="${myUser.mobilePhone}"  readonly name="originator_phone" id="originator_phone" >
								    </div>
								    <label class="col-sm-1 control-label">发起人机构编码</label>
								    <div class="col-sm-4">
								    	<input type="text" class="input-sm form-control " name="organization_code" value="${myUser.orgId}" id="organization_code"  readonly>
								    </div>
							  </div>
							  <div class="form-group">
							  	<label class="col-sm-2 control-label">业务小类</label>
							  	<div class="col-sm-4">
								  	<select class="form-control validate[required]" name="bussiness_small_type" id="bussiness_small_type">
								  		<option value="">请选择类型</option>
								  		<option value="开户">开户</option>
								  		<option value="移机">移机</option>
								  	</select>
							  	</div>
								 <!--  专线号 -->
								 <div id="specialnumber" style="display:none">
								 	<label class="col-sm-1 control-label">专线号</label>
								 	<div class="col-sm-4">
								 		<input type="text" class="input-sm form-control" name="special_number" placeholder="请输入专线号" maxlength="20">
								 	</div>
								 </div>
							  </div>
	
			 				 <div class="form-group">
						    <!--集团单位名称-->
							    <label class="col-sm-2 control-label ">集团单位名称</label>
							    <div class="col-sm-4">
							        <input type="text" maxlength="30" class="input-sm form-control validate[required]" name="group_name" maxlength="30" placeholder="请输入30字以内得集团名称">
							    </div>
							    <label class="col-sm-1 control-label">集团编码</label>
							    <div class="col-sm-4">
							    	<input type="text" maxlength="20" class="input-sm form-control" name="group_coding" placeholder="请输入集团编码">
							    </div>
							</div >
							
							 <div class="form-group">
							 	<!--装机地址-->
							    <label class="col-sm-2 control-label ">装机地址</label>
							    <div class="col-sm-1">
							        <s:dict dictType="install_address" type="select" name="install_address" clazz="form-control validate[required]"></s:dict>
							    </div>
							 	<div class="col-sm-8">
							 		<input type="text" name="particular_address" class="form-control validate[required]" maxlength="50" placeholder="街道-门牌-栋号-楼层-房号"></textarea>
							 	</div>
							 </div>
							 
							 <div class="form-group">
							    <!--装机联系人-->
							    <label class="col-sm-2 control-label ">装机联系人(客户)</label>
							    <div class="col-sm-4">
							        <input type="text" maxlength="20" class="input-sm form-control validate[required]" name="install_name" placeholder="请输入装机联系人姓名">
							    </div>
						     	<!--装机联系手机-->
							    <label class="col-sm-1 control-label ">装机联系手机（客户）</label>
							    <div class="col-sm-4">
							        <input type="text" class="input-sm form-control  validate[required,custom[mobile]]" maxlength="11" name="install_phone" placeholder="请输入手机号码">
							    </div>
							</div>
								
							 <div id="zhuanpai" class="form-group">
							  	<label class="col-sm-2 control-label">客户经理所属机构</label>
									    <div class="col-sm-4">
									      <input type="text" class="input-sm form-control validate[required]" name="orgNames" id="orgNames" readonly="readonly" >
									      <input type="text" name="orgIds_" id="orgIds" class="input-sm form-control" style="display:none" >
									      <div id="orgDiv" style="display:none;position:absolute;z-index:8888">
											<input type="text" class="input-sm form-control" id="orgTreeKey" placeholder="输入机构代码进行搜索" />
											<ul id="orgDivTree" class="ztree divTree"  
											 style="background-color:lightgrey">
											</ul>
										  </div>
					    				</div> 
		                		 <label  class="col-sm-1 control-label">客户经理姓名</label>
							    <div class="col-sm-4">
							    	<select name="customer_manager" id="customer_manager" class="form-control selectpicker validate[required]">
							    	</select>
							    	<input type="text" class="hide" id="customer_manager_name" name="customer_manager_name"/>
								 </div>
							  </div>
							  
							<div class="form-group">
							    <!--是否“和飞速”-->
							    <label class="col-sm-2 control-label ">是否“和飞速”</label>
							    <div class="col-sm-4">
							    	<label>
							        	<input type="radio" name="if_hefeisu"  value="是" checked="checked"><span style="padding: 0px 10px 0px 5px;">是</span>
							    	</label>
							    	<label>
							        	<input type="radio" name="if_hefeisu"  value="否"><span style="padding: 0px 10px 0px 5px;">否</span>
							    	</label>
							    </div> 
							</div>
							<div class="form-group">
								<label class="col-sm-2 control-label">描述说明</label>
								<div class="col-sm-9">
									<textarea rows="3" class="form-control" name="remark" id="remark" maxlength="200" placeholder="此处可填写受理业务其他说明或描述（非必填项） "></textarea>
								</div>
							</div>	
						   <div class="form-group">
							   	<label  class="col-sm-2 control-label">文件上传</label>
							    <div class="col-sm-9">
							    	<input type="file" class="input-sm form-control" multiple name="file" id="file" >
							    </div>
						   </div>
							   <div class="form-group">
								   	<div class="col-sm-9 col-sm-offset-2">
								   		<button type="button" class="btn btn-sm btn-success btn-13" id="btn-ok">
						                	<i class="fa fa-check"></i> 发布
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