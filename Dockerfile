FROM ruby:2.5.3

RUN apt-get update && apt-get install -y \ 
    build-essential \
    nodejs \
    pandoc \
    mysql-client \
    yarn

WORKDIR /usr/src/app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler && bundle install

COPY . .

# Compila os assets
RUN bundle exec rake assets:precompile

# Limpa cache e tmp, diminuindo tamanho da imagem e ajudando no cache
RUN rm -rf /tmp/* /var/tmp/* && apt-get clean
