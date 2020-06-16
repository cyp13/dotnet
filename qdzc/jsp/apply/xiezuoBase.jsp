<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<script>

var downloadUrl = host_+"/api/sys/downloadFile.do";
/* //酬金生成附件及意见
 	function getOpinionsAndFiles(fileList,element,flag){//flag存在则文件不可删除
 		if(!fileList)
 			return;
 		var portalUrl = '${s:getSysConstant("HOST_PORTAL")}';
 		
 		$.each(fileList,function(index,o){
 			var files = o.files;
 			var fileHtml="";
 			var imgHtml="";
 			if(files.length>0){
 				for (var i = 0; i < files.length; i++) {
 					var src = files[i].ext3;
					var realUrl = portalUrl+"/files/portal/"+src;
 					var url_ = downloadUrl+"?sysId="+sysId_+"&id="+files[i]['id'];
 					var ext = files[i].fileExt.toLowerCase();
 					var images = ['png','jpg','bmp','jpeg','gif'];//常见图片格式
 					var ifImage = false;
 					for (var j = 0; j < images.length; j++) {
 						if(ext==images[j]){
 							imgHtml += "&nbsp;&nbsp;<a state='normal' id='img_"+index+"' style='margin-left:20px;' onclick='downloadFile(this,true)'  realUrl='"+realUrl+"' data-id='"+files[i].id+"."+files[i].fileExt+"' data-url='"+url_+"' href='javascript:void(0);' target='_blank'><img width='80px'  src='"+realUrl+"' /></a>";
 							if(!flag && userName_==files[i].creater){//可删除
 								imgHtml+= "<a class='delFile_' state='normal' fileId='"+files[i].id+"' href='javascript:void(0);' "
 									+ "onclick='modifyFile($(this));'><span  style=\"color: red;\"><i class='fa fa-remove delFile'>删除</i></span></a>";
 							}
 							ifImage=true;
 							imgHtml +="&nbsp;&nbsp;&nbsp;";
 							break;
 						}
 					}
 					if(!ifImage){
 						fileHtml += "<a state='normal' title='点击下载' onclick='downloadFile(this)' realUrl='"+realUrl+"' data-id='"+files[i].id+"."+files[i].fileExt+"' data-url='"+url_+"' href='javascript:void(0);' target='_blank'>"+files[i].fileName+"."+files[i].fileExt+"</a>";
 						if(!flag && userName_==files[i].creater){
 							fileHtml += "&nbsp;&nbsp;<a state='normal' fileId='"+files[i].id+"' href='javascript:void(0);' "
 							+ "onclick='modifyFile($(this));'><span style=\"color: red;\"><i class='fa fa-remove delFile'></i>刪除</span></a>";
 						}
 						fileHtml +="&nbsp;&nbsp;&nbsp;";
 					}
 					
 					
 				}
 			}
 			var desc = "";
 			if(o.opinion){
 				desc = o.opinion;
 			}
 			
 			var opinionHtml = '<fieldset>'+
 		  	'<legend>'+o.task_name+'</legend>'+
 		  	'<div class="form-group">'+
 		  		'<label  class="col-sm-2 control-label">处理结果</label>'+
 		  		'<div class="col-sm-4">'+
 		  		'<input type="text" class="input-sm form-control " readonly  value="'+o.result+'" />'+
 		  		'</div>'+
 		  	'</div>'+
 		  	'<div class="form-group">'+
 		    '<label  class="col-sm-2 control-label">意见</label>'+
 		    '<div class="col-sm-9">'+
 		     '<textarea rows="5" class="form-control"  readonly>'+desc+'</textarea>'+
 		    '</div>'+
 		  '</div>'+
 		  '<div class="form-group">'+
 			'<label class="col-xs-2 control-label">附件：</label>'+
 			'<div class="col-xs-9 control-label" id="fileList" style="text-align: left;">'+
 			'<div id="imgDiv_">' +
 				imgHtml+
 			'</div>'+
 			'<div id="fileDiv_">' +
 				fileHtml+
 			'</div>'+
 			'</div>'+
 		'</div>'+
 		 '</fieldset>';
 			$(element).append(opinionHtml);
 			if(imgHtml!=""){
 				$("#imgDiv_").css("padding-bottom","10px");
 			}
 		});
 		
 	} */


 	//酬金生成附件及意见
 	function getOpinionsAndFiles(fileList,element,flag){//flag存在则文件不可删除
 		if(!fileList) return;
 		var portalUrl = '${s:getSysConstant("HOST_PORTAL")}';
 		var fileUploadDir = '${s:getSysConstant("FILE_UPLOAD_DIR")}';
 		var maskImgContent = "";
 		//循环意见
 		$.each(fileList,function(index,o){
 			var files = o.files;//附件
 			var fileHtml="";
 			var imgHtml="";
 			if(files.length>0){//附件不为空
 				var contentHtml = "";
				var images = ['png','jpg','bmp','jpeg','gif'];//常见图片格式
				//循环附件
 				for (var i = 0; i < files.length; i++) {
 					var src = files[i].ext3;//附件地址
					//var realUrl = portalUrl+"/files/portal/"+src;//附件绝对地址
					var realUrl = portalUrl+fileUploadDir+src;//附件绝对地址
 					var url_ = downloadUrl+"?sysId="+sysId_+"&id="+files[i]['id'];//附件下载地址
 					var ext = files[i].fileExt.toLowerCase();

 					var ifImage = false;
 					//判断当前文件是否为图片
 					for (var j = 0; j < images.length; j++) {
 						if(ext==images[j]){
 							ifImage=true;
 							break;
 						}
 					}

 					if(ifImage){
 						//文件创建日期
 						var fileCreateDate = ""+(files[i].created.year)+PrefixInteger((files[i].created.month),2)+PrefixInteger((files[i].created.day),2);
 						var imgUrlAddress = getSmallImgUrl(src,fileCreateDate);//根据图片创建日期应该显示的图片的地址
 						//var smallRealUrl = portalUrl+"/files/portal/"+imgUrlAddress; 						
 						var smallRealUrl = portalUrl+fileUploadDir+imgUrlAddress;
 						imgHtml+="&nbsp;&nbsp;<span state='normal' id='img_"+index+"' style='margin-left:20px;' onclick='seeImgFiles(this,true)'  data-index='"+index+"' realUrl='"+realUrl+"' data-id='"+o.id+"."+o.fileExt+"' data-url='"+url_+"'  target='_blank'><img width='80px'  data-id='"+realUrl+"' modal='zoomImg' src='"+smallRealUrl+"' /></span>";
 						if(!flag && userName_==o.creater){//可删除
 										imgHtml+= "<a class='delFile_' state='normal' fileId='"+o.id+"' href='javascript:void(0);' "
 											+ "onclick='modifyFile($(this));'><span  style=\"color: red;\"><i class='fa fa-remove delFile'>删除</i></span></a>";
 									}
 						/*
 						 if(!flag && userName_==o.creater){//可删除
 										imgHtml+= "<a class='delFile_' state='normal' fileId='"+o.file_ids+"' href='javascript:void(0);' "
 											+ "onclick='modifyFile($(this));'><span  style=\"color: red;\"><i class='fa fa-remove delFile'>删除</i></span></a>";
 									} 
 						*/
 						imgHtml +="&nbsp;&nbsp;";
 						contentHtml+='<li><img src="'+realUrl+'" /></li>'//当前生成的html
 					}else{
 						fileHtml += "<a state='normal' title='点击下载' onclick='downloadFile(this)' realUrl='"+realUrl+"' data-id='"+files[i].id+"."+files[i].fileExt+"' data-url='"+url_+"' href='javascript:void(0);' target='_blank'>"+files[i].fileName+"."+files[i].fileExt+"</a>";
 						if(!flag && userName_==files[i].creater){
 							fileHtml += "&nbsp;&nbsp;<a state='normal' fileId='"+files[i].id+"' href='javascript:void(0);' "
 							+ "onclick='modifyFile($(this));'><span style=\"color: red;\"><i class='fa fa-remove delFile'></i>刪除</span></a>";
 						}
 						fileHtml +="&nbsp;&nbsp;&nbsp;";
 					}
 				}
				
				
 			}
 			var desc = "";
 			if(o.opinion){
 				desc = o.opinion;
 			}
 			
 			var opinionHtml = '<fieldset>'+
 		  	/* '<legend>'+o.task_name+'</legend>'+ */
 		  	'<legend>'+''+'</legend>'+
 		  	'<div class="form-group">'+
 		  		'<label class="col-sm-2 control-label">处理人</label>'+
 		  		'<div class="col-sm-4">'+
 		  		'<input type="text" class="input-sm form-control" readonly value="'+o.USER_ALIAS+'"/>'+
 		  		'</div>'+
 		  		'<label  class="col-sm-1 control-label">处理结果</label>'+
 		  		'<div class="col-sm-4">'+
 		  		'<input type="text" class="input-sm form-control " readonly  value="'+o.result+'" />'+
 		  		'</div>'+
 		  	'</div>'+
 		  	'<div class="form-group">'+
 		    '<label  class="col-sm-2 control-label">意见</label>'+
 		    '<div class="col-sm-9">'+
 		     '<textarea rows="5" class="form-control"  readonly>'+desc+'</textarea>'+
 		    '</div>'+
 		  '</div>'+ 
 		  '<div class="form-group">'+
 			'<label class="col-xs-2 control-label">附件：</label>'+
 			'<div class="col-xs-9 control-label" id="fileList" style="text-align: left;">'+
 			'<div class="imgDiv_" id="imgDiv_'+index+'">' +
 				imgHtml+
 			'</div>'+
 			'<div class="fileDiv_" id="fileDiv_'+index+'">' +
 				fileHtml+
 			'</div>'+
 			'</div>'+
 		'</div>'+
 		 '</fieldset>';
 			$(element).append(opinionHtml);
 			if(imgHtml!=""){
 				$(".imgDiv_").css("padding-bottom","10px");
 			}
 			maskImgContent+=contentHtml;
 			$("#imgDiv_"+index).attr("data-id",contentHtml);
 			$("#imgDiv_"+index).attr("data-flag","false");
 			
 		});
 		
 		/*当存在图片加载js 和css 文件 和生成图片轮播*/
		if(maskImgContent!=""){
			
			var linkFlexslider = document.createElement("link");
			var script=document.createElement("script");
			linkFlexslider.rel="stylesheet";
			linkFlexslider.type="text/css";
			linkFlexslider.href="${ctx}/css/boxImg/boxImg.css";
			script.type="text/javascript";
			script.src="${ctx}/js/boxImg/boxImg.js";
			document.getElementsByTagName('head')[0].appendChild(linkFlexslider);
			document.getElementsByTagName('head')[0].appendChild(script);	
		}
 		
 	}

 	/*查看图片*/
 	function seeImgFiles(element,flag){

 		var portalUrl = '${s:getSysConstant("HOST_PORTAL")}';
 		var realUrl = $(element).attr('realUrl');//真实路径
		var msg = {
			    "type": "DOWNLOAD_FILE",    //  当前操作名称
			    "data": realUrl,   //  对应的data，例如： 附件url、查看大图的url,
			    "original_name": "ORDER_SYSTEM"    //  当前iframe名称----不可随意修改
			}; 		
		
		try {//判断顶层ip地址，若在portal内则直接打开下载文件，否则向集成PC端发送消息，让其下载文件
			var curHost = window.top.location.host;//当前页面host
			if(portalUrl.indexOf(curHost)>-1){
			
				
		/***************************************************************/				
				//找到图片显示的轮播
		 		var index = $(element).attr("data-index");//当前是第几组轮播	
				var idx = $(element).index();
				var elent = $("#imgDiv_"+index).find("img");

				var imgArray = "";
				elent.each(function(index,item){
					var uri = $(item).attr("src")+",,";
						imgArray+=  uri;
					})
				var indexCon = "&indexss="+idx;//当前显示第几张
				var token = "?token="+token_;//token
				var imgArray = "&img="+imgArray;//图片拼接的字符串
				var URL = "${ctx}/jsp/show_img/show_img.jsp"+token+imgArray+indexCon
				top.open(URL)

				
				
		/***************************************************************/				
				
			 }
			 else{
				 if(flag){
					 msg.type="SEE_BIG_PICTURE";//查看大图
				 }
				 window.top.postMessage(JSON.stringify(msg),msgdownloadUrl);
			 }
		} catch (e) {//由于window.top.location.host在集成pc端报错，则在catch中处理
			if(flag){
				 msg.type="SEE_BIG_PICTURE";//查看大图
			 }
			 window.top.postMessage(JSON.stringify(msg),msgdownloadUrl);
		} 		
 		

 		
 	
 	}


</script>
</head>
</html>