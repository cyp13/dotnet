<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%
request.setAttribute("PTYPE", "目标打标");
%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<jsp:include page="/jsp/_p/node2.jsp"></jsp:include>
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
	<form id="editForm" action="gongdan/transmitForm.do" method="post" class="form-horizontal key-13" >
	<input style="display: none;" name="ptype" id="ptype" value="${requestScope.PTYPE}"/>
	<div class="dataForm">
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
			<input type="text" class="form-control validate[required,custom[phone]]" name="user_phone" maxlength="11" placeholder="请填写手机号">
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
			<input type="radio" name="if_apply_reduction" value="1" checked="checked"/>是
			<input type="radio" name="if_apply_reduction" value="0"/>否
		</div>
	</div>
	<!-- end -->
	<!-- 固定字段开始 -->
	<div class="form-group">
		<label class="col-sm-2 control-label">备注</label>
		<div class="col-sm-9">
			<textarea rows="5" class="form-control" name="description" id="description" placeholder=""></textarea>
		</div>
	</div>
	<div class="form-group">
		<label class="col-xs-2 control-label">附件：</label>
		<div class="col-xs-9 control-label" id="fileList" style="text-align: left;"></div>
	</div>
	</div>
	<hr>
	<div class="form-group">
		<label class="col-sm-2 control-label">业务大类</label>
		<div class="col-sm-4" id="service_type" clazz="validate[required] form-control">
		</div>
		<label class="col-sm-1 control-label">业务小类</label>
		<div class="col-sm-4" id="service_type_detail" clazz="validate[required] form-control">
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-2 control-label">处理结果</label>
		<div class="col-sm-4">
			<label>
				<input type="radio" name="OUT_CONTROL" value="完成" checked="checked"/><span style="padding: 0px 10px 0px 5px;">回复</span>
			</label>
			<label>
				<input type="radio" name="OUT_CONTROL" value="驳回"/><span style="padding: 0px 10px 0px 5px;">驳回</span>
			</label>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-2 control-label">意见</label>
		<div class="col-sm-9">
			<textarea rows="5" class="form-control validate[required]" name="desc" id="desc" placeholder="请填写意见"></textarea>
		</div>
	</div>
	<div class="form-group">
		<label class="col-sm-1 control-label col-sm-offset-1"></label>
		<div class="col-sm-9">
			<input name="node" style="display: none;" value="2"/>
			<input name="id" style="display: none;"/>
			<input name="pid" style="display: none;" value="${param.pId }"/>
			<input name="taskId" style="display: none;" value="${param.taskId }"/>
			<button type="button" class="btn btn-sm btn-success btn-13" id="btn-ok">
				<i class="fa fa-check"></i> 确定
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