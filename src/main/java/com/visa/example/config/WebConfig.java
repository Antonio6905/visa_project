package com.visa.example.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;

@Configuration
public class WebConfig implements WebMvcConfigurer {

        @Value("${app.image.dir:demande-search/image}")
        private String imageDir;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        // Configuration pour les WebJars (Bootstrap, jQuery, etc.)
        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/")
                .setCachePeriod(31536000); // 1 an en secondes

        // Configuration pour les ressources statiques personnalisées
        registry.addResourceHandler("/css/**")
                .addResourceLocations("classpath:/static/css/")
                .setCachePeriod(31536000);

        registry.addResourceHandler("/static/js/**")
                .addResourceLocations("classpath:/static/js/")
                .setCachePeriod(31536000);

        registry.addResourceHandler("/images/**")
                .addResourceLocations("classpath:/static/images/")
                .setCachePeriod(31536000);

        registry.addResourceHandler("/fonts/**")
                .addResourceLocations("classpath:/static/fonts/")
                .setCachePeriod(31536000);

        Path imagePath = Paths.get(imageDir).toAbsolutePath().normalize();
        registry.addResourceHandler("/demande-search/image/**")
                .addResourceLocations(imagePath.toUri().toString())
                .setCachePeriod(31536000);
    }

    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        // Page d'accueil par défaut
        registry.addViewController("/").setViewName("redirect:/accueil");
        registry.addViewController("/accueil").setViewName("accueil");
        registry.addViewController("/login").setViewName("login");
        registry.addViewController("/admin").setViewName("admin/dashboard");
                registry.addViewController("/visa-transformable/form").setViewName("visa-transformable-form");
    }
}