<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
    var insertUrl = "${ctx}/jsp/sys/insertOrg.do";
	var updateUrl = "${ctx}/jsp/sys/updateOrg.do";
	var deleteUrl = "${ctx}/jsp/sys/deleteOrg.do";
	var queryUrl = "${ctx}/jsp/sys/queryOrg.do";
	var orgPathReal = "${myUser.user.org.orgPath}".indexOf("${myUser.user.orgId}")>=0?
			"${myUser.user.org.orgPath}" :"${myUser.user.org.orgPath}${myUser.user.orgId}|+|";
	$(window).ready(function() {
		var table = $("#datas").dataTable({
			"language": {"url": "${ctx}/js/plugins/dataTables/Chinese.json"},
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
						"orgPath": orgPathReal
					});
				}
			},
			"aoColumnDefs": [ {
				"targets": [ 0 ],
				"data":"id",
				"render": function (data, type, row) {
					var s = '<input type="checkbox" ';
					if("1" == row.rowDefault) {
						s = s + 'disabled="disabled" '; 
					} else {
						/* if("1" != "${myUser.user.extMap.sys.rowDefault}" && row.creater != "${myUser.user.userName}") {
							s = s + 'disabled="disabled" '; 
                     	} */
						s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
					}
					return s +'style="margin:0px;"/>';
				}
			}, {
				"targets": [ 1 ],
				"data":"orgName",
				"render": function (data, type, row) {
					return '<span class="a-copy" title="点击复制ID" v="'+row.id+'">'+data+'</span>';
				}
			}, {
				"targets": [ 2 ],
				"data":"extMap.orgType",
				"render": function (data, type, row) {
					if(data) {
						return data;
					}
					return row.orgType;
				}
			}, {
				"targets": [ 3 ],
				"render": function (data, type, row) {
					if(row.parentName) {
						return '<span class="a-copy" title="点击复制ID" v="'+row.parentId+'">'+row.parentName+'</span>';
					}
				}
			}, {
				"targets": [ 4 ],
				"data":"sortNo"
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
				//	return '<a onclick="parent.menuItem(\'设置成员-机构\',\'${ctx}/jsp/sys/setOrg.jsp?orgId='+data+'\')">成员</a>';
					return '<a href="${ctx}/jsp/sys/setOrg.jsp?orgId='+data+'&orgName='+encodeURI(row.orgName)+'">成员</a>';
				}
			}]
		});
		
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				var param = {};
				param.orgPath = orgPathReal;
				param.keywords = $("#keywords").val();
				table.api().settings()[0].ajax.data = param;
				table.api().ajax.reload();
			}
       	});
		
		$("#btn-insert").on("click", function() {
			$("#editForm").attr("action", insertUrl);
			if("true" == "${myUser.user.userName eq s:getSysConstant('ADMIN_USER')}") {
				$("#parentId").val("${s:getSysConstant('NUM_ROOT')}");
				$("#parentName").val("${s:getSysConstant('NUM_ROOT')}");
			}
			$("#myModal").modal("show");
			
			orgDivTree = null;
			$("#orgCode").removeAttr("readonly");
			$("#sortNo").val("1");
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
			$("#orgCode").attr("readonly","readonly");

			var obj = new Object();
			obj.url = queryUrl;
			obj.id = $(".ids_:checkbox:checked").val();
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					$("#editForm").fill(result.datas[0]);
					if(result.datas[0].parentId == "${s:getSysConstant('NUM_ROOT')}") {
						$("#parentId").val("${s:getSysConstant('NUM_ROOT')}");
						$("#parentName").val("${s:getSysConstant('NUM_ROOT')}");
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
					}
				});
			}
		});
		
		$("#parentName").on("click", function() {
			showOrgTree(this,null,function(treeId, treeNode) {
				$("#parentId").val(treeNode.id);
				$("#parentName").val(treeNode.orgName);
			});
		});
		
		var clipboard = new Clipboard('.a-copy', {
		    text: function(o) {
		    	layer.msg("复制成功");
		    	return $(o).attr("v");
		    }
		});
	});
