package com.zxj.rule.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.zxj.rule.model.Result;
import com.zxj.rule.service.IRuleGroupService;
import com.zxj.rule.util.Utils;

/**
 * <p>
 * Title:RuleGroupController
 * </p>
 * <p>
 * Description:
 * </p>
 * 
 * @author yuekai
 * @date 2019年4月3日
 */
@Controller
public class RuleGroupController extends BaseController {

	private static final Logger logger = Logger
			.getLogger(RuleGroupController.class);
	@Resource
	private IRuleGroupService ruleGroupService;

	/**
	 * 查询考核体系表信息
	 * 
	 * @param map
	 * @param request
	 * @param session
	 * @return
	 */
	@RequestMapping(value = "/queryRuleGroup.do")
	@ResponseBody
	public String queryRuleGroup(Map<String, Object> map,
			HttpServletRequest request) {
		Result rs = new Result();
		try {
			map = Utils.getMap(request.getParameterMap());
			rs.setData(ruleGroupService.queryRuleGroup(map));
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			rs.setCode("fail");
			rs.setMessage(e.getMessage());
		}
		return JSON.toJSONString(rs);

	}

	/**
	 * 添加考核体系表信息
	 * 
	 * @param map
	 * @param request
	 * @param session
	 * @return
	 */
	@RequestMapping(value = "/insertRuleGroup.do")
	@ResponseBody
	@Transactional(rollbackFor=Exception.class)
	public String insertRuleGroup(Map<String, Object> map,
			HttpServletRequest request, HttpSession httpSession) {
		Result rs = new Result();
		try {
			map = Utils.getMap(request.getParameterMap());
			ruleGroupService.insertRuleGroup(map);
			rs.setData(map);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			rs.setCode("fail");
			rs.setMessage(e.getMessage());
		}
		return JSON.toJSONString(rs);
	}

	/**
	 * 修改考核体系表信息
	 * 
	 * @param map
	 * @param request
	 * @param session
	 * @return
	 */
	@RequestMapping(value = "/updateRuleGroup.do")
	@ResponseBody
	@Transactional(rollbackFor=Exception.class)
	public String updateRuleGroup(Map<String, Object> map,
			HttpServletRequest request) {
		Result rs = new Result();
		try {
			map = Utils.getMap(request.getParameterMap());
			if (!map.containsKey("id")) {
				throw new Exception("缺少考核体系id");
			}
			ruleGroupService.updateRuleGroup(map);
			rs.setData(map);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			rs.setCode("fail");
			rs.setMessage(e.getMessage());
		}
		return JSON.toJSONString(rs);
	}

	/**
	 * 删除考核体系表信息
	 * 
	 * @param map
	 * @param request
	 * @param session
	 * @return
	 */
	@RequestMapping(value = "/deleteRuleGroup.do")
	@ResponseBody
	@Transactional(rollbackFor=Exception.class)
	public String deleteRuleGroup(Map<String, Object> map,
			HttpServletRequest request) {
		Result rs = new Result();
		try {
			String id = request.getParameter("id");
			ruleGroupService.deleteRuleGroup(id);
			rs.setData(id);
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			rs.setCode("fail");
			rs.setMessage(e.getMessage());
		}
		return JSON.toJSONString(rs);
	}

}
