package com.app.news.services.interfaces;

import com.app.news.entities.Category;

public interface ISubCategoryService<Entity, Identifier> {
    Entity get(Category cat, Identifier id);
    Entity create(Category cat, Entity e);
    Entity update(Category cat, Entity e);
    void delete(Category cat, Entity e);
}