var orgDivTree;
var queryOrgTreeUrl = host_ + "/jsp/sys/queryOrg.do";
var queryOrgRoleUrl = "/qdzc/jsp/work/queryRoleByOrg.do";
var queryOrgUserUrl = "/qdzc/jsp/work/queryUserByOrg.do";
var orgAllLoadsetting = {
			async: {
				enable: true,
				dataType : "json",
				url: queryOrgTreeUrl,
				autoParam:["id"],
				otherParam : { "flag_" : "tree" , "sys_" : "2" ,"token" : token_ },
				dataFilter: function(treeId, parentNode, result) {
					if("error" != result.resCode) {
						return result;
					}
				}
			},
			check : {
				enable : true,
				chkStyle : "radio",
				radioType: "all"
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
			callback: {
				beforeAsync: beforeAsync,
				onAsyncSuccess: onAsyncSuccess,
				onAsyncError: onAsyncError,
				onCheck : onCheck
			}
		};
function beforeAsync() {
	curAsyncCount++;
}

var layerLoad = null;

function onAsyncSuccess(event, treeId, treeNode, msg) {

	layerLoad = layer.load(2, {
		shade : [ 0.3, '#393D49' ]
	});
	//msg = JSON.parse(msg);
	if ("error" == msg.resCode) {
		layer.close(layerLoad);
		layer.msg("机构查询异常:" + msg.resMsg, {
			icon : 2
		});
		return;
	}

	curAsyncCount--;
	if (curStatus == "expand" && treeNode && treeNode.children) {
		expandNodes(treeNode.children);
	} else if (curStatus == "async" && treeNode && treeNode.children) {
		asyncNodes(treeNode.children);
	}
	if (curAsyncCount <= 0) {
		if (curStatus != "init" && curStatus != "") {
			asyncForAll = true;
			selectOrgNode();
		}
		curStatus = "";
		layer.close(layerLoad);
	}
}

function onAsyncError(event, treeId, treeNode, XMLHttpRequest, textStatus,
		errorThrown) {
	curAsyncCount--;
	if (curAsyncCount <= 0) {
		curStatus = "";
		if (treeNode != null)
			asyncForAll = true;
	}
}

var curStatus = "init", curAsyncCount = 0, asyncForAll = false, goAsync = false;
function expandAll() {
	if (!check()) {
		return;
	}
	var zTree = $.fn.zTree.getZTreeObj("orgDivTree");
	if (asyncForAll) {
		zTree.expandAll(true);
	} else {
		expandNodes(zTree.getNodes());
		if (!goAsync) {
			curStatus = "";
		}
	}
}
function expandNodes(nodes) {
	if (!nodes)
		return;
	curStatus = "expand";
	var zTree = $.fn.zTree.getZTreeObj("orgDivTree");
	for (var i = 0, l = nodes.length; i < l; i++) {
		zTree.expandNode(nodes[i], true, false, false);
		if (nodes[i].isParent && nodes[i].zAsync) {
			expandNodes(nodes[i].children);
		} else {
			goAsync = true;
		}
	}
}

function asyncAll() {
	if (!check()) {
		return;
	}
	var zTree = $.fn.zTree.getZTreeObj("orgDivTree");
	if (asyncForAll) {

	} else {
		asyncNodes(zTree.getNodes());
		if (!goAsync) {
			curStatus = "";
		}
	}
}
function asyncNodes(nodes) {
	if (!nodes)
		return;
	curStatus = "async";
	var zTree = $.fn.zTree.getZTreeObj("orgDivTree");
	for (var i = 0, l = nodes.length; i < l; i++) {
		if (nodes[i].isParent && nodes[i].zAsync) {
			asyncNodes(nodes[i].children);
		} else {
			goAsync = true;
			zTree.reAsyncChildNodes(nodes[i], "refresh", true);
		}
	}
}
function check() {
	if (curAsyncCount > 0) {
		return false;
	}
	return true;
}

function onCheck(){
	var zTree = $.fn.zTree.getZTreeObj("orgDivTree");
	var nodes = zTree.getNodesByParam("checked", true, null);
	var id = [],name = [];
	for( var i = 0 ; i < nodes.length ; i++ ){
		id.push( nodes[i].id );
		name.push( nodes[i].orgName );
		if($("#roleNames_").length>0){//旧数据兼容
			getOrgRole(nodes[i].id);//获取相应角色
		}else{
			getOrgUser(nodes[i].id);//获取相应人员
		}
		
	}
	$("#orgIds").val( id.join(",") );
	$("#orgNames").val( name.join(",") );
	
}

function getOrgRole(orgId){
	$("#roleNames_").html('');//清空角色信息
	var param = new Object();
	param.url=queryOrgRoleUrl;
	param.orgId = orgId;
	ajax(param, function(data){
		if(data.Rows.length>0){
			formatData(data.Rows,"roleName_","role_name","select","#roleNames_");
		}else{
			alert("当前机构下无可选择角色，请选择其他机构！");
			return;
		}
	});
}

function getOrgUser(orgId){
	$("#xzry_").html('');//清空人员信息
	var param = new Object();
	param.url=queryOrgUserUrl;
	param.orgId = orgId;
	ajax(param, function(data){
		if(data.Rows.length>0){
			formatData(data.Rows,"user_name","user_alias","select","#xzry_","role_name");
		}else{
			alert("当前机构下无可选择人员，请选择其他机构！");
			return;
		}
	});
}

function selectOrgNode() {
	var ids = $("#orgIds").val();
	var zTree = $.fn.zTree.getZTreeObj("orgDivTree");
	if (zTree && ids && ids.length > 0) {
		var idArr = ids.split(",");
		for (var i = 0; i < idArr.length; i++) {
			var node = zTree.getNodeByParam("id", idArr[i]);
			if (node && null != node) {
				zTree.checkNode(node, true, false);
			}
		}
	}
}

function bindOrgTreeEvent() {
	$("body")
			.bind(
					"mousedown",
					function(event) {
						if (!(event.target.id == "orgDiv"
								|| $(event.target).parents("#orgDiv").length > 0 || event.target == $("#orgNames"))) {
							$("#orgDiv").fadeOut("fast");
							$("body").unbind("mousedown");
						}
					});
}