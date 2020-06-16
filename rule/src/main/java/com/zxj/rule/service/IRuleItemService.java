/**
 * 
 */
package com.zxj.rule.service;

import java.util.List;
import java.util.Map;

/**
 * @author 岳开
 * @date 2019年4月8日
 */
public interface IRuleItemService {

	/**
	 * 查询考核项信息
	 * 
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public List<Map> queryRuleItem(Map map) throws Exception;

	/**
	 * 新增考核项信息
	 * 
	 * @param map
	 * @throws Exception
	 */
	public void insertRuleItem(Map map) throws Exception;

	/**
	 * 修改考核项信息
	 * 
	 * @param map
	 * @throws Exception
	 */
	public void updateRuleItem(Map map) throws Exception;

	/**
	 * 删除考核项信息
	 * 
	 * @param id
	 * @throws Exception
	 */
	public void deleteRuleItem(String id) throws Exception;

}
