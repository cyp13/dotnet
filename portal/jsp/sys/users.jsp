<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<link href="${ctx}/js/plugins/select/bootstrap-select.css" rel="stylesheet"  />
<script src="${ctx}/js/plugins/select/bootstrap-select.js"></script>
<script src="${ctx}/js/plugins/select/defaults-zh_CN.js"></script>
<script src="${ctx}/js/md5.js"></script>
<script>
	var queryUrl = "${ctx}/jsp/sys/queryUser.do";
    var insertUrl = "${ctx}/jsp/sys/insertUser.do";
	var updateUrl = "${ctx}/jsp/sys/updateUser.do";
	var deleteUrl = "${ctx}/jsp/sys/deleteUser.do";

	var queryRoleUrl = "${ctx}/jsp/sys/queryRole.do";
	var queryUserRoleUrl = "${ctx}/jsp/sys/queryUserRole.do";

	// http://192.168.5.164:8080/wendaapi
	var hostfaq = "${s:getDict('host','faq---')}";
	var getExtRoleUrl = hostfaq+"/role/list";
	var ext1 = '${myUser.user.org.ext1}';
	
	var orgPathReal = "${myUser.user.org.orgPath}".indexOf("${myUser.user.orgId}")>=0?
			"${myUser.user.org.orgPath}" :"${myUser.user.org.orgPath}${myUser.user.orgId}|+|";
	$(window).ready(function() {
		var table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": false,
			"autoWidth": false,
			"processing": true,
			"serverSide": true,
			"ajax": {
				"dataSrc": "datas",
				"url": queryUrl,
				"data": function (d) {
					return $.extend( {}, d, {
					//	"flag": "queryChilds",
						"orgId": "${myUser.user.orgId}",
						"ext1": orgPathReal
					});
				}
			},
			"aoColumnDefs": [ {
				"targets": [ 0 ],
				"data":"id",
				"render": function (data, type, row) {
					var s = '<input type="checkbox" ';
					if("1" == row.rowDefault || "${myUser.username}" == row.userName) {
						s = s + 'disabled="disabled" '; 
					} else {
						s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
					}
					return s +'style="margin:0px;"/>';
				}
			}, {
				"targets": [ 1 ],
				"data":"userName",
				"render": function (data, type, row) {
					return '<span class="a-copy" title="点击复制" v="'+data+'">'+data+'</span>';
				}
			}, {
				"targets": [ 2 ],
				"data":"userAlias"
			}, {
				"targets": [ 3 ],
				"data":"userSex",
				"render": function (data, type, row) {
					if("1" == data) {
						return "男";
					} else if("0" == data) {
						return "女";
					}
					return data;
				}
			}, {
				"targets": [ 4 ],
				"render": function (data, type, row) {
					if(row.extMap.org) {
						return row.extMap.org.orgName;
					}
				}
			}, {
				"targets": [ 5 ],
				"data":"modified",
				"render": function (data, type, row) {
					return '<span title="'+row.modifier+'">'+data+'</span>';
				}
			}, {
				"targets": [ 6 ],
				"data":"extMap.rowValid",
				"render": function (data, type, row) {
					if("0" == row.rowValid) {
						return '<span style="color:#FF0000">'+data+'<span/>';	
					}
					return data;
				}
			}, {
				"targets": [ 7 ],
				"data":"id",
				"render": function (data, type, row) {
					return '<a href="${ctx}/jsp/sys/userInfo.jsp?userId='+data+'">详情</a>';
				}
			}]
		});
		
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				var param = {};
				param.orgId = "${myUser.user.orgId}";
				param.ext1=orgPathReal
				param.keywords = $("#keywords").val();
				table.api().settings()[0].ajax.data = param;
				table.api().ajax.reload();
			}
       	});
		
		$("#userType---").change( function() {
			if("" != hostfaq) {
				if("5" == $("#userType").val()) {
					$("#ext3-1").removeClass("validate[required]");
				} else {
					$("#ext3-1").addClass("validate[required]");
				}
			} else {
				$("#ext3-1").removeClass("validate[required]");
				$(".ext3-1").hide();
			}
       	});
		
		$("#btn-insert").on("click", function() {
			$("#editForm").attr("action", insertUrl);
			$("#myModal").modal("show");

			orgDivTree = null;
			$("#password").attr("placeholder","默认密码：111111");
			$("#userName").removeAttr("readonly");
       		queryRole();
       		
       		$("#userType---").change();
       	});

		$("#btn-update").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size != 1) {
				layer.msg("请选择需要修改的一行数据！", {icon: 0});
				return;
			}
			$("#editForm").attr("action", updateUrl);
			$("#myModal").modal("show");

			orgDivTree = null;
			$("#password").attr("placeholder","不填表示不修改密码");
			$("#userName").attr("readonly","readonly");
			queryRole($(".ids_:checkbox:checked").val());

			var obj = new Object();
			obj.url = queryUrl;
			obj.id = $(".ids_:checkbox:checked").val();
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					$("#editForm").fill(result.datas[0]);
					//填写用户名
					$("#showUserName").val($("#userName").val());
					//转换用户编码
					$("#userName").val($.base64.encode($("#userName").val()));
					if(result.datas[0].extMap.org) {
						$("#orgName").val(result.datas[0].extMap.org.orgName);
						$("#orgId").val(result.datas[0].extMap.org.id);
						$("#orgType").val(result.datas[0].extMap.org.orgType);
					}
					$("#userType---").change();
				}
			});
       	});
          
		$("#btn-delete").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size < 1) {
				layer.msg("请选择需要删除的数据！", {icon: 0});
				return;
			}
			
			layer.confirm("您确定要删除数据吗？", {icon: 3}, function() {
				var ids = [];
				$(".ids_:checkbox:checked").each(function(index, o) {
					ids.push($(this).val());
				});
				var obj = new Object();
				obj.url = deleteUrl;
				obj.id = ids.join(",");
				ajax(obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						table.api().ajax.reload();
					}
				});
			});
		});
		
		$("#btn-ok").on("click", function() {
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				var pwd = $("#password").val();
				if(pwd && (ext1 === 'MY' || ext1 === 'YA' || ext1 === 'LS')){
					var reg = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[\s\S]{8,16}$/;
					if(reg.test(pwd)){
						$("#ext3").val(1);
					}else{
						$("#ext3").val(0);
					}
				}
				var roleNames = [];
				$("#roles option:selected").each(function(index, o) {
					roleNames.push($(this).text());
				});
				$("#roleNames").val(roleNames.join(","));
				$("#roleIds").val($("#roles").val());
				
				if(pwd){
					//加密处理
					pwd = $.md5(pwd);
					pwd = $.md5(pwd);
					pwd = $.md5(pwd);
					$("#password").val(pwd);
				}
				
				var showName = $("#showUserName").val();
				$("#showUserName").val("");
				ajaxSubmit("#editForm", function(result) {
					$("#showUserName").val(showName);
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						$("#myModal").modal("hide");
						table.api().ajax.reload();
					}
				});
			}
		});
		
		$("#orgName").on("click", function() {
			showOrgTree(this, null, function(treeId, treeNode) {
				$("#orgId").val(treeNode.id);
				$("#orgName").val(treeNode.orgName);
				$("#orgType").val(treeNode.orgType);
			});
		});
		
		var clipboard = new Clipboard('.a-copy', {
		    text: function(o) {
		    	layer.msg("复制成功");
		    	return $(o).attr("v");
		    }
		});
	});
	
	var queryRole = function(userId) {
		var obj = new Object();
		obj.async = false;
		obj.url = queryRoleUrl;
		obj.rowValid = "1";
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			} else {
				$("#roles").empty();
				$.each(result.datas, function(i,o) {
					$("#roles").append("<option value='"+o.id+"'>"+o.roleName+"</option>");    
				});
				$("#roles").selectpicker("render");
				$("#roles").selectpicker("refresh");
				queryUserRole(userId);
			}
		});
		
		if("" != hostfaq) {
			var obj = new Object();
			obj.async = false;
			obj.url = getExtRoleUrl;
			obj.threeCode = "${myUser.user.extMap.org.ext1}";
			if(userId && "" != userId) {
				obj.threePartId = userId;
			}
			ajax(obj, function(result) {
				if ("200" == result.code) {
					$("#ext3-1").empty();
					$("#ext3-1").append("<option value=''>请选择</option>");    
					$.each(result.data, function(i,o) {
						if(o.isHave > 0) {
							$("#ext3-1").append("<option value='"+o.roleid+"' selected>"+o.rolename+"</option>");
						} else {
							$("#ext3-1").append("<option value='"+o.roleid+"'>"+o.rolename+"</option>");
						}
					});
					$("#ext3-1").selectpicker("render");
					$("#ext3-1").selectpicker("refresh");
				} else {
					layer.msg(result.resMsg, {icon: 2});
				}
			});
		}
	}
	
	var queryUserRole = function(userId) {
		if(userId) {
			var obj = new Object();
			obj.url = queryUserRoleUrl;
			obj.userId = userId; 
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					var roles = [];
					$.each(result.datas, function(i,o) {
						roles.push(o.roleId);
					});
				    $("#roles").selectpicker("val", roles);
				}
			});
		}
	}
	
	//转码
	function fillData(obj){
		var value = $(obj).val();
		value = $.base64.encode(value);
		$("#userName").val(value);
	}
