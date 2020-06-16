$.views.helpers({
	abs: function(value) {
		return Math.abs(value);
	},
});

if (id && !ruleInfo) {
	$('body').html('');
	layer.msg('请求数据不存在', {icon: 5, time: 1500, shade: 0.5});
} else {
	// 结束值跟开始值比较验证
	function compare(field) {
		var minVal = field.parents('td').find('input[name="min_value"]').val(),
			maxVal = field.parents('td').find('input[name="max_value"]').val();
		
		if (maxVal && minVal && Number(maxVal) <= Number(minVal)) {
			return (field.prop('name') === 'max_value') ? '* 必须大于开始值' : '* 必须小于结束值';
		}
	}
	
	/* 
	 * 	动态添加考核规则明细
	 */
	function addRuleDetails(data, isFirst) {
		var targetObj = isFirst ? $('#first-details') : $('#details'),
			detailsTemplate = $($('#details-template').render(data));
		
		detailsTemplate.find('[name="calculate_type"]').each(function(index, obj) {
			var name = $(obj).prop('name') + (isFirst ? '_first_' : '_') + targetObj.find('tr').length;
			$(obj).prop({'id': name + '_' + index, 'name': name});
			$(obj).parents('.layui-form-item:first').find('[name="integral"]').prop('class', 'layui-input validate[custom[number], custom[toFixed2], min[0], max[9999], condRequired[' + name + '_' + index + ']]');
		});
		targetObj.append(detailsTemplate).validationEngine('attach');
	}
	
	layui.use('form', function() {
		var form = layui.form, 
			laydate = layui.laydate;
		
		var vueObj = new Vue({
			el : '#app',
			data : {
				form : {
					use_range : '',
					audit_unit : ''
				}
			},
			watch: {
				'form.audit_unit': function() {
					var _this = this;
					$('select[data-field="calculate_value"]').each(function(i, e) {
						var selected = $(e).find('option:selected').val();
						var html = '';
						if (_this.form.audit_unit == 0) {
							html += '<option value="任务总数" ' + (selected == '任务总数' ? 'selected' : '') + '>&le; 任务总数 &lt;</option>';
							html += '<option value="已执行数" ' + (selected == '已执行数' ? 'selected' : '') + '>&le; 已执行数 &lt;</option>';
							html += '<option value="通过数" ' + (selected == '通过数' ? 'selected' : '') + '>&le; 通过数 &lt;</option>';
							html += '<option value="不通过数" ' + (selected == '不通过数' ? 'selected' : '') + '>&le; 不通过数 &lt;</option>';
							html += '<option value="连续未达标次数" ' + (selected == '连续未达标次数' ? 'selected' : '') + '>&le; 连续未达标次数 &lt;</option>';
						} else {
							html += '<option value="完成数百分率" ' + (selected == '完成数百分率' ? 'selected' : '') + '>&le; 完成数百分率 &lt;</option>';
							html += '<option value="连续未达标次数" ' + (selected == '连续未达标次数' ? 'selected' : '') + '>&le; 连续未达标次数 &lt;</option>';
						}
						$(e).html(html);
					});
					form.render();
				},
				'form.use_range': function() {
					setTimeout(function() {
						form.val('form', {
							pass_type: String(ruleInfo.pass_type),
							pass_type_value: ruleInfo.pass_type_value
						});
						form.render();
					}, 0);
				}
			},
			methods : {
				addFirstDetails : function(event) {
					addRuleDetails({"audit_unit" : this.form.audit_unit}, true);
					form.render();
				},
				addDetails : function(event) {
					addRuleDetails({"audit_unit" : this.form.audit_unit});
					form.render();
				},
				save : function() {
					if ($('form').validationEngine('validate') && $('#first-details').validationEngine('attach') && $('#details').validationEngine('attach')) {
						var _form = {}, items = [];
						decodeURIComponent($('form').serialize()).split('&').forEach(function(i) {
							var j = i.split('=');
							_form[j[0]] = j[1];
						});
						
						$('#first-details tr').each(function(index, e) {
							var item = {if_first : 1, calculate_value : $(e).find('select option:selected').val()};
							$(e).find('input[data-field]').each(function(index, e) {
								if ($(e).data('field') == 'calculate_type') {
									if ($(e).attr('checked')) {
										item[$(e).data('field')] = $(e).val();
									}
								} else if($(e).data('field') == 'integral') {
									if ($(e).parents('.layui-form-item').eq(0).find('[data-field="calculate_type"]').attr('checked') == 'checked') {
										var pomValue = $(e).parents('.layui-form-item').eq(0).find('[data-field="pom"] option:selected').val();
										item[$(e).data('field')] = $(e).val() * pomValue;
									}
								} else {
									item[$(e).data('field')] = $(e).val();
								}
							});
							items.push(item);
						});
						
						$('#details tr').each(function(index, e) {
							var item = {if_first : 0, calculate_value : $(e).find('select option:selected').val()}
							$(e).find('input[data-field]').each(function(index, e) {
								if ($(e).data('field') == 'calculate_type') {
									if ($(e).attr('checked')) {
										item[$(e).data('field')] = $(e).val();
									}
								} else if($(e).data('field') == 'integral') {
									if ($(e).parents('.layui-form-item').eq(0).find('[data-field="calculate_type"]').attr('checked') == 'checked') {
										var pomValue = $(e).parents('.layui-form-item').eq(0).find('[data-field="pom"] option:selected').val();
										item[$(e).data('field')] = $(e).val() * pomValue;
									}
								} else {
									item[$(e).data('field')] = $(e).val();
								}
							});
							items.push(item);
						});
						
						_form.items = items;
						
						var url = './insertRuleDefined.do';
						
						_form.org_id = orgId;
						
						if (ruleInfo.id) {
							url = './updateRuleDefined.do';
							_form.code = ruleInfo.code;
							_form.row_version = ruleInfo.row_version;
						}
						
						var layerIndex;
						$.ajax({
							type : 'POST',
							url : url,
							contentType : 'application/json;charset=UTF-8',
							data : JSON.stringify(_form),
							dataType : 'json',
							beforeSend : function() {
								layerIndex = layer.msg('数据提交中，请等待', {time: 9999, shade: 0.5});
							},
							success : function(response) {
								layer.close(layerIndex);
								if (response.code == 'success') {
									layer.msg('保存成功', {icon: 1, time: 1500, shade: 0.5}, function() {
										parent.layer.close(parent.layer.getFrameIndex(window.name));
										parent.vueObj.renderRuleTable();
									});
								} else {
									layer.msg('保存失败', {icon: 5, time: 1500, shade: 0.5});
								}
							},
							error : function(response) {
								layer.close(layerIndex);
								layer.msg('请求失败', {icon: 5, time: 1500, shade: 0.5});
							}
						});
					}
				}
			},
			mounted : function() {
				$('body').on('click', '.del-rule-item', function(e) {
					$(e.target).parents('tr').detach();
				});
			}
		})
		
		// 考核范围选择修改
		form.on('radio(use_range)', function(obj) {
			if (obj.value != vueObj.form.use_range) {
				vueObj.form.use_range = Math.abs(vueObj.form.use_range - 1);
			}
		});
		
		// 考核单位选择修改
		form.on('radio(audit_unit)', function(obj) {
			if (obj.value != vueObj.form.audit_unit) {
				vueObj.form.audit_unit = Math.abs(vueObj.form.audit_unit - 1);
			}
		});
		
		// 考核单位选择修改
		form.on('radio(calculate_type)', function(obj) {
			$('[name="' + $(obj.elem).prop('name') + '"]').attr('checked', false);
			$(obj.elem).attr('checked', true);
		});
		
		/**************回显处理*****************/
		// 默认值
		var defaults = {
			if_check: '1',
			if_sample: '1',
			use_range: '1',
			row_valid: '1',
			audit_unit: '0',
			rule_group: '1',
			convart_scale: '1',
			use_for_all: '1',
			issue_type: 'number',
			assess_cycle: '3',
			pass_type: '0'
		}
		
		ruleInfo = $.extend(true, defaults, ruleInfo);
		vueObj.form = ruleInfo;
		
		if (ruleInfo) {
			var setting = {
				name: ruleInfo.name,
				if_check: String(ruleInfo.if_check),
				if_sample: String(ruleInfo.if_sample),
				use_range: String(ruleInfo.use_range),
				row_valid: String(ruleInfo.row_valid),
				dataurl: ruleInfo.dataurl,
				audit_unit: String(ruleInfo.audit_unit),
				pass_score: ruleInfo.pass_score,
				rule_group: String(ruleInfo.rule_group),
				convart_scale: ruleInfo.convart_scale,
				issue_type: ruleInfo.issue_type,
				assess_cycle: String(ruleInfo.assess_cycle),
				task_start_time: ruleInfo.task_start_time,
				task_end_time: ruleInfo.task_end_time,
				remark: ruleInfo.remark,
				pass_type: String(ruleInfo.pass_type),
				pass_type_value: ruleInfo.pass_type_value
			};
			
			if (ruleInfo.use_for_all == 1) {
				setting.use_for_all = '1';
			}
			
			form.val('form', setting);
		} else {
			form.val('form', defaults);
		}
		
		if (ruleItems && ruleItems.length > 0) {
			ruleItems.forEach(function(value) {
				value.audit_unit = ruleInfo.audit_unit;
				if (value.if_first == 1) {
					addRuleDetails(value, true);
				} else {
					addRuleDetails(value);
				}
			});
		}
		
		form.render();
		laydate.render({elem : 'input[name="task_start_time"]'});
		
		$('form').validationEngine();
	});
}