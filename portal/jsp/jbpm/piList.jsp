<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script src="${ctx}/js/plugins/WdatePicker/WdatePicker.js"></script>
<script>
	var completeTaskUrl = "${ctx}/api/jbpm/completeTask.do";
	var deleteProcessInstanceUrl = "${ctx}/api/jbpm/deleteProcessInstance.do";
	var queryProcessInstanceUrl = "${ctx}/api/jbpm/queryProcessInstance.do";
	var suspendUrl = "${ctx}/api/jbpm/suspend.do";
	var resumeUrl = "${ctx}/api/jbpm/resume.do";
	var table;
	var sysId = "${myUser.user.extMap.sys.id}";
	sysId=""==sysId?"${myUser.user.sysId}":sysId;
	
	$(window).ready(function() {
		table = $("#datas").on('init.dt', function () {
				$("#checkAll_,.checkAll_").on("click", function() {
					$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
				});
	    	}).dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": true,
			"autoWidth": false,
			"processing": true,
			"serverSide": true,
			"stateSave":true,
			"ajax": {
				"dataSrc": "datas",
				"url": queryProcessInstanceUrl,
				"data": function (d) {
					var param = {
						"sysId": sysId,
						"keywords": $("#keywords").val(),
						"queryType": $("#queryType").val(),
						"PROCDEFID_": $("#PROCDEFID_").val(),
						"taskState": "${param.taskState}"//特殊
					};
					if("all" != "${param.flag}") {
						param.userName = "${myUser.username}";
					}
					return $.extend( {}, d, param);
				}
			},
			"aaSorting": [[ 5, "desc" ]],
			"aoColumnDefs": [ {
				"bSortable": false,
				"aTargets": [ 0, 1, 2, 3, 4, 7, 8, 9, 10, 11, 12 ]
			}, {
				"targets": [ 0 ],
				"data":"pId",
				"title":"<input type='checkbox' id='checkAll_' style='margin:0px;'>",
				"render": function (data, type, row) {
					var s = '<input type="checkbox" ';
					if(row.taskId) {
						s = s + 'taskId="'+row.taskId+'" '; 
						s = s + 'title="'+row.taskId+'" '; 
					}
					var state = row.taskState ? row.taskState : row.state;
					if("all" != "${param.flag}" && (row.owner != "${myUser.username}" || 'suspended' == state || 'cancel' == state || 'ended' == state)) {
						s = s + 'disabled="disabled" '; 
					} else {
						s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
					}
					return s +'style="margin:0px;"/>';
				}
			}, {
				"targets": [ 1 ],
				"data":"formCode",
				"title":"工单号",
				"render": function (data, type, row) {
					return "<span title='"+row.pId+"'>"+data+"</span>";
				}
			}, {
				"targets": [ 2 ],
				"data":"pId",
				"title":"工单类型",
				"render": function (data, type, row) {
					var pdName = data.substring(0,data.lastIndexOf("."));
					var formTypeSmall = row['formTypeSmall'];
					if(formTypeSmall){
						pdName = pdName + '(' + formTypeSmall + ')';
					}
					return "<span title='"+row.pdId+"'>"+pdName+"</span>";
				}
			}, {
			<c:if test="${'MY' eq myUser.user.extMap.org.ext1 ||'LUZ' eq myUser.user.extMap.org.ext1}">
				"targets": [ 3 ],
				"data":"formTitle",
				"title":"工单关键字",
				"render": function (data, type, row) {
					if(data){
						return data;
					}
				}
			}, {
			</c:if>
			<c:if test="${'GY' eq myUser.user.extMap.org.ext1}">
				"targets": [ 3 ],
				"data":"formTitle",
				"title":"工单主题",
				"render": function (data, type, row) {
					if(data){
						return data;
					}
				}
			}, {
			</c:if>
				"targets": [ 4 ],
				"data":"userAlias",
				"title":"发起人",
				"render": function (data, type, row) {
					if(data) {
						return "<span title='"+row.owner+"'>"+data+"</span>";
					} else {
						return row.owner;
					}
				}
			}, {
				"targets": [ 5 ],
				"data":"create",
				"title":"开始时间",
				"render": function (data, type, row) {
					return '<span title="'+row.taskCreate+'">'+data+'</span>';
				}
			}, {
				"targets": [ 6 ],
				"data":"end",
				"title":"结束时间",
				"render": function (data, type, row) {
					return data ? data : "";
				}
			}, {
				"targets": [ 7 ],
				"data":"duration",
				"title":"<span title='分钟'>耗时</span>",
				"render": function (data, type, row) {
					if(data) {
						try{
							return parseInt(data/1000/60)
						} catch (e) {}
					}
					return "";
				}
			}, {
				"targets": [ 8 ],
				"data":"activityName",
				"title":"环节",
				"render": function (data, type, row) {
					try{
						data = data ? data : row.endActivity;
						var assignee = row.assignee ? row.assignee : "";
						/* if(row.priority && 0 != row.priority) {
							var currDate = new Date().getTime() - new Date(row.createTime).getTime();
							if(currDate > (row.priority*60*1000)) {
								return "<span style='color:#DAA520' title='"+assignee+"'>"+data+"</span>";
							}
						} */
						return "<span title='"+assignee+"'>"+data+"</span>";
					} catch (e) {}
				}
			}, {
				"targets": [ 9 ],
				"title":"<span title='分钟'>剩余时长</span>",
				"render": function (data, type, row) {
					try{
						if(row.priority && 0 != row.priority) {
							var currDate = new Date().getTime() - new Date(row.taskCreate).getTime();
							currDate = row.priority - currDate/60/1000;
							if(currDate > 0) {
								return "<span title='时效："+row.priority+"分钟'>"+parseInt(currDate)+"</span>";
							}
							return "<span style='color:#DAA520' title='时效："+row.priority+"分钟'>"+parseInt(currDate)+"</span>";
						}
						return "<span>-</span>";
					} catch (e) {}
				}
			}, {
				"targets": [ 10 ],
				"data":"assigneeDesc",
				"title":"处理人",
				"render": function (data, type, row) {
					if(!data){
						return '';
					}else{
						var assignee = row.assignee ? row.assignee : "";
						return "<span title='"+assignee+"'>"+data+"</span>";
					}
				}
			}, {
				"targets": [ 11 ],
				"data":"state",
				"title":"状态",
				"render": function (data, type, row) {
					if(data) {
						data = row.taskState ? row.taskState : data;
						if('active' == data || 'open' == data) {
							return "<span style='color:#008B00' title='"+data+"'><i class='fa fa-play-circle-o'></i> 正常</span>";
	                    } else if('suspended' == data) {
							return "<span style='color:#DAA520' title='"+data+"'><i class='fa fa-pause-circle-o'></i> 挂起</span>";
	                    } else if('cancel' == data) {
							return "<span style='color:#8B0000' title='"+data+"'><i class='fa fa-times-circle-o'></i> 终止</span>";
	                    } else {
							return "<span style='color:#FF0000' title='"+data+"'><i class='fa fa-stop-circle-o'></i> 结束</span>";
	                    }
					}
					return "";
				}
			}, {
				"targets": [ 12 ],
				"title":"操作",
				"render": function (data, type, row) {
					return '<a onclick="actionUrl(this)" action-id="${ctx}/api/jbpm/taskInfo.do?pId='+encodeURI(row.pId)+'&page=${param.page}" href="javascript:void(0)">详情</a>';
				}
			}]
		});
          
		$("#btn-delete").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size < 1) {
				layer.msg("请选择需要删除的数据！", {icon: 0});
				return;
			}
			
			layer.confirm('您确定要删除数据吗？', {
				icon: 3
			}, function() {
				var ids = [];
				$(".ids_:checkbox:checked").each(function(index, o){
					ids.push($(this).val());
				});
				var obj = new Object();
				obj.url = deleteProcessInstanceUrl;
				obj.pId = ids.join(",");
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

		$(".btn-result").on("click", function() {
			var result = $(this).attr("result");
			var size = $(".ids_:checkbox:checked").length;
			if(size < 1) {
				layer.msg("请选择需要"+result+"的数据！", {icon: 0});
				return;
			}
			
			layer.confirm('您确定要'+result+'数据吗？', {
				icon: 3
			}, function() {
				var ids = [];
				$(".ids_:checkbox:checked").each(function(index, o){
					var taskId = $(this).attr("taskId");
					if(taskId) {
						ids.push(taskId);
					}
				});
				if(ids.length == 0) {
					layer.msg("没有需要"+result+"的数据！", {icon: 0});
					return;
				}
				var obj = new Object();
				obj.url = completeTaskUrl;
				obj.taskId = ids.join(",");
				obj.userName = "${myUser.username}";
				obj.result = result;
				obj.desc = "发起人"+result;
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

		$("#btn-suspend").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size < 1) {
				layer.msg("请选择需要挂起的数据！", {icon: 0});
				return;
			}
			
			layer.confirm('您确定要挂起数据吗？', {icon: 3}, function() {
				var ids = [];
				$(".ids_:checkbox:checked").each(function(index, o){
					var taskId = $(this).attr("taskId");
					if(taskId) {
						ids.push(taskId);
					}
				});
				if(ids.length == 0) {
					layer.msg("没有需要挂起的数据！", {icon: 0});
					return;
				}
				var obj = new Object();
				obj.url = suspendUrl;
				obj.taskId = ids.join(",");
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
		
		$("#btn-resume").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size < 1) {
				layer.msg("请选择需要恢复的数据！", {icon: 0});
				return;
			}
			
			layer.confirm('您确定要恢复数据吗？', {icon: 3}, function() {
				var ids = [];
				$(".ids_:checkbox:checked").each(function(index, o){
					var taskId = $(this).attr("taskId");
					if(taskId) {
						ids.push(taskId);
					}
				});
				if(ids.length == 0) {
					layer.msg("没有需要恢复的数据！", {icon: 0});
					return;
				}
				var obj = new Object();
				obj.url = resumeUrl;
				obj.taskId = ids.join(",");
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
		
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				var param = {
					"sysId": sysId,
					"keywords": $("#keywords").val(),
					"queryType": $("#queryType").val(),
					"PROCDEFID_": $("#PROCDEFID_").val(),
					"taskState": "${param.taskState}"//特殊
				};
				if("all" != "${param.flag}") {
					param.userName = "${myUser.username}";
				}
				table.api().settings()[0].ajax.data = param;
				table.api().ajax.reload();
			}
       	});

		var preUrl = document.referrer;
		var s = "${s:getDate('yyyyMMdd')}";
		if(preUrl.indexOf("taskInfo.do")==-1){
			$("#keywords").val(s);
			//当前页面不是从返回页面来  //此次报错，不清楚原因，如有其他问题请查询验证
			//table.clear().draw();
			//table.api().state.clear(); 
			//table.api().ajax.reload()
		}else{
			//$("#keywords").val("%");
			$("#keywords").val(s);
			}

	});


	function actionUrl($this){
		var action_url = $($this).attr("action-id");//需要跳转的url地址
		var keywords = "&keywords="+$("#keywords").val();
		
		window.location.href=action_url+keywords;
		}
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
                	<c:if test="${'mywork' ne param.page}">
	   					<div class="ibox-title">
		                    <h5><c:choose>
		                    		<c:when test="${'all' ne param.flag}">
		                    			<i class="fa fa-flag"></i> 已办列表
		                    		</c:when>
		                    		<c:otherwise>
		                    			<i class="fa fa-tasks"></i> 实例列表
		                    		</c:otherwise>
		                    	</c:choose>
		                    </h5>
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
	                </c:if>
	                
                    <div class="ibox-content">
                        <!-- search star -->
						<div class="form-horizontal clearfix key-13">
							<div class="col-sm-6 pl0">
								<c:if test="${'mywork' ne param.page}">
									<c:if test="${'ended' ne param.taskState}"><!-- 特殊 -->
										<c:choose>
											<c:when test="${'all' ne param.flag}">
												<!-- <button class="btn btn-sm btn-success btn-result" title="只能撤回本人发起的流程" result="撤回">
													<i class="fa fa-mail-reply"></i> 撤回
												</button>
												<button class="btn btn-sm btn-success btn-result" title="只能终止本人发起的流程" result="终止">
													<i class="fa fa-times-circle-o"></i> 终止
												</button> -->
												<!-- <button class="btn btn-sm btn-success" id="btn-delete" title="只能删除本人发起的流程">
													<i class="fa fa-trash-o"></i> 删除
												</button> -->
											</c:when>
											<c:otherwise>
												<button class="btn btn-sm btn-success" id="btn-suspend" title="只能挂起正常的流程">
													<i class="fa fa-pause-circle-o"></i> 挂起
												</button>
												<button class="btn btn-sm btn-success" id="btn-resume" title="只能恢复挂起的流程">
													<i class="fa fa-play-circle-o"></i> 恢复
												</button>
												<button class="btn btn-sm btn-success" id="btn-delete">
													<i class="fa fa-trash-o"></i> 删除
												</button>
											</c:otherwise>
										</c:choose>
									</c:if>
								</c:if>
							</div>
	
							<div class="col-sm-6 form-inline" style="padding-right:0; text-align:right">
								<form id="queryForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
									<input type="hidden" placeholder="工单分类" class="input-sm form-control" id="PROCDEFID_">
									 <select id="queryType" class="form-control">
	                                 	<option value="userName">发起人姓名</option>
	                                 	<option value="formCode_" selected="selected">工单号</option>
	                                 	<option value="owner_">发起人账号</option>
	                                 	<c:if test="${'DY' eq myUser.user.extMap.org.ext1}">
	                                 	<option value="detail_value_">手机号</option>
	                                 	</c:if>
	                                </select>
									<input type="text" placeholder="关键字" class="input-sm form-control validate[required,custom[tszf]]" id="keywords" value="">
	                                <button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
										<i class="fa fa-search"></i> 查询
									</button>
									<!-- 
									1、明细应该是叫工单名字，例如条件(待办工单)  会把这个工单都查询出来，但是这里没有查询出来哈；
									
									2、工单状态，      放入条件(active)  这个是查询流转中工单
												放入条件(ended)  这个是查询归档结束的工单
												
												
									3、任务状态 		放入条件(open)  这个是查询流转中工单
									
									4、还缺少一个，时间查询，例如20190226
									
									
									
									 -->
									
								</form>
							</div>
						</div>
						<!-- search end -->
                        
                        <table id="datas" class="table display" style="width:100%">
                           <!-- <thead>
                                <tr>
                                	<th><input type="checkbox" id="checkAll_" style="margin:0px;"></th>
									<th>工单号</th>
									<th>工单类型</th>
									<th>发起人</th>
									<th>开始时间</th>
									<th>结束时间</th>
									<th title="分钟">耗时</th>
									<th>环节</th>
									<th>处理人</th>
									<th>状态</th>
									<th>操作</th>
                                </tr>
                            </thead> -->
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>