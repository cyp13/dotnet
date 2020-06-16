<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<link href="${ctx}/js/plugins/font-awesome/css/jquery.fonticonpicker.min.css" rel="stylesheet">
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<link href="${ctx}/js/plugins/select/bootstrap-select.css" rel="stylesheet"  />
<script src="${ctx}/js/plugins/select/bootstrap-select.js"></script>
<script src="${ctx}/js/plugins/select/defaults-zh_CN.js"></script>
<script src="${ctx}/js/plugins/font-awesome/js/jquery.fonticonpicker.min.js"></script>
<script src="${ctx}/js/plugins/font-awesome/icon.js"></script>
<style type="text/css">
#treeDiv::-webkit-scrollbar-track {
    background-color: #fff;
}
</style>
<script>
    var insertUrl = "${ctx}/jsp/sys/insertMenu.do";
	var updateUrl = "${ctx}/jsp/sys/updateMenu.do";
	var deleteUrl = "${ctx}/jsp/sys/deleteMenu.do";
	var queryUrl = "${ctx}/jsp/sys/queryMenu.do";

	var queryRoleUrl = "${ctx}/jsp/sys/queryRole.do";
	var queryRoleMenuUrl = "${ctx}/jsp/sys/queryRoleMenu.do";

	var queryParamUrl = "${ctx}/jsp/sys/queryParam.do";
	var queryMenuParamUrl = "${ctx}/api/report/queryMenuParam.do";
	
	var parentNode = null;
	
	$(window).resize(function() {
		$("#treeDiv").css("height",document.body.clientHeight-64);
	});
	
	$(window).ready(function() {
		$("#treeDiv").css("height",$(window).height()-64);
		
		showMenuTree(null, null, null, function(treeId, treeNode) {
			parentNode = treeNode;
			$("#btn-query").click();
		});
		
		$("#menuIcon").fontIconPicker({
			source: fa_icons,
			searchSource: fa_icons,
			//useAttribute: true,  
            //theme: "fip-bootstrap",  
            //attributeName: "data-icomoon",
            emptyIconValue: "none"
        });

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
				"url": queryUrl
			},
			"aoColumnDefs": [ {
				"targets": [ 0 ],
				"data":"id",
				"render": function (data, type, row) {
					var s = '<input type="checkbox" ';
					if("1" == row.rowDefault) {
						s = s + 'disabled="disabled" '; 
					} else {
						s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
					}
					return s +'style="margin:0px;"/>';
				}
			}, {
				"targets": [ 1 ],
				"data":"menuName",
				"render": function (data, type, row) {
					return '<span class="a-copy" title="点击复制" v="'+data+'">'+data+'</span>';
				}
			}, {
				"targets": [ 2 ],
				"data":"menuType",
				"render": function (data, type, row) {
					if("1" == data) {
						return '<span class="a-copy" title="点击复制ID" v="'+row.id+'">菜单</span>';
					} else if("2" == data) {
						return '<span class="a-copy" title="点击复制ID" v="'+row.id+'">pc权限</span>';
					} else if("3" == data) {
						return '<span class="a-copy" title="点击复制ID" v="'+row.id+'">报表</span>'; 
					} else if("5" == data) {
						return '<span class="a-copy" title="点击复制ID" v="'+row.id+'">app菜单</span>';
					} else if("6" == data) {
						return '<span class="a-copy" title="点击复制ID" v="'+row.id+'">app权限</span>';
					}
				}
			}, {
				"targets": [ 3 ],
				"data":"menuUrl",
				"render": function (data, type, row) {
					data = data ? data : "";
					return '<div class="a-copy" style="width:150px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;" title="'+data+'" v="'+data+'">'+data+'</div>';
				}
			}, {
				"targets": [ 4 ],
				"data":"sortNo",
				"render": function (data, type, row) {
					if("1" == row.extendFlag) {
						return '<b>'+data+'</b>';
					}
					return data;
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
				"data":"remark",
				"render": function (data, type, row) {
					return data ? data : "";
				}
			}]
		});
          
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				var param = {};
				param.keywords = $("#keywords").val();
				param.parentId = parentNode ? parentNode.id : "";
				table.api().settings()[0].ajax.data = param;
				table.api().ajax.reload();
			}
       	});
		
		$("#btn-insert").on("click", function() {
			$("#editForm")[0].reset();
			$("#editForm").attr("action", insertUrl);
			if(parentNode) {
				$("#parentId").val(parentNode.id);
				$("#parentName").val(parentNode.menuName);
			}
			$("#myModal").modal("show");
			
			menuDivTree = null;
			$("#sortNo").val(getChlids(parentNode));
			$("#menuIcon_").html("");
			
			$("input:radio[name='menuType']").change();
			queryRole();
       	});

		$("#btn-update").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size != 1) {
				layer.msg("请选择需要修改的一行数据！", {icon: 0});
				return;
			}
			
			$("#editForm")[0].reset();
			$("#editForm").attr("action", updateUrl);
			$("#myModal").modal("show");
			
			menuDivTree = null;
			$("#menuIcon_").html("");
			queryRole($(".ids_:checkbox:checked").val());

			var obj = new Object();
			obj.url = queryUrl;
			obj.id = $(".ids_:checkbox:checked").val();
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					$("#editForm").fill(result.datas[0]);
					$("#menuIcon_").html(result.datas[0].menuIcon);
					
					$("input:radio[name='menuType']").change();
					var menuType = $("input:radio[name='menuType']:checked").val();
					if("3" == menuType) {
						$("#file").removeClass("validate[required]");
					} else {
						$("#file").addClass("validate[required]");
					}
				}
			});
       	});
          
		$("#btn-delete").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size < 1) {
				layer.msg("请选择需要删除的数据！", {icon: 0});
				return;
			}
			
			layer.confirm('您确定要删除数据吗？', {icon: 3}, function() {
				var ids = [];
				$(".ids_:checkbox:checked").each(function(index, o){
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
						var nodes = menuTree.getSelectedNodes();
						if(nodes){
							nodes[0].isParent = true;
							menuTree.reAsyncChildNodes(nodes[0], "refresh");
						}
					}
				});
			});
		});
		
		$("#btn-ok").on("click", function() {
			var b = $("#editForm").validationEngine("validate");
			
			if(b) {
				ajaxSubmit("#editForm", function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						$("#myModal").modal("hide");
						table.api().ajax.reload();
						var nodes = menuTree.getSelectedNodes();
						if(nodes){
							nodes[0].isParent = true;
							menuTree.reAsyncChildNodes(nodes[0], "refresh");
						}
					}
				});
			}
		});
		
		$("#parentName").on("click", function() {
			showMenuTree(this, null, null, function(treeId, treeNode) {
				$("#parentName").val(treeNode.menuName);
				$("#parentId").val(treeNode.id);
			});
		});
		
		$("input:radio[name='menuType']").change(function () {
			$(".report .form-control").attr("disabled",true);
			$(".cognos .form-control").attr("disabled",true);
			$(".report").hide();
			$(".cognos").hide();
			$("#AppIconUrl").hide();
			$("#AppIconUrl").attr("disabled",true);
			var menuType = $("input:radio[name='menuType']:checked").val();
			if("3" == menuType) { 
				$(".report .form-control").attr("disabled",false);
				$(".report").show();
				queryParam();
			}else if("4" == menuType) { 
				$(".cognos .form-control").attr("disabled",false);
				$(".cognos").show();
				queryParam();
			} else if("5" == menuType){ 
				$("#AppIconUrl").show();
				$("#AppIconUrl").attr("disabled",false);
			} 
		});
		
		var clipboard = new Clipboard('.a-copy', {
		    text: function(o) {
		    	layer.msg("复制成功");
		    	return $(o).attr("v");
		    }
		});
	});
	
	var queryRole = function(menuId) {
		var obj = new Object();
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
				queryRoleMenu(menuId);
			}
		});
	}
	
	var queryRoleMenu = function(menuId) {
		if(!menuId) {
			return;
		}
		var obj = new Object();
		obj.url = queryRoleMenuUrl;
		obj.menuId = menuId;
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
	
	var queryParam = function() {
		var obj = new Object();
		obj.url = queryParamUrl;
		obj.rowValid = "1";
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			} else {
				$("#params").empty();
				$.each(result.datas, function(i,o) {
					$("#params").append("<option value='"+o.id+"'>"+o.ename+"("+o.cname+")</option>");    
				});
				$("#params").selectpicker("render");
				$("#params").selectpicker("refresh");
				queryMenuParam();
			}
		});
	}
	
	var queryMenuParam = function() {
		var menuId =  $("#id").val();
		if(!menuId) {
			return;
		}
		var obj = new Object();
		obj.url = queryMenuParamUrl;
		obj.menuId = menuId;
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			} else {
				var params = [];
				$.each(result.datas, function(i,o) {
					params.push(o.paramId);
				});
			    $("#params").selectpicker("val", params);
			}
		});
	}
