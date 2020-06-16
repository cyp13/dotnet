<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ page import="java.io.PrintStream,java.io.ByteArrayOutputStream"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="status" value="${pageContext.errorData.statusCode}" scope="page" />

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
	<c:if test="${empty myUser}">
	 	var page = window.location.pathname;
		if (page.endWith("${ctx}/jsp/index.do")) {
			top.location.href = "${ctx}/j_spring_security_logout";
			/* layer.msg("跳转中...", {
				offset:"b",
				time: 1000
			}, function() {
				top.location.href = "${ctx}/j_spring_security_logout";
			}); */
		}
	</c:if>

	$(window).ready(function() {
		$("title").html("消息页面");
		
		$(".a-login").on("click", function() {
			top.location.href = "${ctx}/j_spring_security_logout";
		});
	})
</script>
</head>
<body class="gray-bg">
	<div class="middle-box text-center animated fadeIn" style="max-width: 500px;">
		<h1>${status}</h1>
		
		<c:if test="${'339' == status}">
			<h3 class="font-bold">请求失败！</h3>
			<div class="error-desc">
				请求失败，请联系管理员。登录、返回、<a class="a-reload">刷新</a>
			</div>
			<h2>
				<textarea class="form-control" id="remark" rows="6">请求失败，请联系管理员。</textarea>
			</h2>
		</c:if>
		
		<c:if test="${'400' == status}">
			<h3 class="font-bold">请求出错！</h3>
			<div class="error-desc">
				抱歉，语法格式有误，请联系管理员，登录、返回、<a class="a-reload">刷新</a>
			</div>
			<h2>
				<textarea class="form-control" id="remark" rows="6">${requestScope['javax.servlet.error.message']}</textarea>
			</h2>
		</c:if>
		
		<c:if test="${'401' == status}">
			<h3 class="font-bold">未被授权！</h3>
			<div class="error-desc">
				抱歉，未被授权，请联系管理员，登录、返回、<a class="a-reload">刷新</a>
			</div>
			<h2>
				<textarea class="form-control" id="remark" rows="6">${requestScope['javax.servlet.error.message']}</textarea>
			</h2>
		</c:if>
		
		<c:if test="${'403' == status}">
			<h3 class="font-bold">禁止访问！</h3>
			<div class="error-desc">
				抱歉，访问被拒绝，请联系管理员，登录、返回、<a class="a-reload">刷新</a>
			</div>
			<h2>
				<textarea class="form-control" id="remark" rows="6">${requestScope['javax.servlet.error.message']}</textarea>
			</h2>
		</c:if>
		
		<c:if test="${'404' == status}">
			<h3 class="font-bold">页面不存在！</h3>
			<div class="error-desc">
				抱歉，页面不存在，登录、返回、<a class="a-reload">刷新</a>
			</div>
		</c:if>

		<c:if test="${'405' == status}">
			<h3 class="font-bold">指定的请求方式！</h3>
			<div class="error-desc">
				抱歉，请求方式错误，登录、返回、<a class="a-reload">刷新</a>
			</div>
			<h2>
				<textarea class="form-control" id="remark" rows="6">${requestScope['javax.servlet.error.message']}</textarea>
			</h2>
		</c:if>
		
		<c:if test="${'500' == status}">
			<h3 class="font-bold">服务器内部错误！</h3>
			<div class="error-desc">
				抱歉，服务器内部错误，请联系管理员，登录、返回、<a class="a-reload">刷新</a>
			</div>
			<h2>
				<textarea class="form-control" id="remark" rows="6">${requestScope['javax.servlet.error.message']}</textarea>
			</h2>
			<%-- <%if (null != exception) {
				ByteArrayOutputStream os = new ByteArrayOutputStream();
				exception.printStackTrace(new PrintStream(os));%>
			<h2>
				<textarea class="form-control" id="remark" rows="6"><%=os%></textarea>
			</h2>
			<%}%> --%>
		</c:if>
	</div>
</body>
</html>