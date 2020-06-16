<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
//var yibanUrl = '${ctx}/jsp/';//已办列表URL
 	$(window).ready(function() {
 		//填充机构信息
 		var orgObj = '${myUser.org}';
 		fillFormOrgs(JSON.parse(orgObj));
 		
 		ifOnWork("#editForm *");
 		
		$("#btn-ok").on("click", function() {
			$(this).attr("disabled","disabled");
			 var b = $("#editForm").validationEngine("validate"); 
			if(b) {
				//$("#service_name").val($("#service_type option:checked").text());
				var pa = new Object();
				pa.token = token_;
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
				$("#work_xiaohu").find(":input").attr("disabled", true);

			}else if(parseInt(work_type)==2){  
				$("#work_kaihu").hide();
				$("#work_kaihu").find(":input").attr("disabled",true);
				$("#work_biangeng").show();
				$("#work_biangeng").find(":input").attr("disabled", false);
				$("#work_xiaohu").hide();
				$("#work_xiaohu").find(":input").attr("disabled", true);
			}else if(parseInt(work_type)==3){
				$("#work_kaihu").hide();
				$("#work_kaihu").find(":input").attr("disabled",true);
				$("#work_biangeng").hide();
				$("#work_biangeng").find(":input").attr("disabled", true);
				$("#work_xiaohu").show();
				$("#work_xiaohu").find(":input").attr("disabled", false);
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
 	
	
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
   						<p>和商务工单</p>
	                </div>
			
		            <div class="ibox-content">
                       <form id="editForm" action="${ctx}/jsp/work/insertCommerce.do"  method="post" class="form-horizontal key-13" >
			                  <input type="text" id="id" name="id" style="display:none"/>
			                  <input type="text" id="taskName" name="taskName" value="渠道人员" style="display:none"/>
 			                  
							   <div class="form-group">
							   		 <label class="col-sm-2 control-label">工单类型</label>
								    <div class="col-sm-4">
								    	<input class="input-sm form-control validate[required]" readonly="readonly" value="和商务工单" name="title" id="title"/>
								    </div>
								    <label class="col-sm-1 control-label">区县</label>
								    <div class="col-sm-4">
								    	<input type="text" class="input-sm form-control "  name="county_name" id="county_name" readonly>
								    	<input type="text" class="hide" name="county" id="county" >
								    </div>
							   </div>
							  <div class="form-group">
								  <label class="col-sm-2 control-label">分局</label>
								    <div class="col-sm-4">
								    	<input type="text" class="input-sm form-control " name="branch_office_name"  id="branch_office_name" readonly>
							    		<input type="text" class="hide" name="branch_office" id="branch_office" >
							    </div>
							  
							    <label class="col-sm-1 control-label">渠道</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control "  name="channel_name" id="channel_name" readonly>
							    </div>
							  </div>
		
							  <div class="form-group">
							    <label class="col-sm-2 control-label">渠道编码</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control " name="channel" id="channel"  readonly>
							    </div>
							 
							    <label class="col-sm-1 control-label">渠道联系方式</label>
							    <div class="col-sm-4">
							     	<input type="number" class="input-sm form-control validate[required]" title="请确认您的个人信息中移动电话是否填写！" value="${myUser.mobilePhone}"  readonly name="channel_phone" id="channel_phone" >
							    </div>
							  </div>
 
							<div class="form-group">
								<label class="col-sm-1 control-label col-sm-offset-1">业务小类</label>
								<div class="col-sm-4">
									<s:dict dictType="zxgd" name="work_type" type="select" clazz="validate[required] form-control" ></s:dict>
								</div> 
							</div>	
	
						    <!-- 开户start -->
				 			<div style="display:none" id="work_kaihu">
				 				 <div class="form-group">
							    <!--集团单位名称-->
							    <label class="col-sm-2 control-label ">集团单位名称</label>
							    <div class="col-sm-4">
							        <input type="text" maxlength="30" class="input-sm form-control validate[required]" name="group_name" maxlength="30" placeholder="请输入30字以内得集团名称">
							    </div>
							    <!--装机地址-->
							    <label class="col-sm-1 control-label ">装机地址</label>
							    <div class="col-sm-4">
							        <input type="text" maxlength="50" class="input-sm form-control validate[required]" name="install_address" placeholder="请输入装机地址"  >
							    </div>
							    

								</div >
								 
								 <div class="form-group">
								    <!--装机联系人-->
								    <label class="col-sm-2 control-label ">装机联系人(客户)</label>
								    <div class="col-sm-4">
								        <input type="text" maxlength="5" class="input-sm form-control validate[required]" name="install_name" placeholder="请输入装机联系人姓名">
								    </div>
								    <!--装机联系手机-->
								    <label class="col-sm-1 control-label ">装机联系手机(客户)</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required,custom[mobile]]" maxlength="11" name="install_phone"  placeholder="请输入手机号码">
								    </div>
								</div>
									
								 <div class="form-group">
								    <!--集团单位法人-->
								    <label class="col-sm-2 control-label ">集团单位法人</label>
								    <div class="col-sm-4">
								        <input type="text" class=" form-control  " maxlength="5" name="group_mainname"  placeholder="请输入法人姓名" >
								    </div>
								    <!--法人手机-->
								    <label class="col-sm-1 control-label ">法人手机</label>
								    <div class="col-sm-4">
								        <input type="text" class=" input-sm form-control validate[custom[mobile]]" name="mainphone"  maxlength="11" placeholder="请输入法人手机号码" >
								    </div>
								</div>
									
								 <div class="form-group">
								    <!--优惠比例-->
								    <label class="col-sm-2 control-label ">优惠比例(%)</label>
								    <div class="col-sm-4">
								        <input type="number" min="0" max="100"  maxlength="3" class="input-sm form-control validate[required,custom[discount_rate]]" name="discount_rate"  placeholder="请输入0到100之间得整数" >
								    </div> 
								</div>
 
				 			</div>
				 			<!-- 开户end -->

						    <!-- 变更start -->
				 			<div   id="work_biangeng" style="display: none;">
				 			
					 			<div class="form-group">
								    <!--专线号（V网产品）-->
								    <label class="col-sm-1 control-label col-sm-offset-1">专线号（V网产品）</label>
								    <div class="col-sm-9">  
								        <textarea class="form-control validate[required]" name="specialnumber" maxlength="30" ></textarea>
								    </div>
	    						</div>
    
				 				 <div class="form-group">
								    <!--集团单位名称-->
								    <label class="col-sm-2 control-label ">集团单位名称</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required]" name="group_name" maxlength="30" placeholder="请输入30字以内得集团名称">
								    </div>
								    <!--装机地址-->
								    <label class="col-sm-1 control-label ">装机地址</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required]" name="install_address" maxlength="50"  placeholder="请输入装机地址"  >
								    </div>  
								</div >
								 
								 <div class="form-group">
								    <!--装机联系人-->
								    <label class="col-sm-2 control-label ">变更联系人</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control validate[required]" name="install_name" maxlength="5" placeholder="请输入变更联系人姓名">
								    </div>
								    <!--装机联系手机-->
								    <label class="col-sm-1 control-label ">变更联系手机</label>
								    <div class="col-sm-4">
								        <input type="text" class="input-sm form-control  validate[required,custom[mobile]]" maxlength="11" name="install_phone" placeholder="请输入手机号码">
								    </div>
								</div>
									
								 <div class="form-group">
								    <!--集团单位法人-->
								    <label class="col-sm-2 control-label ">集团单位法人</label>
								    <div class="col-sm-4">
								        <input type="text" class=" form-control  " name="group_mainname" maxlength="5" placeholder="请输入法人姓名"  >
								    </div>
								    <!--法人手机-->
								    <label class="col-sm-1 control-label ">法人手机</label>
								    <div class="col-sm-4">
								        <input type="text" class=" form-control   validate[custom[mobile]]" name="mainphone"  maxlength="11" placeholder="请输入法人手机号码">
								    </div>
								</div> 
									 
				 			</div>
				 			<!--变更end -->

						    <!-- 销户start -->
				 			<div style="display:none;" id="work_xiaohu">
				 			
					 			<div class="form-group">
								    <!--专线号（V网产品）-->
								    <label class="col-sm-1 control-label col-sm-offset-1">专线号（V网产品）</label>
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
								        <input type="text" class="input-sm form-control validate[required]" name="install_address"  maxlength="50" placeholder="请输入装机地址" >
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
								        <input type="text" class="input-sm form-control  validate[required,custom[mobile]]" name="install_phone" maxlength="11"  placeholder="请输入手机号码">
								    </div>
								</div>
									
								 <div class="form-group">
								    <!--集团单位法人-->
								    <label class="col-sm-2 control-label ">集团单位法人</label>
								    <div class="col-sm-4">
								        <input type="text" class=" form-control  " name="group_mainname" maxlength="5" placeholder="请输入法人姓名"  >
								    </div>
								    <!--法人手机-->
								    <label class="col-sm-1 control-label ">法人手机</label>
								    <div class="col-sm-4">
								        <input type="text" class=" form-control  validate[custom[mobile]] " name="mainphone" maxlength="11" placeholder="请输入法人手机号码"  >
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
							   	<label  class="col-sm-2 control-label">文件上传</label>
							    <div class="col-sm-9">
							    	<input type="file" class="input-sm form-control validate[required]" multiple name="file" id="file" >
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