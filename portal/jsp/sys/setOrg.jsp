<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
	var insertUrl = "${ctx}/jsp/sys/insertUserOrg.do";
	var deleteUrl = "${ctx}/jsp/sys/deleteUserOrg.do";
	var queryUrl = "${ctx}/jsp/sys/queryUser.do";
	if("true" == "${myUser.user.userName ne s:getSysConstant('ADMIN_USER')}") {
		queryUrl+=("true"=="${s:getProp('sys.aync')}"?"":"?sysId=${myUser.user.extMap.sys.id}");
	}

	$(window).ready(function() {
		queryUser("leftdatas", "${param.orgId}");
		
		$("a[href=#tab-1]").on("click", function() {
			queryUser("leftdatas", "${param.orgId}");
			$("#btn-left-query").click();
       	});
		
		$("a[href=#tab-2]").on("click", function() {
			queryUser("rightdatas", "empty");
			$("#btn-right-query").click();
       	});
		
		$(".btn-query").on("click", function() {
			var orgId = "${param.orgId}";
			var keywords = $("#l_keywords").val();
			if("btn-right-query" == this.id) {
				var b = $("#r_queryForm").validationEngine("validate");
				if(!b) {
					return;
				}
				orgId = "empty";
				keywords = $("#r_keywords").val();
			} else {
				var b = $("#l_queryForm").validationEngine("validate");
				if(!b) {
					return;
				}
			}
			var param = {
				"keywords": keywords,
				"orgId" : orgId
			};
			table.api().settings()[0].ajax.data = param;
			table.api().ajax.reload();
       	});
		
		$(".btn-setUser").on("click", function() {
			var id = "leftdatas";
			var msg = "请选择需要移除的成员！";
			if("btn-insert" == this.id) {
				id = "rightdatas";
				msg = "请选择需要添加的成员！";
			}
			var size = $("#"+id+" .ids_:checkbox:checked").length;
			if(size < 1) {
				layer.msg(msg, {icon: 0});
				return;
			}
			var url = deleteUrl;
			if("btn-insert" == this.id) {
				url = insertUrl;
			}
			var ids = [];
			$("#"+id+" .ids_:checkbox:checked").each(function(index, o){
				ids.push($(this).val());
			});
			var obj = new Object();
			obj.url = url;
			obj.orgId = "${param.orgId}";
			obj.userIds = ids.join(",");
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
	
	var table;
	var queryUser = function(id, orgId) {
		table = $("#"+id).dataTable({
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
						"orgId" : orgId
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
				"data":"userName"
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
					return "";
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
				//	return '<a onclick="parent.menuItem(\'成员信息\',\'${ctx}/jsp/sys/userInfo.jsp?userId='+data+'\')">详情</a>';
					return '<a href="${ctx}/jsp/sys/userInfo.jsp?userId='+data+'">详情</a>';
				}
			}]
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
	                    <h5><i class="fa fa-user-circle"></i> 成员列表（机构：${param.orgName}）</h5>
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
                        <div class="tabs-container">
		                    <ul class="nav nav-tabs">
		                        <li class="active form">
		                        	<a data-toggle="tab" href="#tab-1" aria-expanded="true">已添加的成员</a>
		                        </li>
		                        <li>
		                        	<a data-toggle="tab" href="#tab-2" aria-expanded="false">待添加的成员</a>
		                        </li>
		                    </ul>
		                    <div class="tab-content">
		                        <div id="tab-1" class="tab-pane active form">
		                            <div class="panel-body" style="padding:10px !important;">
		                              	<!-- search star -->
										<div class="form-horizontal clearfix">
											<div class="col-sm-6 pl0">
												<button class="btn btn-sm btn-success btn-setUser" id="btn-delete">
													<i class="fa fa-user-times"></i> 移除
												</button>
											</div>
					
											<div class="col-sm-6 form-inline" style="padding-right:0; text-align:right">
												<form id="l_queryForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
													<input type="text" placeholder="关键字" class="input-sm form-control validate[custom[tszf]]" id="l_keywords">
					                                <button id="btn-left-query" type="button" class="btn btn-sm btn-success btn-query btn-13">
														<i class="fa fa-search"></i> 查询
													</button>
												</form>
											</div>
										</div>
										<!-- search end -->
				                        
				                        <table id="leftdatas" class="table display" style="width:100%">
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
		                        <div id="tab-2" class="tab-pane his">
		                            <div class="panel-body" style="padding:10px !important;">
		                              	<!-- search star -->
										<div class="form-horizontal clearfix">
											<div class="col-sm-6 pl0">
												<button class="btn btn-sm btn-success btn-setUser" id="btn-insert">
													<i class="fa fa-user-plus"></i> 添加
												</button>
											</div>
											
											<div class="col-sm-6 form-inline" style="padding-right:0; text-align:right">
												<form id="r_queryForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
													<input type="text" placeholder="关键字" class="input-sm form-control validate[custom[tszf]]" id="r_keywords">
					                                <button id="btn-right-query" type="button" class="btn btn-sm btn-success btn-query btn-13">
														<i class="fa fa-search"></i> 查询
													</button>
												</form>
											</div>
										</div>
										<!-- search end -->
				                        
				                        <table id="rightdatas" class="table display" style="width:100%">
				                            <thead>
				                                <tr>
					                                <th><input type="checkbox" class="checkAll_" style="margin:0px;"></th>
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
                </div>
            </div>
        </div>
    </div>
</body>
</html>