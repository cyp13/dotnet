/**
 * version base on jquery 1.x +
 * version base on jquery ztree v.3.5.37
 */

/**
 *
 * @param zTreeId ztree对象的id,不需要#
 * @param searchField 输入框选择器
 * @param isHighLight 是否高亮,默认高亮,传入false禁用
 * @param isExpand 是否展开,默认合拢,传入true展开
 * @returns
 */
var idFuzzySearch = function(zTreeId, searchField, isExpand){
    var zTreeObj = $.fn.zTree.getZTreeObj(zTreeId);//获取树对象
    if(!zTreeObj){
        alter("获取树对象失败");
    }
    var idKey = zTreeObj.setting.data.key.id; //获取name属性的key
    if( !idKey ){
        idKey = "id";
    }
    isExpand = isExpand?true:false;

    var metaChar = '[\\[\\]\\\\\^\\$\\.\\|\\?\\*\\+\\(\\)]'; //js正则表达式元字符集
    var rexMeta = new RegExp(metaChar, 'gi');//匹配元字符的正则表达式

    // 过滤ztree显示数据
    function ztreeFilter(zTreeObj,_keywords,callBackFunc) {
        if(!_keywords){
            _keywords =''; //如果为空，赋值空字符串
        }

        // 查找符合条件的叶子节点
        function filterFunc(node) {

            zTreeObj.updateNode(node); //更新节点让之前对节点所做的修改生效
            if (_keywords.length == 0) {
                //如果关键字为空,返回true,表示每个节点都显示
                zTreeObj.showNode(node);
                zTreeObj.expandNode(node,isExpand); //关键字为空时是否展开节点
                return true;
            }
            //节点名称和关键字都用toLowerCase()做小写处理
            if (node[idKey] && node[idKey].toLowerCase().indexOf(_keywords.toLowerCase())!=-1) {
                zTreeObj.showNode(node);//显示符合条件的节点
                return true; //带有关键字的节点不隐藏
            }

            zTreeObj.hideNode(node); // 隐藏不符合要求的节点
            return false; //不符合返回false
        }
        var nodesShow = zTreeObj.getNodesByFilter(filterFunc); //获取匹配关键字的节点
        processShowNodes(nodesShow, _keywords);//对获取的节点进行二次处理
    }

    /**
     * 对符合条件的节点做二次处理
     */
    function processShowNodes(nodesShow,_keywords){
        if(nodesShow && nodesShow.length>0){
            //关键字不为空时对关键字节点的祖先节点进行二次处理
            if(_keywords.length>0){
                $.each(nodesShow, function(n,obj){
                    var pathOfOne = obj.getPath();//向上追溯,获取节点的所有祖先节点(包括自己)
                    if(pathOfOne && pathOfOne.length>0){ //对path中的每个节点进行操作
                        // i < pathOfOne.length-1, 对节点本身不再操作
                        for(var i=0;i<pathOfOne.length-1;i++){
                            zTreeObj.showNode(pathOfOne[i]); //显示节点
                            zTreeObj.expandNode(pathOfOne[i],true); //展开节点
                        }
                    }
                });
            }else{ //关键字为空则显示所有节点, 此时展开根节点
                var rootNodes = zTreeObj.getNodesByParam('level','0');//获得所有根节点
                $.each(rootNodes,function(n,obj){
                    zTreeObj.expandNode(obj,true); //展开所有根节点
                });
            }
        }
    }

    //监听关键字input输入框文字变化事件
    $(searchField).bind('input propertychange', function() {
        var _keywords = $(this).val();
        searchNodeLazy(_keywords); //调用延时处理
    });

    var timeoutId = null;
    // 有输入后定时执行一次，如果上次的输入还没有被执行，那么就取消上一次的执行
    function searchNodeLazy(_keywords) {
        if (timeoutId) { //如果不为空,结束任务
            clearTimeout(timeoutId);
        }
        timeoutId = setTimeout(function() {
            ztreeFilter(zTreeObj,_keywords);    //延时执行筛选方法
            $(searchField).focus();//输入框重新获取焦点
        }, 500);
    }
}