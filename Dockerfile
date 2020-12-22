FROM ruby:2.6.5

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update -qq && \
    apt-get install -y nodejs postgresql-client yarn && \
    mkdir /mysql-rails-app
WORKDIR /mysql-rails-app
COPY Gemfile /mysql-rails-app/Gemfile
COPY Gemfile.lock /mysql-rails-app/Gemfile.lock
RUN gem install bundler:2.1.4 && \
    bundle install
COPY . /mysql-rails-app

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT [ "entrypoint.sh" ]
EXPOSE 3000

CMD [ "rails", "server", "-b", "0.0.0.0" ]