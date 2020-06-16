<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>

<script>
var pid = '${param.pId}';
var taskId = '${param.taskId}';
var formData = null;
$(window).ready(function() {
	ajax({
		url: 'gongdan/queryForm.do',
		async: false,
		token: token_,
		pid: pid,
		taskId: taskId,
		ptype: $('#ptype').val()
	}, function(data){
		formData = data.rows[0];
		$("#editForm").fill(formData);
		initDictSelect([{
			parentId: '${requestScope.PTYPE}'
			,name: 'service_type'
			,element: '#service_type'
			,value: formData['service_type']
			,disabled: false
			,defaultIndex: 0
		},{
			name: 'service_type_detail'
			,element: '#service_type_detail'
			,value: formData['service_type_detail']
			,disabled: false
			,defaultIndex: 0
		}]);
		$(".dataForm *").attr('disabled', 'disabled');
		getFiles(formData.files, "#fileList", true);
	});
	$("#btn-ok").on("click", function() {
		if(!$("#editForm").validationEngine("validate")){
			return;
		}
		$("#btn-ok").attr("disabled", "disabled");
		ajaxSubmit("#editForm", {token: token_}, function(data) {
			if ("0" == data.code) {
				layer.msg("数据处理成功！", {icon: 1}, function(){
					back_();
				});
			} else {
				layer.msg(data.msg, {icon: 2});
				$("#btn-ok").removeAttr("disabled");
			};
		});
	});
});
</script>

</body>
</html>