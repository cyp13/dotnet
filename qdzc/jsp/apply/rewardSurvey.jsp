<%@ page language="java" contentType="text/html; charset=UTF-8"    pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
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
var queryUrl = "${ctx}/jsp/work/queryRewardSurvey.do";
var queryRsrListUrl = "${ctx}/jsp/work/queryRewardSurveyRecordByRsId.do";
$(window).ready(function() {
	var rsInfo;
	var rsId = "${param.id}";
	var feededRsDataTable,nFeededRsDataTable;
	var obj = new Object();
	obj.url = queryUrl;
	obj.id = rsId;
	ajax(obj, function( result ){
		if ("error" == result.resCode) {
			layer.msg("问卷信息查询异常:"+result.resMsg, {icon: 2});
		} else {
			rsInfo = result.datas[0];
			$("#rs-Type").html( "1" == rsInfo.rsType ? "开票" : "到账" );
			$("#rs-Creater").html( rsInfo.createrName );
			$("#rs-Created").html( formatCSTDate(rsInfo.created, "yyyy-MM-dd hh:mm:ss") );
			$("#rs-Sended").html( formatCSTDate(rsInfo.rsSended, "yyyy-MM-dd hh:mm:ss") );
			$("#rs-Status").html( "1" == rsInfo.rsStatus ? "已发送" : "未发送" );
			$("#rs-Title").html( rsInfo.rsTitle );
			$("#rs-Content").html( rsInfo.rsContent );
			$("#rs-choose").html("").append("<label><input type='radio' name='rsChoose' />"+ ("1" == rsInfo.rsType ? "已开票" : "已到账") +"</label><label><input type='radio' name='rsChoose' />"+ ("1" == rsInfo.rsType ? "未开票" : "未到账") +"</label>" );
		}
	});
	$("#link-rsFdInfo").on("click", function(){
		if( rsInfo ){
			$("#rs-record-count").html( rsInfo.fdCount + rsInfo.nFdCount );
			$("#rs-record-count-fd").html( rsInfo.fdCount );
			$("#rs-record-count-nfd").html( rsInfo.nFdCount );
			$("#fd-type-0").html( "1" == rsInfo.rsType ? "已开票数:" : "已到账数:" );
			$("#fd-type-1").html( "1" == rsInfo.rsType ? "未开票数:" : "未到账数:" );
			$("#fd-type-v-0").html( rsInfo.fdYCount );
			$("#fd-type-v-1").html( rsInfo.fdNCount );
			
			feededRsDataTable = $("#datas-rsFeeded").dataTable({
				"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
				"dom": 'rt<"bottom"iflp<"clear">>',
				"pagingType": "full_numbers",
				"searching": false,
				"ordering": true,
				"autoWidth": false,
				"processing": true,
				"serverSide": true,
				"ajax": {
					"dataSrc": "datas",
					"url": queryRsrListUrl,
					"data": {
						"rsId" : rsId,
						"fdStatus" : "1"
					}
				},
				"aoColumnDefs" : [
					{
						"targets": [ 0 ],
						"data": "orgName",
						"orderable": false
					},
					{
						"targets": [ 1 ],
						"data": "userCnName",
						"orderable": false
					},
					{
						"targets": [ 2 ],
						"data": "orgId",
						"orderable": false
					},
					{
						"targets": [ 3 ],
						"data": "mPhone",
						"orderable": false
					},
					{
						"targets": [ 4 ],
						"data": "county",
						"orderable": false,
						"render": function( data, type, row ){
							return data ? data : "";
						}
					},
					{
						"targets": [ 5 ],
						"data": "branch",
						"orderable": false,
						"render": function( data, type, row ){
							return data ? data : "";
						}
					},
					{
						"targets": [ 6 ],
						"data": "fdTime",
						"orderable": false,
						"render": function( data, type, row ){
							return formatCSTDate(data, "yyyy-MM-dd hh:mm:ss");
						}
					},
					{
						"targets": [ 7 ],
						"data": "fdResult",
						"orderable": true,
						"render": function( data, type, row ){
							var str = "";
							if( "1" == rsInfo.rsType ){
								str = "1" == data ? "已开票" : "未开票";
							}else{
								str = "1" == data ? "已到账" : "未到账";
							}
							return str;
						}
					},
					{
						"targets": [ 8 ],
						"data": "files",
						"orderable": false,
						"render": function( data, type, row ){
							var fileList = data.data;
							if( fileList && fileList.length > 0 ){
								var str = "";
								$.each( fileList, function(index,o){
									var url_ = downloadUrl+"&id="+o.id;
									var portalUrl = '${s:getSysConstant("HOST_PORTAL")}';
									var fileUploadDir = '${s:getSysConstant("FILE_UPLOAD_DIR")}';
									var src = o.ext3;//文件地址
									//var fileCreateDate = ""+(o.created.year)+o.created.month+o.created.day;
									var realUrl ="";
									if(src){
										 //realUrl = portalUrl + "/files/portal/" + o.ext3 ;
										realUrl = portalUrl + fileUploadDir + o.ext3 ; 
									}else{
										 //realUrl = portalUrl+"/files/portal/"+sysId_+"/"+fileId;
										realUrl = portalUrl+fileUploadDir+sysId_+"/"+fileId;

									}
									//var imgUrlAddress = getSmallImgUrl(src,fileCreateDate);//根据图片创建日期应该显示的图片的地址
									//var smallRealUrl = portalUrl+"/files/portal/"+imgUrlAddress;
									
									var html = "<a state='normal' onclick='downloadFile(this,true)' data-id='"+o.id+"."+o.fileExt+"' data-url='"+url_+"' realUrl='"+realUrl+"' href='javascript:void(0);' target='_blank'><img width='40px'  src='"+realUrl+"' /></a>";
									html +="&nbsp;&nbsp;";
									str += html;
								});
								return str;
								
							}
							return "";
						}
					}
				]
			});
			
			nFeededRsDataTable = $("#datas-rsNfeeded").dataTable({
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
					"url": queryRsrListUrl,
					"data": {
						"rsId" : rsId,
						"fdStatus" : "0"
					}
				},
				"aoColumnDefs" : [
					{
						"targets": [ 0 ],
						"data": "orgName"
					},
					{
						"targets": [ 1 ],
						"data": "userCnName"
					},
					{
						"targets": [ 2 ],
						"data": "orgId"
					},
					{
						"targets": [ 3 ],
						"data": "mPhone"
					},
					{
						"targets": [ 4 ],
						"data": "county",
						"render": function( data, type, row ){
							return data ? data : "";
						}
					},
					{
						"targets": [ 5 ],
						"data": "branch",
						"render": function( data, type, row ){
							return data ? data : "";
						}
					}
				]
			});
		}
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
	                    <h5><label>酬金进度反馈>详情</label></h5>
                    	<div class="ibox-tools">
	                        <a class="a-back"><i class="fa fa-reply"></i>返回</a>
	                    </div>
	                </div>
                </div>
                <div class="ibox-content">
                	<ul class="nav nav-tabs" role="tablist">
                		<li role="presentation" class="active"><a href="#rsInfo" role="tab" data-toggle="tab">问卷信息</a></li>  
                		<li role="presentation"><a href="#rsFdInfo" role="tab" data-toggle="tab" id="link-rsFdInfo">反馈信息</a></li>
                	</ul>
                	<div class="tab-content">
                		<div style="height:20px;">&nbsp;</div>
                		<div role="tabpanel" class="tab-pane active" id="rsInfo">
                			<div class="container-fluid">
                				<label class="col-md-2">类型:<span id="rs-Type"></span></label>
                				<label class="col-md-2">创建人:<span id="rs-Creater"></span></label>
                				<label class="col-md-2">创建时间:<span id="rs-Created"></span></label>
                				<label class="col-md-2">发送时间:<span id="rs-Sended"></span></label>
                				<label class="col-md-2">状态:<span id="rs-Status"></span></label>
                			</div>
                			<div style="height:10px;">&nbsp;</div>
                			<div class="container-fluid">
                				<table style="margin:5px;">
	                				<tr>
	                					<td class="col-0">主题:</td>
	                					<td id="rs-Title"></td>
	                				</tr>
	                				<tr>
	                					<td class="col-0">内容:</td>
	                					<td id="rs-Content"></td>
	                				</tr>
	                				<tr>
	                					<td class="col-0">选项:</td>
	                					<td id="rs-choose"></td>
	                				</tr>
	                			</table>
                			</div>
                		</div>
                		<div role="tabpanel" class="tab-pane" id="rsFdInfo">
                			<div class="container-fluid">
                				<label class="col-md-2">发送总数:<span id="rs-record-count"></span></label>
                				<label class="col-md-2">未反馈数:<span id="rs-record-count-nfd"></span></label>
                				<label class="col-md-2">已反馈数:<span id="rs-record-count-fd"></span></label>
                				<label class="col-md-2"><label id="fd-type-0"></label><span id="fd-type-v-0"></span></label>
                				<label class="col-md-2"><label id="fd-type-1"></label><span id="fd-type-v-1"></span></label>
                			</div>
                			<div class="container-fluid">
                				<ul class="nav nav-tabs" role="tablist">
			                		<li role="presentation" class="active"><a href="#rsFeeded" role="tab" data-toggle="tab">已反馈</a></li>  
			                		<li role="presentation"><a href="#rsNfeeded" role="tab" data-toggle="tab">未反馈</a></li>
			                	</ul>
			                	<div class="tab-content">
			                		<div role="tabpanel" class="tab-pane active" id="rsFeeded">
			                			<table id="datas-rsFeeded" class="table display" style="width:100%">
				                            <thead>
				                                <tr>
													<th>渠道名称</th>
													<th>渠道姓名</th>
													<th>渠道编码</th>
													<th>联系方式</th>
													<th>区县</th>
													<th>分局</th>
													<th>反馈时间</th>
													<th>反馈结果</th>
													<th>附件</th>
				                                </tr>
				                            </thead>
				                        </table>
			                		</div>
			                		<div role="tabpanel" class="tab-pane" id="rsNfeeded">
			                			<table id="datas-rsNfeeded" class="table display" style="width:100%">
				                            <thead>
				                                <tr>
													<th>渠道名称</th>
													<th>渠道姓名</th>
													<th>渠道编码</th>
													<th>联系方式</th>
													<th>区县</th>
													<th>分局</th>
				                                </tr>
				                            </thead>
				                        </table>
			                		</div>
			                	</div>
                			</div>
                		</div>
                	</div>
                </div>
           </div>
       </div>
</div>    
</body>
</html>