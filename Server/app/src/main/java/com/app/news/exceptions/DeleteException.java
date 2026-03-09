package com.app.news.exceptions;

public class DeleteException extends RuntimeException
{
    private static final String defaultMessage="[DeleteException]";

    public DeleteException()
    {
        super(defaultMessage);
    }

    public DeleteException(String message)
    {
        super(defaultMessage+": "+message);
    }
}
