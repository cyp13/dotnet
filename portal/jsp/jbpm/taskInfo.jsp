<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
	var queryUrl = "${ctx}/api/jbpm/queryHisTask.do";
	
	var h = 136;
	h = 'mywork' == '${param.page}' ? 92 : h;
	
	$(window).resize(function() {
		$("#form").css("height",document.body.clientHeight-h);
		$("#view").css("height",document.body.clientHeight-h);
	});
	
	$(window).ready(function() {
		$("#form").css("min-height", $(window).height()-h);
		$("#view").height($(window).height()-h);
		
		var	form = '${s:getVariable(param.pId,param.taskId,"form_")}';
		if (form && "null" != form) {
			form += form.indexOf("?") > -1 ? "&" : "?";
			form += getParameterStr();
			if(form.indexOf("token=") == -1) {
				form += "&token=${myUser.user.extMap.token}";
			}
		//	form = form.replace("\$\{ctx\}", "${ctx}");
			$("#form").attr("src", form);
		} else {
			$(".form").css("display", "none");
			$(".his").addClass("active");
			queryHisTask();
		}
		
		$("a[href=#tab-1]").on("click", function() {
			$("#form").attr("src", form);
       	});
		
		$("a[href=#tab-2]").on("click", function() {
			if(table) {
				table.api().ajax.reload();
			} else {
				queryHisTask();
			}
       	});
		
		$("a[href=#tab-3]").on("click", function() {
			$("#view").attr("src","${ctx}/api/jbpm/designerView.do?pId="+encodeURI("${param.pId}"));
       	});

	});
	
	var table;
	var queryHisTask = function() {
		table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": true,
			"autoWidth": false,
			"processing": true,
			"serverSide": false,
			"ajax": {
				"dataSrc": "datas",
				"url": queryUrl,
				"data": function (d) {
					return $.extend( {}, d, {
						"pId" : "${param.pId}"
					});
				}
			},
			"aaSorting": [],
			"aoColumnDefs": [ {
				"bSortable": false,
				"aTargets": [ 0, 4, 5, 6, 7, 8 ]
			}, {
				"targets": [ 0 ],
				"data":"taskId",
				"render": function (data, type, row) {
					return data ? "<span title='"+row.pId+"'>"+data+"</span>" : "-";
				}
			}, {
				"targets": [ 1 ],
				"data":"create",
				"render": function (data, type, row) {
					return data;
				}
			}, {
				"targets": [ 2 ],
				"data":"end",
				"render": function (data, type, row) {
					if(row.desc&&row.desc.indexOf("会签")>-1){
						return row.time;
					}
					return data ? data : "";
				}
			}, {
				"targets": [ 3 ],
				"data":"duration",
				"render": function (data, type, row) {
					try{
						if(row.desc&&row.desc.indexOf("会签")>-1){
							data =  new Date(row.time).getTime() - new Date(row.create).getTime();
						}
						/* if(row.priority && 0 != row.priority) {
							var str = "<span title='时效："+row.priority+"分钟' ";
							if(data > (row.priority*60*1000)) {
								str += "style='color:#DAA520'";
							} else if(0 == data){
								var currDate = new Date().getTime() - new Date(row.create).getTime();
								if(currDate > (row.priority*60*1000)) {
									str += "style='color:#DAA520'";
								}
							}
							return str += (">" + parseInt(data/1000/60) + "</span>");
						} */
						return parseInt(data/(1000*60));
					} catch (e) {}
				}
			}, {
				"targets": [ 4 ],
				"data":"activityName"
			}, {
				"targets": [ 5 ],
				"render": function (data, type, row) {
					try{
						if(row.priority>0){
							var dur;
							if(row.duration){
								dur = row.duration/(1000*60); 
							}else{
								dur = new Date().getTime() - new Date(row.create).getTime();
								dur = dur/(60*1000);
							}
							dur = row.priority - dur; 
							if(dur > 0) {
								return "<span title='时效："+row.priority+"分钟'>"+parseInt(dur)+"</span>";
							}
							return "<span style='color:#DAA520' title='时效："+row.priority+"分钟'>"+parseInt(dur)+"</span>";
						}else{
							return "<span>-</span>";
						}
					} catch (e) {}
				}
			}, {
				"targets": [ 6 ],
				"data":"userAlias",
				"render": function (data, type, row) {
					if(row.taskId) {
						var desc = row.desc;
	 					if(desc&&desc.indexOf("会签")>-1){
	 						var arr = desc.split("-");
	 						if(arr.length>2){
	 							return "<span title='"+arr[2]+"'>"+arr[2]+"</span>";
	 						}else{
	 							var userAlias = row.userAlias ? row.userAlias : row.assignee;
	 							userAlias = userAlias ? userAlias : "";
	 							return "<span title='"+row.assignee+"'>"+userAlias+"</span>";
	 						}
	 					}else{
		 					var userAlias = row.userAlias ? row.userAlias : row.assignee;
		 					userAlias = userAlias ? userAlias : "";
		 					return "<span title='"+row.assignee+"'>"+userAlias+"</span>";
	 					}
						
					} else {
						return "-";
					}
				}
			}, {
				"targets": [ 7 ],
				"data":"result",
				"render": function (data, type, row) {
					var desc = row.desc;
 					if(desc&&desc.indexOf("会签")>-1){
 						var arr = desc.split("-");
 						if(arr.length>1){
 							data= arr[1];
 						}
 					}
					if('不同意' == data || '回退' == data || '驳回' == data || '终止' == data || '结束' == data || '撤回' == data || '驳回归档' == data) {
						return "<span style='color:#FF0000'>"+data+"</span>";
                    }
					if('其他'==data){
						if('发起人'==row.activityName){
							return "发布";
						}
						return "同意";
					}
					return data ? data : "";
				}
			}, {
				"targets": [ 8 ],
				"data":"desc",
				"width":"20%",
				"render": function (data, type, row) {
					if(data) {
						if(data.indexOf("会签")>-1){
 	 						var arr = data.split("-");
 	 						if(arr.length==4){
 	 							return '<div style="overflow:hidden;" title="'+arr[3]+'">'+arr[3]+'</div>';
 	 						}
 	 					}else{
	 						return '<div style="overflow:hidden;" title="'+data+'">'+data+'</div>';
 	 					}
						//return '<div style="width:200px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;" title="'+data+'">'+data+'</div>';
					}
					return "";
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
            		<div class="ibox-title" style="display: ${'mywork' ne param.page ? '' : 'none'};">
	                    <h5><i class="fa fa-info-circle"></i> 实例详情（${param.pId}）</h5>
                    	<div class="ibox-tools">
	                       <a class="a-reload">
	                          <i class="fa fa-repeat"></i> 刷新
	                       </a>
	                       <a class="a-back">
	                          <i class="fa fa-reply"></i> 返回
	                       </a>
	                    </div>
	                </div>
	                
	                <div class="ibox-content">
		                <div class="tabs-container">
		                    <ul class="nav nav-tabs">
		                        <li class="active form">
		                        	<a data-toggle="tab" href="#tab-1" aria-expanded="true" title="${param.pId}">业务表单</a>
		                        </li>
		                        <li class="his">
		                        	<a data-toggle="tab" href="#tab-2" aria-expanded="false" title="${param.pId}">历史详情</a>
		                        </li>
		                        <li>
		                        	<a data-toggle="tab" href="#tab-3" aria-expanded="false" title="${param.pId}">流程图</a>
		                        </li>
		                    </ul>
		                    <div class="tab-content">
		                        <div id="tab-1" class="tab-pane active form">
		                            <div class="panel-body" style="padding:0px !important;">
		                            	<iframe id="form" style="width:100%; height:100%; display:block; border:0px;"></iframe>
		                            </div>
		                        </div>
		                        <div id="tab-2" class="tab-pane his">
		                            <div class="panel-body" style="padding:10px !important;">
		                            	<table id="datas" class="table display" style="width:100%">
				                            <thead>
				                                <tr>
					                                <th>任务ID</th>
													<th>开始时间</th>
													<th>结束时间</th>
													<th title="分钟">耗时</th>
													<th>环节</th>
													<th title="分钟">剩余时长</th>
													<th>处理人</th>
													<th>结果</th>
													<th>意见</th>
				                                </tr>
				                            </thead>
				                        </table>
		                            </div>
		                        </div>
		                        <div id="tab-3" class="tab-pane">
		                            <div class="panel-body" style="padding:0px !important;">
		                            	<iframe id="view" style="width:100%; height:100%; display:block; border:0px;"></iframe>
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