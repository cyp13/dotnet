<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
// 	var deleteLogsUrl = "${ctx}/jsp/sys/deleteLogs.do";
	var queryUrl = "${ctx}/jsp/sys/queryWorkTime.do";
	var insertUrl = "${ctx}/jsp/sys/insertWorkTime.do";
	var updateUrl = "${ctx}/jsp/sys/updateWorkTime.do";
	var deleteUrl = "${ctx}/jsp/sys/deleteWorkTime.do";

	$(window).ready(function() {
		var table = $("#datas").dataTable({
			"language": { "url": "${ctx}/js/plugins/dataTables/Chinese.json"},
			"dom": 'rt<"bottom"iflp<"clear">>',
			"pagingType": "full_numbers",
			"searching": false,
			"ordering": true,
			"autoWidth": false,
			"processing": true,
			"serverSide": true,
			"ajax": {
				"dataSrc": "Rows",
				"url": queryUrl
			},
			"aaSorting": [[ 7, "desc" ]],
			"aoColumnDefs": [ {
				"bSortable": false,
				"aTargets": [ 0, 1, 2, 4, 5, 7 ]
			}, {
				"targets": [ 0 ],
				"data":"id",
				"orderable": false,
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
				"data":"type",
				"render": function (data, type, row) {
					if(data=="1"){
						return row.enterprise_flag;
					}
					return row.group_id;
				}
			}, {
				"targets": [ 2 ],
				"data":"type",
				"render": function (data, type, row) {
					if(data=="1"){
						return "工单";
					}
					return "问答";
				}
			}, {
				"targets": [ 3 ],
				"data":"work_time"
			}, {
				"targets": [ 4 ],
				"data":"rest_time"
				
			}, {
				"targets": [ 5 ],
				"data":"work_time_2"
				
			}, {
				"targets": [ 6 ],
				"data":"rest_time_2"
				
			}, {
				"targets": [ 7 ],
				"data":"modified",
				"render":function (data, type, row) {
					return '<span title="'+row.modifier+'">'+data+'</span>';
				}
			}]
		});
          
		$("#btn-query").on("click", function() {
			var param = {
				"keywords": $("#keywords").val(),
				"startTime": $("#startTime").val(),
				"endTime": $("#endTime").val()
			};
			table.api().settings()[0].ajax.data = param;
			table.api().ajax.reload();
       	});
		
	/* 	$("#btn-insert").on("click", function() {
			$("#editForm")[0].reset();
			$("#editForm").attr("action", insertUrl);
			$("#myModal").modal("show");
			
			$(".type,#group_id").removeAttr("disabled");
			$(".type").change();

       	}); */

		$("#btn-update").on("click", function() {
			var size = $(".ids_:checkbox:checked").length;
			if(size != 1) {
				layer.msg("请选择需要修改的一行数据！", {icon: 0});
				return;
			}
			$("#editForm")[0].reset();
			$("#editForm").attr("action", updateUrl);
			$("#myModal").modal("show");
			
			var obj = new Object();
			obj.url = queryUrl;
			obj.id = $(".ids_:checkbox:checked").val();
			ajax(obj, function(data) {
				if ("error" == data.resCode) {
					error(data.resMsg);
					//layer.msg(data.resMsg, {icon: 2});
				} else {
					$("#editForm").fill(data.Rows[0]);
					$(".type,#group_id").attr("disabled","disabled");
					$(".type").change();
				}
			});
       	});
		
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
				obj.url = deleteUrl;
				obj.id = ids.join(",");
				ajax(obj, function(data) {
					if ("error" == data.resCode) {
						layer.msg(data.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						table.api().ajax.reload();
					}
				});
			});
		});

		$("#btn-clear").on("click", function() {
			layer.confirm('您确定要清空数据吗？', {
				icon: 3
			}, function() {
				var obj = new Object();
				obj.url = deleteUrl;
				ajax(obj, function(result) {
					if ("error" == result.resCode) {
						layer.msg(result.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						table.api().ajax.reload();
					}
				});
			});
		});
		
		$("input[name='type']").on("change",function(){
			var type_ = $("input[name='type']:checked").val();
			if(type_=="1"){
				$("#qybs").removeClass('hide');
				$("#enterprise_flag").addClass('validate[required]');
				$("#group_id").removeClass('validate[required]');
				$("#group_id").val("");
				$("#enterprise_flag").val("${myUser.org.ext1}");
				$("#jnz").addClass('hide');
			}
			else{
				$("#jnz").removeClass('hide');
				$("#group_id").addClass('validate[required]');
				$("#enterprise_flag").removeClass('validate[required]');
				$("#enterprise_flag").val("");
				$("#qybs").addClass('hide');
			}
		});

		$(".date_time").on("click", function() {
			var thiz = $(this);
			var end_date = $(this).attr("end_date");
			var format = $(this).attr("format");
			if(!format){
				format = "yyyy-MM-dd HH:mm:ss";
			}
			WdatePicker({
				dateFmt:format,
				onpicked:function(dp){
	 				dateChange(thiz,end_date);
				}
			});
		});
		
		$("#btn-ok").on("click", function() {
			var b = $("#editForm").validationEngine("validate");
			if(b) {
				var valid_start = $("#valid_start_date").val();
				var valid_start_2 = $("#valid_start_date_2").val();
				var valid_end = $("#valid_end_date").val();
				var valid_end_2 = $("#valid_end_date_2").val();
				
				dealDate(valid_start,valid_end,"#valid_end");//处理夏季时间
				dealDate(valid_start_2,valid_end_2,"#valid_end_2");//处理冬季时间
				if(valid_start==valid_start_2){
					alert("夏季开始时间和冬季开始时间不能相同！");
					return;
				}
				
				var work_time = $("#work_time").val();
				var rest_time = $("#rest_time").val();
				
				var work_time_2 = $("#work_time_2").val();
				var rest_time_2 = $("#rest_time_2").val();
				if(work_time>rest_time||work_time_2>rest_time_2){
					alert("上班时间不能晚于下班时间！");
					return;
				}
				
				ajaxSubmit("#editForm", function(data) {
					if ("error" == data.resCode) {
						layer.msg(data.resMsg, {icon: 2});
					} else {
						layer.msg("数据处理成功！", {icon: 1});
						$("#myModal").modal("hide");
						table.api().ajax.reload();
					}
				});
			}
		});
	});
	
	//时间联动
	function dateChange(ele,ele2){
		var valid_start_date = $(ele).val();
		var summer_date = stringToDate('2018-'+valid_start_date);
		summer_date.setDate(summer_date.getDate()-1);
		$(ele2).val(formatDate(summer_date,"MM-dd"));
	}
	
	//处理跨年时间
	function dealDate(start,end,ele){
		if(start.substr(0,2)>end.substr(0,2)//如果开始月份大于结束月份
				||(start.substr(0,2)==end.substr(0,2)&&start.substr(2)<end.substr(2)))//月份相同，开始日期大于结束日期
		{
			$(ele).val(end+"+1");//表示跨年的情况
		}
		else{
			$(ele).val(end);
		}
	}
	
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeInDown">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
   					<div class="ibox-title">
	                    <h5><i class="fa fa-history"></i> 上班时间管理列表</h5>
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
								<!-- <button class="btn btn-sm btn-success" id="btn-insert">
									<i class="fa fa-plus"></i> 新增
								</button> -->
								<button class="btn btn-sm btn-success" id="btn-update">
									<i class="fa fa-edit"></i> 修改
								</button>
							<!-- 	<button class="btn btn-sm btn-success" id="btn-delete">
									<i class="fa fa-trash-o"></i> 删除
								</button> -->
							</div>
	
