package com.app.news.exceptions;

public class ImageStorageException extends RuntimeException
{
    private static final String defaultMessage="[ImageStorageException]";

    public ImageStorageException()
    {
        super(defaultMessage);
    }

    public ImageStorageException(String message)
    {
        super(defaultMessage+": "+message);
    }
}
