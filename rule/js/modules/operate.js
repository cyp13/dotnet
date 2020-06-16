define(["config","util"],function(){
    function backgroudColor(node) {
        var trList = node.find("tr");
        var trLength = trList.length;
        for (var i = 0; i < trLength; i++) {
            if (i % 2 == 1) {
                node.find("tr").eq(i).addClass("even");
            }
        }
    };
    function getFj(value){
        var str1 = "";
        var arr = value !="" ? value.split('|') : [];
        if(arr.length > 0){
            for(var j=0;j<arr.length;j++){
                if(arr[j] != ""){
                    var filename = arr[j].split(':');
                    var index = filename[0].lastIndexOf('.');
                    var type = util.fileType(filename[0].substring(index+1));
                    var _target = type[0].indexOf('xiazai') > -1 ? "_self" : "_blank";
                    str1 += '<div class="file-wrap">'+
                            '<a class="file" href="' + request.baseUrl + filename[1] + '" download="" target="'+_target+'">' + filename[0] + '</a>'+
                            '<i class="iconfont '+ type[0] +'" title="'+type[1]+'" ></i></div>';
      		}
            }
        } else {
            str1 = "无";
        }
        return str1
    }
	return operate = {
        backgroudColor:backgroudColor,
        getFj:getFj
	};
})