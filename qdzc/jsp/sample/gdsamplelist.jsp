<%@page import="cn.scihi.mb.commons.util.SysConst,java.util.*,cn.scihi.dy.gongdan.help.PSetting,com.alibaba.fastjson.JSON"%>
<%@page import="cn.scihi.mb.commons.util.SysConst"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<%    
	ArrayList<Map> listMap = new ArrayList<Map>();
	Class<PSetting> pTable = PSetting.class;
	for (PSetting ps : pTable.getEnumConstants()) {
		Map mapT = new HashMap<>();
		mapT.put("pName", ps.NAME);
		mapT.put("workTable", ps.TABLE_NAME);
		mapT.put("view_url", ps.VIEW_URL); 
		listMap.add(mapT);
	}  
	String strMap=JSON.toJSONString(listMap);
%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script async="async">
var sampleListUrl="${ctx}/jsp/work/sample/querySampleList.do?token=${token}";//根据抽样id查询出抽样详细信息
var querySampleListBySampleIsNullUrl="${ctx}/jsp/work/sample/querySampleListBySampleIsNull.do?token=${token}";//根据抽样id查询未评分的pid
var updateSamoleListGradeBySampleListIdUrl="${ctx}/jsp/work/sample/updateSamoleListGradeBySampleListId.do";//根据抽样pid查询出抽样记录id
var updateSampleStatisUrl="${ctx}/jsp/work/sample/updateSampleStatis.do";//放弃抽样	
var querySamoleTableListUrl="${ctx}/jsp/work/sample/querySamoleTableList.do?token=${token}";//获得工单抬头信息  

var querySampleListIdByPidORSampleUrl = "${ctx}/jsp/work/sample/querySampleListIdByPidORSample.do?token=${token}";//获得此记录得评分

