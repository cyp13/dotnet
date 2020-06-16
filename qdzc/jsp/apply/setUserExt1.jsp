<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
var table;
$(function(){
	var columnMaxLength = 50;
	table = $("#datas").dataTable({
		"language": { "url": "js/plugins/dataTables/Chinese.json"},
		"dom": 'rt<"bottom"iflp<"clear">>',
		"pagingType": "full_numbers",
		"searching": false,
		"ordering": false,
		"autoWidth": false,
		"processing": true,
		"serverSide": false,
		"pageLength": 50,
		"ajax": {
			"dataSrc": "rows",
			"type": "post",
			//"url": "gongdan/queryJiedanUsers.do?token=${token}",
			"url": "gongdan/queryJiedanUsers.do",
			"headers":{
				'token':"${token}",	
			},
			data: {
				status: $('select[name=status]').val()
			}
		},
		"aoColumnDefs": [{
			"targets": [0],
			"data": "USER_NAME",
			title: '账号'
		},{
			"targets": [1],
			"data": "USER_ALIAS",
			title: '用户名'
		},{
			"targets": [2],
			"data": "ORG_NAME",
			title: '所属机构'
			,"render": function ( data, type, full, meta ) {
				if(data && data.length>columnMaxLength){
					return data.substring(0, columnMaxLength) + '...';
				}else{
					return data;
				}
			}
		},{
			"targets": [3],
			"data": "role_names",
			title: '角色'
			,"render": function ( data, type, full, meta ) {
				if(data && data.length>columnMaxLength){
					return data.substring(0, columnMaxLength) + '...';
				}else{
					return data;
				}
			}
		},{
			"targets": [4],
			"data": "jiedan_status",
			title: '接单状态',
			"render": function ( data, type, full, meta ) {
				if(data=='0'){
					return '不接单';
				}else{
					return '接单';
				}
			}
		}, {
			"targets": [5],
			"data": "task_count",
			title: '待办任务数'
		}]
	});
});
function doLoad(){
	if(!$("#queryForm").validationEngine("validate")){
		return;
	}
	table.api().settings()[0].ajax.data = {
		status: $('select[name=status]').val()
	};
	table.api().ajax.reload();
}
function doSetStatus(keyword){
	$.ajax({
		url: 'gongdan/setStatus.do'
		, data: {
			status: 0
			,keyword: keyword
		}
		, type: 'post'
		, dataType: 'json'
		, success: function(data){
			if(data.code==0){
				layer.msg('设置成功', {icon: 1});
				doLoad();
			}else{
				layer.msg(data.msg, {icon: 2});
			}
		}
	});
}
</script>
<script>
var userAgent = navigator.userAgent; //取得浏览器的userAgent字符串
var isOpera = userAgent.indexOf("Opera") > -1; //判断是否Opera浏览器
var isIE = userAgent.indexOf("compatible") > -1 && userAgent.indexOf("MSIE") > -1 && !isOpera; //判断是否IE浏览器
var isIE11 = userAgent.indexOf("rv:11.0") > -1; //判断是否是IE11浏览器
var isEdge = userAgent.indexOf("Edge") > -1 && !isIE; //判断是否IE的Edge浏览器
$(function(){
	if(!isIE && !isEdge && !isIE11) {//兼容chrome和firefox
		var _beforeUnload_time = 0, _gap_time = 0;
		var is_fireFox = navigator.userAgent.indexOf("Firefox")>-1;//是否是火狐浏览器
		window.onunload = function (){
			_gap_time = new Date().getTime() - _beforeUnload_time;
			if(_gap_time <= 5){
				layer.msg('onunload');
			}else{//浏览器刷新
			}
	 	}
		window.onbeforeunload = function (){ 
			_beforeUnload_time = new Date().getTime();
			if(is_fireFox){//火狐关闭执行
			} 
		};
	}
});
</script>
<style type="text/css">
</style> 
</head>
<body class="gray-bg">

<div class="wrapper wrapper-content">
	<div class="row">
		<div class="col-sm-12">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5><i class="fa fa-leanpub"></i> 接单人员列表</h5>
					<div class="ibox-tools"><a class="a-reload"><i class="fa fa-repeat"></i> 刷新</a></div>
				</div>
				<div class="ibox-content">
					<form class="form-horizontal clearfix key-13" id="queryForm" enctype="multipart/form-data" method="post">
						<div class="form-group">
							<div class="col-sm-12">
								<label class="col-sm-1 control-label">接单状态</label>
								<div class="col-sm-1">
									<select class="form-control" name="status">
										<option value="">全部</option>
										<option value="1" selected="selected">接单</option>
										<option value="0">不接单</option>
									</select>
								</div>
								<div class="col-sm-10">
									<button class="btn btn-sm-1 btn-success" type="button" onclick="doLoad()">
										<i class="fa fa-search"></i> 查询
									</button>
									<button class="btn btn-sm-1 btn-success" type="button" onclick="doSetStatus('支撑')">
										<i class="fa fa-close"></i> 设置所有支撑为不接单
									</button>
									<!-- <button class="btn btn-sm-1 btn-success" type="button" onclick="doSetStatus()">
										<i class="fa fa-close"></i> 设置所有人为不接单
									</button> -->
								</div>
							</div>
						</div>
					</form>
					<table id="datas" class="table display" style="width:100%">
					</table>
				</div>
			</div>
		</div>
	</div>
</div>

</body>
</html>