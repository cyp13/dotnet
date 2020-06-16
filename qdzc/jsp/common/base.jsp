<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
	String templateName = request.getParameter("templateName");
%>
<base href="<%=basePath %>">
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="session" />

<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<title>渠道支持服务平台</title>

<link href="${ctx}/js/bootstrap/css/bootstrap.min.css?v=3.3.7" rel="stylesheet">
<link href="${ctx}/css/font-awesome/css/font-awesome.min.css?v=4.7.0" rel="stylesheet">
<link href="${ctx}/css/animate/animate.css?v=3.5.2" rel="stylesheet">
<link href="${ctx}/js/plugins/select/bootstrap-select.css" rel="stylesheet"  />


<link href="${ctx}/js/hplus/style.css?v=4.1.0" rel="stylesheet">
<link href="${ctx}/js/plugins/dataTables/css/jquery.dataTables.css" rel="stylesheet">
<link href="${ctx}/js/plugins/dataTables/css/dataTables.bootstrap.css" rel="stylesheet">

<link href="${ctx}/js/plugins/ztree/css/zTreeStyle/zTreeStyle.css?v=3.5.19" rel="stylesheet">
<link href="${ctx}/js/plugins/validation-engine/validationEngine.jquery.css" rel="stylesheet">
<link href="${ctx}/js/plugins/wdatePicker/skin/WdatePicker.css" rel="stylesheet">

<script src="${ctx}/js/jquery.min.js?v=2.1.4"></script>
<!-- 日期控件 -->
<script src="${ctx}/js/plugins/wdatePicker/WdatePicker.js"></script>
<%-- <script src="${ctx}/js/plugins/ztree/jquery.ztree.all.min.js?v=3.5.29"></script> --%>
<script src="${ctx}/js/plugins/ztree/jquery.ztree.all.js?v=3.5.37"></script>
<script src="${ctx}/js/plugins/select/bootstrap-select.js"></script>
<script src="${ctx}/js/plugins/select/defaults-zh_CN.js"></script>

<script src="${ctx}/js/plugins/layer/layer.js?v=3.0.3"></script>

<script src="${ctx}/js/bootstrap/js/bootstrap.min.js?v=3.3.7"></script>
<script src="${ctx}/js/bootstrap/js/bootstrap-typeahead.js"></script>

<script src="${ctx}/js/plugins/prettyfile/bootstrap-prettyfile.js"></script>


<script src="${ctx}/js/hplus/content.js?v=1.0.0"></script>

<script src="${ctx}/js/plugins/validation-engine/jquery.validationEngine.js"></script>
<script src="${ctx}/js/plugins/validation-engine/jquery.validationEngine-zh_CN.js"></script>

<script src="${ctx}/js/jquery.form.js"></script>
<script src="${ctx}/js/jquery.formautofill.js"></script>
<script src="${ctx}/js/public.js"></script>

<script src="${ctx}/js/plugins/dataTables/js/jquery.dataTables.min.js?v=1.10.15"></script>
<script src="${ctx}/js/plugins/dataTables/js/dataTables.bootstrap.min.js?v=3"></script>


<!-- 自定义js -->
<script src="${ctx}/js/hplus/hplus.js?v=4.1.0"></script>
<script src="${ctx}/js/hplus/contabs.js"></script>

<script src="${ctx}/js/echarts/echarts.js"></script>

<style type="text/css">
.delFile_{
	position:absolute;
}

.ibox-title p{
	font-size:18px;
	text-align:center;
}

.ibox-content{
	border:none;
}
.red{
	color:#F00;
}
.dark-red{
	color:#8B0000;
}
.orange{
	color:#FF7F00;
}
.green{
	color:#008B00;
}
.table th {
	border-bottom: 1px solid #111 !important;
}
.form-control[disabled], .form-control[readonly], fieldset[disabled] .form-control {
	background-color: #f9f9f9;
	background-image: none;
}
[class*="validate\[required"] {
    padding-right:20px;
	background-image: url("${ctx}/images/icon_star.png");
    background-position: calc(100% - 5px);
    background-repeat: no-repeat;
}
select[class*="validate\[required"] {
	appearance:none;
	-moz-appearance:none;
	-webkit-appearance:none;
	line-height:20px;
}
select[class*="validate\[required"]::-ms-expand {
	display:none
}
/* 解决select高度不一致 */
select.form-control.input-sm{
	padding: 4px 12px;
}
/*进度条样式 */
 .progressbar
 {
     position:relative;background:#bbb;width:100%;height:16px;overflow:hidden;
 }
 .progressbar-percent
 {
     position:absolute;height:18px;background:blue;left:0;top:0px;overflow:hidden;
     z-index:1;
 }
 .progressbar-label
 {
     position:absolute;left:0;top:0;width:100%;font-size:13px;color:White;
     z-index:10;
     text-align:center;
     height:16px;line-height:16px;
 }
 
 .wrapper-content{
 padding:10px 20px 5px;
}

