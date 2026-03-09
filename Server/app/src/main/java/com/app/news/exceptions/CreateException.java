package com.app.news.exceptions;

public class CreateException extends RuntimeException
{
    private static final String defaultMessage="[CreateException]";

    public CreateException()
    {
        super(defaultMessage);
    }

    public CreateException(String message)
    {
        super(defaultMessage+": "+message);
    }
}
