<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<style type="text/css">
.btnm{
	margin-top: 5px;
}
</style>
<script>
var table;
var columns, columnsOrginal = [{
	"targets": [ 0 ],
	"data":"bid",
	"title":"<input type=\"checkbox\" id=\"checkAll_\" style=\"margin:0px;\">",
	"render": function (data, type, row) {
		var s = '<input type="checkbox" ';
		if('suspended' == row.state) {
			s = s + 'disabled="disabled" '; 
		} else {
			s = s + 'class="ids_" name="ids_" value=\''+JSON.stringify(row)+'\' '; 
		}
		return s +'style="margin:0px;"/>';
	}
},{
	"targets": [1],
	"data": "channel",
	title: '渠道编码'
},{
	"targets": [2],
	"data": "channel_name",
	title: '渠道名称'
},{
	"targets": [3],
	"data": "year_month_",
	title: '酬金年月'
}];
$(function(){
	//1.生成月份，支持最近半年
	var now = new Date();
	var nowyear = now.getFullYear();
	var nowmonth = now.getMonth();
	var yearmonth;
	for(var i=0; i<12; i++, nowmonth--){
		if(nowmonth<0){
			nowmonth = 11;
			nowyear -= 1;
		}
		yearmonth = nowyear + '-' + (nowmonth<9?('0'+(nowmonth+1)):(nowmonth+1));
		$('select[name=yearmonth]').append('<option value="'+yearmonth+'">'+yearmonth+'</option>');
	}
	//2.初始化表格
	table = initTable(columnsOrginal);
	//3.生成模板
	var columnsMap = new Object();
	$.ajax({
		url: 'remuneration/queryTypeList.do'
		,dataType: 'json'
		,success:function(data){
			var rows = data.rows;
			for(var i in rows){
				var row = rows[i];
				var filename = row['bname'] + (row['bversion']?' (' + row['bversion'] + ')':'');
				$('select[name=bname]').append('<option names="'+row['names']+'" value="'+row['bid']+'">'+filename+'</option>');
			}
			$('select[name=bname]').change(function(){
				var names = $(this).find('option:selected').attr('names');
				names = names.split(',');
				columns = new Array();
				for(var index in columnsOrginal){
					columns.push(columnsOrginal[index]);
				}
				for(var index in names){
					columns.push({
						"targets": [index - (-columnsOrginal.length)],
						"data": names[index],
						title: names[index]
					});
				}
				/* columns.push({
					targets: columns.length
					,data:'countMoney'
					,title:'合计'
				}); */
				table.api().clear();
				table.api().destroy();
				$("#datas").empty();// 列改变了，需要清空table
				table = initTable(columns);
			});
			$('select[name=bname]').change();
		}
	});
});
function initTable(columns){
	return $("#datas").dataTable({
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
			"url": "remuneration/queryRemunerationValueList.do",
			data: {
				bid: $('select[name=bname]').val()
				,yearMonth: $('select[name=yearmonth]').val()
				,channel: $('input[name=channel]').val()
			}
		}
		,"aoColumnDefs": columns
		,"initComplete": function( settings, json ) {
			$("#checkAll_,.checkAll_").on("click", function() {
				$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
			});
		}
	});
}
function doLoad(){
	table.api().settings()[0].ajax.data = {
		bid: $('select[name=bname]').val()
		,yearMonth: $('select[name=yearmonth]').val()
		,channel: $('input[name=channel]').val()
	};
	table.api().ajax.reload();
}
var editRow;
function showEditModel(){
	editRow = null;
	$(".ids_:checkbox:checked").each(function(){
		editRow = JSON.parse($(this).val());
		return false;
	});
	if(editRow == null || editRow.length<=0){
		return;
	}
	$("#model-edit").find('input[name=channel]').val(editRow['channel']);
	$("#model-edit").find('input[name=channel_name]').val(editRow['channel_name']);
	$("#model-edit").find('input[name=year_month_]').val(editRow['year_month_']);
	$('.append-form-group').remove();
	for(var key in editRow){
		var found = false;
		for(var keyOrginal in columnsOrginal){
			if(key==columnsOrginal[keyOrginal]['data'] || key=='countMoney'){
				found = true;
				break;
			}
		}
		if(found){
			continue;
		}
		$('#append-form-group').append($('<div class="form-group append-form-group">'
			+'<label class="col-sm-3 control-label">'+key+'</label>'
			+'<div class="col-sm-8">'
			+'<input type="number" class="input-sm form-control validate[required]" name="remuneration_'+key+'" value="'+editRow[key]+'" maxlength="36" placeholder="请填写'+key+'" />'
			+'</div>'
			+'</div>'));
	}
	$("#model-edit").modal("show");
}
function doSave(){
	if(!$("#form-edit").validationEngine("validate")) {
		return;
	}
	var ajaxData = {
		url: 'remuneration/updateRemuneration.do'
		,channel: $('#form-edit').find('input[name=channel]').val()
		,year_month_: $('#form-edit').find('input[name=year_month_]').val()
		,channel_name: $('#form-edit').find('input[name=channel_name]').val()
	}
	$('#form-edit').find('input[name^=remuneration_]').each(function(){
		ajaxData[$(this).attr('name')] = $(this).val()
	});
	ajax(ajaxData, function(result) {
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
	var channels = new Array();
	var year_month_s = new Array();
	$(".ids_:checkbox:checked").each(function(){
		var row = JSON.parse($(this).val());
		channels.push(row['channel']);
		year_month_s.push(row['year_month_']);
	});
	if(channels.length<=0){
		return;
	}
	layer.confirm('确认删除？', {
		btn: ['确认','取消'] //按钮
	}, function(){
		ajax({
			url: 'remuneration/deleteRemuneration.do'
			,channels: channels
			,year_month_s: year_month_s
		}, function(result) {
			if ("error" == result.code) {
				layer.msg(result.msg, {icon: 2});
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
</script>
</head>
<body class="gray-bg">

<div class="wrapper wrapper-content">
	<div class="row">
		<div class="col-sm-12">
			<div class="ibox float-e-margins">
				<div class="ibox-title">
					<h5><i class="fa fa-leanpub"></i> 酬金明细</h5>
					<div class="ibox-tools"><a class="a-reload"><i class="fa fa-repeat"></i> 刷新</a></div>
				</div>
				<div class="ibox-content">
					<div class="form-group">
						<div class="col-sm-12 form-inline">
							<label class="control-label">模板</label>
							<select class="input-sm form-control" name="bname" style="width: 200px;">
								<!-- <option value="">请选择酬金模板</option> -->
							</select>
							<label class="control-label">酬金月份</label>
							<select class="input-sm form-control" name="yearmonth" style="width: 200px;">
							</select>
							<label class="control-label">渠道编码</label>
							<input type="text" class="input-sm form-control" name="channel" style="width: 200px;"/>
							<button class="btn btnm btn-success btn-sm" type="button" onclick="doLoad()">
								<i class="fa fa-search"></i> 查询
							</button>
							<button class="btn btnm btn-success btn-sm" type="button" onclick="showEditModel()">
								<i class="fa fa-edit"></i> 编辑
							</button>
							<button class="btn btnm btn-success btn-sm" type="button" onclick="doDelete()">
								<i class="fa fa-close"></i> 删除
							</button>
						</div>
					</div>
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
			<h5><i class="fa fa-pencil-square-o"></i> 编辑酬金明细</h5>
			<div class="ibox-tools">
				<a class="close-link" data-dismiss="modal">
				<i class="fa fa-times"></i>
				</a>
			</div>
		</div>
		<div class="ibox-content">
			<div id="append-form-group">
			<div class="form-group">
				<label class="col-sm-3 control-label">渠道编码</label>
				<div class="col-sm-8 append_div">
					<input type="text" class="input-sm form-control validate[required]" name="channel" maxlength="36" placeholder="请填写渠道编码" disabled="disabled"/>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label">渠道名称</label>
				<div class="col-sm-8 append_div">
					<input type="text" class="input-sm form-control" name="channel_name" maxlength="36"/>
				</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label">酬金年月</label>
				<div class="col-sm-8 append_div">
					<input type="text" class="input-sm form-control validate[required]" name="year_month_" maxlength="36" disabled="disabled"/>
				</div>
			</div>
			</div>
			<div class="form-group">
				<label class="col-sm-3 control-label"></label>
				<div class="col-sm-8">
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