(function($) {
	$.websocket = function(options) {
		var defaults = {
			domain : top.location.hostname,
			port : top.location.port,
			uri : ""
		};
		var opts = $.extend(defaults, options);
		var url = "ws://" + opts.domain + ":" + opts.port + opts.uri;
		if (top.location.protocol == 'https:') {
			url = "wss://" + opts.domain + ":" + opts.port + opts.uri;
		}
		var socket = null;
		var isOpen = false;
		var messageEvent = {
			onInit : function() {
				if ("MozWebSocket" in window) {
					socket = new MozWebSocket(url);
				} else if ("WebSocket" in window) {
					socket = new WebSocket(url);
				} else {
					return false;
				}
				if (opts.onInit) {
					opts.onInit();
				}
			},
			onOpen : function(event) {
				isOpen = true;
				if (opts.onOpen) {
					opts.onOpen(event);
				}
			},
			onSend : function(msg) {
				if (opts.onSend) {
					opts.onSend(msg);
				}
				socket.send(msg);
			},
			onMessage : function(event) {
				if (opts.onMessage) {
					opts.onMessage(event.data);
				}
			},
			onClose : function(event) {
				if (opts.onclose) {
					opts.onclose(event);
				}
				if (socket.close() != null) {
					socket = null;
				}
			},
			onError : function(event) {
				if (opts.onError) {
					opts.onError(event);
				}
			}
		};

		messageEvent.onInit();
		socket.onopen = messageEvent.onOpen;
		socket.onmessage = messageEvent.onMessage;
		socket.onclose = messageEvent.onClose;
		socket.onerror = messageEvent.onError;

		this.send = function(data) {
			if (isOpen == false) {
				return false;
			}
			messageEvent.onSend(data);
			return true;
		};
		this.close = function() {
			messageEvent.onClose();
		};
		return this;
	};
})(jQuery);