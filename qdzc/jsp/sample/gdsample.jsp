<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
var sampList=new Array();
var token="${token}";
var sampleListUrl="${ctx}/jsp/sample/gdsamplelist.jsp?token=${token}";//工单质检详情页面
var sampleCountUrl="${ctx}/jsp/work/sample/querySampleAll.do?token=${token}";//工单数量查询
var insertSampleUrl = "${ctx}/jsp/work/sample/insertSample.do?token=${token}";//执行抽样添加
var queryUrl = "${ctx}/jsp/work/sample/querySample.do?token=${token}";//查询所有抽样记录
var queryOrgAndFlowUrl="${ctx}/jsp/work/sample/queryOrgAndFlow.do";//获得区县
 /*
 
 *****************************************
 
 绵阳工单质检，在每次增加工单，需要在字典配置工单的相关数据
 
 *****************************************
 
 */
var table ;  
 	$(window).ready(function() {  

		table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": true,//开启排序
			"autoWidth": false,
			"processing": true,
			"serverSide": false,
			"ajax": {
				"dataSrc": "Rows",
				"type":"post",
				"url": queryUrl,
				"data":{"userName":userName_,
					"corporate_identify":enterprise_flag_,
					"sysId":sysId_
				}  
			},
			"aaSorting": [[ 0, "desc" ]],//设置默认排序列
			"aoColumnDefs": [ {
				"bSortable": false,
				"aTargets": [ 2, 3, 6 ]//不可排序列
			}, {
				"targets": [ 0 ],
				"data":"CREATTIME"
			}, {
				"targets": [ 1 ],
				"data":"ORG_NAME"
				
			}, {
				"targets": [ 2 ],
				"data":"WORK_SUM"
				
			}, {
				"targets": [ 3 ],
				"data":"SAMPLE_CONUTSUM"
			}, {
				"targets": [ 4 ],
				"data":"SAMPLE_GRADE",
				"render": function (data, type, row) {
					if(row.SAMPLE_GRADE==null) {
						return '';	
					} else {
						return row.SAMPLE_GRADE;
					}
				}
				
			},{
				"targets": [ 5 ],
				"data":"SAMPLE_GRADE",
				"render": function (data, type, row) {
					if(row.SAMPLE_GRADE==null) {
						return '<i class="fa fa-question-circle-o " style="color:red"></i> <span style="color:red">未完成<span/>';	
					} else {
						return '<i class="fa fa-check-circle " style="color:green"></i> <span style="color:green">已完成<span/>';
					}
				}
				
			},{
				"targets": [ 6 ],
				"render": function (data, type, row) {
					var a = 0;
					if(row.SAMPLE_GRADE!=null){
						a=1
					}  
 					return '<a href="${ctx}/jsp/sample/gdsamplelist.jsp?SAMPLEID='+encodeURI(row.SAMPLEID)+'&STATIS='+encodeURI(a)+'">详情</a>'; 
				}
			}]
		});
		 
		
 
		/**
		 *自动抽样打开窗体
		 */
 		$("#btn-insert").on("click", function() {
			$("#editForm")[0].reset(); 
			$("#editForm").attr("action", insertSampleUrl);
			$("#myModal").modal("show"); 
	 		$("#STARTDATE").val(getNowFormatDateReduceOne())
	 		$("#ENDDATE").val(getNowFormatDateReduceOne())
			queryOrg()// 获得区县
	  		finGDsum();// 查询工单记录条数 
       	}); 
 
		 
		/**
		 * 自动抽检;
		 */
			$("#btn-ok").on("click", function() {   
  			 var b = $("#editForm").validationEngine("validate");//表单验证 
 				var  a=layer.load(1);  
			  if(b) { 	 
			 	    $.ajax({
			 	        url : insertSampleUrl,
			 	        async : true,
			 	        type : "POST",
			 	       	dataType : "json",
			 	        data : $("#editForm").serialize()+"&sampList="+JSON.stringify(sampList)+"&CREATER="+userName_,  
			 	        beforeSend:function(XMLHttpRequest){
			 	     
			 	        },
			 	        success :  function(data){ 
			 	        	sampleListUrl+"&SAMPLEID="+data.SAMPLEID
			 				if ("error" == data.resCode) {
			 					layer.msg(data.resMsg, {icon: 2});
			 				} else {
			 					layer.close(a);
			 					layer.msg("数据抽样成功！", {icon: 1,time:10000});
			 					layer.close(a);
			 					window.location=sampleListUrl+"&STATIS="+encodeURI(0)+"&SAMPLEID="+encodeURI(data.SAMPLEID);
			 					 
			 				}
			 	        },
			 	        error : function() { 
			 	        	layer.msg("获得工单数量失败！", {icon: 2});
			 	        },
			 	        dataType : "json"
			 	    }); 
			 	    
			 }  
		});
 	});
 
	
	/**
	* 查询工单记录条数(及展示工单)
	*/
 	function finGDsum(){   
 			 var sample_scope =$("#SAMPLE_SCOPE").val(); 
 			 if(sample_scope==null){
 				sample_scope='-1';
 			 }
 			 var startDate =$("#STARTDATE").val();
 		     var endDate=$("#ENDDATE").val();
 	   	 	if((sample_scope!=null)&&(startDate!=null&&startDate!='')&&(endDate!=null&&endDate!='')&&(sample_scope!=-2)){   
		 	    $.ajax({
		 	        url : sampleCountUrl,
		 	        async : true,
		 	        type : "GET",
		 	       	dataType : "json",
		 	        data : {
		 	            "SAMPLE_SCOPE" : sample_scope,
		 	            "STARTDATE" : startDate,
		 	            "ENDDATE":endDate
		 	        }, 
		 	        success :function showQuery(data) {  
		 	   		sampList=data['Rows'];
		 			var work_sum=0;
		 	     	var strHtml="";
		 	 		for (var i = 0; i < data['Rows'].length; i++) {
		 				var obj=data['Rows'][i]; 
		 				work_sum+=obj.work_sum;
		 				strHtml+='<div class="form-group">'
		 					    		+'<label  class="col-sm-3 control-label">'+obj.pName+'</label>'
		 					    		+'<div class="col-sm-2">'
		 					      		+' <input type="number" id="SAMPLESUM" onclick="changeTypeSample_Sum(this)" onkeyup="changeTypeSample_Sum(this)" min="0" value="0" class="form-control"  name="'+obj.pName+'"  />'
		 								+'</div>' 
		 				    		+'<div class="col-sm-5"> '
		 				     			+'<span id="'+obj.pName+'Sum">可抽检数量：'+obj.work_sum+'</span>个'
		 				    		+'</div>'  
		 			    		+'</div>'  
		 				}
		 	 		
			 	 		$("#strHtml").html(strHtml); 
			 	 		$("#work_sumSpan").html(work_sum);//查询出来工单总数量展示
			 	 		$("#WORK_SUM").val(work_sum);//查询出来工单总数量   
			 	 		//changeTypeSample_Sum();
		 	 		},
		 	        error : function() {
		 	        	layer.msg("获得工单数量失败！", {icon: 2});
		 	        },
		 	        dataType : "json"
		 	    });  
 	   	 	}else{
 	   	 	$("#btn-ok").prop("disabled", true);//禁用 
 	   	 	} 
 	} 

	//更新判断数据
 	function changeTypeSample_Sum(obj){  
 		var objData=queryListBypName(obj.name);
		if(Number(obj.value)<0){ 
			layer.msg("数据错误，自动设置为0", {icon: 1}); 
			setWorkSum(obj.name,0); 
		}else if(Number(obj.value)>Number(objData.work_sum)){
			layer.msg("数量超过,自动设置最大值："+objData.work_sum, {icon: 1});  
			setWorkSum(obj.name,objData.work_sum); 
		}else{
			setWorkSum(obj.name,obj.value);
		}
 		//没问题就看另一个有数据没，有数据就打开
 		if(queryListCount()<=0){	 				
 			$("#btn-ok").prop("disabled", true);
 		}else{
 			$("#btn-ok").prop("disabled", false);//可用
 		} 
 
 	}
 	
 	//$("#SAMPLESUM1").focus();//聚焦
   	//计算sampList抽样总数 
	function queryListCount(){
		var sample_sum=0;
		for (var i = 0; i < sampList.length; i++) {
			sample_sum+=Number(sampList[i].sample_sum);
		}
		return sample_sum;
	} 
 	/**
 	 *	根据pName设置抽样实际数量并更新显示和数组
 	 */
	function setWorkSum(pName,work_sum){
	  for (var i = 0; i < sampList.length; i++) {
		  if(sampList[i].pName==pName){
			  sampList[i].sample_sum=work_sum;//单个工单数组保存提交数量
			  $("input[name='"+pName+"']").val(Number(work_sum));//单个工单imput表单显示数量
			  //$('#'+pName+'Sum').html(Number(work_sum));//单个工单span显示数量
			  $("#sample_sumCountSpan").html(queryListCount());  //抽样工单总数展示
	 		  $("#SAMPLE_CONUTSUM").val(queryListCount());  //抽样工单总数 
		  }
	  } 
	} 
	//根据pName获取对应的对象 
	function queryListBypName(pName){
	  for (var i = 0; i < sampList.length; i++) {
		  if(sampList[i].pName==pName){
			  return sampList[i];
		  }
	  }
	  return null;
	}
 	//获得当前时间
	function getNowFormatDateReduceOne() {
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
        var currentdate = year + seperator1 + month + seperator1 + (Number(strDate)-1);
        return currentdate;
    }
	/**
	 * 获得区县
	 */
	function queryOrg() {
		var object = new Object();
		object.url = queryOrgAndFlowUrl;  
		ajax(object, function(data) {
			if ("error" == data.resCode) {
				layer.msg(data.resMsg, {icon: 2});
			} else {
				//获得区县  
				var str = '<option value="-1" >全部</option>';
				for(var i = 0 ;i<data.orgList.length;i++){
					var obj=data.orgList[i];
					str+='<option value="'+obj.id+'" >'+obj.org_name+'</option>';
				}
				$("#SAMPLE_SCOPE").html(str) 
			}
		}); 
	}