</script>
<link href="${ctx}/js/tree/divTree.css" rel="stylesheet">
<script src="${ctx}/js/tree/orgTree.js"></script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12" style="padding-left: 10px;">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-flag-checkered"></i> 机构列表</h5>
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
									<th>机构名称</th>
									<th>类型</th>
									<th>上级机构</th>
									<th>排序</th>
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
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
		            
		            <div class="ibox-content">
	                  <input type="text" id="id" name="id" style="display:none"/>
	                  <input type="text" id="rowVersion" name="rowVersion" style="display:none"/>
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">机构代码</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required,custom[onlyLetterNumber]]" name="orgCode" id="orgCode" maxlength="16">
					    </div>
					    <label class="col-sm-2 control-label">机构名称</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" id="orgName" name="orgName" maxlength="16">
					    </div>
					  </div>
	
					  <div class="form-group">
					    <label class="col-sm-2 control-label">上级机构</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" id="parentName" name="parentName" readonly="readonly" >
					      <input type="text" class="validate[required]" id="parentId" name="parentId" style="display:none"/>
					    </div>
					    <label class="col-sm-2 control-label">类型</label>
					    <div class="col-sm-4">
					      <s:dict dictType="orgType" clazz="input-sm form-control"></s:dict>
					    </div>
					  </div>
					  
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">机构级别</label>
					    <div class="col-sm-4">
					      <s:dict dictType="orgLevel" clazz="input-sm form-control"></s:dict>
					    </div>
					  	<label class="col-sm-2 control-label">机构属性</label>
					    <div class="col-sm-4">
					      <s:dict dictType="orgAttr" clazz="input-sm form-control"></s:dict>
					    </div>
					  </div>
	
					 <!--  <div class="form-group">
					  	<label class="col-sm-2 control-label">内线电话</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[custom[phone]]" name="insideLine" id="insideLine" maxlength="11">
					    </div>
					    <label class="col-sm-2 control-label">外线电话</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[custom[phone]]" name="outsideLine" id="outsideLine" maxlength="11">
					    </div>
					  </div>

					  <div class="form-group">
					    <label class="col-sm-2 control-label">经度</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[custom[number]]" name="orgLng" id="orgLng" maxlength="16">
					    </div>
					  	<label class="col-sm-2 control-label">纬度</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[custom[number]]" name="orgLat" id="orgLat" maxlength="16">
					    </div>
					  </div> -->
	
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">所在区域</label>
					    <div class="col-sm-4">
					      <s:dict dictType="areaCode" clazz="input-sm form-control"></s:dict>
					    </div>
					    <label class="col-sm-2 control-label">企业标识</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="ext1" id="ext1" maxlength="16">
					    </div>
					  </div>

					  <div class="form-group">
					    <label class="col-sm-2 control-label">机构地址</label>
					    <div class="col-sm-10">
					      <input type="text" class="input-sm form-control" name="orgAddress" id="orgAddress" maxlength="128">
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">排序号</label>
					    <div class="col-sm-4">
					      <input type="number" class="input-sm form-control validate[required,custom[integer]]" name="sortNo" id="sortNo" >
					    </div>
					    <label class="col-sm-2 control-label">状态</label>
					    <div class="col-sm-4">
					      <label><input type="radio" name="rowValid" value="1" checked="checked">有效</label>
					      <label><input type="radio" name="rowValid" value="0">禁用</label>
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
	
	<!-- edit start-->
	<div class="modal fade" id="importModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:50%;">
	        <div class="modal-content ibox">
                <form id="importForm" class="form-horizontal key-13" role="form">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-download"></i> 导入数据</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
		            
		            <div class="ibox-content">
					  <div class="form-group">
					    <label class="col-sm-2 control-label">
					    	<a href="${ctx}/files/templet/org_templet.xlsx">模板下载</a>
					    </label>
					    <div class="col-sm-10">
					      <input type="file" name="file" id="file" class="validate[required]" accept=".xlsx">
					    </div>
					  </div>
		            </div>
		            
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-import-ok">
		                	<i class="fa fa-check"></i> 确定
		                </button>
		                <button type="button" class="btn btn-sm btn-default" id="btn-import-cancel" data-dismiss="modal">
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