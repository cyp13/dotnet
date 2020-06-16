<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%
request.setAttribute("PTYPE", "目标打标");
%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<jsp:include page="/jsp/_p/apply.jsp"></jsp:include>
<script>
</script>
</head>
<body class="gray-bg">
<div class="wrapper wrapper-content animated fadeIn">
	<div class="row">
	<div class="ibox float-e-margins">
	<div class="ibox-title"><p>${requestScope.PTYPE}</p></div>
	<div class="ibox-content">
	<!-- 表单开始 -->
	<form id="editForm" action="gongdan/applyForm.do" method="post" class="form-horizontal key-13" >
	<input style="display: none;" name="ptype" id="ptype" value="${requestScope.PTYPE}"/>
	<!-- 固定字段开始 -->
	<div class="form-group">
		<label class="col-sm-2 control-label">工单主题</label>
		<div class="col-sm-4">
			<input type="text" class="form-control validate[required]" name="title" id="title">
		</div>
		<label class="col-sm-1 control-label">区县</label>
		<div class="col-sm-4">
			<input type="text" class="form-control" name="county_name" id="county_name" readonly>
			<input type="text" class="hide" name="county" id="county">
			<input type="text" class="hide" name="city" id="city">
			<input type="text" class="hide" name="sheng" id="sheng">
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-2 control-label">分局</label>
		<div class="col-sm-4">
			<input type="text" class="form-control" name="branch_office_name" id="branch_office_name" readonly>
			<input type="text" class="hide" name="branch_office" id="branch_office">
		</div>
		<label class="col-sm-1 control-label">渠道</label>
		<div class="col-sm-4">
			<input type="text" class="form-control" name="channel_name" id="channel_name" readonly>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-2 control-label">渠道编码</label>
		<div class="col-sm-4">
			<input type="text" class="form-control" name="channel" id="channel" readonly>
		</div>
		<label class="col-sm-1 control-label">渠道联系方式</label>
		<div class="col-sm-4">
			<input type="number" class="form-control" value="${myUser.mobilePhone}" name="channel_phone" id="channel_phone" readonly placeholder="请确认您的个人信息中移动电话是否填写！" >
		</div>
	</div>
	<!-- end -->
	<!-- 可变字段 -->
	<div class="form-group">
		<label class="col-sm-1 control-label col-sm-offset-1">用户手机号码</label>
		<div class="col-sm-4">
			<input type="text" class="form-control validate[required,custom[phone]]" name="user_phone" maxlength="15" placeholder="请填写手机号">
		</div>
		<label class="col-sm-1 control-label">代办业务名称</label>
		<div class="col-sm-4">
			<input type="text" class="form-control validate[required]" name="service_name" maxlength="50" placeholder="请填写代办业务名称">
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-1 control-label col-sm-offset-1">违约金金额</label>
		<div class="col-sm-4">
			<input type="number" class="form-control validate[required,custom[number],min[0],max[9999.99]]" name="liquidated_damages" id="liquidated_damages">
		</div>
		<label class="col-sm-1 control-label">是否申请减免</label>
		<div class="col-sm-4">
			<s:dict dictType="boolean" type="radio" name="if_apply_reduction"/>
		</div>
	</div>
	<!-- end -->
	<!-- 固定字段开始 -->
	<div class="form-group hide">
		<label class="col-sm-2 control-label">描述说明</label>
		<div class="col-sm-9">
			<textarea rows="5" class="form-control" name="description" placeholder="此处可填写受理业务其他说明或描述"></textarea>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-2 control-label">文件上传</label>
		<div class="col-sm-9">
			<input type="file" class="" multiple name="file" id="file" placeholder="此处可填写受理业务其他说明或描述">
		</div>
		<label class="col-sm-2 control-label"></label>
		<div class="col-sm-9">
			<p class="help-block"></p>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-1 control-label col-sm-offset-1"></label>
		<div class="col-sm-9">
			<button type="button" class="btn btn-sm btn-success btn-13" id="btn-ok">
				<i class="fa fa-check"></i> 发布
			</button>
		</div>
	</div>
	<!-- end -->
	</form>
	<!-- 表单结束 -->
	</div>
	</div>
	</div>
</div>
</body>
</html>