package com.app.news.entities;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.sql.Timestamp;
import java.time.Instant;
import java.util.Collection;
import java.util.HashSet;
import java.util.Set;

@Entity
public class Article
{
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long artID;

    @NotNull @NotBlank @Getter
    @Column(columnDefinition = "TEXT")
    private String title;

    @NotNull @Getter
    @Column(columnDefinition = "TEXT")
    private String summary;

    @NotNull @Getter
    @Column(columnDefinition = "TEXT")
    private String content;

    @OneToOne(cascade = CascadeType.ALL, orphanRemoval = true)
    @JoinColumn(name="imgID", referencedColumnName = "imgID")
    @Getter
    @EqualsAndHashCode.Exclude @ToString.Exclude
    private Image image;

    @Getter
    private Timestamp createdOn;

    @Getter
    private Timestamp updatedOn;

    @ManyToOne
    @JoinColumn(name = "catID")
    @Getter
    @EqualsAndHashCode.Exclude @ToString.Exclude
    private Category category;

    @ManyToMany(fetch=FetchType.LAZY)
    @JoinTable(
            name="art_subcat",
            joinColumns=@JoinColumn(name="artID"),
            inverseJoinColumns=@JoinColumn(name="subcatID"))
    @Getter
    @EqualsAndHashCode.Exclude @ToString.Exclude
    private Set<SubCategory> subcats;

    protected Article() {}

    public Article(String title)
    {
        this.title = title;
        this.createdOn = getCurrentTimestamp();
        this.category = null;
        this.subcats = new HashSet<>();
        this.setUpdateOn();
    }

    private Timestamp getCurrentTimestamp()
    {
        return new Timestamp(Instant.now().toEpochMilli());
    }

    private void setUpdateOn()
    {
        this.updatedOn = getCurrentTimestamp();
    }

    public void setSummary(String summary)
    {
        this.summary = summary;
        this.setUpdateOn();
    }

    public void setContent(String content)
    {
        this.content = content;
        this.setUpdateOn();
    }

    public void setCategory(Category cat)
    {
        this.category = cat;
        this.setUpdateOn();
    }

    public void setImage(Image img)
    {
        this.image = img;
        this.setUpdateOn();
    }

    public void addSubCategory(SubCategory subcat)
    {
        if(subcat!=null) {
            subcats.add(subcat);
            this.setUpdateOn();
        }
    }

    public void removeSubCategory(SubCategory subcat)
    {
        if(subcat!=null) {
            subcats.remove(subcat);
            this.setUpdateOn();
        }
    }

    public void addSubCaterogies(Collection<SubCategory> subcats)
    {
        this.subcats.addAll(subcats);
        this.setUpdateOn();
    }

    public void removeSubCaterogies(Collection<SubCategory> subcats)
    {
        this.subcats.removeAll(subcats);
        this.setUpdateOn();
    }

    public void removeAllSubCategories()
    {
        subcats.clear();
        this.setUpdateOn();
    }
}