var exportUrl="${ctx}/jsp/work/sample/exportSample.do";//抽样下载
var table;
var querySampleListBySampleIsNullIndex=null;//游标
var isNullSamoleList=new Array();//未完成评分的  
var sampList=new Array()
	$(window).ready(function() {  
				/*******加载相关工单数据*****************/
				$.ajax({
					url: '${ctx}/jsp/sys/queryDict.do',
					data: {
						parentId: 'gdzj'
					},
					type: 'post',
					dataType: 'json',
					async: false,
					success: function(data){
						var rows = data['Rows'];
						for (var i = 0; i < rows.length; i++) {
							var obj = rows[i];
							var objAdd=new Object();
							objAdd.pName=obj.dictType;
							objAdd.workTable=obj.dictName;
							objAdd.view_url=qdzc_+obj.dictValue; 
							sampList[i]=objAdd;
						}
					}
				}); 
				/**************************************/
				
				//获得没有评分得数据
		 	    $.ajax({
		 	        url : querySampleListBySampleIsNullUrl,
		 	        async : false,
		 	        type : "GET",
		 	       	dataType : "json",
		 	        data :{'SAMPLEID':'${param.SAMPLEID}'}, 
		 	        // 成功后开启模态框	
		 	        success :  function(data){  
		 				if ("error" == data.resCode) {
		 					layer.msg(data.resMsg, {icon: 2});
		 				} else {  
		 					isNullSamoleList=data.Rows;   
		 					if(isNullSamoleList.length>0){ 
		 						$("#gdcyHead").html("未完成") 
			 					
		 					}else{
			 					$("#gdcyHead").html("已完成") 
			 					$("#FQSample").css('display','none')  

		 					}
		 					
		 					
		 				}
		 	        },
		 	        error : function() {
		 	        	layer.msg("获得未评分失败！", {icon: 1});
		 	        },
		 	        dataType : "json"
		 	    });  
 	    		//加载获得头部信息 
		 	    	getHead();  
 	    		//加载表格数据--放在加载头里面了
 	 
 	    	
			
				/* window.history.back() */
				
	 			$("#exportData").on("click", function() {
	 				if($("#gdcyHead").html()=='未完成') {
	 					layer.msg("请完成抽样处理！", {icon: 0});
	 					return;
	 				}
	 				location.href = exportUrl+"?SAMPLEID=${param.SAMPLEID}";
	 			});
	 			$("input[name='GRADE']"). on("click", function() {
 				 	if(Number(this.value)!=5){
 				 		$("#EXT3").removeClass('form-control');
 				 		$("#EXT3").addClass('form-control validate[required]');
 				 	}else{
 				 		$("#EXT3").removeClass('form-control validate[required]');
 				 		$("#EXT3").addClass('form-control');
 				 	}
 				 
 				}); 
 	    		
 	    		
 
	});
	
	function tableLoadNoEnd(){
		table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": true, 
			"autoWidth": false,
			"processing": false,
			"serverSide": false,	
			//"order":[[4,"desc"],[5,"desc"]],
			"StateSave":true,
			  
			"ajax": {
				"dataSrc": "Rows",
				"type":"post",
				"url": sampleListUrl,
				"data":{"SAMPLEID":'${param.SAMPLEID}'
				}  
			},"aaSorting": [[ 6, "asc" ],[ 5, "desc" ]],
			  "aoColumnDefs": [ {
				"bSortable": false,
				"aTargets": [ 0, 1, 2, 3, 4, 5, 6 , 7]
			}, {
				"targets": [ 0 ],
				"data":"FORM_CODE"
			}, {
				"targets": [ 1 ],
				"data":"FORMTYPE"
				
			}, {
				"targets": [ 2 ],
				"data":"TITLE"
			}, {
				"targets": [ 3 ],
				"data":"ORG_NAME",
				"render": function (data, type, row) { 
		 			return data;
				}
			}, {
				"targets": [ 4 ],
				"data":"YWTYPE" 
			},{
				"targets": [ 5 ],
				"data":"CREATERTIME",
				"render": function (data, type, row) {
					 
		 			return timetrans(row.CREATERTIME);
				}
			},{
				"targets": [ 6 ],
				"data":"GRADE",
				"render": function (data, type, row) {
					if(row.GRADE==null) {  
						return '<span style="color:red ;width: 40px" >未评分<span/>';	
					} else {

						return '<span style="color:black ;width: 40px">'+row.GRADE+'分<span/>';
					}
				}
			},{
				"targets": [ 7 ],
				"render": function (data, type, row) {     
					return '<a   href="javascript:showList(\''+row['PID']+'\')">详情</a>';
				}
			}]
			
			
			
		
		});
	}
	
	function tableLoadEnd(){
		table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": true, 
			"autoWidth": false,
			//"order":[[5,"desc"],[4,"desc"]],
			"processing": true,
			"serverSide": false,	
			"StateSave":true,
			  
			"ajax": {
				"dataSrc": "Rows",
				"type":"post",
				"url": sampleListUrl,
				"data":{"SAMPLEID":'${param.SAMPLEID}'
				}  
			},"aaSorting": [[ 5, "desc" ]],
			  "aoColumnDefs": [ {
				"bSortable": false,
				"aTargets": [ 0, 1, 2, 3, 4, 5, 6 ,7 ]
			}, {
				"targets": [ 0 ],
				"data":"FORM_CODE"
			}, {
				"targets": [ 1 ],
				"data":"FORMTYPE"
				
			}, {
				"targets": [ 2 ],
				"data":"TITLE"
			},{
				"targets": [ 3 ],
				"data":"ORG_NAME",
				"render": function (data, type, row) {
					 
		 			return row.ORG_NAME+"区县";
				}
			}, {
				"targets": [ 4 ],
				"data":"YWTYPE"
				
			},{
				"targets": [ 5 ],
				"data":"CREATERTIME",
				"render": function (data, type, row) {
					 
		 			return timetrans(row.CREATERTIME);
				}
			},{
				"targets": [ 6 ],
				"data":"GRADE",
				"render": function (data, type, row) {
					if(row.GRADE==null) {  
						return '<span style="color:red ;width: 40px" >未评分<span/>';	
					} else {

						return '<span style="color:black ;width: 40px">'+row.GRADE+'分<span/>';
					}
				}
			},{
				"targets": [ 7 ],
				"render": function (data, type, row) {     
					return '<a   href="javascript:showList(\''+row['PID']+'\')">操作</a>';
				}
			}] 
		});
	}
	
	//传递工单类型，返回对应的页面查看地址
	function getSampListUrl(ptype) {
		var flag = false;
			if(ptype=="网络弱覆盖"||ptype=="5033777工单"
					||ptype=="存量宽带故障移机"){//协作工单子类型，单独判断
				flag = true;
			}
		for (var i = 0; i < sampList.length; i++) {
			var obj = sampList[i];
			if(flag&&obj.pName=="协作工单"){//协作工单子类型，单独判断
				return obj.view_url;
			}
			if(ptype==obj.pName){
				return obj.view_url;
			}
			
		}
	}
	
	//时间格式化
	function timetrans(date){
	    var date = new Date(date);
	    var Y = date.getFullYear() + '-';
	    var M = (date.getMonth()+1 < 10 ? '0'+(date.getMonth()+1) : date.getMonth()+1) + '-';
	    var D = (date.getDate() < 10 ? '0' + (date.getDate()) : date.getDate()) + ' ';
	    var h = (date.getHours() < 10 ? '0' + date.getHours() : date.getHours()) + ':';
	    var m = (date.getMinutes() <10 ? '0' + date.getMinutes() : date.getMinutes()) + ':';
	    var s = (date.getSeconds() <10 ? '0' + date.getSeconds() : date.getSeconds());
	    return Y+M+D+h+m+s;
	} 
	
	//打开模型窗体
	function showList(pId) {      
		
	//	layer.msg("数据测试："+1, {icon: 1}); 
		
		$("#btn-ok").css('display','none'); 
		$("#btn-up").css('display','none'); 
		$("#btn-down").css('display','none'); 
		$("#GRADE1").attr("disabled",false);
		$("#GRADE2").attr("disabled",false);
		$("#GRADE3").attr("disabled",false);
		$("#GRADE4").attr("disabled",false);
		$("#GRADE5").attr("disabled",false);
		$("#EXT3").attr("disabled",false);
		
		
		var obj = new Object();
		obj.url = querySampleListIdByPidORSampleUrl;
		obj.SAMPLEID = '${param.SAMPLEID}'; 
		obj.PID = pId;  
		ajax(obj, function(data) { //回显评分
			if(data.row[0].EXT3==null){
				data.row[0].EXT3='';
				data.row[0].GRADE="5";  
		 		$("#EXT3").removeClass('form-control validate[required]');
				$("#EXT3").addClass('form-control');
			}
			$("#editForm").fill(data.row[0]);  
		});

		
		if(isNullSamoleList.length!=0){ 
			querySampleListBySampleIsNullIndex= forList(pId); 
			if(querySampleListBySampleIsNullIndex==0){//代表上面没有未评分的数据
				//layer.msg("上面没有数据！"+isNullSamoleList.length, {icon: 1}); 
				if(isNullSamoleList.length==1){//代表是唯一一个元素了
					$("#btn-ok").css('display','block'); 
				}else{
					$("#btn-down").css('display','block'); 
				}
			}else if(querySampleListBySampleIsNullIndex==isNullSamoleList.length-1){//代表是最后一个元素了
				//layer.msg("下面没有数据！"+isNullSamoleList.length, {icon: 1}	);   
				if(isNullSamoleList.length==1){//代表是唯一一个元素了
					$("#btn-ok").css('display','block'); 
				}else{
					$("#btn-up").css('display','block'); 
				}
				
			}else if(querySampleListBySampleIsNullIndex==-1){
				//layer.msg("此数据已评价"+isNullSamoleList.length, {icon: 1});
					//这里需要设置单选框不可选
					//	disabled="true"
	 				$("#GRADE1").attr("disabled",true);
					$("#GRADE2").attr("disabled",true);
					$("#GRADE3").attr("disabled",true);
					$("#GRADE4").attr("disabled",true);
					$("#GRADE5").attr("disabled",true);  
					//$("#GRADE5").attr("checked",true); 
					$("#EXT3").attr("disabled",true);
				if(isNullSamoleList.length>1){
					$("#btn-down").css('display','block');
				}else{//代表此抽检已全部完成得。全是都是查看了
					 
				}
			}else{
				//layer.msg("此数据有上下页码！"+isNullSamoleList.length, {icon: 1}); 
				$("#btn-down").css('display','block'); 
				$("#btn-up").css('display','block'); 
			}
		}else{
				$("#GRADE1").attr("disabled",true);
				$("#GRADE2").attr("disabled",true);
				$("#GRADE3").attr("disabled",true);
				$("#GRADE4").attr("disabled",true);
				$("#GRADE5").attr("disabled",true);  
				//$("#GRADE5").attr("checked",true);
				$("#EXT3").attr("disabled",true);
		} 
		document.getElementById('iframeList').src= encodeURI(getSampListUrl(pId.split(".")[0])+'?token=${token}&pId='+pId)
		//如果是未完成  可以修改评分 
		$("#myModal").modal("show");
		

 
	} 
	//加载页面头
	function getHead(){
		var obj = new Object();
		obj.url = querySamoleTableListUrl;
		obj.SAMPLEID = '${param.SAMPLEID}'; 
		
		ajax(obj, function(data) {
			if ("error" == data.resCode) {
				layer.msg(data.resMsg, {icon: 2});
			} else {
				 
				if(data.row.ORG_NAME==null){
					$("#ORG_NAMExxx").html("全部");
				}else{
					$("#ORG_NAMExxx").html(data.row[0].ORG_NAME);
											}
				$("#SAMPLE_SCOPE_DATExxx").html(data.row[0].SAMPLE_SCOPE_DATE);
				$("#WORK_SUMxxx").html(data.row[0].WORK_SUM);
				$("#WORK_CREATER").html(data.row[0].CREATER);
				$("#SAMPLE_CONUTSUMxxx").html(data.row[0].SAMPLE_CONUTSUM); 
				//获得区县 
				var str= ''; 
				var stris=$("#gdcyHead").html(); 
				if(stris=='已完成'||'${param.STATIS}'==1){ 
					for(var i = 0 ;i<data.row.length;i++){
						var obj=data.row[i];
						str+=obj.FORMTYPE+":"+obj.FORMSUM +" &nbsp;&nbsp;"+"抽样数:"+obj.SAMPLESUM +" &nbsp;&nbsp;平均分：  "+obj.AVGGRADE+"&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
					}
					
					str+="&nbsp;&nbsp;&nbsp;&nbsp;总平均得分："+data.row[0].SAMPLE_GRADE; 
					;tableLoadEnd();//table.api().ajax.reload();
				}else{
					for(var i = 0 ;i<data.row.length;i++){
						var obj=data.row[i];
						str+=obj.FORMTYPE+":"+obj.FORMSUM +" &nbsp;&nbsp;"+"抽样数:"+obj.SAMPLESUM +" &nbsp;&nbsp;"
					}
					
					//DataTable.Rows.Clear()
					tableLoadNoEnd();
				 	//table.api().ajax.reload();
				} 
					$("#GDTYSUM").html(str)
			}
		});
	}
	//上一页
	function showListUp() {  
		var b = $("#editForm").validationEngine("validate");//表单验证
		if(b) { 	
			var pId=isNullSamoleList[querySampleListBySampleIsNullIndex-1].PID ;//上一页得pid
			if(querySampleListBySampleIsNullIndex!=-1){	 
				update(isNullSamoleList[Number(querySampleListBySampleIsNullIndex)].PID)
				isNullSamoleList.splice(querySampleListBySampleIsNullIndex, 1)
				
			}
			querySampleListBySampleIsNullIndex=querySampleListBySampleIsNullIndex-1;
			showList(pId)
		}
 
	} 
	
	//下一页
	function showListDown() {
		var b = $("#editForm").validationEngine("validate");//表单验证
		if(b) { 
			var pId=isNullSamoleList[Number(querySampleListBySampleIsNullIndex)+Number(1)].PID ; //下一页得pid
			if(querySampleListBySampleIsNullIndex!=-1){	 
				update(isNullSamoleList[Number(querySampleListBySampleIsNullIndex)].PID)
				isNullSamoleList.splice(querySampleListBySampleIsNullIndex, 1) 
			}
			querySampleListBySampleIsNullIndex=querySampleListBySampleIsNullIndex+1;
			showList(pId)
		}
	} 
	//确定-完成最后一个，并计算评分，同事更新页面数据
	function submitOk(){
		var b = $("#editForm").validationEngine("validate");//表单验证
		if(b) { 
	  		if(querySampleListBySampleIsNullIndex!=-1){			
				update(isNullSamoleList[Number(querySampleListBySampleIsNullIndex)].PID)
			}  
			 //关闭模拟窗体
			$("#myModal").modal("hide");
			 $("#gdcyHead").html("已完成")//这里也
			 $("#FQSample").css('display','none')//这里和上面也可以用页面刷新来处理 
			// $("#exportData").css('display','block')//这里和上面也可以用页面刷新来处理 
			// $("#exportData").css('text-align','right') 
			getHead();
		}
	}
	
	//获得当前打开的下标(数组)
	function forList(pId){ 
		for(var i in isNullSamoleList){
			if(isNullSamoleList[i].PID == pId){
				return i;//i就是下标
			}
		}
		return -1;
	}
	 
	//修改评分
	function update(pid){  	 
			 	    $.ajax({
			 	        url : updateSamoleListGradeBySampleListIdUrl,
			 	        async : false,
			 	        type : "GET",
			 	       	dataType : "json",
			 	        data : $("#editForm").serialize()+"&PID="+encodeURI(pid)+"&SAMPLEID=${param.SAMPLEID}", 
			 	        // 成功后开启模态框	
			 	        success :  function(data){  
			 				if ("error" == data.resCode) {
			 					layer.msg(data.resMsg, {icon: 2});
			 				} else {
			 					//修改数据成功-暂时不刷新页面
			 					table.api().ajax.reload();
 
			 				}
			 	        },
			 	        error : function() {
			 	        	layer.msg("修改评分失败！", {icon: 2});
			 	        },
			 	        dataType : "json"
			 	    }); 
	 
	}
	//放弃抽样
	function FQSampleSubmit() {
		layer.confirm('确认放弃抽样吗？', {icon: 3}, function() {
			var obj = new Object();
			obj.url = updateSampleStatisUrl;
			obj.SAMPLEID = '${param.SAMPLEID}'; 
			
			ajax(obj, function(data) {
				if ("error" == data.resCode) {
					layer.msg(data.resMsg, {icon: 2});
				} else {
					layer.msg("数据处理成功！", {icon: 1});
					window.location.href='${ctx}/jsp/sample/gdsample.jsp'; 
				}
			});
		});
		 
	}
	
	function test() {
   		$("#datas").dataTable({
 			"aaSorting": [[ 5, "desc" ]]
 		}) 
 		 table.api().ajax.reload();
	}
	
	//根据
