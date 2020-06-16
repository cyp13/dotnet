<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
	var tokenUrl = "${ctx}/jsp/sys/token.do";
	var validTokenUrl = "${ctx}/api/validToken.do";

	$(window).ready(function() {
		document.oncontextmenu = function() {
			return true;
		}
		
		$("#btn-ok").on("click", function() {
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				$("#editForm").attr("action", tokenUrl);
				ajaxSubmit("#editForm", function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						$("#token").val(result.datas.token);
					}
				});
			}
		});
		
		$("#btn-valid").on("click", function() {
			var token = $("#token").val();
			if(!token) {
				layer.msg("token不能为空",{offset:"b"});
				return false;
			}
			$("#editForm").attr("action", validTokenUrl);
			ajaxSubmit("#editForm", function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					layer.msg(result.resMsg, {icon: 1});
				}
			});
		});
		
		var clipboard = new Clipboard('#token', {
		    text: function(o) {
		    	if($(o).val()) {
			    	layer.msg("复制成功");
			    	return $(o).val();
		    	}
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
                   	<form id="editForm" class="form-horizontal key-13" role="form">
	                	<div class="ibox-title">
		                    <h5><i class="fa fa-ticket"></i> Token管理</h5>
		                    <div class="ibox-tools">
		                       <a class="btn-13" id="btn-ok" style="color:#4974A4">
		                          <i class="fa fa-save"></i> 生成
		                       </a>
		                       <a class="btn-13" id="btn-valid" style="color:#4974A4">
		                          <i class="fa fa-ticket"></i> 验证
		                       </a>
		                       <a class="a-reload">
		                          <i class="fa fa-repeat"></i> 刷新
		                       </a>
		                    </div>
		                </div>

			            <div class="ibox-content">
						  <div class="form-group">
						    <label class="col-sm-2 control-label">IP</label>
						    <div class="col-sm-4">
						      <input type="text" class="input-sm form-control validate[required,custom[ip]]" name="ip" id="ip">
						    </div>
						    <label class="col-sm-2 control-label">有效期（分钟）</label>
						    <div class="col-sm-4">
						      <input type="number" class="input-sm form-control validate[required,custom[integer],maxSize[9]]" name="exp" id="exp">
						    </div>
						  </div>
	
						  <div class="form-group">
						    <label  class="col-sm-2 control-label">token</label>
						    <div class="col-sm-10">
						      <textarea class="form-control" name="token" id="token"></textarea>
						    </div>
						  </div>
			            </div>
					</form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>