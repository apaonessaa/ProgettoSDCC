package com.app.news.repositories;

import com.app.news.entities.Image;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface ImageRepository extends JpaRepository<Image, Long>
{
    Optional<Image> findByFilename(String filename);
}
