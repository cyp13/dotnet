package com.zxj.rule.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.zxj.rule.model.CalTask;
import com.zxj.rule.model.CalculateItem;
import com.zxj.rule.model.Result;
import com.zxj.rule.service.IRuleService;
import com.zxj.rule.util.DateUtil;

@Controller
public class RuleController {

	@Autowired
	private IRuleService ruleService;

	@RequestMapping("/index")
	public String index() {
		return "/rule/index";
	}

	/**
	 * @Title: queryRuleList
	 * @Description: 根据组织Id查询该组织下的所有规则
	 * @param map
	 * @param model
	 * @return Result
	 */
	@RequestMapping("/queryRuleList")
	@ResponseBody
	public Result queryRuleList(@RequestParam Map<String, Object> map, Model model) {
		try {
			return new Result(ruleService.queryRuleList(map));
		} catch (Exception e) {
			e.printStackTrace();
			return new Result("fail", e.getMessage());
		}
	}

	/**
	 * @Title: details
	 * @Description: 规则详情页面
	 * @param id
	 * @param orgId
	 * @param model
	 * @return String
	 */
	@RequestMapping("/details")
	public String details(String id, String orgId, Model model) {
		if (StringUtils.isNotEmpty(id)) {
			// 修改操作，查询数据进行回显
			model.addAttribute("id", id);
			model.addAttribute("ruleInfo", ruleService.queryRuleById(id));
			model.addAttribute("ruleItems", ruleService.queryRuleItemList(id));
		}
		model.addAttribute("orgId", orgId);
		return "/rule/details";
	}

	/**
	 * @Title: updateRuleState
	 * @Description: 启用/停用/删除选中规则
	 * @param id：规则ID
	 * @return Result
	 */
	@RequestMapping("/updateRuleState")
	@ResponseBody
	public Result updateRuleState(@RequestParam Map<String, Object> map) {
		try {
			ruleService.updateRuleState(map);
			return new Result();
		} catch (Exception e) {
			e.printStackTrace();
			return new Result("fail", e.getMessage());
		}
	}

	/**
	 * @Title: queryItemsByRuleCode
	 * @Description: 移动端根据RuleCode获取规则详情
	 * @param id：规则ID
	 * @return Result
	 */
	@CrossOrigin(origins = "*")
	@RequestMapping("/queryItemsByRuleCode")
	@ResponseBody
	public Result queryItemsByRuleCode(@RequestParam String code) {
		try {
			return new Result(ruleService.queryItemsByRuleCode(code));
		} catch (Exception e) {
			e.printStackTrace();
			return new Result("fail", e.getMessage());
		}
	}
	
	@RequestMapping("/queryCalculatable")
	@ResponseBody
	public Result queryCalculatable(String orgId, String tixi, String code){
		Result result = new Result();
		List<CalTask> tasks = ruleService.queryCalculatable(0, orgId, tixi, code);
		result.setData(tasks);
		return result;
	}
	private static Logger log = Logger.getRootLogger();
	/**
	 * 循环调用所有需要计算的积分
	 * @return
	 * @throws Exception 
	 */
	@RequestMapping("/cycleJob")
	@ResponseBody
	@Scheduled(cron = "0 0 1 1/1 * ?")//每日1点扫描可计算的数据
	public Result cycle() throws Exception{
		Result result = cycleReal("release");
		return result;
	}
	@RequestMapping("/cycle")
	@ResponseBody
	private Result cycleReal(String mode) throws Exception{
		Result result = new Result();
		List<CalculateItem> resultList = new ArrayList<>();
		result.setData(resultList);
		//1.查询所有需要计算的任务
		List<CalTask> tasks = null;
		if("release".equals(mode)) {//真数据
			tasks = ruleService.queryCalculatable(1, null, null, null);
		}else if("test".equals(mode) || "dev".equals(mode)) {
			tasks = ruleService.queryCalculatableDev(1, null, null, null);
		}else {
			result.setMessage("未知的mode：" + mode);
			return result;
		}
		if(tasks==null || tasks.size()<=0) {
			result.setMessage("无可计算规则");
			return result;
		}
		//2.计算所有任务
		List<CalculateItem> r;
		for(CalTask task : tasks) {
			if("dev".equals(mode)) {//假数据
				r = calculateDev(task);
			}else if("release".equals(mode) || "test".equals(mode)){
				r = calculate(task);
			}else {
				break;
			}
			if(r!=null && r.size()>0) {
				resultList.addAll(r);
			}
		}
		//3.将结果提交给存量
		log.info(" 已计算：" + resultList.size());
		if(resultList.size()>0) {
			ruleService.postCalResult(result);
		}
		return result;
	}
	
	private List<CalculateItem> calculate(CalTask task) throws Exception{
		List<CalculateItem> calDatas = ruleService.queryDatasForCal(task.getRuleCode(), task.getOrgId(), task.getStartDate(), task.getEndDate(), task.getUseRange(), task.getDownPattern());
		if(calDatas==null||calDatas.size()<=0) {
			return calDatas;
		}
		for(CalculateItem calData : calDatas) {
			task.setData(calData);
			ruleService.calculate(calData, null, task.getRuleCode(), task.getLastRunTime(), task.getEndDate());//分别计算，并返回结果
		}
		return calDatas;
	}
	private List<CalculateItem> calculateDev(CalTask task) throws Exception{
		List<CalculateItem> calDatas = ruleService.queryDatasForCalDev(task.getRuleCode(), task.getOrgId(), task.getStartDate(), task.getEndDate(), task.getUseRange(), task.getDownPattern());
		if(calDatas==null||calDatas.size()<=0) {
			return calDatas;
		}
		for(CalculateItem calData : calDatas) {
			task.setData(calData);
			ruleService.calculate(calData, null, task.getRuleCode(), task.getLastRunTime(), task.getEndDate());//分别计算，并返回结果
		}
		return calDatas;
	}
	
	/**
	 * 计算
	 * @return
	 */
	@RequestMapping("/calculateForDatas")
	@ResponseBody
	public Result calculateForDatas(String ruleId,String ruleCode, Integer ifFirst, String dataStr){
		try {
			Result result = new Result();
			List<CalculateItem> resultList = new ArrayList<>();
			result.setData(resultList);
			String ifFirstDate = null;
			if(ifFirst==null || 1!=ifFirst) {//如果不是首次
				ifFirstDate = DateUtil.format(new Date());
			}
			JSONArray jsonarray = JSONArray.parseArray(dataStr);
			CalculateItem ci;
			JSONObject json;
			for(int i=0; i<jsonarray.size(); i++) {
				json = jsonarray.getJSONObject(i);
				ci = new CalculateItem();
				resultList.add(ci);
				ci.setCycleType(json.getString("cycleType"));
				ci.setCycleValue(json.getString("cycleValue"));
				ci.setOrgId(json.getString("orgId"));
				ci.setUserName(json.getString("userName"));
				ci.setOver_count(json.getInteger("over_count"));
				ci.setTotal_count(json.getInteger("total_count"));
				ci.setNoover_count(json.getInteger("noover_count"));
				ci.setNopass_count(json.getInteger("nopass_count"));
			}
			if(resultList==null||resultList.size()<=0) {
				return result;
			}
			for(CalculateItem calData : resultList) {
				ruleService.calculate(calData, ruleId, ruleCode, ifFirstDate, null);
			}
			return result;
		} catch (Exception e) {
			e.printStackTrace();
			return new Result("fail", e.getLocalizedMessage());
		}
	}
}
