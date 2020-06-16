<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script src="${ctx}/js/plugins/WdatePicker/WdatePicker.js"></script>
<script>
	var deleteLogsUrl = "${ctx}/jsp/sys/deleteLogs.do";
	var deleteUrl = "${ctx}/jsp/sys/deleteLog.do";
	var queryUrl = "${ctx}/jsp/sys/queryLog.do";

	$(window).ready(function() {
		var table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": true,
			"autoWidth": false,
			"processing": true,
			"serverSide": true,
			"ajax": {
				"dataSrc": "datas",
				"url": queryUrl,
				"data": function (d) {
					return $.extend( {}, d, {
						"keywords": $("#keywords").val(),
						"startTime": $("#startTime").val(),
						"endTime": $("#endTime").val()
					});
				}
			},
			"aaSorting": [[ 6, "desc" ]],
			"aoColumnDefs": [ {
				"bSortable": false,
				"aTargets": [ 0, 1, 2, 4, 5, 7 ]
			}, {
				"targets": [ 0 ],
				"data":"id",
				"render": function (data, type, row) {
					return '<input type="checkbox" class="ids_" name="ids_" value="'+ data +'" style="margin:0px;"/>';
				}
			}, {
				"targets": [ 1 ],
				"data":"module"
			}, {
				"targets": [ 2 ],
				"data":"method"
			}, {
				"targets": [ 3 ],
				"data":"responseTime",
				"render": function (data, type, row) {
					if(data > 6000) {
						return '<span style="color:#FF0000">'+data+'<span/>';
					} else if(data > 3000) {
						return '<span style="color:#DAA520">'+data+'<span/>';
					} else {
						return data;
					}
				}
			}, {
				"targets": [ 4 ],
				"data":"createrIp"
			}, {
				"targets": [ 5 ],
				"data":"creater"
			}, {
				"targets": [ 6 ],
				"data":"created"
			}, {
				"targets": [ 7 ],
				"data":"targetUrl"
			}]
		});
          
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				var param = {
					"keywords": $("#keywords").val(),
					"startTime": $("#startTime").val(),
					"endTime": $("#endTime").val()
				};
				table.api().settings()[0].ajax.data = param;
				table.api().ajax.reload();
			}
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

		$("#btn-clear").on("click", function() {
			layer.confirm('您确定要清空数据吗？', {
				icon: 3
			}, function() {
				var obj = new Object();
				obj.url = deleteLogsUrl;
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
	});
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-history"></i> 日志列表</h5>
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
							<div class="col-sm-3 pl0">
								<button class="btn btn-sm btn-success" id="btn-delete">
									<i class="fa fa-trash-o"></i> 删除
								</button>
								<button class="btn btn-sm btn-success" id="btn-clear">
									<i class="fa fa-remove"></i> 清空
								</button>
							</div>
	
							<div class="col-sm-9 form-inline" style="padding-right:0; text-align:right">
								<form id="queryForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
									<input type="text" placeholder="关键字" class="input-sm form-control validate[custom[tszf]]" id="keywords" name="keywords">
	                                <input type="text" placeholder="开始时间" class="input-sm form-control date_select" id="startTime" name="startTime" readonly="readonly" value="${s:getDate('yyyy-MM-dd 00:00:00')}">
	                                <input type="text" placeholder="结束时间" class="input-sm form-control date_select" id="endTime" id="endTime" readonly="readonly" value="${s:getDate('yyyy-MM-dd 23:59:59')}">
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
									<th>模块</th>
									<th>方法</th>
									<th title="毫秒">耗时</th>
									<th>IP</th>
									<th>用户</th>
									<th>时间</th>
									<th>URL</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>