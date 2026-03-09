package com.app.news.exceptions;

public class NotFoundException extends RuntimeException
{
    private static final String defaultMessage="[NotFoundException]";

    public NotFoundException()
    {
        super(defaultMessage);
    }

    public NotFoundException(String message)
    {
        super(defaultMessage+": "+message);
    }
}