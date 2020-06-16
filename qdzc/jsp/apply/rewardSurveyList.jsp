<%@page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<style>
.a-split {
	display: inline-block;
    width: 15px;
    text-align: center;
}
.control-label-left {
	margin-left: 30px;
}
.btn-layout {
	margin: 5px 0 0 30px;
}
</style>
<script>
var insertUrl = "${ctx}/jsp/work/insertRewardSurvey.do";
var queryUrl = "${ctx}/jsp/work/queryRewardSurvey.do";
var updateUrl = "${ctx}/jsp/work/updateRewardSurvey.do";
var deleteUrl = "${ctx}/jsp/work/deleteRewardSurvey.do";
var queryRsRecordUrl = "${ctx}/jsp/work/rewardSurveyRecord.do";
var exportRsUrl = "${ctx}/jsp/work/exportRewardSurvey.do";
$(window).ready(function() {
	/**
	var roleFlag = false;
	var userRoles_ =  '${myUser.extMap.roles}';
	$.each(eval("("+userRoles_+")"),function(i,o){
		if( "酬金支撑" == o.roleName ){
			roleFlag = true;
			return false;
		}
	});
	if( !roleFlag ){
		$("body").find("input,a,select,button").attr("disabled", true);
		layer.msg("对不起,您没有权限使用此功能!", {icon: 2});
		return;
	}
	**/
	$("#startTime").val( dateOffset( -6, "yyyy-MM-dd" ) );
	$("#endTime").val( dateOffset( 1, "yyyy-MM-dd" ) );
	
	var dTable = $("#datas").dataTable({
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
			"data": {
				startTime: $("#startTime").val(),
				endTime: $("#endTime").val(),
				rsType: $("#rsType").val(),
				rsStatus: $("#rsStatus").val()
			}
		},
		"aoColumnDefs" : [
			{
				"targets": [ 0 ],
				"data": "rsTitle"
			},
			{
				"targets": [ 1 ],
				"data": "rsType",
				"render": function( data, type, row ){
					return data == "1" ? "开票" : "到账";
				}
			},
			{
				"targets": [ 2 ],
				"data": "createrName"
			},
			{
				"targets": [ 3 ],
				"data": "created",
				"render": function( data, type, row ){
					return formatCSTDate(data, "yyyy-MM-dd hh:mm:ss");
				}
			},
			{
				"targets": [ 4 ],
				"data": "sendCount",
				"render": function(data, type ,row){
					if( "0" == data || 0 == data ){
						return "-";
					}else{
						return data;
					}
				}
			},
			{
				"targets": [ 5 ],
				"data": "nFdCount",
				"render": function(data, type, row){
					if( "0" == row.sendCount || 0 == row.sendCount ){
						return "-";
					}else{
						return data;
					}
				}
			},
			{
				"targets": [ 6 ],
				"data": "fdCount",
				"render": function(data, type, row){
					if( "0" == row.sendCount || 0 == row.sendCount ){
						return "-";
					}else{
						return data;
					}
				}
			},
			{
				"targets": [ 7 ],
				"data": "rsStatus",
				"render": function( data, type, row ){
					return data == "1" ? "<i class='fa fa-send-o' style='color:#01A701;'> 已发送<i>" : "<i class='fa fa-send-o'> 未发送</i>";
				}
			},
			{
				"targets": [ 8 ],
				"render": function( data, type, row ){
					var s = '';
					if( "0" == row.rsStatus ){
						s += '<a href="javascript:void(0);" rsId="'+row.id+'" class="deleteRow">删除</a><label class="a-split"><b>|</b></label>';
						s += '<a href="javascript:void(0);" rsId="'+row.id+'" fdCount="'+row.fdCount+'" class="editRow">编辑重发</a><label class="a-split"><b>|</b></label>';
					}else{
						s += '<a href="javascript:void(0);" rsId="'+row.id+'" class="pBackRow">撤回</a><label class="a-split"><b>|</b></label>';
					}
					return s + '<a href="'+queryRsRecordUrl+'?id='+row.id+'" rsId="'+row.id+'">详情</a><label class="a-split"><b>|</b></label><a a-link-id="'+row.id+'" class="rs-export">导出</a>';
				}
			}
		]
	});
	
	$(".date-clear").on("click", function(){
		//清除日期选择
		$("#startTime").val("");
		$("#endTime").val("");
	});
	
	$("#btn-query").on("click", function(){
		//查询
		var param = {
			"startTime": $("#startTime").val(),
			"endTime": $("#endTime").val(),
			"rsType": $("#rsType").val(),
			"rsStatus": $("#rsStatus").val()
		};
		dTable.api().settings()[0].ajax.data = param;
		dTable.api().ajax.reload();
	});
	
	$("#rs-create").on("click", function(){
		//发布反馈问卷
		if( !$(".display-choose-kp").hasClass("hide") ) $(".display-choose-kp").addClass("hide");
		if( !$(".display-choose-dz").hasClass("hide") ) $(".display-choose-dz").addClass("hide");
		$("#optFlag").val("create");
		$("#editModal").modal("show");
	});
	
	$("#editForm").on("change", "#rsType", function(){
		//切换问卷类型
		linkAgeChooseOption( $(this).val() );
	});
	
	$("#rs-save").on("click", function(){
		//保存,不发送
		return saveOrEditData("0");
	});
	
	$("#rs-send").on("click", function(){
		//发送
		return saveOrEditData("1");
	});
	
	function saveOrEditData( rsSuatus ){
		var obj = new Object();
		obj.rsSuatus = rsSuatus;
		var optFlag = $("#optFlag").val();
		if( "update" == optFlag ){
			$("#editForm").attr("action", updateUrl);
			obj.id = $("#rsId").val();
		}else{
			$("#editForm").attr("action", insertUrl);
		}
		var b = $("#editForm").validationEngine("validate");
		if( b ){
			ajaxSubmit("#editForm", obj, function( data ){
				if ("error" == data.resCode) {
					layer.msg(data.resMsg, {icon: 2});
				} else {
					layer.msg("数据处理成功！", {icon: 1});
					$("#editModal").modal("hide");
					dTable.api().ajax.reload();
				}
			});
		}
		return false;
	}
	
	/**
	 * 联动开票/到账的选择项
	 * @rsType 问卷类型
	 */
	function linkAgeChooseOption( rsType ){
		if( "1" == rsType ){
			//开票
			$(".display-choose-kp").removeClass("hide");
			if( !$(".display-choose-dz").hasClass("hide") ) $(".display-choose-dz").addClass("hide");
		}else if( "2" == rsType ){
			//到账
			$(".display-choose-dz").removeClass("hide");
			if( !$(".display-choose-kp").hasClass("hide") ) $(".display-choose-kp").addClass("hide");
		}else{
			//请选择
			if( !$(".display-choose-kp").hasClass("hide") ) $(".display-choose-kp").addClass("hide");
			if( !$(".display-choose-dz").hasClass("hide") ) $(".display-choose-dz").addClass("hide");
		}
	}
	
	$("#datas").on("click", ".editRow", function(){
		//编辑重发
		var rsId = $(this).attr("rsId");
		var fdCount = $(this).attr("fdCount");
		var obj = new Object();
		obj.url = queryUrl;
		obj.id = rsId;
		ajax(obj, function(result){
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			}else{
				$("#editForm").fill(result.datas[0]);
				linkAgeChooseOption( result.datas[0].rsType );
				$("#rsId").val(rsId);
				if( "0" == fdCount ){
					//没有反馈记录,直接发送
					$("#optFlag").val("update");
				}else{
					//有反馈记录的,处理为"另存为"
					$("#optFlag").val("insert");
				}
				$("#editModal").modal("show");
			}
		});
	}).on("click", ".deleteRow", function(){
		//删除
		var rsId = $(this).attr("rsId");
		if(rsId){
			layer.confirm('您确定要删除数据吗？', {icon: 3}, function() {
				var obj = new Object();
				obj.url = deleteUrl;
				obj.id = rsId;
				ajax(obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						dTable.api().ajax.reload();
					}
				});
			});
		}
	}).on("click", ".pBackRow", function(){
		//撤回
		var rsId = $(this).attr("rsId");
		if( rsId ){
			layer.confirm('您确定要撤回数据吗？', {icon: 3}, function() {
				var obj = new Object();
				obj.url = updateUrl;
				obj.id = rsId;
				obj.rsSuatus = "0";
				obj.pBack = "1";
				ajax(obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						dTable.api().ajax.reload();
					}
				});
			});
		}
	}).on("click", ".rs-export", function(){
		//导出
		var linkId_ = $(this).attr("a-link-id");
		var portalUrl = '${s:getSysConstant("HOST_PORTAL")}';
		var fileUploadDir = '${s:getSysConstant("FILE_UPLOAD_DIR")}';
		try {
			//pc端导出
			var host = window.top.location.host;
			if( host && portalUrl.indexOf(host) > -1 ){
				window.open( exportRsUrl + "?id=" + linkId_ );
			}
		} catch (e) {
			//webpc导出
			try {
				var obj = new Object();
				obj.url = "${ctx}/jsp/work/exportRewardSurveyUrl.do?id=" + linkId_;
				obj.dataType = "html";
				obj.async = false;
				ajax(obj, function(result){
					result = $.parseJSON(result);
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						var filename = result.fileName;
						//var realUrl = portalUrl+"/files/portal/"+sysId_+"/"+filename;
						var realUrl = portalUrl+fileUploadDir+sysId_+"/"+filename;
						var msg = {
						    "type": "DOWNLOAD_FILE",    //  当前操作名称
						    "data": realUrl,   //  对应的data，例如： 附件url、查看大图的url,
						    "original_name": "ORDER_SYSTEM"    //  当前iframe名称----不可随意修改
						};
						window.top.postMessage(JSON.stringify(msg),msgdownloadUrl);
					}
				});
			} catch (e) {
				layer.msg("操作失败!", {icon: 2});
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
   					<div class="ibox-title">
	                    <h5>酬金反馈管理</h5>
                    	<div class="ibox-tools">
	                        <a class="a-reload">
	                            <i class="fa fa-repeat"></i> 刷新
	                        </a>
	                    </div>
	                </div>
	                
                    <div class="ibox-content">
						<div class="form-horizontal clearfix">
							<div class="col-sm-12 form-inline" style="padding-right:0; text-align:right">
								<button type="butotn" class="btn btn-success btn-13" id="rs-create"><i class="fa fa-edit"></i> 发布反馈问卷</button>
							</div>
							<div class="col-sm-12 form-inline">
								<form id="queryForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
									<input type="text" placeholder="年-月-日" class="input-sm form-control date_select" id="startTime" name="startTime" readonly="readonly" onclick="WdatePicker()" />
									<b>-</b>
									<input type="text" placeholder="年-月-日" class="input-sm form-control date_select" id="endTime" name="endTime" readonly="readonly" onclick="WdatePicker()" />
									<label class="control-label"><a href="javascript:void(0);" class="date-clear">清除</a></label>
									<label class="control-label control-label-left">类型:</label>
									<select id="rsType" name="rsType" class="form-control">
										<option value="">全部</option>
										<option value="1">开票</option>
										<option value="2">到账</option>
									</select>
									<label class="control-label control-label-left">状态:</label>
									<select id="rsStatus" name="rsStatus" class="form-control">
										<option value="">全部</option>
										<option value="0">未发送</option>
										<option value="1">已发送</option>
									</select>
									<button id="btn-query" type="button" class="btn btn-sm btn-success btn-13 btn-layout"><i class="fa fa-search"></i> 查询</button>
								</form>
							</div>
						</div>
                        <table id="datas" class="table display" style="width:100%">
                            <thead>
                                <tr>
									<th>主题</th>
									<th>类型</th>
									<th>创建人</th>
									<th>创建时间</th>
									<th>发送总数</th>
									<th>未反馈数</th>
									<th>已反馈数</th>
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
    
    <div class="modal fade" id="editModal" tabindex="-1" role="dialog" >
    	<div class="modal-dialog" style="width:70%;">
    		<div class="modal-content ibox">
    			<input type="hidden" id="optFlag" name="optFlag" value="" />
    			<input type="hidden" id="rsId" name="rsId" value="" />
    			<form id="editForm" class="form-horizontal key-13" role="form" method="post">
    				<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i> 编辑数据</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
	                <div class="ibox-content">
	                	<div class="form-group">
						    <label class="col-sm-2 control-label">类型:</label>
						    <div class="col-sm-10">
						      <select id="rsType" name="rsType" class="input-sm form-control validate[required]">
						      	<option value="">请选择类型</option>
						      	<option value="1">开票</option>
						      	<option value="2">到账</option>
						      </select>
						    </div>
					  	</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">主题:</label>
							<div class="col-sm-10">
								<input type="text" id="rsTitle" name="rsTitle" maxlength="30" class="input-sm form-control validate[required]" />
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">内容:</label>
							<div class="col-sm-10">
								<textarea rows="5" class="form-control validate[required]" maxlength="300" name="rsContent" id="rsContent" ></textarea>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">选项:</label>
							<div class="col-sm-10">
								<div class="display-choose-kp hide">
									<label><input type="radio" name="rsChoose" value="1">已开票</label>
						      		<label><input type="radio" name="rsChoose" value="0">未开票</label>
					      		</div>
					      		<div class="display-choose-dz hide">
									<label><input type="radio" name="rsChoose" value="1">已到账</label>
						      		<label><input type="radio" name="rsChoose" value="0">未到账</label>
					      		</div>
							</div>
						</div>
						<div class="modal-footer">
							<button type="butotn" class="btn btn-sm btn-success btn-13" id="rs-save"><i class="fa fa-save"></i> 保存</button>
							<button type="butotn" class="btn btn-sm btn-success btn-13" id="rs-send"><i class="fa fa-send"></i> 发布</button>
							<button type="button" class="btn btn-sm btn-default" data-dismiss="modal">
			                	<i class="fa fa-ban"></i> 取消
			                </button>
						</div>
					</div>
    			</form>
    		</div>
    	</div>
    </div>
    
</body>
</html>