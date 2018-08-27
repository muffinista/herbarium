FROM ruby:2.5

WORKDIR /app
ADD Gemfile* /app/
RUN bundle install

COPY . /app

CMD ["bundle", "exec", "./herbarium.rb"]
