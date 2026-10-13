package com.rev_creations.rcsite.exception;

/** A request that conflicts with existing data (answers 409). */
public class ConflictException extends RuntimeException {

    public ConflictException(String message) {
        super(message);
    }
}
