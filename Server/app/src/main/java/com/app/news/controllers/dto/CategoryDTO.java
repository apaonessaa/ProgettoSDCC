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
public class CategoryDTO {
    @NotNull @NotBlank
    private String name;
    @NotNull
    private String description;
    @NotNull
    private List<String> subcategories;
}
