package com.app.news.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.HashSet;
import java.util.Set;

@Entity
public class Category
{
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long catID;

    @NotBlank @NotNull @Getter
    private String name;

    @NotNull @Getter @Setter
    private String description;

    @OneToMany(
            mappedBy="category",
            cascade=CascadeType.ALL,
            orphanRemoval = true)
    @EqualsAndHashCode.Exclude @ToString.Exclude
    @Getter
    private Set<SubCategory> subcats;

    protected Category() {}

    public Category(String name)
    {
        this.name = name;
        this.subcats = new HashSet<>();
    }

    public void addSubCategory(SubCategory subcat)
    {
        if(subcat!=null)
            this.subcats.add(subcat);
    }

    public void removeSubCategory(SubCategory subcat)
    {
        if(subcat!=null && !subcats.isEmpty())
            this.subcats.remove(subcat);
    }

    public void removeAllSubCategories()
    {
        this.subcats.clear();
    }
}
