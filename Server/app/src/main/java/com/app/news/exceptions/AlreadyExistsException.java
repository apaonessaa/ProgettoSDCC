package com.app.news.exceptions;

public class AlreadyExistsException extends RuntimeException
{
    private static final String defaultMessage="[AlreadyExistsException]";

    public AlreadyExistsException()
    {
        super(defaultMessage);
    }

    public AlreadyExistsException(String message)
    {
        super(defaultMessage+": "+message);
    }
}
