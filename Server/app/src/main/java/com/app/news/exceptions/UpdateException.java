package com.app.news.exceptions;

public class UpdateException extends RuntimeException
{
    private static final String defaultMessage="[UpdateException]";

    public UpdateException()
    {
        super(defaultMessage);
    }

    public UpdateException(String message)
    {
        super(defaultMessage+": "+message);
    }
}
