package com.zxj.rule.service.impl;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections4.MapUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.github.pagehelper.PageHelper;
import com.zxj.rule.dao.RuleMapper;
import com.zxj.rule.model.CalTask;
import com.zxj.rule.model.CalculateItem;
import com.zxj.rule.model.Result;
import com.zxj.rule.service.IHttpService;
import com.zxj.rule.service.IRuleService;
import com.zxj.rule.util.DateUtil;
import com.zxj.rule.util.RuleConfig;

@Service
public class RuleService implements IRuleService {

	@Autowired
	private RuleMapper mapper;
	@Autowired
	private IHttpService httpService;
	@Autowired
	private RuleConfig ruleConfig;


	@Override
	public List<Map<String, Object>> queryRuleList(Map<String, Object> map) {
		return mapper.queryRuleList(map);
	}

	@Override
	public Map<String, Object> queryRuleById(String id) {
		return mapper.queryRuleById(id);
	}

	@Override
	public List<Map<String, Object>> queryRuleItemList(String id) {
		return mapper.queryRuleItemList(id);
	}
	
	@Override
	public List<Map<String, Object>> queryItemsByRuleCode(String code) {
		return mapper.queryItemsByRuleCode(code);
	}
	
	@Override
	@Transactional(rollbackFor = RuntimeException.class)
	public void disableAllRule(Map<String, Object> map) {
		mapper.disableAllRule(map);
	}
	
	@Override
	@Transactional(rollbackFor = RuntimeException.class)
	public void updateRuleState(Map<String, Object> map) {
		/**
		 * 启用一个规则的版本之前先停用此规则的其他版本
		 */
		if (MapUtils.getInteger(map, "rowValid") == 1) {
			disableAllRule(map);
		}
		mapper.updateRuleState(map);
	}
	
	@Override
	public List<Object> queryTest(Map<String, String> map) {
		int pageNum = 1;
		int pageSize = 10;
		PageHelper.startPage(pageNum, pageSize);
		return mapper.queryTest(map);
	}
	