</script>
</head> 
<body class="gray-bg"> 
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5> <i class="fa fa-flag"></i> 工单抽样详细记录 (<span id="gdcyHead" >未完成</span>)
	                    </h5>
                    	<div class="ibox-tools">
	                        <a class="a-reload">
	                            <i class="fa fa-repeat"></i> 刷新
	                        </a>
	                        <a class="a-go" href="javascript:window.location.href='${ctx}/jsp/sample/gdsample.jsp'">
	                         	 <i class="fa fa-reply" ></i> 返回 
	                       	</a>
	                        <!-- <a class="collapse-link">
	                            <i class="fa fa-chevron-up"></i>
	                        </a>
	                        <a class="close-link">
	                            <i class="fa fa-times"></i>
	                        </a> -->
	                    </div>
	                </div>
	                
                    <div class="ibox-content">
                        <!-- search star -->
						<div class="form-horizontal clearfix key-13">
							<div class="col-sm-12 pl0" style="margin-right:10px; text-align:right">
							 
											<button class="btn btn-sm btn-success btn-result"  id="FQSample" onclick="FQSampleSubmit()"  >
												<i class="fa fa-trash-o"></i> 放弃抽样
											</button>  
											<button class="btn btn-sm btn-success btn-result"  id="exportData"   >
												<i class="fa fa-download"></i> 导出
											</button>  
										 
											<button class="btn btn-sm btn-success btn-result" onclick="javascript:window.location.href='${ctx}/jsp/sample/gdsample.jsp'"   >
												<i class="fa fa-mail-reply" ></i> 确定
											</button>
		 
							</div>

