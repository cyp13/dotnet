<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
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
<script src="${ctx}/js/plugins/ztree/jquery.ztree.exhide.js"></script>
<script src="${ctx}/js/plugins/ztree/jquery.ztree.id.search.js"></script>
<script src="${ctx}/js/ztree.xiezuo.js"></script>
<script>
//var yibanUrl = '${ctx}/jsp/';//已办列表URL
 	$(window).ready(function() { 
 		
 		var roleObj = '${myUser.extMap.roles}';
 		roleObj = JSON.parse(roleObj);
 		for (var r = 0; r < roleObj.length; r++) {
			if("政企投诉支撑"==roleObj[r].roleName){
				$("#zhuanpai").removeClass("hide");
				$("#roleNames_").addClass("validate[required]");
				$("#editForm").attr("action","${ctx}/jsp/work/insertZQComplaint4ZC.do");
				$("#taskName").val("政企投诉支撑");
				break;
			}else {
				if ("渠道人员" == roleObj[r].roleName) {
					$("#zhuanpai").remove();
					$("#taskName").val("渠道人员");
					break;
				}
			}
		}
 		
 		var now = formatDate(new Date(),"yyyy-MM-dd");
		$("#publish_time").val(now);
		/* $("#reserve_time").val(now); */
 		
 		//填充机构信息
 		var orgObj = '${myUser.org}';
 		fillFormOrgs(JSON.parse(orgObj));
 		
 		ifOnWork("#editForm *");
 		
		$("#btn-ok").on("click", function() {
			$(this).attr("disabled","disabled");
			if($("#xzry_").val()!=""){
				$("#xzry_name").val($(".filter-option").html());
			}
			 var b = $("#editForm").validationEngine("validate");
			if(b) {
				$("#service_type_name").val($("#service_type").val());
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
							);
						}
				});
			} 
			else{
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
		
 		$("#roleNames_").on("change",function(){
			$("#action").val("指派"+$(this).val());
			if("渠道"==$(this).val()){
				$("#orgNames").addClass("validate[required]");
				$("#zhuanjia_").removeClass("validate[required]");
			}else if(""!=$(this).val()){
				var param = new Object();
		 		param.roleName = $(this).val();
		 		getUserByRoleAndOrgPath(param,function(data){
		 			formatData(data, "userName", "userAlias", "select", "#zhuanjia_", "orgName");
		 		});
		 		$("#zhuanjia_").addClass("validate[required]");
				$("#orgNames").removeClass("validate[required]");
			}else{
				$("#orgNames").removeClass("validate[required]");
				$("#zhuanjia_").removeClass("validate[required]");
				$("#action").val("");
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
   						<p>政企投诉响应工单</p>
	                </div>
			
		            <div class="ibox-content">
                       <form id="editForm" action="${ctx}/jsp/work/insertZQComplaint.do"  method="post" class="form-horizontal key-13" >
			                  <input type="text" class="hide" name="action" id="action"/>
			                  <input type="text" id="taskName" name="taskName" style="display:none"/>
							   <div class="form-group">
							   		 <label class="col-sm-2 control-label">客户投诉类型</label>
								    <div class="col-sm-4">
								    	<s:dict dictType="complaint_type" name="title" type="select" clazz="validate[required] form-control" ></s:dict>
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
							  
							    <label class="col-sm-1 control-label">发起人</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control" value="${myUser.userAlias}"  name="publisher" id="publisher" readonly>
							    </div>
							  </div>
		
							  <div class="form-group">
							    <label class="col-sm-2 control-label">发起时间</label>
							    <div class="col-sm-4">
							    	<input type="text"  readonly="readonly"  class="input-sm  form-control validate[required]"  name="publish_time" id="publish_time" >
							    </div>
							 
							    <label class="col-sm-1 control-label">联系方式</label>
							    <div class="col-sm-4">
							     	<input type="number" class="input-sm form-control " title="请确认您的个人信息中移动电话是否填写！" value="${myUser.mobilePhone}"  readonly name="user_phone" id="user_phone" >
							    </div>
							  </div>
		
							  <div class="form-group">
							  	<label class="col-sm-2 control-label">客户手机号码</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control validate[required] " name="client_phone" id="client_phone" maxlength="11">
							    </div>
							     <label class="col-sm-1 control-label">209/10号码</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control " name="number" id="number" maxlength="18">
							    </div>
							  </div>
							  
							  <div class="form-group">
							  	<label class="col-sm-2 control-label">客户地址</label>
							    <div class="col-sm-4">
							    	<textarea rows="3" class="form-control validate[required]"  name="user_address" id="user_address" maxlength="50"></textarea>
							    </div>
							     <label class="col-sm-1 control-label">预约时间</label>
							    <div class="col-sm-4">
							    	<input type="text"  readonly="readonly"  class="input-sm  form-control validate[required] date_time" format="yyyy-MM-dd"  name="reserve_time" id="reserve_time" >
							    </div>
							  </div>
							  
							  <div id="zhuanpai" class="form-group hide">
							  	<label class="col-sm-2 control-label">机构指配</label>
									    <div class="col-sm-4">
									      <input type="text" class="input-sm form-control validate[required]" name="orgNames" id="orgNames" readonly="readonly" >
									      <input type="text" name="orgIds_" id="orgIds" class="input-sm form-control" style="display:none" >
									      <div id="orgDiv" style="display:none;position:absolute;z-index:8888">
											<input type="text" class="input-sm form-control" id="orgTreeKey" placeholder="输入机构代码进行搜索" />
											<ul id="orgDivTree" class="ztree divTree">
											</ul>
										  </div>
					    				</div> 
		                		 <%-- <label  class="col-sm-1 control-label">指定角色</label>
							    <div class="col-sm-4">
							    	<select name="roleNames_" id="roleNames_" class="form-control">
							    	</select>
								 </div> --%>
		                		 <label  class="col-sm-1 control-label">指定人员</label>
							    <div class="col-sm-4">
							    	<select name="xzry_" id="xzry_" class="form-control selectpicker multiple validate[required]">
							    	</select>
							    	<input type="text" class="hide" id="xzry_name" name="xzry_name"/>
								 </div>
							  </div>
							  
							  <div class="form-group">
							    <label  class="col-sm-2 control-label ">描述说明</label>
							    <div class="col-sm-9">
							      <textarea rows="5" class="form-control validate[required]"  name="description" id="description" maxlength="200"></textarea>
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