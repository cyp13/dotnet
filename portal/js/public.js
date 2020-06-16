//var pathName = window.document.location.pathname;
//var ctx = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);

document.oncontextmenu = function() {
	return false;
}

String.prototype.startWith = function(s) {
	if (s == null || s == "" || this.length == 0 || s.length > this.length)
		return false;
	if (this.substr(0, s.length) == s)
		return true;
	else
		return false;
	return true;
}

String.prototype.endWith = function(s) {
	if (s == null || s == "" || this.length == 0 || s.length > this.length)
		return false;
	if (this.substring(this.length - s.length) == s)
		return true;
	else
		return false;
	return true;
}

var arrRemove = function(arr, val) {
	arr.splice($.inArray(val, arr), 1);
}

var getParameter = function(name, url) {
	if (!url) {
		url = document.location.toString();
	}
	var LocString = String(url);
	return (RegExp(name + '=' + '(.+?)(&|$)').exec(LocString) || [ , '' ])[1];
}

var getParameterStr = function(url) {
	if (!url) {
		url = location.search;
	}
	if (url.indexOf("?") != -1) {
		return url.substr(1);
	}
}

var getParameterObj = function(url) {
	if (!url) {
		url = location.search;
	}
	var obj = new Object();
	if (url.indexOf("?") != -1) {
		var str = url.substr(1);
		strs = str.split("&");
		for (var i = 0; i < strs.length; i++) {
			obj[strs[i].split("=")[0]] = decodeURI(strs[i].split("=")[1]);
		}
	}
	return obj;
}

var setHeight = function(id, height) {
	var iframe = document.getElementById(id);
	if (iframe) {
		var iframeWin = iframe.contentWindow
				|| iframe.contentDocument.parentWindow;
		if (iframeWin.document.body) {
			iframe.height = iframeWin.document.documentElement.scrollHeight
					|| iframeWin.document.body.scrollHeight;
		} else {
			iframe.height = height;
		}
	}
}

// 格式化CST日期的字串
function formatCSTDate(date, format) {
	if (date) {
		return formatDate(new Date(date), format);
	}
}

// 格式化日期
function formatDate(date, format) {
	var paddNum = function(num) {
		num += "";
		return num.replace(/^(\d)$/, "0$1");
	}
	var cfg = {
		yyyy : date.getFullYear(),
		MM : paddNum(date.getMonth() + 1), // 月 : 如果1位的时候补0
		dd : paddNum(date.getDate()),
		hh : paddNum(date.getHours()),
		mm : paddNum(date.getMinutes()),
		ss : paddNum(date.getSeconds())
	}
	format || (format = "yyyy-MM-dd hh:mm:ss");
	return format.replace(/([a-z])(\1)*/ig, function(m) {
		return cfg[m];
	});
}

var ajax = function(param, callback) {
	if (!param || !param.url) {
		layer.msg("缺少参数：url！", {
			icon : 3
		});
		return;
	}
	if($.isEmptyObject(param.async) && param.async) {
		param.async = true;
	}
	var i_ = layer.load(1);
	jQuery.ajax({
		url : param.url,
		data : param,
		async : param.async,
		type : "POST",
		dataType : "json",
		success : function(result) {
			// layer.closeAll("loading");
			layer.close(i_);
			if (typeof callback === "function") {
				callback(result);
			} else {
				layer.msg("数据处理成功！", {
					icon : 1
				});
			}
		},
		error : function(result) {
			// layer.closeAll("loading");
			layer.close(i_);
			layer.msg("网络连接错误！", {
				icon : 2
			});
		}
	});
}

