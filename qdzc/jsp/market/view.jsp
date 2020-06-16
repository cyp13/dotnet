<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<jsp:include page="/jsp/common/base.jsp"></jsp:include> 
<style type="text/css">
video {
    width: 400px !important;
    height: 300px !important;
}
</style>
<script>
//var yibanUrl = '${ctx}/jsp/';//已办列表URL
var queryUrl = "${ctx}/jsp/market/queryMarket.do"; 
var id='${param.id}'; 
var flag = '${param.flag}';  // 0 查看  1 审核
 	$(window).ready(function() {
 

 		
 		//填充机构信息
 		var orgObj = '${myUser.org}';
 		fillFormOrgs(JSON.parse(orgObj));
 		ifOnWork("#editForm *");
 		if(id){
			var obj = new Object();
			//实例ID
			obj.ID=id;
			obj.url=queryUrl;
			obj.token=token_;
			ajax(obj, function(data){
				var row = data.Rows[0]; 
				  
				$("#editForm").fill(row); 
				 
				$(".dataForm input[type='text'], .dataForm textarea, .dataForm select, .dataForm input[type='radio']").attr('disabled', 'disabled'); 

				  
				
			 	 if (row.files) {//附件处理  flag等于3时  就可以删除附件
			 		getFilesssssssss(row.files);//3代表不显示删除
					 
			 	 }
			 	 if('0'==flag){//未审核
						$("#type_2_3").show(); 
						$("#examine").hide(); 
						$("#type_2_3").find(":input,.dataForm input[type='radio']").attr("disabled", false);
						//$("#okStatus").attr("checked","checked") 默认选择
			 	 } else if('2'==flag){//审核
			 		$("#type_2_3").hide(); 
					$("#type_2_3").find(":input,.dataForm input[type='radio']").attr("disabled", true); 
					$("#btn-ok").hide();
					$("#cancel").html("返回")
			 	 }
			 	 
			 	 //处理数字转换为中文
			 	 var aaa=$("#STATUS").val();
			 	 var bbb=$("#ARTICLE_SWITCH").val(); 
			 	 if("2"==aaa){
			 		$("#STATUS").val("已通过");
			 		$("#STATUS").css("color","green")
			 	 }else if("1"==aaa){
			 		$("#STATUS").val("未通过");
			 		$("#STATUS").css("color","red")
			 		$("#noOk").show();
			 	 } 
			 	 if("0"==bbb){
			 		$("#ARTICLE_SWITCH").val("上架");
			 	 }else if("1"==bbb){
			 		$("#ARTICLE_SWITCH").val("下架");
			 	 }
			});
		}
 		
		$("#btn-ok").on("click", function() {
			var status = $("input[name='STATUSIS']:checked").val()
			if(status==null){
				layer.msg('请选择审核结果！', {icon: 3});
				return;
			}
			$(this).attr("disabled","disabled");
			var b = $("#editForm").validationEngine("validate");  
			if(b) { 
				var pa = new Object();
				pa.token = token_;
				pa.ID=id;
				pa.EXT1=$("#desc").val();
				pa.userName=userName_;
				pa.STATUS=status; 
				if("1"==status){//如果拒绝就下架，
					pa.ARTICLE_SWITCH='1';
				}
				ajaxSubmit("#editForm",pa, function(data) {
					if ("error" == data.resCode) {
						layer.msg(data.resMsg, {icon: 2});
						$("#btn-ok").removeAttr("disabled");
					} else {
						layer.msg("数据处理成功！", {
					          icon: 1
					        },
					        function() {
					          back_();
					        });
						}
				});
			} 
			else{
				$("#btn-ok").removeAttr("disabled");
			}
		});
		
		
		//视频监听事件
 		var vid = document.querySelector('video');
 		vid.addEventListener('play', function () {
 			aud.pause();
 	    }, false);
 		
 		
 		var aud = $('audio')[0];  
 		
 		aud.addEventListener('play', function () { 
 			vid.pause();
 		}, false);
		 
 	});
	
	 
 	//生成附件
 	function getFilesssssssss(fileList){//flag存在则文件不可删除
 		// 默认隐藏
 		$("#imgdiv").hide();
 		$("#videodiv").hide();
 		$("#audiodiv").hide();
 		
 		var fileUploadDir = '${s:getSysConstant("FILE_UPLOAD_DIR")}';
		var portalUrl = '${s:getSysConstant("HOST_PORTAL")}'; 
		$.each(fileList,function(index,o){ 
 			var ext = o.fileExt.toLowerCase();
			var images = ['png','jpg','bmp','jpeg','gif'];//常见图片格式
			var videos = ['mp4','avi','wmv','mpeg4','3gp','mov'];//常见视频格式MP4  webm ogg
			var audios = ['mp3','mpeg','amr','wma','wave','wav'];//常见音频格式
			//var realUrl = portalUrl+"/files/portal/"+sysId_+"/"+o.id+"."+o.fileExt;
			var realUrl = portalUrl+fileUploadDir+sysId_+"/"+o.id+"."+o.fileExt;
			for (var i = 0; i < images.length; i++) { 
				if(ext==images[i]){    
					$("#imgdiv").show();
					$("#imgjdz").attr("src",realUrl) 
					break;
				} 
			}
			for (var i = 0; i < videos.length; i++) {  
				if(ext==videos[i]){   
			 		$("#videodiv").show(); 
					$("#view").attr("src",realUrl) 
					$("#view").attr("type",'video/'+ext) 
					$("#videoplay").load();
					break;
				} 
			}
			for (var i = 0; i < audios.length; i++) {
				if(ext==audios[i]){

			 		$("#audiodiv").show();
					$("#audiojdz").attr("src",realUrl)
					break;
				}
			}
			 
		});
	}
 
	
	function isorno(value) {
		$("#btn-ok").removeAttr("disabled");
		if (value == '1') {
			$("#isError").show(); 
			$("#isError").find(":input").attr("disabled", false);
			//$("#editForm").attr("action","${ctx}/jsp/work/subSpecial.do"); //如果是驳回就修改为提交url
		 
		} else if (value = '2') {  
			$("#isError").hide();
			$("#isError").find(":input").attr("disabled", true);
			 
			
		}
	}
	
	//视频播放暂停
	function vstop(){
		
	}
	//音频播放暂停
	function astop(){
		
	}
