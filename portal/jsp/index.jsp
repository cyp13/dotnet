<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script src="${ctx}/js/plugins/metisMenu/metisMenu.js?v=2.7.0"></script>
<script src="${ctx}/js/plugins/slimscroll/jquery.slimscroll.min.js?v=1.3.1"></script>
<script src="${ctx}/js/plugins/WdatePicker/WdatePicker.js"></script>
<script src="${ctx}/js/md5.js"></script>
<!-- 自定义js -->
<script src="${ctx}/js/hplus/hplus.js?v=4.1.0"></script>
<script src="${ctx}/js/hplus/contabs.js"></script>
<script src="${ctx}/js/WebSocket.js"></script>
<script type="text/javascript">
	var queryUserUrl = "${ctx}/jsp/sys/queryUser.do";
	var updateOwnerUrl = "${ctx}/jsp/sys/updateOwner.do";
	var queryUserRoleUrl = "${ctx}/jsp/sys/queryUserRole.do";
	
	var querySysUrl = "${ctx}/jsp/sys/querySys.do?id=${myUser.user.extMap.sys.id}";
	var updateSysUrl = "${ctx}/jsp/sys/updateSys.do?ajax=1";
	var initSysUrl = "${ctx}/jsp/sys/init.do";

	var pageUrl = "${ctx}/jsp/sys/page.do";
	var insertPageUrl = "${ctx}/jsp/sys/insertPage.do";
	
	var queryMsgRecordUrl = "${ctx}/jsp/sys/queryMsgRecord.do";
	
	var pwdUpUrl = "${ctx}/jsp/sys/updateOwner.do";

	if(top.location != self.location) {
		top.location = self.location;
	}
	
	//去掉new
	function cancelNew(){
		$(".s-msg9").html("");
	}
	
	var userExt3 ='${myUser.user.ext3}';
	var userId = '${myUser.user.id}';
	var ext1 = '${myUser.user.org.ext1}';
	
	$(window).ready(function() {
		
		if(userExt3 != 1 && (ext1 === 'MY' || ext1 === 'YA' || ext1 === 'LS' || ext1 === 'DY')){
			$("#pwdUpForm").attr("action", pwdUpUrl);
			$("#pwdUserId").val(userId);
			$("#myModal").modal("show");
		}
		
		$("#iframe0").attr("src", pageUrl);
		
		$("#btn-logout").on("click", function() {
			layer.confirm('您确定要退出系统吗？', {
			//	skin: 'layui-layer-lan',
				icon: 3
			}, function() {
				top.location.href = "${ctx}/j_spring_security_logout";
			});
		});
		
		$("#btn-pwdUp-colse").on("click",function(){
			layer.confirm('您确定要退出系统吗？', {
				//	skin: 'layui-layer-lan',
					icon: 3
				}, function() {
					top.location.href = "${ctx}/j_spring_security_logout";
				});
		});
		
		$("#btn-pwdUp-ok").on("click",function(){
			var b = $("#pwdUpForm").validationEngine("validate");
			if(b){
				newPassword = $("#newPassword").val();
				confirmPwd = $("#confirmPwd").val();
				if(newPassword === confirmPwd){
					
					newPassword = $("#newPassword").val();
					newPassword = $.md5(newPassword);
					newPassword = $.md5(newPassword);
					newPassword = $.md5(newPassword);
					$("#newPassword").val(newPassword);
					
					confirmPwd = $("#confirmPwd").val();
					confirmPwd = $.md5(confirmPwd);
					confirmPwd = $.md5(confirmPwd);
					confirmPwd = $.md5(confirmPwd);
					$("#confirmPwd").val(confirmPwd);
					
					ajaxSubmit("#pwdUpForm", function(result) {
						if ("error" == result.resCode) {
	 						layer.msg(result.resMsg, {icon: 2});
						} else {
							layer.msg("数据处理成功！", {icon: 1});
							$("#myModal").modal("hide");
						}
					});
				}else{
					layer.msg("两次输入密码不一致", {icon: 2});
				}
				 
			}
			
		});
		
		$("#btn-sys").on("click", function() {
			$("#sysForm")[0].reset();
			$("#sysForm").attr("action", updateSysUrl);
			$("#sysModal").modal("show");
			var obj = new Object();
			obj.url = querySysUrl;
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					$("#sysForm").fill(result.datas[0]);
					$("#oldUserId").val(result.datas[0].userId);
				}
			});
		});

		$("#btn-sys-ok").on("click", function() {
			var b = $("#sysForm").validationEngine("validate");
			if(b) {
				ajaxSubmit("#sysForm", function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						$("#sysModal").modal("hide");
						$("#logo").attr("src", "${ctx}/images/logo.do?id=${myUser.user.extMap.sys.id}&r="+Math.random());
					}
				});
			}
		});
		
		$("#btn-user").on("click", function() {
			menuItem("个人信息", "${ctx}/jsp/sys/userInfo.jsp");
			return;
			
			$("#userForm")[0].reset();
			$("#userForm").attr("action", updateOwnerUrl);
			$("#userModal").modal("show");
			
			$("#password").attr("placeholder","不填不会修改密码");
			
			var obj = new Object();
			obj.url = queryUserUrl;
			obj.id = "${myUser.user.id}";
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					$("#userForm").fill(result.datas[0]);
					$("#password").val("");
					queryUserRole(obj.id);
					if(result.datas[0].extMap.org) {
						$("#orgName").val(result.datas[0].extMap.org.orgName);
						$("#orgId").val(result.datas[0].extMap.org.id);
					}
				}
			});
			
		});

		$("#btn-user-ok").on("click", function() {
			var b = $("#userForm").validationEngine("validate");
			if(b) {
				ajaxSubmit("#userForm", function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						$("#userModal").modal("hide");
					}
				});
			}
		});
		
		$("#btn-help").on("click", function() {
			menuItem("在线帮助", "${ctx}/jsp/common/help.jsp");
		});
		
		$(".a-detail").on("click", function() {
			menuItem("个人信息", "${ctx}/jsp/sys/userInfo.jsp");
		});

		$(".a-msg").on("click", function() {
			if($(this).attr('msgType') == '9') {
				$(".s-msg9").html("");
				menuItem("待处理", "${ctx}/api/jbpm/taskList.do?msgType=9");
			} else {
				$(".s-msg").html("");
				menuItem("通知", "${ctx}/jsp/sys/msg.jsp?msgType=!9");
			}
		});
		
		$("#btn-clear").on("click", function() {
			layer.confirm('您确定要清空缓存吗？', {
				icon: 3
			}, function() {
				var obj = new Object();
				obj.url = initSysUrl;
				ajax(obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("清空成功！", {icon: 1});
					}
				});
			});
		});

		$("#btn-lic").on("click", function() {
			$("#licForm")[0].reset();
			$("#licModal").modal("show");
			try {
				$.get("${ctx}/LICENSE", null, function(tex){
		            $("#licTxt").val(tex);  
		        }, "text");
				$("#licForm").find("input[type=text]").attr("placeholder","上传license");
			} catch(ex) {
			}
		});
		
		$("#btn-lic-ok").on("click", function() {
			var b = $("#licForm").validationEngine("validate");
			if(b) {
				layer.confirm('上传的license会覆盖原license，上传后应用服务器可能需要重启，您确定要上传吗？', {
					icon: 3
				}, function() {
					ajaxSubmit("#licForm", function(result) {
						if ("error" == result.resCode) {
							layer.msg(result.resMsg, {icon: 2});
						} else {
							layer.msg("license上传成功！", {icon: 1});
							$("#licModal").modal("hide");
						}
					});
				});
			}
		});
		
		$("#btn-page").on("click", function() {
			$("#pageForm").attr("action", insertPageUrl);
			$("#pageModal").modal("show");

			$("#btn-page-ok").on("click", function() {
				var b = $("#pageForm").validationEngine("validate");
				if(b) {
					ajaxSubmit("#pageForm", function(result) {
						if ("error" == result.resCode) {
							layer.msg(result.resMsg, {icon: 2});
						} else {
							layer.msg("数据处理成功！", {icon: 1});
							$("#pageModal").modal("hide");
							refreshItem("default_page");
						}
					});
				}
			});
		});
		
		$("#btn-about").on("click", function() {
			layer.open({
				title: '关于系统',
				icon: 0,
				closeBtn: 0, //不显示关闭按钮
				shadeClose: true, //开启遮罩关闭
				area: ['750px','415px'],
				resize:false,
			    content: $('#about').html()
			});
		});
		
		$(".${myUser.user.extMap.sys.id}").css({"background-color":"#f4f4f4"});
		$(".btn-sys-exchange").on("click", function() {
			var sysId = $(this).attr("sysId");
			var sysUrl = $(this).attr("sysUrl");
			var sysType = $(this).attr("sysType");
			if(sysId == "${myUser.user.extMap.sys.id}") {
				return;
			}
			if(sysUrl && "3" == sysType) {
				var token = $(this).attr("token");
				sysUrl += (-1 == sysUrl.indexOf("?") ? "?" : "&") + "token=" + token;
				window.open(sysUrl, "_blank");
			} else if(sysId) {
				location.href = "${ctx}/jsp/index.do?id="+sysId;
			}
		});
		
		queryMsgRecord();
		
	});
	
	var queryUserRole = function(userId) {
		if(userId) {
		 	var obj = new Object();
			obj.url = queryUserRoleUrl;
			obj.userId = userId;
		 	ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					var roleNames = [], roleIds = [];
					$.each(result.datas, function(i,o) {
						roleNames.push(o.roleName);
						roleIds.push(o.roleId);
					});
				    $("#roleNames").val(roleNames.join(","));
				    $("#roleIds").val(roleIds.join(","));
				}
			});
		}
	}
	
	var queryMsgRecord = function() {
		var userId = "${myUser.user.id}";
		if(userId) {
			initSocket();
			
			var obj = new Object();
			obj.url = queryMsgRecordUrl;
			obj.userId = userId; 
			obj.flag_ = "all"; 
			obj.readStatus = "2"; 
			obj.msgType = "!9";
			jQuery.ajax({
				url : obj.url,
				data : obj,
				type : "POST",
				dataType : "json",
				success : function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						var msgs = result.datas.length;
						$(".s-msg").html(msgs <= 0 ? "" : msgs);
					}
				}
			});
			
			return;
			
			obj.msgType = "9";
			jQuery.ajax({
				url : obj.url,
				data : obj,
				type : "POST",
				dataType : "json",
				success : function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						var msgs = result.datas.length;
						$(".s-msg9").html(msgs <= 0 ? "" : "new");
					}
				}
			});
		}
	}
	
	var initSocket =  function() {
		var Socket1 = $.websocket({
			uri : "${ctx}/api/socket/${myUser.user.id}/${myUser.username}",
		    onMessage : function(result) {
		    	try {
		    		if("new" == result) {
				    	$(".s-msg9").html(result);
		    		} else if("-new" == result) {
				    	$(".s-msg9").html("");
		    		} else {
				    	var msgs = $(".s-msg").html();
				    	msgs = msgs ? parseInt(msgs) : 0;
				    	msgs = msgs + parseInt(result);
				    	$(".s-msg").html(msgs <= 0 ? "" : msgs);
		    		}
		    	} catch(e) {
		    	}
		    }
		});
		setTimeout(function() {
		//	Socket1.send('hi');
		}, 5000);
	}
	
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
    <div id="wrapper" class="animated fadeIn">
        <!--左侧导航开始-->
        <nav class="navbar-default navbar-static-side" role="navigation">
            <!-- <div class="nav-close">
            	<i class="fa fa-times-circle"></i>
            </div> -->
            <div class="sidebar-collapse">
            	<s:menu />
            </div>
        </nav>
        <!--左侧导航结束-->
        
        <!--右侧部分开始-->
        <div id="page-wrapper" class="gray-bg dashbard-1">
            <div class="row border-bottom">
                <nav class="navbar navbar-fixed-top" role="navigation">
                    <div class="navbar-header">
                    	<span>
                    		<a><img id="logo" src="${ctx}/images/logo.do?id=${myUser.user.extMap.sys.id}" style="max-height: 60px; max-width: 800px;"></a>
	                    </span>
                    </div>
                    <ul class="nav navbar-top-links navbar-right">
                        <li class="hidden-xs">
                            <a class="a-detail">${fn:trim(myUser.user.userAlias)}，您好！</a>
                        </li>
                        
                        <!-- <li class="dropdown hidden-xs">
                            <a class="right-sidebar-toggle">
                                <i class="fa fa-yelp"></i>主题
                            </a>
                        </li> -->

						<li class="hidden-xs">
	                        <a class="a-msg dropdown-toggle count-info" msgType="9">
	                            <i class="fa fa-bell"></i>消息
	                            <span class="label label-warning s-msg9"></span>
	                        </a>
	                    </li>
	                    
						<li class="hidden-xs">
	                        <a class="a-msg dropdown-toggle count-info">
	                            <i class="fa fa-bullhorn"></i>通知
	                            <span class="label label-warning s-msg"></span>
	                        </a>
	                    </li>

                        <li class="hidden-xs">
                            <a data-toggle="dropdown">
                            	<i class="fa fa-cog"></i>设置
                            </a>
		                    <ul role="menu" class="dropdown-menu dropdown-menu-right">
		                        <li>
		                        	<a id="btn-user"><i class="fa fa-user-circle"></i> 个人信息</a>
		                        </li>
		                        <sec:authorize access="hasRole('${myUser.user.extMap.sys.roleId}')">
			                        <li>
			                        	<a id="btn-sys"><i class="fa fa-windows"></i> 系统信息</a>
			                        </li>
			                        <li>
			                        	<a id="btn-clear"><i class="fa fa-repeat"></i> 清空缓存</a>
			                        </li>
		                        </sec:authorize>
		                       <%--  <c:if test="${myUser.user.extMap.sys.userId eq myUser.user.id}">
		                        </c:if> --%>
								<li>
		                        	<a id="btn-lic"><i class="fa fa-ticket"></i> 授权许可</a>
		                        </li>
		                        
		                        <li class="divider"></li>
		                        <li>
		                        	<a id="btn-help"><i class="fa fa-question-circle-o"></i> 在线帮助</a>
		                        </li>
		                        <!-- <li>
		                        	<a id="btn-about"><i class="fa fa-info-circle"></i> 关于系统</a>
		                        </li> -->
		                        
								<li/>
		                    </ul>
                        </li>
						
						<c:if test="${null ne myUser.user.extMap.syss && fn:length(myUser.user.extMap.syss) > 1}">
	                        <li class="hidden-xs">
	                            <a data-toggle="dropdown">
	                            	<i class="fa fa-exchange"></i>切换
	                            </a>
			                    <ul role="menu" class="dropdown-menu dropdown-menu-right">
			                    	<c:forEach items="${myUser.user.extMap.syss}" var="sys">
				                        <li>
				                        	<a class="btn-sys-exchange ${sys.id}" sysId="${sys.id}" sysType="${sys.sysType}" sysUrl="${sys.sysUrl}" token="${sys.extMap.token}">
				                        		<c:choose>
													<c:when test="${'3' eq sys.sysType}">
														<i class="fa fa-external-link-square"></i> ${sys.sysName}
													</c:when>
													<c:otherwise>
														<i class="fa fa-windows"></i> ${sys.sysName}
													</c:otherwise>
												</c:choose>
				                        	</a>
				                        </li>
		                    		</c:forEach>
									<li/>
			                    </ul>
	                        </li>
                        </c:if>
                        
                        <li class="hidden-xs">
                            <a id="btn-logout">
                            	<i class="fa fa-power-off"></i>安全退出
                            </a>
                        </li>
                    </ul>
                </nav>
            </div>

            <div class="row content-tabs">
                <button class="roll-nav roll-left navbar-minimalize" title="隐藏菜单">
                	<i class="fa fa-outdent"></i>
                </button>
                
                <button class="roll-nav roll-left J_tabLeft">
                	<i class="fa fa-backward"></i>
                </button>
                
                <nav class="page-tabs J_menuTabs">
                    <div class="page-tabs-content">
                        <a href="javascript:;" class="active J_menuTab" data-id="default_page">首页</a>
                    </div>
                </nav>
                
                <button class="roll-nav roll-right J_tabRight">
                	<i class="fa fa-forward"></i>
                </button>
                
                <div class="btn-group roll-nav roll-right">
                    <button class="dropdown J_tabClose" data-toggle="dropdown" title="选项卡">
                    	<i class="fa fa-chevron-down"></i>
                    	<%-- 关闭<span class="caret"></span> --%>
                    </button>
                    <ul role="menu" class="dropdown-menu dropdown-menu-right">
                        <li class="J_tabShowActive">
                        	<a>定位当前选项卡</a>
                        </li>
                        <li class="divider"></li>
                        <li class="J_tabCloseAll">
                        	<a>关闭全部选项卡</a>
                        </li>
                        <li class="J_tabCloseOther">
                        	<a>关闭其他选项卡</a>
                        </li>
                        <li class="divider"></li>
                        <li id="btn-page">
                        	<a>定制首页选项卡</a>
                        </li>
                    </ul>
                </div>
            </div>
            
            <div class="row J_mainContent" id="content-main">
            	<iframe class="J_iframe" name="iframe0" id="iframe0" data-id="default_page" seamless style="width:100%; height:100%; display:block; border:0px;"></iframe>
                <!-- <iframe class="J_iframe" name="iframe0" id="iframe0" data-id="default_page" seamless width="100%" height="100%" frameborder="0"></iframe> -->
            </div>
            
            <div class="footer">
                <div class="pull-right">
                	<span>${myUser.user.extMap.sys.sysCopyrights}</span>
                </div>
            </div>
        </div>
        <!--右侧部分结束-->
        
        <!--右侧边栏开始-->
        <div id="right-sidebar">
            <div class="sidebar-container">
                <div class="tab-content">
                    <div id="tab-1" class="tab-pane active">
                        <div class="setings-item blue-skin nb">
                            <span class="skin-name ">
		                    	<a class="s-skin-1">蓝色主题</a>
		                   	</span>
                        </div>
                        <div class="setings-item default-skin nb">
                            <span class="skin-name ">
                        		<a class="s-skin-0">绿色主题</a>
                  			 </span>
                        </div>
                        <div class="setings-item yellow-skin nb">
                            <span class="skin-name ">
                       			<a class="s-skin-3">黄色主题</a>
                   			</span>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!--右侧边栏结束-->
    
    <!-- edit start-->
	<div class="modal fade" id="sysModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:60%;">
	        <div class="modal-content ibox">
	        	<form id="sysForm" class="form-horizontal key-13" role="form">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-windows"></i> 系统信息</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
		            
		            <div class="ibox-content">
	                  <input type="text" name="id" style="display:none"/>
	                  <input type="text" name="rowVersion" style="display:none"/>
	                  <input type="text" name="sysBelong" style="display:none"/>
	                  <input type="text" name="sysUrl" style="display:none"/>
	                  <input type="text" name="sysType" style="display:none"/>
	                  <input type="text" name="orgId" style="display:none"/>
	                  <input type="text" name="userId" style="display:none"/>
	                  <input type="text" id="oldUserId" name="oldUserId" style="display:none"/>
	                  <input type="text" name="roleId" style="display:none"/>
	                  <input type="text" name="sortNo" style="display:none"/>
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">系统代码</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required,custom[tszf]]" name="sysCode" id="sysCode" readonly="readonly" maxlength="16">
					    </div>
					    <label class="col-sm-2 control-label">系统名称</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required,custom[tszf]]" name="sysName" id="sysName" maxlength="64">
					    </div>
					  </div>

					  <div class="form-group">
					    <label class="col-sm-2 control-label">系统版本</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required,custom[tszf]]" name="sysVersion" id="sysVersion" maxlength="16">
					    </div>
					    <label class="col-sm-2 control-label">发布日期</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required] date_select" name="sysRelease" readonly="readonly">
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">技术支持</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required,custom[tszf]]" name="sysSupport" id="sysSupport" placeholder="电子邮件或联系电话" maxlength="16">
					    </div>
					    <label class="col-sm-2 control-label">LOGO</label>
					    <div class="col-sm-4">
					      <input type="file" name="sys_logo" id="sys_logo"  accept=".jpeg,.jpg,.png,.bmp,.gif"/>
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">版权信息</label>
					    <div class="col-sm-10">
					      <input type="text" class="input-sm form-control validate[required,custom[tszf]]" name="sysCopyrights" id="sysCopyrights" >
					    </div>
					  </div>

					  <div class="form-group">
					    <label  class="col-sm-2 control-label">首页URL</label>
					    <div class="col-sm-10">
					      <input type="text" class="input-sm form-control validate[custom[tszf]]" name="sysPage" id="sysPage" >
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">日志</label>
					    <div class="col-sm-4">
					      <label><input type="radio" name="sysLog" value="1" checked="checked">有效</label>
					      <label><input type="radio" name="sysLog" value="0">禁用</label>
					    </div>
					    <label class="col-sm-2 control-label">状态</label>
					    <div class="col-sm-4">
					      <label><input type="radio" name="rowValid" value="1" checked="checked">有效</label>
					      <label><input type="radio" name="rowValid" value="0">禁用</label>
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">备注</label>
					    <div class="col-sm-10">
					      <textarea class="form-control" name="remark"></textarea>
					    </div>
					  </div>
		            </div>
		            
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-sys-ok">
		                	<i class="fa fa-check"></i> 确定
		                </button>
		                <button type="button" class="btn btn-sm btn-default" id="btn-sys-cancel" data-dismiss="modal">
		                	<i class="fa fa-ban"></i> 取消
		                </button>
		            </div>
				</form>
	        </div>
	    </div>
	</div>
	<!-- edit end-->
	
	<!-- edit start-->
	<div class="modal fade" id="userModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:60%;">
	        <div class="modal-content ibox">
                <form id="userForm" class="form-horizontal key-13" role="form">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-user-circle"></i> 个人信息</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
		            
		            <div class="ibox-content">
	                  <input type="text" name="id" style="display:none"/>
	                  <input type="text" id="rowVersion" name="rowVersion" style="display:none"/>
	                  <input type="text" id="rowValid" name="rowValid" style="display:none"/>
	                  <input type="text" id="ext1" name="ext1" style="display:none"/>
	                  <input type="text" id="ext2" name="ext2" style="display:none"/>
	                  <input type="text" id="ext3" name="ext3" style="display:none"/>
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">登录账号</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="userName" id="userName" readonly="readonly" maxlength="18">
					    </div>
					    <label class="col-sm-2 control-label">密码</label>
					    <div class="col-sm-4">
					      <input type="password" class="input-sm form-control validate[minSize[4]]" name="password" id="password" autocomplete="off" maxlength="16">
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">姓名</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="userAlias" id="userAlias" maxlength="16">
					    </div>
					    <label class="col-sm-2 control-label">所属机构</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control" name="orgName" id="orgName" readonly="readonly" >
					      <input type="text" name="orgId" id="orgId" style="display:none" >
					    </div>
					  </div>
					  
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">性别</label>
					    <div class="col-sm-4">
					      <label><input type="radio" name="userSex" value="1" checked="checked">男</label>
					      <label><input type="radio" name="userSex" value="0">女</label>
					    </div>
					    <label class="col-sm-2 control-label">证件号码</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[custom[chinaIdLoose]]" name="userPid" id="userPid" placeholder="身份证编号" maxlength="18">
					    </div>
					  </div>

					  <div class="form-group">
					  	<label class="col-sm-2 control-label">政治面貌</label>
					    <div class="col-sm-4">
					      <s:dict dictType="userParty" clazz="input-sm form-control"></s:dict>
					    </div>
					    <label class="col-sm-2 control-label">民族</label>
					    <div class="col-sm-4">
					      <s:dict dictType="userNation" clazz="input-sm form-control"></s:dict>
					    </div>
					  </div>
					  
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">类型</label>
					    <div class="col-sm-4">
					      <s:dict dictType="userType" clazz="input-sm form-control"></s:dict>
					    </div>
					    <label class="col-sm-2 control-label">职级</label>
					    <div class="col-sm-4">
					      <s:dict dictType="userLevel" clazz="input-sm form-control"></s:dict>
					    </div>
					  </div>
					  
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">职称</label>
					    <div class="col-sm-4">
					      <s:dict dictType="userTitle" clazz="input-sm form-control"></s:dict>
					    </div>
					    <label class="col-sm-2 control-label">职务</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control" name="userPosition" id="userPosition" maxlength="16">
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">学历</label>
					    <div class="col-sm-4">
					      <s:dict dictType="userEdu" clazz="input-sm form-control"></s:dict>
					    </div>
					    <label  class="col-sm-2 control-label">电子邮件</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[custom[email]" name="userEmail" id="userEmail" maxlength="32">
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">办公电话</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[custom[phone]" name="officePhone" id="officePhone" maxlength="11">
					    </div>
					    <label  class="col-sm-2 control-label">移动电话</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[custom[phone],minSize[11],maxSize[11]]" name="mobilePhone" id="mobilePhone" maxlength="11" >
					    </div>
					  </div>

					  <div class="form-group">
					    <label  class="col-sm-2 control-label">角色信息</label>
					    <div class="col-sm-10">
					      <input type="text" class="input-sm form-control" name="roleNames" id="roleNames" readonly="readonly">
					      <input type="text" name="roleIds" id="roleIds" style="display:none" >
					    </div>
					  </div>

					  <div class="form-group">
					    <label  class="col-sm-2 control-label">备注</label>
					    <div class="col-sm-10">
					      <textarea class="form-control" name="remark"></textarea>
					    </div>
					  </div>
		            </div>
		            
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-user-ok">
		                	<i class="fa fa-check"></i> 确定
		                </button>
		                <button type="button" class="btn btn-sm btn-default" id="btn-user-cancel" data-dismiss="modal">
		                	<i class="fa fa-ban"></i> 取消
		                </button>
		            </div>
				</form>
	        </div>
	    </div>
	</div>
	<!-- edit end-->

	<!-- edit start-->
	<div class="modal fade" id="licModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:60%;">
	        <div class="modal-content ibox">
	        	<form id="licForm" action="${ctx}/api/license.do?ajax=1" class="form-horizontal key-13" role="form" onsubmit="return false;">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-ticket"></i> 授权许可</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
		            
		            <div class="ibox-content">
					  <div class="form-group">
					    <div class="col-sm-12">
					      <h5>本程序使用权已授予：北京众信佳科技发展有限公司</h5>
					      <textarea class="form-control" id="licTxt" readonly="readonly" style="height:300px;resize:none"></textarea>
					    </div>
					  </div>
		            </div>
		            
					<div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success" onclick='javascript:$("#licModal").modal("hide");'>
		                	<i class="fa fa-check"></i> 确定
		                </button>
			        </div>
				</form>
	        </div>
	    </div>
	</div>
	<!-- edit end-->

	<!-- edit start-->
	<div class="modal fade" id="pageModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:500px;">
	        <div class="modal-content ibox">
	        	<form id="pageForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-home"></i> 定制首页</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
		            
		            <div class="ibox-content">
					  <div class="form-group">
					    <label class="col-sm-3 control-label">首页版块数量</label>
					    <div class="col-sm-9">
					      <input type="number" class="input-sm form-control validate[required,custom[integer],maxSize[1]]" name="panels" id="panels" placeholder="建议版块总数<=6">
					      <input type="hidden" name="pageType" value="1">
					    </div>
					  </div>
		            </div>
		            
					<div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-page-ok">
		                	<i class="fa fa-check"></i> 确定
		                </button>
		                <button type="button" class="btn btn-sm btn-default" id="btn-page-cancel" data-dismiss="modal">
		                	<i class="fa fa-ban"></i> 取消
		                </button>
			        </div>
				</form>
	        </div>
	    </div>
	</div>
	<!-- edit end-->
	
	<div id="about" style="display:none;">
		<%-- <a><img src="${ctx}/images/logo.do"></a> --%>
        <h3>${myUser.user.extMap.sys.sysName}</h3>
        <p>系统版本：${myUser.user.extMap.sys.sysVersion} 发布日期：${myUser.user.extMap.sys.sysRelease} 技术支持：<a>${myUser.user.extMap.sys.sysSupport}</a>
        </p>
        <p>
        	<div style="width:100%;height:186px;overflow:auto;font-size:13px;border:1px solid #e3e3e3;padding:10px;background-color: #f9f9f9;">
		        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;本软件基于J2EE技术体系、B/S架构模式的三层结构设计完成，具有跨平台（Linux、Windows）、跨数据库（Oracle、MySQL、SQL Server）、安全可靠、性能卓越、纯浏览器应用、维护成本低等优点，可快速便捷的集成第三方应用和扩展开发各类MIS系统。
		        <!-- <li>核心思想：账号管理、认证管理、授权管理、操作审计</li> -->
		        <li>基础模块：系统管理（多应用集成管理）、权限管理、流程管理、报表管理（JasperReport、Cognos）</li>
		        <li>认证管理：CAS（SSO单点登录）、LDAP（域认证）、DB（本地数据库认证）</li>
		        <li>技术框架：Spring Security（安全框架）、Spring MVC（Web框架）、MyBatis（持久层框架）、Ehcache（缓存框架）、Quartz（调度框架）、Jbpm（流程引擎）、JasperReport（报表引擎）、Drools（规则引擎）</li>
		        <div class="alert alert-warning" style="margin-top:10px;margin-bottom:0px;">
			        <p><i class="fa fa-warning"></i> 温馨提示：1、左侧菜单栏如为空，请联系管理员授权；2、表单中带有“<img src="${ctx}/images/icon_star.png">”的元素均为必填（选）项；3、表单中下拉框如为空，可根据提示在数据字典中配置。</p>
		        	<p><i class="fa fa-internet-explorer"></i> 系统要求：为了保证系统运行的流畅性，建议使用<a>Chrome</a>、<a>Firefox</a>或IE10及以上版本的浏览器</p>
		        	<p><i class="fa fa fa-user-circle"></i> 技术支持：<a>it_life@qq.com</a></p>
		        </div>
       		</div>
        </p>
       	${myUser.user.extMap.sys.sysCopyrights}
    </div>
	<!-- edit start-->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" data-keyboard="false" >
	    <div class="modal-dialog" style="width:30%;">
	        <div class="modal-content ibox">
                <form id="pwdUpForm" class="form-horizontal key-13" role="form">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i> 修改密码</h5>
	                </div>
		            
		            <div class="ibox-content">
	                	<input type="hidden" id="pwdUserId" name="id" />
	                  	<input type="hidden" name="ext3" value="pwdUp" />
					  <!-- <div class="form-group">
					    <label class="col-sm-2 control-label">原密码</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="dictType" id="dictType" maxlength="16">
					    </div>-->
					    <div class="class="form-group" style="text-align:center"">
					  		<font size="3" color="#FF0000">原密码强度太弱，请修改后再使用</font>
					    </div><br>
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">新密码</label>
					    <div class="col-sm-4">
					      <input type="password" class="input-sm form-control validate[required,custom[passStrength]]" name="password" id="newPassword" maxlength="16">
					    </div>
					    <font size="1" color="#FF0000">密码至少大写，小写字母，数字组成，8-16位</font>
					  </div>
					 <div class="form-group">
					     <label class="col-sm-2 control-label">确认新密码</label>
					    <div class="col-sm-4">
					      <input type="password" class="input-sm form-control validate[required,custom[passStrength]]" name="confirmPwd" id="confirmPwd" >
					    </div>
					    <font size="1" color="#FF0000">密码至少大写，小写字母，数字组成，8-16位</font>
					  </div>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-pwdUp-ok">
		                	<i class="fa fa-check"></i> 确定
		                </button>
		                <button type="button" class="btn btn-sm btn-default" id="btn-pwdUp-colse">
		                	<i class="fa fa-ban"></i> 退出
		                </button>
		            </div>
				</form>
	        </div>
	    </div>
	</div>
	<!-- edit end-->
</body>
</html>