<!-- 							<div class="col-sm-3 form-inline" style="padding-right:0; text-align:right"> -->
<!-- 								<input type="text" placeholder="关键字" class="input-sm form-control" id="keywords"> -->
<!--                                 <button id="btn-query" type="button" class="btn btn-sm btn-success btn-13"> -->
<!-- 									<i class="fa fa-search"></i> 查询 -->
<!-- 								</button> -->
<!-- 							</div> -->
						</div>
						<!-- search end -->
                        
                        <table id="datas" class="table display" style="width:100%">
                            <thead>
                                <tr>
	                                <th><input type="checkbox" id="checkAll_" style="margin:0px;"></th>
									<th>企业标识/技能组</th>
									<th>类型</th>
									<th>夏季上班时间</th>
									<th>夏季下班时间</th>
									<th>冬季上班时间</th>
									<th>冬季下班时间</th>
									<th>修改时间</th>
									<th>状态</th>
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
                   <fieldset>
   						<legend>基本信息</legend> 
					  <div class="form-group">
					 
						  <label class="col-sm-2 control-label">类型</label>
						    <div class="col-sm-4">
						    	<s:dict dictType="phraseType" type="radio" name="type"></s:dict>
						    </div>
					  <div id="qybs" class="hide">
					  
					    <label class="col-sm-1 control-label">企业标识</label>
					    <div class="col-sm-4">
					    	<input type="text" readonly class="input-sm form-control" name=enterprise_flag id="enterprise_flag" value="${myUser.org.ext1}">
					    </div>
					  </div>
					    <div id="jnz" class="hide">
						    <label class="col-sm-1 control-label">技能组</label>
						    <div class="col-sm-4">
						    	<select name="group_id" class="form-control input-sm">
						    		<option value="1">技能组1</option>
						    		<option value="2">技能组2</option>
						    	</select>
						    </div>
					    </div>
					  </div>
					  </fieldset>
					 <fieldset>
    						<legend>夏季</legend> 
					  <div class="form-group">
					    <label class="col-sm-2 control-label">开始时间</label>
					    <div class="col-sm-4">
					    	<input type="text" end_date="#valid_end_date_2" value="05-01" readonly="readonly"  class="input-sm  form-control validate[required] date_time" format="MM-dd"  title="可更改开始时间，结束时间自动计算。" name="valid_start_date" id="valid_start_date" >
					    </div>
					 
					    <label class="col-sm-1 control-label">结束时间</label>
					    <div class="col-sm-4">
					     	<input type="text" class="input-sm  form-control validate[required] date_time" value="09-30"  disabled format="MM-dd"  name="valid_end_date" id="valid_end_date" title="可更改开始时间，结束时间自动计算。">
					   		<input type="text" class="hide" name="valid_end" id="valid_end"/>
					    </div>
					 
					  </div>
					  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">上班时间</label>
					    <div class="col-sm-4">
					    	<input type="text" class="input-sm form-control validate[required] date_time" format="HH:mm"  name="work_time" id="work_time" >
					    </div>
					    	 <label class="col-sm-1 control-label">下班时间</label>
					   	<div class="col-sm-4">
					    	 <input type="text" class="input-sm form-control validate[required] date_time" format="HH:mm"  name="rest_time" id="rest_time" >
					  	</div>
					  </div>
					  </fieldset>
					   <fieldset>
    						<legend>冬季</legend> 
					  <div class="form-group">
					    <label class="col-sm-2 control-label">开始时间</label>
					    <div class="col-sm-4">
					    	<input type="text" end_date="#valid_end_date" title="可更改开始时间，结束时间自动计算。" readonly="readonly" class="input-sm  form-control validate[required] date_time" value="10-01" format="MM-dd" name="valid_start_date_2" id="valid_start_date_2"  >
					    </div>
					 
					    <label class="col-sm-1 control-label" >结束时间</label>
					    <div class="col-sm-4">
					     	<input type="text" class="input-sm  form-control validate[required] date_time" disabled format="MM-dd"  value="04-30"  name="valid_end_date_2" id="valid_end_date_2" title="可更改开始时间，结束时间自动计算。">
					   		<input type="text" class="hide" name="valid_end_2" id="valid_end_2"/>
					    </div>
					 
					  </div>
					  
					  <div class="form-group">
					    <label class="col-sm-2 control-label">上班时间</label>
					    <div class="col-sm-4">
					    	<input type="text" class="input-sm form-control validate[required] date_time" format="HH:mm"  name="work_time_2" id="work_time_2" >
					    </div>
					    	 <label class="col-sm-1 control-label">下班时间</label>
					   	<div class="col-sm-4">
					    	 <input type="text" class="input-sm form-control validate[required] date_time" format="HH:mm"  name="rest_time_2" id="rest_time_2" >
					  	</div>
					  </div>
					  </fieldset>
					   <fieldset>
    						<legend>其他</legend> 
					  <div class="form-group">
					  	<label class="col-sm-2 control-label">备注</label>
					    <div class="col-sm-9">
					    	<textarea rows="5" class="form-control" name="remark" id="remark" ></textarea>
					    </div>
					  </div>
					  </fieldset>
					  

					 <%--  <div class="form-group">
					  	<label class="col-sm-2 control-label">每周工作日</label>
					    <div class="col-sm-9">
					    	<s:dict dictType="workDay" clazz="validate[required]" type="checkbox" name="work_week"></s:dict>
					    </div>
					  </div> --%>
					  
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
</body>
</html>