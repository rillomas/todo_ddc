FROM google/dart

WORKDIR /app

# install npm and bower
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash && apt-get install --no-install-recommends -y -q nodejs
RUN npm install --global bower
RUN echo '{ "allow_root": true }' > /root/.bowerrc

COPY pubspec.* local_package /app/
RUN pub get
ADD . /app
RUN pub get --offline

ENTRYPOINT ["pub", "serve"]
