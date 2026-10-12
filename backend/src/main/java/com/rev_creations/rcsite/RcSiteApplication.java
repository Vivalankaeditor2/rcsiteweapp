package com.rev_creations.rcsite;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.cache.annotation.EnableCaching;

/**
 * Entry point for the VivaLanka.com revamp API.
 *
 * <p>Packaged as a WAR and deployed to WildFly 27 (Jakarta EE 10) with a
 * WildFly-managed JNDI datasource (D-017). Extending {@link SpringBootServletInitializer}
 * lets the container bootstrap the application context; the embedded
 * {@code main} is used only for local/dev runs.
 */
@SpringBootApplication
@EnableCaching
public class RcSiteApplication extends SpringBootServletInitializer {
    public static void main(String[] args) {
        SpringApplication.run(RcSiteApplication.class, args);
    }

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(RcSiteApplication.class);
    }
}
