FROM ruby:2.3.3
# RUN apt-get update -qq && apt-get install -y mongo
RUN gem install bundler
RUN mkdir /UserService

WORKDIR /UserService
COPY Gemfile /UserService/Gemfile
COPY Gemfile.lock /UserService/Gemfile.lock
RUN bundle install
COPY . /UserService

EXPOSE 3000

# Start the main process.
CMD ["bundle exec ruby main.rb"]

