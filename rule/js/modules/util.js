define([],function(){
    //工单状态
	function getStatus(runStatus) {
        switch (runStatus) {
            case 0:
                return "未知";
            case 1:
                return "已发布";
            case 2:
                return "已回复";
            case 3:
                return "已驳回";
            case 4:
                return "已重新发布";
            case 5:
                return "已解决";
            case 6:
                return "未解决";
            case 7:
                return "已转派";
            default:
                break;
        }
    }
    //获取工单类型
    function getTaskType(stepStatus) {
        id = Number(stepStatus);
        switch (id) {
            case 0:
                return "待处理";
            case 1:
                return "发布";
            case 2:
                return "回复";
            case 3:
                return "驳回";
            case 4:
                return "已解决";
            case 5:
                return "重新发布";
            case 6:
                return "未解决";
            case 7:
                return "转派";
            default:
                break;
        }
    }
    function formatTime(date){
        return date.replace("T"," ").split('.')[0];
    }
    function fileType(t){
        var type = t.toLowerCase();
        switch(type){
            case "jpg":
            case "jpeg":
            case "png":
            case "gif":
                return ["icon-tupianyulan ispic","预览"];
            case "txt":
            case "pdf":
                return ["icon-tupianyulan  isfile","预览"];
            default:
                return ["icon-xiazai","下载"];
        }
    }
    //'yyyy-MM-dd hh:mm'
    function formatDate(time, fmt) {
        var date = time ? new Date(time) :new Date() ;
        if (/(y+)/.test(fmt)) {
            fmt = fmt.replace(RegExp.$1, (date.getFullYear() + '').substr(4 - RegExp.$1.length));
        }
        var o = {
            'M+': date.getMonth() + 1,
            'd+': date.getDate(),
            'h+': date.getHours(),
            'm+': date.getMinutes(),
            's+': date.getSeconds()
        };
        for (var k in o) {
            if (new RegExp("("+k+")").test(fmt)) {
                var str = o[k] + '';
                fmt = fmt.replace(RegExp.$1, (RegExp.$1.length === 1) ? str : padLeftZero(str));
            }
        }
        return fmt;
    }
    function padLeftZero(str) {
        return ('00' + str).substr(str.length);
    }
	return util = {
		getStatus:getStatus,
		getTaskType:getTaskType,
		formatTime:formatTime,
		fileType:fileType,
        formatDate:formatDate
	};
})