package com.rev_creations.rcsite.config;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class OpenApiConfig {
    @Bean
    public OpenAPI rcSiteOpenApi() {
        return new OpenAPI().info(new Info()
                .title("VivaLanka.com API")
                .description("Read API over the existing VivaLanka database (schema frozen).")
                .version("v1"));
    }
}
