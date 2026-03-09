package com.app.news.services.interfaces;

public interface IService<Entity, Identifier> {
    Entity get(Identifier id);
    Entity create(Entity e);
    Entity update(Entity e);
    void delete(Entity e);
}
