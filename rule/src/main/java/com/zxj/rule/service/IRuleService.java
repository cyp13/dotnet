package com.zxj.rule.service;

import java.util.List;
import java.util.Map;

import com.zxj.rule.model.CalTask;
import com.zxj.rule.model.CalculateItem;
import com.zxj.rule.model.Result;

public interface IRuleService {

	List<Map<String, Object>> queryRuleList(Map<String, Object> map);

	Map<String, Object> queryRuleById(String id);
	
	List<Map<String, Object>> queryRuleItemList(String id);

	List<Map<String, Object>> queryItemsByRuleCode(String code);

	void disableAllRule(Map<String, Object> map);

	void updateRuleState(Map<String, Object> map);

	/**
	 * 查询测试方法
	 * @return
	 */
	public List<Object> queryTest(Map<String, String> map);
	
	/**
	 * 查询所有需要计算的任务
	 * @param pattern 模式， 1用于计算（级查询上个周期），0用于导入，查询本周期
	 * @return
	 */
	public List<CalTask> queryCalculatable(int pattern, String orgId, String tixi, String code);
	public List<CalTask> queryCalculatableDev(int pattern, String orgId, String tixi, String code);
	
	/**
	 * 查询数据，用于考核
	 */
	public List<CalculateItem> queryDatasForCal(String ruleCode, String orgId, String startDate, String endDate, String useRange, String downPattern);
	public List<CalculateItem> queryDatasForCalDev(String ruleCode, String orgId, String startDate, String endDate, String useRange, String downPattern);
	/**
	 * 将考核完成的数据提交给存量
	 * @param result
	 */
	public void postCalResult(Result result);
	
	/**
	 * 计算分数，传入一整个机构的数据，可能计算出多条结果
	 * @param calData
	 * @return
	 * @throws Exception 
	 */
	public CalculateItem calculate(CalculateItem calData, String ruleId, String ruleCode, String lastCutDate, String currentCutDate) throws Exception;

}
