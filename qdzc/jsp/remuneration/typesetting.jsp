<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<style type="text/css">
</style>
<script>
var table;
var code = '${requestScope.code}';
var status = '${requestScope.status}';
$(function(){
	var now = new Date();
	var nowyear = now.getFullYear();
	var nowmonth = now.getMonth();
	$('input[name=bname]').val('酬金模板' + nowyear + '-' + (nowmonth+1));
	if(code==='0'){
		layer.msg('上传成功！', {icon: 1});
	}else if(code==='1'){
		layer.msg('上传失败！', {icon: 0});
	}
	if(status){
		layer.msg('${requestScope.statusMsg}', {icon: 0});
	}
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
			"url": "remuneration/queryTypeList.do",
			data: {
				status: $('select[name=status]').val()
			}
		},"aoColumnDefs": [{
			"targets": [ 0 ],
			"data":"bid",
			"title":"<input type=\"checkbox\" id=\"checkAll_\" style=\"margin:0px;\">",
			"render": function (data, type, row) {
				var s = '<input type="checkbox" ';
				if('suspended' == row.state) {
					s = s + 'disabled="disabled" '; 
				} else {
					var filename = row['bname'] + (row['bversion']?' (' + row['bversion'] + ')':'');
					s = s + 'class="ids_" name="ids_" value="'+data+'" filename="'+filename+'.xlsx"'; 
				}
				return s +'style="margin:0px;"/>';
			}
		},{
			"targets": [1],
			"data": "bname",
			title: '模板名称'
			,"render": function ( data, type, full, meta ) {
				var filename = data + (full['bversion']?' (' + full['bversion'] + ')':'');
				return filename;
			}
		},{
			"targets": [2],
			"data": "names",
			title: '酬金类型'
		},{
			"targets": [3],
			"data": "user_alias",
			title: '创建人'
		},{
			"targets": [4],
			"data": "org_name",
			title: '创建机构'
		},{
			"targets": [5],
			"data": "created",
			title: '创建时间'
			,"render": function ( data, type, full, meta ) {
				return data;
			}
		},{
			"targets": [6],
			"data": "modified",
			title: '最后修改时间',
			"render": function ( data, type, full, meta ) {
				return data;
			}
		},{
			"targets": [7],
			"data": "status",
			title: '状态'
			,"render": function ( data, type, full, meta ) {
				if(data==0){
					return '有效';
				}else if(data==-1){
					return '过期';
				}else{
					return data;
				}
			}
		}],"initComplete": function( settings, json ) {
			$("#checkAll_,.checkAll_").on("click", function() {
				$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
			});
		}
	});
});
function doLoad(){
	table.api().settings()[0].ajax.data = {
		status: $('select[name=status]').val()
	};
	table.api().ajax.reload();
}
function showEditModel(){
	$("#model-edit").modal("show");
}
function doSave(){
	if(!$("#form-edit").validationEngine("validate")) {
		return;
	}
	var names = new Object();
	$('input[name=type_name]').each(function(){
		names[$(this).val()]=0;
	});
	ajax({
		url: 'remuneration/saveTypeList.do'
		,names: Object.keys(names)
		,bname: $('input[name=bname]').val()
	}, function(result) {
		if ("error" == result.code) {
			layer.msg(result.resMsg, {icon: 2});
		} else {
			layer.msg("数据处理成功！", {icon: 1});
			$("#model-edit").modal("hide");
			table.api().ajax.reload();
		}
	});
}
function doDelete(){
	var bids = new Array();
	$(".ids_:checkbox:checked").each(function(){
		bids.push($(this).val());
	});
	if(bids.length<=0){
		return;
	}
	ajax({
		url: 'remuneration/queryDataCount.do'
		,bids: bids
	}, function(result) {
		if ("error" == result.code) {
			layer.msg(result.resMsg, {icon: 2});
		} else {
			var count = result.count;
			var msg = '确认删除'+bids.length+'个配置？';
			if(count>0){
				msg = '选中的配置已经导入过酬金数据'+count+'条，删除配置将同时删除酬金数据，是否确认？'
			}
			layer.confirm(msg, {
				btn: ['确认','取消'] //按钮
			}, function(){
				ajax({
					url: 'remuneration/deleteTypeSetting.do'
					,bids: bids
				}, function(result) {
					if ("error" == result.code) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg('删除成功', {icon: 1});
						$("#model-edit").modal("hide");
						table.api().ajax.reload();
					}
				});
			}, function(){
				$("#model-edit").modal("hide");
				table.api().ajax.reload();
			});
		}
	});
}
function doUpLoad(){
	layer.confirm('是否确认上传酬金数据？', {
		btn: ['确认','取消'] //按钮
	}, function(){
		if(!$("#queryForm").validationEngine("validate")){
			return;
		}
		$('#queryForm').attr('action', 'remuneration/uploadTemplate.do');
		$('#queryForm').submit();
		loading = layer.load(1, {
			//shade: [0.1,'#fff'] //0.1透明度的白色背景
		});
	},function(){
		
	});
}
function doDownLoad(){
	$('.append_filename').remove();
	$(".ids_:checkbox:checked").each(function(){
		$('#queryForm').append('<input type="hidden" class="append_filename" name="fileName" value="' + $(this).attr('filename') + '">');
		return false;
	});
	if($('.append_filename').length<=0){
		layer.msg('请选择模板进行下载！',{icon: 0});
		return;
	}
	$('#queryForm').attr('action', 'remuneration/downloadTemplate.do');
	$('#queryForm').submit();
}
function $addInput(dom){
	var appendGroup = $(dom).parents(".append_group").clone();
	var appendDiv = $(dom).parents(".append_div");
	var groups = $(dom).parents(".append_div").children('.append_group');
	if(groups.size()<20){
		appendDiv.append(appendGroup);
	}else{
		layer.msg('最多可设置20个类别');
	}
}
function $removeInput(dom){
	var groups = $(dom).parents(".append_div").children('.append_group');
	if(groups.size()>1){
		$(dom).parents(".append_group").remove();
	}
}
</script>
</head>
<body class="gray-bg">

