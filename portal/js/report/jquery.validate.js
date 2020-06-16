/**
 * form validate (jQuery plugin) 
 * Author: yove 
 * Version: 0.1 
 * Released: 2017-06-27
 */
(function($) {
	$.fn.validate = function(tag, callback) {
		var tag_default = "title";
		if (tag && typeof tag != 'function') {
			tag_default = tag;
		}
		var result = true;
		var tmps = this.find("input[" + tag_default + "]");
		$.merge(tmps, this.find("select[" + tag_default + "]"));
		$.merge(tmps, this.find("textarea[" + tag_default + "]"));
		$.merge(tmps, this.find("[typ]"));
		$.each(tmps, function(index, o) {
			var value = $(this).val();
			var typ = $(this).attr("typ");
			var msg = $(this).attr(tag_default);
			if ("email" == typ && valid.email(value)) {
				return true;
			} else if ("url" == typ && valid.url(value)) {
				return true;
			} else if ("date" == typ && valid.date(value)) {
				return true;
			} else if ("pid" == typ && valid.pid(value)) {
				return true;
			} else if ("code" == typ && valid.code(value)) {
				return true;
			} else if ("number" == typ && valid.number(value)) {
				return true;
			} else if (!typ && value && "" != $.trim(value)) {
				return true;
			} else {
				if(!value && !msg) {
					return true;
				}
				if (typ && !msg) {
					msg = "该项输入不正确！";
				} else if (!msg) {
					msg = "该项为必输项！";
				}
				if (typeof tag === "function") {
					tag(msg);
				} else if (typeof callback === "function") {
					callback(msg);
				} else {
					layer.msg(msg, {icon: 0});
					$(this).focus();
				}
				result = false;
				return false;
			}
		});
		return result;
	};

	var valid = {
		email : function(value) {
			return /\w+([-+.´]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*/.test(value);
		},
		url : function(value) {
			return /^(https?|s?ftp):\/\/([\w-]+(\.[\w-]+)+(\/[\w- .\/\?%&=\u4e00-\u9fa5]*)?)?$/
					.test(value);
		},
		date : function(value) {
			return !/Invalid|NaN/.test(new Date(value).toString());
		},
		// 身份证id
		pid : function(value) {
			return /^[1-9]([0-9]{16}|[0-9]{13})[xX0-9]$/.test(value);
		},
		// 匹配英文字符或数字或下划线
		code : function(value) {
			return /^\w+$/.test(value);
		},
		number : function(value) {
			return /^[-+]?\d+(\.\d+)?$/.test(value);
		}
	};
})(jQuery);