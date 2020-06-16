<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include>
<script>
	var queryUrl = "${ctx}/jsp/work/querySpecial.do";
	var queryDictUrl = "${ctx}/jsp/sys/queryDict.do";
	var pid = '${param.pId}';
	var flag = '${param.flag}';
	var taskId = '${param.taskId}';
	$(window)
			.ready(
					function() {
						//获取常用语
						getPhraseToPage();
						$(".phrase_").typeahead({
							source : phrases
						});

						//默认不能编辑
						$(".dataForm input,.dataForm textarea").attr(
								'readonly', 'readonly');
						$(".dataForm select,.dataForm input[type='radio']")
								.attr('disabled', 'disabled');

						$("#flag").val(flag);
						$("#taskId").val(taskId);
						$("#pid").val(pid);
						//填充数据
						if (pid) {
							var obj = new Object();
							//实例ID
							obj.pid = pid;
							obj.url = queryUrl;
							obj.token = token_;
							ajax(
									obj,
									function(data) {
										$("#type_1_1").hide();
										$("#type_1_1").find(":input")
												.attr("disabled", true);
										$("#type_1_2").hide();
										$("#type_1_2")
												.find(":input")
												.attr("disabled", true);
										$("#type_1_3").hide();
										$("#type_1_3").find(":input")
												.attr("disabled", true);
										
										$("#node").val("2");//设置页面编码
										
										//设置取消驳回框
										$("#isError").hide();
										$("#isError").find(":input").attr("disabled", true);
									 
										
										var row = data.Rows[0];
										var a = row.work_type;
										//alert("${param.taskName}")
										if (a == 1) {//开户
											$("#work_kaihu").show();
											$("#work_kaihu").find(":input").attr("disabled", false);
											$("#work_biangeng").hide();
											$("#work_biangeng").find(":input").attr("disabled", true);
											$("#work_xiaohu").hide();
											$("#work_xiaohu").find(":input").attr("disabled", true);
											$("#type_2_3").hide();
											$("#type_2_3").find(":input").attr("disabled", true);
											
											//判断这是第几次提交
											var statis = row.work_statis;
											if (statis == 0) {//渠道第一次提交 ---280及产品类型确认
												$("#type_1_1").show();
												$("#type_1_1")
														.find(":input")
														.attr("disabled", false);  
												$("#type_1_1_1").show();
												$("#type_1_1_1").find(":input").attr("disabled", false);
												
												$("#type_1_2").hide();
												$("#type_1_2").find(":input")
														.attr("disabled", true);
												$("#type_1_3").hide();
												$("#type_1_3").find(":input")
														.attr("disabled", true);
												//进入这个页面那么提交的状态就改变了
												$("#work_statis1").val("1"); 
												$("#editForm").attr("action","${ctx}/jsp/work/updateSpecial.do"); 
												
												$("#DIYICI").attr("checked","checked"); 
												 
											} else if (statis == 1) {//渠道第二次确认---boss是否已提单
												$("#type_1_1").hide();
												$("#type_1_1").find(":input")
														.attr("disabled", true);
												
												$("#type_1_1_1").show();
												$("#type_1_1_1").find(":input").attr("disabled", true);
												
												$("#type_1_2").show();
												$("#type_1_2")
														.find(":input")
														.attr("disabled", false);
												$("#type_1_3").hide();
												$("#boosidNo").hide();//取消驳回
												$("#type_1_3").find(":input")
														.attr("disabled", true);
												$("#work_statis1").val("2");
												$("#editForm").attr("action","${ctx}/jsp/work/updateSpecial.do"); 
												$("#boosid").attr("checked","checked"); 
												 
												
											} else if (statis == 2) {//渠道第三次确认 ---专线号
												$("#type_1_1").hide();
												$("#type_1_1").find(":input")
														.attr("disabled", true);
												
												$("#type_1_1_1").show();
												$("#type_1_1_1").find(":input").attr("disabled", true);
												
												$("#type_1_2").hide();
												$("#type_1_2").find(":input")
														.attr("disabled", true);
												$("#type_1_3").show();
												$("#type_1_3")
														.find(":input")
														.attr("disabled", false);
												$("#work_statis1").val("3");
												
												$("#okbanli").attr("checked","checked"); 
												$("#type_2_3").show();
												$("#type_2_3").find(":input").attr(
														"disabled", false);
											}

											$(".dataForm input, .dataForm textarea, .dataForm select, .dataForm input[type='radio'],.dataForm input[type='hidden']")
													.attr('disabled',
															'disabled');
										} else if (a == 3) {//销户
											nopage();
										
											$("#work_kaihu").hide();
											$("#work_kaihu").find(":input")
													.attr("disabled", true);
											$("#work_biangeng").hide();
											$("#work_biangeng").find(":input")
													.attr("disabled", true);
											$("#work_xiaohu").show();
											$("#work_xiaohu").find(":input")
													.attr("disabled", false); 

											$(
													".dataForm input, .dataForm textarea, .dataForm select, .dataForm input[type='radio'],.dataForm input[type='hidden']")
													.attr('disabled',
															'disabled');
											
											
											
											var statis = row.work_statis;
											if (statis == 0) {// ---boss是否已提单
												$("#type_1_1").hide();
												$("#type_1_1").find(":input")
														.attr("disabled", true);
												
												//$("#type_1_1_1").show();
												//$("#type_1_1_1").find(":input").attr("disabled", true);
												
												$("#type_1_2").show();
												$("#type_1_2")
														.find(":input")
														.attr("disabled", false);
												$("#type_1_3").hide();
												$("#type_1_3").find(":input")
														.attr("disabled", true);
												$("#work_statis1").val("2");
												$("#editForm").attr("action","${ctx}/jsp/work/updateSpecial.do"); 
												$("#boosid").attr("checked","checked"); 
												

												$("#type_2_3").hide();
												$("#type_2_3").find(":input").attr(
														"disabled", true);
										
												}else if(statis=2){
												$("#okbanli").attr("checked","checked"); 
												$("#type_2_3").show();
												$("#type_2_3").find(":input").attr(
														"disabled", false);
											}
											
											
										}else { //变更  
											
											nopage();  
											$("#work_kaihu").hide();
											$("#work_kaihu").find(":input")
													.attr("disabled", true);
											$("#work_biangeng").show();
											$("#work_biangeng").find(":input")
													.attr("disabled", false);
											$("#work_xiaohu").hide();
											$("#work_xiaohu").find(":input")
													.attr("disabled", true); 
											$(
													".dataForm input, .dataForm textarea, .dataForm select, .dataForm input[type='radio'] ,.dataForm input[type='hidden']")
													.attr('disabled',
															'disabled');
											
											
											var statis = row.work_statis;
											if (statis == 0) {// ---boss是否已提单
												$("#type_1_1").hide();
												$("#type_1_1").find(":input")
														.attr("disabled", true);
												
												//$("#type_1_1_1").show();
												//$("#type_1_1_1").find(":input").attr("disabled", true);
												
												$("#type_1_2").show();
												$("#type_1_2")
														.find(":input")
														.attr("disabled", false);
												$("#type_1_3").hide();
												$("#type_1_3").find(":input")
														.attr("disabled", true);
												$("#work_statis1").val("2");
												$("#editForm").attr("action","${ctx}/jsp/work/updateSpecial.do"); 
												$("#boosid").attr("checked","checked"); 
												

												$("#type_2_3").hide();
												$("#type_2_3").find(":input").attr(
														"disabled", true);
											}else if(statis=2){
												$("#okbanli").attr("checked","checked"); 
												$("#type_2_3").show();
												$("#type_2_3").find(":input").attr(
														"disabled", false);
											}
											
											
										} 
										$("#editForm").fill(row); 
										 
									 	 //获取小类
										initFormTypeSmall($('select[name=service_type] option:selected').attr('data-id'),row.service_type_detail);
										 
									 	 
									 	 if (row.files) {//附件处理  flag等于3时  就可以删除附件
											if (flag != '3') {
												getFiles(row.files, "#fileList");
											} else {
												getFiles(row.files,
														"#fileList", flag);
											}
									 	 }
									 	 
										 
									 	if (row.status == "2") { //表示已解决(李：就是查看页面了？)
									 		  $("#evaluate").removeClass('hide');
									 		  $(".ibox-content input,.ibox-content textarea,.ibox-content select").attr('disabled', 'disabled');
									 		}

							 });
						}
				 
						$(".action").on("change",
								function() { //未解决才可编辑数据 
								  if ($(this).val() == "0") {
								    $(".dataForm input,.dataForm textarea").removeAttr('readonly');
								    $(".readonly").attr('readonly', 'readonly');
								    $(".dataForm select,.dataForm input[type='radio']").removeAttr('disabled');
								    $("#evaluate").addClass("hide");
								    $(".ext1").attr("disabled", true);
								    $("#fileUpload").removeClass("hide");
								  } else {
								    $(".dataForm input,.dataForm textarea").attr('readonly', 'readonly');
								    $(".dataForm select").attr('disabled', 'disabled');
								    $("#fileUpload").addClass("hide");
								    $(".ext1").removeAttr("disabled");
								    $("#evaluate").removeClass("hide");
								  }
								}); 
						//业务类型联动-选择某个其他小类会进行改变
								$("#service_type").on("change",
								function() {
								  if ($(this).val()) {
								    var dictType = $("#service_type option:checked").data("id");
								    getDictToPage(dictType, "#service_type_detail");
								  } else {
								    $("#service_type_detail").html("无");
								  }
								});
			 		
						//确定按钮
						$("#btn-ok").on("click",
						function() {
						  if ($('#fileList').children().length <= 0) {
						    $('#file').addClass('validate[required]');
						  } else {
						    var found = false;
						    $('#fileList').children().each(function() {
						      found = $(this).attr('state') == 'normal';
						    });
						    if (found) {
						      $('#file').removeClass('validate[required]');
						    } else {
						      $('#file').addClass('validate[required]');
						    }
						  }

						  for (var key in deleteFileIds) {
						    $("#editForm").append('<input type="hidden" name="deleteFileIds" value="' + key + '" />');
						  } 
						  if (!$(".delFile") && !$("#file").val()) {
						    $("#file").addClass("validate[required]");
						  }

						  var b = $("#editForm").validationEngine("validate");
						  
						/*****工单质检用的字段******/
						
						$("#editForm").append('<input type="hidden" name="service_type_name" value="' + $("select[name=service_type] option:selected").text() + '" />');
						$("#editForm").append('<input type="hidden" name="service_type_detail_name" value="' + $("select[name=service_type_detail] option:selected").text() + '" />');
						
						/***********/
						
						  if (b) {
						    if (flag == "2") {
						      $("#service_type_detail_name").val($("#service_type_detail option:checked").text());
						    }

						    //如果是驳回就修改页面
						    var work_statis1 = $("#work_statis1").val();
						    if (work_statis1 == "1" || work_statis1 == "2") {
						      $("#work_statis").val(work_statis1);
						    }
						    ajaxSubmit("#editForm",
						    function(data) {
						      if ("error" == data.resCode) {
						        layer.msg(data.resMsg, {
						          icon: 2
						        });
						      } else {
						        layer.msg("数据处理成功！", {
						          icon: 1
						        },
						        function() {
						        	/**********************/
						        	var a = $("#work_statis1").val();  
									if((parseInt(a)==1||parseInt(a)==2)&&data['result']!='驳回'){ 
										reload_();
									}else{
										back_();
									}
						        	/**********************/
						         
						        });
						      }
						    });
						  }
						});

					});
	function isorno(value) {
		$("#btn-ok").removeAttr("disabled");
		if (value == '驳回') {
			$("#isError").show(); 
			$("#isError").find(":input").attr("disabled", false);
			$("#editForm").attr("action","${ctx}/jsp/work/subSpecial.do"); //如果是驳回就修改为提交url
			
			$("#type_1_3").hide();
			$("#type_1_3").find(":input").attr("disabled", true);
		} else if (value = '回复') {  
			$("#isError").hide();
			$("#isError").find(":input").attr("disabled", true);
			var a = $("#work_statis1").val(); 
			if(parseInt(a)==1||parseInt(a)==2){//个人是1 或2  不流转流程 只是修改数据
				$("#editForm").attr("action","${ctx}/jsp/work/updateSpecial.do"); 
			}else if(parseInt(a)==3){
				$("#type_1_3").show();
				$("#type_1_3").find(":input").attr("disabled", false);
			}
			
		}
	}
	
	function isorno1_1(value) { //第一次处理
		$("#btn-ok").removeAttr("disabled");
		if (value == '回退') {
			$("#isError").show();
			$("#isError").find(":input").attr("disabled", false);
			$("#type_1_1_1").hide();
			$("#type_1_1_1").find(":input").attr("disabled", true); 
			$("#editForm").attr("action","${ctx}/jsp/work/subSpecial.do"); //如果是驳回就修改为提交url
		} else if (value = '回复') {
			$("#isError").hide();
			$("#isError").find(":input").attr("disabled", true);
			$("#type_1_1_1").show();
			$("#type_1_1_1").find(":input").attr("disabled", false); 
			var a = $("#work_statis1").val(); 
			if(parseInt(a)==1||parseInt(a)==2){//个人是1 或2  不流转流程 只是修改数据 
				$("#editForm").attr("action","${ctx}/jsp/work/updateSpecial.do"); 
			}
		}
	}

	function isorno1_2(value) {
		$("#btn-ok").removeAttr("disabled");
		if (value == '回退') {
			$("#isError").show();
			$("#isError").find(":input").attr("disabled", false);
			$("#editForm").attr("action","${ctx}/jsp/work/subSpecial.do"); //如果是驳回就修改为提交url
		} else if (value = '回复') {
			$("#isError").hide();
			$("#isError").find(":input").attr("disabled", true);
			var a = $("#work_statis1").val();
			if(parseInt(a)==1||parseInt(a)==2){//个人是1 或2  不流转流程 只是修改数据
				$("#editForm").attr("action","${ctx}/jsp/work/updateSpecial.do"); 
			}
		}
	}

	function isorno1_3(value) {
		$("#btn-ok").removeAttr("disabled");
		if (value == '驳回') {
			$("#isError").show();
			$("#isError").find(":input").attr("disabled", false);
			$("#editForm").attr("action","${ctx}/jsp/work/subSpecial.do"); //如果是驳回就修改为提交url
		} else if (value = '回复') {

			$("#isError").hide();
			$("#isError").find(":input").attr("disabled", true);
			var a = $("#work_statis1").val();
			if(parseInt(a)==1||parseInt(a)==2){//个人是1 或2  不流转流程 只是修改数据
				$("#editForm").attr("action","${ctx}/jsp/work/subSpecial.do"); 
			}
		}
	}
	/*
	*隐藏开户动态页面
	*/
	function nopage() {
		$("#type_1_1").hide();
		$("#type_1_1")
				.find(":input")
				.attr("disabled", true);  
		$("#type_1_1_1").hide();
		$("#type_1_1_1").find(":input").attr("disabled", true);
		
		$("#type_1_2").hide();
		$("#type_1_2").find(":input")
				.attr("disabled", true);
		$("#type_1_3").hide();
		$("#type_1_3").find(":input")
				.attr("disabled", true);
	}
	
