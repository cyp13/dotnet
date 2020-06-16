/**
 * 
 */
package com.zxj.rule.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;


/**
 * @author 岳开
 * @date 2019年4月8日
 */
@Mapper
public interface RuleDefinedMapper {
	/**
	 * 查询规则定义信息
	 * 
	 * @param map
	 * @return
	 */
	public List<Map> queryRuleDefined(Map map);
	
	/**
	 * 查询规则定义最新版本号
	 * 
	 * @param map
	 * @return
	 */
	public List<Map> queryMaxVersion(Map map);

	/**
	 * 新增规则定义信息
	 * 
	 * @param map
	 */
	public void insertRuleDefined(Map map);

	/**
	 * 修改规则定义信息
	 * 
	 * @param map
	 */
	public void updateRuleDefined(Map map);

	/**
	 * 删除规则定义信息
	 * 
	 * @param id
	 */
	public void deleteRuleDefined(String id);

}
