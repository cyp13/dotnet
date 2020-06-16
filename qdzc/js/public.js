//var sysId="15b1eb02-740a-476d-beb5-4ff0a70926b0";//本地系统ID
var pathName = window.document.location.pathname;

//var ctx = pathName.substring(0, pathName.substr(1).indexOf('/') + 1);

String.prototype.startWith = function(s) {
	if (s == null || s == "" || this.length == 0 || s.length > this.length)
		return false;
	if (this.substr(0, s.length) == s)
		return true;
	else
		return false;
	return true;
};

String.prototype.endWith = function(s) {
	if (s == null || s == "" || this.length == 0 || s.length > this.length)
		return false;
	if (this.substring(this.length - s.length) == s)
		return true;
	else
		return false;
	return true;
};

var getParameter = function(name, url) {
	if (!url) {
		url = document.location.toString();
	}
	var LocString = String(url);
	return (RegExp(name + '=' + '(.+?)(&|$)').exec(LocString) || [ , '' ])[1];
};

var getParameterStr = function(url) {
	if (!url) {
		url = location.search;
	}
	if (url.indexOf("?") != -1) {
		return url.substr(1);
	}
};

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
};

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
};

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
	};
	var cfg = {
		yyyy : date.getFullYear(),
		MM : paddNum(date.getMonth() + 1), // 月 : 如果1位的时候补0
		dd : paddNum(date.getDate()),
		hh : paddNum(date.getHours()),
		mm : paddNum(date.getMinutes()),
		ss : paddNum(date.getSeconds())
	};
	format || (format = "yyyy-MM-dd hh:mm:ss");
	return format.replace(/([a-z])(\1)*/ig, function(m) {
		return cfg[m];
	});
}

//偏移并格式化日期
function dateOffset( offset, format ){
	var date = new Date();
	if( "0" != offset && 0 != offset ){
		date.setDate( date.getDate() + offset );
	}
	return formatCSTDate( date, format);
}

//字符串转日期
 function stringToDate(dateStr,separator){
    if(!separator){
           separator="-";
    }
    var dateArr = dateStr.split(separator);
    var year = parseInt(dateArr[0]);
    var month;
    //处理月份为04这样的情况                         
    if(dateArr[1].indexOf("0") == 0){
        month = parseInt(dateArr[1].substring(1));
    }else{
         month = parseInt(dateArr[1]);
    }
    var day = parseInt(dateArr[2]);
    var date = new Date(year,month -1,day);
    return date;
 }

var ajax = function(param, callback) {
	if (!param || !param.url) {
		layer.msg("缺少参数：url！", {icon : 3});
		return;
	}
	if('undefined' == typeof param.async){
		param.async = true;
	}
	if('undefined' == typeof param.dataType){
		param.dataType = "json";
	}
	param.i_ = layer.load(1);
	param.userName=userName_;
	jQuery.ajax({
		url : param.url,
		data : param,
		async: param.async,
		type : "POST",
		dataType : param.dataType,
		success : function(data) {
		//	layer.closeAll("loading");
			layer.close(param.i_);
			if (typeof callback === "function") {
				callback(data);
			} else {
				layer.msg("数据处理成功！", {icon: 1});
			}
		},
		error : function(data) {
		//	layer.closeAll("loading");
			layer.close(param.i_);
			layer.msg("网络连接错误！", {icon: 2});
		}
	});
};

