<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<link href="${ctx}/js/plugins/font-awesome/css/jquery.fonticonpicker.min.css" rel="stylesheet">
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script src="${ctx}/js/plugins/font-awesome/js/jquery.fonticonpicker.min.js"></script>
<script src="${ctx}/js/plugins/font-awesome/icon.js"></script>
<script>
	var queryPageUrl = "${ctx}/jsp/sys/queryPage.do";
	var updatePageUrl = "${ctx}/jsp/sys/updatePage.do";
	var deletePageUrl = "${ctx}/jsp/sys/deletePage.do";

	$(window).ready(function() {
		$("#rowIcon").fontIconPicker({
			source: fa_icons,
			searchSource: fa_icons,
			//useAttribute: true,  
            //theme: "fip-bootstrap",  
            //attributeName: "data-icomoon",
            emptyIconValue: "none"
        });
		
		$(".a-update").on("click", function() {
			var id = $(this).attr("page-id");
			if(id) {
				$("#editForm").attr("action", updatePageUrl);
				$("#myModal").modal("show");
				
				$(".rowValid").attr("disabled",true);
				$("#rowIcon_").html("");
				
				var obj = new Object();
				obj.url = queryPageUrl;
				obj.pageType = "1";
				obj.id = id;
				ajax(obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						$("#editForm").fill(result.datas[0]);
						$("#rowIcon_").html(result.datas[0].rowIcon);
					}
				});
			}
			
			$("#btn-ok").on("click", function() {
				var b = $("#editForm").validationEngine("validate");
				if(b) {
					ajaxSubmit("#editForm", function(result) {
						if ("error" == result.resCode) {
							layer.msg(result.resMsg, {icon: 2});
						} else {
							layer.msg("数据处理成功！", {icon: 1});
							location.reload();
						}
					});
				}
			});
       	});

		$(".close-link").on("click", function() {
			var id = $(this).attr("page-id");
			if(id) {
				layer.confirm('您确定要删除数据吗？', {icon: 3}, function() { 
					var obj = new Object();
					obj.url = deletePageUrl;
					obj.id = id;
					ajax(obj, function(result) {
						if ("error" == result.resCode) {
							layer.msg(result.resMsg, {icon: 2});
						} else {
							layer.msg("数据处理成功！", {icon: 1});
							location.reload();
						}
					});
				});
			}
       	});

		$(".a-reload-this").on("click", function() {
			var id = $(this).attr("page-id");
			if(id) {
				$("#"+id).attr("src", $("#"+id).attr("src"));
			}
       	});

		$(".a-forward").on("click", function() {
			var title = $(this).attr("page-title");
			var menuId = $(this).attr("page-menuId");
			if(title && menuId) {
				try {
					parent.menuItem(title, menuId);
				} catch (e) {
					window.open(menuId, "_blank");
				}
			}
       	});
	});
</script>
<style type="text/css">
.wrapper {
    padding: 0px;
    padding-right: 5px;
}
.wrapper [class*="col-sm-"] {
    padding: 0px;
    padding-top: 5px;
    padding-left: 5px;
}
.wrapper .ibox {
    margin: 0px;
}
.wrapper .ibox-content {
	padding: 0px;
}
.wrapper .ibox-title {
	height: 40px;
	min-height: 40px;
	padding: 10px 15px 0;
}
.wrapper .ibox-title h5 {
	margin: 0;
}
</style>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
       	<c:forEach items="${page.datas}" var="module">
       		<div class="col-sm-${module.rowWidth}">
                <div class="ibox">
                	<c:if test="${'-1' ne param.toolbar_}">
	   					<div class="ibox-title">
		                    <h5>${module.rowIcon} ${module.rowTitle}</h5>
	                    	<div class="ibox-tools">
	                    		<c:if test="${'0' ne param.toolbar_}">
			                        <a class="a-update" title="设置" page-id="${module.id}">
			                            <i class="fa fa-wrench"></i>
			                        </a>
			                        <a class="a-reload-this" title="刷新" page-id="${module.id}">
			                            <i class="fa fa-repeat"></i>
			                        </a>
			                        <a class="a-forward" title="跳转" page-title="${module.rowTitle}" page-menuId="${module.menuId}">
			                            <i class="fa fa-mail-forward"></i>
			                        </a>
			                        <a class="close-link" title="删除" page-id="${module.id}">
			                            <i class="fa fa-times"></i>
			                        </a>
		                        </c:if>
		                    </div>
		                </div>
	                </c:if>
	                
                    <div class="ibox-content" style="height:${module.rowHeight}px;">
                        <iframe id="${module.id}" src="${module.menuId}" style="width:100%; height:100%; display:block; border:0px;"></iframe>
                    </div>
                </div>
            </div>
       	</c:forEach>
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
	                  <input type="text" name="pageType" value="1" style="display:none"/>
	                  <input type="text" name="extId" style="display:none"/>
	                  <input type="text" name="rowValid" value="1" style="display:none"/>
	                  <input type="text" name="rowVersion" style="display:none"/>
	                  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">标题</label>
					    <div class="col-sm-4">
					      <input type="text" class="input-sm form-control validate[required]" name="rowTitle" id="rowTitle" maxlength="16">
					    </div>
					    <label class="col-sm-2 control-label"><span id="rowIcon_"></span> 图标</label>
					    <div class="col-sm-2">
					      <input type="text" name="rowIcon" id="rowIcon">
					    </div>
					  </div>
					  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">宽度</label>
					    <div class="col-sm-4">
					      <input type="number" class="input-sm form-control validate[required,custom[integer]]" name="rowWidth" id="rowWidth" title="参考值：1-12" placeholder="参考值：1-12">
					    </div>
					    <label class="col-sm-2 control-label">高度</label>
					    <div class="col-sm-4">
					      <input type="number" class="input-sm form-control validate[required,custom[integer]]" name="rowHeight" id="rowHeight" title="参考单位：px" placeholder="参考单位：px">
					    </div>
					  </div>

					  <div class="form-group">
					    <label  class="col-sm-2 control-label">URL</label>
					    <div class="col-sm-10">
					      <input type="text" class="input-sm form-control validate[custom[tszf]]" name="menuId" id="menuId" >
					    </div>
					  </div>
					  
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">排序号</label>
					    <div class="col-sm-4">
					      <input type="number" class="input-sm form-control validate[required,custom[integer]]" name="sortNo" id="sortNo" >
					    </div>
					    <label class="col-sm-2 control-label">状态</label>
					    <div class="col-sm-4">
					      <label><input type="radio" name="rowValid" class="rowValid" value="1" checked="checked">有效</label>
					      <label><input type="radio" name="rowValid" class="rowValid" value="0">禁用</label>
					    </div>
					  </div>
					  
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
	
	<c:if test="${'0' ne param.toolbar_ and '-1' ne param.toolbar_}">
		<div class="gohome">
			<a class="animated bounceInUp" href="?toolbar_=0" target="_blank" title="最大化">
				<i class="fa fa-window-restore"></i>
			</a>
		</div>
	</c:if>
</body>
</html>