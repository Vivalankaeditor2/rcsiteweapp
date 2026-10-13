package com.rev_creations.rcsite.service;
import com.rev_creations.rcsite.dto.AdminConfigRequest;
import com.rev_creations.rcsite.dto.RcSiteConfigDto;
import com.rev_creations.rcsite.entity.RcSiteConfig;
import com.rev_creations.rcsite.exception.ResourceNotFoundException;
import com.rev_creations.rcsite.mapper.RcSiteConfigMapper;
import com.rev_creations.rcsite.repository.RcSiteConfigRepository;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

/** Reads site settings; every key is cached in the {@code rcsiteConfig} cache. */
@Service
public class RcSiteConfigService {
    private final RcSiteConfigRepository repository;

    private final RcSiteConfigMapper mapper;

    public RcSiteConfigService(RcSiteConfigRepository repository, RcSiteConfigMapper mapper) {
        this.repository = repository;
        this.mapper = mapper;
    }

    @Transactional(readOnly = true)
    @Cacheable("rcsiteConfig")
    public List<RcSiteConfigDto> listAll() {
        return repository.findAll().stream().map(mapper::toDto).toList();
    }

    @Transactional(readOnly = true)
    @Cacheable(value = "rcsiteConfig", key = "#configKey")
    public Optional<String> getValue(String configKey) {
        return repository.findById(configKey).map(c -> c.getValue());
    }

    /**
     * Update a setting (admin, Phase 7). The whole cache is evicted because the
     * cached {@code listAll()} entry is keyed differently from a single key; the
     * cache is tiny (a few settings), so a full eviction is the safe choice.
     */
    @Transactional
    @CacheEvict(value = "rcsiteConfig", allEntries = true)
    public RcSiteConfigDto update(String configKey, AdminConfigRequest request) {
        RcSiteConfig config = repository.findById(configKey)
                .orElseThrow(() -> new ResourceNotFoundException("No config key " + configKey));
        config.setValue(request.value());
        if (request.description() != null) {
            config.setDescription(request.description());
        }
        if (request.siteArea() != null) {
            config.setSiteArea(request.siteArea());
        }
        if (request.active() != null) {
            config.setActive(request.active());
        }
        return mapper.toDto(repository.save(config));
    }
}
