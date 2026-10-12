package com.rev_creations.rcsite.web;
import com.rev_creations.rcsite.dto.RcSiteConfigDto;
import com.rev_creations.rcsite.exception.ResourceNotFoundException;
import com.rev_creations.rcsite.service.RcSiteConfigService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@RestController
@RequestMapping("/api/config")
@Tag(name = "Config", description = "Read access to the rcsite_config table (cached)")
public class RcSiteConfigController {
    private final RcSiteConfigService service;

    public RcSiteConfigController(RcSiteConfigService service) {
        this.service = service;
    }

    @GetMapping
    @Operation(summary = "List all site settings")
    public List<RcSiteConfigDto> listAll() {
        return service.listAll();
    }

    @GetMapping("/{configKey}")
    @Operation(summary = "Get a single setting's value")
    public String getValue(@PathVariable String configKey) {
        return service.getValue(configKey)
                .orElseThrow(() -> new ResourceNotFoundException("No config key " + configKey));
    }
}
