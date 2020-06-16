<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ page language="java" import="java.util.*"%>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="page" />

<% //增加随机数，解决CSRF漏洞
	String uuid = UUID.randomUUID().toString().replaceAll("-","");
	//增加当前时间+有效时长
	Long timeStamp = System.currentTimeMillis() + 3*60*1000L;
	request.getSession().setAttribute("csrfToken",uuid);
	request.getSession().setAttribute("timeStamp",timeStamp);
	//设置cookie只读
	//String sessionid = request.getSession().getId();
	//response.setHeader("SET-COOKIE", "JSESSIONID=" + sessionid + "; secure ; HttpOnly"); 	
%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Cache-Control" content="no-cache" /> 
<meta http-equiv="Pragma" content="no-cache" /> 
<meta http-equiv="Expires" content="0" />
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta name="keywords" content="${s:getSys(null).sysName}">
<title>${s:getSys(null).sysName}</title>
<%-- <link rel="shortcut icon" href="${ctx}/favicon.ico"> --%>
<link href="${ctx}/css/login.css" rel="stylesheet">
<link href="${ctx}/css/animate/animate.css?v=3.5.2" rel="stylesheet">
<script>var ctx="${ctx}";</script>
<%-- <script src="${ctx}/js/jquery.min.js"></script> --%>
<script src="${ctx}/js/jquery_login/jquery-3.4.1.min.js"></script> 
<script src="${ctx}/js/plugins/layer/layer.js?v=3.0.3"></script>
<script src="${ctx}/js/jquery.form.js"></script>
<script src="${ctx}/js/public.js"></script>
<script src="${ctx}/js/md5.js"></script>
<script src="${ctx}/js/jquery.base64.js"></script>

<script type="text/javascript">
	document.oncontextmenu = function() {
		return false;
	}

	<c:if test="${not empty myUser}">
		var platformIndex = "${platformIndex}";
		if(!platformIndex) {
			platformIndex = "${s:getProp('target.url')}";
			if(!platformIndex.startWith("http")) {
				platformIndex = "${ctx}" + platformIndex;
			}
		}
		top.location = platformIndex;
	</c:if>

	/* <sec:authorize access="isRememberMe()">
		alert("自动登录");
	</sec:authorize> */
	
	if(top.location != self.location) {
		top.location = self.location;
	}
	
	var checkcode = "${ctx}/images/checkcode.png";
	$(window).ready(function() {
		$("#j_username").focus();
		$("#yzm-img").attr("src",checkcode+"?r="+Math.random());
		$("#yzm-img").bind("click",function() {
			$("#yzm-img").attr("src",checkcode+"?r="+Math.random());
		});
		
		$("#forget").bind("click",function() {
			layer.msg('技术支持：${s:getSys(null).sysSupport}',{offset:"b",time:8000});
		});
		
		$("#lic").bind("click",function() {
			if ($(".lic").is(":hidden")) {
				$(".lic").show();
			} else {
				$(".lic").hide();
			}
		});
		
		$("#btn-lic").bind("click",function() {
			if(!$("#license").val()) {
				layer.msg("请选择license！", {icon: 0});
				return false;
			}
			layer.confirm('上传的license会覆盖原license，上传后应用服务器可能需要重启，您确定要上传吗？', {
				icon: 3
			}, function() {
				ajaxSubmit("#licForm", function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("license上传成功！", {icon: 1});
					}
				});
			});
		});
		
		try {
			$("body").bind("mousedown", function(event) {
				if(3 == event.which) {
					layer.closeAll("loading");
				}
			});
		} catch(ex) {
		}
	});
	
	var dologin = function() {
		var j_username = $("#j_username").val();
		var j_password = $("#j_password").val();
		var j_checkcode = $("#j_checkcode").val();
		if(!j_username) {
			layer.msg("登录账号不能为空",{offset:"b"});
			$("#j_username").focus();
			return false;
		}
		if(!j_password) {
			layer.msg("登录密码不能为空",{offset:"b"});
			$("#j_password").focus();
			return false;
		}
		if(!j_checkcode) {
			layer.msg("验证码不能为空",{offset:"b"});
			$("#j_checkcode").focus();
			return false;
		}
		j_password = $.md5(j_password);
		j_password = $.md5(j_password);
		j_password = $.md5(j_password);
		$("#j_password").val(j_password);
		$("#showUsername").attr("disabled", true);
		//return false;
		$("#btn-submit").attr("disabled", true);
		$("#btn-submit").text("登录中...");
		return true;
	}
	
	try {
		/* var index = 0;
		var bgImgs = ["icon_bg1.jpg","icon_bg2.jpg","icon_bg3.jpg","icon_bg4.jpg"];
		setInterval(function() {
		 	index++; 
			index = index >= bgImgs.length ? 0 : index;
		    var obj = document.getElementsByTagName("body")[0];
		 	obj.style.backgroundImage = "url(${ctx}/images/"+bgImgs[index]+")";
		}, 10000); */
		
		history.pushState(null, null, document.URL);
		window.addEventListener("popstate", function () {
		    history.pushState(null, null, document.URL);
		});
	} catch(ex) {
	}
	
	//转码
	function fillData(obj){
		var value = $(obj).val();
		value = $.base64.encode(value);
		$("#j_username").val(value);
	}
</script>
</head>
<body>
	<div id="main" class="animated fadeIn">
		<div class="header">
			<img src="${ctx}/images/logo.do" class="logo"/>
		</div>
		
		<div class="content">
			<form action="${ctx}/j_spring_security_check" method="post" onsubmit="return dologin()">
				<div class="right">
				<input type="hidden" name="randSesion"  value = "<%=request.getSession().getAttribute("csrfToken")%>" />
					<div>
						<fieldset>
							<div class="inputWrap j_username">
								<input type="text" id="showUsername"  name="showUsername" onchange="fillData(this)" placeholder="登录账号" required="required" maxlength="18">
								<input type="hidden" name="j_username" id="j_username"> 
							</div>
							<div class="inputWrap j_password">
								<input type="password" id="j_password" name="j_password" placeholder="登录密码" required="required" autocomplete="off" maxlength="16">
							</div>
							<div class="inputWrap j_checkcode">
								<input type="text" id="j_checkcode" name="j_checkcode" placeholder="验证码" required="required" maxlength="4">
								<img id="yzm-img" title="点击刷新"/>
							</div>
						</fieldset>
						<fieldset>
							<label title="5天内自动登录"><input type="checkbox" name="j_remember_me" value="true">自动登录</label>
							<a id="forget" style="float:right;cursor:pointer;">忘记密码？</a>
						</fieldset>
					</div>
					
					<div style="color:#ff0000;text-align:center;">
						<button type="submit" name="submit" id="btn-submit">登录</button>
						<p>${SPRING_SECURITY_LAST_EXCEPTION.message}</p>
					</div>
				</div>
			</form>
		</div>
		
		<%-- <div class="footer">
			<span>${s:getSys('').sysCopyrights}</span>
		</div> --%>
	</div>
</body>
</html>