</script>
</head>

<body class="gray-bg">
    <div class="wrapper wrapper-content animated fadeIn">
        <div class="row">
            <div class="col-sm-12">
                <div class="ibox float-e-margins">
                    <div class="ibox-title" style="display: ${'mywork' ne param.page ? '' : 'none'};">
	                    <h5><i class="fa fa-info-circle"></i> 待审批&nbsp;&nbsp;>&nbsp;&nbsp;文章详情</h5>
                    	<div class="ibox-tools">
	                       <a class="a-reload">
	                          <i class="fa fa-repeat"></i> 刷新
	                       </a>
	                       <a class="a-back">
	                          <i class="fa fa-reply"></i> 返回
	                       </a>
	                    </div>
	                </div>
   					<div class="ibox-title">
   						<p>营销金点子</p>
	                </div>
			
		            <div class="ibox-content">
		            <div class="dataForm">
                       <form id="editForm" action="${ctx}/jsp/market/updateMarket.do"  method="post" class="form-horizontal key-13" > 
                       <input type="hidden" name="REQSOURCE" value="pc">
							   <div class="form-group"> 
								    <label class="col-sm-2 control-label">区县</label>
								    <div class="col-sm-4">
								    	<input type="text" class="input-sm form-control "  name="county_name" id="county_name" readonly>
								    	<input type="text" class="hide" name="COUNTY" id="county" >
								    </div>
    								  <label class="col-sm-1 control-label">分局</label>
								    <div class="col-sm-4">
								    	<input type="text" class="input-sm form-control " name="branch_office_name"  id="branch_office_name" readonly>
							    		<input type="text" class="hide" name="BRANCH_OFFICE" id="branch_office" >
							   		 </div>
							   </div>
							  <div class="form-group">

							  
							    <label class="col-sm-2 control-label">渠道</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control "  name="CHANNEL_NAME" id="channel_name" readonly>
							    </div>
							    <label class="col-sm-1 control-label">发布人</label>
							    <div class="col-sm-4">
							    	<input type="text" class="input-sm form-control " name="CREATER" id="CREATER"  readonly>
							    </div>
							  </div>
		
							  <div class="form-group"> 

								<label class="col-sm-2 control-label ">业务类型</label>
								<div class="col-sm-4">
									<s:dict dictType="jdztype" name="ARTICLE_TYPE" type="select" clazz="validate[required] form-control" ></s:dict>
								</div> 
							    <label class="col-sm-1 control-label ">发布时间</label>
							    <div class="col-sm-4">
							        <input type="text" class=" form-control validate[required]  " name="CREATED"  >
							    </div>
							  </div> 

