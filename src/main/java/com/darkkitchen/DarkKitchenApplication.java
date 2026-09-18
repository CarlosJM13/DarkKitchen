package com.darkkitchen;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class DarkKitchenApplication {
    public static void main(String[] args) {
        SpringApplication.run(DarkKitchenApplication.class, args);
        System.out.println("¡Aplicación Web iniciada! Ve a http://localhost:8080 en tu navegador.");
    }
}