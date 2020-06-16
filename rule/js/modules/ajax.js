define(function(){
	function ajax(options) {
		if (!options.url) // 没有请求资源，则结束
			return;
		// 创建对象
		var xhr;
		if (window.XMLHttpRequest)
			xhr = new XMLHttpRequest();
		else
			xhr = new ActiveXObject("Microsoft.XMLHTTP");

		var method = options.type || "get", // 请求方式
			url = options.url, // 请求资源
			async = typeof options.async !== "undefined" ? options.async : true, // 是否异步
			param = null; // 查询字符串

		// 有查询字符串，则组装查询字符串
		if (options.data) {
			param = "";
			for (var attr in options.data) {
				param += attr + "=" + options.data[attr] + "&";
			}
			param = param.substring(0, param.length - 1);
		}
		if (method === "get"){ // get请求，将查询字符串连接到 url 后
			if(options.data){
				url += "?" + param;
				param = null;
			}
		}

		// 建立连接
		xhr.open(method, url, async);
		// 如果是 post 提交请求，则设置头信息
		if (method === "post")
			xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
		// 有其它头信息的设置
		if (options.headers) {
			for (var attr in options.headers) {
				xhr.setRequestHeader(attr, options.headers[attr]);
			}
		}
		// 发送请求
		xhr.send(param);
		// 异步回调
		xhr.onreadystatechange = function(){
			if (xhr.readyState === 4) { // 响应就绪
				options.completeCb && options.completeCb(xhr);
				if (xhr.status === 200) { // ok
					var data = xhr.responseText;
					if (options.dataType === "json")
						data = JSON.parse(data);
					// 请求资源成功执行函数
					options.successCb && options.successCb(data);
				} else {
					options.errorCb && options.errorCb(xhr);
				}
			}
		};
	}
	return req = {requst:ajax}
})