</script>
<link href="${ctx}/js/tree/divTree.css" rel="stylesheet">
<script src="${ctx}/js/tree/orgTree.js"></script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-user-circle"></i> 用户列表</h5>
                    	<div class="ibox-tools">
	                        <a class="a-reload">
	                            <i class="fa fa-repeat"></i> 刷新
	                        </a>
	                        <a class="a-go">
	                          <i class="fa fa-reply"></i> 返回
	                       	</a>
	                    </div>
	                </div>
	                
                    <div class="ibox-content">
                        <!-- search star -->
						<div class="form-horizontal clearfix">
							<div class="col-sm-7 pl0">
								<button class="btn btn-sm btn-success" id="btn-insert">
									<i class="fa fa-plus"></i> 新增
								</button>
								<button class="btn btn-sm btn-success" id="btn-update">
									<i class="fa fa-edit"></i> 修改
								</button>
								<button class="btn btn-sm btn-success" id="btn-delete">
									<i class="fa fa-trash-o"></i> 删除
								</button>
							</div>
	
							<div class="col-sm-5 form-inline" style="padding-right:0; text-align:right">
								<form id="queryForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
									<input type="text" placeholder="关键字" class="input-sm form-control validate[custom[tszf]]" id="keywords">
	                                <button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
										<i class="fa fa-search"></i> 查询
									</button>
								</form>
							</div>
						</div>
						<!-- search end -->
                        
                        <table id="datas" class="table display" style="width:100%">
                            <thead>
                                <tr>
	                                <th><input type="checkbox" id="checkAll_" style="margin:0px;"></th>
									<th>登录账号</th>
									<th>姓名</th>
									<th>性别</th>
									<th>所属机构</th>
									<th>修改时间</th>
									<th>状态</th>
									<th>操作</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

	<!-- edit start-->
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:70%;">
	        <div class="modal-content ibox">
                <form id="editForm" class="form-horizontal key-13" role="form">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i> 编辑数据</h5>
	                    <div class="ibox-tools">
	                    	<!-- <a class="collapse-link">
	                            <i class="fa fa-chevron-up"></i>
	                        </a> -->
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
	            
		            <div class="ibox-content">
	                  <input type="text" id="id" name="id" style="display:none"/>
	                  <input type="text" id="rowVersion" name="rowVersion" style="display:none"/>
	                  <input type="hidden" id="flag_" name="flag_" value="manager_"/>
	                  <input type="hidden" id="ext3" name="ext3" value="0" />
	                  <input type="text" name="updateSign" value="updateSign" style="display:none"/>
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">登录账号</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required,custom[onlyLetterNumber]]" name="showUserName" id="showUserName" onblur="fillData(this)" placeholder="建议手机号或身份证编号" maxlength="18">
					      <input type="hidden" name="userName" id="userName">
					    </div>
					    <label class="col-sm-2 control-label">登录密码</label>
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
					      <input type="text" class="input-sm form-control validate[required]" name="orgName" id="orgName" readonly="readonly" >
					      <input type="text" class="validate[required]" name="orgId" id="orgId" style="display:none" >
					      <input type="text" name="ext2" id="orgType" style="display:none" >
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
					    <label class="col-sm-2 control-label">学历</label>
					    <div class="col-sm-4">
					      <s:dict dictType="userEdu" clazz="input-sm form-control"></s:dict>
					    </div>
					    <label class="col-sm-2 control-label">电子邮件</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[custom[email]]" name="userEmail" id="userEmail" maxlength="16">
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">办公电话</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[custom[phone]]" name="officePhone" id="officePhone" maxlength="11">
					    </div>
					    <%-- <span class="ext3-1">
						    <label class="col-sm-2 control-label">问答角色</label>
						    <div class="col-sm-4">
						      <select id="ext3-1" name="ext3" class="form-control validate[required] selectpicker"></select><!-- 角色id -->
						    </div>
					    </span> --%>
					    <label class="col-sm-2 control-label">移动电话</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[custom[mobile],minSize[11],maxSize[11]]" name="mobilePhone" id="mobilePhone" maxlength="11" >
					    </div>
					  </div>

					  <div class="form-group">
					  	<label class="col-sm-2 control-label">角色指配</label>
					    <div class="col-sm-4">
					      <select id="roles" name="roles" class="form-control selectpicker multiple"></select>
					      <input type="text" name="roleIds" id="roleIds" style="display:none" >
					      <input type="text" name="roleNames" id="roleNames" style="display:none" >
					    </div>
					    <label class="col-sm-2 control-label">状态</label>
					    <div class="col-sm-4">
					      <label><input type="radio" name="rowValid" value="1" checked="checked">有效</label>
					      <label><input type="radio" name="rowValid" value="0">禁用</label>
					    </div>
					  </div>

						<div class="form-group">
						 <label  class="col-sm-2 control-label">BOSS工号</label>
						 <div class="col-sm-4">
						      <input type="text" class="input-sm form-control" name="bossCode" id="bossCode">
						 </div>
						 </div>

					  <div class="form-group">
					    <label class="col-sm-2 control-label">备注</label>
					    <div class="col-sm-10">
					      <textarea class="form-control" name="remark" maxlength="200" id="remark" ></textarea>
					    </div>
					  </div>
		            </div>
		            
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-ok">
		                	<i class="fa fa-check"></i> 确定
		                </button>
		                <button type="button" class="btn btn-sm btn-default" id="btn-cancel" data-dismiss="modal">
		                	<i class="fa fa-ban"></i> 取消
		                </button>
		            </div>
				</form>
	        </div>
	    </div>
	</div>
	<!-- edit end-->

	<div id="orgDiv" style="display: none; position: absolute; z-index: 9999">
		<ul id="orgDivTree" class="ztree divTree"></ul>
	</div>
</body>
</html>