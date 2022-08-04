# Docker good practices

# Ignore huge unuse folders by `.dockerignore`
We usually use `COPY . /` step to copy the current folder to the images. In some cases, there are some huge files which
we don't really need it. These files are better to be in `.dockerignore` file
For more information: https://docs.docker.com/engine/reference/builder/#dockerignore-file
# Use lint to optimize the Dockerfile
Similar with the lint in developmen, Dockerfile also has linter tool which is [Hadolint](https://github.com/hadolint/hadolint)

# Change owner on copy step
```
COPY --chown=nobody:nogroup . /
```

# Separate the install dependency step
```
COPY app/Gemfile /app/Gemfile
COPY app/Gemfile.lock /app/Gemfile.lock
RUN bundle install --gemfile ./app/Gemfile
```

# Use Docker buildkit mouch cache
# Mutli stages


