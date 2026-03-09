# --- BUILD STAGE ---
FROM ubuntu:22.04 AS build

RUN apt-get update -y && apt-get install -y curl git unzip xz-utils zip libglu1-mesa

# Install Flutter
COPY ./flutter.tar.xz /tmp/flutter.tar.xz

RUN mkdir -p /opt/flutter \
	&& unxz /tmp/flutter.tar.xz \
	&& tar -xf /tmp/flutter.tar -C /opt/flutter --strip-components=1 \
	&& rm /tmp/flutter.tar

# Make safe and add flutter to PATH
RUN git config --global --add safe.directory /opt/flutter 
ENV PATH="/opt/flutter/bin:$PATH"

# Flutter configurations
RUN flutter --disable-analytics \
	&& flutter config --enable-web \
	&& flutter precache --web

# Create project, copy the codebase and build
WORKDIR /tmp/newsweb
RUN flutter create . --platforms web
COPY ./lib ./lib
COPY ./pubspec.yaml ./pubspec.yaml
RUN flutter clean && flutter pub get

ARG HOST
ARG SERVICE
RUN flutter build web \
	--dart-define=HOST=${HOST} \ 
	--dart-define=SERVICE=${SERVICE} \
	--no-pub --release --no-wasm-dry-run --no-tree-shake-icons -O4 -o /tmp/web

# --- RUN STAGE ---
FROM nginx:alpine
COPY --from=build /tmp/web /usr/share/nginx/html
