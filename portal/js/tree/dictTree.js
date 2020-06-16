var queryDictTreeUrl = ctx + "/api/sys/queryDict.do";
var dictTreeSetting = {
	async: {
		enable: true,
		dataType: "json",
		url: queryDictTreeUrl,
		autoParam : [ "id" ],
		otherParam : {"flag_" : "tree"},
		dataFilter: function(treeId, parentNode, result) {
			if("error" != result.resCode) {
				return result;
			}
		}
	},
	view : {
		dblClickExpand : false
	},
	data: {
		key: { name: "dictName", title: "dictType"}
	},
	check : {
		enable : true,
		chkStyle : "checkbox", //radio
		radioType : "all",
		chkboxType : {
			"Y" : "",
			"N" : ""
		}
	},
	callback : {
		onCheck : null
	}
};

dictTree = null;
dictDivTree = null;

function showDictTree(target, callback) {
	dictTreeSetting.async.otherParam.pvalue = $(target).attr("pvalue");
	dictTreeSetting.callback.onCheck = callback;
	if(target) {
		if ($("#dictDiv").is(":hidden")) {
			var objOffset = $(target).offset();
			var w = $(target).outerWidth();
			w = w < 200 ? 200 : (w > 300 ? 300 : w - 12);
			$("#dictDiv ul").width(w);
			$("#dictDiv").css({
				left : objOffset.left + "px",
				top : objOffset.top + $(target).outerHeight() + "px"
			}).fadeToggle("fast", function() {
				dictDivTree = !dictDivTree ? $.fn.zTree.init($("#dictDivTree"), dictTreeSetting) : dictDivTree;
			});
			$("body").bind("mousedown", function(event) {
				if (!(event.target.id == "dictDiv"
						|| $(event.target).parents("#dictDiv").length > 0 
						|| event.target == target)) {
						$("#dictDiv").fadeOut("fast");
						$("body").unbind("mousedown");
				}
			});
		}
	}
}

function getChlids(treeNode) {
    var count = 1;
    if(treeNode && treeNode.isParent) {
    	try {
    		count = treeNode.children.length + 1 ;
    	} catch(e) {
    		return treeNode.childs + 1;
    	}
    }
    return count;
}