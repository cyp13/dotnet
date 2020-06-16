var connection = null;
var openfire_name = 'openfire';

function connect(){
	connection = new Strophe.Connection($('#bosh').val());
	//Uncomment the following lines to spy on the wire traffic.
	connection.rawInput = function (data) {
		//console.log('RECV: ' + data);
	};
	connection.rawOutput = function (data) {
		//console.log('SEND: ' + data);
	};
	//Uncomment the following line to see all the debug output.
	Strophe.log = function (level, msg) {
		//console.log('LOG['+level+']: ' + msg);
	};
	connection.connect($('#username').val() + '@' + openfire_name, $('#password').val(), onConnect);
}
function disconnect(){
	connection.disconnect();
}
function onConnect(status){
    if (status == Strophe.Status.CONNECTING) {
    	$('#logbar').html('Strophe 正在连接...');
    } else if (status == Strophe.Status.CONNFAIL) {
    	$('#logbar').html('Strophe 连接失败');
    } else if (status == Strophe.Status.DISCONNECTING) {
    	$('#logbar').html('Strophe 正在断开连接...');
    } else if (status == Strophe.Status.DISCONNECTED) {
    	$('#logbar').html('Strophe 成功断开');
		$('#connectbtn').html('登录');
		$('#connectbtn')[0].onclick = connect;
    } else if (status == Strophe.Status.CONNECTED) {
    	$('#logbar').html('Strophe 连接成功');
		//log('ECHOBOT: Send a message to ' + connection.jid + ' to talk to me.');
		connection.addHandler(onMessage, null, 'message', null, null,  null); 
		connection.send($pres().tree());
		$('#connectbtn').html('登出');
		$('#connectbtn')[0].onclick = disconnect;
		initLayim();
    }
}
function initLayim(){
	$.ajax({
		url: 'jsp/ques/queryImInitInfoIM.do'
		,data: {
			account: $('#username').val()
		}
		,async: true
		,type: "POST"
		,dataType: "json"
		,success: function(data) {
			layui.use('layim', function(layim){
				window.layim = layim;
				layim.config({
					title: data['data']['mine']['username']
					,brief: false
					,min: false
					,right: '5px'
					,notice: true
					,isgroup: false
					,copyright: true
					,uploadImage: {
						url: '' //（返回的数据格式见下文）
						,type: '' //默认post
					}
					,uploadFile: {
						url: '' //（返回的数据格式见下文）
						,type: '' //默认post
					}
					,isAudio: true //开启聊天工具栏音频
					,isVideo: true //开启聊天工具栏视频
					,init: {
						mine: data['data']['mine']
						,friend: data['data']['friend']
					}
					,chatLog: layui.cache.dir + 'css/modules/layim/html/chatlog.html'
				});
				layim.on('sendMessage', function(res){
					var reply = $msg({
						type: 'chat'
						,to: res.to.id + '@' + openfire_name
						,from: res.mine.id + '@' + openfire_name
						,toId: res.to.id
						,fromId: res.mine.id
						,username: res.mine.username
						,avatar: res.mine.avatar
						,timestamp: new Date().getTime()
						,cId: 0
					}).cnode(Strophe.xmlElement('body', '' , res.mine.content));
					connection.send(reply.tree());
					//console.log('发送至[' + toId + ']: ' + msg);
				});
//				var cache =  layui.layim.cache();
//				var local = layui.data('layim')[cache.mine.id]; //获取当前用户本地数据
//				//这里以删除本地聊天记录为例
//				delete local.chatlog;
//				//向localStorage同步数据
//				layui.data('layim', {
//				  key: cache.mine.id
//				  ,value: local
//				});
			});
		}
	});
}
function onMessage(msg) {
	var type = msg.getAttribute('type');
	var elems = msg.getElementsByTagName('body');
	if (type == "chat" && elems.length > 0) {
		var body = elems[0];
		layim.getMessage({
			id: msg.getAttribute('fromId') //消息的来源ID（如果是私聊，则是用户id，如果是群聊，则是群组id）
			,fromid: msg.getAttribute('fromId') //消息的发送者id（比如群组中的某个消息发送者），可用于自动解决浏览器多窗口时的一些问题
			,username: msg.getAttribute('username') //消息来源用户名
			,avatar: msg.getAttribute('avatar') //消息来源用户头像
			,type: 'friend'
			,content: Strophe.getText(body) //消息内容
			,cid: msg.getAttribute('cId') //消息id，可不传。除非你要对消息进行一些操作（如撤回）
			,mine: false //是否我发送的消息，如果为true，则会显示在右方
			,timestamp: msg.getAttribute('avatar')-0 //服务端时间戳毫秒数。注意：如果你返回的是标准的 unix 时间戳，记得要 *1000
		});
		//console.log('接收到['+from+']: ' + Strophe.getText(body));
	}
	return true;
}