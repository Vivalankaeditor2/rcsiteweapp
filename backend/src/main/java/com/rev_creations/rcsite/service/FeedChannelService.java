package com.rev_creations.rcsite.service;
import com.rev_creations.rcsite.dto.FeedChannelDto;
import com.rev_creations.rcsite.mapper.FeedChannelMapper;
import com.rev_creations.rcsite.repository.FeedChannelRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class FeedChannelService {
    private final FeedChannelRepository repository;

    private final FeedChannelMapper mapper;

    public FeedChannelService(FeedChannelRepository repository, FeedChannelMapper mapper) {
        this.repository = repository;
        this.mapper = mapper;
    }

    @Transactional(readOnly = true)
    public List<FeedChannelDto> listAll() {
        return repository.findAll().stream().map(mapper::toDto).toList();
    }
}
