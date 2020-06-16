<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
</head>
<body>

<script>
var sheng, city, county, office, channel, dept;
function checkOut(org){
	if(org.orgType=='6'){//部门
		dept = org;
	}else if(org.orgType=='5'){//渠道
		channel = org;
		$('#channel').val(channel.id);
		$('#channel_name').val(channel.orgName);
	}else if(org.orgType=='4'){//分局
		office = org;
		$('#branch_office').val(office.id);
		$('#branch_office_name').val(office.orgName);
	}else if(org.orgType=='3'){//区县、分公司
		county = org;
		$('#county').val(county.id);
		$('#county_name').val(county.orgName);
	}else if(org.orgType=='2'){//市
		city = org;
		$('#city').val(city.id);
		$('#city_name').val(city.orgName);
	}else if(org.orgType=='1'){//省
		sheng = org;
	}
	if(!sheng && org.extMap.parent){//遍历父级单位
		checkOut(org.extMap.parent);
	}
}
$(window).ready(function() {
	checkOut(JSON.parse('${myUser.extMap.org}'));
	ifOnWork("#editForm *");
	$("#btn-ok").on("click", function() {
		if(!$("#editForm").validationEngine("validate")){
			return;
		}
		$("#btn-ok").attr("disabled", "disabled");
		ajaxSubmit("#editForm", {token: token_}, function(data) {
			if ("0" == data.code) {
				layer.msg("数据处理成功！", {icon: 1}, function(){
					closeCurPage();
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