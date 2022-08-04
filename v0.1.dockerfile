FROM ruby:3.0.0
RUN apt-get update -qq && apt-get install -y --no-install-recommends nodejs postgresql-client\
  && rm -rf /var/lib/apt/lists/*

COPY . /
RUN bundle install --gemfile ./app/Gemfile

# Add a script to be executed every time the container starts.
RUN chown -R nobody:nogroup /app \
    && chmod +x /app/entrypoint.sh

WORKDIR /app
USER nobody

ENTRYPOINT ["/app/entrypoint.sh"]
