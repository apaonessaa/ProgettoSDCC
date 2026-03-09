package com.app.news.repositories;

import com.app.news.entities.Article;
import com.app.news.entities.Category;
import com.app.news.entities.SubCategory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface SubCategoryRepository extends JpaRepository<SubCategory, Long>
{
    Optional<SubCategory> findByNameAndCategory(String name, Category cat);

    List<SubCategory> findAllByCategory(Category cat, Sort sort);

    @Query("SELECT a FROM Article a " +
            "JOIN a.subcats sc " +
            "WHERE sc = :subcat " +
            "ORDER BY a.createdOn DESC")
    Page<Article> findAllBySubcategory(SubCategory subcat, Pageable pageable);

    @Query("SELECT a FROM Article a " +
            "JOIN a.subcats sc " +
            "WHERE sc IN :subcats " +
            "ORDER BY a.createdOn DESC")
    Page<Article> findAllBySubcategories(List<SubCategory> subcats, Pageable pageable);
}