</script>
<style type="text/css">
	ul.ztree {
		width: 232px;
		height: 300px;
		border: 1px solid #ccc;
		background: #f9f9f9;
		overflow: auto;
	}
</style> 
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeInDown">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-flag"></i> 工单质检</h5>
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
	                
                    <div class="ibox-content">
                        <!-- search star -->
						<div class="form-horizontal clearfix key-13" style="padding-right:0; text-align:right">
							<div class="col-sm-12 pl0">
								<button class="btn btn-sm btn-success" id="btn-insert">
									<i class="fa fa-random "></i> 自动抽样
								</button>  
							</div> 
						</div>
						<!-- search end -->
                        
                        <table id="datas" class="table display" style="width:100%">
                            <thead>
                                <tr>
	                                <!-- <th><input type="checkbox" id="checkAll_" style="margin:0px;"></th> -->
	                                <th>抽样时间</th>
									<th>抽样范围</th>
									<th>工单总数</th>
									<th>抽样数量</th>
									<th>平均得分</th>
									<th>抽样状态</th>
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
	    <div class="modal-dialog" style="width:80%;height: 80%">
	        <div class="modal-content ibox">
                <form id="editForm" class="form-horizontal key-13" role="form" >
	           		<div class="ibox-title">
	                    <h5><i class="fa fa-random "></i> 自动抽样</h5>
	                    <div class="ibox-tools">
	                        <a class="close-link" data-dismiss="modal">
	                            <i class="fa fa-times"></i>
	                        </a>
	                    </div>
	                </div>
		            
		            <div class="ibox-content">
