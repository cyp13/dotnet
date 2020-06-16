<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script src="${ctx}/js/md5.js"></script>
<style type="text/css">
#treeDiv::-webkit-scrollbar-track {
    background-color: #fff;
}
</style>
<script>
	var queryUserUrl = "${ctx}/jsp/sys/queryUser.do";
	var updateUserUrl = "${ctx}/jsp/sys/updateOwner.do";
	var queryUserRoleUrl = "${ctx}/jsp/sys/queryUserRole.do";

	var setting = {
		data: {
			key: { name: "menuName", title: "menuUrl"},
			simpleData: {
				enable: true,
				idKey: "id",
				pIdKey: "parentId",
			}
		},
		callback : {
			beforeClick : function(treeId, treeNode) {
				var url = treeNode.menuUrl
				if(url && "undefined" != typeof url) {
					var clipboard = new Clipboard(".node_name", {
					    text: function(o) {
					    	layer.msg("URL复制成功");
					    	return url;
					    }
					});
				}
			}
		}
	};
	
	$(window).resize(function() {
		$("#treeDiv").css("height",document.body.clientHeight-64);
	});
	
	$(window).load(function() {
		$("#btn-ok").on("click", function() {
			var b = $("#userForm").validationEngine("validate");
			$("#ext3").val(1);
			if(b) {
				
				var pwd = $("#password").val();
				if(pwd){
					//加密处理
					pwd = $.md5(pwd);
					pwd = $.md5(pwd);
					pwd = $.md5(pwd);
					$("#password").val(pwd);
				}
				
				layer.confirm("您确定要保存数据吗？", {icon: 3}, function() {
					var showName = $("#showUserName").val();
					$("#showUserName").val("");
					$("#userForm").attr("action", updateUserUrl);
					ajaxSubmit("#userForm", function(result) {
						$("#showUserName").val(showName);
						if ("error" == result.resCode) {
							layer.msg(result.resMsg, {icon: 2});
						} else {
							layer.msg("数据处理成功！", {icon: 1});
							$("#rowVersion").val(result.rowVersion);
						}
					});
				});
			}
		});
		
		if("" != "${param.userId}") {
			$("#btn-ok").css("display", "none");
			$("input,select,textarea").attr("disabled", true);
		}
		
		queryUser();

		$("#treeDiv").css("height",$(window).height()-64);
		$.fn.zTree.init($("#ztree"), setting, <s:menu type="json" userId="${param.userId}" menuTypes="1,2,3,4,5" />);
	});
	
	var queryUser = function(userId) {
		$("#userForm")[0].reset();
		$("#password").attr("placeholder","不填不会修改密码");
		
		var obj = new Object();
		obj.url = queryUserUrl;
		obj.id = "${param.userId}";
		if(!obj.id || "" == obj.id) {
			obj.id = "${myUser.user.id}";
		}
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			} else {
				$("#userForm").fill(result.datas[0]);
				//填写用户名
				$("#showUserName").val($("#userName").val());
				//转换用户编码
				$("#userName").val($.base64.encode($("#userName").val()));
				$("#password").val("");
				queryUserRole(obj.id);
				if(result.datas[0].extMap.org) {
					$("#orgName").val(result.datas[0].extMap.org.orgName);
					$("#orgId").val(result.datas[0].extMap.org.id);
				}
			}
		});
	}
	
	var queryUserRole = function(userId) {
		if(!userId) {
			return;
		}
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
	
	/*
	 * 修改密码操作
	 */
	$(function() {
		var resetPasswordForm = $('#reset-password-form').validationEngine('attach', {
			promptPosition: 'bottomLeft',
			maxErrorsPerField: 1,
			autoPositionUpdate: true,
			showOneMessage: true
		});
		
		function closeLayer(index, $form) {
			$('#oldPwd').val('');
			$('#newPwd').val('');
			$('#confirmNewPwd').val('');
			$form.validationEngine('hideAll');
			layer.close(index);
		}
		
		$('body').on('click', '#btn-reset-password', function() {
			layer.open({
				type: 1,
				title: '修改密码',
				area: ['550px', '300px'],
				fixed: false,
				maxmin: false,
				content: resetPasswordForm,
				btn: ['提交修改'],
				btnAlign: 'c',
				yes: function(index, layero) {
					if ($('#reset-password-form').validationEngine('validate')) {
						$('#oldPwd').val($.md5($.md5($.md5($('#oldPwd').val()))));
						$('#newPwd').val($.md5($.md5($.md5($('#newPwd').val()))));
						ajaxSubmit('#reset-password-form', function(result) {
							if ('error' === result.resCode) {
								layer.msg(result.resMsg, {icon: 2});
							} else {
								layer.msg('数据处理成功！', {icon: 1});
								closeLayer(index, $('#reset-password-form'));
							}
						});
					}
				},
				cancel: function(index, layero) {
					closeLayer(index, $('#reset-password-form'));
				}
			});
		});
	})
</script>
</head>

<body class="gray-bg">
	
	<form id="reset-password-form" style="display: none;margin: 20px;" action="${ctx}/api/sys/updateUser.do" class="form-horizontal" role="form">
		<input type="hidden" name="userId" value="${myUser.user.id}" />
		<input type="hidden" name="ext3" value="1" />
		<input type="text" name="updateSign" value="updateSign" style="display:none"/>
	
		<div class="form-group">
			<label class="col-sm-2 control-label">原密码</label>
			<div class="col-sm-9">
				<input type="password" class="input-sm form-control validate[required]" autocomplete="off" maxlength="16" name="oldPwd" id="oldPwd">
			</div>
		</div>
			
		<div class="form-group">
			<label class="col-sm-2 control-label">新密码</label>
			<div class="col-sm-9">
				<input type="password" class="input-sm form-control validate[required, custom[passStrength]]" autocomplete="off" maxlength="16" name="newPwd" id="newPwd">
				<font size="1" color="#FF0000">密码至少大写，小写字母，数字组成，8-16位</font>
			</div>
		</div>
			
		<div class="form-group">
			<label class="col-sm-2 control-label">确认密码</label>
			<div class="col-sm-9">
				<input type="password" class="input-sm form-control validate[required, custom[passStrength], equals[newPwd]]" autocomplete="off" maxlength="16" id="confirmNewPwd">
			</div>
		</div>
	</form>
	
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-9" style="padding-right: 0;">
                <div class="ibox float-e-margins">
                   	<form id="userForm" class="form-horizontal" role="form">
	                	<div class="ibox-title">
		                    <h5><i class="fa fa-user-circle"></i> 基本信息</h5>
		                    <div class="ibox-tools">
		                       <a class="btn-13" id="btn-reset-password" style="color:#4974A4">
		                          <i class="fa fa-key fa-fw"></i> 修改密码
		                       </a>
		                       <a class="btn-13" id="btn-ok" style="color:#4974A4">
		                          <i class="fa fa-save"></i> 保存
		                       </a>
		                       <c:if test="${null ne param.userId}">
		                       	  <a class="a-reload">
			                          <i class="fa fa-repeat"></i> 刷新
			                       </a>
		                       </c:if>
		                    </div>
		                </div>

			            <div class="ibox-content">
		                  <input type="text" name="id" style="display:none"/>
		                  <input type="text" id="rowVersion" name="rowVersion" style="display:none"/>
		                  <input type="text" id="rowValid" name="rowValid" style="display:none"/>
		                  <input type="text" id="ext2" name="ext2" style="display:none"/>
		                  <input type="text" id="ext3" name="ext3" style="display:none"/>
		                  <input type="text" name="updateSign" value="updateSign" style="display:none"/>
		                  
						  <div class="form-group">
						    <label class="col-sm-2 control-label">登录账号</label>
						    <div class="col-sm-4">
						      <input type="text" class="input-sm form-control validate[required]" name="showUserName" id="showUserName"  readonly="readonly" maxlength="18">
						      <input type="hidden" name="userName" id="userName"> 
						    </div>
						    
						    <%--
						    <label class="col-sm-2 control-label">密码</label>
						    <div class="col-sm-4">
						    	<c:if test="${myUser.user.org.ext1 eq 'MY' || myUser.user.org.ext1 eq 'YA' || myUser.user.org.ext1 eq 'LS'}" var="flag" scope="session" >
						    		<input type="password" class="input-sm form-control validate[custom[passStrength]]" name="password" id="password" autocomplete="off" maxlength="16">
						     		<font size="1" color="#FF0000">密码至少大写，小写字母，数字组成，8-16位</font>
								</c:if>
								<c:if test="${not flag}">
						    		<input type="password" class="input-sm form-control validate[minSize[4]]" name="password" id="password" autocomplete="off" maxlength="16">
								</c:if>
						    </div>
						    --%>
						     <label  class="col-sm-2 control-label">角色信息</label>
						    <div class="col-sm-4">
						      <input type="text" class="input-sm form-control" name="roleNames" id="roleNames" readonly="readonly">
						      <input type="text" name="roleIds" id="roleIds" style="display:none" >
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
						    <!-- <label class="col-sm-2 control-label">职务</label>
						    <div class="col-sm-4">
						      <input type="text" class="input-sm form-control" name="userPosition" id="userPosition" maxlength="16">
						    </div> -->
						    <label class="col-sm-2 control-label">是否接单</label>
						    <div class="col-sm-4">
						      <label><input type="radio" name="ext1" value="1" checked="checked">是</label>
					      	  <label><input type="radio" name="ext1" value="0">否</label>
						    </div>
						  </div>
						  
						  <div class="form-group">
						    <label  class="col-sm-2 control-label">学历</label>
						    <div class="col-sm-4">
						      <s:dict dictType="userEdu" clazz="input-sm form-control"></s:dict>
						    </div>
						    <label  class="col-sm-2 control-label">电子邮件</label>
						    <div class="col-sm-4">
						      <input type="text" class="input-sm form-control validate[custom[email]" name="userEmail" id="userEmail" maxlength="16">
						    </div>
						  </div>
						  
						  <div class="form-group">
						    <label  class="col-sm-2 control-label">办公电话</label>
						    <div class="col-sm-4">
						      <input type="text" class="input-sm form-control validate[custom[phone]" name="officePhone" id="officePhone" maxlength="11">
						    </div>
						    <label  class="col-sm-2 control-label">移动电话</label>
						    <div class="col-sm-4">
						      <input type="text" class="input-sm form-control validate[custom[mobile],minSize[11],maxSize[11]]" name="mobilePhone" id="mobilePhone" maxlength="11">
						    </div>
						  </div>
	
						  <div class="form-group">
						    <label  class="col-sm-2 control-label">BOSS工号</label>
						    <div class="col-sm-4">
						      <input type="text" class="input-sm form-control" name="bossCode" id="bossCode">
						    </div>
							  <c:if test="${myUser.user.org.ext1 eq 'DY'}">
								    <label class="col-sm-2 control-label">是否接收短信</label>
								    <div class="col-sm-4">
								      <label><input type="radio" name="ifReceiveMessage" value="1">是</label>
							      	  <label><input type="radio" name="ifReceiveMessage" value="0">否</label>
								    </div>
							  </c:if>
						  </div>
						  
	
						  <div class="form-group">
						    <label  class="col-sm-2 control-label">备注</label>
						    <div class="col-sm-10">
						      <textarea class="form-control" name="remark"></textarea>
						    </div>
						  </div>
						  
			            </div>
					</form>
               	</div>
            </div>

            <div class="col-sm-3" style="padding-left: 10px;">
                <div class="ibox float-e-margins">
                	<div class="ibox-title">
	                    <h5><i class="fa fa-key"></i> 权限信息</h5>
	                    <div class="ibox-tools">
	                       <c:choose>
	                       	<c:when test="${null ne param.userId}">
	                       		<a class="a-go">
		                          <i class="fa fa-reply"></i> 返回
		                       </a>
	                       	</c:when>
	                       	<c:otherwise>
	                       		<a class="a-reload">
		                          <i class="fa fa-repeat"></i> 刷新
		                       </a>
	                       	</c:otherwise>
	                       </c:choose>
	                    </div>
	                </div>
                    <div class="ibox-content" id="treeDiv" style="overflow: auto; padding:10px;">
						<ul id="ztree" class="ztree"></ul>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>