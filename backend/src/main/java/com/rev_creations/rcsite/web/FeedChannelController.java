package com.rev_creations.rcsite.web;
import com.rev_creations.rcsite.dto.FeedChannelDto;
import com.rev_creations.rcsite.dto.FeedChannelLogDto;
import com.rev_creations.rcsite.dto.FeedPollResultDto;
import com.rev_creations.rcsite.service.FeedChannelService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;

@RestController
@RequestMapping("/api/feeds")
@Tag(name = "Feeds", description = "Read access to the feed_channel table")
public class FeedChannelController {
    private final FeedChannelService service;

    public FeedChannelController(FeedChannelService service) {
        this.service = service;
    }

    @GetMapping
    @Operation(summary = "List all feed channels")
    public List<FeedChannelDto> listAll() {
        return service.listAll();
    }

    @GetMapping("/{channelId}/log")
    @Operation(summary = "Newest-first poll log for one channel")
    public List<FeedChannelLogDto> log(@PathVariable Long channelId) {
        return service.listLog(channelId);
    }

    @PostMapping("/{channelId}/poll")
    @Operation(summary = "Poll one channel now (admin trigger; writes the feed_* tables)")
    public FeedPollResultDto pollNow(@PathVariable Long channelId) {
        return service.pollNow(channelId);
    }
}
