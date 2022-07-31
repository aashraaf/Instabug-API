FROM ruby:3.1.2

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler 
RUN bundle install

COPY . /app/

CMD [ "rails", "s", "-b", "0.0.0.0" ]