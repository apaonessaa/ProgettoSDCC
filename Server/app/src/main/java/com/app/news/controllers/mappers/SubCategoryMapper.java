package com.app.news.controllers.mappers;

import com.app.news.controllers.dto.SubCategoryDTO;
import com.app.news.entities.Article;
import com.app.news.entities.Category;
import com.app.news.entities.SubCategory;
import org.springframework.stereotype.Component;

@Component
public class SubCategoryMapper implements Mapper<SubCategory, SubCategoryDTO>
{

    @Override
    public SubCategory toEntity(SubCategoryDTO subcatDTO)
    {
        SubCategory subcat = new SubCategory(subcatDTO.getName());
        subcat.setDescription(subcatDTO.getDescription());
        subcat.setCategory(new Category(subcatDTO.getCategory()));
        subcatDTO.getArticles()
                .stream().map(Article::new)
                .forEach(subcat::addArticle);
        return subcat;
    }

    @Override
    public SubCategoryDTO toDTO(SubCategory subcat)
    {
        return new SubCategoryDTO(
                subcat.getName(),
                subcat.getDescription(),
                subcat.getCategory().getName(),
                subcat.getArticles()
                        .stream().map(Article::getTitle)
                        .toList());
    }
}
