/*var datas =[
    {"id":"2","text":"中国石油天然气股份有限公司"}, 
	{"id":"4","text":"中国建筑股份有限公司"},
	{"id":"3","text":"中国移动有限公司"}];
$.selectSuggest('assigneeAlias',datas,function(){
//	alert(this.id + "," + this.innerHTML);
	$("#assignee").val(this.id);
});*/
(function($) {
    $.selectSuggest = function(target, data, itemSelectFunction,checkbox) {
		var defaulOption = {
			suggestMaxHeight: '200px',//弹出框最大高度
			itemColor : '#000',//默认字体颜色
			itemBackgroundColor:'#f3f3f3',//默认背景颜色
			itemOverColor : '#fff',//选中字体颜色
			itemOverBackgroundColor : '#3399FF',//选中背景颜色 #e9e9e9
			itemPadding : 4 ,//item间距
			fontSize : 12 ,//默认字体大小
			alwaysShowALL : true //点击input是否展示所有可选项
		};
        var maxFontNumber = 0;//最大字数
        var currentItem;
        var suggestContainerId = target + "-suggest";
        var suggestContainerWidth = $('#' + target).innerWidth();
        var suggestContainerLeft = $('#' + target).offset().left;
        var top = $('#' + target).offset().top;
        var suggestContainerTop = (top < 0 ? top * -1 : top) + $('#' + target).outerHeight();
        var texts = [];
        var ids = [];
        
        var showClickTextFunction = function() {
            currentItem = null;
            if('checkbox' !== checkbox) {
            	$('#' + target).val(this.innerText);
            	$('#' + suggestContainerId).hide();
            } else {
            	$('#checkbox_'+escapeJquery(this.id)).prop("checked", !($('#checkbox_'+escapeJquery(this.id)).prop("checked")));
            	
            	var index = $.inArray(this.id,ids);
        		if(index < 0) { 
            		ids.push(this.id);
            		texts.push(this.innerText);
        		} else {
        			ids.splice(index,1);
        			texts.splice(index,1);
        		}
        		$('#' + target).val(texts.join(','));
        		$(this).attr("ids", ids.join(','));
            }
        }
        var suggestContainer;
        if ($('#' + suggestContainerId)[0]) {
            suggestContainer = $('#' + suggestContainerId);
            suggestContainer.empty();
        } else {
            suggestContainer = $('<div></div>'); //创建一个子<div>
        }

        suggestContainer.attr('id', suggestContainerId);
        suggestContainer.attr('tabindex', '0');
        suggestContainer.hide();
        var _initItems = function(items) {
            suggestContainer.empty();
            for (var i = 0; i < items.length; i++) {
        		if(items[i].text.length > maxFontNumber) {
        			maxFontNumber = items[i].text.length;
        		}
        		var suggestItem = $('<div></div>');//创建一个子<div>
            	if('checkbox' == checkbox) {
            		var index = $.inArray(items[i].id,ids);
            		index = index >= 0 ? "checked" : ""; 
            		suggestItem = $('<div><input type="checkbox" disabled="disabled" id="checkbox_'+items[i].id+'" '+index+'/></div>'); //创建一个子<div>
            	}
            	suggestItem.attr('id', items[i].id);
                suggestItem.attr('ids', items[i].id);
                suggestItem.append(items[i].text);
                suggestItem.css({
                	'padding':defaulOption.itemPadding + 'px',
                    'white-space':'nowrap',
                    'cursor': 'pointer',
                    'background-color': defaulOption.itemBackgroundColor,
                    'color': defaulOption.itemColor
                });
                suggestItem.bind("mouseover", function() {
                    $(this).css({
                        'background-color': defaulOption.itemOverBackgroundColor,
                        'color': defaulOption.itemOverColor
                    });
                    currentItem = $(this);
                });
                suggestItem.bind("mouseout", function() {
                    $(this).css({
                        'background-color': defaulOption.itemBackgroundColor,
                        'color': defaulOption.itemColor
                    });
                    currentItem = null;
                });
                suggestItem.bind("click", showClickTextFunction);
                suggestItem.bind("click", itemSelectFunction);
                suggestItem.appendTo(suggestContainer);
                suggestContainer.appendTo(document.body);
            }
        }

        var inputChange = function() {
            var inputValue = $('#' + target).val();
            inputValue = inputValue.replace(/[\-\[\]{}()*+?.,\\\^$|#\s]/g, "\\$&");
            var matcher = new RegExp(inputValue, "i");
            return $.grep(data,
            function(value) {
                return matcher.test(value.text);
            });
        }

        $('#' + target).bind("keyup", function() {
            _initItems(inputChange());
        });

        $('#' + target).bind("blur", function() {
        	$('#' + suggestContainerId).focus();      
    		if(!$('#' + suggestContainerId).is(":hover")) {
    		//	$('#' + suggestContainerId).hide();
    			if (currentItem) {
    		//		currentItem.trigger("click");
    			}
    			currentItem = null;
    			return;
    		}                       
        });

        $('#' + target).bind("click", function() {
            if (defaulOption.alwaysShowALL) {
                _initItems(data);
            } else {
                _initItems(inputChange());
            }
            $('#' + suggestContainerId).removeAttr("style");
            var tempWidth = defaulOption.fontSize*maxFontNumber + 2 * defaulOption.itemPadding + 30;
            var containerWidth = Math.max(tempWidth, suggestContainerWidth);
            containerWidth = $('#' + target).width() + 2;
            containerWidth = containerWidth < 184 ? 184 : containerWidth;
            $('#' + suggestContainerId).css({
                'border': '1px solid #ccc',
                'min-height': '219px',
                'max-height': '219px',
                'top': suggestContainerTop,
                'left': suggestContainerLeft,
                'width': containerWidth,
                'position': 'absolute',
                'font-size': defaulOption.fontSize+'px',
                'font-family':'Arial',
                'z-index': 99999,
                'background-color': '#f3f3f3',
                'overflow-y': 'auto',
                'overflow-x': 'hidden',
                'white-space':'nowrap',
                'outline':'none'
            });
            $('#' + suggestContainerId).show();
            
        });
        _initItems(data);
        
        $('#' + suggestContainerId).hover(function() {
        	$('#' + suggestContainerId).focus();      
        });

        $('#' + suggestContainerId).bind("blur", function() {
            $('#' + suggestContainerId).hide();
        });
        
        $('#' + target).keyup(function() {
			var v = $.trim($(this).val());
			$("#" + target.split("_desc")[0]).val(v);
		});
    }
})(jQuery);

function escapeJquery(srcString) {  
    // 转义之后的结果  
    var escapseResult = srcString;  
    // javascript正则表达式中的特殊字符  
    var jsSpecialChars = ["\\", "^", "$", "*", "?", ".", "+", "(", ")", "[",  
            "]", "|", "{", "}"];  
    // jquery中的特殊字符,不是正则表达式中的特殊字符  
    var jquerySpecialChars = ["~", "`", "@", "#", "%", "&", "=", "'", "\"",  
            ":", ";", "<", ">", ",", "/"];  
    for (var i = 0; i < jsSpecialChars.length; i++) {  
        escapseResult = escapseResult.replace(new RegExp("\\"  
                                + jsSpecialChars[i], "g"), "\\"  
                        + jsSpecialChars[i]);  
    }  
    for (var i = 0; i < jquerySpecialChars.length; i++) {  
        escapseResult = escapseResult.replace(new RegExp(jquerySpecialChars[i],  
                        "g"), "\\" + jquerySpecialChars[i]);  
    }  
    return escapseResult;  
}
