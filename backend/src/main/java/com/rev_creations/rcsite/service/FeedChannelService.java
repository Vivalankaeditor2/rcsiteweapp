package com.rev_creations.rcsite.service;
import com.rev_creations.rcsite.dto.FeedChannelDto;
import com.rev_creations.rcsite.dto.FeedChannelLogDto;
import com.rev_creations.rcsite.dto.FeedPollResultDto;
import com.rev_creations.rcsite.exception.ResourceNotFoundException;
import com.rev_creations.rcsite.mapper.FeedChannelLogMapper;
import com.rev_creations.rcsite.mapper.FeedChannelMapper;
import com.rev_creations.rcsite.repository.FeedChannelLogRepository;
import com.rev_creations.rcsite.repository.FeedChannelRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class FeedChannelService {
    private final FeedChannelRepository repository;

    private final FeedChannelMapper mapper;

    private final FeedChannelLogRepository logRepository;

    private final FeedChannelLogMapper logMapper;

    private final FeedPollService pollService;

    public FeedChannelService(FeedChannelRepository repository, FeedChannelMapper mapper,
            FeedChannelLogRepository logRepository, FeedChannelLogMapper logMapper,
            FeedPollService pollService) {
        this.repository = repository;
        this.mapper = mapper;
        this.logRepository = logRepository;
        this.logMapper = logMapper;
        this.pollService = pollService;
    }

    @Transactional(readOnly = true)
    public List<FeedChannelDto> listAll() {
        return repository.findAll().stream().map(mapper::toDto).toList();
    }

    @Transactional(readOnly = true)
    public List<FeedChannelLogDto> listLog(Long channelId) {
        if (!repository.existsById(channelId)) {
            throw new ResourceNotFoundException("No feed channel with id " + channelId);
        }
        return logRepository.findByChannelIdOrderByLogTimeDesc(channelId)
                .stream().map(logMapper::toDto).toList();
    }

    /**
     * Poll one channel now (the scheduled sweep does the same on a timer). This
     * is an admin action: it writes to the {@code feed_*} tables, which the site
     * does not otherwise mutate (D-004/D-008).
     */
    public FeedPollResultDto pollNow(Long channelId) {
        FeedPollService.PollResult result = pollService.pollChannel(channelId);
        return new FeedPollResultDto(result.ok(), result.fetched(), result.stored(), result.message());
    }
}
