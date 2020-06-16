package com.zxj.rule.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.zxj.rule.model.CalTask;

@Mapper
public interface RuleMapper {

	List<Map<String, Object>> queryRuleList(Map<String, Object> map);

	Map<String, Object> queryRuleById(@Param("id") String id);
	
	List<Map<String, Object>> queryRuleItemList(@Param("id") String id);

	List<Map<String, Object>> queryItemsByRuleCode(@Param("code") String code);
	
	void disableAllRule(Map<String, Object> map);
	
	void updateRuleState(Map<String, Object> map);

	List<Object> queryTest(Map<String, String> map);

	List<CalTask> queryCalculatable(Map<String, Object> map);

	Map<String, Object> queryCalculatorByCode(@Param("ruleId")String ruleId, @Param("ruleCode")String ruleCode);

	List<Map<String, Object>> queryCalculatorItemByDefId(@Param("defId")int defId, @Param("ifFirst")int ifFirst, @Param("pattern")String pattern);

	void updateCalculatorByCode(@Param("ruleCode")String ruleCode, @Param("endDate")String endDate);
}
