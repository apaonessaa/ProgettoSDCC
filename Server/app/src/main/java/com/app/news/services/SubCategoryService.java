package com.app.news.services;

import com.app.news.entities.Article;
import com.app.news.entities.Category;
import com.app.news.entities.SubCategory;
import com.app.news.repositories.SubCategoryRepository;
import com.app.news.exceptions.CreateException;
import com.app.news.exceptions.DeleteException;
import com.app.news.exceptions.NotFoundException;
import com.app.news.exceptions.UpdateException;
import com.app.news.services.interfaces.ISubCategoryService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;

@Component
public class SubCategoryService implements ISubCategoryService<SubCategory, String> {
    private final SubCategoryRepository subcatrepo;

    public SubCategoryService(SubCategoryRepository subcatrepo) {
        this.subcatrepo = subcatrepo;
    }

    @Override
    public SubCategory get(Category cat, String name) {
        Optional<SubCategory> subcat = subcatrepo.findByNameAndCategory(name, cat);
        if (subcat.isEmpty())
            throw new NotFoundException("Subcategory <" + cat.getName() + "," + name + ">.");
        return subcat.get();
    }

    @Override
    public SubCategory create(Category cat, SubCategory e) {
        String name = e.getName();
        if (subcatrepo.findByNameAndCategory(name, cat).isPresent())
            throw new CreateException("Subcategory <" + cat.getName() + "," + name + "> exists.");

        SubCategory subcat = new SubCategory(name);
        subcat.setDescription(e.getDescription());
        subcat.setCategory(cat);
        return subcatrepo.save(subcat);
    }

    @Override
    public SubCategory update(Category cat, SubCategory e) {
        SubCategory subcat;
        String name = e.getName();
        try {
            subcat = get(cat, e.getName());
        } catch (NotFoundException ex) {
            throw new UpdateException("Subcategory <" + cat.getName() + "," + name + "> not exists.");
        }
        subcat.setDescription(e.getDescription());
        return subcatrepo.save(subcat);
    }

    @Override
    public void delete(Category cat, SubCategory e) {
        SubCategory subcat;
        String name = e.getName();
        try {
            subcat = get(cat, e.getName());
        } catch (NotFoundException err) {
            throw new DeleteException("Subcategory <" + cat.getName() + "," + name + "> not exists.");
        }
        /**
         * Delete from articles
         */
        for (Article art : subcat.getArticles())
            art.removeSubCategory(subcat);
        subcatrepo.delete(subcat);
    }

    public List<SubCategory> getAll(Category cat) {
        Sort sort = Sort.by("name").ascending();
        return subcatrepo.findAllByCategory(cat, sort);
    }

    public Page<Article> getAll(Category cat, int pageNumber, int pageSize) {
        Pageable pageable = PageRequest.of(pageNumber, pageSize);
        List<SubCategory> subcats = getAll(cat);
        return subcatrepo.findAllBySubcategories(subcats, pageable);
    }

    public Page<Article> getAll(SubCategory subcat, int pageNumber, int pageSize) {
        Pageable pageable = PageRequest.of(pageNumber, pageSize);
        return subcatrepo.findAllBySubcategory(subcat, pageable);
    }
}