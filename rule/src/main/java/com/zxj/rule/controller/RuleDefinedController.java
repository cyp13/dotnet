package com.zxj.rule.controller;

import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.alibaba.fastjson.JSON;
import com.zxj.rule.model.Result;
import com.zxj.rule.service.IRuleDefinedService;
import com.zxj.rule.util.Utils;

/**
 * <p>
 * Title:RuleDefinedController
 * </p>
 * <p>
 * Description:
 * </p>
 * 
 * @author yuekai
 * @date 2019年4月3日
 */
@Controller
public class RuleDefinedController extends BaseController {

	private static final Logger logger = Logger
			.getLogger(RuleDefinedController.class);
	@Resource
	private IRuleDefinedService ruleDefinedService;

	/**
	 * 查询考核体系表信息
	 * 
	 * @param map
	 * @param request
	 * @param session
	 * @return
	 */
	@RequestMapping(value = "/queryRuleDefined.do")
	@ResponseBody
	public String queryRuleDefined(Map<String, Object> map,
			HttpServletRequest request) {
		Result rs = new Result();
		try {
			map = Utils.getMap(request.getParameterMap());
			rs.setData(ruleDefinedService.queryRuleDefined(map));
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
	@RequestMapping(value = "/insertRuleDefined.do", produces = "application/json;charset=UTF-8")
	@ResponseBody
	@Transactional(rollbackFor=Exception.class)
	public String insertRuleDefined(@RequestBody Map<String, Object> map,
			HttpServletRequest request, HttpSession httpSession) {
		Result rs = new Result();
		try {
			if(!map.containsKey("items")){
				throw new Exception("参数考核项items不能为空!");
			}
			ruleDefinedService.insertRuleDefined(map);
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
	 * 修改考核体系表信息（生成新版本）
	 * 
	 * @param map
	 * @param request
	 * @param session
	 * @return
	 */
	@RequestMapping(value = "/updateRuleDefined.do", produces = "application/json;charset=UTF-8")
	@ResponseBody
	@Transactional(rollbackFor=Exception.class)
	public String updateRuleDefined(@RequestBody Map<String, Object> map,
			HttpServletRequest request, HttpSession httpSession) {
		Result rs = new Result();
		try {
			ruleDefinedService.updateRuleDefined(map);
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
	@RequestMapping(value = "/updateRuleDefinedValid.do")
	@ResponseBody
	@Transactional(rollbackFor=Exception.class)
	public String updateRuleDefinedValid(Map<String, Object> map,
			HttpServletRequest request) {
		Result rs = new Result();
		try {
			map = Utils.getMap(request.getParameterMap());
			if (!map.containsKey("code")) {
				throw new Exception("缺少规则code");
			}
			if (!map.containsKey("row_valid")) {
				throw new Exception("缺少row_valid");
			}
			ruleDefinedService.updateRuleDefinedValid(map);
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
	@RequestMapping(value = "/deleteRuleDefined.do")
	@ResponseBody
	@Transactional(rollbackFor=Exception.class)
	public String deleteRuleDefined(Map<String, Object> map,
			HttpServletRequest request) {
		Result rs = new Result();
		try {
			String id = request.getParameter("id");
			ruleDefinedService.deleteRuleDefined(id);
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