<div id="examine"> 
							  <div class="form-group"> 
							    <label class="col-sm-2 control-label">评论数</label>
							    <div class="col-sm-4">
							     	<input type="text" class="input-sm form-control validate[required]"   readonly name="COMMENTCOUNT" id="COMMENTCOUNT" >
							    </div>
								<label class="col-sm-1 control-label ">点赞数</label>
								<div class="col-sm-4">
							     	<input type="text" class="input-sm form-control validate[required]"   readonly name="LIKECOUNT" id="LIKECOUNT" >

								</div> 
							  </div> 
  							  <div class="form-group"> 
							    <label class="col-sm-2 control-label">审核状态</label>
							    <div class="col-sm-4">
							     	<input type="text" class="input-sm form-control validate[required]"   readonly name="STATUS" id="STATUS" >
 							    </div>
								<label class="col-sm-1 control-label ">上下架状态	</label>
								<div class="col-sm-4">
							     	<input type="text" class="input-sm form-control validate[required]"   readonly name="ARTICLE_SWITCH" id="ARTICLE_SWITCH" >
									 
								</div> 
							  </div> 
						 
  							  <div class="form-group" id="noOk"  style="display: none;">  
								<label class="col-sm-2 control-label">未通过原因</label>
								<div class="col-sm-9">
									<textarea rows="5" class="form-control validate[required]" name="EXT1" maxlength="200" >
									</textarea>
								</div>
							</div>
						  
							  
   							  <div class="form-group"> 
							    <label class="col-sm-2 control-label">审核时间</label>
							    <div class="col-sm-4">
								 <input type="text" class=" form-control validate[required]  " name="MOFIFIED"  >
 							    </div>
							  </div> 
</div>
							  
							<div class="form-group">

							    <label class="col-sm-2 control-label ">宣传标题</label>
							    <div class="col-sm-4">
							        <input type="text" class=" form-control validate[required]  " name="ARTICLE_TITLE" maxlength="30" placeholder="请输入30字以内标题"  >
							    </div>

							</div>	
	  
						 <div class="form-group">  
						    <!--法人手机-->
						    <label class="col-sm-2 control-label ">宣传内容</label>
						    <div class="col-sm-9"  >
 							<textarea rows="5" class="form-control validate[required]" maxlength="300" rows="6" name="ARTICLE_PAGE" id="description" ></textarea>
 						    </div>
						</div>
					 		 
				 			 
				 			<!-- end -->		 
				 			
				 			
							 <div class="form-group" id="imgdiv">   
							    <label class="col-sm-2 control-label ">图片内容（1）</label>
							    <div class="col-sm-6" style="width:400px;height: 300px">
								<img id="imgjdz" alt="图片加载失败" src=""
								style="width: 100%;height:100%">
								</div>
					  	  	</div>	
							<div class="form-group" id="videodiv">   
							    <label class="col-sm-2 control-label ">视频内容（1）</label>
								<div class="col-sm-6" style="width:400px;height: 300px">  
									<video id="videoplay" controls >
										<source  id="view" onclick="alert(1)"  >
									</video>
								</div>
					  	  	</div>
							<div class="form-group" id="audiodiv">   
							    <label class="col-sm-2 control-label ">音频内容（1）</label>
							    <div class="col-sm-6" style="width:400px;height: 100px"> 
									<audio id="audiojdz"   
									controls="controls" style="margin: 30px 0;width: 100%;height: 50px;line-height: 50px;
									border: 1px solid #e6e6e7;background-color: #f7f7f8;border-radius: 1px;"> 
									</audio>   
								</div> 
					  	  	</div>	
					  	  	 		
							
							<div id="type_2_3"> 
								<div class="form-group">
									<label class="col-sm-2 control-label">处理结果</label>
									<div class="col-sm-4">
										<label> <input type="radio"   
											onclick="isorno(this.value)" id="okStatus" name="STATUSIS" value="2" /><span
											style="padding: 0px 10px 0px 5px;">通过</span>

										</label> <label> <input type="radio"
											onclick="isorno(this.value)" name="STATUSIS" value="1" /><span
											style="padding: 0px 10px 0px 5px;">不通过</span>
										</label>
									</div>
								</div>
							</div>
							
							<!-- *******失败原因******  -->
							<div id="isError" class="form-group" style="display: none;">
								<label class="col-sm-2 control-label">失败原因</label>
								<div class="col-sm-9">
									<textarea rows="5" class="form-control validate[required]" name="desc" maxlength="200"
										id="desc" placeholder="此处可填写处理意见（必填项） "></textarea>
								</div>
							</div>
							
							
							
							
							
							   <div class="form-group">
								   	<div class="col-sm-9 col-sm-offset-2">
								   		<button type="button" class="btn btn-sm btn-success btn-13" id="btn-ok">
						                	<i class="fa fa-check"></i> 确认
						                </button>
								 
								   	<a class="a-back">
								   		<button type="button" class="btn btn-sm btn-success btn-13" >  
						                          <i class="fa fa-reply"></i> <span id="cancel">取消</span>
						                </button>
						            </a>
								   	</div>
 
							   </div> 
							</form>
				 </div>
			            </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>