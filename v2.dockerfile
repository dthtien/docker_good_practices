FROM ruby:3.0.0
ENV BUNDLE_PATH=/bundler
RUN mkdir /bundler
RUN apt-get update -qq &&\
    apt-get install -y --no-install-recommends nodejs postgresql-client &&\
    rm -rf /var/lib/apt/lists/*

COPY app/Gemfile app/Gemfile.lock /app/
RUN --mount=type=cache,target=/bundler ls -la /bundler/cache; bundle install --gemfile ./app/Gemfile

COPY --chown=nobody:nogroup . /

# Add a script to be executed every time the container starts.
RUN chown -R nobody:nogroup /app \
    && chmod +x /app/entrypoint.sh

WORKDIR /app
USER nobody

ENTRYPOINT ["/app/entrypoint.sh"]