.dropdown-menu li{
	overflow: hidden;
	text-overflow: ellipsis;
	white-space: nowrap;
	max-width:100%;
}

</style>

<script>
	$.fn.dataTable.ext.errMode = 'none';
	var userName_ = '${myUser.userName}';
	var userId_ = '${myUser.id}';
	var enterprise_flag_ = '${myUser.org.ext1}';
	
	var host_ = '<s:dict dictType="host" dictName="portal" type="string"/>';
	var qdzc_ = '<s:dict dictType="host" dictName="local" type="string"/>';
	
	var token_='${param.token}';
	var sysId_='${myUser.sysId}';//'${s:getSysConstant("SYS_ID")}';//系统ID
	var managerRoleId_='${s:getSysConstant("SYS_MANAGER_ROLE_ID")}';//系统管理员角色ID
	var msgdownloadUrl='${s:getSysConstant("MSG_DOWNLOAD_URL")}';//集成PC下载url
	
	var phrases =[];
	
	//查询当前是否为用户对应企业的上班时间
	function ifOnWork(ele){
		var param = new Object();
		param.url='${ctx}/jsp/sys/ifOnWork.do';
		param.type='1';//表示工单。
		param.enterprise_flag=enterprise_flag_;//企业标识。
		ajax(param, function(data){
			if(!data.ifOnWork){
				layer.msg('当前为下班时间，请在上班时间内发起工单！<br>工作时间：' + data.workStartTime + ' - ' + data.workEndTime, {icon: 0});
				$(ele).attr("disabled", "disabled");
			}
		});
	}
	
	$(window).ready(function() {
		
		$("body").on('click','#btn-insert,#btn-update',function(){
			if($(".showDetail").length>0||$(".detail_").length>0){
				//将只读的文本框变为可编辑，显示确定按钮。
				$("#editForm input,#editForm textarea").removeAttr("readonly");
				$("#editForm input[read='read'],#editForm textarea[read='read']").attr('readonly','readonly');
				$("#editForm select").attr("disabled", false);
				$("#btn-ok").show();
			}
			// 初始化select
			$("#editForm .selectpicker").selectpicker("val",'');
			//将删除多余的多文件输入框。
			$(".diyFile").find('a[onclick="$deleteFile(this)"]').click();
		});
		
		//查看某条数据详情，数据变为只读。
		$("body").on('click',".showDetail", function() {
			$("#editForm input,#editForm textarea").attr("readonly","readonly");
			$("#editForm select").attr("disabled", true);
			$("#btn-ok").hide();
			
			var url = $(this).data("url");
			var row = $(this).data("obj");

			$("#editForm")[0].reset();
			$("#myModal").modal("show");
			
			if(row){
				row=eval('('+row+')');
				$("#editForm").fill(row);
				setDataToSelect(row);
				return;
			}

			var obj = new Object();
			obj.url = url;
			obj.id = $(this).data("id");
			ajax(obj, function(data) {
				if ("error" == data.resCode) {
					error(data.resMsg);
					//layer.msg(data.resMsg, {icon: 2});
				} else {
					$("#editForm").fill(data.Rows[0]);
					setDataToSelect(data.Rows[0]);
				}
			});
       	});
		
		
		$("#checkAll_,.checkAll_").on("click", function() {
			$("input[name='ids_'],.ids").prop("checked", $(this).prop("checked"));
		});
		
	 	$(".a-reload").on("click", function() {
			location.reload();
		});

	 	$(".a-back").on("click", function() {
	 		location.href = document.referrer;
	 		/**
	 		if (self.frameElement && self.frameElement.tagName == "IFRAME") { 
				self.frameElement.contentWindow.history.back();
			} else {
				history.back();
			}**/
		});

	 	$(".a-go").on("click", function() {
	 		history.back();
		});
		
		$(".key-13").bind("keypress", function(e) {
			try {
			    var theEvent = e || window.event;
			    var code = theEvent.keyCode || theEvent.which || theEvent.charCode;
			    if (code == 13 && !($(":focus").is("textarea"))) {
			        e.preventDefault();
			      	$(this).find(".btn-13").click();
			    }
			} catch(ex) {
			}
		});
		
		 $(".date_picker").on("click", function() {
			var format = $(this).attr("format");
			if(!format){
				format = "yyyy-MM-dd HH:mm:ss";
			}
	 		WdatePicker({el:this,dateFmt:format});
		});
		
		 $(".date_picker_start").on("click", function() {
			var format = $(this).attr("format");
			if(!format){
				format = "yyyy-MM-dd HH:mm:ss";
			}
	 		WdatePicker({dateFmt:format,maxDate:'#F{$dp.$D(\'endTime\')}'});
		});
		
		 $(".date_picker_end").on("click", function() {
			var format = $(this).attr("format");
			if(!format){
				format = "yyyy-MM-dd HH:mm:ss";
			}
	 		WdatePicker({dateFmt:format,minDate:'#F{$dp.$D(\'startTime\')}'});
		});
		
	 	$(".modal").on("hidden.bs.modal", function() {
			try {
				$(".modal form").resetForm();
				$("form").validationEngine("hideAll");
			} catch(ex) {
			}
		});

		try {
			$("input[type='file']").prettyFile();
		} catch(ex) {
		}
		
		
		//开始时间和结束时间
		if($(".start-day").length == $(".end-day").length){
			$(".start-day").each(function(i,item){
				var startDay = {
				    format: 'YYYY-MM-DD',
				    isinitVal: false,
				    festival: false,
				    ishmsVal: false,
				    choosefun: function(elem,datas){
				    	endDay.minDate = datas+" 00:00:00"; //开始日选好后，重置结束日的最小日期
				    }
				};
				var endDay = {
				    format: 'YYYY-MM-DD',
				    isinitVal: false,
				    festival: false,
				    ishmsVal: false,
				    choosefun: function(elem,datas){
				        startDay.maxDate = datas+" 00:00:00"; //将结束日的初始值设定为开始日的最大日期
				    }
				};
				$(item).attr("readonly","readonly");
				$(item).jeDate(startDay);
				$($(".end-day")[i]).attr("readonly","readonly");
				$($(".end-day")[i]).jeDate(endDay);
			});
			
		}
		
		
		//时间转换
		Date.prototype.format = function(format) {
		    var date = {
		       "M+": this.getMonth() + 1,
		       "d+": this.getDate(),
		       "h+": this.getHours(),
		       "m+": this.getMinutes(),
		       "s+": this.getSeconds(),
		       "q+": Math.floor((this.getMonth() + 3) / 3),
		       "S+": this.getMilliseconds()
		    };
		    if (/(y+)/i.test(format)) {
		       format = format.replace(RegExp.$1, (this.getFullYear() + '').substr(4 - RegExp.$1.length));
		    }
		    for (var k in date) {
		       if (new RegExp("(" + k + ")").test(format)) {
		           format = format.replace(RegExp.$1, RegExp.$1.length == 1
		              ? date[k] : ("00" + date[k]).substr(("" + date[k]).length));
		       }
		    }
		    return format;
		}
		
		$("body").bind("mousedown", function(event) {
			try {
				if(3 == event.which) {
					layer.closeAll("loading");
				}
			} catch(ex) {
			//	console.log(ex);
			}
		});
	//标题传参
		var pName='${param.title_add_name}';
		if(pName && pName!="")
 		$(".ibox-title:first h5").append("--"+pName);
		
		try {
			//多选
			$(".multiple").attr("multiple","multiple");
			
			//可搜索
			$(".selectpicker").attr("data-live-search","true");
			$(".selectpicker").selectpicker({
				actionsBox: true,
				style: "btn-white"
			});
			$(".selectpicker").selectpicker("render");
			$(".selectpicker").selectpicker("refresh");
			$(".selectpicker").selectpicker("val","");
			//$(".selectpicker").selectpicker("val", []);//"2".split(",")
		} catch(ex) {
		//	console.log(ex);
		}
	//多选框
		$("select[multiple]").selectpicker({
			actionsBox: true,
			style: "btn-white"
		});
	
		var insertPhraseUrl = "${ctx}/jsp/work/insertPhrase.do";
		//快速添加个人常用语
		$("#addPhrase").on("click", function() {
			layer.confirm('您确定要将该意见设置为个人常用语吗？', {icon: 3}, function() {
				var desc = $("#desc").val();
				if(desc){
					var obj = new Object();	
					obj.url = insertPhraseUrl;
					obj.type = '1';//工单
					obj.property = '2';//私有
					obj.row_valid = '1';//有效
					obj.corporate_identify = enterprise_flag_;//企业标识
					obj.content = desc;//内容
					obj.title = $("#service_type_detail option:checked").text();//标题
				
					ajax(obj, function(data) {
						if ("error" == data.resCode) {
							layer.msg(data.resMsg, {icon: 2});
						} else {
							layer.msg("设置成功！", {icon: 1});
						}
					});
				}else{
					alert("请填写意见后再添加常用语！");
				}
				
			});
		});
		
	});
	
	//获取流程变量
	function queryProcessVariable(param,callback){
 		param.url=host_+"/api/jbpm/queryVariable.do";
 		param.sysId=sysId_;
 		param.token=token_;
 		ajax(param, function(data){
 			if(data.resCode=="success"){
	 			if(callback){
	 				callback(data.datas);
	 			}
 			return data;
 			}
 			else{
 				alert(data.resMsg);
 			}
 		})
 	}
	
	//给selectpicker 赋值
	function setDataToSelect(data){
		var selects = $(".selectpicker");
		if(selects.length>0){
			$.each(selects,function(index,o){
				var name = $(o).attr('name');
				$(o).selectpicker('val', data[name]);
			});
		}
	}
	
	//用于将数据封装成下拉框等形式。
	function formatData(data,_value,_name,type,element,flag){
		var htm = '';
		switch (type) {
		case "select":
			$.each(data,function(index,o){
				if(flag && flag.constructor === String){
					var flagData = o[flag];
					if(flag=="orgName"){
						flagData = o.org.orgName;
					}
					if(!flagData){
						flagData = "";
					}
					htm+='<option value="'+o[_value]+'">'+o[_name]+'('+flagData+')</option>';
				}else if(flag){
					htm+='<option value="'+o[_value]+'">'+o[_name]+'('+o[_value]+')</option>';
				}else{
					htm+='<option value="'+o[_value]+'">'+o[_name]+'</option>';
				}
			});
			if($(element)){
				$(element).html(htm);
				if($(element).hasClass('selectpicker')){
					$(element).selectpicker("render");
					$(element).selectpicker("refresh");
				}
			}
			break;
		case "selects":
			$.each(data,function(index,o){
				if(flag && flag.constructor === String){
					htm+='<option value="'+o[_value]+'">'+o[_name]+'('+o[flag]+')</option>';
				}else if(flag){
					htm+='<option value="'+o[_value]+'">'+o[_name]+'('+o[_value]+')</option>';
				}else{
					htm+='<option value="'+o[_value]+'">'+o[_name]+'</option>';
				}
			});
			if($(element)){
				$(element).html(htm);
				if($(element).hasClass('selectpicker')){
					$(element).selectpicker("render");
					$(element).selectpicker("refresh");
				}
			}
			break;
		default:
			break;
		}
	}
	
	//获取字典并生成下拉选项
	function getDictToPage(parentId,element){
		var pa = new Object();
			pa.url='${ctx}/jsp/sys/queryDict.do';
			pa.parentId = parentId;
			pa.rowValid = "1";
			pa.async = false;
			ajax(pa, function(data){
				if("success"==data.resCode){
					formatData(data.Rows,"dictValue","dictName","select",element);//eval('('+userList+')')
				}
			});
	}
	
	
	function alert(msg){
		layer.msg(msg,{icon:0});
	}
	
	function success(msg){
		layer.msg(msg,{icon:1});
	}
	
	function error(msg){
		layer.msg(msg,{icon:2});
	}
	
	function confirm(msg){
		layer.confirm(msg);
	}
	
	/*向portal发起请求。
	新开窗口：action="menuItem";name="menuName";target="url";
	关闭窗口:action="closeItem";target="url";
	调用某元素的点击事件：obj.action="click";obj.target=".a-back";
	*/
	function postMessage(obj){
		try{
			window.parent.postMessage(obj,'*');
		}
		catch (e) {
		}
	}
	
	//关闭当前页面
 	function closeCurPage(){
 		var obj = new Object();
		obj.action="closeItem";
		obj.target = location.href;
		postMessage(obj);
 	}
	
	function back_(){
		var obj = new Object();
 		obj.action='click';
 		obj.target='.a-back';
 		postMessage(obj);
	}
	function reload_(){
		var obj = new Object();
 		obj.action='click';
 		obj.target='.a-reload';
 		postMessage(obj);
	}
	var downloadUrl = host_+"/api/sys/downloadFile.do?sysId=" + sysId_;
	var deleteFileIds = new Object();
	
	
	function PrefixInteger(num, n) {
	    return (Array(n).join(0) + num).slice(-n);
	}
	
	function getFiles(fileList,element,flag){
	 	
	 	var portalUrl = '${s:getSysConstant("HOST_PORTAL")}';	
	 	var fileUploadDir = '${s:getSysConstant("FILE_UPLOAD_DIR")}';
	 	$(element).html('<div id="imgDiv_"></div><div id="fileDiv_"></div>');//添加两个容器
		var images = ['png','jpg','bmp','jpeg','gif','webp'];//常见图片格式	
		var contentHtml = "";
		
		$(fileList).each(function(index,o){
			
			var fileHtml = "";//文件html
			var imgHtml = "";//图片html
			var ext = o.fileExt.toLowerCase();//图片后缀名字
			var src = o.ext3;//文件地址
			
			//var realUrl =  portalUrl+"/portal/uploads/"+src;
			var realUrl =  portalUrl+fileUploadDir+src;
			var t = downloadUrl.lastIndexOf("?sysId")>-1?"&":"?";
			var url_ = downloadUrl+t+"id="+o.id;
			var isImg = false;
			for(var i = 0,len=images.length;i<len;i++){
				if(images[i]==ext){//当文件是图片
					isImg = true;
					break;			
				}	
			}
			if(isImg){	
				//文件创建日期
				var fileCreateDate = ""+(o.created.year)+PrefixInteger(o.created.month,2)+PrefixInteger(o.created.day,2);
				var imgUrlAddress = getSmallImgUrl(src,fileCreateDate);//根据图片创建日期应该显示的图片的地址
				//var smallRealUrl = portalUrl+"/files/portal/"+imgUrlAddress;
				var smallRealUrl = portalUrl+fileUploadDir+imgUrlAddress;
				imgHtml += imgHtml+="&nbsp;&nbsp;<span state='normal' id='img_"+index+"' style='margin-left:20px;'  onclick='seeImgFile(this,true)'  realUrl='"+realUrl+"' data-id='"+o.id+"."+o.fileExt+"' data-url='"+url_+"'  target='_blank'><img width='80px'  data-id='"+realUrl+"' modal='zoomImg' src='"+smallRealUrl+"' /></span>";
				if(!flag && userName_==o.creater){//可删除
								imgHtml+= "<a class='delFile_' state='normal' fileId='"+o.id+"' href='javascript:void(0);' "
									+ "onclick='modifyFile($(this));'><span  style=\"color: red;\"><i class='fa fa-remove delFile'>删除</i></span></a>";
							}
				imgHtml +="&nbsp;&nbsp;";
				contentHtml+='<li><img src="'+realUrl+'" /></li>'
			}else{
				fileHtml += "<a state='normal' title='点击下载' onclick='downloadFile(this)' realUrl='"+realUrl+"' data-id='"+o.id+"."+o.fileExt+"'   data-url='"+url_+"' href='javascript:void(0);' target='_blank'>"+o.fileName+"."+o.fileExt+"</a>";
				if(!flag && userName_==o.creater){
							fileHtml += "&nbsp;&nbsp;<a state='normal' fileId='"+o.id+"' href='javascript:void(0);' "
							+ "onclick='modifyFile($(this));'><span style=\"color: red;\"><i class='fa fa-remove delFile'></i>刪除</span></a>";
						}
				fileHtml +="&nbsp;&nbsp;";		
				
			}
			$("#imgDiv_").append(imgHtml);
			$("#fileDiv_").append(fileHtml);
			if(imgHtml!=""){
		 		$("#imgDiv_").css("padding-bottom","10px");
		 	}
		})	
		
		$("#imgDiv_").attr("data-id",contentHtml)
		$("#imgDiv_").attr("data-flag","false");
 		//当存在图片加载js 和css 文件 和生成图片轮播
		if(contentHtml!=""){
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
	
	
 	/* 图片地址转换为缩略图地址 */
 	function getSmallImgUrl(bigImgUrl,imgCreateDate){
 		var smallImgUrl = "";
 		//当前图片创建时间小于特定时间则显示为原图
 		if(Number(imgCreateDate)<20181123){
 			smallImgUrl = bigImgUrl;
 		}else{
 			var len = bigImgUrl.lastIndexOf(".");
 			var strStart = bigImgUrl.substr(0,len);
 			var strEnd =bigImgUrl.substring(len);
 			smallImgUrl = strStart+"-small"+strEnd;
 		}
 		return smallImgUrl;
 	}
 	
 	//查看大图
	function seeImgFile(ele,flag){
 
	/***********************************************/		
		var indexss = $(ele).index();//当前是第几张图片
		var element = $("#imgDiv_ img");//显示图片的容器

		var imgArray = "";
		element.each(function(index,item){
			var uri = $(item).attr("src")+",,";
				imgArray+=  uri;
			})
		var indexCon = "&indexss="+indexss;//当前显示第几张
		var token = "?token="+token_;
		var imgArray = "&img="+imgArray;//图片拼接的字符串
		var URL = "${ctx}/jsp/show_img/show_img.jsp"+token+imgArray+indexCon
		top.open(URL)

	/***********************************************/			
			 
	}
 	
 	//查看大图——废弃
	function seeImgFile_废弃(ele,flag){
		var portalUrl = '${s:getSysConstant("HOST_PORTAL")}';
 		var realUrl = $(ele).attr('realUrl');//真实路径
		var msg = {
			    "type": "DOWNLOAD_FILE",    //  当前操作名称
			    "data": realUrl,   //  对应的data，例如： 附件url、查看大图的url,
			    "original_name": "ORDER_SYSTEM"    //  当前iframe名称----不可随意修改
			}; 		
		try {//判断顶层ip地址，若在portal内则直接打开下载文件，否则向集成PC端发送消息，让其下载文件
			var curHost = window.top.location.host;//当前页面host
			if(!portalUrl||portalUrl.indexOf(curHost)>-1){		
				/***********************************************/		
					var indexss = $(ele).index();//当前是第几张图片
					var element = $("#imgDiv_ img");//显示图片的容器

					var imgArray = "";
					element.each(function(index,item){
						var uri = $(item).attr("src")+",,";
							imgArray+=  uri;
						})
					var indexCon = "&indexss="+indexss;//当前显示第几张
					var token = "?token="+token_;
					var imgArray = "&img="+imgArray;//图片拼接的字符串
					var URL = "${ctx}/jsp/show_img/show_img.jsp"+token+imgArray+indexCon
					top.open(URL)
			
				/***********************************************/			
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
 	

	function downloadFile(ele,flag){//flag存在表示预览
		var portalUrl = '${s:getSysConstant("HOST_PORTAL")}';
		//http://192.168.5.164:8080/files/portal/026b17ad-a099-45c1-beb5-316d300c7f23/00a60640-96e6-49eb-96d3-635802012c57.jpg
		var realUrl = $(ele).attr('realUrl');//真实路径
		var msg = {
		    "type": "DOWNLOAD_FILE",    //  当前操作名称
		    "data": realUrl,   //  对应的data，例如： 附件url、查看大图的url,
		    "original_name": "ORDER_SYSTEM"    //  当前iframe名称----不可随意修改
		};

		try {//判断顶层ip地址，若在portal内则直接打开下载文件，否则向集成PC端发送消息，让其下载文件
			var curHost = window.top.location.host;//当前页面host
			if(portalUrl.indexOf(curHost)>-1){
				if(flag){//预览
					window.open(realUrl);
				}else{//下载
					window.open($(ele).attr('data-url'));
				}
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
	
	function modifyFile(ele){
		var state = ele.attr('state'), fileId = ele.attr('fileId');
		if(state=='normal'){
			ele.html('<span style="color: gray;"><i class="fa fa-mail-reply"></i>恢复</span>');
			ele.attr('state', 'deleted');
			ele.prev('a').attr('state', 'deleted');
			ele.prev('a').css('color', 'gray');
			deleteFileIds[fileId] = fileId;
		}else{
			ele.html('<span style="color: red;"><i class="fa fa-remove"></i>删除</span>');
			ele.attr('state', 'normal');
			ele.prev('a').attr('state', 'normal');
			ele.prev('a').css('color', '');
			delete deleteFileIds[fileId];
		}
	}
	
	function fillFormOrgs(orgObj){
		var orgType = orgObj.orgType;
		switch (orgType) {
		case '5':
			$("#channel").val(orgObj.id);
			$("#channel_name").val(orgObj.orgName);
			break;
		case '4':
			$("#branch_office").val(orgObj.id);
			$("#branch_office_name").val(orgObj.orgName);
			break;
		case '3':
			$("#county").val(orgObj.id);
			$("#county_name").val(orgObj.orgName);
			break;

		default:
			break;
		}
		//若存在父机构且父机构类型不为省、市，则继续判断（1.省，2.市，3.区县，4.分局，5.渠道，6.部门）
		if(orgObj.extMap){
			var pOrg = orgObj.extMap.parent;
			if(pOrg&&pOrg.orgType>2){
				fillFormOrgs(pOrg);
			}
		}
	}
	
	function getUserByRole(roleId,callback){
		var param = new Object();
		param.url = host_+"/api/sys/queryUserByRoleId.do";
		param.token=token_;
		param.roleId=roleId;
		param.rowValid="1";
		param.sysId=sysId_;
		ajax(param, function(data){
			if(data.resCode=="success"){
				callback(data.datas);
			}
			else{
				alert(data.resMsg);
			}
		});
	}
	
	function getPhraseToPage(){
		var param = new Object();
		param.url = "${ctx}/jsp/work/queryPhrase.do";
		param.token=token_;
		param.sysId=sysId_;
		param.userName = userName_;
		param.corporate_identify = enterprise_flag_;
		param.type = "1";//类型为工单
		param.row_valid = "1";//只查询有效的
		ajax(param, function(data){
			if(data.resCode=="success"){
				var datas = data.Rows;
				$.each(datas,function(i,o){
					phrases.push(o.content);
				});
			 	return phrases;
			}
			else{
				alert(data.resMsg);
			}
		});
	}
	function initFormTypeSmall(formType, defaultValue, disabled){
		if(!formType){
			return;
		}
	 
		$.ajax({
			url: '${ctx}/jsp/sys/queryDict.do',
			data: {
				parentId: formType
			},
			type: 'post',
			dataType: 'json',
			async: false,
			success: function(data){
				var rows = data['Rows'];
				 
				   
/* 				var html = '<select name="service_type_detail" id="service_type_detail" title="'+formType+'" class="validate[required] form-control">'; */
				var html = "";
				for(var key in rows){ 
					option = rows[key]; 
					if(defaultValue==option['dictValue']){
						html +='<option selected="selected" value="'+option['dictValue']+'">'+option['dictName']+'</option>';
						continue;
					}
					html +='<option value="'+option['dictValue']+'">'+option['dictName']+'</option>';
				}
				html += '</select>';
				
				$('#service_type_detail').html(html);
				 
				if(disabled){
					$('#form_type_small_').attr('disabled', 'disabled');
				}
			}
		});
	}
	
	function getUserByRoleAndOrgPath(iparam,callback){
		var param = new Object();
		param.url = host_+"/api/sys/getUserByRoleAndOrgPath.do";
		param.token=token_;
		param.roleId=iparam['roleId'];
		param.roleName=iparam['roleName'];
		param.orgPath=iparam['orgPath'];
		param.sysId=sysId_;
		ajax(param, function(data){
			if(data.resCode=="success"){
				callback(data.datas);
			}
			else{
				alert(data.resMsg);
			}
		});
	}
	
	
	
	
</script>