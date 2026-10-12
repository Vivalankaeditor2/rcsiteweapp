package com.rev_creations.rcsite.entity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

/**
 * One site setting. Drives every {@code Config.getValue(...)} key in the legacy
 * app. Cached in memory (see {@code rcsiteConfig} cache).
 */
@Entity
@Table(name = "rcsite_config")
@Getter
@Setter
public class RcSiteConfig {
    @Id
    @Column(name = "config_key")
    private String configKey;

    @Column(name = "value")
    private String value;

    @Column(name = "description")
    private String description;

    @Column(name = "site_area")
    private String siteArea;

    @Column(name = "active")
    private Integer active;

    @Column(name = "hot_configurable")
    private Integer hotConfigurable;
}
