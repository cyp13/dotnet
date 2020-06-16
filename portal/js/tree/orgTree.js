var queryOrgTreeUrl = ctx + "/jsp/sys/queryOrg.do";
var queryOrgTreeApiUrl = ctx + "/api/sys/queryOrg.do";
var orgTreeSetting = {
	async : {
		enable : true,
		dataType : "json",
		url : queryOrgTreeUrl,
		autoParam : [ "id" ],
		otherParam : { "flag_" : "tree" },
		dataFilter: function(treeId, parentNode, result) {
			if("error" != result.resCode) {
				return result;
			}
		}
	},
	view : {
		dblClickExpand : false
	},
	check : {
		enable : false,
		chkStyle : "checkbox", //radio
		radioType : "all",
		chkboxType : {
			"Y" : "",
			"N" : ""
		}
	},
	data : {
		key : {
			name : "orgName", title : "id"
		},
		simpleData : {
			enable : true,
			idKey : "id",
			pIdKey : "parentId",
		}
	},
	callback : {
		beforeClick : null,
		onCheck : null,
		onAsyncSuccess : null
	}
};

orgTree = null;
orgDivTree = null;

function showOrgTree(target, flag, callback, asyncSuccess) {
	if("1" == flag) {
		orgTreeSetting.async.url = queryOrgTreeApiUrl;
		orgTreeSetting.async.otherParam.flag_ = "tree";
		orgTreeSetting.check.enable = true;
		orgTreeSetting.check.chkStyle = "checkbox";
		orgTreeSetting.check.chkboxType.Y = "";
		orgTreeSetting.check.chkboxType.N = "";
		orgTreeSetting.callback.onCheck = callback;
		orgTreeSetting.callback.beforeClick = null;
		orgTreeSetting.callback.onAsyncSuccess = asyncSuccess;
	} else {
		orgTreeSetting.async.url = queryOrgTreeUrl;
		orgTreeSetting.async.otherParam.flag_ = "tree";
		orgTreeSetting.check.enable = false;
		orgTreeSetting.callback.onCheck = null;
		orgTreeSetting.callback.beforeClick = callback;
		orgTreeSetting.callback.onAsyncSuccess = asyncSuccess;
	}
	
	if(target) {
		if ($("#orgDiv").is(":hidden")) {
			var objOffset = $(target).offset();
			var w = $(target).outerWidth();
			w = w < 200 ? 200 : (w > 300 ? 300 : w - 12);
			$("#orgDiv ul").width(w);
			$("#orgDiv").css({
				left : objOffset.left + "px",
				top : objOffset.top + $(target).outerHeight() + "px"
			}).fadeToggle("fast", function() {
				orgDivTree = !orgDivTree ? $.fn.zTree.init($("#orgDivTree"), orgTreeSetting) : orgDivTree;
			});
			$("body").bind("mousedown", function(event) {
				if (!(event.target.id == "orgDiv"
						|| $(event.target).parents("#orgDiv").length > 0 
						|| event.target == target)) {
						$("#orgDiv").fadeOut("fast");
						$("body").unbind("mousedown");
				}
			});
		}
	} else {
		orgTree = !orgTree ? $.fn.zTree.init($("#orgTree"), orgTreeSetting) : orgTree;
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