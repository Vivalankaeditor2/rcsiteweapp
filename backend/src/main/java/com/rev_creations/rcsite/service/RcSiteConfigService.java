package com.rev_creations.rcsite.service;
import com.rev_creations.rcsite.dto.RcSiteConfigDto;
import com.rev_creations.rcsite.mapper.RcSiteConfigMapper;
import com.rev_creations.rcsite.repository.RcSiteConfigRepository;
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
}
