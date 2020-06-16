<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String templateName = request.getParameter("templateName");
%>
<html>
<head>
<base href="<%=basePath %>">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>测试IM</title>
<link rel="stylesheet" href="js/layui/css/layui.css">
</head>
<body>

<script type="text/javascript" src="js/jquery.min.js"></script>
<script type="text/javascript" src="js/layui/layui.js"></script>
<script type="text/javascript" src='js/smack/strophe.js'></script>
<script type="text/javascript" src="js/smack/pingstream.n.js"></script>

<script>
$(function(){

$('#password').keyup(function(event){
	if (event.keyCode == 13) {
		$('#connectbtn').click();
	}
});
$('#username').select();

});
</script>

<fieldset class="layui-elem-field layui-field-title" style="margin-top: 20px;">
  <legend>登录到openfire</legend>
</fieldset>
 
<form class="layui-form" action="">
	<div class="layui-form-item">
		<div class="layui-inline">
			<label class="layui-form-label">BOSH地址</label>
			<div class="layui-input-inline">
				<input type="text" id="bosh" lay-verify="required" autocomplete="off" placeholder="请输入BOSH地址" class="layui-input" value="http://192.168.60.108:7070/http-bind/">
			</div>
		</div>
	</div>
	
	<div class="layui-form-item">
		<div class="layui-inline">
			<label class="layui-form-label">用户名</label>
			<div class="layui-input-inline">
				<input type="text" id="username" lay-verify="required" autocomplete="off" placeholder="请输入账号" class="layui-input" value="admin">
			</div>
			<div class="layui-form-mid layui-word-aux">@openfire</div>
		</div>
	</div>
	
	<div class="layui-form-item">
		<div class="layui-inline">
			<label class="layui-form-label">密码</label>
			<div class="layui-input-inline">
				<input type="password" id="password" lay-verify="required" autocomplete="off" placeholder="请输入密码" class="layui-input" value="">
			</div>
		</div>
	</div>
	  
	<div class="layui-form-item">
		<div class="layui-input-block">
			<button type="button" class="layui-btn" onclick="connect();" id="connectbtn">登录</button>
			<button type="reset" class="layui-btn layui-btn-primary" onclick="location.reload();">重置</button>
		</div>
	</div>
	
	<div class="layui-form-item">
		<div class="layui-block">
			<label class="layui-form-label"></label>
			<div class="layui-input-block">
				<div class="layui-form-mid layui-word-aux" id="logbar"></div>
			</div>
		</div>
	</div>
</form>

</body>
</html>