<!-- 							<div class="col-sm-6 form-inline" style="padding-right:0; text-align:right">
								<form id="queryForm" class="form-horizontal key-13" role="form" onsubmit="return false;">
									<input type="text" placeholder="关键字" class="input-sm form-control validate[custom[tszf]]" id="keywords">
	                                <button id="btn-query" type="button" class="btn btn-sm btn-success btn-13">
										<i class="fa fa-search"></i> 查询
									</button>
								</form>
							</div> -->
						</div>
						<!-- 详情头部 end -->
								<br> 
                        <div class="form-horizontal clearfix key-13"  >
                       				 <div class="col-sm-1 pl0" >
                       					区县：<span id="ORG_NAMExxx"></span>
                       				 </div>
                       				 <div class="col-sm-2 pl0">
                       				 	时段：<sapan id="SAMPLE_SCOPE_DATExxx"></sapan>
                       				 </div>
                       				 <div class="col-sm-1 pl0"  style="font-weight: bold">
                       				 	工单总数：<span id="WORK_SUMxxx"> </span>
                       				 </div> 
                    				 <div class="col-sm-1 pl0"  style="font-weight: bold">
                       				 	抽样人员：<span id="WORK_CREATER"> </span>
                       				 </div> 
                        </div>
                        <div class="form-horizontal clearfix key-13" style="font-weight: bold;margin-top: 10px">
                       				 <div class="col-sm-1 pl0">
                       					抽样总数：<span id="SAMPLE_CONUTSUMxxx"></span>
                       				 </div>
                       				 <div class="col-sm-8 pl0">
                       				 	<span id="GDTYSUM"></span>
                       				 </div> 
                        </div>   
                        
                        
                        <br>
                        
                        <table id="datas" class="table display" style="width:100%">
                            <thead>
                                <tr>
                                	<!-- <th><input type="checkbox" id="checkAll_" style="margin:0px;"></th> -->
									<th>工单编号</th>
									<th>工单类型</th> 
									<th>工单主题</th> 
									<th>区县</th>
									<th>业务类型</th>
									<th>发布时间</th>
									<th>评分</th>
									<th>操作</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
 
	<!-- edit start-->
	
	
	
 	
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog" >

	    <div class="modal-dialog" style="width:80%; height:800px">
	    	

	        <div class="modal-content ibox">

                <form id="editForm" class="form-horizontal key-13" role="form" >
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-random "></i> 已归档详情</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
        	    	<iframe id="iframeList" width="100%" height="640px"  ></iframe>
		         
		            <div class="ibox-content"  > 评分：
						 	<input type="radio" id="GRADE1" name="GRADE" value="1">1分
							<input type="radio" id="GRADE2" name="GRADE" value="2">2分
							<input type="radio" id="GRADE3" name="GRADE" value="3">3分
							<input type="radio" id="GRADE4" name="GRADE" value="4">4分
							<input type="radio" id="GRADE5" name="GRADE" value="5" checked="checked">5分 
					</div>
		            <div class="ibox-content"  > 意见：
						 	<textarea rows="3" class="form-control" name="EXT3" id="EXT3" placeholder="请填写意见"></textarea>
					</div>

		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-ok" style="display: none;float: right;" onclick="submitOk()">
		                	<i class="fa fa-check" ></i> 确定
		                </button>  
		            	 
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-down"  style="display: none;float: right;" onclick="showListDown()">
		                	下一个
		                </button>  
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-up" style="display: none;float: right;" onclick="showListUp()">
		                	上一个
		                </button> 
		            </div>
				</form>
	        </div>
	    </div>
	</div>
	<!-- edit end-->
	
</body>
</html>