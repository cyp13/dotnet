/**
 * 
 */
package com.zxj.rule.service;

import java.util.List;
import java.util.Map;

/**
 * <p>
 * Title:IRuleGroupService
 * </p>
 * <p>
 * Description:
 * </p>
 * 
 * @author yuekai
 * @date 2019年4月3日
 */
public interface IRuleGroupService {

	/**
	 * 查询考核体系信息
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<Map> queryRuleGroup(Map map) throws Exception;

	/**
	 * 新增考核体系信息
	 * 
	 * @param map
	 * @throws Exception
	 */
	public void insertRuleGroup(Map map) throws Exception;

	/**
	 * 修改考核体系信息
	 * 
	 * @param map
	 * @throws Exception
	 */
	public void updateRuleGroup(Map map) throws Exception;

	/**
	 * 删除考核体系信息
	 * 
	 * @param id
	 * @throws Exception
	 */
	public void deleteRuleGroup(String id) throws Exception;

}
