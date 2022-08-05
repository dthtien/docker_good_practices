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
COPY app/Gemfile /app/Gemfile
COPY app/Gemfile.lock /app/Gemfile.lock
RUN bundle install --gemfile ./app/Gemfile
```
Each step in the Docker image is a layer already cached when we build the docker image. By separating the install
dependencies step, we don't need to install dependencies every time we update the code
## Use Docker Buildkit cache mount

## Mutli stages

## References
- https://docs.docker.com
- https://martinheinz.dev/blog/44
- https://github.com/hadolint/hadolint