	/**
	 * 查询上级orgId
	 * @param orgId
	 * @param sysId
	 */
	private String getUpOrgIds(String orgId) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("token", ruleConfig.getToken());
		param.put("sysId", ruleConfig.getSysId());
		param.put("orgId", orgId);
		param.put("method", "up");
		String url = ruleConfig.getPortal() + "/api/sys/getOrgContext.do";
		Map<String, Object> data = httpService.post(url, param);
		return (String) data.get("data");
	}
	
	@Override
	public List<CalTask> queryCalculatable(int pattern, String orgId, String tixi, String code) {
		Map<String, Object> param = new HashMap<>();
		param.put("orgId", orgId);
		param.put("tixi", tixi);
		param.put("code", code);
		//param.put("orgContext", getUpOrgIds(orgId));
		List<CalTask> list = mapper.queryCalculatable(param);//查询所有可执行的任务
		List<CalTask> result = new ArrayList<>();
		Date[] dateArea = new Date[2];
		for(CalTask ctask : list) {
			if(1==pattern) {//用于计算
				if("1".equals(ctask.getTimeAreaType())) {//年
					dateArea = DateUtil.getLastWholeArea(DateUtil.YEAR);//获取最近的完整时间段
				}else if("2".equals(ctask.getTimeAreaType())) {//半年
					dateArea = DateUtil.getLastWholeArea(DateUtil.HALFYEAR);//获取最近的完整时间段
				}else if("3".equals(ctask.getTimeAreaType())) {//季度
					dateArea = DateUtil.getLastWholeArea(DateUtil.QUARTER);//获取最近的完整时间段
				}else if("4".equals(ctask.getTimeAreaType())) {//月
					dateArea = DateUtil.getLastWholeArea(DateUtil.MONTH);//获取最近的完整时间段
				}else {
					continue;
				}
				if(ctask.getLastRunTime()!=null && DateUtil.parse(ctask.getLastRunTime()).compareTo(dateArea[1])>=0) {//计算截至日期大于等于上个周期，则表示上个周期已计算过
					continue;
				}
				ctask.setStartDate(DateUtil.format(dateArea[0]));
				ctask.setEndDate(DateUtil.format(dateArea[1]));
				ctask.setTimeAreaName(DateUtil.getAreaName(dateArea, Integer.valueOf(ctask.getTimeAreaType())-1));
				Date countDate = DateUtil.add(DateUtil.parse(ctask.getEndDate()), 5, Calendar.DATE);//周期结束+5天，则为计算时间
				if(countDate.compareTo(new Date())>0) {//计算时间大于当前时间，即还不到计算时间，则跳过计算
					continue;
				}
			}else {
				if("1".equals(ctask.getTimeAreaType())) {//年
					dateArea = DateUtil.getCurrentWholeArea(DateUtil.YEAR);//获取当前时间段
				}else if("2".equals(ctask.getTimeAreaType())) {//半年
					dateArea = DateUtil.getCurrentWholeArea(DateUtil.HALFYEAR);//获取当前时间段
				}else if("3".equals(ctask.getTimeAreaType())) {//季度
					dateArea = DateUtil.getCurrentWholeArea(DateUtil.QUARTER);//获取当前时间段
				}else if("4".equals(ctask.getTimeAreaType())) {//月
					dateArea = DateUtil.getCurrentWholeArea(DateUtil.MONTH);//获取当前时间段
				}else {
					continue;
				}
				ctask.setStartDate(DateUtil.format(dateArea[0]));
				ctask.setEndDate(DateUtil.format(dateArea[1]));
				ctask.setTimeAreaName(DateUtil.getAreaName(dateArea, Integer.valueOf(ctask.getTimeAreaType())-1));
			}
			result.add(ctask);
		}
		return result;
	}
	
	@Override
	public List<CalTask> queryCalculatableDev(int pattern, String orgId, String tixi, String code) {
		Map<String, Object> param = new HashMap<>();
		param.put("orgId", orgId);
		param.put("tixi", tixi);
		param.put("code", code);
		//param.put("orgContext", getUpOrgIds(orgId));
		List<CalTask> list = mapper.queryCalculatable(param);//查询所有可执行的任务
		List<CalTask> result = new ArrayList<>();
		Date[] dateArea = new Date[2];
		for(CalTask ctask : list) {
			if("1".equals(ctask.getTimeAreaType())) {//年
				dateArea = DateUtil.getCurrentWholeArea(DateUtil.YEAR);//获取当前时间段
			}else if("2".equals(ctask.getTimeAreaType())) {//半年
				dateArea = DateUtil.getCurrentWholeArea(DateUtil.HALFYEAR);//获取当前时间段
			}else if("3".equals(ctask.getTimeAreaType())) {//季度
				dateArea = DateUtil.getCurrentWholeArea(DateUtil.QUARTER);//获取当前时间段
			}else if("4".equals(ctask.getTimeAreaType())) {//月
				dateArea = DateUtil.getCurrentWholeArea(DateUtil.MONTH);//获取当前时间段
			}else {
				continue;
			}
			ctask.setStartDate(DateUtil.format(dateArea[0]));
			ctask.setEndDate(DateUtil.format(dateArea[1]));
			ctask.setTimeAreaName(DateUtil.getAreaName(dateArea, Integer.valueOf(ctask.getTimeAreaType())-1));
			result.add(ctask);
		}
		return result;
	}
	
	//http
	@Override
	public List<CalculateItem> queryDatasForCal(String ruleCode, String orgId, String startDate, String endDate, String useRange, String downPattern) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("ruleCode", ruleCode);
		param.put("orgId", orgId);
		param.put("useRange", useRange);
		param.put("downPattern", downPattern);
		param.put("startDate", startDate);
		param.put("endDate", endDate);
		String url = ruleConfig.getCl() + ruleConfig.getGetData();
		Map<String, Object> data = httpService.get(url, param);
		List<Map<String, Object>> datas = (List<Map<String, Object>>) data.get("data");
		if(datas==null||datas.size()<=0) {
			return null;
		}
		List<CalculateItem> list = new ArrayList<>();
		CalculateItem cdatai;
		for(Map<String, Object> map : datas) {
			cdatai = new CalculateItem();
			cdatai.setOrgId((String) map.get("orgId"));
			if(map.get("userName")!=null) {//存量如果username为空会报错，兼容处理
				cdatai.setUserName((String) map.get("userName"));
			}else {
				cdatai.setUserName("");
			}
			cdatai.setTotal_count((Integer) map.get("total_count"));
			cdatai.setOver_count((Integer) map.get("over_count"));
			cdatai.setNoover_count((Integer) map.get("noover_count"));
			cdatai.setNopass_count((Integer) map.get("nopass_count"));
			list.add(cdatai);
		}
		return list;
	}
	@Override
	public List<CalculateItem> queryDatasForCalDev(String ruleCode, String orgId, String startDate, String endDate, String useRange, String downPattern) {
		Map<String, Object> param = new HashMap<String, Object>();
		param.put("ruleCode", ruleCode);
		param.put("orgId", orgId);
		param.put("useRange", useRange);
		param.put("downPattern", downPattern);
		param.put("startDate", startDate);
		param.put("endDate", endDate);
		List<Map<String, Object>> datas = new ArrayList<>(10);
		Map<String, Object> adata;
		for(int i=0; i<2; i++) {
			adata = new HashMap<>();
			datas.add(adata);
			adata.put("orgId", "root");
			adata.put("userName", "user_" + i);
			adata.put("total_count", (int)(Math.random()*10));
			adata.put("over_count", (int)(Math.random()*5));
			adata.put("noover_count", (int)(Math.random()*5));
			adata.put("nopass_count", (int)(Math.random()*5));
		}
		List<CalculateItem> list = new ArrayList<>();
		CalculateItem cdatai;
		for(Map<String, Object> map : datas) {
			cdatai = new CalculateItem();
			cdatai.setOrgId((String) map.get("orgId"));
			cdatai.setUserName((String) map.get("userName"));
			cdatai.setTotal_count((Integer) map.get("total_count"));
			cdatai.setOver_count((Integer) map.get("over_count"));
			cdatai.setNoover_count((Integer) map.get("noover_count"));
			cdatai.setNopass_count((Integer) map.get("nopass_count"));
			list.add(cdatai);
		}
		return list;
	}
	@Override
	public CalculateItem calculate(CalculateItem calData, String ruleId, String ruleCode, String lastCutDate, String currentCutDate) throws Exception {
		Map<String, Object> calculator = mapper.queryCalculatorByCode(ruleId, ruleCode);
		if(calculator==null) {
			throw new Exception("不存在的规则：" + ruleCode);
		}
		int ifFirst = 0;
		if(lastCutDate==null) {//最后运行时间为空，表示首次运行
			ifFirst = 1;
		}
		int au = (int) calculator.get("audit_unit");
		Double passScore = ((BigDecimal) calculator.get("pass_score")).doubleValue();//考核指标
		if(au==0) {
			Double i = calData.getOver_count() - passScore;
			if(i>=0) {//及格
				calData.setNopass_count(0);
			}else {//不及格
				calData.setNopass_count(calData.getNopass_count()+1);
			}
		}else if(au==1){
			Double passScorei = ((double) calData.getTotal_count()) * passScore/100;//总数*指标百分比=指标绝对值
			Double i = calData.getOver_count() - passScorei;
			if(i>=0) {//及格
				calData.setNopass_count(0);
			}else {//不及格
				calData.setNopass_count(calData.getNopass_count()+1);
			}
		}else {
			return null;
		}
		List<Map<String, Object>> jifenItem = mapper.queryCalculatorItemByDefId((int) calculator.get("id"), ifFirst, "考核值");
		Double min, max, score = 0D;
		Double num;
		String cValue;
		for(Map<String, Object> item : jifenItem) {//计算积分
			if(item.get("min_value")!=null) {
				min = ((BigDecimal) item.get("min_value")).doubleValue();
			}else {
				min = null;
			}
			if(item.get("max_value")!=null) {
				max = ((BigDecimal) item.get("max_value")).doubleValue();
			}else {
				max = null;
			}
			cValue = (String)item.get("calculate_value");
			if("完成数百分率".equals(cValue)) {
				num = ((double) calData.getOver_count())/calData.getTotal_count()*100;
			}else if("已执行数".equals(cValue)) {
				num = (double)(calData.getOver_count() + calData.getNoover_count());
			}else if("通过数".equals(cValue)) {
				num = (double) calData.getOver_count();
			}else if("不通过数".equals(cValue)) {
				num = (double) calData.getNoover_count();
			}else if("任务总数".equals(cValue)) {
				num = (double) calData.getTotal_count();
			}else if("连续未达标次数".equals(cValue)) {
				num = (double) calData.getNopass_count();
			}else {
				continue;
			}
			if((min==null||num>=min) && (max==null||num<max)) {//如果在区间内
				Double s = score((String) item.get("calculate_type"), calData, calculator, item);
				if(s==null) {//表示无酬金
					score = 0D;//积分清0,并退出计算
				}else{
					score = s;
				}
				break;
			}
		}
		if(calData.getTotal_count()==0) {
			calData.setCompleteProgress(100D);
		}else {
			calData.setCompleteProgress(Double.valueOf(calData.getOver_count())/calData.getTotal_count()*100);
		}
		calData.setAutoDeductionScore(score);
		Double bili = ((BigDecimal) calculator.get("convart_scale")).doubleValue();
		calData.setMoney(score * bili);
		mapper.updateCalculatorByCode(ruleCode, currentCutDate);
		return calData;
	}
	private Double score(String calculateType, CalculateItem ci, Map<String, Object> calculator, Map<String, Object> item) {
		Double bili = ((BigDecimal) item.get("integral")).doubleValue();//积分兑换比例
		Double target = ((BigDecimal) calculator.get("pass_score")).doubleValue();//考核指标
		if("1".equals(calculateType)) {
			int au = (int) calculator.get("audit_unit");
			if(au==0) {//绝对值target
				return Math.abs((target - ci.getOver_count())) * bili;//与标准差值*比例
			}else if(au==1){//百分比
				Double targeti = ((double) ci.getTotal_count()) * target/100;//总数*指标百分比=指标绝对值
				return Math.abs((targeti - ci.getOver_count())) * bili;//与标准差值*比例
			}else {
				return 0D;
			}
		}else if("2".equals(calculateType)) {//固定积分
			return bili;
		}else if("3".equals(calculateType)) {
			return null;
		}else {//
			return 0D;
		}
	}
	private Double bscore(String calculateType, CalculateItem ci, Map<String, Object> calculator, Map<String, Object> item) {
		Double bili = ((BigDecimal) item.get("integral")).doubleValue();//积分兑换比例
		return ci.getNopass_count() * bili;
	}

	//http
	@Override
	public void postCalResult(Result result) {
		String url = ruleConfig.getCl() + ruleConfig.getPushData();
		Map<String, Object> data = httpService.postJSON(url, result.getData());
		System.out.println("回传数据("+url+")：" + data);
	}
}
