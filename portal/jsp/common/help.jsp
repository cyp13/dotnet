<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script src="${ctx}/js/plugins/other/jquery.media.js?v=0.99"></script>
<script>
	$(window).resize(function() {
		$("iframe").css("width", document.body.clientWidth);
		$("iframe").css("height", document.body.clientHeight);
	});

	$(window).ready(function() {
		try {
			$("#view").css("width", $(window).width());
			$("#view").css("height", $(window).height());
			jQuery.ajax({
				url: "${ctx}/files/help/${myUser.user.extMap.sys.id}.pdf",
				async: false,
				type: "HEAD",
				success: function() {
					$("#view").attr("src", "${ctx}/files/help/${myUser.user.extMap.sys.id}.pdf");
				},
				error: function() {
					$("#view").attr("src", "${ctx}/files/help/"+encodeURI('统一认证应用集成平台用户手册.pdf'));
				}
			});
			$(".media").media();
		} catch(ex) {}
	})
</script>
</head>

<body>
	<center>
		<div class="media">
			<iframe id="view" style="display: block; border: 0px;"></iframe>
		</div>
	</center>
</body>
</html>