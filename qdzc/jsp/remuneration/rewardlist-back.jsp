<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<style>
	.detailsDiv {
		overflow-x: auto;
		overflow-x: hidden;
		border: 1px solid red;
	}
	.detailDiv table {
		width: 5000px;
	}
</style>
<script>
	var phoneLibUrl = "${ctx}/familyCircle/queryList.do";
	var getFCTypUrl = "${ctx}/familyCircle/getFCTypeList.do";
	var addFCPhoneUrl = "${ctx}/familyCircle/addFCPhone.do";
	var updateFCUrl = "${ctx}/familyCircle/updateNumberLib.do";
	var queryFCInfoByBasicId = "${ctx}/familyCircle/queryFCInfoByBasicId.do";
	var deleteFCUrl = "${ctx}/familyCircle/deleteFCByIds.do";
	var searchChannelInfo = "${ctx}/familyCircle/searchChannelInfo.do";
	var importUrl = "${ctx}/familyCircle/fcImportExcel.do";
	var exportUrl = "${ctx}/familyCircle/fcExportExcel.do";
	
	var loadTemplate = "${ctx}/FCFieldLib/loadTemplate.do";//模板生成
	

	$(window).ready(function() {
		var now = formatDate(new Date(),"yyyy-MM-dd");
		var firstDay = formatDate(new Date(),"yyyy-MM")+"-01";
		
		 var table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": false,
			"autoWidth": false,
			"processing": true,
			"serverSide": true,
			"StateSave":true,
			"ajax": {
				"dataSrc": "data",
				"url": phoneLibUrl,
				"data":{
					"startTime":$("#start_date").val(),
					"endTime":$("#end_date").val(),
					"phone":$("#phone_no").val()
				}
			},
			"aaSorting": [[ 0, "desc" ]],
			"aoColumnDefs": [ {
				"bSortable": false,
				"aTargets": [ 0, 1, 2, 3, 4, 5,6,7,8 ]
			}, {
				"targets": [ 0 ],
				"data":"id",
				
				"render": function (data, type, row) {
					var s = '<input type="checkbox" ';
					if("1" == row.row_default) {
						s = s + 'disabled="disabled" '; 
					} else {
						s = s + 'class="ids_" name="ids_" value="'+data+'" '; 
					}
					return s +'style="margin:0px;"/>';
				} 
			}, {
				"targets": [ 1 ],
				"data":"id",
				"visible":false,
			},{
				"targets": [ 2 ],
				"data":"fc_code"
			}, {
				"targets": [ 3 ],
				"data":"phone"
			}, {
				"targets": [ 4 ],
				"data":"key_person"
			}, {
				"targets": [ 5 ],	
				"data":"MODIFIED"
				
			}, {
				"targets": [ 6 ],	
				"data":"MODIFIER"
				
			}, {
				"targets": [ 7 ],	
				"data":"query_num"
				
			},{
				"targets": [ 8 ],
				"data":"id",
				 "render":function (data, type, row) {
					  //'<a id=\"channelInfo\" onclick=\"channelInfo\("+data+"\) >渠道</a>'
					return '<a class="detail" onclick="details(this);" data-val="'+row.id+'" data-obj="'+JSON.stringify(row).replace(/\"/g,"'")+'">详情</a>'
					+'|'
					+'<a id="channelInfo" data-val="'+row.id+'" onclick="channelInfo(this);" >渠道</a>';
				}
			}]
			   
		});
        //条件查询  
		$("#btn-query").on("click", function() {
			var param = {
				"phone": $("#phone_no").val(),
				"startTime": $("#start_date").val(),
				"endTime": $("#end_date").val()
			};
			table.api().settings()[0].ajax.data = param;
			table.api().ajax.reload();
       	});
		//添加
		$("#btn-add").on("click",function(){
			$("#phone").attr("readonly",false);
			 $.ajax({
	             type: "GET",
	             url: getFCTypUrl,
	             data: {"sysId":sysId_},
	             success: function(res){
	            	var resObj = eval('(' + res + ')');
	                if(resObj.code == '0' ){
	                	$("#editForm")[0].reset();
	        			$("#editForm").attr("action", addFCPhoneUrl);
	        			$("#FCTypeDiv").empty();
	        			var fcTypeIds = new Array()
	                	$.each(resObj.data, function(index, fcType){
                            var divHtml = $("#FCTypeDiv");
                            var divContent = "<div class='form-group'>"+
                            	"<div class='form-group'>"+
                            	"<label class='col-sm-1 control-label'>"+fcType.name+"</label>"+
                            	"<div class='col-sm-4 '>"+
                            	"<input type='text' class='validate[required]' name='if_"+fcType.id+"' maxlength='25' />"+
                            	"</div>"+
                            	"</div>"; 
                            divHtml.append(divContent);
                            fcTypeIds.push(fcType.id);
                      	});
	        			$("#fcTypeIds").val(fcTypeIds);
	        			$("#myModal").modal("show");
	                }else if(resObj.code == '2'){
	                	layer.msg("请先添加字段库字段！", {icon: 0});
	                }else{
	                	layer.msg(resObj.msg, {icon: 0});
	                }
	                	
	             }
	         });
		});
		//修改
		$("#btn-update").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size != 1) {
				layer.msg("请选择需要修改的一行数据！", {icon: 0});
				return;
			}
			$("#editForm")[0].reset();
			$("#editForm").attr("action", updateFCUrl);
			$("#FCTypeDiv").empty();
			$("#phone").attr("readonly",true);
			$("#myModal").modal("show");
			
			var obj = new Object();
			obj.url = queryFCInfoByBasicId;
			obj.id = $(".ids_:checkbox:checked").val();
			ajax(obj, function(data) {
				if ("error" == data.code) {
					error(data.msg);
					//layer.msg(data.resMsg, {icon: 2});
				}else if("1" == data.code){
					error(data.msg);
				} else {
					$("#editForm").fill(data.data);
					var fcTypeIds = new Array()
					var typesNum = data.data.typeLenth.length;
					$.each(data.data.members, function(membersIndex, members){
						$.each(members.memberTypes, function(index, fcType){
	                		var divHtml = $("#FCTypeDiv");

						if(index<=typesNum){
							if(fcType.basic_id==obj.id){
								  var divContent = "<div class='form-group'>"+
						         	"<label class='col-sm-1 control-label'>"+fcType.name+"</label>"+
						         	"<input type='text' id='fcbtId' name='fcbtIds' value='"+fcType.id+"' style='display:none'/>"+
						         	"<div class='col-sm-4 '>"+
						         	"<input type='text' class='validate[required]' name='if_"+fcType.type_id+"' value='"+fcType.isTransact+"' maxlength='25' />"+
						         	"</div>"+
						         	"</div>"; 
								  divHtml.append(divContent);
								  fcTypeIds.push(fcType.type_id);
							}
	                       }
	                  	});
					})
					
        			$("#fcTypeIds").val(fcTypeIds);
        			
				}
			});
       	});
		
		//删除
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
				obj.url = deleteFCUrl;
				obj.ids = ids.join(",");
				ajax(obj, function(data) {
					if ("error" == data.code) {
						layer.msg(data.msg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						table.api().ajax.reload();
					}
				});
			});
		});
		

		$(".date_time").on("click", function() {
			var thiz = $(this);
			var other_date = $(this).attr("other_date");
			var format = $(this).attr("format");
			var date = formatDate(new Date());
			if(!format){
				format = "yyyy-MM-dd HH:mm:ss";
			}
			WdatePicker({
				dateFmt:format,
				onpicked:function(dp){
	 				dateChange(thiz,other_date);
				},
				maxDate:date
			});
		});
		
		function dateChange(ele,other_date){
			if(other_date&&$(other_date).val()){
				switch (other_date) {
				case "#end_date":
					if($(ele).val()>$(other_date).val()){
						alert("开始时间不能大于结束时间");
						$(ele).val("");
						return;
					}
					break;
					
				case "#start_date":
					if($(ele).val()<$(other_date).val()){
						alert("开始时间不能大于结束时间");
						$(ele).val("");
						return;
					}
					
					break;

				default:
					break;
				}
			}
		}
		
		$("#btn-import").on("click", function() {
			$("#importForm").attr("action", importUrl);
			$("#importModal").modal("show");
		});
		
		$("#btn-import-ok").on("click", function() {
			var b = $("#importForm").validationEngine("validate");
			if(b) {
				ajaxSubmit("#importForm", function(result) {
					if ("error" == result.code) {
						layer.msg(result.msg, {icon: 2});
					} else {
						if(result.msg.length===0){
							layer.confirm("数据处理成功！",{
								icon: 1,
								btn:['确定']
							});
						}else{
							layer.confirm("数据处理完成！其中电话号码：   "+result.msg+"处理失败",{
								icon: 1,
								btn:['确定']
							});
						}
						
						$("#importModal").modal("hide");
						table.api().ajax.reload();
					}
				});
			}
		});
		
		$("#btn-export").on("click", function() {
			alert("导出功能暂未开通");
			return; 
			alert("导出文件生成中,请等待...");
			$(this).attr('disabled',true);
			$.ajax({
	             type: "GET",
	             url: exportUrl,
	             data: {"sysId":sysId_},
	             success: function(res){
	            	 var obj = eval('(' + res + ')');
	            	 if(obj.resCode == '0'){
	            		 location.href = "${ctx}/files/down/down_fc_phone_lib_templet.xlsx";
	            	 }else{
	            		 
	            		 layer.msg(obj.resMsg, {icon: 2});
	            	 }
	             },
	             complete:function(){
	            	 $(this).attr('disabled',false);
	             }
	         });
			
		});
		
		$("#btn-ok").on("click", function() {
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				ajaxSubmit("#editForm", function(data) {
					if ("error" == data.code) {
						layer.msg(data.msg, {icon: 2});
					}else if("1" == data.code){
						layer.msg(data.msg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						$("#myModal").modal("hide");
						location.reload(true);
						//table.api().ajax.reload();
					}
				});
			}
		});
		
		$("#btn-clear").on("click",function(){
			$("#start_date").val("");
			$("#end_date").val("");
			$("#phone_no").val("");
		});
		
		$("#templetDown").on("click",function(e){
			e.preventDefault(); 
			$.ajax({
	            type: "GET",
	            async: false,
	            url:loadTemplate , 
	            success: function(data){ 
	            	window.location.href=$("#templetDown").attr("href");
	            },
	            error:function(){layer.msg("模板生成失败！"+data.code, {icon: 2});}
	        }); 
			 
			
			
			
		});
	});
	function channelInfo(aval){
		aval = $(aval);
		$('#channelTable').dataTable().fnDestroy();
		var table = $("#channelTable").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": false,
			"autoWidth": false,
			"processing": true,
			"serverSide": true,
			"ajax": {
				"dataSrc": "data",
				"url": searchChannelInfo,
				"data":{
					"id":aval.attr("data-val")
				}
			},
			"aaSorting": [[ 0, "asc" ]],
			"aoColumnDefs": [ {
				"bSortable": false,
			}, {
				"targets": [ 0 ],
				"data":"id",
				"visible":false,				
			}, {
				"targets": [ 1 ],
				"data":"COUNTY"
			},{
				"targets": [ 2 ],
				"data":"BRANCH_OFFICE"
			}, {
				"targets": [ 3 ],
				"data":"CHANNEL_NAME"
			}, {
				"targets": [ 4 ],
				"data":"CHANNEL"
			}, {
				"targets": [ 5 ],
				"data":"CHANNEL_PHONE"
				
			}, {
				"targets": [ 6 ],	
				"data":"CREATER"
				
			}, {
				"targets": [ 7 ],	
				"data":"CREATED"
				
			}]
			   
		});
		$("#channelInfoModal").modal("show");
	};
	
		//detailsModal
	function details(aval){
		aval = $(aval);
		$.ajax({
            type: "GET",
            url: queryFCInfoByBasicId,
            data: {"id":aval.attr("data-val")},
            success: function(res){
           		var resObj = eval('(' + res + ')');
           		$("#detailsForm input[name='phone']").val(resObj.data.phone);
           		$("#detailsForm input[name='fc_code']").val(resObj.data.fc_code);
           		$("#detailsForm input[name='memberNum']").val(resObj.data.memberNum);
           		$("#detailsDiv").empty();
           		var divHtml = $("#detailsDiv");
           		var tdCountWidth = 200*7;
           		var divContent ="<table id='detailsTable' class='table display'>"
           			+"<thead>"
                    +"<tr>"
           			+"<th>手机号</th>"
           			+"<th width='130'>角色</th>"
           			+"<th>创建时间</th>"
           			+"<th>创建人</th>"
           			+"<th>更新时间</th>"
           			+"<th>更新人</th>"
           			+"<th>被查询次数</th>";
           			
           			$.each(resObj.data.typeLenth, function(index, fcType){
           				divContent += "<th>"+fcType.name+"</th>";
           				tdCountWidth += 200;
           			});
           			divContent += "</tr>"
           			+"</thead><tbody>";
               	$.each(resObj.data.members, function(index, member){
               		divContent +="<tr>"
               			+"<td>"+member.phone+"</td>"
               			+"<td>"+member.key_person+"</td>"
               			+"<td>"+member.CREATED+"</td>"
               			+"<td>"+member.CREATER+"</td>"
               			+"<td>"+member.MODIFIED+"</td>"
               			+"<td>"+member.MODIFIER+"</td>"
               			+"<td>"+member.searchNum+"</td>";
               			var typesNum = resObj.data.typeLenth.length;
               			$.each(member.memberTypes, function(index, memfcType){
               				if(index<typesNum){
               					//console.log(memfcType);
               					divContent += "<td>"+memfcType.isTransact+"</td>";
               					/* if(memfcType.isTransact==0){
                            		divContent += "<td>是</td>";
                            	}else{
                            		divContent += "<td>否</td>";
                            	} */
                       		}
               			});
                        	divContent+="</tr>"
                });
               	+"</tbody></table>"; 
                divHtml.append(divContent);
                $('#detailsTable').css({
                	width: tdCountWidth + 'px'
                })
            }
        });
		
		$("#detailsModal").modal("show");
		
	}
	
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeInDown">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-history"></i>酬金明细管理</h5>
                    	<div class="ibox-tools">
	                        <a class="a-reload">
	                            <i class="fa fa-repeat"></i> 刷新
	                        </a>
	                    </div>
	                </div>
	                
                    <div class="ibox-content">
                        <!-- search star -->
						<div class="form-horizontal clearfix key-13">
							<div class="col-sm-3 pl0">
								<button class="btn btn-sm btn-success" id="btn-add">
									<i class="fa fa-edit"></i> 添加
								</button>
								<button class="btn btn-sm btn-success" id="btn-update">
									<i class="fa fa-edit"></i> 修改
								</button>
								<button class="btn btn-sm btn-success" id="btn-delete">
									<i class="fa fa-trash-o"></i> 删除
								</button>
								<button class="btn btn-sm btn-success" id="btn-import">
									<i class="fa fa-upload"></i> 导入
								</button>
								<button class="btn btn-sm btn-success" id="btn-export" style="display:none;">
									<i class="fa  fa-download"></i> 导出
								</button>
							</div>
	
							<div class="col-sm-9 form-inline" style="padding-right:0; text-align:right">
								开始时间：<input type="text" placeholder="开始时间" other_date="#end_date"  readonly="readonly"  class="input-sm  form-control validate[required] date_time" format="yyyy-MM-dd"  name="start_date" id="start_date" >
								结束时间：<input type="text" placeholder="结束时间" other_date="#start_date" readonly="readonly"  class="input-sm  form-control validate[required] date_time" readonly="readonly"  format="yyyy-MM-dd"  name="end_date" id="end_date" >
                                                                              状态：<select class="form-control" name="status">
										<option value="">全部</option>
										<option value="0">启用</option>
										<option value="-1">禁用</option>
									</select>
                                <button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
									<i class="fa fa-search"></i> 查询
								</button>
								 <button id="btn-clear" type="button" class="btn btn-sm btn-clear btn-13">
									重置
								</button>
							</div>
						</div>
						<!-- search end -->
                        <table id="datas" class="table display" style="width:100%">
                            <thead>
                                <tr>
	                                <th><input type="checkbox" id="checkAll_" style="margin:0px;"></th>
									<th>ID</th>
									<th>导入时间</th>
									<th>模板</th>
									<th>酬金月份</th>
									<th>总金额</th>
									<th>创建人</th>
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
    
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog" >
    	<div class="modal-dialog" style="width:70%;">
    	<div class="modal-content ibox">
                <form id="editForm" class="form-horizontal key-13" role="form">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i> 编辑数据</h5>
	                </div>
	
		            <div class="ibox-content">
	                  <input type="text" id="id" name="id" style="display:none"/>
	                  <input type="text" id="fcTypeIds" name="fcTypeIds" style="display:none"/>
   						<legend>基本信息</legend> 
					  <div class="form-group">
							<label class="col-sm-1 control-label">手机号码</label>
						    <div class="col-sm-4">
						    	<input type="text" class="input-sm form-control validate[required,custom[phone]]" maxlength="11" name=phone id="phone" value="">
						    </div>
					  </div>
					  <div class="form-group">
							<label class="col-sm-1 control-label">家庭圈编号</label>
						    <div class="col-sm-4">
						    	<input type="text" class="input-sm form-control validate[required]" maxlength="20" name=fc_code id="fc_code" value="">
						    </div>
					  </div>
					  <div class="form-group">
							<label class="col-sm-1 control-label">角色</label>
						    <div class="col-sm-4">
						    	<input type="text" class="input-sm form-control validate[required]" maxlength="20" name=key_person id="key_person" value="">
						    </div>
					  </div>
					  <div id="FCTypeDiv"></div>
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
	
	<div class="modal fade" id="detailsModal" tabindex="-1" role="dialog" >
    	<div class="modal-dialog" style="width:70%;" >
    	<div class="modal-content ibox">
    		<form id="detailsForm" class="form-horizontal key-13" role="form">
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-pencil-square-o"></i> 详情数据</h5>
	                </div>
	
		            <div class="ibox-content">
	                  <div class="form-group">
							<label class="col-sm-1 control-label">手机号码</label>
						    <div class="col-sm-2">
						    	<input type="text" class="input-sm form-control " readonly="readonly" name=phone id="phone" value="">
						    </div>
					  </div>
					  <div class="form-group">
							<label class="col-sm-1 control-label">家庭圈编号</label>
						    <div class="col-sm-2">
						    	<input type="text" class="input-sm form-control " readonly="readonly" name=fc_code id="fc_code" value="">
						    </div>
					  </div>
					  </div>
					  <div id="detailsDiv" style="overflow-x: auto; overflow-y: auto; max-height: 600px;"></div>
   						<!-- <table id="detailsTable" class="table display" style="width:100%">
                            <thead>
                                <tr>
									<th>手机号码</th>
									<th>角色</th>
									<th>创建时间</th>
									<th>创建人</th>
									<th>更新时间</th>
									<th>更新人</th>
									<th>被查次数</th>
                                </tr>
                            </thead>
                        </table> -->
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-default" id="btn-cancel" data-dismiss="modal">
		                	<i class="fa fa-ban"></i> 取消
		                </button>
		            </div>
		         </form>
	        </div>
	    </div>
    </div>
	<div class="modal fade" id="channelInfoModal"  >
		<div class="modal-dialog" style="width:70%;">
    	<div class="modal-content ibox">
               <table id="channelTable" class="table display" style="width:100%">
                            <thead>
                                <tr>
									<th>ID</th>
									<th>区县</th>
									<th>分局</th>
									<th>渠道名称</th>
									<th>渠道编码</th>
									<th>联系方式</th>
									<th>搜索人</th>
									<th>搜索时间</th>
                                </tr>
                            </thead>
                        </table>
		            <div class="modal-footer">
	                <button type="button" class="btn btn-sm btn-default" id="btn-cancel" data-dismiss="modal">
	                	<i class="fa fa-ban"></i> 取消
	                </button>
	            </div>
	        </div>
	    </div>
	</div>
	<div class="modal fade" id="importModal" tabindex="-1" role="dialog" >
	    <div class="modal-dialog" style="width:50%;">
	        <div class="modal-content ibox">
                <form id="importForm" class="form-horizontal key-13" role="form" >
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-download"></i> 导入数据</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
		            
		            <div class="ibox-content">
					  <div class="form-group">
					    <label class="col-sm-2 control-label">
					    	<a id="templetDown" href="${ctx}/files/templet/fc_phone_lib_templet.xlsx">模板下载</a>
					    </label>
					    <div class="col-sm-10">
					      <input type="file" name="file" id="file" class="validate[required]">
					    </div>
					  </div>
		            </div >
		            <div class="ibox-content">
		            	<div class="form-group">
			            	<label class="col-sm-2 control-label"  >上传方式</label>
			            	<div class="col-sm-10">
			            		新增
			            		<input type="radio" class="validate[required]" name="operation" value="0"  checked="checked"/>
			            		更新
			            		<input type="radio" class="validate[required]" name="operation" value="1"  />
			            		<!-- 删除
			            		<input type="radio" class="validate[required]" name="operation" value="2"  /> -->
			            	</div>
		            	
		            	</div>
		            </div>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-import-ok">
		                	<i class="fa fa-check"></i> 确定
		                </button>
		                <button type="button" class="btn btn-sm btn-default" id="btn-import-cancel" data-dismiss="modal">
		                	<i class="fa fa-ban"></i> 取消
		                </button>
		            </div>
				</form>
	        </div>
	    </div>
	</div>
</body>
</html>