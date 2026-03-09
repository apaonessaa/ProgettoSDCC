package com.app.news.controllers;

import com.app.news.controllers.dto.ArticleDTO;
import com.app.news.controllers.dto.CategoryDTO;
import com.app.news.controllers.dto.SubCategoryDTO;
import com.app.news.controllers.mappers.ArticleMapper;
import com.app.news.controllers.mappers.CategoryMapper;
import com.app.news.controllers.mappers.SubCategoryMapper;
import com.app.news.entities.Category;
import com.app.news.entities.SubCategory;
import com.app.news.services.CategoryService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/categories")
public class CategoryController
{
    private final CategoryService catserv;
    private final CategoryMapper catmap;
    private final SubCategoryMapper subcatmap;
    private final ArticleMapper artmap;

    public CategoryController(
            CategoryService catserv,
            CategoryMapper catmap,
            SubCategoryMapper subcatmap,
            ArticleMapper artmap)
    {
        this.catserv = catserv;
        this.catmap = catmap;
        this.subcatmap = subcatmap;
        this.artmap = artmap;
    }

    /**
     * Category
     * */
    @GetMapping
    public ResponseEntity<List<CategoryDTO>> getAll()
    {
        List<CategoryDTO> cats =
                catserv.getAll()
                        .stream().map(catmap::toDTO)
                        .toList();
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(cats);
    }

    @PostMapping
    public ResponseEntity<CategoryDTO> create(@RequestBody @Valid CategoryDTO dto)
    {
        Category cat = catserv.create(catmap.toEntity(dto));
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(catmap.toDTO(cat));
    }

    @GetMapping("/{name}")
    public ResponseEntity<CategoryDTO> get(@PathVariable String name)
    {
        Category cat = catserv.get(name);
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(catmap.toDTO(cat));
    }

    @PutMapping("/{name}")
    public ResponseEntity<CategoryDTO> update(@PathVariable String name, @RequestBody @Valid CategoryDTO dto)
    {
        dto.setName(name);
        Category cat = catserv.update(catmap.toEntity(dto));
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(catmap.toDTO(cat));
    }

    @DeleteMapping("/{name}")
    public ResponseEntity<Void> delete(@PathVariable String name)
    {
        Category cat = catserv.get(name);
        catserv.delete(cat);
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }

    @GetMapping("/{cat}/articles")
    public ResponseEntity<Page<ArticleDTO>> get(
            @PathVariable String cat,
            @RequestParam(defaultValue = "0") int pageNumber,
            @RequestParam(defaultValue = "10") int pageSize
    ) {
        if (pageNumber < 0)
            pageNumber = 0;
        if (pageSize <= 0)
            pageSize = 10;
        Page<ArticleDTO> arts = catserv.getAll(cat, pageNumber, pageSize).map(artmap::toDTO);
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(arts);
    }

    /**
     * SubCategory
     * */
    @PostMapping("/{cat}/subcategories")
    public ResponseEntity<SubCategoryDTO> create(@PathVariable String cat, @RequestBody @Valid SubCategoryDTO dto)
    {
        dto.setCategory(cat);
        SubCategory subcat = catserv.createSubCat(subcatmap.toEntity(dto));
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(subcatmap.toDTO(subcat));
    }

    @GetMapping("/{cat}/subcategories/{name}")
    public ResponseEntity<SubCategoryDTO> get(@PathVariable String cat, @PathVariable String name) 
    {
        SubCategory subcat = catserv.getSubCat(cat, name);
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(subcatmap.toDTO(subcat));
    }

    @PutMapping("/{cat}/subcategories/{name}")
    public ResponseEntity<SubCategoryDTO> update(
            @PathVariable String cat,
            @PathVariable String name,
            @RequestBody @Valid SubCategoryDTO dto)
    {
        dto.setCategory(cat);
        dto.setName(name);
        SubCategory subcat = catserv.updateSubCat(subcatmap.toEntity(dto));
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(subcatmap.toDTO(subcat));
    }

    @DeleteMapping("/{cat}/subcategories/{name}")
    public ResponseEntity<Void> delete(@PathVariable String cat, @PathVariable String name)
    {
        SubCategoryDTO subcatDTO = new SubCategoryDTO();
        subcatDTO.setCategory(cat);
        subcatDTO.setName(name);
        catserv.deleteSubCat(subcatmap.toEntity(subcatDTO));
        return ResponseEntity
                .status(HttpStatus.NO_CONTENT)
                .build();
    }

    @GetMapping("/{cat}/subcategories/{name}/articles")
    public ResponseEntity<Page<ArticleDTO>> get(
            @PathVariable String cat,
            @PathVariable String name,
            @RequestParam(defaultValue = "0") int pageNumber,
            @RequestParam(defaultValue = "10") int pageSize
    ) {
        if (pageNumber < 0)
            pageNumber = 0;
        if (pageSize <= 0)
            pageSize = 10;
        Page<ArticleDTO> arts = catserv.getAll(cat, name, pageNumber, pageSize).map(artmap::toDTO);
        return ResponseEntity
                .status(HttpStatus.OK)
                .body(arts);
    }
}