</script>
<link href="${ctx}/js/tree/divTree.css" rel="stylesheet">
<script src="${ctx}/js/tree/menuTree.js"></script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-3" style="padding-right: 0;">
                <div class="ibox float-e-margins">
                	<div class="ibox-title">
	                    <h5><i class="fa fa-list-ul"></i> 上级菜单</h5>
	                </div>
                    <div class="ibox-content" id="treeDiv" style="overflow:auto; padding:10px;">
						<ul id="menuTree" class="ztree"></ul>
                    </div>
                </div>
            </div>

            <div class="col-sm-9" style="padding-left: 10px;">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-link"></i> 菜单列表</h5>
                    	<div class="ibox-tools">
	                        <a class="a-reload">
	                            <i class="fa fa-repeat"></i> 刷新
	                        </a>
	                        <!-- <a class="collapse-link">
	                            <i class="fa fa-chevron-up"></i>
	                        </a>
	                        <a class="close-link">
	                            <i class="fa fa-times"></i>
	                        </a> -->
	                    </div>
	                </div>
	                
                    <div class="ibox-content">
						<!-- search star -->
						<div class="form-horizontal clearfix">
							<div class="col-sm-6 pl0">
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
	
							<div class="col-sm-6 form-inline key-13" style="padding-right:0; text-align:right">
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
									<th>菜单名称</th>
									<th>类型</th>
									<th>URL</th>
									<th>排序</th>
									<th>修改时间</th>
									<th>状态</th>
									<th>备注</th>
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
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
		            
		            <div class="ibox-content">
	                  <input type="text" id="id" name="id" style="display:none"/>
	                  <input type="text" id="sysId" name="sysId" value="${myUser.user.extMap.sys.id}" style="display:none"/>
	                  <input type="text" id="rowVersion" name="rowVersion" style="display:none"/>
	                  <input type="text" id="menuCode" name="menuCode" style="display:none"/>
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">菜单名称</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" id="menuName" name="menuName" maxlength="16">
					    </div>
					    <label class="col-sm-2 control-label">上级菜单</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" id="parentName" name="parentName" readonly="readonly" >
					      <input type="text" class="validate[required]" id="parentId" name="parentId" style="display:none"/>
					    </div>
					  </div>
	
					  <div class="form-group">
					    <label class="col-sm-2 control-label">类型</label>
					    <div class="col-sm-4">
					      <label><input type="radio" name="menuType" value="1" checked="checked">菜单</label>
					      <label><input type="radio" name="menuType" value="2">pc权限</label>
					      <label><input type="radio" name="menuType" value="3">报表</label>
					      <label><input type="radio" name="menuType" value="5">app菜单</label>
					      <label><input type="radio" name="menuType" value="6">app权限</label>
					    </div>
					    <label class="col-sm-2 control-label">角色指配</label>
					    <div class="col-sm-4">
					      <select id="roles" name="roles" class="input-sm form-control selectpicker multiple"></select>
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">目标窗口</label>
					    <div class="col-sm-4">
					      <select name="menuTarget" class="input-sm form-control" >
					      	<option value="">请选择</option>
					      	<option value="_self">本窗口</option>
					      	<option value="_blank">新窗口</option>
					      	<option value="_parent">父窗口</option>
					      	<option value="_top">整个窗口</option>
					      </select>
					    </div>
					    <label class="col-sm-2 control-label"><span id="menuIcon_"></span> 图标</label>
					    <div class="col-sm-4">
					      <input type="text" name="menuIcon" id="menuIcon">
					    </div>
					    <c:choose>
					    	<c:when test="${myUser.user.extMap.sys.id eq s:getSysConstant('ADMIN_SYSTEM')}">
					    		 <div class="col-sm-2">
							    	<select id="extendFlag" name="extendFlag" class="input-sm form-control" title="扩展系统是否新增该菜单（仅对新增有效）">
							    		<option value="0">下发标志</option>
							    		<option value="1">是</option>
							    	</select>
							    </div>
					    	</c:when>
					    	<c:otherwise>
					    		<input type="text" id="extFlag" name="extFlag" value="0" style="display:none"/>
					    	</c:otherwise>
					    </c:choose>
					  </div>

					  <div class="form-group report">
					    <label class="col-sm-2 control-label">数据源</label>
					    <div class="col-sm-4">
					      <s:ds name="extId" dsType="1" clazz="input-sm form-control validate[required]" />
					    </div>
					    <label class="col-sm-2 control-label">报表文件</label>
					    <div class="col-sm-4" title="jrxml格式报表">
					      <input type="file" name="file" id="file" class="input-sm form-control validate[required]" accept=".jrxml"/>
					    </div>
					  </div>

					  <div class="form-group cognos">
					    <label class="col-sm-2 control-label">服务源</label>
					    <div class="col-sm-4">
					      <s:ds name="extId" dsType="2" clazz="input-sm form-control validate[required]" />
					    </div>
					    <label class="col-sm-2 control-label">报表路径</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" id="extPath" name="extPath" title="/content/package[@name='Package']/report[@name='Report']" placeholder="/content/package[@name='Package']/report[@name='Report']"/>
					    </div>
					  </div>
					  
					  <div class="form-group report cognos">
					    <label class="col-sm-2 control-label">参数设置</label>
					    <div class="col-sm-10">
					      <select id="params" name="params" class="input-sm form-control selectpicker multiple"></select>
					    </div>
					  </div>

					  <div class="form-group" id="AppIconUrl">
					    <label class="col-sm-2 control-label">App图标URL</label>
					    <div class="col-sm-10">
					      <input type="text" class="input-sm form-control" name="ext3" id="ext3" >
					    </div>
					  </div>
					  <div class="form-group">
					    <label class="col-sm-2 control-label">URL</label>
					    <div class="col-sm-10">
					      <input type="text" class="input-sm form-control" name="menuUrl" id="menuUrl" >
					    </div>
					  </div>
	
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">排序号</label>
					    <div class="col-sm-4">
					      <input type="number" class="input-sm form-control validate[required,custom[integer]]" name="sortNo" id="sortNo" >
					    </div>
					    <label  class="col-sm-2 control-label">状态</label>
					    <div class="col-sm-4">
					      <label><input type="radio" name="rowValid" value="1" checked="checked">有效</label>
					      <label><input type="radio" name="rowValid" value="0">禁用</label>
					    </div>
					  </div>
	
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">备注</label>
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
	
	<div id="menuDiv" style="display: none; position: absolute; z-index: 9999">
		<ul id="menuDivTree" class="ztree divTree"></ul>
	</div>
</body>
</html>