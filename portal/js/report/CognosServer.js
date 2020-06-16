CognosContext = {};//隐藏所有状态栏为&ui=h1h2h3h4或&cv.header=false&cv.toolbar=false
CognosContext.authaction = "b_action=xts.run&m=portal/main.xts&h_CAM_action=logonAs";
CognosContext.logoutaction = "b_action=xts.run&m=portal/logoff.xts&h_CAM_action=logoff";
CognosContext.viewaction = "b_action=xts.run&m=portal/launch.xts&ui.tool=CognosViewer&ui.action=view&cv.header=false&cv.toolbar=false&run.prompt=false";
CognosContext.runaction = "b_action=xts.run&m=portal/launch.xts&ui.tool=CognosViewer&ui.action=run&cv.header=false&cv.toolbar=false&run.prompt=false";
CognosContext.queryaction = "b_action=xts.run&m=portal/launch.xts&ui.tool=QueryStudio&ui.action=edit&launch.openJSStudioInFrame=true&ui=";
CognosContext.reportaction = "b_action=xts.run&m=portal/launch.xts&ui.tool=ReportStudio&ui.action=edit&launch.openJSStudioInFrame=true&ui=";
CognosContext.analysisaction = "b_action=xts.run&m=portal/launch.xts&ui.tool=AnalysisStudio&ui.action=edit&launch.openJSStudioInFrame=true&ui=";
function CognosServer(serverurl, gateway) {
	this.serverurl = serverurl;
	this.gateway = gateway;
	this.login = function(username, password, namespace) {
		var islogin = false;
		namespace = "" == namespace ? "dbAuth" : namespace;//默认为数据库认证
		var url = this.serverurl + "?" + CognosContext.authaction;
		url = url + "&CAMUsername=" + username + "&CAMPassword=" + password
				+ "&CAMNamespace=" + namespace;
		try {
			var xmlHttp = createXMLHttp();
			xmlHttp.onreadystatechange = function() {
				if (xmlHttp.readyState == 4) {
					if (xmlHttp.status == 200) {
						var rs = xmlHttp.responseText;//判断包含CAM-AAA-0136为已经登录，包含g_PS_msg_PasswordVerifyFailed为用户名密码不正确
						if (rs.indexOf("CAM-AAA-0136") != -1) {
							islogin = true;
						} else if (rs.indexOf("CAM-AAA-0136") == -1
								&& rs.indexOf("g_PS_msg_PasswordVerifyFailed") != -1) {
							alert("COGNOS认证失败，用户名或密码错误！");
						} else if (rs.indexOf("CAM-AAA-0034") != -1) {
							alert("COGNOS认证失败，名称空间\"" + namespace + "\"不存在！");
						} else {
							alert("COGNOS认证失败，未知错误！");
						}
					}
				}
			};
			xmlHttp.open("GET", url, true);
			xmlHttp.send(null);
		} catch (e) {
			alert(e.message);
		}
		return islogin;
	}
}
//server:Cognos服务器,obj:搜索路径,type:表示报表对应的编辑器(Q,R,A)
function CognosReport(server, obj, type) {
	this.server = server;
	this.obj = obj;
	this.type = type;
	//查询历史报表
	this.viewhistoryreport = function(params, target) {
		var url = this.server.serverurl + "?" + CognosContext.viewaction;
		url = url + "&ui.object=defaultOutput(" + encodeURIComponent(this.obj)
				+ ")";
		url = null == params ? url : url + "&" + params;
		target = null == target ? "_self" : target;
		window.open(url, target);
	}
	//查询报表
	this.runreport = function(params, target) {
		var url = this.server.serverurl + "?" + CognosContext.runaction;
		url = url + "&ui.object=" + encodeURIComponent(this.obj);
		url = null == params ? url : url + "&" + params;
		target = null == target ? "_self" : target;
		window.open(url, target);
	}
	//使用QueryStudio编辑报表
	this.editUseQueryStudio = function(target) {
		var url = this.server.serverurl + "?" + CognosContext.queryaction;
		url = url + "&ui.object=" + encodeURIComponent(this.obj);
		target = null == target ? "_self" : target;
		window.open(url, target);
	}
	//使用ReportStudio编辑报表,编辑时需要gateway参数
	this.editUseReportStudio = function(target) {
		var url = this.server.serverurl + "?" + CognosContext.reportaction;
		url = url + "&ui.gateway=" + this.server.gateway;
		url = url + "&ui.object=" + encodeURIComponent(this.obj);
		target = null == target ? "_self" : target;
		window.open(url, target);
	}
	//使用AnalysisStudio编辑报表,编辑时需要gateway参数
	this.editUseAnalysisStudio = function(target) {
		var url = this.server.serverurl + "?" + CognosContext.analysisaction;
		url = url + "&ui.gateway=" + this.server.gateway;
		url = url + "&ui.object=" + encodeURIComponent(this.obj);
		target = null == target ? "_self" : target;
		window.open(url, target);
	}
}
//model:0-查询历史报表,1-查询报表,2-编辑报表
function showReport(report, model, params, target) {
	if (report instanceof CognosReport) {
		if (model == 0) {
			report.viewhistoryreport(params, target);
		} else if (model == 1) {
			report.runreport(params, target);
		} else if (model == 2) {
			if (report.type == "Q") {
				report.editUseQueryStudio(target);
			} else if (report.type == "R") {
				report.editUseReportStudio(target);
			} else if (report.type == "A") {
				report.editUseAnalysisStudio(target);
			}
		}
	} else {
		alert("操作错误，不是COGNOS报表对象！");
	}
}
function createXMLHttp() {
	var xmlHttp;
	if (window.ActiveXObject) {
		try {
			xmlHttp = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try {
				xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e) {
				alert(e.message);
			}
		}
	} else if (window.XMLHttpRequest) {
		xmlHttp = new XMLHttpRequest();
		if (xmlHttp.overrideMimeType) {
			xmlHttp.overrideMimeType('text/xml');
		}
	}
	return xmlHttp;
}