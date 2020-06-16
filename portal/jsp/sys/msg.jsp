<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<link href="${ctx}/js/plugins/select/bootstrap-select.css" rel="stylesheet"  />
<link href="${ctx}/js/plugins/other/wangEditor-fullscreen-plugin.css" rel="stylesheet"  />
<script src="${ctx}/js/plugins/select/bootstrap-select.js"></script>
<script src="${ctx}/js/plugins/select/defaults-zh_CN.js"></script>
<script src="${ctx}/js/plugins/other/wangEditor.js"></script>
<script src="${ctx}/js/plugins/other/wangEditor-fullscreen-plugin.js"></script>
<script>
	var queryUrl = "queryMsgRecord.do";
	var updateUrl = "updateMsgRecord.do";
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
				"url": queryUrl,
				"data": function (d) {
					return $.extend( {}, d, {
						"sysId": sysId,
						"userId": "${myUser.user.id}",
						"msgType": "${param.msgType}"
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
						s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
					}
					return s +'style="margin:0px;"/>';
				}
			}, {
				"targets": [ 1 ],
				"data":"msgTitle"
			}<%-- 成都消息通知不需要类型和级别 --%>
			<c:if test="${myUser.user.org.ext1 eq 'CD'}">, {
				"targets": [ 2 ],
				"data":"created",
				"render": function (data, type, row) {
					return '<span title="'+row.creater+'">'+data+'</span>';
				}
			}, {
				"targets": [ 3 ],
				"data":"readStatus",
				"render": function (data, type, row) {
					if('2' == data) {
						return "<i class='fa fa-envelope-o' style='color:#DAA520'> 未读</i>";
                    } else if('3' == data) {
                    	return "<i class='fa fa-envelope-open-o'> 已读</i>";
                    }
					return data;
				}
			}, {
				"targets": [ 4 ],
				"data":"modified",
				"render": function (data, type, row) {
					if(data) {
						return '<span title="'+row.modifier+'">'+data+'</span>';
					}
					return "";
				}
			}, {
				"targets": [ 5 ],
				"data":"id",
				"render": function (data, type, row) {
					<c:choose>
						<c:when test="${param.msgType eq '9'}">
							return ' <a href="${ctx}/api/jbpm/taskList.do">去处理</a>';
						</c:when>
						<c:otherwise>
						 	return '<a onclick="updateStatus(\''+data+'\');">详情</a>';
						</c:otherwise>
					</c:choose>
				}
			}
			</c:if>
			<c:if test="${myUser.user.org.ext1 ne 'CD'}">
			, {
				"targets": [ 2 ],
				"data":"extMap.msgType",
				"render": function (data, type, row) {
					if(data) {
						return data;
					}
					return row.msgType;
				}
			},	{
				"targets": [ 3 ],
				"data":"extMap.msgLevel",
				"render": function (data, type, row) {
					if(data) {
						return data;
					}
					return "一般";
				}
			},	{
				"targets": [ 4 ],
				"data":"created",
				"render": function (data, type, row) {
					return '<span title="'+row.creater+'">'+data+'</span>';
				}
			}, {
				"targets": [ 5 ],
				"data":"readStatus",
				"render": function (data, type, row) {
					if('2' == data) {
						return "<i class='fa fa-envelope-o' style='color:#DAA520'> 未读</i>";
                    } else if('3' == data) {
                    	return "<i class='fa fa-envelope-open-o'> 已读</i>";
                    }
					return data;
				}
			}, {
				"targets": [ 6 ],
				"data":"modified",
				"render": function (data, type, row) {
					if(data) {
						return '<span title="'+row.modifier+'">'+data+'</span>';
					}
					return "";
				}
			}, {
				"targets": [ 7 ],
				"data":"id",
				"render": function (data, type, row) {
					<c:choose>
						<c:when test="${param.msgType eq '9'}">
							return ' <a href="${ctx}/api/jbpm/taskList.do">去处理</a>';
						</c:when>
						<c:otherwise>
						 	return '<a onclick="updateStatus(\''+data+'\');">详情</a>';
						</c:otherwise>
					</c:choose>
				}
			}
			</c:if>
			]
			,"initComplete": function(settings, json ) {
				$(".a-forward").on("click", function() {
					try {
						parent.menuItem("待处理", "${ctx}/api/jbpm/taskList.do");
					} catch (e) {
						window.open("${ctx}/api/jbpm/taskList.do", "_blank");
					}
		       	});
			}
		});
        
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				var param = {
					"sysId": sysId,
					"userId": "${myUser.user.id}",
					"keywords": $("#keywords").val(),
					"msgType": "${param.msgType}"
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
		
		$("#btn-ok").on("click", function() {
			$("#myModal").modal("hide");
		});
		
		try {
			E = window.wangEditor;
			editor = new E('.editor');
			editor.customConfig.menus = [
/*                 'head',  // 标题
			    'bold',  // 粗体
			    'fontSize',  // 字号
			    'fontName',  // 字体
			    'italic',  // 斜体
			    'underline',  // 下划线
			    'strikeThrough',  // 删除线
			    'foreColor',  // 文字颜色
			    'backColor',  // 背景颜色
			    'link',  // 插入链接
			    'list',  // 列表
			    'justify',  // 对齐方式
			    'emoticon',  // 表情
			    'table',  // 表格
			    'code',  // 插入代码
			    'undo',  // 撤销
			    'redo'  // 重复 */
            ];
			editor.create();
			E.fullscreen.init('.editor');
			editor.$textElem.attr('contenteditable', false);
		} catch(ex) {}
	});
	
	var updateStatus = function(id) {
		$(".files").html("");
		if(id) {
			editor.txt.clear();
			$("#myModal").modal("show");
			$("#editForm").find("input,select,textarea").attr("disabled", true);
			var obj = new Object();
			obj.url = queryUrl;
			obj.id = id;
			obj.sysId = sysId;
			obj.userId = "${myUser.user.id}";
			obj.ext3 = "ext3";
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					$("#editForm").fill(result.datas[0]);
					editor.txt.html(result.datas[0].msgContent);
					if("2" == result.datas[0].readStatus) {
						obj.url = updateUrl;
						obj.rowVersion = result.datas[0].rowVersion;
						ajax(obj, function(result) {
							if ("error" == result.resCode) {
								layer.msg(result.resMsg, {icon: 2});
							} else {
								$("#btn-query").click();
							}
						});
					}
					
					var files = result.datas[0].extMap.files;
					if(files && files.length > 0) {
						getFiles( files, $(".files"), true);
					}
				}
			});
		}
	}
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
   						<c:choose>
   							<c:when test="${'9' == param.msgType}">
   								<h5><i class="fa fa-bell-o"></i> 消息列表</h5>
   							</c:when>
   							<c:otherwise>
   								<h5><i class="fa fa-bullhorn"></i> 通知列表</h5>
   							</c:otherwise>
   						</c:choose>
                    	<div class="ibox-tools">
	                        <a class="a-reload">
	                            <i class="fa fa-repeat"></i> 刷新
	                        </a>
	                    </div>
	                </div>
	                
                    <div class="ibox-content">
                        <!-- search star -->
						<div class="form-horizontal clearfix">
							<div class="col-sm-6 col-sm-offset-0 pl0">
								<!-- <button class="btn btn-sm btn-success" id="btn-update">
									<i class="fa fa-info-circle"></i> 详情
								</button> -->
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
									<th>标题</th>
									<%-- 成都消息通知不需要类型和级别 --%>
									<c:if test="${myUser.user.org.ext1 ne 'CD'}">
									<th>类型</th>
									<th>级别</th>
									</c:if>
									<th>接收时间</th>
									<th>状态</th>
									<th>查阅时间</th>
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
	    <div class="modal-dialog" style="width:70%;height: 90%;">
	        <div class="modal-content ibox">
                <form id="editForm" class="form-horizontal key-13" role="form">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-info-circle"></i> 消息详情</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
		            
		            <div class="ibox-content">
	                  <input type="text" id="id" name="id" style="display:none"/>
	                  <input type="text" id="sysId" name="sysId" value="${myUser.user.extMap.sys.id}" style="display:none"/>
	                  <input type="text" id="rowValid" name="rowValid" value="1" style="display:none"/>
	                  <input type="text" id="rowVersion" name="rowVersion" style="display:none"/>
	                  <input type="text" id="readStatus" name="readStatus" style="display:none"/>
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">标题</label>
					    <div class="col-sm-10">
					      <input type="text" class="input-sm form-control validate[required]" name="msgTitle" id="msgTitle" >
					    </div>
					  </div>
					  
					  <%-- 成都消息通知不需要类型和级别 --%>
					  <c:if test="${myUser.user.org.ext1 ne 'CD'}">
					  <div class="form-group">
					    <label class="col-sm-2 control-label">类型</label>
					    <div class="col-sm-4">
					      <s:dict dictType="msgType" clazz="input-sm form-control"/>
					    </div>
					    <label class="col-sm-2 control-label">级别</label>
					    <div class="col-sm-4">
					      <s:dict dictType="msgLevel" clazz="input-sm form-control"></s:dict>
					    </div>
					  </div>
					  </c:if>

					  <div class="form-group">
					    <label  class="col-sm-2 control-label">内容</label>
					    <div class="col-sm-10">
					      <div class="editor"></div>
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label class="col-sm-12 control-label files"></label>
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