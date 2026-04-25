package com.githubfinal;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
public class FinalApplication {
    public static void main(String[] args) {
        SpringApplication.run(FinalApplication.class, args);
    }
}

@RestController
class FinalController {
    private final JdbcTemplate jdbcTemplate;

    FinalController(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    @GetMapping("/")
    public String hello() {
        return "Hello from the Final Kubernetes Spring Boot Web App!";
    }

    @GetMapping("/db")
    public String databaseTest() {
        String result = jdbcTemplate.queryForObject("SELECT 'MySQL connection successful'", String.class);
        return result;
    }
}
