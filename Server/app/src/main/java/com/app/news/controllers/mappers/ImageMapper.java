package com.app.news.controllers.mappers;

import com.app.news.controllers.dto.ImageDTO;
import com.app.news.entities.Image;
import org.springframework.stereotype.Component;

@Component
public class ImageMapper implements Mapper<Image, ImageDTO>
{

    @Override
    public Image toEntity(ImageDTO imgDTO)
    {
        return new Image(imgDTO.getFilename());
    }

    @Override
    public ImageDTO toDTO(Image img)
    {
        return new ImageDTO(img.getFilename());
    }
}