var ajaxSubmit = function(form, param, callback) {
	if (!form) {
		layer.msg("缺少参数：表单对象！", {icon : 3});
		return;
	}
	var obj = new Object();
	if (param && !(typeof param === "function")) {
		obj = param;
	}
	var dataType_ = "json";
	if('undefined' != typeof param.dataType){
		dataType_ = param.dataType;
	}
	obj.i_ = layer.load(1);
	obj.userName=userName_;
	$(form).ajaxSubmit({
		data : obj,
		type : "POST",
		dataType : dataType_,
		success : function(data) {
		//	layer.closeAll("loading");
			layer.close(obj.i_);
			if (typeof param === "function") {
				param(data);
			} else if (typeof callback === "function") {
				callback(data);
			} else {
				layer.msg("数据处理成功！", {icon: 1});
			}
		},
		error : function(data) {
		//	layer.closeAll("loading");
			layer.close(obj.i_);
			layer.msg("网络连接错误！", {icon: 2});
		}
	});
};

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
};

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
	//	window.self.close();
		window.document.body.innerHTML = bodyhtml;
		location.reload();
		return false;
	}
};

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
	var printhtml = $("#"+id).html();
	window.document.body.innerHTML = printhtml;
	window.self.focus();
	window.self.print();
//	window.self.close();
	window.document.body.innerHTML = bodyhtml;
	$.each(datas, function(index, form) {
		$("#" + form.id).fill(form.value);
	});
	return false;
};

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
};

/**
 * 删除附件
 * @param docId
 * @param fileId
 */

function delFile(fileId,ctx,token_){
	layer.confirm('您确定要删除附件吗？', {
		icon: 3
	}, function(){
		$.ajax({
			url : ctx+'/api/sys/deleteFile.do',
			data : {
				"id":fileId,
				"sysId":sysId_,
				"token":token_
			},
			type : "post",
			dataType : "jsonp",
			success : function(data) {
				debugger;
				if ('error' == data.resCode) {
					alert(data.resMsg);
				} else {
					success('附件删除成功！');
					location.reload();
				}
			},
			error : function(data) {
				alert(data);
			}
		});
	});
}

/**
 * 级联生成字典select
 * @param formType
 * @param defaultValue
 * @param disabled
 */
var DICT_MAP = {};
function initDictSelect(options){
	if(!options || options.length<=0){
		return;
	}
	var op = options[0];
	var parentId = op['parentId'];
	var element = op['element'];
	var name = op['name'];
	var value = op['value'];
	var defaultIndex = op['defaultIndex'];
	var disabled = op['disabled'];
	var nextParentId;
	$(element).html('<select></select>');
	$.ajax({
		url: 'jsp/sys/queryDict.do',
		data: {
			parentId: parentId
		},
		type: 'post', dataType: 'json', async: false,
		success: function(data){
			var rows = data['Rows'];
			if(!rows||rows.length<=0){
				return;
			}
			var selectId = parentId + '_' + new Date().getTime();
			var select = $('<select name="'+name+'" id="'+parentId+'" title="'+parentId+'" select-id="'+selectId+'" class="'+$(element).attr('clazz')+'">');
			if(!value){
				if(defaultIndex===undefined || defaultIndex===null){
				}else{
					value = rows[defaultIndex]['dictValue'];
				}
			}
			var selectedOP;
			for(var key in rows){
				option = rows[key];
				select.append($('<option dict-id="'+option['id']+'" value="'+option['dictValue']+'">'+option['dictName']+'</option>'));
				if(option['dictValue']==value){
					nextParentId = option['id'];
					selectedOP = option;
				}
			}
			$(element).html('');
			$(element).append(select);
			$(select).val(value);
			if(disabled){
				$(select).attr('disabled', 'disabled');
			}
			if(options.length>1){
				options.splice(0, 1);
				DICT_MAP[selectId] = options;
				$(select).change(function(){
					changeFun($(this).attr('select-id'), $(this).find('option:selected').attr('dict-id'));
				});
				if(selectedOP){
					changeFun(selectId, selectedOP['id'], true);
				}else{
					changeFun(selectId, null, true);
				}
			}
		}
	});
}
function changeFun(selectId, dictId, isAuto){
	var tempOptions = DICT_MAP[selectId];
	tempOptions[0]['parentId'] = dictId;
	if(!isAuto){//不是自动生成的子级，需要去掉disabled，因为人为选择的上级，要保证下级也可以选
		for(var i in tempOptions){
			tempOptions[i]['disabled'] = false;
		}
	}
	initDictSelect(tempOptions);
}