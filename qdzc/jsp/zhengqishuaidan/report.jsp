<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%> 
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script src="${ctx}/js/WdatePicker.js"></script>
<script>
	var querySpecialAll = "${ctx}/jsp/work/queryGovEntAgencyReportData.do";	
	var queryOrgAll = "${ctx}/jsp/work/queryGovEntAgencyOrgAll.do"; 
	var exportUrl="${ctx}/jsp/work/exportReportDataDetail.do";//导出	
	var querySpecialId=host_+"/api/jbpm/taskInfo.do?flag=4&token=${token}";//查看详情
	
	var table;
	var sysId = "${myUser.user.extMap.sys.id}";
	sysId=""==sysId?"${myUser.user.sysId}":sysId;
	
	$(window).ready(function() {
		
		$("#startTime").val(getNowFormatDate()),
		$("#endTime").val(getNowFormatDate()),
		
		  $.ajax({
	 	        url : queryOrgAll,
	 	        async : false,
	 	        type : "GET",
	 	       	dataType : "json",
	 	        data :{"A":"A"}, 
	 	        // 获得区县	
	 	        success :  function(data){ 
	 	        	var isNullSamoleList1=data.COUNTY;    
	 	       		 var	str1="<option value='-1'>请选择区县</option>";
	 	         	for (var i = 0; i < data.COUNTY.length; i++) { 
	 	         		var obj=data.COUNTY[i];
						str1+="<option value='"+obj.ID+"'>"+obj.ORG_NAME+"</option>"; 
					} 
	 	        	$("#COUNTY").html(str1);
	 	        	 
	 	        	
	 	        	var	str2="<option value='-1'>请选择分局</option>";
	 	        	 for (var i = 0; i < data.BRANCH_OFFICE.length; i++) {
	 	        		var obj=data.BRANCH_OFFICE[i];
	 	        		str2+="<option value='"+obj.ID+"'>"+obj.ORG_NAME+"</option>";
					}  
	 	        	$("#BRANCH_OFFICE").html(str2);  
	 	        	
	 	        	
	 	        },
	 	        error : function() {
	 	        	layer.msg("获得区县失败！", {icon: 1});
	 	        },
	 	        dataType : "json"
	 	    }); 
		  
		  
		 table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": true, 
			"autoWidth": false,
			"processing": true,
			"serverSide": false,	
			"StateSave":true, 
			"ajax": { 
				"dataSrc": "Rows",
				"type":"post",
				"url": querySpecialAll,
				"data":{ 
					/* "zxgdCont": $("#zxgdCont").val(),
					"COUNTY" : $("#COUNTY").val(),
					"BRANCH_OFFICE" :  $("#BRANCH_OFFICE").val(),
					"work_statis" :  $("#work_statis").val(),
					"startTime" :  $("#startTime").val(),
					"endTime" : $("#endTime").val() */
				 
					 
				} 
			},
			//"aaSorting": [[ 4, "ASC" ]],
			"aoColumnDefs": [ {
				"bSortable": false,
				"aTargets": [ 0 ,1,2,3,4,5,6,7,8,9, 10 ]
			}, {
				"targets": [ 0 ],
				"data":"FORM_CODE"
			}, {
				"targets": [ 1 ],
				"data":"TITLE"
			}, {
				"targets": [ 2 ],
				"data":"DICT_NAME"
			}, {
				"targets": [ 3 ],
				"data":"DICT_NAME1"
			}, {
				"targets": [ 4 ],
				"data":"state_"
			}, {
				"targets": [ 5 ],
				"data":"start_"
			}, {
				"targets": [ 6 ],
				"data":"end_"
			}, {
				"targets": [ 7 ],
				"data":"county_name"
			}, {
				"targets": [ 8 ],
				"data":"office_name"
			},{
				"targets": [ 9 ],
				"data":"channel_name"
			},{
				"targets": [ 10 ],
				"data":"USER_PHONE"
			}, {
				"targets": [ 11 ],
				"render": function (data, type, row) {
					return '<a   href="javascript:showList(\''+row['pid']+'\')">详情</a>'; 
				}
			}]
		});
	      
		$("#btn-empty").on("click",function(){
			$("#zxgdCont").val(null);
			$("#COUNTY").val('-1');
			$("#BRANCH_OFFICE").val('-1');
			$("#work_statis").val('-1');
			$("#startTime").val(null);
			$("#endTime").val(null)
			 
		});
		
		$("#btn-query").on("click", function() {
		 
				var param = {
						"zxgdCont": $("#zxgdCont").val(),
						"COUNTY" : $("#COUNTY").val(),
						"BRANCH_OFFICE" :  $("#BRANCH_OFFICE").val(),
						"work_statis" :  $("#work_statis").val(),
						"startTime" :  $("#startTime").val(),
						"endTime" : $("#endTime").val()
				}; 
				table.api().settings()[0].ajax.data = param;
				table.api().ajax.reload();
			 
	   	});
		
		
	
		$("#exportData").on("click", function() {
			if($("#gdcyHead").html()=='未完成') {
				layer.msg("请完成抽样处理！", {icon: 0});
				return;
			} 
			//获得区县的值BRANCH_OFFICE
			//COUNTY
			var COUNTY_NAME="";
			var BRANCH_OFFICE_NAME="";
			if("-1"==($("#COUNTY").val()+"")){
				COUNTY_NAME="全部";
			}else{				
				COUNTY_NAME=$("#COUNTY").find("option:selected").text()
			}
			if("-1"==($("#BRANCH_OFFICE").val()+"")){
				BRANCH_OFFICE_NAME="全部";
			}else{				
				BRANCH_OFFICE_NAME=$("#BRANCH_OFFICE").find("option:selected").text();
			}

			location.href = exportUrl+'?COUNTY_NAME='+COUNTY_NAME+'&BRANCH_OFFICE_NAME='+BRANCH_OFFICE_NAME+'&endTime='+($("#endTime").val()+"")+"&startTime="+($("#startTime").val()+"")+"&work_statis="+$("#work_statis").val()+"&BRANCH_OFFICE="+$("#BRANCH_OFFICE").val()+"&COUNTY="+$("#COUNTY").val()+"&zxgdCont="+($("#zxgdCont").val()+"");
		});
	
	});
	
	function showList(pId) {  
		document.getElementById('iframeList').src=querySpecialId+"&pId="+pId;		
		$("#myModal").modal("show");
		setTimeout(function(){
			$(".modal-backdrop.in").remove();
		},1000);
	}
	function colosList() {
		$("#myModal").modal("hide");
	}
	
	
	//获得时间
	function getNowFormatDate() {
	    var date = new Date();
	    var seperator1 = "-";
	    var year = date.getFullYear();
	    var month = date.getMonth() + 1;
	    var strDate = date.getDate();
	    if (month >= 1 && month <= 9) {
	        month = "0" + month;
	    }
	    if (strDate >= 0 && strDate <= 9) {
	        strDate = "0" + strDate;
	    }
	    var currentdate = year + seperator1 + month + seperator1 + strDate;
	    return currentdate;
	}
