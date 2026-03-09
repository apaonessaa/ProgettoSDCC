package com.app.news.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.HashSet;
import java.util.Set;

@Entity
public class SubCategory
{
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long subcatID;

    @NotNull @NotBlank @Getter
    private String name;

    @NotNull @Getter @Setter
    private String description;

    @ManyToOne
    @NotNull @Getter @Setter
    @EqualsAndHashCode.Exclude @ToString.Exclude
    private Category category;

    @ManyToMany(mappedBy="subcats", fetch=FetchType.LAZY)
    @Getter
    @EqualsAndHashCode.Exclude @ToString.Exclude
    private Set<Article> articles;

    protected SubCategory() {}

    public SubCategory(String name)
    {
        this.name = name;
        this.articles = new HashSet<>();
    }

    public void addArticle(Article article)
    {
        if(article!=null)
            this.articles.add(article);
    }

    public void removeArticle(Article article)
    {
        if(article!=null && !articles.isEmpty())
            this.articles.remove(article);
    }

    public void removeAllArticles()
    {
        this.articles.clear();
    }
}
