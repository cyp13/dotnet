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
			,disabled: true
			,defaultIndex: 0
		},{
			name: 'service_type_detail'
			,element: '#service_type_detail'
			,value: formData['service_type_detail']
			,disabled: true
			,defaultIndex: 0
		}]);
		$(".dataForm *").attr('disabled', 'disabled');
		getFiles(formData.files, "#fileList", true);
	});
	$("#btn-ok").on("click", function() {
		if($('#fileList').children().length<=0){
			$('#file').addClass('validate[required]');
		}else{
			var found = false;
			$('#fileList').children().each(function(){
				found = $(this).attr('state')=='normal';	
			});
			if(found){
				$('#file').removeClass('validate[required]');
			}else{
				$('#file').addClass('validate[required]');
			}
		}
		for(var key in deleteFileIds){
			$("#editForm").append('<input type="hidden" name="deleteFileIds" value="'+key+'" />');
		}
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
	$('input[name=IN_CONTROL]').change(function(){
		if($(this).val()=="归档"){//未解决才可编辑数据
			$(".dataForm input, .dataForm textarea, .dataForm select, .dataForm input[type='radio']").attr('disabled', 'disabled');
			getFiles(formData.files, "#fileList", true);
			$('#evaluate').show();//已解决 
			$('#noevaluate').hide();//未解决
			$('#remark').removeClass('validate[required]'); 
		} else{
			$(".dataForm input, .dataForm textarea, .dataForm select, .dataForm input[type='radio']").removeAttr('disabled', 'disabled');
			getFiles(formData.files, "#fileList", false); 
			$('#evaluate').hide();//已解决 
			$('#noevaluate').show();//未解决
			$('#remark').addClass('validate[required]'); 
		}
	});
	$('.ext1').change(function(){
		var score = $(this).val();
		if(score<4){
			$('#ext2').addClass('validate[required]');
		}else{
			$('#ext2').removeClass('validate[required]');
		};
	});
});
</script>

</body>
</html>