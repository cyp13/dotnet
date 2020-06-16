var queryMenuTreeUrl = ctx + "/jsp/sys/queryMenu.do";
menuTree = null;
menuDivTree = null;

var menuTreeSetting = {
	async : {
		enable : true,
		dataType : "json",
		url : queryMenuTreeUrl,
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
			"Y" : "ps",
			"N" : "s"
		}
	},
	data : {
		key : {
			name : "menuName", title : "menuUrl"
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
		onAsyncSuccess: function() {
			if(menuTree) {
			//	setTimeout(function() {
					var root = menuTree.getNodeByTId("menuTree_1");
					if(root && !root.open) {
						menuTree.expandNode(root, true);
					}
			//	}, 100);
			}
		}
	}
};

function showMenuTree(target, flag, roleId, callback) {
	if(roleId && "1" == flag) {
		menuTreeSetting.async.url = queryMenuTreeUrl + "?roleId="+roleId;
		menuTreeSetting.async.otherParam.flag_ = "role";
		menuTreeSetting.async.otherParam.rowValid = "1";
		menuTreeSetting.async.otherParam.menuTypes = "";
		menuTreeSetting.check.enable = true;
		menuTreeSetting.check.chkStyle = "checkbox";
		menuTreeSetting.check.chkboxType.Y = "ps";
		menuTreeSetting.check.chkboxType.N = "s";
		menuTreeSetting.callback.onCheck = callback;
		menuTreeSetting.callback.beforeClick = null;
	} else if(roleId && "2" == flag) {
		menuTreeSetting.async.url = queryMenuTreeUrl + "?roleId="+roleId;
		menuTreeSetting.async.otherParam.flag_ = "page";
		menuTreeSetting.async.otherParam.rowValid = "1";
		menuTreeSetting.async.otherParam.menuTypes = "1,2,3";
		menuTreeSetting.check.enable = true;
		menuTreeSetting.check.chkStyle = "radio";
		menuTreeSetting.check.chkboxType.Y = "";
		menuTreeSetting.check.chkboxType.N = "";
		menuTreeSetting.callback.onCheck = callback;
		menuTreeSetting.callback.beforeClick = null;
	} else {
		menuTreeSetting.async.url = queryMenuTreeUrl;
		menuTreeSetting.async.otherParam.flag_ = "tree";
		menuTreeSetting.async.otherParam.rowValid = "";
		menuTreeSetting.async.otherParam.menuTypes = "";
		menuTreeSetting.check.enable = false;
		menuTreeSetting.callback.onCheck = null;
		menuTreeSetting.callback.beforeClick = callback;
	}
	
	if(target) {
		if ($("#menuDiv").is(":hidden")) {
			var objOffset = $(target).offset();
			var w = $(target).outerWidth();
			w = w < 200 ? 200 : (w > 300 ? 300 : w - 12);
			$("#menuDiv ul").width(w);
			$("#menuDiv").css({
				left : objOffset.left + "px",
				top : objOffset.top + $(target).outerHeight() + "px"
			}).fadeToggle("fast", function() {
				menuDivTree = !menuDivTree ? $.fn.zTree.init($("#menuDivTree"), menuTreeSetting) : menuDivTree;
			});
			$("body").bind("mousedown", function(event) {
				if (!(event.target.id == "menuDiv"
					|| $(event.target).parents("#menuDiv").length > 0 
					|| event.target == target)) {
					$("#menuDiv").fadeOut("fast");
					$("body").unbind("mousedown");
				}
			});
		}
	} else {
		menuTree = !menuTree ? $.fn.zTree.init($("#menuTree"), menuTreeSetting) : menuTree;
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