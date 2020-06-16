<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="s" uri="http://java.scihi.cn/jsp/jstl/core"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="renderer" content="webkit">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>查看图片</title>
<link href="${ctx}/css/boxImg/boxImg.css" rel="stylesheet">
<script src="${ctx}/js/jquery.min.js?v=2.1.4"></script>
<script src="${ctx}/js/boxImg/boxImg2.js"></script>
</head>
<body>

</body>
<script>
var imgArr = "${param.img}";
var indexss = ${param.indexss};
var arrPic = imgArr.split(",,");
var arr = arrPic[arrPic.length-1];
if(!arr || arr==""){
	arrPic.pop();
}
addImgShow(indexss,arrPic);
</script>

</html>