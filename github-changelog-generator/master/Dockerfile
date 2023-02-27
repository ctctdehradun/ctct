FROM ruby:3.1

RUN gem install github_changelog_generator

# Set up the application directory
VOLUME ["/app"]
WORKDIR /app

CMD ["--help"]
ENTRYPOINT ["github_changelog_generator"]
