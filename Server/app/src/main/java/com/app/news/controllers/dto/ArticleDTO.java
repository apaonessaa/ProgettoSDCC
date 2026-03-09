package com.app.news.controllers.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.util.List;

@Data
@RequiredArgsConstructor
@AllArgsConstructor
public class ArticleDTO {
    @NotNull @NotBlank
    private String title;

    @NotNull @NotBlank
    private String summary;

    @NotNull @NotBlank
    private String content;

    @NotNull @NotBlank
    private String image;

    @NotNull @NotBlank
    private String category;

    @NotNull @NotEmpty
    private List<String> subcategories;
}
