package com.zxj.rule.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.zxj.rule.dao.RuleGroupMapper;
import com.zxj.rule.service.IRuleGroupService;

/**
 * <p>
 * Title:RuleGroupServiceImpl
 * </p>
 * <p>
 * Description:
 * </p>
 * 
 * @author yuekai
 * @date 2019年4月3日
 */
@Service("ruleGroupService")
public class RuleGroupServiceImpl implements IRuleGroupService {

	@Resource
	private RuleGroupMapper ruleGroupMapper;

	/**
	 * 查询考核体系
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map> queryRuleGroup(Map map) throws Exception {
		try {
			return ruleGroupMapper.queryRuleGroup(map);
		} catch (Throwable e) {
			throw new Exception("查询考核体系失败！", e);
		}
	}

	/**
	 * 新增考核体系
	 * 
	 * @param map
	 * @throws Exception
	 */
	@Override
	public void insertRuleGroup(Map map) throws Exception {
		try {
			map.put("userName", "admin");
			ruleGroupMapper.insertRuleGroup(map);
		} catch (Throwable e) {
			throw new Exception("添加考核体系失败！" + e.getMessage(), e);
		}
	}

	/**
	 * 修改考核体系
	 * 
	 * @param map
	 * @throws Exception
	 */
	@Override
	public void updateRuleGroup(Map map) throws Exception {
		try {
			map.put("userName", "admin");
			ruleGroupMapper.updateRuleGroup(map);
		} catch (Throwable e) {
			throw new Exception("修改考核体系失败！", e);
		}
	}

	/**
	 * 删除考核体系
	 * 
	 * @param id
	 * @throws Exception
	 */
	@Override
	public void deleteRuleGroup(String id) throws Exception {
		try {
			ruleGroupMapper.deleteRuleGroup(id);
		} catch (Throwable e) {
			throw new Exception("删除考核体系失败！", e);
		}
	}

}
