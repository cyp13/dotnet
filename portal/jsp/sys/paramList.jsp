<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
    var insertUrl = "${ctx}/jsp/sys/insertParam.do";
	var updateUrl = "${ctx}/jsp/sys/updateParam.do";
	var deleteUrl = "${ctx}/jsp/sys/deleteParam.do";
	var queryUrl = "${ctx}/jsp/sys/queryParam.do";

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
				"data":"ename",
				"render": function (data, type, row) {
					return '<span class="a-copy" title="点击复制" v="'+data+'">'+data+'</span>';
				}
			}, {
				"targets": [ 2 ],
				"data":"cname"
			}, {
				"targets": [ 3 ],
				"data":"dvalue"
			}, {
				"targets": [ 4 ],
				"data":"controlType",
				"render": function (data, type, row) {
					if("1" == data) {
						return '文本框';	
					} else if("2" == data) {
						return '下拉框';	
					} else if("3" == data) {
						return '隐藏框';	
					} else if("4" == data) {
						return '日期控件';	
					} else if("5" == data) {
						return '机构控件';	
					} else if("6" == data) {
						return '字典控件';	
					}
					return data;
				}
			}, {
				"targets": [ 5 ],
				"data":"sortNo"
			}, {
				"targets": [ 6 ],
				"data":"modified",
				"render": function (data, type, row) {
					return '<span title="'+row.modifier+'">'+data+'</span>';
				}
			}, {
				"targets": [ 7 ],
				"data":"extMap.rowValid",
				"render": function (data, type, row) {
					if("0" == row.rowValid) {
						return '<span style="color:#FF0000">'+data+'<span/>';	
					}
					return data;
				}
			}, {
				"targets": [ 8 ],
				"data":"remark",
				"render": function (data, type, row) {
					return data ? data : "";
				}
			}]
		});
        
		$("#btn-query").on("click", function() {
			var b = $("#queryForm").validationEngine("validate");
			if(b) {
				var param = {
					"keywords": $("#keywords").val()
				};
				table.api().settings()[0].ajax.data = param;
				table.api().ajax.reload();
			}
       	});
		
		$("#btn-insert").on("click", function() {
			$("#editForm")[0].reset();
			$("#editForm").attr("action", insertUrl);
			$("#myModal").modal("show");
			
			$("#sortNo").val("1");
			$("#valueType").change();
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

			var obj = new Object();
			obj.url = queryUrl;
			obj.id = $(".ids_:checkbox:checked").val();
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					$("#editForm").fill(result.datas[0]);
					$("#valueType").change();
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

		$("#valueType").on("change", function() {
			if("2" == $(this).val()) {
				$("#dsId").attr("disabled",false);
				$("#pvalue").addClass("validate[required]");
				$("#pvalue").attr("placeholder","例：select id,text from table");
				$(".ds").show();
			} else {
				$("#dsId").attr("disabled",true); 
				$("#pvalue").removeClass("validate[required]");
				$("#pvalue").attr("placeholder","下拉框格式：id:text;id:text; 日期控件格式：yyyy,yyyyMM,yyyyMMdd,yyyy-MM");
				$(".ds").hide();
			}
		});
		
		var clipboard = new Clipboard('.a-copy', {
		    text: function(o) {
		    	layer.msg("复制成功");
		    	return $(o).attr("v");
		    }
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
	                    <h5><i class="fa fa fa-question-circle-o"></i> 参数列表</h5>
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
									<th>参数名称</th>
									<th>参数别名</th>
									<th>默认值</th>
									<th>控件类型</th>
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
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">参数名称</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required,custom[onlyLetterNumber]]" name="ename" id="ename" maxlength="16">
					    </div>
					    <label class="col-sm-2 control-label">参数别名</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="cname" id="cname" maxlength="16">
					    </div>
					  </div>

					  <div class="form-group">
					  	<label class="col-sm-2 control-label">控件类型</label>
					    <div class="col-sm-4">
					      <select id="controlType" name="controlType" class="input-sm form-control validate[required]">
							<option value="1">文本框</option>
							<option value="2">下拉框</option>
							<option value="3">隐藏框</option>
							<option value="4">日期控件</option>
							<option value="5">机构控件</option>
							<option value="6">字典控件</option>
						  </select>
					    </div>
					    <label class="col-sm-2 control-label">默认值</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control" name="dvalue" id="dvalue" maxlength="32">
					    </div>
					  </div>

					  <div class="form-group">
					    <label class="col-sm-2 control-label">取值方式</label>
					    <div class="col-sm-4">
					      <select id="valueType" name="valueType" class="input-sm form-control validate[required]">
							<option value="1">自定义</option>
							<option value="2">SQL（仅下拉框有效）</option>
						  </select>
					    </div>
					    <label  class="col-sm-2 control-label">必输（选）项</label>
					    <div class="col-sm-4">
					      <label><input type="radio" name="validFlag" value="1">是</label>
						  <label><input type="radio" name="validFlag" value="0" checked="checked">否</label>
					    </div>
					  </div>

					  <div class="form-group ds">
					    <label  class="col-sm-2 control-label">数据源</label>
					    <div class="col-sm-4">
					      <s:ds name="dsId" dsType="1" clazz="input-sm form-control validate[required]"></s:ds>
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">参数值</label>
					    <div class="col-sm-10">
					      <input type="text" class="input-sm form-control" name="pvalue" id="pvalue" >
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">排序号</label>
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
</body>
</html>