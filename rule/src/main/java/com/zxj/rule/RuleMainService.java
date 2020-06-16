package com.zxj.rule;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class RuleMainService {
	public static void main(String[] args) {
		SpringApplication.run(RuleMainService.class, args);
	}

}


//    this is a test