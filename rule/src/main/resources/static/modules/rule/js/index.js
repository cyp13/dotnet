var vueObj = new Vue({
	el : '#app',
	data : {
		orgId: '',
		ruleList : []
	},
	methods : {
		initTree : function() {
			var _this = this;
			
			var url = ruleConfig.portal, token = ruleConfig.token;
			
			$.ajax({
				type : 'POST',
				url : url,
				data : {"parentId" : ruleConfig.parentId, "token" : token},
				dataType : 'json',
				success : function(response) {
					if (response && response.resCode == 'success') {
						var treeObj = $.fn.zTree.init($('#organizeTree'), {
							data: {
								simpleData: {
									enable: true,
									idKey: "id",
									pIdKey: "parentId",
									rootPId: -1
								},
								key: {
									name: "orgName"
								}
							},
							async: {
								enable: true,
								url: url,
								autoParam:["id=parentId"],
								otherParam:{"token" : token},
								dataFilter: function(treeId, parentNode, childNodes) {
									if (response && response.resCode == 'success') {
										return childNodes.datas;
									}
									return null;
								}
							},
							callback : {
								onClick : _this.renderRuleTable
							}
						}, response.datas);
						
						var node = treeObj.getNodes()[0];
			            treeObj.selectNode(node);
			            treeObj.checkNode(node, true, true);
			            treeObj.setting.callback.onClick(null, treeObj.setting.treeId, node);
					} else {
						layer.msg('获取机构数据失败', {icon: 5});
					}
				},
				error : function(response) {
					layer.msg('获取机构数据失败', {icon: 5});
				}
			});
		},
		renderRuleTable : function(event, treeId, treeNode) { // 渲染规则列表
			var _this = this;
			if (treeNode) {
				_this.orgId = treeNode.id;
			}
			
			$.ajax({
				type : 'POST',
				url : './queryRuleList',
				data : {"orgId" : _this.orgId},
				dataType : 'json',
				success : function(response) {
					if (response.code === "success") {
						_this.ruleList = response.data;
					} else {
						layer.msg('获取规则数据失败', {icon: 5});
					}
				},
				error : function(response) {
					layer.msg('获取规则数据失败', {icon: 5});
				}
			});
		},
		addRule : function() { // 新增规则
			this.showRuleView(null, this.orgId);
		},
		editRule : function(ruleId) { // 修改规则
			this.showRuleView(ruleId, this.orgId);
		},
		updateRuleState: function(data, callback) {
			var layerIndex;
			$.ajax({
				type : 'POST',
				url : './updateRuleState',
				data : data,
				dataType : 'json',
				beforeSend : function() {
					layerIndex = layer.msg('数据提交中，请等待', {time: 9999, shade: 0.5});
				},
				success : function(response) {
					layer.close(layerIndex);
					if (response.code === "success") {
						layer.msg('操作成功', {icon: 1, time: 1500, shade: 0.5}, callback);
					} else {
						layer.msg('操作失败', {icon: 5, time: 1500, shade: 0.5});
					}
				},
				error : function(response) {
					layer.close(layerIndex);
					layer.msg('操作失败', {icon: 5, time: 1500, shade: 0.5});
				}
			});
		},
		deleteRule : function(ruleId) { // 删除规则
			var _this = this;
			layer.confirm('确定要删除选中规则吗？', {
				btn: ['确定', '取消'],
				icon: 3
			}, function(index) {
				_this.updateRuleState({'id' : ruleId, 'rowValid' : -1}, function() {
					_this.renderRuleTable();
				});
			}, function(index) {
				layer.close(index);
			});
		},
		enableRule : function(ruleId, ruleCode) { // 启用规则
			var _this = this;
			layer.confirm('确定要启用选中规则吗？', {
				btn: ['确定', '取消'],
				icon: 3
			}, function(index) {
				_this.updateRuleState({'id' : ruleId, 'rowValid' : 1, 'code' : ruleCode}, function() {
					_this.renderRuleTable();
				});
			}, function(index) {
				layer.close(index);
			});
		},
		disableRule : function(ruleId) { // 停用规则
			var _this = this;
			layer.confirm('确定要停用选中规则吗？', {
				btn: ['确定', '取消'],
				icon: 3
			}, function(index) {
				_this.updateRuleState({'id' : ruleId, 'rowValid' : 0}, function() {
					_this.renderRuleTable();
				});
			}, function(index) {
				layer.close(index);
			});
		},
		showRuleView : function(ruleId, orgId) { // 规则详情
			if (!orgId) {
				layer.msg('请选择一个机构', {icon: 5, time: 1500});
				return;
			}
			if (ruleId) {
				layer.full(layer.open({type : 2, content : './details?orgId=' + orgId + '&id=' + ruleId, area : [ '320px', '195px' ]}));
			} else {
				layer.full(layer.open({type : 2, content : './details?orgId=' + orgId, area : [ '320px', '195px' ]}));
			}
		}
	},
	mounted : function() {
		this.initTree();
	}
});
