package com.app.news.controllers.mappers;

public interface Mapper<Entity, DTO> {
    Entity toEntity(DTO dto);
    DTO toDTO(Entity entity);
}
