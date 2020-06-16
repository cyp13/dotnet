(function($){
var myflow = $.myflow;

$.extend(true, myflow.editors, {
	inputEditor : function(type){
		var _props,_k,_div,_src,_r;
		this.init = function(props, k, div, src, r){
			_props=props; _k=k; _div=div; _src=src; _r=r;
			
			var o =$('<input style="width:100%;"/>');
			if("pdId" == type) {
				$(o).attr("title", "必填(请勿含有特殊字符)");
				$(o).attr("placeholder", "必填(请勿含有特殊字符)");
			} else if("name" == type) {
				$(o).attr("title", "必填(唯一)");
				$(o).attr("placeholder", "必填(唯一)");
			} else if("form" == type || "api" == type) {
				$(o).attr("title", "URL");
				$(o).attr("placeholder", "URL");
			} else if("assignee" == type) {
				$(o).attr("title", "登录账号");
				$(o).attr("placeholder", "登录账号");
			} else if("expr" == type) {
				$(o).attr("title", "#{true?\'Y\':\'N\'}");
				$(o).attr("placeholder", "#{true?\'Y\':\'N\'}");
			} else if("due" == type || "rep" == type) {
				$(o).attr("title", "分钟(整数)");
				$(o).attr("placeholder", "分钟(整数)");
			}
			
			$(o).val(props[_k].value).change(function(){
				props[_k].value = $(this).val();
			}).appendTo('#'+_div);
			
			$('#'+_div).data('editor', this);
		}
		this.destroy = function(){
			$('#'+_div+' input').each(function(){
				_props[_k].value = $(this).val();
			});
		}
	},
	selectEditor : function(arg){
		var _props,_k,_div,_src,_r;
		this.init = function(props, k, div, src, r){
			_props=props; _k=k; _div=div; _src=src; _r=r;
			var sle = $('<select style="width:100%"/>').val(props[_k].value).change(function(){
				props[_k].value = $(this).val();
			}).appendTo('#'+_div);
			
			if(typeof arg === 'string'){
				$.ajax({
				   type: "GET",
				   url: arg,
				   success: function(data){
					 sle.append('<option value="">请选择</option>');
					 var opts = eval(data);
					 if(opts && opts.length){
						for(var idx=0; idx<opts.length; idx++){
							sle.append('<option value="'+opts[idx].id+'">'+opts[idx].name+'</option>');
						}
					 }
					 sle.append('<option value="#{roleNames_}">#{roleNames_}</option>');
					 sle.val(_props[_k].value);
				   }
				});
			} else {
				for(var idx=0; idx<arg.length; idx++){
					sle.append('<option value="'+arg[idx].value+'">'+arg[idx].name+'</option>');
				}
				sle.val(_props[_k].value);
			}
			
			$('#'+_div).data('editor', this);
		};
		this.destroy = function(){
			$('#'+_div+' input').each(function(){
				_props[_k].value = $(this).val();
			});
		};
	}
});
})(jQuery);