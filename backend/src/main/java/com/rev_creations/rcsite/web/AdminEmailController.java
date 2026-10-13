package com.rev_creations.rcsite.web;

import com.rev_creations.rcsite.dto.AdminEmailRequest;
import com.rev_creations.rcsite.dto.EmailMessageDto;
import com.rev_creations.rcsite.dto.PageDto;
import com.rev_creations.rcsite.service.EmailService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

/** Admin email queue (Phase 7, ADMIN role via {@code /api/admin/**}). */
@RestController
@RequestMapping("/api/admin/email")
@Validated
@Tag(name = "Admin - Email", description = "The outbound email queue (ADMIN)")
public class AdminEmailController {

    private final EmailService service;

    public AdminEmailController(EmailService service) {
        this.service = service;
    }

    @GetMapping
    @Operation(summary = "List the email queue, newest first")
    public PageDto<EmailMessageDto> list(
            @RequestParam(defaultValue = "0") @Min(0) int page,
            @RequestParam(defaultValue = "20") @Min(1) @Max(100) int size) {
        return service.list(page, size);
    }

    @PostMapping
    @Operation(summary = "Queue an email for sending")
    public EmailMessageDto enqueue(@RequestBody AdminEmailRequest request) {
        return service.enqueue(request);
    }
}
