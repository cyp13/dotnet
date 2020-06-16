<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<link href="${ctx}/js/plugins/select/bootstrap-select.css" rel="stylesheet"  />
<script src="${ctx}/js/plugins/select/bootstrap-select.js"></script>
<script src="${ctx}/js/plugins/WdatePicker/WdatePicker.js"></script>
<script>
	var queryUrl = "${ctx}/jsp/sys/querySys.do";
    var insertUrl = "${ctx}/jsp/sys/insertSys.do";
	var updateUrl = "${ctx}/jsp/sys/updateSys.do";
	var deleteUrl = "${ctx}/jsp/sys/deleteSys.do";
	var queryOrgUrl = "${ctx}/jsp/sys/queryOrg.do";
	var queryUserUrl = "${ctx}/jsp/sys/queryUser.do";

	$(window).ready(function() {
		dt.ajax = {
			"dataSrc": "datas",
			"url": queryUrl	
		};
		dt.aoColumnDefs = [{
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
			"data":"sysName",
			"render": function (data, type, row) {
				if(row.sysUrl && "3" == row.sysType) {
					return '<a href="'+row.sysUrl+'" title="'+row.sysUrl+'" target="_blank" class="a-copy" title="点击复制ID" v="'+row.id+'">'+data+'</a>';
				} else {
					return '<span class="a-copy" title="点击复制ID" v="'+row.id+'">'+data+'</span>';
				}
				return data;	
			}
		}, {
			"targets": [ 2 ],
			"data":"sysVersion"
		}, {
			"targets": [ 3 ],
			"data":"sysRelease"
		}, {
			"targets": [ 4 ],
			"data":"sortNo"
		}, {
			"targets": [ 5 ],
			"data":"extMap.rowValid",
			"render": function (data, type, row) {
				if("0" == row.rowValid) {
					return '<span style="color:#FF0000">'+data+'<span/>';	
				}
				return data;
			}
		}, {
			"targets": [ 6 ],
			"render": function (data, type, row) {
				return '<img src="${ctx}/images/logo.do?id='+row.id+'&r='+Math.random()+'"/>';
			}
		}];
		
		var table = $("#datas").dataTable(dt);
         
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				var param = {};
				param.keywords = $("#keywords").val();
				table.api().settings()[0].ajax.data = param;
				table.api().ajax.reload();
			}
       	});
		
		$("#btn-insert").on("click", function() {
			$("#editForm").attr("action", insertUrl);
			$("#myModal").modal("show");
			
			$("#sortNo").val("1");
			$("#sysType").attr("disabled",false); 
			$("#sysType").change();
		//	queryOrg();
		//	queryUser();
       	});

		$("#btn-update").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size != 1) {
				layer.msg("请选择需要修改的一行数据！", {icon: 0});
				return;
			}

			$("#editForm").attr("action", updateUrl);
			$("#myModal").modal("show");
			$("#sysType").attr("disabled",true); 
			$("#sysType").change();
		//	queryOrg();
		//	queryUser();
			
			var obj = new Object();
			obj.url = queryUrl;
			obj.id = $(".ids_:checkbox:checked").val();
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					$("#editForm").fill(result.datas[0]);
					$("#orgId").selectpicker("val", result.datas[0].orgId);
					$("#userId").selectpicker("val", result.datas[0].userId);
					$("#oldUserId").val(result.datas[0].userId);
					$("#sysType").change();
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
		
		$("#sysType").on("change", function() {
			if("3" == $(this).val()) {
				$("#sysUrl").attr("disabled",false);
				$(".sysType3").show();
				$(".sysType1").hide();
				$(".sysType1 input[type=text],.sysType1 select").attr("disabled",true); 
			} else {
				$("#sysUrl").attr("disabled",true); 
				$(".sysType3").hide();
				$(".sysType1").show();
				$(".sysType1 input[type=text],.sysType1 select").attr("disabled",false); 
			}
		});
		
		var clipboard = new Clipboard('.a-copy', {
		    text: function(o) {
		    	layer.msg("复制成功");
		    	return $(o).attr("v");
		    }
		});
	});
	
	var queryOrg = function() {
		var obj = new Object();
		obj.url = queryOrgUrl;
		obj.parentId = "-1";
		obj.rowValid = "1";
		obj.async = false;
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			} else {
				$("#orgId").empty();
				$("#orgId").append("<option value=''>请选择</option>");
				$.each(result.datas, function(i,o) {
					$("#orgId").append("<option value='"+o.id+"'>"+o.orgName+"</option>");
				});
				$("#orgId").selectpicker("render");
				$("#orgId").selectpicker("refresh");
			}
		});
	}
	
	var queryUser = function() {
		var obj = new Object();
		obj.url = queryUserUrl;
		obj.rowValid = "1";
		obj.async = false;
		ajax(obj, function(result) {
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			} else {
				$("#userId").empty();
				$("#userId").append("<option value=''>请选择</option>");
				$.each(result.datas, function(i,o) {
					var orgName = o.extMap.org ? "-"+o.extMap.org.orgName : "";
					$("#userId").append("<option value='"+o.id+"'>"+o.userName+"-"+o.userAlias+orgName+"</option>");
				});
				$("#userId").selectpicker("render");
				$("#userId").selectpicker("refresh");
			}
		});
	}
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-cogs"></i> 系统列表</h5>
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
							<div class="col-sm-6 col-sm-offset-0 pl0">
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
							
							<div class="col-sm-6 form-inline" style="padding-right:0; text-align:right">
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
									<th>系统名称</th>
									<th>版本</th>
									<th>发布日期</th>
									<th>排序</th>
									<th>状态</th>
									<th>LOGO</th>
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
	                  <input type="text" name="id" style="display:none"/>
	                  <input type="text" name="rowVersion" style="display:none"/>
	                  <input type="text" name="sysBelong" style="display:none"/>
	                  <input type="text" name="roleId" style="display:none"/>
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">系统代码</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required,custom[tszf]]" name="sysCode" id="sysCode" maxlength="16">
					    </div>
					    <label class="col-sm-2 control-label">系统名称</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required,custom[tszf]]" name="sysName" id="sysName" maxlength="64">
					    </div>
					  </div>

					  <div class="form-group">
					    <label class="col-sm-2 control-label">系统类型</label>
					    <div class="col-sm-4">
					      <select id="sysType" name="sysType" class="input-sm form-control">
					      	<option value="1" title="机构用户共享">内部管理系统</option>
					      	<!-- <option value="2" title="机构用户独立">内部独立系统</option> -->
					      	<option value="3">外部链接系统</option>
					      </select>
					    </div>
					    <label class="col-sm-2 control-label">系统版本</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required,custom[tszf]]" name="sysVersion" id="sysVersion" maxlength="16">
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">发布日期</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required] date_select" name="sysRelease" value="${s:getDate('')}" readonly="readonly">
					    </div>
					    <label  class="col-sm-2 control-label">技术支持</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required,custom[tszf]]" name="sysSupport" id="sysSupport" placeholder="电子邮件或联系电话" maxlength="16">
					    </div>
					  </div>

					  <div class="form-group">
					    <label class="col-sm-2 control-label">LOGO</label>
					    <div class="col-sm-4">
					      <input type="file" name="sys_logo" id="sys_logo" accept=".jpeg,.jpg,.png,.bmp,.gif"/>
					    </div>     
					    <label  class="col-sm-2 control-label">排序号</label>
					    <div class="col-sm-4">
					      <input type="number" class="input-sm form-control validate[required,custom[integer]]" name="sortNo" id="sortNo" >
					    </div>
					  </div>
					  
					  <div class="form-group sysType3">
					    <label  class="col-sm-2 control-label">系统URL</label>
					    <div class="col-sm-10">
					      <input type="text" class="input-sm form-control validate[required,custom[tszf]]" name="sysUrl" id="sysUrl" >
					    </div>
					  </div>
					  
					  <span class="sysType1">
						  <div class="form-group">
						    <label  class="col-sm-2 control-label">版权信息</label>
						    <div class="col-sm-10">
						      <input type="text" class="input-sm form-control validate[required,custom[tszf]]" name="sysCopyrights" id="sysCopyrights" >
						    </div>
						  </div>
	
						  <%-- <div class="form-group">
						    <label  class="col-sm-2 control-label">管理机构</label>
						    <div class="col-sm-4">
						      <select id="orgId" name="orgId" class="form-control selectpicker"></select>
						    </div>
						  </div> --%>

						  <div class="form-group">
						    <%-- <label  class="col-sm-2 control-label">管理员</label>
						    <div class="col-sm-4">
						      <select id="userId" name="userId" class="form-control validate[required] selectpicker"></select>
						      <input type="text" id="oldUserId" name="oldUserId" style="display:none"/>
						    </div> --%>
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
					  </span>
					  
					  <div class="form-group">
					    <label  class="col-sm-2 control-label">备注</label>
					    <div class="col-sm-10">
					      <textarea class="form-control" name="remark"></textarea>
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
</body>
</html>