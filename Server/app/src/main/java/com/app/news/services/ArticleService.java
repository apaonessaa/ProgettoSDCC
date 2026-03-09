package com.app.news.services;

import com.app.news.entities.Article;
import com.app.news.entities.Category;
import com.app.news.entities.Image;
import com.app.news.entities.SubCategory;
import com.app.news.repositories.ArticleRepository;
import com.app.news.services.interfaces.IService;
import com.app.news.exceptions.CreateException;
import com.app.news.exceptions.DeleteException;
import com.app.news.exceptions.NotFoundException;
import com.app.news.exceptions.UpdateException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
public class ArticleService implements IService<Article, String>
{
    private final CategoryService catserv;
    private final ImageService imgserv;
    private final ArticleRepository artrepo;

    public ArticleService(
            CategoryService catserv,
            ImageService imgserv,
            ArticleRepository artrepo)
    {
        this.catserv = catserv;
        this.imgserv = imgserv;
        this.artrepo = artrepo;
    }

    @Override
    public Article get(String title)
    {
        Optional<Article> art = artrepo.findByTitle(title);
        if (art.isEmpty())
            throw new NotFoundException("The article <"+title+"> not exists.");
        return art.get();
    }

    /**
     * Enforce the creation of completed article.
     */
    @Override
    public Article create(Article e)
    {
        String title = e.getTitle();
        if (artrepo.findByTitle(title).isPresent())
            throw new CreateException("The article <"+title+"> already exists.");
        Article art = new Article(title);
        art.setSummary(e.getSummary());
        art.setContent(e.getContent());
        /**
         * Create the image
         */
        Image img;
        try {
            img = imgserv.create(e.getImage());
        } catch (CreateException ex) {
            throw new CreateException("The article <"+title+"> has invalid image <"+e.getImage().getFilename()+">.");
        }
        art.setImage(img);
        /**
         * Check the category
         */
        Category cat;
        String catname = e.getCategory().getName();
        try {
            cat = catserv.get(catname);
        } catch (NotFoundException ex) {
            throw new CreateException("The article <"+title+"> has invalid category <"+catname+">.");
        }
        /**
         * Check the subcategory
         */
        Set<SubCategory> subcats = new HashSet<>();
        Set<String> scnames = e.getSubcats().stream().map(SubCategory::getName).collect(Collectors.toSet());
        SubCategory sc;
        for(String scname : scnames) {
            try {
                sc = catserv.getSubCat(catname, scname);
                if (sc.getCategory().equals(cat))
                    subcats.add(sc);
            } catch (NotFoundException ex) {
                throw new CreateException("The article <"+title+"> has invalid subcategory <"+scname+">.");
            }
        }
        if (subcats.isEmpty())
            throw new CreateException("The article <"+title+"> has no subcategory of <"+catname+"> category.");
        /**
         * Update category and subcategory
         * */
        art.setCategory(cat);
        for(SubCategory subcat : subcats) {
            subcat.addArticle(art);
            art.addSubCategory(subcat);
        }
        return artrepo.save(art);
    }

    @Override
    public Article update(Article e)
    {
        String title = e.getTitle();
        Article art;
        try {
            art = get(title);
        } catch (NotFoundException ex) {
            throw new UpdateException("The article <"+title+"> not exists.");
        }
        art.setSummary(e.getSummary());
        art.setContent(e.getContent());
        /**
         * Update the description of the image
         * */
        Image img = art.getImage();
        try {
            imgserv.update(img);
        } catch (UpdateException ex) {
            throw new UpdateException("The image <"+img.getFilename()+"> of the article <"+title+"> cannot be updated.");
        }
        /**
         * Update the category
         */
        Category cat;
        String catname = e.getCategory().getName();
        try {
            cat = catserv.get(catname);
        } catch (NotFoundException ex) {
            throw new UpdateException("The article <"+title+"> has invalid category <"+catname+">.");
        }
        art.setCategory(cat);
        /**
         * Update the subcategory (least one subcategory)
         */
        Set<SubCategory> toRemove = new HashSet<>(art.getSubcats());
        Set<SubCategory> toAdd = new HashSet<>();
        Set<String> scnames = e.getSubcats().stream().map(SubCategory::getName).collect(Collectors.toSet());
        SubCategory sc;
        for (String scname : scnames) {
            try {
                sc = catserv.getSubCat(catname, scname);
                if (sc.getCategory().equals(cat) && !toRemove.remove(sc))
                    toAdd.add(sc);
            } catch (NotFoundException ex) {
                throw new UpdateException("The article <"+title+"> has invalid subcategory <"+scname+">.");
            }
        }
        /**
         * Least one subcategory
         *      (subcategories - toRemove) U toAdd
         * */
        Set<SubCategory> leastOne = new HashSet<>(art.getSubcats());
        leastOne.removeAll(toRemove);
        leastOne.addAll(toAdd);
        if (leastOne.isEmpty())
            throw new UpdateException("The article <"+title+"> has no subcategory of <"+catname+"> category.");

        for (SubCategory subcat : toRemove) {
            subcat.removeArticle(art);
            catserv.updateSubCat(subcat);
        }
        for (SubCategory subcat : toAdd) {
            subcat.addArticle(art);
            catserv.updateSubCat(subcat);
        }
        art.removeSubCaterogies(toRemove);
        art.addSubCaterogies(toAdd);
        return artrepo.save(art);
    }

    @Override
    public void delete(Article e)
    {
        String title = e.getTitle();
        Article art;
        try {
            art = get(title);
        } catch (NotFoundException ex) {
            throw new DeleteException("The article <"+title+"> not exists.");
        }
        /**
         * Update subcategory
         */
        for(SubCategory subcat : art.getSubcats()) {
            subcat.removeArticle(art);
            try {
                catserv.updateSubCat(subcat);
            } catch (UpdateException ex) {
                throw new DeleteException("The subcategory <"+subcat.getName()+"> of article <"+title+"> cannot be updated.");
            }
        }
        artrepo.delete(art);
    }

    public Page<Article> getAll(int pageNumber, int pageSize) {
        Pageable pageable = PageRequest.of(pageNumber, pageSize);
        return artrepo.findAllByOrderByCreatedOnDesc(pageable);
    }
}
