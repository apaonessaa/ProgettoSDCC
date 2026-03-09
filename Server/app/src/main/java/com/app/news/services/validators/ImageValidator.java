package com.app.news.services.validators;

import dev.filechampion.filechampion4j.FileValidator;
import dev.filechampion.filechampion4j.ValidationResponse;
import org.json.JSONObject;
import org.springframework.http.MediaType;
import org.springframework.util.InvalidMimeTypeException;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.net.URLConnection;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ImageValidator
{
    private final Set<MediaType> whitelist;
    private final FileValidator validator;

    public ImageValidator(
            String configPath,
            List<MediaType> whiteslist
    ) throws InstantiationException
    {
        this.whitelist = new HashSet<>(whiteslist);
        try {
            String jsonConfigContent = new String(Files.readAllBytes(Paths.get(configPath)));
            JSONObject jsonObject = new JSONObject(jsonConfigContent);
            this.validator = new FileValidator(jsonObject);
        } catch (IOException e) {
            throw new InstantiationException("Error during ImageValidator instatiation.");
        }
    }

    private MediaType getMimeType(byte[] fileInBytes) throws InvalidMimeTypeException
    {
        String mimeType;
        try {
            ByteArrayInputStream byteStream = new ByteArrayInputStream(fileInBytes);
            mimeType = URLConnection.guessContentTypeFromStream(byteStream);
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        if (mimeType == null)
            throw new InvalidMimeTypeException("", "No file type.");
        return MediaType.valueOf(mimeType);
    }

    public MediaType getValidMediaType(byte[] fileInBytes) throws InvalidMimeTypeException
    {
        MediaType mediaType = getMimeType(fileInBytes);
        if (!whitelist.contains(mediaType))
            throw new InvalidMimeTypeException(mediaType.toString(), "Invalid file type.");
        return mediaType;
    }

    public boolean validate(String filename, byte[] fileInBytes)
    {
        MediaType mediaType;
        try {
            mediaType = getValidMediaType(fileInBytes);
        } catch (InvalidMimeTypeException e) {
            return false;
        }
        ValidationResponse response = validator.validateFile("Images", fileInBytes, filename, mediaType.toString());
        return response.isValid();
    }
}
