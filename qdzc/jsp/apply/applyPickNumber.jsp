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
		
 	});
 	
	
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
   						<p>业务代办工单</p>
	                </div>
			
		            <div class="ibox-content">
                       <form id="editForm" action="${ctx}/jsp/work/insertPickNumber.do"  method="post" class="form-horizontal key-13" >
			                  <input type="text" id="id" name="id" style="display:none"/>
			                  
							   <div class="form-group">
							   		 <label class="col-sm-2 control-label">工单主题</label>
								    <div class="col-sm-4">
								    	<input class="input-sm form-control validate[required]" name="title" id="title"/>
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
								    	<input type="text" class="input-sm form-control "  name="branch_office_name"  id="branch_office_name" readonly>
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
							  	<label class="col-sm-2 control-label">选中号码</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control validate[required, custom[mobile]] " maxlength="11" name="user_phone" id="user_phone">
							    </div>
							    
							  	<label class="col-sm-1 control-label">客户姓名</label>
							    <div class="col-sm-4">
							    	<input type="text" maxlength="5	" class="input-sm form-control validate[required]" name="user_name" id="user_name">
							    </div>
							  </div>
		
							  <div class="form-group">
							  	<label class="col-sm-2 control-label">身份证号码</label>
							    <div class="col-sm-4">
							    	<input type="text" maxlength="18" class="input-sm form-control validate[required,custom[chinaId]]" name="china_id" id="china_id">
							    </div>
							    <label class="col-sm-1 control-label">客户地址</label>
							    <div class="col-sm-4">
							    	<input type="text" maxlength="50" class="input-sm form-control validate[required]" name="user_address" id="user_address">
							    </div>
							  </div>
							   <div class="form-group">
							   	<label  class="col-sm-2 control-label">身份证正面</label>
							    <div class="col-sm-9">
							    	<input type="file" class="input-sm form-control" name="file" id="file" accept="image/*">
							    </div>
							   </div>
							   <div class="form-group">
							   	<label  class="col-sm-2 control-label">身份证背面</label>
							    <div class="col-sm-9">
							    	<input type="file" class="input-sm form-control" name="file" id="file" accept="image/*">
							    </div>
							   </div>
							   <div class="form-group">
							   	<label  class="col-sm-2 control-label">手持身份证</label>
							    <div class="col-sm-9">
							    	<input type="file" class="input-sm form-control" name="file" id="file" accept="image/*">
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