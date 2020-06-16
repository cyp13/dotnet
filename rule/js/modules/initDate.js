define(["jquery","jedate","util"],function(){
	var date = util.formatDate('','yyyy-MM-dd');
	var start = {
	    format: 'YYYY-MM-DD',
	    minDate: '2000-06-16', //设定最小日期为当前日期
	    festival: false,
	    isToday: false, 
	    maxDate: date, //最大日期
	    choosefun: function(elem, datas) {
	        end.minDate = datas; //开始日选好后，重置结束日的最小日期
	    },
	    clearfun:function(elem, val) {
	    	end.minDate = start.minDate;
	    }
	};
	var end = {
	    format: 'YYYY-MM-DD',
	    minDate: '2000-06-16', //设定最小日期为当前日期
	    festival: false,
	    isToday: false, 
	    maxDate: date, //最大日期
	    choosefun: function(elem, datas) {
	        start.maxDate = datas; //将结束日的初始值设定为开始日的最大日期
	    },
	    clearfun:function(elem, val) {
	    	start.maxDate = end.maxDate;
	    }
	};
	$("#inpstart").jeDate(start);
	$("#inpend").jeDate(end);
})