</script>
</head>

<body class="gray-bg">
	<div class="wrapper wrapper-content animated fadeIn">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox float-e-margins">

					<div class="ibox-content">
						<form id="editForm" action="${ctx}/jsp/work/subSpecial.do"
							method="post" class="form-horizontal key-13">
							
							<input type="text" id="id" name="id" style="display: none" /> <input
								type="text" id="pid" name="pid" style="display: none" /> <input
								type="text" id="flag" name="flag" style="display: none" /> <input
								type="text" id="taskId" name="taskId" style="display: none" />
							<div class="dataForm">
								<div class="form-group">
									<label class="col-sm-2 control-label">工单主题</label>
									<div class="col-sm-4">
										<input class="input-sm form-control validate[required]"
											name="title" id="title" />
									</div>
									<label class="col-sm-1 control-label">工单编号</label>
									<div class="col-sm-4">
										<input
											class="input-sm form-control validate[required] readonly"
											name="form_code" id="form_code" />
									</div>
								</div>
								<div class="form-group">
									<label class="col-sm-2 control-label">区县</label>
									<div class="col-sm-4">
										<input type="text" class="input-sm form-control readonly"
											name="county_name" id="county_name" readonly> <input
											type="text" class="hide" name="county" id="county">
									</div>

									<label class="col-sm-1 control-label">分局</label>
									<div class="col-sm-4">
										<input type="text" class="input-sm form-control readonly"
											name="branch_office_name" id="branch_office_name" readonly>
										<input type="text" class="hide" name="branch_office"
											id="branch_office">
									</div>
								</div>

								<div class="form-group">
									<label class="col-sm-2 control-label">渠道</label>
									<div class="col-sm-4">
										<input type="text" class="input-sm form-control readonly"
											name="channel_name" id="channel_name" readonly>
									</div>
									<label class="col-sm-1 control-label">渠道编码</label>
									<div class="col-sm-4">
										<input type="text" class="input-sm form-control readonly"
											value="121" name="channel" id="channel" readonly>
									</div>
								</div>

								<div class="form-group">
									<label class="col-sm-2 control-label">渠道联系方式</label>
									<div class="col-sm-4">
										<input type="number" class="input-sm form-control readonly" 
											readonly name="channel_phone" id="channel_phone">
									</div>

								</div>

								<!-- 可变字段 -->


								<!-- 开户start -->
								<div id="work_kaihu" style="display: none;">
									<div class="form-group">
										<label class="col-sm-1 control-label col-sm-offset-1">业务小类</label>
										<div class="col-sm-4">
											<s:dict dictType="zxgd_sj" name="work_type" type="select"
												clazz="validate[required] form-control"></s:dict>
										</div>
									</div>
									<div class="form-group">
										<!--集团单位名称-->
										<label class="col-sm-2 control-label ">集团单位名称</label>
										<div class="col-sm-4">
											<input type="text"
												class="input-sm form-control validate[required]" placeholder="请输入30字以内得集团名称" maxlength="30"
												name="group_name" readonly>
										</div>
										<!--装机地址-->
										<label class="col-sm-1 control-label ">装机地址</label>
										<div class="col-sm-4">
											<input type="text"
												class="input-sm form-control validate[required]" maxlength="50"
												name="install_address" placeholder="请输入装机地址"  readonly>
										</div>


									</div>

									<div class="form-group">
										<!--装机联系人-->
										<label class="col-sm-2 control-label ">装机联系人(客户)</label>
										<div class="col-sm-4">
											<input type="text"
												class="input-sm form-control validate[required]" placeholder="请输入装机联系人姓名" maxlength="5"
												name="install_name" readonly>
										</div>
										<!--装机联系手机-->
										<label class="col-sm-1 control-label ">装机联系手机(客户)</label>
										<div class="col-sm-4">
											<input type="text"
												class="input-sm form-control validate[required,custom[mobile]]"  maxlength="11" placeholder="请输入手机号码"
												name="install_phone" readonly>
										</div>
									</div>

									<div class="form-group">
										<!--集团单位法人-->
										<label class="col-sm-2 control-label ">集团单位法人</label>
										<div class="col-sm-4">
											<input type="text"
												class="input-sm form-control   " placeholder="无"  maxlength="5"
												name="group_mainname" readonly>
										</div>
										<!--法人手机-->
										<label class="col-sm-1 control-label ">法人手机</label>
										<div class="col-sm-4">
											<input type="text"
												class=" input-sm form-control validate[custom[mobile]]"  maxlength="11" placeholder="无"
												name="mainphone" readonly>
										</div>
									</div>

									<div class="form-group">
										<!--优惠比例-->
										<label class="col-sm-2 control-label ">优惠比例(%)</label>
										<div class="col-sm-4">
											<input type="number" min="0" max="100" maxlength="3" class="input-sm form-control validate[required,custom[discount_rate]]" placeholder="请输入0到100之间得整数" 
												name="discount_rate" readonly>
										</div>
									</div>
								</div>
								<!-- 开户end -->

								<!-- 变更start -->
								<div id="work_biangeng" style="display: none;">

									<div class="form-group">
										<label class="col-sm-1 control-label col-sm-offset-1">业务小类</label>
										<div class="col-sm-4">
											<s:dict dictType="zxgd_sj" name="work_type" type="select"
												clazz="validate[required] form-control"></s:dict>
										</div>
										<!--专线号-->
										<label class="col-sm-1 control-label ">专线号</label>
										<div class="col-sm-4">
											<input type="text" class="input-sm form-control validate[required,custom[specialnumber]]" name="specialnumber"   maxlength="11" placeholder="请填写100开头的11位数专线号">
										</div>
									</div>

									<div class="form-group">
										<!--集团单位名称-->
										<label class="col-sm-2 control-label ">集团单位名称</label>
										<div class="col-sm-4">
											<input type="text"
												class="input-sm form-control validate[required]" placeholder="请输入30字以内得集团名称" maxlength="30"
												name="group_name">
										</div>
										<!--装机地址-->
										<label class="col-sm-1 control-label ">装机地址</label>
										<div class="col-sm-4">
											<input type="text"
												class="input-sm form-control validate[required]" maxlength="50"
												placeholder="请输入装机地址"  name="install_address">
										</div>
									</div>

									<div class="form-group">
										<!--装机联系人-->
										<label class="col-sm-2 control-label ">变更联系人</label>
										<div class="col-sm-4">
											<input type="text"
												class="input-sm form-control validate[required]" placeholder="请输入变更联系人姓名" maxlength="5"
												name="install_name">
										</div>
										<!--装机联系手机-->
										<label class="col-sm-1 control-label ">变更联系手机</label>
										<div class="col-sm-4">
											<input type="text"
												class="input-sm form-control validate[required,custom[mobile]]" maxlength="11" placeholder="请输入手机号码"
												name="install_phone">
										</div>
									</div>

									<div class="form-group">
										<!--集团单位法人-->
										<label class="col-sm-2 control-label ">集团单位法人</label>
										<div class="col-sm-4">
											<input type="text" class=" form-control  "  placeholder="无"  maxlength="5"
												name="group_mainname">
										</div>
										<!--法人手机-->
										<label class="col-sm-1 control-label ">法人手机</label>
										<div class="col-sm-4">
											<input type="text" class=" form-control validate[custom[mobile]] " name="mainphone" maxlength="11" placeholder="无">
										</div>
									</div>

								</div>
								<!--变更end -->

								<!-- 销户start -->
								<div style="display: none;" id="work_xiaohu">

									<div class="form-group">
										<label class="col-sm-1 control-label col-sm-offset-1">业务小类</label>
										<div class="col-sm-4">
											<s:dict dictType="zxgd_sj" name="work_type" type="select"
												clazz="validate[required] form-control"></s:dict>
										</div>
										
										<!--专线号-->
										<label class="col-sm-1 control-label  ">专线号</label>
										<div class="col-sm-4">
											<input type="text" class="input-sm form-control validate[required,custom[specialnumber]]" name="specialnumber"   maxlength="11" placeholder="请填写100开头的11位数专线号">
										</div>
									</div>

									<div class="form-group">
										<!--集团单位名称-->
										<label class="col-sm-2 control-label ">集团单位名称</label>
										<div class="col-sm-4">
											<input type="text"
												class="input-sm form-control validate[required]" placeholder="请输入30字以内得集团名称" maxlength="30"
												name="group_name">
										</div>
										<!--装机地址-->
										<label class="col-sm-1 control-label ">装机地址</label>
										<div class="col-sm-4">
											<input type="text"
												class="input-sm form-control validate[required]" maxlength="50"
												placeholder="请输入装机地址"  name="install_address">
										</div>
									</div>

									<div class="form-group">
										<!--装机联系人-->
										<label class="col-sm-2 control-label ">销户联系人</label>
										<div class="col-sm-4">
											<input type="text"
												class="input-sm form-control validate[required]" placeholder="请输入销户联系人姓名" maxlength="5"
												name="install_name">
										</div>
										<!--装机联系手机-->
										<label class="col-sm-1 control-label ">销户联系手机</label>
										<div class="col-sm-4">
											<input type="text"
												class="input-sm form-control validate[required,custom[mobile]]"  maxlength="11" placeholder="请输入手机号码"
												name="install_phone">
										</div>
									</div>

									<div class="form-group">
										<!--集团单位法人-->
										<label class="col-sm-2 control-label ">集团单位法人</label>
										<div class="col-sm-4">
											<input type="text" class=" form-control  "  placeholder="无"  maxlength="5"
												name="group_mainname">
										</div>
										<!--法人手机-->
										<label class="col-sm-1 control-label ">法人手机</label>
										<div class="col-sm-4">
											<input type="text" class=" form-control  validate[custom[mobile]]" name="mainphone" maxlength="11" placeholder="无">
										</div>
									</div>

								</div>
								<!--销户end -->



								<!-- end -->
							<div class="form-group">
								<label class="col-sm-2 control-label">描述说明</label>
								<div class="col-sm-9">
									<textarea class="form-control" name="remark" id="remark" maxlength="500" placeholder="此处可填写受理业务其他说明或描述（非必填项） "></textarea>
								</div>
							</div>	
							</div>
							

							<div class="form-group">
								<label class="col-xs-2 control-label">附件：</label>
								<div class="col-xs-9 control-label" id="fileList"
									style="text-align: left;"></div>
							</div>
							 

							<div id="sub1" class="sub hide"></div>
							<hr>

							<div id="type_1_1">
								<!-- 开户 1-->

								<div class="form-group">
									<label class="col-sm-2 control-label">处理结果</label>
									<div class="col-sm-4">
										<label> <input type="radio"
											onclick="isorno1_1(this.value)" name="result"  id="DIYICI"
											  value="回复" /><span
											style="padding: 0px 10px 0px 5px;">回复</span>

										</label> <label> <input type="radio"
											onclick="isorno1_1(this.value)" name="result" value="回退" /><span
											style="padding: 0px 10px 0px 5px;">驳回</span>
										</label>
									</div>
								</div>
							</div>
							<div id="type_1_1_1"> <!-- ********开户1********--> 
								<div class="form-group">
										  	<label class="col-sm-2 control-label">产品大类</label>
										    <div class="col-sm-4">
										    	<s:dict dictType="zxgdmaxmin" clazz="form-control validate[required]" name="service_type"  />
										    </div>
									      
											
									     	<label class="col-sm-1 control-label">产品小类</label>
											<div class="col-sm-4">
												<select id="service_type_detail" class="form-control validate[required]"
													name="service_type_detail">
														  
													</select> 
													 
													<input type="text"
													class="hide" name="service_type_detail_name"
													id="service_type_detail_name">
											   
											</div>
							     </div>
							      
								<div class="form-group">
									<label class="col-sm-2 control-label ">集团编码</label>
									<div class="col-sm-4">
										<input type="text" class=" form-control  validate[required,custom[group_code]] " name="group_code" maxlength="10"
											placeholder="请输入280集团编码">
									</div>
								</div>
							</div>
 					
							<div id="type_1_2"><!-- ********开户2 ********--> 
							 
 <hr>
								<div class="form-group">
									<label class="col-sm-2 control-label">处理结果</label> 
									<div class="col-sm-4">
										<label> <input type="radio"  id="boosid"
											onclick="isorno1_2(this.value)" name="result" value="回复" /><span
											style="padding: 0px 10px 0px 5px;" >boss已提单</span>
					 
					
									  	</label> 
									  	
									 	<label id="boosidNo" > <input type="radio" 
											onclick="isorno1_2(this.value)" name="result" value="回退" /><span
											style="padding: 0px 10px 0px 5px;">驳回</span>
										</label>   
				 
									</div>
								</div>

							</div>
							
							 
													<!-- *******销户和变更的支撑处理******  -->
							<div id="type_2_3"> 
								<div class="form-group">
									<label class="col-sm-2 control-label">处理结果</label>
									<div class="col-sm-4">
										<label> <input type="radio"   
											onclick="isorno(this.value)" id="okbanli" name="result" value="回复" /><span
											style="padding: 0px 10px 0px 5px;">办理成功</span>

										</label> <label> <input type="radio"
											onclick="isorno(this.value)" name="result" value="驳回" /><span
											style="padding: 0px 10px 0px 5px;">办理失败</span>
										</label>
									</div>
								</div>
							</div>
							
							
							
							<div id="type_1_3"><!-- ********开户3********--> 
