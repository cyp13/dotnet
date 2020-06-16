(function($) {
	var myflow = $.myflow;

	$.extend(true, myflow.config.props.props, {
		name : {
			name : 'name',
			label : '流程',
			value : '新建流程',
			editor : function() {
				return new myflow.editors.inputEditor('pdId');
			}
		},
		description : {
			name : 'description',
			label : '描述',
			value : '',
			editor : function() {
				return new myflow.editors.inputEditor('description');
			}
		}
	});

	$.extend(true, myflow.config.tools.states, {
		start : {
			showType : 'image',
			type : 'start',
			name : {
				text : '<<start>>'
			},
			text : {
				text : '开始'
			},
			img : {
				src : ctx+'/js/designer/img/48/start_event_empty.png',
				width : 48,
				height : 48
			},
			attr : {
				width : 50,
				heigth : 50
			},
			props : {
				name : {
					name : 'name',
					label : '名称',
					value : '开始',
					editor : function() {
						return new myflow.editors.textEditor('name');
					}
				}
				,api : {
					name : 'api',
					label : '接口',
					value : '',
					editor : function() {
						return new myflow.editors.inputEditor('api');
					}
				}
			}
		},
		task : {
			showType : 'text',
			type : 'task',
			name : {
				text : '<<task>>'
			},
			text : {
				text : '任务'
			},
			img : {
				src : ctx+'/js/designer/img/48/task_empty.png',
				width : 48,
				height : 48
			},
			props : {
				name : {
					name : 'name',
					label : '名称',
					value : '',
					editor : function() {
						return new myflow.editors.textEditor('name');
					}
				},
				form : {
					name : 'form',
					label : '表单',
					value : '',
					editor : function() {
						return new myflow.editors.inputEditor('form');
					}
				},
				assignee : {
					name : 'assignee',
					label : '用户',
					value : '',
					editor : function() {
						return new myflow.editors.inputEditor('assignee');
					}
				},/*
				'candidateUsers' : {
					name : 'candidateUsers',
					label : '多人',
					value : '',
					editor : function() {
						return new myflow.editors.inputEditor();
					}
				},*/
				'candidateGroups' : {
					name : 'candidateGroups',
					label : '角色',
					value : '',
					editor : function() {
						return new myflow.editors.selectEditor(ctx + '/api/jbpm/queryRole.do');
					}
				}
				,'description' : {
					name : 'description',
					label : '机构',
					value : '',
					editor : function() {
						var select = [];
						var obj = new Object();
						obj.name = '请选择';
						obj.value = '';
						select.push(obj);
						obj = new Object();
						obj.name = '发起人相同机构';
						obj.value = '_11';
						select.push(obj);
						obj = new Object();
						obj.name = '发起人同级机构';
						obj.value = '_12';
						select.push(obj);
						obj = new Object();
						obj.name = '发起人上级机构';
						obj.value = '_13';
						select.push(obj);
						obj = new Object();
						obj.name = '发起人下级机构';
						obj.value = '_14';
						select.push(obj);
						obj = new Object();
						obj.name = '上一任务相同机构';
						obj.value = '_21';
						select.push(obj);
						obj = new Object();
						obj.name = '上一任务同级机构';
						obj.value = '_22';
						select.push(obj);
						obj = new Object();
						obj.name = '上一任务上级机构';
						obj.value = '_23';
						select.push(obj);
						obj = new Object();
						obj.name = '上一任务下级机构';
						obj.value = '_24';
						select.push(obj);
						obj = new Object();
						obj.name = '#{orgIds_}';
						obj.value = '#{orgIds_}';
						select.push(obj);
						return new myflow.editors.selectEditor(select);
					}
				}
				,'swim' : {
					name : 'swim',
					label : '泳道',
					value : '1',
					editor : function() {
						var select = [];
						var obj = new Object();
						obj.name = '是';
						obj.value = '1';
						select.push(obj);
						obj = new Object();
						obj.name = '否';
						obj.value = '0';
						select.push(obj);
						return new myflow.editors.selectEditor(select);
					}
				}
				,'msg' : {
					name : 'msg',
					label : '通知',
					value : '0',
					editor : function() {
						var select = [];
						var obj = new Object();
						obj.name = '请选择';
						obj.value = '0';
						select.push(obj);
						obj = new Object();
						obj.name = '消息';
						obj.value = '1';
						select.push(obj);
						return new myflow.editors.selectEditor(select);
					}
				}
				,due : {
					name : 'due',
					label : '时效',
					value : '',
					editor : function() {
						return new myflow.editors.inputEditor('due');
					}
				}
				,rep : {
					name : 'rep',
					label : '间隔',
					value : '',
					editor : function() {
						return new myflow.editors.inputEditor('rep');
					}
				}
				,api : {
					name : 'api',
					label : '接口',
					value : '',
					editor : function() {
						return new myflow.editors.inputEditor('api');
					}
				}
			}
		},
		decision : {
			showType : 'image',
			type : 'decision',
			name : {
				text : '<<decision>>'
			},
			text : {
				text : '决策'
			},
			img : {
				src : ctx+'/js/designer/img/48/gateway_exclusive.png',
				width : 48,
				height : 48
			},
			attr : {
				width : 50,
				heigth : 50
			},
			props : {
				name : {
					name : 'name',
					label : '名称',
					value : '',
					editor : function() {
						return new myflow.editors.textEditor('name');
					}
				},
				expr : {
					name : 'expr',
					label : '判断',
					value : '',
					editor : function() {
						return new myflow.editors.inputEditor('expr');
					}
				}
				,api : {
					name : 'api',
					label : '接口',
					value : '',
					editor : function() {
						return new myflow.editors.inputEditor('api');
					}
				}
			}
		},
		fork : {
			showType : 'image',
			type : 'fork',
			name : {
				text : '<<fork>>'
			},
			text : {
				text : '分支'
			},
			img : {
				src : ctx+'/js/designer/img/48/gateway_parallel.png',
				width : 48,
				height : 48
			},
			attr : {
				width : 50,
				heigth : 50
			},
			props : {
				name : {
					name : 'name',
					label : '名称',
					value : '',
					editor : function() {
						return new myflow.editors.textEditor('name');
					}
				}
			}
		},
		join : {
			showType : 'image',
			type : 'join',
			name : {
				text : '<<join>>'
			},
			text : {
				text : '合并'
			},
			img : {
				src : ctx+'/js/designer/img/48/gateway_parallel.png',
				width : 48,
				height : 48
			},
			attr : {
				width : 50,
				heigth : 50
			},
			props : {
				name : {
					name : 'name',
					label : '名称',
					value : '',
					editor : function() {
						return new myflow.editors.textEditor('name');
					}
				}
			}
		},
		end : {
			showType : 'image',
			type : 'end',
			name : {
				text : '<<end>>'
			},
			text : {
				text : '结束'
			},
			img : {
				src : ctx+'/js/designer/img/48/end_event_terminate.png',
				width : 48,
				height : 48
			},
			attr : {
				width : 50,
				heigth : 50
			},
			props : {
				name : {
					name : 'name',
					label : '名称',
					value : '结束',
					editor : function() {
						return new myflow.editors.textEditor('name');
					}
				}
				,api : {
					name : 'api',
					label : '接口',
					value : '',
					editor : function() {
						return new myflow.editors.inputEditor('api');
					}
				}
			}
		},
		'end-cancel' : {
			showType : 'image',
			type : 'end-cancel',
			name : {
				text : '<<end-cancel>>'
			},
			text : {
				text : '取消'
			},
			img : {
				src : ctx+'/js/designer/img/48/end_event_cancel.png',
				width : 48,
				height : 48
			},
			attr : {
				width : 50,
				heigth : 50
			},
			props : {
				name : {
					name : 'name',
					label : '名称',
					value : '取消',
					editor : function() {
						return new myflow.editors.textEditor('name');
					}
				}
			}
		},
		'end-error' : {
			showType : 'image',
			type : 'end-error',
			name : {
				text : '<<end-error>>'
			},
			text : {
				text : '错误'
			},
			img : {
				src : ctx+'/js/designer/img/48/end_event_error.png',
				width : 48,
				height : 48
			},
			attr : {
				width : 50,
				heigth : 50
			},
			props : {
				name : {
					name : 'name',
					label : '名称',
					value : '错误',
					editor : function() {
						return new myflow.editors.textEditor('name');
					}
				}
			}
		}
	});
})(jQuery);