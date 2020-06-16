<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<style>
.container-fluid {
	line-height: 30px;
}
.col-0 {
	width: 35px;
	font-weight: bold;
	vertical-align: top;
}
span {
	padding-left: 5px;
}
</style>
<script>
var queryUrl = "${ctx}/jsp/work/queryRewardSurveyRecord.do";
var queryRsUrl = "${ctx}/jsp/work/queryRewardSurvey.do";
var updateRsrUrl = "${ctx}/jsp/work/updateRewardSurveyRecord.do";
$(window).ready(function() {
	/**
	var roleFlag = false;
	var userRoles_ =  '${myUser.extMap.roles}';
	$.each(eval("("+userRoles_+")"),function(i,o){
		if( "渠道老板" == o.roleName ){
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
				userId : userId_,
				userName : userName_
			}
		},
		"aoColumnDefs" : [
			{
				"targets": [ 0 ],
				"render": function( data, type, row ){
					return "<input type='checkbox' name='rsrId' value='"+row.rsrId+"' />";
				}
			},
			{
				"targets": [ 1 ],
				"data": "rsTitle"
			},
			{
				"targets": [ 2 ],
				"data": "rsType",
				"render": function( data, type, row ){
					return "1" == data ? "开票" : "到账";
				}
			},
			{
				"targets": [ 3 ],
				"data": "createrName"
			},
			{
				"targets": [ 4 ],
				"data": "rsSended",
				"render": function( data, type, row ){
					return formatCSTDate(data, "yyyy-MM-dd hh:mm:ss");
				}
			},
			{
				"targets": [ 5 ],
				"data": "fdStatus",
				"render": function( data, type, row ){
					//return "1" == data ? "<i class='fa fa-check-circle-o' style='color:#01A701;'> 已反馈</i>" : "<i class='fa fa-times-circle' style='color:#FF0000;'> 未反馈</i>";
					return "1" == data ? "<i class='fa fa-check-circle-o' style='color:#01A701;'> 已反馈</i>" : "<i class='fa fa-check-circle-o'> 未反馈</i>";
				}
			},
			{
				"targets": [ 6 ],
				"data": "fdTime",
				"render": function( data, type, row ){
					return formatCSTDate(data, "yyyy-MM-dd hh:mm:ss");
				}
			},
			{
				"targets": [ 7 ],
				"render": function( data, type, row ){
					return "<a href='javascript:void(0);' rsrId='"+row.rsrId+"' class='cl-for-detail'>详情</a>";
				}
			}
		]
	});
	
	$("#datas").on("click", ".cl-for-detail", function(){
		var rsrId = $(this).attr("rsrId");
		var obj = new Object();
		obj.url = queryUrl;
		obj.id = rsrId;
		obj.userId = userId_;
		obj.userName = userName_;
		ajax(obj, function(result){
			if ("error" == result.resCode) {
				layer.msg(result.resMsg, {icon: 2});
			}else{
				var rsInfo = result.datas[0]
				$("#editForm").fill(rsInfo);
				if( "1" == rsInfo.rsType ){
					$("#choose-y-desc").html("已开票");
					$("#choose-n-desc").html("未开票");
				}else{
					$("#choose-y-desc").html("已到账");
					$("#choose-n-desc").html("未到账");
				}
				if( "1" == rsInfo.fdStatus ){
					$("#editForm").find("input:radio").attr("disabled", true);
					$("#rsr-save").attr("disabled", true);
				}else{
					$("#editForm").find("input:radio").attr("disabled", false);
					$("#rsr-save").attr("disabled", false);
				}
				if( !$("#file-opt").hasClass("hide") ){
					$("#file-opt").addClass("hide")
				}
				
				$(".files").html("");
				var files = rsInfo.files.data;
				if(files && files.length > 0) {
					getFiles( files, $(".files"), true );
				}
				//删除多余的多文件输入框
				$(".diyFile").find('a[onclick="$deleteFile(this)"]').click();
				$("#editModal").modal("show");
			}
		});
	});
	
	$("#editModal").on("click", "#rsr-close", function(){
		$("#editModal").modal("hide");
		return false;
	}).on("click", ".rsrChoose", function(){
		$("#file-opt").removeClass("hide");
		var file = $("#file") 
		file.after(file.clone().val("")); 
		file.remove();
		//删除多余的多文件输入框
		$(".diyFile").find('a[onclick="$deleteFile(this)"]').click();
	}).on("click", "#rsr-save", function(){
		var rsChoose = $("input:radio[name='rsChoose']:checked");
		if( rsChoose.length == 0 ){
			layer.msg("请选择反馈选项！", {icon: 0});
			return false;
		}
		if( "1" == rsChoose.val() ){
			//如果选择了已开票或者已到账,必须要上传附件
			var file = $(this).closest("#editForm").find("input:file");
			var realFileCount = 0;
			for( var i = 0 ; i < file.length ; i++ ){
				if( file[i].files.length > 0 ){
					realFileCount++;
				}
			}
			if( realFileCount == 0 ){
				layer.msg("请上传对应已开票/到账的证明截图！", {icon: 0});
				return false;
			}
		}
		
		$("#editForm").attr("action", updateRsrUrl);
		ajaxSubmit("#editForm", new Object(), function( data ){
			if ("error" == data.resCode) {
				layer.msg(data.resMsg, {icon: 2});
			} else {
				layer.msg("数据处理成功！", {icon: 1});
				$("#editModal").modal("hide");
				dTable.api().ajax.reload();
			}
		});
		return false;
	});
	
});
</script>
</head>
<body class="gray-bg" >
<div class="wrapper wrapper-content animated fadeIn">
       <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5>酬金进度反馈</h5>
                    	<div class="ibox-tools">
	                        <a class="a-reload">
	                            <i class="fa fa-repeat"></i> 刷新
	                        </a>
	                    </div>
	                </div>
                    <div class="ibox-content">
                    	<table id="datas" class="table display" style="width:100%">
                    		<thead>
                    			<tr>
                    				<th><input type="checkbox" id="checkAll" /></th>
                    				<th>标题</th>
                    				<th>类型</th>
                    				<th>发送人</th>
                    				<th>发送时间</th>
                    				<th>状态</th>
                    				<th>反馈时间</th>
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
    			<form id="editForm" class="form-horizontal key-13" role="form" method="post" enctype="multipart/form-data">
    				<input type="hidden" id="rsrId" name="rsrId" />
    				<input type="hidden" id="rsId" name="rsId" />
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
						      <select id="rsType" name="rsType" class="input-sm form-control" disabled>
						      	<option value="">请选择类型</option>
						      	<option value="1">开票</option>
						      	<option value="2">到账</option>
						      </select>
						    </div>
					  	</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">主题:</label>
							<div class="col-sm-10">
								<input type="text" id="rsTitle" name="rsTitle" maxlength="30" class="input-sm form-control" disabled />
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">内容:</label>
							<div class="col-sm-10">
								<textarea rows="5" class="form-control" maxlength="300" name="rsContent" id="rsContent" disabled></textarea>
							</div>
						</div>
						<div class="form-group">
							<label class="col-sm-2 control-label">选项:</label>
							<div class="col-sm-10">
								<label for="rsChoose-y"><input type="radio" name="rsChoose" value="1" class="rsrChoose" id="rsChoose-y"><label id="choose-y-desc" for="rsChoose-y"></label></label>
					      		<label for="rsChoose-n"><input type="radio" name="rsChoose" value="0" class="rsrChoose" id="rsChoose-n"><label id="choose-n-desc" for="rsChoose-n"></label></label>
							</div>
						</div>
						<div id="file-opt" class="form-group hide">
							<label class="col-sm-2 control-label">附件</label>
							<div class="col-sm-10" isLimit="1" limit="5">
							  <input type="file" id="file" name="file" class="input-sm form-control" multiple="multiple" accept="image/png,image/jpg,image/bmp,image/jpeg,image/gif" />
							</div>
					  	</div>
					  	<div class="form-group">
					    	<label class="col-sm-12 control-label files"></label>
					  	</div>
						<div class="modal-footer">
							<button type="butotn" class="btn btn-success btn-13" id="rsr-save"><i class="fa fa-save"></i> 保存</button>
							<button type="butotn" class="btn btn-success btn-13" id="rsr-close"><i class="fa fa-close"></i> 关闭</button>
						</div>
					</div>
    			</form>
    		</div>
    	</div>
    </div>
    
</div>    
</body>
</html>