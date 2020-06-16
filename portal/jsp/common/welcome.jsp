<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
	$(window).ready(function() {
		$("title").html("欢迎页面");
	})
</script>
<style type="text/css">
	i {
	   /*  color: #4974A4; */
	}
</style>
</head>
<body class="gray-bg animated fadeIn">
	<div class="row border-bottom white-bg dashboard-header">
		<div class="col-sm-12">
			<div class="col-sm-1">
				<i class="fa fa-user-circle fa-5x"></i>
			</div>
			<div class="col-sm-11">
				<blockquote>
					<h3><i class="fa fa-user-o"></i> ${myUser.user.userAlias}，您好！欢迎使用${myUser.user.extMap.sys.sysName}</h3>
					<h4><i class="fa fa-bell-o"></i> 这是您第 ${myUser.user.loginCount + 1} 次登录系统，上次登录时间：<fmt:formatDate value="${myUser.user.lastLoginTime}" pattern="yyyy-MM-dd HH:mm:ss" />，上次登录IP：${myUser.user.lastLoginIp}</h4>
					<hr>
					<h5><i class="fa fa-warning"></i> 温馨提示：1、左侧菜单栏如为空，请联系管理员授权；2、表单中带有“<img src="${ctx}/images/icon_star.png">”的元素均为必填（选）项；3、表单中下拉框如为空，可根据提示在数据字典中配置。</h5>
					<h5><i class="fa fa-internet-explorer"></i> 系统要求：为了保证系统运行的正确性和流畅性，建议使用<a>Chrome</a>、<a>Firefox</a>或IE9及以上版本的浏览器</h5>
					<h5><i class="fa fa-envelope"></i> 技术支持：<a>${myUser.user.extMap.sys.sysSupport}</a></h5>
				</blockquote>
			</div>
		</div>
	</div>
</body>
</html>