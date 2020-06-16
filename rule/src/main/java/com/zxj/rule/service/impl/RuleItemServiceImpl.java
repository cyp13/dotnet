package com.zxj.rule.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.zxj.rule.dao.RuleItemMapper;
import com.zxj.rule.service.IRuleItemService;


/**
 * @author 岳开
 * @date 2019年4月8日
 */
@Service("ruleItemService")
public class RuleItemServiceImpl implements IRuleItemService {

	@Resource
	private RuleItemMapper ruleItemMapper;

	/**
	 * 查询考核项
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	@Override
	public List<Map> queryRuleItem(Map map) throws Exception {
		try {
			return ruleItemMapper.queryRuleItem(map);
		} catch (Throwable e) {
			throw new Exception("查询考核项失败！", e);
		}
	}

	/**
	 * 新增考核项
	 * 
	 * @param map
	 * @throws Exception
	 */
	@Override
	public void insertRuleItem(Map map) throws Exception {
		try {
			ruleItemMapper.insertRuleItem(map);
		} catch (Throwable e) {
			throw new Exception("添加考核项失败！" + e.getMessage(), e);
		}
	}

	/**
	 * 修改考核项
	 * 
	 * @param map
	 * @throws Exception
	 */
	@Override
	public void updateRuleItem(Map map) throws Exception {
		try {
			ruleItemMapper.updateRuleItem(map);
		} catch (Throwable e) {
			throw new Exception("修改考核项失败！", e);
		}
	}

	/**
	 * 删除考核项
	 * 
	 * @param id
	 * @throws Exception
	 */
	@Override
	public void deleteRuleItem(String id) throws Exception {
		try {
			ruleItemMapper.deleteRuleItem(id);
		} catch (Throwable e) {
			throw new Exception("删除考核项失败！", e);
		}
	}

}
