<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<link href="${ctx}/js/plugins/scroll/scroll.1.3.css" rel="stylesheet">
<script src="${ctx}/js/plugins/scroll/scroll.1.3.js"></script>
<script type="text/javascript">
	if (top.location != self.location) {
		top.location = self.location;
	}

	$(window).ready(function() {
		$("title").html('${s:getSys(null).sysName}');
		
		$("#btn-logout").on("click", function() {
			layer.confirm('您确定要退出系统吗？', {
				icon: 3
			}, function() {
				top.location.href = "${ctx}/j_spring_security_logout";
			});
		});
		
		$("#count").dayuwscroll({
			parent_ele: '#wrapBox',
			pre_btn: '#left_btn',
			next_btn: '#right_btn'
		})

		$(".warp-pic-list li a").on("click", function() {
			var sysId = $(this).attr("id");
			var sysUrl = $(this).attr("sysUrl");
			var sysType = $(this).attr("sysType");
			if(sysUrl && "3" == sysType) {
				var token = $(this).attr("token");
				sysUrl += (-1 == sysUrl.indexOf("?") ? "?" : "&") + "token=" + token;
				window.open(sysUrl, "_blank");
			} else if(sysId) {
				location.href = "${ctx}/jsp/index.do?id="+sysId;
			}
		});
	});
	
	try {
		history.pushState(null, null, document.URL);
		window.addEventListener("popstate", function () {
		    history.pushState(null, null, document.URL);
		});
	} catch(ex) {
	}
</script>
</head>

<body class="fixed-sidebar full-height-layout gray-bg skin-1 fixed-nav" style="overflow:hidden">
	<div id="page-wrapper" class="animated fadeIn" style="margin: 0;">
		<div class="row border-bottom">
			<nav class="navbar skin-1 navbar-fixed-top" role="navigation">
				<div class="navbar-header">
					<span>
						<a><img src="${ctx}/images/logo.do" class="logo" /></a>
					</span>
				</div>

				<ul class="nav navbar-top-links navbar-right">
					<li class="hidden-xs">
                        <a id="btn-logout">
                        	<i class="fa fa-power-off"></i>安全退出
                        </a>
                    </li>
				</ul>
			</nav>
		</div>

		<div class="wc1200">
			<div class="warp-pic-list">
				<div id="wrapBox">
					<ul id="count">
						<c:forEach items="${myUser.user.extMap.syss}" var="sys">
							<li>
								<a id="${sys.id}" sysType="${sys.sysType}" sysUrl="${sys.sysUrl}" token="${sys.extMap.token}">
									<c:choose>
										<c:when test="${'3' eq sys.sysType}">
											<img src="${ctx}/js/plugins/scroll/link.png">
										</c:when>
										<c:otherwise>
											<img src="${ctx}/js/plugins/scroll/system.png">
										</c:otherwise>
									</c:choose>
								</a>
								<span>${sys.sysName}</span>
							</li>
						</c:forEach>
					</ul>
					<a id="right_btn" class="prev icon"></a>
					<a id="left_btn" class="next icon"></a>
				</div>
			</div>
		</div>

		<div class="footer">
			<div class="pull-right">
				<span>${s:getSys('').sysCopyrights}</span>
			</div>
		</div>
	</div>
</body>
</html>