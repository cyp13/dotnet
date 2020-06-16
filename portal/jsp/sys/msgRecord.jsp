<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
	var queryUrl = "queryMsgRecord.do";
	var queryUrl_01 = "queryMsgRecord_01.do";
	var deleteUrl = "deleteMsgRecord.do";

	var sysId = "${myUser.user.extMap.sys.id}";
	sysId = "" == sysId ? "${myUser.user.sysId}" : sysId;
	
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
				"url": queryUrl_01,
				"data": function (d) {
					return $.extend( {}, d, {
						"sysId": sysId,
						"flag_": "all",
						"msgId": "${param.msgId}"
					});
				}
			},
			"aoColumnDefs": [ {
				"targets": [ 0 ],
				"data":"id",
				"render": function (data, type, row) {
					var s = '<input type="checkbox" ';
					if("2" != row.readStatus) {
						s = s + 'disabled="disabled" '; 
					} else {
						s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
					}
					return s +'style="margin:0px;"/>';
				}
			}, {
				"targets": [ 1 ],
				"data":"msgTitle"
			}, {
				"targets": [ 2 ],
				"data":"extMap.msgType",
				"render": function (data, type, row) {
					if(data) {
						return data;
					}
					return row.msgType;
				}
			}, {
				"targets": [ 3 ],
				"data":"extMap.msgLevel",
				"render": function (data, type, row) {
					if(data) {
						return data;
					}
					return row.msgLevel;
				}
			}, {
				"targets": [ 4 ],
				"data":"userAlias",
				"render": function (data, type, row) {
					return data ? data : "";
				}
			}, {
				"targets": [ 5 ],
				"data":"orgName",
				"render": function (data, type, row) {
					return data ? data : "";
				}
			}, {
				"targets": [ 6 ],
				"data":"readStatus",
				"render": function (data, type, row) {
					if('1' == data) {
						return "<i class='fa fa-save' style='color:#DAA520'> 草稿</i>";
					} else if('8' == data) {
						return "<i class='fa fa-minus-circle' style='color:#8B0000'> 撤回</i>";
					} else if('9' == data) {
						return "<i class='fa fa-trash-o' style='color:#FF0000'> 删除</i>";
					} else if('2' == data) {
						return "<i class='fa fa-envelope-o' style='color:#DAA520'> 未读</i>";
                    } else if('3' == data) {
                    	return "<i class='fa fa-envelope-open-o'> 已读</i>";
                    }
					return data;
				}
			}, {
				"targets": [ 7 ],
				"data":"modified",
				"render": function (data, type, row) {
					if(data) {
						return '<span title="'+row.modifier+'">'+data+'</span>';
					}
					return "";
				}
			}]
		});
        
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				var param = {
					"sysId": sysId,
					"flag_": "all",
					"msgId": "${param.msgId}",
					"keywords": $("#keywords").val()
				};
				table.api().settings()[0].ajax.data = param;
				table.api().ajax.reload();
			}
       	});
		
		$("#btn-delete").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size < 1) {
				layer.msg("请选择需要撤回的数据！", {icon: 0});
				return;
			}
			
			layer.confirm('您确定要撤回数据吗？', {icon: 3}, function() {
				var ids = [];
				$(".ids_:checkbox:checked").each(function(index, o){
					ids.push($(this).val());
				});
				var obj = new Object();
				obj.url = deleteUrl;
				obj.flag = "8";
				obj.sysId = sysId;
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
	});
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-info-circle"></i> 消息详情</h5>
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
                        <!-- search star -->
						<div class="form-horizontal clearfix">
							<div class="col-sm-6 col-sm-offset-0 pl0">
								<button class="btn btn-sm btn-success" id="btn-delete">
									<i class="fa fa-minus-circle"></i> 撤回
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
									<th>标题</th>
									<th>类型</th>
									<th>级别</th>
									<th>接收人</th>
									<th>所属机构</th>
									<th>状态</th>
									<th>修改时间</th>
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