<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%-- <%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%> --%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<style>
	body,html{margin:0;padding:0}
	.background{width:728px;height:311px;position:absolute;background: url("${ctx}/images/404.jpg");
				top:50%;left:50%;margin-top:-195px;margin-left:-364px;text-align: center;}
	.background button{margin-top:280px;}
	.btn-success{background:#2e79e6;border:1px solid #2e79e6;min-width: 120px;color:white;
		cursor:pointer;border-radius: 3px;display: inline-block;padding: 6px 12px;margin-bottom: 0;
	    font-size: 14px;font-weight: 400;line-height: 1.42857143; text-align: center; white-space: nowrap;}
</style>
</head>
<body class="white-bg">
	<div class="middle-box text-center animated fadeInDown">
		<c:if test="${'401' == param.status}">
			<h1>${param.status}</h1>
			<h3 class="font-bold">未被授权！</h3>
			<div class="error-desc">未被授权，请先登录</div>
		</c:if>
		<c:if test="${'403' == param.status}">
			<h1>${param.status}</h1>
			<h3 class="font-bold">权限限制！</h3>
			<div class="error-desc">抱歉，访问被拒绝了...</div>
		</c:if>
		<c:if test="${'500' == param.status}">
			<h1>${param.status}</h1>
			<h3 class="font-bold">服务器内部错误！</h3>
			<div class="error-desc">抱歉，服务器好像出错了...</div>
		</c:if>
	</div>
	<c:if test="${'404' == param.status}">
		<div class="background animated fadeInDown">
			<button type="button" class="btn-success">返回</button>
		</div>
	</c:if>
	<%-- <s:prop key="platform.main"></s:prop> --%>
	<script>
		$("button").click(function(){
			/* window.history.go(-1) */
			parent.location.href='<s:prop key="platform.main"></s:prop>'
		})
	</script>
</body>
</html>