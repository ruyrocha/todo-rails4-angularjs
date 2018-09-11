FROM ubuntu:bionic
RUN apt update && \
  apt upgrade -y -qq && \
  DEBIAN_FRONTEND=noninteractive apt -y install build-essential git \
  wget imagemagick unzip phantomjs libxml2-dev libxslt-dev \
  libffi-dev libyaml-dev libgdbm-dev libreadline-dev libmysqlclient-dev \
  apt-utils libpq-dev ncurses-dev sqlite3 libsqlite3-dev \
  silversearcher-ag screen cron tzdata dash chromium-chromedriver \
  libssl1.0-dev nodejs sudo

# Set default local time
ENV TZ America/Sao_Paulo
RUN ln -nsf /usr/share/zoneinfo/$TZ /etc/timezone

# Bash > Dash
RUN echo "dash    dash/sh boolean false" | debconf-set-selections && \
  dpkg-reconfigure --frontend=noninteractive dash

# Fix NodeJS path
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 99

# Add `deploy` user
RUN useradd -m deploy && echo "deploy:deploy" | chpasswd && adduser deploy sudo
RUN sed -i -e '/\%sudo/s/.*/\%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g' /etc/sudoers

USER deploy
# Install rbenv
RUN git clone https://github.com/sstephenson/rbenv.git $HOME/.rbenv && \
  echo 'export RBENV_ROOT=$HOME/.rbenv' >> $HOME/.profile && \
  echo 'export PATH="$RBENV_ROOT/bin:$PATH"' >> $HOME/.profile && \
  echo 'eval "$(rbenv init -)"' >> $HOME/.profile

# And ruby-build
ENV RBENV_ROOT="/home/deploy/.rbenv"
ENV PATH=$RBENV_ROOT/bin:$RBENV_ROOT/shims:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
RUN git clone https://github.com/rbenv/ruby-build.git $RBENV_ROOT/plugins/ruby-build

ENV CONFIGURE_OPTS --disable-install-doc
RUN rbenv install -v 2.2.4 && rbenv rehash && rbenv global 2.2.4 && \
  echo 'gem: --no-rdoc --no-ri' >> $HOME/.gemrc

# install things globally, for great justice
# and don't create ".bundle" in all our apps
ENV GEM_HOME="/home/deploy/.bundle"
ENV BUNDLE_PATH=$GEM_HOME \
	BUNDLE_BIN=$GEM_HOME/bin \
	BUNDLE_SILENCE_ROOT_WARNING=1 \
	BUNDLE_APP_CONFIG=$GEM_HOME \
  BUNDLE_JOBS=4 \
  BUNDLER_VERSION=1.16.3
ENV PATH=$BUNDLE_BIN:$PATH

RUN mkdir -p "$GEM_HOME" "$BUNDLE_BIN" && \
	chmod 777 "$GEM_HOME" "$BUNDLE_BIN" && \
  gem install bundler --no-rdoc --no-ri --version "$BUNDLER_VERSION"

ENV APP_HOME=/home/deploy/current
RUN mkdir -pv $APP_HOME
COPY --chown=deploy Gemfile* $APP_HOME/
ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile
WORKDIR $APP_HOME
RUN bundle install
COPY --chown=deploy ./ $APP_HOME/

EXPOSE 3000
CMD ["scripts/wait-for-it.sh", "db:5432", "--", "scripts/start.sh"]
