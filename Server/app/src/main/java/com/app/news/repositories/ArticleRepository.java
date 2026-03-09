package com.app.news.repositories;

import com.app.news.entities.Article;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ArticleRepository extends JpaRepository<Article, Long>
{
    Optional<Article> findByTitle(String title);

    Page<Article> findAllByOrderByCreatedOnDesc(Pageable pageable);
}
