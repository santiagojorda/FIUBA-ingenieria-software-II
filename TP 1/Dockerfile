FROM ruby:3.1.2
ARG GIT_COMMIT=undefined
LABEL GIT_COMMIT=$GIT_COMMIT
LABEL AUTHOR=NicoPaez
RUN mkdir /jobvacancy
WORKDIR /jobvacancy
COPY . /jobvacancy
RUN bundler install --without development test
RUN useradd -m jobvacancy
RUN chown -R jobvacancy:jobvacancy /jobvacancy
USER jobvacancy
CMD ["/jobvacancy/start_app.sh"]