<div class="wrapper wrapper-content">
	<div class="row">
		<div class="col-sm-12">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5><i class="fa fa-leanpub"></i> 酬金模板列表</h5>
					<div class="ibox-tools"><a class="a-reload"><i class="fa fa-repeat"></i> 刷新</a></div>
				</div>
				<div class="ibox-content">
					<form class="form-horizontal clearfix key-13" id="queryForm" action="remuneration/downloadTemplate.do" enctype="multipart/form-data" method="post">
						<div class="form-group">
							<div class="col-sm-12">
								<label class="control-label col-sm-1">状态</label>
								<div class="col-sm-1">
									<select class="form-control" name="status">
										<option value="">全部</option>
										<option value="0" selected="selected">有效</option>
										<option value="-1">已过期</option>
									</select>
								</div>
								<div class="col-sm-5">
									<button class="btn btn-sm-1 btn-success" type="button" onclick="doLoad()">
										<i class="fa fa-search"></i> 查询
									</button>
									<button class="btn btn-sm-1 btn-success" type="button" onclick="showEditModel()">
										<i class="fa fa-edit"></i> 设置酬金类别
									</button>
									<button class="btn btn-sm-1 btn-success" type="button" onclick="doDelete()">
										<i class="fa fa-close"></i> 删除
									</button>
								</div>
								<div class="col-sm-5">
									<div class="col-sm-7">
										<input type="file" name="uploadFile" id="uploadFile" class="col-sm-5" class="validate[required]"/>
									</div>
									<div class="col-sm-5">
										<button class="btn btn-sm-1 btn-success" type="button" onclick="doUpLoad()">
											<i class="fa fa-upload"></i> 上传
										</button>
												<button class="btn btn-sm-1 btn-success" type="button" onclick="doDownLoad()">
											<i class="fa fa-download"></i> 下载模板
										</button>
									</div>
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

<div class="modal fade" id="model-edit" tabindex="-1" role="dialog">
	<div class="modal-dialog" style="width:25%; margin-top: 100px;">
	<div class="modal-content ibox">
	<form id="form-edit" class="form-horizontal key-13" role="form">
		<div class="ibox-title">
			<h5><i class="fa fa-pencil-square-o"></i> 设置酬金类别</h5>
			<div class="ibox-tools">
				<a class="close-link" data-dismiss="modal">
				<i class="fa fa-times"></i>
				</a>
			</div>
		</div>
		<div class="ibox-content">
			<div class="form-group">
				<label class="col-sm-2 control-label">模板名称</label>
				<div class="col-sm-10">
					
					<div class="input-group" style="margin-bottom: 5px;">
						<input type="text" class="input-sm form-control validate[required]" name="bname" maxlength="18" placeholder="请填写模板名称">
						<span class="input-group-btn" style="visibility: hidden;">
							<a onclick="$addInput(this)" class="btn btn-sm btn_success"><i class="fa fa-plus"></i></a>
						</span>
						<span class="input-group-btn" style="visibility: hidden;">
							<a onclick="$removeInput(this)" class="btn btn-sm btn_success"><i class="fa fa-minus"></i></a>
						</span>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label">类别</label>
				<div class="col-sm-10 append_div">
					<div class="input-group append_group" style="margin-bottom: 5px;">
						<input type="text" class="input-sm form-control validate[required]" name="type_name" maxlength="18" placeholder="请填写类型名称">
						<span class="input-group-btn">
							<a onclick="$addInput(this)" class="btn btn-sm btn_success"><i class="fa fa-plus"></i></a>
						</span>
						<span class="input-group-btn">
							<a onclick="$removeInput(this)" class="btn btn-sm btn_success"><i class="fa fa-minus"></i></a>
						</span>
					</div>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-2 control-label"></label>
				<div class="col-sm-10">
					<button type="button" class="btn btn-sm btn-success btn-13" onclick="doSave()">
						<i class="fa fa-check"></i> 保存
					</button>
				</div>
			</div>
		</div>
	</form>
	</div>
	</div>
</div>

</body>
</html>