<%--   								<div class="form-group">
									<label class="col-sm-2 control-label">处理结果</label>
									<div class="col-sm-4">
										<label> <input type="radio"   
											onclick="isorno(this.value)" name="result" value="回复" /><span
											style="padding: 0px 10px 0px 5px;">办理成功</span>

										</label> <label> <input type="radio"
											onclick="isorno(this.value)" name="result" value="驳回" /><span
											style="padding: 0px 10px 0px 5px;">办理失败</span>
										</label>
									</div>
								</div> --%>
								
							    <div class="form-group">
									<label class="col-sm-2 control-label ">专线号</label>
									<div class="col-sm-4">
										<input type="text" class="input-sm form-control validate[required,custom[specialnumber]]" name="specialnumber"   maxlength="11" placeholder="请填写100开头的11位数专线号">
									</div>
								</div>
								
							</div>
							 
							
			 
							



							<!-- *************  -->


							<!-- *******失败原因******  -->
							<div id="isError" class="form-group" style="display: none;">
								<label class="col-sm-2 control-label">失败原因</label>
								<div class="col-sm-9">
									<textarea rows="5" class="form-control validate[required]" name="desc" maxlength="200"
										id="desc" placeholder="此处可填写处理意见（必填项） "></textarea>
								</div>
							</div>
							<!-- *************  -->

 							<!-- *******页面编码  2 代表支撑******  -->
						<input type="hidden" value="2" name="node" id="node">	
						<input type="hidden" value="0" name="work_statis" id="work_statis"><!-- 原有状态  -->
						<input type="hidden" value="3" name="work_statis1" id="work_statis1"> <!-- 新的处理状态  -->
							<div class="form-group">
								<div class="col-sm-9 col-sm-offset-2">
									<button type="button" class="btn btn-sm btn-success btn-13"
										id="btn-ok">
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