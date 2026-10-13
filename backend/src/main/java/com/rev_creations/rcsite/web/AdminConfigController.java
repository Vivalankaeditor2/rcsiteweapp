package com.rev_creations.rcsite.web;

import com.rev_creations.rcsite.dto.AdminConfigRequest;
import com.rev_creations.rcsite.dto.RcSiteConfigDto;
import com.rev_creations.rcsite.service.RcSiteConfigService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/** Admin config write surface (Phase 7, ADMIN role via {@code /api/admin/**}). */
@RestController
@RequestMapping("/api/admin/config")
@Tag(name = "Admin - Config", description = "Update site settings (ADMIN)")
public class AdminConfigController {

    private final RcSiteConfigService service;

    public AdminConfigController(RcSiteConfigService service) {
        this.service = service;
    }

    @PutMapping("/{configKey}")
    @Operation(summary = "Update a site setting (evicts the config cache)")
    public RcSiteConfigDto update(@PathVariable String configKey,
            @Valid @RequestBody AdminConfigRequest request) {
        return service.update(configKey, request);
    }
}
