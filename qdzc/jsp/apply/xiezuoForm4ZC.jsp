<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<jsp:include page="/jsp/apply/xiezuoBase.jsp"></jsp:include>
<script src="${ctx}/js/plugins/ztree/jquery.ztree.exhide.js"></script>
<script src="${ctx}/js/plugins/ztree/jquery.ztree.id.search.js"></script>
<script src="${ctx}/js/ztree.xiezuo.js"></script>
<style type="text/css">
ul.divTree {
	width: 232px;
	height: 300px;
	border: 1px solid #ccc;
	background: #f3f3f3;
	overflow: auto;
}
</style>
<script>
var queryUrl = "${ctx}/jsp/work/queryXiezuo.do";
var queryXiezuoHisUrl = "${ctx}/jsp/work/queryXiezuoExt.do";

var pid = '${param.pId}';
var flag = '${param.flag}';
var taskId = '${param.taskId}';
var taskName = '${param.taskName}';
 	$(window).ready(function() {
 		
 		//获取常用语
 		getPhraseToPage();
 		$(".phrase_").typeahead({
	 		 source: phrases
	 	});	
 		
 		//默认不能编辑
 		$(".dataForm input,.dataForm textarea").attr('readonly','readonly');
 		$(".dataForm select,.dataForm input[type='radio']").attr('disabled','disabled');
 		
 		$("#flag").val(flag);
 		$("#taskId").val(taskId); 
 		$("#taskName").val(taskName); 
 		$("#pid").val(pid); 
 		//填充数据
 		if(pid){
			var obj = new Object();
			//实例ID
			obj.pid=pid;
			obj.url=queryUrl;
			obj.token=token_;
			ajax(obj, function(data){
				var row = data.Rows[0];
				$("#editForm").fill(row);
				if(row.opinions){
					if(flag!='3'){
						getOpinionsAndFiles(row.opinions,"#filesAndOpinion");
					}else{
						getOpinionsAndFiles(row.opinions,"#filesAndOpinion",1);
					}
				}
				if(row.status=="2"){//表示已解决
					$(".ibox-content input,.ibox-content textarea,.ibox-content select").attr('disabled','disabled');
				}
				
			});
		}
 		
 		if(flag=='1'){
 			$("#fileUpload").addClass("hide");
 			$("#opinion").addClass('hide');
 			$("#result").removeClass('validate[required]');
 			$("#desc").removeClass('validate[required]');
 			//$(".file1").addClass("hide");
 			
 		}else{
 			$("#finish_date").attr("disabled",true);
 			$(".ext1").attr("disabled",true);
 			$("#fileUpload").removeClass('hide');
 			if(flag!='4'){
 				$("#opinion").removeClass('hide');
 				$("#yijian").removeClass('hide');
 	 			$("#desc").addClass('validate[required]');
 	 			$("#service_type").addClass('validate[required]');
 	 			var phone = '${myUser.mobilePhone}';
 				$("#executor_phone").val(phone);//用户号码
 			}
 			else{
 				$("#btn-ok").hide();
 				$("#fileUpload").addClass("hide");
 			}
 			
 		}
 		
 		$(".action").on("change",function(){
 			$("#action").val($(this).val());
 			//未解决才可编辑数据
 			if($(this).val()=="重发"){
 				$("#action").val("发起");
 				$(".dataForm input,.dataForm textarea").removeAttr('readonly');
 				$(".readonly").attr('readonly','readonly');
 		 		$(".dataForm select,.dataForm input[type='radio']").removeAttr('disabled');
 		 		$("#finish_date").removeAttr('disabled');
 		 		$("#fileUpload").removeClass("hide");
 		 		$("#zhuanpai").removeClass("hide");
 		 		$("#orgNames").addClass("validate[required]");
 		 		$("#roleNames_").addClass("validate[required]");
 			}
 			else{
 				$(".dataForm input,.dataForm textarea").attr('readonly','readonly');
 		 		$(".dataForm select").attr('disabled','disabled');
 		 		$("#finish_date").attr('disabled','disabled');
 		 		$("#fileUpload").addClass("hide");
 		 		$("#zhuanpai").addClass("hide");
 		 		$("#orgNames").removeClass("validate[required]");
 		 		$("#roleNames_").removeClass("validate[required]");
 			}
 		});
 		
		$("#btn-ok").on("click", function() {
			$(this).attr("disabled","disabled");
 			if(!$(".delFile")&&!$("#file").val()){
				$("#file").addClass("validate[required]");
  			}
 			for(var key in deleteFileIds){
				$("#editForm").append('<input type="hidden" name="deleteFileIds" value="'+key+'" />');
			}
			$("#service_type").val($("#service_type_name").val());
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				ajaxSubmit("#editForm", function(data) {
					if ("error" == data.resCode) {
						layer.msg(data.resMsg, {icon: 2});
						$("#btn-ok").removeAttr("disabled");
					} else {
						layer.msg("数据处理成功！", {icon: 1},function(){
							back_();
						});
					}
				});
			}else{
				$("#btn-ok").removeAttr("disabled");
			}
		});
		
		$(".date_time").on("click", function() {
			var format = $(this).attr("format");
			var date = formatDate(new Date());
			if(!format){
				format = "yyyy-MM-dd HH:mm:ss";
			}
			WdatePicker({
				dateFmt:format,
				minDate:date
			});
		});
		
		<c:if test="${param.taskName eq '协作支撑'}">
		var queryZPHisTask = function() {
			var zpTable = $("#zp_datas").dataTable({
	 			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
	 			"dom": 'rt<"bottom"iflp<"clear">>',
	 			"pagingType": "full_numbers",
	 			"bLengthChange": false,
	 			"searching": false,
	 			"info": false,
	 			"paging":false,
	 			"ordering": true,
	 			"order":[[0,"asc"],[1,"asc"]],
	 			"autoWidth": false,
	 			"processing": true,
	 			"serverSide": false,
	 			"ajax": {
	 				"dataSrc": "Rows",
	 				"url": queryXiezuoHisUrl,
	 				"data": function (d) {
	 					return $.extend( {}, d, {
	 						"pId" : "${param.pId}",
	 						"token":token_,
	 					});
	 				}
	 			},
	 			"aaSorting": [],
	 			"aoColumnDefs": [ {
	 				"bSortable": false
	 				
	 			},  {
	 				"targets": [ 0 ],
	 				"data":"created",
	 				"render": function (data, type, row) {
	 					return data;
	 				}
	 			}, {
	 				"targets": [ 1 ],
	 				"data":"execute_time",
	 				"render": function (data, type, row) {
	 					return data ? data : "";
	 				}
	 			}, {
	 				"targets": [ 2 ],
	 				"data":"org_name",
	 				"orderable":false,
	 				"render": function (data, type, row) {
	 					return data ? data+"("+row.org_id+")" : "";
	 				}
	 			}, {
	 				"targets": [ 3	 ],
	 				"data":"role_name",
	 				"orderable":false,
	 				"render": function (data, type, row) {
	 					return data ? data : "";
	 				}
	 			}, {
	 				"targets": [ 4 ],
	 				"data":"status",
	 				"orderable":false,
	 				"render": function (data, type, row) {
	 					if("1"==data){
	 						return "<span style='color:#FF0000'>待处理</span>";
	 					}else if("2"==data){
	 						return "<span class='green'>已处理</span>";
	 					}
	 					return "";
	 				}
	 			}, {
	 				"targets": [ 5 ],
	 				"data":"executor_name",
	 				"orderable":false,
	 				"render": function (data, type, row) {
	 					return data ? data : "";
	 				}
	 			}, {
	 				"targets": [ 6 ],
	 				"data":"result",
	 				"orderable":false,
	 				"render": function (data, type, row) {
	 					if('不同意' == data || '回退' == data || '驳回' == data || '终止' == data || '结束' == data || '撤回' == data || '驳回归档' == data) {
	 						return "<span style='color:#FF0000'>"+data+"</span>";
	 	                }
	 					return data ? data : "";
	 				}
	 			}, {
	 				"targets": [ 7 ],
	 				"data":"opinion",
	 				"orderable":false,	
	 				"width":"40%",
	 				"render": function (data, type, row) {
	 					if(data) {
	 						return '<div style="overflow:hidden;" title="'+data+'">'+data+'</div>';
	 					}
	 					return "";
	 				}
	 			}]
	 		});
	 	};
	 	queryZPHisTask();
		</c:if>
		
		$("#orgNames").on("click", function() {
			orgDivTree = $.fn.zTree.init($("#orgDivTree"), orgAllLoadsetting);
			$("body").unbind("mousedown");
			if ($("#orgDiv").is(":hidden")) {
				$("#orgDiv ul").width(500).height(150);
				$("#orgDiv").css({
					top : "30px"
				}).fadeIn("fast", function() {
					orgDivTree = !orgDivTree ? $.fn.zTree.init($("#orgDivTree"), orgAllLoadsetting) : orgDivTree;
					$("#orgTreeKey").val("");
					idFuzzySearch("orgDivTree", "#orgTreeKey", false, false);
					asyncForAll = false;
					asyncAll();
					setTimeout(function(){
						bindOrgTreeEvent();
					}, 1000);
				});
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
			
		            <div class="ibox-content">
                       <form id="editForm" action="${ctx}/jsp/work/subXiezuo4ZC.do"  method="post" class="form-horizontal key-13" >
			                  <input type="text" id="id" name="id" style="display:none"/>
			                  <input type="text" id="pid" name="pid" style="display:none"/>
			                  <input type="text" id="flag" name="flag" style="display:none"/>
			                  <input type="text" id="taskId" name="taskId" style="display:none"/>
			                  <input type="text" id="taskName" name="taskName" style="display:none"/>
			                  <input type="text" id="org_id" name="org_id" style="display:none"/>
			                  <input type="text" id="executor_phone" name="executor_phone" style="display:none"/>
			                  <div class="dataForm">
							  <div class="form-group">	
							   		 <label class="col-sm-2 control-label">工单主题</label>
									    <div class="col-sm-4">
								    	<input class="input-sm form-control validate[required]"  name="title" id="title"/>
								    </div>
								    <label class="col-sm-1 control-label">工单编号</label>
								    <div class="col-sm-4">
								    	<input class="input-sm form-control validate[required] readonly" name="form_code" id="form_code"/>
								    </div>
							   </div>
							  <div class="form-group">
								  <label class="col-sm-2 control-label">区县</label>
								    <div class="col-sm-4">
								    	<input type="text" class="input-sm form-control readonly"  name="county_name" id="county_name" readonly>
								    	<input type="text" class="hide" name="county" id="county" >
								    </div>
							  
							    <label class="col-sm-1 control-label">分局</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control readonly"  name="branch_office_name"  id="branch_office_name" readonly>
							    	<input type="text" class="hide" name="branch_office" id="branch_office" >
							    </div>
							  </div>
		
							  <div class="form-group">
							    <label class="col-sm-2 control-label">发起人</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control readonly"  name="publisher" id="publisher" readonly>
							    </div>
							    <label class="col-sm-1 control-label">发起时间</label>
							    <div class="col-sm-4">
							    	<input type="text"  readonly="readonly"  class="input-sm  form-control readonly"  name="publish_time" id="publish_time" >
							    </div>
							  </div>
		
							  <div class="form-group">
							    <label class="col-sm-2 control-label">联系方式</label>
							    <div class="col-sm-4">
							     	<input type="number" class="input-sm form-control readonly"   readonly name="user_phone" id="user_phone" >
							    </div>
							    <label class="col-sm-1 control-label">工单类型</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control " id="service_type_name" name="service_type_name" />
							    	<input type="text" class="hide " id="service_type" name="service_type" />
							    </div>
							  </div>
							
							  <div class="form-group">
							  	 <label class="col-sm-2 control-label">完成时限</label>
							    <div class="col-sm-4">
							    	<input type="text"  readonly="readonly" disabled="disabled"  class="input-sm  readonly form-control date_time" format="yyyy-MM-dd"  name="finish_date" id="finish_date" >
							    </div>
							  </div>
							
							  <div class="form-group">
							    <label  class="col-sm-2 control-label">描述说明</label>
							    <div class="col-sm-9">
							      <textarea rows="5" class="form-control " name="description" id="description" ></textarea>
							    </div>
							  </div>
							  </div>
							<div id="filesAndOpinion"></div>
							   <div id="opinion" class="hide">
							   <fieldset>
							   	<legend>我的回复</legend>
							   	<div class="form-group">
								  	<label  class="col-sm-2 control-label">处理结果</label>
								    <div class="col-sm-4">
									  <select name="result" id="result"  class="form-control">
									  	 <c:if test="${param.taskName ne '协作支撑'}">
									  	 	<option value="回复">回复</option>
									  	 	<option value="驳回">驳回</option>
									  	 </c:if>
									  </select>
									 </div>
								  </div>
							   </fieldset>
								</div>
								<div id="yijian" class="hide">
								  <div class="form-group">
								    <label  class="col-sm-2 control-label">意见</label>
								    <div class="col-sm-8">
								      <textarea rows="5" rows="5" class="form-control phrase_" name="desc" id="desc" ></textarea>
								    </div>
								    <a id="addPhrase"><i class="fa fa-plus" style="margin-top: 18px;">设为常用语</i></a>
								  </div>
							  </div>
							  <div id="fileUpload" class="hide">
								  <%-- <c:if test="${param.taskName eq '协作支撑'}"> --%>
								  	<div class="form-group">
								   	<label  class="col-sm-2 control-label">文件上传</label>
								    <div class="col-sm-9">
								    	<input type="file" class="input-sm form-control" multiple name="file" id="file" >
								    </div>
								   </div>	
								  <%-- </c:if> --%>
							  </div>
							  <c:if test="${param.taskName eq '协作支撑'}">
							  <fieldset>
						   	<legend>转派详情</legend>
							   <table id="zp_datas" class="table display" style="width:100%">
				                  <thead>
				                      <tr>
										<th>开始时间</th>
										<th>结束时间</th>
										<th>转派机构</th>
										<th>转派角色</th>
										<th>处理状态</th>
										<th>处理人</th>
										<th>结果</th>
										<th>意见</th>
				                      </tr>
				                  </thead>
				              </table>
				              </fieldset>
							  <div id="sub1" class="sub">
							  <hr>
							  <input name="action" id="action" value="归档" class="hide"/>
								   <div class="form-group">
									   	<label  class="col-sm-2 control-label">处理结果</label>
									   	<div class="col-sm-4">
										   	 <input type="radio" class="action" name="zccljg" value="归档"  checked="checked"/>归档
										   	 <input type="radio" class="action" name="zccljg" value="重发" />重发
									  	</div>
								  </div>
								  <div class="form-group">
										<label  class="col-sm-2 control-label">处理意见</label>
										<div class="col-sm-9">
											 <textarea rows="5" class="col-sm-9" name="handling_suggestion" maxlength="200"></textarea>
										</div>
								  </div>
								  <!-- <div class="form-group">
										<label class="col-xs-2 control-label">附件：</label>
										<div class="col-xs-9 control-label" id="fileList1" style="text-align: left;">
										</div>
								  </div> -->
								  <div id="zhuanpai" class="form-group hide">
								  	<label class="col-sm-2 control-label">机构指配</label>
										    <div class="col-sm-4">
										      <input type="text" class="input-sm form-control" name="orgNames" id="orgNames" readonly="readonly" >
										      <input type="text" name="orgIds_" id="orgIds" class="input-sm form-control" style="display:none" >
										      <div id="orgDiv" style="display:none;position:absolute;z-index:8888">
												<input type="text" class="input-sm form-control" id="orgTreeKey" placeholder="输入机构代码进行搜索" />
												<ul id="orgDivTree" class="ztree divTree">
												</ul>
											  </div>
						    				</div> 
			                		 <label  class="col-sm-1 control-label">指定角色</label>
								    <div class="col-sm-4">
								    	<select name="roleNames_" id="roleNames_" class="form-control">
								    	</select>
									 </div>
								  </div>
							  </div>
							  </c:if>
							  
							   <div class="form-group">
								   	<div class="col-sm-9 col-sm-offset-2">
								   		<button type="button" class="btn btn-sm btn-success btn-13" id="btn-ok">
						                	<i class="fa fa-check"></i> 确定
						                </button>
								   	</div>
							   </div>
							</form>
			            </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>