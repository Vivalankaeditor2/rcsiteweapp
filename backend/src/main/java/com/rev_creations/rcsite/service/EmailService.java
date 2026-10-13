package com.rev_creations.rcsite.service;

import com.rev_creations.rcsite.dto.AdminEmailRequest;
import com.rev_creations.rcsite.dto.EmailMessageDto;
import com.rev_creations.rcsite.dto.PageDto;
import com.rev_creations.rcsite.entity.EmailMessage;
import com.rev_creations.rcsite.mapper.EmailMessageMapper;
import com.rev_creations.rcsite.repository.EmailMessageRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

/**
 * The outbound email queue (read + enqueue) for the admin screens (Phase 7).
 * Delivery itself is Phase 6 mail work; here an item is only staged in the
 * {@code email} table, matching the legacy {@code emailcompose} action.
 */
@Service
public class EmailService {

    private final EmailMessageRepository repository;

    private final EmailMessageMapper mapper;

    public EmailService(EmailMessageRepository repository, EmailMessageMapper mapper) {
        this.repository = repository;
        this.mapper = mapper;
    }

    @Transactional(readOnly = true)
    public PageDto<EmailMessageDto> list(int page, int size) {
        Pageable pageable = PageRequest.of(page, size);
        Page<EmailMessage> result = repository.findAllByOrderByEmailIdDesc(pageable);
        List<EmailMessageDto> items = result.getContent().stream().map(mapper::toDto).toList();
        return new PageDto<>(items, result.getNumber(), result.getSize(),
                result.getTotalElements(), result.getTotalPages(), result.hasNext());
    }

    @Transactional
    public EmailMessageDto enqueue(AdminEmailRequest request) {
        EmailMessage email = new EmailMessage();
        email.setToName(request.toName());
        email.setToEmail(request.toEmail());
        email.setSubject(request.subject());
        email.setMessage(request.message());
        email.setFromName(request.fromName());
        email.setFromEmail(request.fromEmail());
        email.setType(request.type());
        email.setFolder("outbox");
        return mapper.toDto(repository.save(email));
    }
}
