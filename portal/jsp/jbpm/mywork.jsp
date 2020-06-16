<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
	$(window).resize(function() {
		$(".panel-body").height($(window).height()-136);
	});
	
	var ext1 = "${myUser.user.ext1}";
	$(window).ready(function() {
		$(".panel-body").height($(window).height()-136);
		
		$("li a").on("click", function() {
			var fid = $(this).attr("f");
			$("#"+fid).attr("src", $("#"+fid).attr("to"));
       	});
		
		$("#iframe1").attr("src", $("#iframe1").attr("to"));
		
		$(".setting").hide();
		if(ext1 == "0") {
			$(".check").hide();
			$(".remove").show();
		} else {
			$(".check").show();
			$(".remove").hide();
		}
		
		$("#btn-update").on("click", function() {
			var obj = new Object();
			obj.url = "${ctx}/api/sys/updateUserExt1.do";
			obj.userId = "${myUser.user.id}";
			if(ext1 == "0") {
				obj.ext1 = "1";
			} else {
				obj.ext1 = "0";
			}
			obj.async = false;
			ajax(obj, function(result) {
				if ("error" == result.resCode) {
					layer.msg(result.resMsg, {icon: 2});
				} else {
					layer.msg(result.resMsg, {icon: 1});
					ext1 = obj.ext1;
					if(ext1 == "0") {
						$(".check").hide();
						$(".remove").show();
					} else {
						$(".check").show();
						$(".remove").hide();
					}
				}
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
	                    <h5><i class="fa fa-cogs"></i> 我的工单</h5>
                    	<div class="ibox-tools">
	                       <a id="btn-update">
	                       	  <span class="setting check" style="color:#008B00"><i class="fa fa-check"></i> 接单</span>
	                       	  <span class="setting remove" style="color:#FF0000"><i class="fa fa-remove"></i> 不接单</span>
	                       </a>
	                       <a class="a-reload">
	                          <i class="fa fa-repeat"></i> 刷新
	                       </a>
	                    </div>
	                </div>
	                
	                <div class="ibox-content">
		                <div class="tabs-container">
		                    <ul class="nav nav-tabs">
		                        <li class="active">
		                        	<a data-toggle="tab" href="#tab-1" f="iframe1" aria-expanded="false">待办工单</a>
		                        </li>
		                        <li>
		                        	<a data-toggle="tab" href="#tab-2" f="iframe2" aria-expanded="false">已办工单</a>
		                        </li>
		                        <li>
		                        	<a data-toggle="tab" href="#tab-3" f="iframe3" aria-expanded="false">已归档工单</a>
		                        </li>
		                        <li>
		                        	<a data-toggle="tab" href="#tab-4" f="iframe4" aria-expanded="false">常用语管理</a>
		                        </li>
		                        <!-- <li>
		                        	<a data-toggle="tab" href="#tab-5" f="iframe5" aria-expanded="false">接单管理</a>
		                        </li> -->
		                    </ul>
		                    <div class="tab-content">
		                        <div id="tab-1" class="tab-pane active">
		                            <div class="panel-body" style="padding:0px !important;">
		                            	<iframe id="iframe1" style="width:100%; height:100%; display:block; border:0px;" to="${ctx}/api/jbpm/taskList.do?page=mywork"></iframe>
		                            </div>
		                        </div>
		                        <div id="tab-2" class="tab-pane">
		                        	<div class="panel-body" style="padding:0px !important;">
		                            	<iframe id="iframe2" style="width:100%; height:100%; display:block; border:0px;" to="${ctx}/api/jbpm/piList.do?page=mywork"></iframe>
		                            </div>
		                        </div>
		                        <div id="tab-3" class="tab-pane">
		                            <div class="panel-body" style="padding:0px !important;">
		                            	<iframe id="iframe3" style="width:100%; height:100%; display:block; border:0px;" to="${ctx}/api/jbpm/piList.do?taskState=ended&page=mywork"></iframe>
		                            </div>
		                        </div>
		                        <div id="tab-4" class="tab-pane">
		                            <div class="panel-body" style="padding:0px !important;">
		                            	<iframe id="iframe4" style="width:100%; height:100%; display:block; border:0px;" to="${s:getDict('host','biz')}/jsp/workList/phraseList.jsp?token=${myUser.user.extMap.token}"></iframe>
		                            </div>
		                        </div>
		                        <%-- <div id="tab-5" class="tab-pane">
		                            <div class="panel-body" style="padding:0px !important;">
		                            	<iframe id="iframe5" style="width:100%; height:100%; display:block; border:0px;" to="${s:getDict('host','biz')}/jsp/sys/adoptList.jsp?token=${myUser.user.extMap.token}"></iframe>
		                            </div>
		                        </div> --%>
		                    </div>
		                </div>
		        	</div>
	        	</div>
            </div>
        </div>
    </div>
</body>
</html>