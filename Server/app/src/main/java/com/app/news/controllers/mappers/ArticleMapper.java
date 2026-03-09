package com.app.news.controllers.mappers;

import com.app.news.controllers.dto.ArticleDTO;
import com.app.news.entities.Article;
import com.app.news.entities.Category;
import com.app.news.entities.Image;
import com.app.news.entities.SubCategory;
import org.springframework.stereotype.Component;

@Component
public class ArticleMapper implements Mapper<Article, ArticleDTO>
{

    @Override
    public Article toEntity(ArticleDTO artDTO)
    {
        Article art = new Article(artDTO.getTitle());
        art.setSummary(artDTO.getSummary());
        art.setContent(artDTO.getContent());
        art.setCategory(new Category(artDTO.getCategory()));
        artDTO.getSubcategories()
                .stream().map(SubCategory::new)
                .forEach(art::addSubCategory);
        art.setImage(new Image(artDTO.getImage()));
        return art;
    }

    @Override
    public ArticleDTO toDTO(Article art)
    {
        return new ArticleDTO(
                art.getTitle(),
                art.getSummary(),
                art.getContent(),
                art.getImage().getFilename(),
                art.getCategory().getName(),
                art.getSubcats().stream().map(SubCategory::getName).toList());
    }
}
