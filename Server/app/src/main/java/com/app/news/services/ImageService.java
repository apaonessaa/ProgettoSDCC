package com.app.news.services;

import com.app.news.entities.Image;
import com.app.news.repositories.ImageRepository;
import com.app.news.exceptions.CreateException;
import com.app.news.exceptions.DeleteException;
import com.app.news.exceptions.NotFoundException;
import com.app.news.exceptions.UpdateException;
import com.app.news.services.interfaces.IService;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class ImageService implements IService<Image, String>
{

    private final ImageRepository imgrepo;

    public ImageService(ImageRepository imgrepo)
    {
        this.imgrepo = imgrepo;
    }

    @Override
    public Image get(String fname)
    {
        Optional<Image> img = imgrepo.findByFilename(fname);
        if (img.isEmpty())
            throw new NotFoundException("The image <"+fname+"> not exists.");
        return img.get();
    }

    @Override
    public Image create(Image e)
    {
        String fname = e.getFilename();
        if(imgrepo.findByFilename(fname).isPresent())
            throw new CreateException("The image <"+fname+"> exists.");
        Image img = new Image(fname);
        return imgrepo.save(img);
    }

    @Override
    public Image update(Image e)
    {
        Image img;
        try {
            img = get(e.getFilename());
        } catch (NotFoundException ex) {
            throw new UpdateException("The image <"+e.getFilename()+"> not exists.");
        }
        return img;
    }

    @Override
    public void delete(Image e)
    {
        Image img;
        try {
            img = get(e.getFilename());
        } catch (NotFoundException ex) {
            throw new DeleteException("The image <"+e.getFilename()+"> not exists.");
        }
        imgrepo.delete(img);
    }
}