</script>
</head>
<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
                	<c:if test="${'mywork' ne param.page}">
	   					<div class="ibox-title">
		                    <h5><c:choose>
		                    		<c:when test="${'all' ne param.flag}">
		                    			<i class="fa fa-flag"></i> 政企甩单
		                    		</c:when>
		                    		<c:otherwise>
		                    			<i class="fa fa-tasks"></i> 实例列表
		                    		</c:otherwise>
		                    	</c:choose>
		                    </h5>
	                    	<div class="ibox-tools">
		                        <a class="a-reload">
		                            <i class="fa fa-repeat"></i> 刷新
		                        </a>
		                        <!-- <a class="collapse-link">
		                            <i class="fa fa-chevron-up"></i>
		                        </a>
		                        <a class="close-link">
		                            <i class="fa fa-times"></i>
		                        </a> -->
		                    </div>
		                </div>
	                </c:if>

                    <div class="ibox-content">
                        <!-- search star -->
						<div class="form-horizontal clearfix key-13">	
							<div class="col-sm-6 form-inline" style="padding-right:0; text-align:right">
			 <form id="queryForm" class="form-horizontal key-13"  >								
 				<!-- 查询条件start -->
 				  <div class="form-group"  >
 				  <!-- 集团/工单号 -->
 				  <br>
 				  <table   style="width: 100%;height:50px;m">
 				  <tr >
 				  <td><input type="text" class=" form-control " name="zxgdCont" id="zxgdCont" placeholder="请输入工单号"></td><td>&nbsp;</td><td>&nbsp;</td>
 				  <td>&nbsp;</td><td>&nbsp;</td>
 				  <td><input  onclick="WdatePicker({maxDate:'#F{$dp.$D(\'endTime\')}',maxDate:'%y-%M-%d'})" type="text" 
  		class="form-control date_picker " name="startTime"  id="startTime"  placeholder="yyyy-MM-dd" format="yyyy-MM-dd"> </td><td>&nbsp;</td><td>&nbsp;</td>
  					<td>——</td>
 				  <td><input  onclick="WdatePicker({minDate:'#F{$dp.$D(\'startTime\')}',maxDate:'%y-%M-%d'})" type="text"   
		class="form-control date_picker " name="endTime" id="endTime"   placeholder="yyyy-MM-dd" format="yyyy-MM-dd"> </td><td>&nbsp;</td><td>&nbsp;</td>
 				  <td><select class="  form-control" name="COUNTY" id="COUNTY">  </select></td><td>&nbsp;</td><td>&nbsp;</td>
 				  <td><select class="  form-control" name="BRANCH_OFFICE" id="BRANCH_OFFICE"> </select></td><td>&nbsp;</td><td>&nbsp;</td> 				  
				<td>&nbsp;</td><td>&nbsp;</td>
			  	<td>
						<select class="  form-control" name="work_statis" id="work_statis">
							<option value="">选择状态</option> 
							<option value="active">流程中</option>
							<option value="ended">已归档</option>
						</select> 
				</td><td>&nbsp;</td><td>&nbsp;</td>
				<td>
					 <button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
										<i class="fa fa-search"></i> 查询	
									</button>
				</td><td>&nbsp;</td><td>&nbsp;</td>
				<td>
					<button id="btn-empty" type="button" class="btn btn-sm btn-success">
										<i class="fa fa-refresh"></i> 重置
									</button>
				</td><td>&nbsp;</td><td>&nbsp;</td>
				<td>
					<button id="exportData" type="button" class="btn btn-sm btn-success">
										<i class="fa fa-download"></i> 导出
									</button>
				</td>
 				  </tr>
 				  </table>
 				  
 				  <br>
 				  <br>	                

	 </form>
							</div>
						</div>
						<!-- search end -->
                        
                        <table id="datas" class="table display" style="width:100%">
                            <thead>
                                <tr> 
									<th>工单编号</th>
									<th>工单主题</th>
									<th>业务大类</th> 
									<th>业务小类</th>
									<th>状态</th>
									<th>发布时间</th>
									<th>归档时间</th>
									<th>区县</th>
									<th>分局</th>
									<th>渠道名称</th>
									<th>用户手机号</th>
                                </tr>
                            </thead>
                        </table> 
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="modal fade" id="myModal" tabindex="-1" role="dialog"  style="margin: 0 auto">
	    <div  style="width:80%; height:800px">
	        <div class="modal-content ibox" >
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-random "></i> 工单详情</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
        	    	<iframe id="iframeList" width="100%" height="640px"  ></iframe>
		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13"  style=" float: right;" onclick="colosList()">
		                	<i class="fa fa-check" ></i> 确定
		                </button>  
		            </div>
	        </div>
	</div>
</div>
</body>
</html>