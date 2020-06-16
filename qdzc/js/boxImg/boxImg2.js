/**
 * Created by TF on 2018/1/15.
 */
 
 
 
 
 /**
  * indexss {int} 显示第几张图片
  * arrPic {Array} 装图片的容器
  * 
  */
 function addImgShow(indexss,arrPic){

	 var len = arrPic.length;

	/* var arrPic = new Array(); //定义一个数组
	 for (var i = 0; i < len; i++) {
		 //获取原图
		// arrPic[i] = $(element).eq(i).attr("data-id"); //将所有img路径存储到数组中
		 //获取src图片地址
		 arrPic[i] = $(element).eq(i).prop("src"); //将所有img路径存储到数组中
	 }*/

        $("body").append("<div id=\"mask-layer\" class=\"mask-layer\" data-img='big'>" +
            "   <div class=\"mask-layer-black\"></div>" +
            "   <div class=\"mask-layer-container\">" +
            "       <div class=\"mask-layer-container-operate\">" +
            "           <button class=\"mask-prev btn-default-styles\" style=\"float: left\">上一张</button>" +
            "           <button class=\"mask-out btn-default-styles\">放大</button>" +
            "           <button class=\"mask-in btn-default-styles\">缩小</button>" +
            "           <button class=\"mask-clockwise btn-default-styles\">顺旋转</button>" +
            "           <button class=\"mask-counterclockwise btn-default-styles\">逆旋转</button>" +
            "           <button class=\"mask-maximg btn-default-styles\">查看原图</button>" +
            "           <button class=\"mask-minimg btn-default-styles\">查看小图</button>" +
            /*"           <button class=\"mask-close btn-default-styles\">关闭</button>" +*/
            "           <button class=\"mask-next btn-default-styles\" style=\"float: right\">下一张</button>" +
            "       </div>" +
            "       <div class=\"mask-layer-imgbox auto-img-center\"></div>" +
            "   </div>" +
            "</div>"
        );

        var $this = $(this);
        var img_index = $this.index(); //获取点击的索引值
        var num = img_index;
        num = indexss;        
        showImg(arrPic[num]);

        //下一张
        $(".mask-next").on("click", function () {
        	$("#mask-layer").attr("data-img","big");
            $(".mask-layer-imgbox p").remove();
            num++;
            if (num == len) {
                num = 0;
            }
            showImg(arrPic[num]);
        });
        //上一张
        $(".mask-prev").on("click", function () {
        	$("#mask-layer").attr("data-img","big");
            $(".mask-layer-imgbox p").remove();
            num--;
            if (num == -1) {
                num = len - 1;
            }
            showImg(arrPic[num]);
        });

        /**
         * 查看原图
         * @returns
         */
        $(".mask-maximg").on("click", function () {
            var maximg = $(".mask-layer-imgbox p img");
            var min = maximg.prop("src");
            var max = min.replace("-small","");
			$(".mask-layer-imgbox p").remove();
	 		showImg(max);
            
        });
        /**
         * 查看小图
         * @returns
         */
        $(".mask-minimg").on("click", function () {
            var maximg = $(".mask-layer-imgbox p img");
            var src = maximg.prop("src");
            var max = src.replace("-small","");//原图
            
            var dataImg = $("#mask-layer").attr("data-img");
            var smallImgUrl=null;
            if(dataImg=="small"){
            	var len = max.lastIndexOf(".");
     			var strStart = max.substr(0,len);
     			var strEnd =max.substring(len);
     			smallImgUrl = strStart+"-small"+strEnd;
            }
            else{
            	smallImgUrl=max;
            }
 			$(".mask-layer-imgbox p").remove();
 			showImg(smallImgUrl);
        });
        

}

 function showImg(imgAddress) {
	 //判断小图
	 var _smallIndex = imgAddress.indexOf("-small");
	 if(_smallIndex>-1){
		 $("#mask-layer").attr("data-img","small");
	 }

     $(".mask-layer-imgbox").append("<p data-id='100' id='onmousewheel_'><img id='showImgInfo_' src=\"\" alt=\"\"></p>");
     $(".mask-layer-imgbox img").attr("src", imgAddress); //给弹出框的Img赋值
     $("#showImgInfo_").hide();
     //图片自动适应
     var initial_width = $("#showImgInfo_").width();//初始图片宽度
     var initial_height = $("#showImgInfo_").height();//初始图片高度
     var getImgContainerInfoTime =null;
     if(initial_width==0 ||initial_height==0 ){
    	  $("#showImgInfo_").hide();
    	 getImgContainerInfoTime = setInterval(function getImgContainerInfo(){
    		 var widths = $("#showImgInfo_").width();
    		 if(widths!=0){
    			 initial_width = widths;
    			 initial_height = $("#showImgInfo_").height();
    			 imgContainer("#showImgInfo_",".auto-img-center");
    			 $("#showImgInfo_").show();
    			 clearInterval(getImgContainerInfoTime); 
    		 }
    	 },100);
    	 
     }else{
    	 imgContainer("#showImgInfo_",".auto-img-center");
    	 $("#showImgInfo_").show();
     }
     
     
     //图片拖拽
     var $div_img = $(".mask-layer-imgbox p");
     //绑定鼠标左键按住事件
     $div_img.bind("mousedown", function (event) {
         event.preventDefault && event.preventDefault(); //去掉图片拖动响应
         //获取需要拖动节点的坐标
         var offset_x = $(this)[0].offsetLeft;//x坐标
         var offset_y = $(this)[0].offsetTop;//y坐标
         //获取当前鼠标的坐标
         var mouse_x = event.pageX;
         var mouse_y = event.pageY;
         //绑定拖动事件
         //由于拖动时，可能鼠标会移出元素，所以应该使用全局（document）元素
         $(".mask-layer-imgbox").bind("mousemove", function (ev) {
             // 计算鼠标移动了的位置
             var _x = ev.pageX - mouse_x;
             var _y = ev.pageY - mouse_y;
             //设置移动后的元素坐标
             var now_x = (offset_x + _x ) + "px";
             var now_y = (offset_y + _y ) + "px";
             //改变目标元素的位置
             $div_img.css({
                 top: now_y,
                 left: now_x
             });
         });
     });
     //当鼠标左键松开，接触事件绑定
     $(".mask-layer-imgbox").bind("mouseup", function () {
         $(this).unbind("mousemove");
     });

     
     
     
     
     
     //鼠标滚轮时间
     $("#onmousewheel_").bind('mousewheel DOMMouseScroll',function(event){
     	
     	var isfireFox = (navigator.userAgent).indexOf("Firefox");
     	
     	if(isfireFox>-1){
     		delta = event.originalEvent.detail;
     		if(delta==3) delta= -3;
     		else delta= 3;
     	}else{
     		delta = event.originalEvent.wheelDelta;
     	}
     	
     	var zoom = $(this).attr('data-id');
     	zoom = Number(zoom);
     	 var imgWidth = $(this).attr("data-width");
     	 var imgHeight = $(this).attr("data-height");
     	 var img = $(this).find("img");
     	 if(!imgWidth){
     		 imgWidth = img.width();
     		 imgHeight = img.height();
     		 $(this).attr("data-width",imgWidth);
     		 $(this).attr("data-height",imgHeight);
     	 }
     	if (delta > 0) zoom+=12.5;
     	else zoom-=12.5;
     	//控制缩放比列
     	 if (zoom>15 &&zoom<=500){
     			$(this).attr("data-id",zoom);
     			 img.css("width",imgWidth*(zoom/100)+'px');
     			 img.css("height",imgHeight*(zoom/100)+'px');
     		 }
     	
     	
     })
     
     
     
     
     //缩放
     var zoom_n = 1;
     $(".mask-out").click(function () {
         zoom_n += 0.1;
         $(".mask-layer-imgbox img").css({
             "transform": "scale(" + zoom_n + ")",
             "-moz-transform": "scale(" + zoom_n + ")",
             "-ms-transform": "scale(" + zoom_n + ")",
             "-o-transform": "scale(" + zoom_n + ")",
             "-webkit-": "scale(" + zoom_n + ")"
         });
     });
     $(".mask-in").click(function () {
         zoom_n -= 0.1;
         console.log(zoom_n)
         if (zoom_n <= 0.1) {
             zoom_n = 0.1;
             $(".mask-layer-imgbox img").css({
                 "transform":"scale(.1)",
                 "-moz-transform":"scale(.1)",
                 "-ms-transform":"scale(.1)",
                 "-o-transform":"scale(.1)",
                 "-webkit-transform":"scale(.1)"
             });
         } else {
             $(".mask-layer-imgbox img").css({
                 "transform": "scale(" + zoom_n + ")",
                 "-moz-transform": "scale(" + zoom_n + ")",
                 "-ms-transform": "scale(" + zoom_n + ")",
                 "-o-transform": "scale(" + zoom_n + ")",
                 "-webkit-transform": "scale(" + zoom_n + ")"
             });
         }
     });
     //旋转
     var spin_n = 0;
     $(".mask-clockwise").click(function () {
         spin_n += 90;
         $(".mask-layer-imgbox img").parent("p").css({
             "transform":"rotate("+ spin_n +"deg)",
             "-moz-transform":"rotate("+ spin_n +"deg)",
             "-ms-transform":"rotate("+ spin_n +"deg)",
             "-o-transform":"rotate("+ spin_n +"deg)",
             "-webkit-transform":"rotate("+ spin_n +"deg)"
         });
     });
     $(".mask-counterclockwise").click(function () {
         spin_n -= 90;
         $(".mask-layer-imgbox img").parent("p").css({
             "transform":"rotate("+ spin_n +"deg)",
             "-moz-transform":"rotate("+ spin_n +"deg)",
             "-ms-transform":"rotate("+ spin_n +"deg)",
             "-o-transform":"rotate("+ spin_n +"deg)",
             "-webkit-transform":"rotate("+ spin_n +"deg)"
         });
     });
     //关闭
     $(".mask-close").click(function () {
         $(".mask-layer").remove();
     });
     $(".mask-layer-black").click(function () {
         $(".mask-layer").remove();
     });
 }
 
 /**
  * 图片自适应
  * @param imgContainer 图片容器
  * @param parentContainer 图片父级容器
  * @returns
  */
 function imgContainer(imgContainer,parentContainer){
	 var box_width = $(parentContainer).width(); //图片盒子宽度
     var box_height = $(parentContainer).height();//图片高度高度
     var initial_width = $(imgContainer).width();//初始图片宽度
     var initial_height = $(imgContainer).height();//初始图片高度

     //图片高度小于容器高度，并且图片高度小于容器高度
     if(initial_width<box_width && initial_height<box_height){
    	 
    	 var last_imgHeight = $(imgContainer).height();
    	 $(imgContainer).css("margin-top",(box_height-last_imgHeight)/2);
     }
     //如果图片高度大于容器高度,并且图片宽度小于容器宽度
     else if(initial_height>box_height && initial_width<box_width){
    	 $(imgContainer).css("height","100%");
     }
     //图片宽度大于容器宽度，图片高度小于容器高度
     else if(initial_width>box_width && initial_height<box_height){
    	 $(imgContainer).css("width","100%");
    	 var last_imgHeight = $(imgContainer).height();
    	 $(imgContainer).css("margin-top",(box_height-last_imgHeight)/2);
     }//图片宽度大容器，图片高度大于容器
     else if(initial_width>box_width && initial_height>box_height){
    	 var wd = initial_width/box_width;//宽度比列
    	 var hg = initial_height/box_height;//高度比列
    	 
    	 if(wd>hg){
    		 $(imgContainer).css("width","100%");
    		 var last_imgHeight = $(imgContainer).height();
        	 $(imgContainer).css("margin-top",(box_height-last_imgHeight)/2);
    	 }else{
    		 $(imgContainer).css("height","100%");
    	 }
    	 
     }
     
 }

 

 