var ajaxSubmit = function(form, param, callback) {
	if (!form) {
		layer.msg("缺少参数：表单对象！", {
			icon : 3
		});
		return;
	}
	var obj = new Object();
	if (param && !(typeof param === "function")) {
		obj = param;
		if($.isEmptyObject(obj.async) && obj.async) {
			obj.async = true;
		}
	}
	var i_ = layer.load(1);
	$(form).ajaxSubmit({
		data : obj,
		async : obj.async,
		type : "POST",
		dataType : "json",
		success : function(result) {
			// layer.closeAll("loading");
			layer.close(i_);
			if (typeof param === "function") {
				param(result);
			} else if (typeof callback === "function") {
				callback(result);
			} else {
				layer.msg("数据处理成功！", {
					icon : 1
				});
			}
		},
		error : function(result) {
			// layer.closeAll("loading");
			layer.close(i_);
			layer.msg("网络连接错误！", {
				icon : 2
			});
		}
	});
}

var isNull = function(obj) {
	if (typeof (obj) == "undefined" || obj == "undefined" || !obj) {
		return true;
	}
	return false;
}

// 控制网页打印的页眉页脚为空
var setPageNull = function() {
	var HKEY_Root, HKEY_Path, HKEY_Key;
	HKEY_Root = "HKEY_CURRENT_USER";
	HKEY_Path = "\\Software\\Microsoft\\Internet Explorer\\PageSetup\\";
	try {
		var Wsh = new ActiveXObject("WScript.Shell");
		HKEY_Key = "header";
		Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, "");
		HKEY_Key = "footer";
		Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, "");
	} catch (e) {
	}
}

var printIt = function(startstr, endstr) {
	if (startstr && endstr) {
		setPageNull();
		var obj;
		var datas = [];
		var forms = $("body").find("form");
		$.each(forms, function(index, form) {
			obj = new Object();
			obj.id = $(form).attr("id");
			obj.value = $(form).serializeObj();
			datas.push(obj);
		});
		var bodyhtml = window.document.body.innerHTML;
		var printhtml = bodyhtml.substring(bodyhtml.indexOf(startstr)
				+ startstr.length);
		printhtml = printhtml.substring(0, printhtml.indexOf(endstr));
		window.document.body.innerHTML = printhtml;
		$.each(datas, function(index, form) {
			$("#" + form.id).fill(form.value);
		});
		window.self.focus();
		window.self.print();
		// window.self.close();
		window.document.body.innerHTML = bodyhtml;
		location.reload();
		return false
	}
}

var doPrint = function(id) {
	setPageNull();
	var datas = [];
	var forms = $("body").find("form");
	$.each(forms, function(index, form) {
		var obj = new Object();
		obj.id = $(form).attr("id");
		obj.value = $(form).serializeObj();
		datas.push(obj);
	});
	var bodyhtml = window.document.body.innerHTML;
	var printhtml = $("#" + id).html();
	window.document.body.innerHTML = printhtml;
	window.self.focus();
	window.self.print();
	// window.self.close();
	window.document.body.innerHTML = bodyhtml;
	$.each(datas, function(index, form) {
		$("#" + form.id).fill(form.value);
	});
	return false
}

$.fn.serializeObj = function() {
	var obj = {};
	var data = this.serializeArray();
	$.each(data, function() {
		if (obj[this.name]) {
			if (!obj[this.name].push) {
				obj[this.name] = [ obj[this.name] ];
			}
			obj[this.name].push(this.value || "");
		} else {
			obj[this.name] = this.value || "";
		}
	});
	return obj;
}

var setPageNull = function() {
	var HKEY_Root, HKEY_Path, HKEY_Key;
	HKEY_Root = "HKEY_CURRENT_USER";
	HKEY_Path = "\\Software\\Microsoft\\Internet Explorer\\PageSetup\\";
	try {
		var Wsh = new ActiveXObject("WScript.Shell");
		HKEY_Key = "header";
		Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, "");
		HKEY_Key = "footer";
		Wsh.RegWrite(HKEY_Root + HKEY_Path + HKEY_Key, "");
	} catch (e) {
	}
}

var dt = {
	"language": { 
		"url": ctx+"/js/plugins/dataTables/Chinese.json"
	},
	"dom": 'rt<"bottom"iflp<"clear">>',
	"pagingType": "full_numbers",
	"searching": false,
	"ordering": false,
	"autoWidth": false,
	"processing": true,
	"serverSide": true
};