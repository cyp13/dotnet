/**
 * 
 */
package com.zxj.rule.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

/**
 * <p>
 * Title:RuleGroupMapper
 * </p>
 * <p>
 * Description:
 * </p>
 * 
 * @author yuekai
 * @date 2019年4月3日
 */
@Mapper
public interface RuleGroupMapper {
	/**
	 * 查询考核体系信息
	 * 
	 * @param map
	 * @return
	 */
	public List<Map> queryRuleGroup(Map map);

	/**
	 * 新增考核体系信息
	 * 
	 * @param map
	 */
	public void insertRuleGroup(Map map);

	/**
	 * 修改考核体系信息
	 * 
	 * @param map
	 */
	public void updateRuleGroup(Map map);

	/**
	 * 删除考核体系信息
	 * 
	 * @param id
	 */
	public void deleteRuleGroup(String id);

}
