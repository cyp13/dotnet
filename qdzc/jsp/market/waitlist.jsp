<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%> 
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script src="${ctx}/js/WdatePicker.js"></script>
<script>
	var querySpecialAll = "${ctx}/jsp/market/queryMarketAll.do";
	var deleteMarket = "${ctx}/jsp/market/deleteMarket.do";
	
	
	var table;
	var queryOrgAll = "${ctx}/jsp/work/queryOrgAll.do";
	var queryOrgAll = "${ctx}/jsp/work/queryOrgAll.do"; 
	var exportUrl="${ctx}/jsp/work/exportSample.do";//导出
	
	var querySpecialId=host_+"/api/jbpm/taskInfo.do?flag=4&token=${token}";//查看详情

	var token='${param.token}';
	var sysId='${myUser.sysId}';
	
	
	$(window).ready(function() { 
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
			"order":[[2,"asc"]],
			"processing": true,
			"serverSide": false,	
			"StateSave":true, 
			"ajax": { 
				"dataSrc": "Rows",
				"type":"post",
				"url": querySpecialAll,
				"data":{  "STATUS":'0',"sysId":sysId,"token":token
				} 
			},
			"aaSorting": [[ 2, "asc" ]],//设置默认排序列 
			"aoColumnDefs": [ {
				"bSortable": false,
				"aTargets": [ 0 , 1 , 2 , 3 , 4 , 5 , 6 ] //设置表格的格子
			}, {
				"targets": [ 0 ],
				"data":"ARTICLE_TITLE",
				"render": function (data, type, row) {
					return data;
				}
			}, {
				"targets": [ 1 ],
				"data":"CREATER",
				"render": function (data, type, row) {
					return data;
				}
			}, {
				"targets": [ 2 ],
				"data":"CREATED",
				"render": function (data, type, row) {
					return data;
				}
			}, {
				"targets": [ 3 ],
				"data":"ARTICLE_TYPE_NAME",
				"render": function (data, type, row) { 
					return data;
				}
			}, {
				"targets": [ 4 ],
				"data":"COUNTY_NAME",
				"render": function (data, type, row) {
					return data; 
				}
			}, {
				"targets": [ 5 ],
				"data":"BRANCH_OFFICE_NAME",
				"render": function (data, type, row) { 
					return data;
				}
			}, {
				"targets": [ 6 ],
				"render": function (data, type, row) { 
					var a ='<a href="${ctx}/jsp/market/view.jsp?id='+encodeURI(row['ID'])+'&flag=0">详情</a>';
					var b =''; 
					if('cdadmin'==userName_){ //后面优化，现在制定过的用户
						b ='<a   href="javascript:showList(\''+row['ID']+'\')">删除</a>'
					}
					
					return a+"&nbsp;&nbsp;&nbsp;"+b; 
				}
			}]
		});

		
		$("#btn-query").on("click", function() {
		 
				var param = {
						"ARTICLE_TITLE": $("#ARTICLE_TITLE").val(),
						"STATUS":'0',
						"sysId":sysId,
						"token":token
				}; 
				table.api().settings()[0].ajax.data = param;
				table.api().ajax.reload();
			 
       	});
		
		

		 
	}); 
	
	function clean() { 
			$("#ARTICLE_TITLE").val(null);  
	}
	 
	function showList(id) {  
		  $.ajax({
	 	        url : deleteMarket,
	 	        async : false,
	 	        type : "GET",
	 	       	dataType : "json",
	 	        data :{"ID":id},  
	 	        success :  function(data){ 
					if ("error" == data.resCode) {
						layer.msg(data.resMsg, {icon: 2}); 
					} else {
						layer.msg("数据处理成功！", {icon: 1},  function() { 
							table.api().ajax.reload();
							});
					}
	 	        },
	 	        error : function() {
	 	        	layer.msg("删除文章失败！", {icon: 1});
	 	        },
	 	        dataType : "json"
	 	    }); 
		  
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
		                    			<i class="fa fa-flag"></i> 待审批
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
		                    </div>
		                </div>
	                </c:if>

                    <div class="ibox-content">
                        <!-- search star -->
						<div class="form-horizontal clearfix key-13" style=" margin-left: 10px;">
					 
	
							<div class="col-sm-12 form-inline" style="padding-right:0; text-align:right">
							 <form id="queryForm" class="form-horizontal key-13"  > 
				 				<!-- 查询条件start --> 
							        <div class="form-group" style="float: left;">
						 			 
						 				  <input type="text" class=" form-control " name="ARTICLE_TITLE" id="ARTICLE_TITLE"   placeholder="请输入宣传标题">
						 				  <label>&nbsp;&nbsp;&nbsp;&nbsp;</label>
						 			  		<button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
												<i class="fa fa-search"></i> 查询	
											 </button>
											  <label></label>
											  <a onclick="clean()"   style="color: blue">清除</a>
											<!-- <button id="btn-empty" type="button" class="btn btn-sm btn-success btn-13"  >
																	<i class="fa fa-search"></i> 重置
											</button> -->
							 			 
									 </div> 
					 	</form>
							</div>
						</div>
						<!-- search end -->
                        
                        <table id="datas" class="table display" style="width:100%">
                            <thead>
                                <tr> 
									<th>标题</th>
									<th>发布人</th>
									<th>发布时间</th>
									<th>业务类型</th> 
									<th>区县</th>
									<th>分局</th> 
									<th>操作</th>
                                </tr>
                            </thead>
                        </table>
                        
                        
 
                    </div>
                </div>
            </div>
        </div>
    </div>
 
</html>