<!-- 	                  <input type="text" id="id" name="id" style="display:none"/>
	                  <input type="number" id="rowVersion" name="rowVersion" style="display:none"/>
	                  <input type="text" id="parentId" name="parentId" style="display:none"/> -->
	                  <input type="text" id="corporate_identify" value="${myUser.org.ext1}"  name="corporate_identify" style="display:none"/>
	                  
					  <div class="form-group">
						   <label class="col-sm-3 control-label">选择区县</label>
						    <div class="col-sm-4">
						     <!--  <input type="text" class="input-sm form-control validate[required]" name="title" id="title" > -->
						     <select class="form-control validate[required]" id="SAMPLE_SCOPE" name = "SAMPLE_SCOPE" onchange="finGDsum()"> 
						     </select>
						     
						    </div>

					  </div>
					  
					  <div class="form-group"> 
					     <label class="col-sm-2 control-label col-sm-offset-1">开始时间</label>
						<div class="col-sm-4">   
 							<input  onblur="finGDsum()"  onclick="WdatePicker({maxDate:'#F{$dp.$D(\'ENDDATE\')}',maxDate:'%y-%M-{%d-1}'})" type="text" class="form-control date_picker validate[required]" name="STARTDATE" id="STARTDATE" placeholder="yyyy-MM-dd" format="yyyy-MM-dd"> 
						</div>	
					  </div>
					   <div class="form-group"> 
						<label class="col-sm-2 control-label col-sm-offset-1">结束时间</label>
						<div class="col-sm-4"> 
