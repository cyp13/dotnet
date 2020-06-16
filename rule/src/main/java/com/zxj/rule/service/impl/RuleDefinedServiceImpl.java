package com.zxj.rule.service.impl;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.zxj.rule.dao.RuleDefinedMapper;
import com.zxj.rule.dao.RuleItemMapper;
import com.zxj.rule.service.IRuleDefinedService;

/**
 * @author 岳开
 * @date 2019年4月8日
 */
@Service("ruleDefinedService")
public class RuleDefinedServiceImpl implements IRuleDefinedService {

	@Resource
	private RuleDefinedMapper ruleDefinedMapper;
	@Resource
	private RuleItemMapper ruleItemMapper;

	/**
	 * 查询规则定义
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map> queryRuleDefined(Map map) throws Exception {
		try {
			List<Map> list = ruleDefinedMapper.queryRuleDefined(map);
			Map para = new HashMap<>();
			// 查询考核项详情，添加到考核定义返回数据中
			for (Map m : list) {
				para.put("rule_defined_id", m.get("code"));
				m.put("items", ruleItemMapper.queryRuleItem(para));
			}
			return list;
		} catch (Throwable e) {
			throw new Exception("查询规则定义失败！", e);
		}
	}

	/**
	 * 新增规则定义
	 * 
	 * @param map
	 * @throws Exception
	 */
	@Override
	public void insertRuleDefined(Map map) throws Exception {
		try {
			map.put("userName", "admin");
			map.put("row_version", 1);// 版本号
			map.put("code", UUID.randomUUID().toString());// 生成规则code
			ruleDefinedMapper.insertRuleDefined(map);
			int rule_defined_id = 0;
			Map para = new HashMap<>();
			para.put("code", map.get("code"));
			List<Map> list = ruleDefinedMapper.queryMaxVersion(para);
			for (Map m : list) {
				rule_defined_id = (int) m.get("id");
			}
			List<Map> items = (List<Map>) map.get("items");
			// 新增考核项
			for (Map m : items) {
				if("".equals(m.get("min_value"))) {
					m.remove("min_value");
				}
				if("".equals(m.get("max_value"))) {
					m.remove("max_value");
				}
				m.put("rule_defined_id", rule_defined_id);
				ruleItemMapper.insertRuleItem(m);
			}
		} catch (Throwable e) {
			e.printStackTrace();
		}
	}

	/**
	 * 修改规则启用状态
	 * 
	 * @param map
	 * @throws Exception
	 */
	@Override
	public void updateRuleDefinedValid(Map map) throws Exception {
		try {
			map.put("userName", "admin");
			ruleDefinedMapper.updateRuleDefined(map);
		} catch (Throwable e) {
			throw new Exception("修改规则状态失败！", e);
		}
	}

	/**
	 * 修改规则定义（生成新版本）
	 * 
	 * @param map
	 * @throws Exception
	 */
	@Override
	public void updateRuleDefined(Map map) throws Exception {
		try {
			map.put("userName", "admin");
			if (!map.containsKey("row_version")) {
				throw new Exception("规则版本不能为空！");
			}
			int row_version = (int) map.get("row_version");
			if (!map.containsKey("code")) {
				throw new Exception("规则code不能为空！");
			}
			Map para = new HashMap<>();
			para.put("code", map.get("code"));
			para.put("row_valid", "0");// 表示禁用
			ruleDefinedMapper.updateRuleDefined(para);// 将其他版本禁用
			int cur_version = 1;
			List<Map> list = ruleDefinedMapper.queryMaxVersion(para);
			for (Map m : list) {
				cur_version = Integer.parseInt(m.get("row_version") + "");
			}
			if(row_version!=cur_version){
				throw new Exception("当前数据版本与数据库版本不符，请刷新后重试！");
			}
			map.put("row_version", cur_version + 1);
			ruleDefinedMapper.insertRuleDefined(map);
			//新增考核项
			int rule_defined_id = 0;
			para.clear();
			para.put("code", map.get("code"));
			List<Map> list2 = ruleDefinedMapper.queryMaxVersion(para);
			for (Map m : list2) {
				rule_defined_id = (int) m.get("id");
			}
			
			List<Map> items = (List<Map>) map.get("items");
			// 新增考核项
			for (Map m : items) {
				if("".equals(m.get("min_value"))) {
					m.remove("min_value");
				}
				if("".equals(m.get("max_value"))) {
					m.remove("max_value");
				}
				m.put("rule_defined_id", rule_defined_id);
				ruleItemMapper.insertRuleItem(m);
			}
		} catch (Throwable e) {
			e.printStackTrace();
		}
	}

	/**
	 * 删除规则定义
	 * 
	 * @param id
	 * @throws Exception
	 */
	@Override
	public void deleteRuleDefined(String id) throws Exception {
		try {
			ruleDefinedMapper.deleteRuleDefined(id);
		} catch (Throwable e) {
			throw new Exception("删除规则定义失败！", e);
		}
	}

}
