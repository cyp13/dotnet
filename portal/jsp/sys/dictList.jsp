<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<style type="text/css">
#treeDiv::-webkit-scrollbar-track {
    background-color: #fff;
}
</style>
<script>
	var queryUrl = "${ctx}/jsp/sys/queryDict.do";
	var insertUrl = "${ctx}/jsp/sys/insertDict.do";
	var updateUrl = "${ctx}/jsp/sys/updateDict.do";
	var deleteUrl = "${ctx}/jsp/sys/deleteDict.do";

	var dictTree = null, parentNode = null; var table = null;
	var setting = {
		async: {
			enable: true,
			dataType: "json",
			url: queryUrl,
			autoParam : [ "id" ],
			otherParam : {"flag_" : "tree"},
			dataFilter: function(treeId, parentNode, result) {
				if("error" != result.resCode) {
					return result;
				}
			}
		},
		view : {
			dblClickExpand : false
		},
		data: {
			key: { name: "dictName", title: "dictType"}
		},
		callback : {
			beforeClick : function(treeId, treeNode) {
				parentNode = treeNode;
				$("#btn-query").click();
			},
			onAsyncSuccess: function() {
				if(dictTree) {
					var root = dictTree.getNodeByTId("dictTree_1");
					if(root && !root.open) {
					//	setTimeout(function() {
							dictTree.expandNode(root, true);
					//	}, 100);
					}
				}
			}
		}
	};
	
	$(window).resize(function() {
		$("#treeDiv").css("height",document.body.clientHeight-64);
	});
	
	$(window).ready(function() {
		$("#treeDiv").css("height",$(window).height()-64);
		dictTree = $.fn.zTree.init($("#dictTree"), setting);
         
		table = $("#datas").dataTable({
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
					s += 'title="'+row.creater+'" '; 
					if("1" == row.rowDefault) {
						s = s + 'disabled="disabled" '; 
					} else {
                     //	if("1" != "${myUser.user.extMap.sys.rowDefault}" && row.creater != "${myUser.user.userName}") {
                     //		s = s + 'disabled="disabled" '; 
                     //	} else {
					 //		s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
                     //	}
						s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
					}
					return s +'style="margin:0px;"/>';
				}
			}, {
				"targets": [ 1 ],
				"data":"dictType",
				"render": function (data, type, row) {
					return '<span class="a-copy" title="点击复制" v="'+data+'">'+data+'</span>';
				}
			}, {
				"targets": [ 2 ],
				"data":"dictName",
				"render": function (data, type, row) {
					return '<span class="a-copy" title="点击复制" v="'+data+'">'+data+'</span>';
				}
			}, {
				"targets": [ 3 ],
				"data":"dictValue",
				"render": function (data, type, row) {
					return '<div class="a-copy" style="width:100px;white-space:nowrap;overflow:hidden;text-overflow:ellipsis;" title="'+data+'" v="'+data+'">'+data+'</div>';
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
						return '<span style="color:#FF0000">'+data+'</span>';
					}
					return data;
				}
			}, {
				"targets": [ 7 ],
				"render": function (data, type, row) {
					var str = "";
					if("-1" == row.parentId) {
						str += '<s>上级</s> ';
					} else {
						str += '<a onclick="goin(\''+encodeURI(row.parentId)+'\',\'-1\');" title="'+row.parentId+'-'+row.parentName+'">上级</a> ';
					}
					if(row.childs == 0) {
						str += '<s>下级</s>';
					} else {
						str += '<a onclick="goin(\''+encodeURI(row.id)+'\',\'1\');">下级</a>';
					}
					return str;
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
			$("#editForm").attr("action", insertUrl);
			$("#parentId").val("${s:getSysConstant('NUM_ROOT')}");
			$("#parentName").val("${s:getSysConstant('NUM_ROOT')}");
			if(parentNode) {
				$("#parentId").val(parentNode.id);
				$("#parentName").val(parentNode.dictName);
			}
			$("#myModal").modal("show");
			$("#sortNo").val(getChlids(parentNode));
			$("#dictValue").val(getChlids(parentNode));
			$("#dictType").removeAttr("readonly");
       	});

		$("#btn-update").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size != 1) {
				layer.msg("请选择需要修改的一行数据！", {icon: 0});
				return;
			}

			$("#editForm").attr("action", updateUrl);
			$("#myModal").modal("show");
			$("#dictType").attr("readonly","readonly");

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
						var nodes = dictTree.getSelectedNodes();
						if(nodes && "" != nodes){
							nodes[0].isParent = true;
							dictTree.reAsyncChildNodes(nodes[0], "refresh");
						} else if(dictTree) {
							dictTree.reAsyncChildNodes(null, "refresh");
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
						var nodes = dictTree.getSelectedNodes();
						if(nodes && "" != nodes){
							nodes[0].isParent = true;
							dictTree.reAsyncChildNodes(nodes[0], "refresh");
						} else if(dictTree) {
							dictTree.reAsyncChildNodes(null, "refresh");
						}
					}
				});
			}
		});
		
		var clipboard = new Clipboard('.a-copy', {
		    text: function(o) {
		    	layer.msg("复制成功");
		    	return $(o).attr("v");
		    }
		});
	});
	
	function goin(id,flag) {
		var param = {};
		if('-1' == flag) {
			param.id = id;
		} else {
			param.parentId = id;
		}
		table.api().settings()[0].ajax.data = param;
		table.api().ajax.reload();
	}
	
	function getChlids(treeNode) {
	    var count = 1;
	    if(treeNode && treeNode.isParent) {
	    	try {
	    		count = treeNode.children.length + 1 ;
	    	} catch(e) {
	    		return treeNode.childs + 1;
	    	}
	    }
	    return count;
	}
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-3" style="padding-right: 0;">
                <div class="ibox float-e-margins">
                	<div class="ibox-title">
	                    <h5><i class="fa fa-book"></i> 上级字典</h5>
	                </div>
                    <div class="ibox-content" id="treeDiv" style="overflow: auto; padding:10px;">
						<ul id="dictTree" class="ztree"></ul>
                    </div>
                </div>
            </div>

			<div class="col-sm-9" style="padding-left: 10px;">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-list-alt"></i> 字典列表</h5>
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
									<th>字典代码</th>
									<th>字典名称</th>
									<th>字典值</th>
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
	                  <input type="text" id="sysId" name="sysId" value="${myUser.user.extMap.sys.id}" style="display:none"/>
	                  <input type="text" id="rowVersion" name="rowVersion" style="display:none"/>
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">字典代码</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="dictType" id="dictType" maxlength="16">
					    </div>
					  	<label class="col-sm-2 control-label">字典名称</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="dictName" id="dictName" maxlength="32">
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">字典值</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="dictValue" id="dictValue" >
					    </div>
					    <label class="col-sm-2 control-label">上级字典</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" id="parentName" name="parentName" readonly="readonly" >
					      <input type="text" class="validate[required]" id="parentId" name="parentId" style="display:none"/>
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
</body>
</html>