<!-- 						<input type="text"   onclick="WdatePicker({minDate:'#F{$dp.$D(\'STARTDATE\')}',maxDate:'%y-%M-{%d-1}'})"  onblur="finGDsum()" class="form-control date_picker validate[required]" name="ENDDATE" id="ENDDATE" maxlength="11" placeholder="yyyy-MM-dd" format="yyyy-MM-dd"> 
-->							<input onblur= "finGDsum()"   onclick="WdatePicker({minDate:'#F{$dp.$D(\'STARTDATE\')}',maxDate:'%y-%M-{%d-1}'})" type="text"   class="form-control date_picker validate[required]" name="ENDDATE" id="ENDDATE"  placeholder="yyyy-MM-dd" format="yyyy-MM-dd"> 
 	 
						</div>	
					  </div> 
					  <!-- 工单总数-->
					<div class="form-group"> 
				  	 <label  class="col-sm-3 control-label">工单总数</label>
				    	<div class="col-sm-8">
				      	<span id="work_sumSpan"  >0</span>
				      	<input type="hidden" id="WORK_SUM" name="WORK_SUM" > 
				   		</div>  
					</div>  
					<hr>
					<!-- 抽样类型表 --><!-- 抽样数量 -->
					<div id="strHtml"></div>
 	
					<!-- 抽样总数 -->
					<div class="form-group"> 
				  	 <label  class="col-sm-3 control-label">抽样总数</label>
				    	<div class="col-sm-4">
				    	 <input type="hidden" id="SAMPLE_CONUTSUM"  class="form-control"  name="SAMPLE_CONUTSUM"/>
				      		<span id="sample_sumCountSpan" style="clour:red">0</span>
				   		</div>  
					</div> 
 				</div>
 		            <div class="modal-footer">
		                <button type="button" class="btn btn-sm btn-success btn-13" id="btn-ok" disabled="true" >
		                	<i class="fa fa-check"></i> 自动抽样
		                </button>
		                <button type="button" class="btn btn-sm btn-default"  id="btn-cancel" data-dismiss="modal">
		                	<i class="fa fa-ban"></i> 取消
		                </button>
		            </div>
				</form>
	        </div>
	    </div>
	</div>
	<!-- edit end-->
	
	
</body>
</html>