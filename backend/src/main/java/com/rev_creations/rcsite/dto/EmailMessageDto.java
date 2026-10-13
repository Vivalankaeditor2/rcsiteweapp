package com.rev_creations.rcsite.dto;

import java.time.LocalDateTime;

/** Public view of one queued outbound email. */
public record EmailMessageDto(
        Long emailId,
        LocalDateTime enteredDate,
        String fromName,
        String fromEmail,
        String toName,
        String toEmail,
        String subject,
        String type,
        String folder,
        String user) {
}
