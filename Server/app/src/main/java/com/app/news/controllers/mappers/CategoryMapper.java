package com.app.news.controllers.mappers;

import com.app.news.controllers.dto.CategoryDTO;
import com.app.news.entities.Category;
import com.app.news.entities.SubCategory;
import org.springframework.stereotype.Component;

@Component
public class CategoryMapper implements Mapper<Category, CategoryDTO>
{

    @Override
    public Category toEntity(CategoryDTO catDTO)
    {
        Category cat = new Category(catDTO.getName());
        cat.setDescription(catDTO.getDescription());
        catDTO.getSubcategories()
                .stream().map(SubCategory::new)
                .forEach(cat::addSubCategory);
        return cat;
    }

    @Override
    public CategoryDTO toDTO(Category cat)
    {
        return new CategoryDTO(
                cat.getName(),
                cat.getDescription(),
                cat.getSubcats()
                        .stream().map(SubCategory::getName)
                        .toList());
    }
}
