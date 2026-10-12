package com.rev_creations.rcsite.exception;
/** A requested resource does not exist (mapped to HTTP 404). */
public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String message) {
        super(message);
    }
}
