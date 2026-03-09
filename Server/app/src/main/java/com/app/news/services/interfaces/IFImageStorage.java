package com.app.news.services.interfaces;

import org.springframework.http.MediaType;

public interface IFImageStorage<Filename, Bytes> {
    boolean exist(Filename filename);
    MediaType getMediaType(Bytes file);
    Bytes get(Filename filename);
    Filename create(Filename filename, Bytes file);
    void update(Filename filename, Bytes file);
    void delete(Filename filename);
}
