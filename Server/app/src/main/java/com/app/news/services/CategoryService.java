package com.app.news.services;

import com.app.news.entities.Article;
import com.app.news.entities.Category;
import com.app.news.entities.SubCategory;
import com.app.news.exceptions.CreateException;
import com.app.news.exceptions.DeleteException;
import com.app.news.exceptions.NotFoundException;
import com.app.news.exceptions.UpdateException;
import com.app.news.repositories.CategoryRepository;
import com.app.news.services.interfaces.IService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Service;

import java.util.Optional;
import java.util.List;

@Service
public class CategoryService implements IService<Category, String>
{

    private final SubCategoryService subcatserv;
    private final CategoryRepository catrepo;

    public CategoryService(CategoryRepository catrepo, SubCategoryService subcatserv)
    {
        this.catrepo = catrepo;
        this.subcatserv = subcatserv;
    }

    @Override
    public Category get(String name)
    {
        Optional<Category> cat = catrepo.findByName(name);
        if (cat.isEmpty())
            throw new NotFoundException("Category <"+name+">.");
        return cat.get();
    }

    @Override
    public Category create(Category e)
    {
        String name = e.getName();
        if (catrepo.findByName(name).isPresent())
            throw new CreateException("Category <"+name+"> exists.");
        Category cat = new Category(name);
        cat.setDescription(e.getDescription());
        return catrepo.save(cat);
    }

    @Override
    public Category update(Category e)
    {
        Category cat;
        try {
            cat = get(e.getName());
        } catch (NotFoundException err) {
            throw new UpdateException("Category <"+e.getName()+"> not exists.");
        }
        cat.setDescription(e.getDescription());
        return catrepo.save(cat);
    }

    @Override
    public void delete(Category e)
    {
        Category cat;
        try {
            cat = get(e.getName());
        } catch (NotFoundException err) {
            throw new DeleteException("Category <"+e.getName()+"> not exists.");
        }
        /**
         * Delete subcategories, update articles for each subcategory
         * */
        for(SubCategory subcat : cat.getSubcats())
            subcatserv.delete(cat, subcat);
        catrepo.delete(cat);
    }

    public SubCategory getSubCat(String catname, String subcatname)
    {
        Category cat = get(catname);
        return subcatserv.get(cat, subcatname);
    }

    public SubCategory createSubCat(SubCategory e)
    {
        String catname = e.getCategory().getName();
        Category cat = get(catname);
        return subcatserv.create(cat, e);
    }

    public SubCategory updateSubCat(SubCategory e)
    {
        String catname = e.getCategory().getName();
        Category cat = get(catname);
        return subcatserv.update(cat, e);
    }

    public void deleteSubCat(SubCategory e)
    {
        String catname = e.getCategory().getName();
        Category cat = get(catname);
        subcatserv.delete(cat, e);
    }

    public List<Category> getAll()
    {
        Sort sort = Sort.by("name").ascending();
        return catrepo.findAll(sort);
    }

    public List<SubCategory> getAll(String catname)
    {
        Category cat = get(catname);
        return subcatserv.getAll(cat);
    }

    public Page<Article> getAll(String catname, int pageNumber, int pageSize)
    {
        Category cat = get(catname);
        return subcatserv.getAll(cat, pageNumber, pageSize);
    }

    public Page<Article> getAll(String catname, String subcatname, int pageNumber, int pageSize)
    {
        Category cat = get(catname);
        SubCategory subcat = subcatserv.get(cat, subcatname);
        return subcatserv.getAll(subcat, pageNumber, pageSize);
    }
}
