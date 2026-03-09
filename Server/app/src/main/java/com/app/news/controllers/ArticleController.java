package com.app.news.controllers;

import com.app.news.controllers.dto.ArticleDTO;
import com.app.news.controllers.mappers.ArticleMapper;
import com.app.news.entities.Article;
import com.app.news.exceptions.CreateException;
import com.app.news.services.ArticleService;
import com.app.news.services.ImageStorageService;
import jakarta.annotation.Nullable;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("/api/articles")
public class ArticleController
{
    private final ArticleService artserv;
    private final ImageStorageService imgserv;
    private final ArticleMapper artmap;

    public ArticleController(
            ArticleService artserv,
            ImageStorageService imgserv,
            ArticleMapper artmap)
    {
        this.artserv = artserv;
        this.imgserv = imgserv;
        this.artmap = artmap;
    }

    @GetMapping
    public ResponseEntity<Page<ArticleDTO>> get(
            @RequestParam(defaultValue = "0") int pageNumber,
            @RequestParam(defaultValue = "10") int pageSize
    ) {
        if (pageNumber < 0)
            pageNumber = 0;
        if (pageSize <= 0)
            pageSize = 10;
        Page<ArticleDTO> arts = artserv.getAll(pageNumber, pageSize).map(artmap::toDTO);
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(arts);
    }

    @PostMapping
    public ResponseEntity<ArticleDTO> create(
            @RequestPart("article") @Valid ArticleDTO dto,
            @RequestPart("image") MultipartFile image)
            throws IOException
    {
        byte[] raw = image.getInputStream().readAllBytes();
        String filename = imgserv.create(image.getOriginalFilename(), raw);
        dto.setImage(filename);
        Article art;
        try {
            art = artserv.create(artmap.toEntity(dto));
        } catch (CreateException ex) {
            imgserv.delete(filename);
            throw ex;
        }
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(artmap.toDTO(art));
    }

    @GetMapping("/{title}")
    public ResponseEntity<ArticleDTO> get(@PathVariable String title)
    {
        Article art = artserv.get(title);
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(artmap.toDTO(art));
    }

    @GetMapping("/{title}/image")
    public ResponseEntity<byte[]> getImage(@PathVariable String title)
    {
        Article art = artserv.get(title);
        String filename = art.getImage().getFilename();
        byte[] imageBytes = imgserv.get(filename);
        MediaType mediaType = imgserv.getMediaType(imageBytes);
        return ResponseEntity
                .ok()
                .contentType(mediaType)
                .body(imageBytes);
    }

    @PutMapping("/{title}")
    public ResponseEntity<ArticleDTO> update(
            @PathVariable String title,
            @RequestPart("article") @Valid ArticleDTO artDTO,
            @Nullable @RequestPart("image") MultipartFile image)
            throws IOException
    {
        if (image!=null && !image.isEmpty())
        {
            byte[] raw = image.getInputStream().readAllBytes();
            imgserv.update(artDTO.getImage(), raw);
        }
        artDTO.setTitle(title);
        Article art = artserv.update(artmap.toEntity(artDTO));
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(artmap.toDTO(art));
    }

    @DeleteMapping("/{title}")
    public ResponseEntity<Void> delete(@PathVariable String title)
    {
        Article art = artserv.get(title);
        imgserv.delete(art.getImage().getFilename());
        artserv.delete(art);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }
}
