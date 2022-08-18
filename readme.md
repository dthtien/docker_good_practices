# Docker good practices

## Ignore huge unuse files and folders by `.dockerignore`
We usually have the `COPY . /` step which copies the working directory to the images. In some cases, there are some vast files and folders which we don't really need it. These files and folders are better to be in the `.dockerignore` file.
For more information: https://docs.docker.com/engine/reference/builder/#dockerignore-file
## Using Dockerfile linting tool(s)
Similar to the lint in development EG: `rubocop, eslint`,... Dockerfile also has linter tool which is [Hadolint](https://github.com/hadolint/hadolint)
```
hadolint Dockerfile
```

## Using COPY/ADD option to change file metadata (such as: owner/permissions)
```
COPY --chown=nobody:nogroup . /
```

The Docker uses the technic that called [union filesystem](https://martinheinz.dev/blog/44) , which, in general speak, is
Docker only creates a thin layer on top of the image, and the rest of it can be shared between all the containers. By
setting the `--chown=nobody:nogroup`, we don't only need to copy the working directory only once
## Separate the install dependency step
```
COPY app/Gemfile app/Gemfile.lock /app/
RUN bundle install --gemfile ./app/Gemfile
```
Each step in the Docker image is a layer already cached when we build the docker image. By separating the install
dependencies step, we don't need to install dependencies every time we update the code
## Use Docker Buildkit cache mount
```
ENV BUNDLE_PATH=/bundler
RUN mkdir /bundler
COPY app/Gemfile app/Gemfile.lock /app/
RUN --mount=type=cache,target=/bundler ls -la /bundler/cache; bundle install --gemfile ./app/Gemfile
```

### [Buildkit](https://github.com/moby/buildkit):
- The component that the core of Docker building image support
- Originally from Docker
- Docker's latest version already uses Buildkit to build images by default

### Cache mount
- The functionality is similar to installing all dependencies to separate disk and mounting it whenever we want toreuse it. When finished building, it closes the disks and uploads the image to the registry. the cached data is already onthe builder(Docker)
- Possible to export the cache file to another host
- ? retention
## Multi stages
Docker only pushes the last from to registry, which reduces the space, but the building time is still the same.
```dockerfile
# v1
FROM golang:1.18.2-alpine3.14

WORKDIR /app
RUN apk add --no-cache git \
  && git clone https://github.com/cucxabong/aws-google-login.git \
  && cd aws-google-login \
  && go build -o /usr/local/bin/aws-google-login cmd/main.go

ENTRYPOINT [ "/usr/local/bin/aws-google-login" ]
```

```dockerfile
FROM golang:1.18.2-alpine3.14 as builder

WORKDIR /app
RUN apk add --no-cache git \
  && git clone https://github.com/cucxabong/aws-google-login.git \
  && cd aws-google-login \
  && CGO_ENABLED=0 go build -o /usr/local/bin/aws-google-login cmd/main.go

FROM alpine:3.15.4

COPY --from=builder /usr/local/bin/aws-google-login /usr/local/bin/aws-google-login

ENTRYPOINT [ "/usr/local/bin/aws-google-login" ]

```
## References
- https://docs.docker.com
- https://martinheinz.dev/blog/44
- https://github.com/hadolint/hadolint
- https://github.com/cucxabong/aws-google-login
