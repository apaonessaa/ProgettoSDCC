package com.app.news.services;

import com.app.news.services.interfaces.IFImageStorage;
import com.app.news.exceptions.ImageStorageException;
import com.app.news.services.validators.ImageValidator;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Service;
import org.springframework.util.InvalidMimeTypeException;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.UUID;

@Service
public class ImageStorageService implements IFImageStorage<String, byte[]>
{
    private final ImageValidator imgvald;
    private final Path root;

    public ImageStorageService(
            @Value("${IMAGE_PATH:/home/spring/images}") String rootPath,
            @Value("${IMAGE_CONFIG_PATH:/home/spring/config/validator.json}") String configPath
    )
    {
        MediaType[] validContentType = {MediaType.IMAGE_JPEG, MediaType.IMAGE_PNG};
        try {
            this.imgvald = new ImageValidator(configPath, Arrays.asList(validContentType));
        } catch (InstantiationException e) {
            throw new RuntimeException(e);
        }
        this.root = Path.of(rootPath);
    }

    private String getSecureFilename(@NotNull @NotBlank String filename)
    {
        int firstDot = filename.indexOf(".");
        String noExtFilename = filename.substring(0, firstDot);
        return UUID.randomUUID() + "_" + noExtFilename;
    }

    @Override
    public boolean exist(String filename)
    {
        Path target = root.resolve(filename);
        return Files.exists(target);
    }

    @Override
    public MediaType getMediaType(byte[] file)
    {
        MediaType mt;
        try {
            mt = imgvald.getValidMediaType(file);
        } catch (InvalidMimeTypeException e) {
            throw new ImageStorageException("Error with file type.");
        }
        return mt;
    }

    @Override
    public byte[] get(String filename)
    {
        Path target = root.resolve(filename);
        byte[] file;
        try {
            file = Files.readAllBytes(target);
        } catch (IOException e) {
            throw new ImageStorageException("Error during reading file <"+filename+">.");
        }
        return file;
    }

    @Override
    public String create(String filename, byte[] file)
    {
        if (!imgvald.validate(filename, file))
            throw new ImageStorageException("Error during file validation of <"+filename+">.");
        String secureFilename = this.getSecureFilename(filename);
        Path target = root.resolve(secureFilename);
        try {
            Files.copy(new ByteArrayInputStream(file), target);
        } catch (IOException e) {
            throw new ImageStorageException("Error during file creation of <"+filename+">.");
        }
        return secureFilename;
    }

    @Override
    public void update(String filename, byte[] file)
    {
        if (!imgvald.validate(filename, file))
            throw new ImageStorageException("Error during file validation of <"+filename+">.");
        if (!this.exist(filename))
            throw new ImageStorageException("The <"+filename+"> not exists.");
        Path target = root.resolve(filename);
        try {
            Files.copy(new ByteArrayInputStream(file), target, StandardCopyOption.REPLACE_EXISTING);
        } catch (IOException e) {
            throw new ImageStorageException("Error during the file update of <"+filename+">.");
        }
    }

    @Override
    public void delete(String filename)
    {
        try {
            Files.deleteIfExists(root.resolve(filename));
        } catch (IOException e) {
            throw new ImageStorageException("Error during file deletion of <"+filename+">.");
        }
    }
}
