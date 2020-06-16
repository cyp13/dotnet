<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<jsp:include page="/jsp/apply/xiezuoBase.jsp"></jsp:include>
<script>
var queryUrl = "${ctx}/jsp/work/queryGovernmentResources.do";

var queryTaskHisUrl = host_+"/api/jbpm/queryHisTask.do";
var queryGovernmentResourcesHisUrl = "${ctx}/jsp/work/queryGovernmentResourcesExt.do";
var pid = '${param.pId}';

var downloadUrl = host_+"/api/sys/downloadFile.do";

var table;
var zpTable;

 	$(window).ready(function() {
 		//默认不能编辑
 		$(".dataForm input,.dataForm textarea").attr('disabled','disabled');
 		$(".dataForm select,.dataForm input[type='radio']").attr('disabled','disabled');
 		
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
					getOpinionsAndFiles(row.opinions,"#filesAndOpinion",1);
				}
				if(row.ext2){
					$("#zpry").removeClass("hide");
				}
				if(row.tag_ifsuccess){
					$("#tag").removeClass("hide");
				}
			});
		}
		
 	});
 	
 	var queryHisTask = function() {
 		table = $("#datas").dataTable({
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
 				"dataSrc": "datas",
 				"url": queryTaskHisUrl,
 				"data": function (d) {
 					return $.extend( {}, d, {
 						"pId" : "${param.pId}",
 						"token":token_,
 						"sysId":sysId_
 					});
 				}
 			},
 			"aaSorting": [],
 			"aoColumnDefs": [ {
 				"bSortable": false
 				
 			},  {
 				"targets": [ 0 ],
 				"data":"create",
 				"render": function (data, type, row) {
 					return data;
 				}
 			}, {
 				"targets": [ 1 ],
 				"data":"end",
 				"render": function (data, type, row) {
 					return data ? data : "";
 				}
 			}, {
 				"targets": [ 2 ],
 				"data":"userAlias",
 				"orderable":false,
 				"render": function (data, type, row) {
 					var desc = row.desc;
 					if(desc&&desc.indexOf("会签")>-1){
 						var arr = desc.split("-");
 						if(arr.length>2){
 							return arr[2];
 						}else{
 							var userAlias = row.userAlias ? row.userAlias : row.assignee;
 		 					return userAlias ? userAlias : "";
 						}
 					}else{
	 					var userAlias = row.userAlias ? row.userAlias : row.assignee;
	 					return userAlias ? userAlias : "";
 					}
 				}
 			}, {
 				"targets": [ 3 ],
 				"data":"result",
 				"orderable":false,
 				"render": function (data, type, row) {
 					if('不同意' == data || '回退' == data || '驳回' == data || '终止' == data || '结束' == data || '撤回' == data || '驳回归档' == data) {
 						return "<span style='color:#FF0000'>"+data+"</span>";
 	                }
 					return data ? data : "";
 				}
 			}, {
 				"targets": [ 4 ],
 				"data":"desc",
 				"orderable":false,	
 				"width":"40%",
 				"render": function (data, type, row) {
 					if(data) {
 						if(row.activityName=="协作人员"&&data.indexOf("会签")>-1){
 	 						var arr = data.split("-");
 	 						if(arr.length==4){
 	 							return '<div style="overflow:hidden;" title="'+arr[3]+'">'+arr[3]+'</div>';
 	 						}
 	 					}else{
	 						return '<div style="overflow:hidden;" title="'+data+'">'+data+'</div>';
 	 					}
 					}
 					return "";
 				}
 			}]
 		});
 	}
 	
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
			
		            <div class="ibox-content">
                       <form id="editForm"  class="form-horizontal key-13" >
			                  <input type="text" id="id" name="id" style="display:none"/>
			                  <div class="dataForm">
								  <div class="form-group">
							   		 <label class="col-sm-2 control-label">工单类型</label>
								    <div class="col-sm-4">
								    	<input class="input-sm form-control validate[required]" readonly="readonly" value="政企资源业务工单"  name="form_type" id="form_type"/>
								    </div>
								    <label class="col-sm-1 control-label">工单编号</label>
								    <div class="col-sm-4">
								    	<input type="text" class="input-sm form-control "  name="form_code" id="form_code" readonly>
								    </div>
							   </div>
							  <div class="form-group">
								  <label class="col-sm-2 control-label">发起时间</label>
								    <div class="col-sm-4">
								    	<input type="text" class="input-sm form-control " name="created"  id="created" readonly>
							    </div>
							  </div>
		
							  <div class="form-group">
							   		 <label class="col-sm-2 control-label">发起人</label>
								    <div class="col-sm-4">
								    	<input class="input-sm form-control validate[required]"  name="originator" id="originator" readonly>
								    </div>
								    <label class="col-sm-1 control-label">发起人所属机构</label>
								    <div class="col-sm-4">
								    	<input type="text" class="input-sm form-control "  name="organization_name"id="organization_name" readonly>
								    </div>
							   </div>
		
							  <div class="form-group">
								    <label class="col-sm-2 control-label">发起人联系方式</label>
								    <div class="col-sm-4">
								     	<input type="number" class="input-sm form-control validate[required]" title="请确认您的个人信息中移动电话是否填写！" readonly name="originator_phone" id="originator_phone" >
								    </div>
								    <label class="col-sm-1 control-label">发起人机构编码</label>
								    <div class="col-sm-4">
								    	<input type="text" class="input-sm form-control " name="organization_code" id="organization_code"  readonly>
								    </div>
							  </div>
							  <div class="form-group">
							  	<label class="col-sm-2 control-label">业务小类</label>
							  	<div class="col-sm-4">
								  	<select class="form-control validate[required]" name="bussiness_small_type" id="bussiness_small_type">
								  		<option value="">请选择类型</option>
								  		<option value="开户">开户</option>
								  		<option value="移机">移机</option>
								  	</select>
							  	</div>
								 <!--  专线号 -->
								 <div id="specialnumber" style="display:none">
								 	<label class="col-sm-1 control-label">专线号</label>
								 	<div class="col-sm-4">
								 		<input type="text" class="input-sm form-control validate[required]" name="special_number" placeholder="请输入专线号" maxlength="11">
								 	</div>
								 </div>
							  </div>
	
			 				 <div class="form-group">
						    <!--集团单位名称-->
							    <label class="col-sm-2 control-label ">集团单位名称</label>
							    <div class="col-sm-4">
							        <input type="text" maxlength="30" class="input-sm form-control validate[required]" name="group_name" maxlength="30" placeholder="请输入30字以内得集团名称">
							    </div>
							    <label class="col-sm-1 control-label">集团编码</label>
							    <div class="col-sm-4">
							    	<input type="text" maxlength="11" class="input-sm form-control" name="group_coding" placeholder="请输入集团编码">
							    </div>
							</div >
							
							 <div class="form-group">
							 	<!--装机地址-->
							    <label class="col-sm-2 control-label ">装机地址</label>
							    <div class="col-sm-1">
							        <input type="text" class="form-control validate[required]" name="install_address">
							    </div>
							 	<div class="col-sm-8">
							 		<input type="text" name="particular_address" class="form-control validate[required]" maxlength="50" placeholder="街道-门牌-栋号-楼层-房号"></textarea>
							 	</div>
							 </div>
							 
							 <div class="form-group">
							    <!--装机联系人-->
							    <label class="col-sm-2 control-label ">装机联系人(客户)</label>
							    <div class="col-sm-4">
							        <input type="text" maxlength="5" class="input-sm form-control validate[required]" name="install_name" placeholder="请输入装机联系人姓名">
							    </div>
						     	<!--装机联系手机-->
							    <label class="col-sm-1 control-label ">装机联系手机（客户）</label>
							    <div class="col-sm-4">
							        <input type="text" class="input-sm form-control  validate[required,custom[mobile]]" maxlength="11" name="install_phone" placeholder="请输入手机号码">
							    </div>
							</div>
								
							 <div id="zhuanpai" class="form-group">
							  	<label class="col-sm-2 control-label">客户经理所属机构</label>
									    <div class="col-sm-4">
									      <input type="text" class="input-sm form-control validate[required]" name="orgNames" id="orgNames" readonly="readonly" >
									      <input type="text" name="orgIds_" id="orgIds" class="input-sm form-control" style="display:none" >
									      <div id="orgDiv" style="display:none;position:absolute;z-index:8888">
											<input type="text" class="input-sm form-control" id="orgTreeKey" placeholder="输入机构代码进行搜索" />
											<ul id="orgDivTree" class="ztree divTree">
											</ul>
										  </div>
					    				</div> 
		                		 <label  class="col-sm-1 control-label">客户经理姓名</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control " id="customer_manager_name" name="customer_manager_name"/>
								 </div>
							  </div>
							  <div class="form-group">
							    <!--是否“和飞速”-->
							    <label class="col-sm-2 control-label ">是否“和飞速”</label>
							    <div class="col-sm-4">
							    	<label>
							        	<input type="radio" name="if_hefeisu"  value="是" checked="checked"><span style="padding: 0px 10px 0px 5px;">是</span>
							    	</label>
							    	<label>
							        	<input type="radio" name="if_hefeisu"  value="否"><span style="padding: 0px 10px 0px 5px;">否</span>
							    	</label>
							    </div> 
							</div>
								<div class="form-group">
									<label class="col-sm-2 control-label">描述说明</label>
									<div class="col-sm-9">
										<textarea rows="3" class="form-control" name="remark" id="remark" maxlength="200" placeholder="此处可填写受理业务其他说明或描述（非必填项） "></textarea>
									</div>
								</div>	
								<div id="filesAndOpinion"></div>
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