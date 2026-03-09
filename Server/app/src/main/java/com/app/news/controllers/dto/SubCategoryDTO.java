package com.app.news.controllers.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.util.List;

@Data
@RequiredArgsConstructor
@AllArgsConstructor
public class SubCategoryDTO {
    @NotNull @NotBlank
    private String name;
    @NotNull
    private String description;
    @NotNull @NotBlank
    private String category;
    @NotNull
    private List<String> articles;
}