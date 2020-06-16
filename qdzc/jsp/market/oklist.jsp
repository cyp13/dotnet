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
	var updateMarketARTICLE_SWITCH = "${ctx}/jsp/market/updateMarketARTICLE_SWITCH.do";
	
	
	var table;
	var queryOrgAll = "${ctx}/jsp/work/queryOrgAll.do";
	var queryOrgAll = "${ctx}/jsp/work/queryOrgAll.do"; 
	var exportUrl="${ctx}/jsp/work/exportSample.do";//导出
	
	var querySpecialId=host_+"/api/jbpm/taskInfo.do?flag=4&token=${token}";//查看详情

	var token='${param.token}';
	var sysId='${myUser.sysId}';
	  
	
	$(window).ready(function() {
		$("#STARTTIMEMOFIFIED").val(getNowFormatDate()),
		$("#ENDTIMEMOFIFIED").val(getNowFormatDate()),
			$.ajax({
				url: '${ctx}/jsp/sys/queryDict.do',
				data: {
					parentId: 'jdztype'
				},
				type: 'post',
				dataType: 'json',
				async: false,
				success: function(data){ 
					
					var rows = data['Rows'];   
				 	var html = "<option value='-1'>请选择类型</option>"; 
					for(var key in rows){ 
						option = rows[key]; 
						html +='<option value="'+option['dictValue']+'">'+option['dictName']+'</option>'; 
					} 
					
					$('#ARTICLE_TYPE').html(html); 
					
				}
			}); 
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
			"order":[[2,"desc"]],
			"serverSide": false,	
			"StateSave":true, 
			"ajax": { 
				"dataSrc": "Rows",
				"type":"post",
				"url": querySpecialAll,
				"data":{
					"STATUSIS":'0',
					"STARTTIMEMOFIFIED":$("#STARTTIMEMOFIFIED").val(),
					"ENDTIMEMOFIFIED":$("#ENDTIMEMOFIFIED").val(),
					"sysId":sysId,
					"token":token
				} 
			},
			"aaSorting": [[ 2, "desc" ]],//设置默认排序列
			"aoColumnDefs": [ {
				"bSortable": false,
				"aTargets": [ 0 , 1 , 2 , 3 , 4 , 5 , 8 , 9 , 10 ]//不可排序列
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
				"data":"MOFIFIED",
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
				"data":"LIKECOUNT",
				"render": function (data, type, row) {
					if('1'==row.STATUS){
						return "-";	
					}else{
					return data;
					}
				}
			}, {
				"targets": [ 7 ],
				"data":"COMMENTCOUNT",
				"render": function (data, type, row) {
					if('1'==row.STATUS){
						return "-";	
					}else{
					return data;
					}
				}
			}, {
				"targets": [ 8 ],
				"data":"STATUS",
				"render": function (data, type, row) {
					 if('0'==data){
						return "审核中";
					 }else if('1'==data){
						return '<i class="fa fa-window-close " aria-hidden="true" style="color:red"></i><span style="color:red">未通过</span>';					 
					 }else if('2'==data){
						return '<i class="fa fa-check-circle " aria-hidden="true" style="color:green"></i><span style="color:green">已通过</span>';					 
					 }
				}
			}, {
				"targets": [ 9 ],
				"data":"ARTICLE_SWITCH",
				"render": function (data, type, row) {
					 if('1'==row.STATUS){
						 return "-";	 
					 }else{
						 if('0'==data){  
							 return "上架";
						 }else if('1'==data){ 
							return "下架";					 
						 }
					 }
				}
			}, {
				"targets": [ 10 ],
				"render": function (data, type, row) {
					var a ='<a href="${ctx}/jsp/market/view.jsp?id='+encodeURI(row['ID'])+'&flag=2">详情</a>'
					var b ='';
					if('2'==row.STATUS){
						if('0'==row.ARTICLE_SWITCH){
							b ='<a   href="javascript:showList(\''+row['ID']+'\',1)">下架</a>'
						}else{
							b ='<a   href="javascript:showList(\''+row['ID']+'\',0)">上架</a>'
							
						}
					}
					
					return a+"&nbsp;&nbsp;&nbsp;"+b; 
				}
			}]
		});

		
		$("#btn-query").on("click", function() {
		 		var param = {
						"ARTICLE_TITLEORCREATER": $("#ARTICLE_TITLEORCREATER").val(),
						"STATUSIS":'0',
						"sysId":sysId,
						"token":token, 
						"COUNTY" : $("#COUNTY").val(),
						"BRANCH_OFFICE" :  $("#BRANCH_OFFICE").val(),
						"ARTICLE_SWITCH" :  $("#ARTICLE_SWITCH").val(),
						"STATUS" :  $("#STATUS").val(),
						"STARTTIMEMOFIFIED" :  $("#STARTTIMEMOFIFIED").val(),
						"ENDTIMEMOFIFIED" : $("#ENDTIMEMOFIFIED").val(),
						"ARTICLE_TYPE":$("#ARTICLE_TYPE").val()
				}; 
				table.api().settings()[0].ajax.data = param;
				table.api().ajax.reload();
			 
       	});
		$("#ARTICLE_SWITCH").attr("disabled", true);
		//防止出现未通过，并且选择上下架
		$("#STATUS").on("change",
				function() {  
				  if ($(this).val() == "2") {//通过
				   	$("#ARTICLE_SWITCH").attr("disabled", false); 
				  }else{
					$("#ARTICLE_SWITCH").val("-1");
					$("#ARTICLE_SWITCH").attr("disabled", true); 
				  }
				}); 
		 
	});
	//清除
	function clean() { 
		$("#ARTICLE_TITLEORCREATER").val(null), 
		$("#COUNTY").val('-1'),
		$("#BRANCH_OFFICE").val('-1'),
		$("#ARTICLE_SWITCH").val('-1'),
		$("#STATUS").val('-1'),
		$("#STARTTIMEMOFIFIED").val(getNowFormatDate()),
		$("#ENDTIMEMOFIFIED").val(getNowFormatDate()),
		$("#ARTICLE_TYPE").val('-1')
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
	
	
	function showList(id,article_switch) {      
		$.ajax({
 	        url : updateMarketARTICLE_SWITCH,
 	        async : false,
 	        type : "POST",
 	       	dataType : "json",
 	        data :{"ID":id,"ARTICLE_SWITCH":article_switch},  
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
 	        	layer.msg("上下架失败！", {icon: 1});
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
		                    			<i class="fa fa-flag"></i> 已审批
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
						 			 
						 				  <input type="text" class=" form-control " name="ARTICLE_TITLEORCREATER" id="ARTICLE_TITLEORCREATER"   placeholder="请输入宣传标题或发起人">
						 				  <label>&nbsp;&nbsp;&nbsp;&nbsp;</label>
						 			  		<button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
												<i class="fa fa-search"></i> 查询	
											 </button>
											  <label>&nbsp;</label>
											  <a onclick="clean()"   style="color: blue">清除</a>　
							 			 
									 </div> 
									 <br> <br> 	
							        <div class="form-group" style="float: left;margin-top: 10px">
						 			 
						 				<input  onclick="WdatePicker({maxDate:'#F{$dp.$D(\'ENDTIMEMOFIFIED\')}',maxDate:'%y-%M-%d'})" type="text" 
  		class="form-control date_picker " name="STARTTIMEMOFIFIED"  id="STARTTIMEMOFIFIED"  placeholder="yyyy-MM-dd" format="yyyy-MM-dd"> 
							 			  －
							 			 <input  onclick="WdatePicker({minDate:'#F{$dp.$D(\'STARTTIMEMOFIFIED\')}',maxDate:'%y-%M-%d'})" type="text"   
		class="form-control date_picker " name="ENDTIMEMOFIFIED" id="ENDTIMEMOFIFIED"   placeholder="yyyy-MM-dd" format="yyyy-MM-dd">
		
										<select class="  form-control" name="ARTICLE_TYPE" id="ARTICLE_TYPE" > </select>
										<select class="  form-control" name="COUNTY" id="COUNTY">  </select>
										<select class="  form-control" name="BRANCH_OFFICE" id="BRANCH_OFFICE"> </select>
										
										<select class="  form-control" name="STATUS" id="STATUS" >
											<option value="-1">选择审核状态</option> 
											<option value="1">未通过</option> 
											<option value="2">已通过</option>  
										</select>
										
										<select class="  form-control" name="ARTICLE_SWITCH" id="ARTICLE_SWITCH">
											<option value="-1">选择上下架状态</option> 
											<option value="0">上架</option> <!--  0  -->
											<option value="1">下架</option> <!--  1  --> 
										</select> 
									 </div> 
									 
				　
					 	</form>
					 	
							</div>
						</div>
						<!-- search end -->
                        <br> 
                        <table id="datas" class="table display" style="width:100%">
                            <thead>
                                <tr> 
									<th>标题</th>
									<th>发布人</th>
									<th>审核时间</th>
									<th>业务类型</th> 
									<th>区县</th>
									<th>分局</th> 
									<th>评论数</th>
									<th>点赞数</th> 
									<th>审核状态</th>
									<th>上下架状态</th> 
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