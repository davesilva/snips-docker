FROM debian:stretch-slim

RUN groupadd --gid 99 snips \
  && useradd --gid 99 --uid 99 --system snips

RUN sed -i "s#main#main non-free#g" /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y dirmngr apt-transport-https

RUN echo "deb [arch=amd64] https://debian.snips.ai/stretch stable main\n \
          deb [arch=armhf] https://raspbian.snips.ai/stretch stable main" \
          > /etc/apt/sources.list.d/snips.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F727C778CCB0A455 && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D4F50CDCA10A2849 && \
  apt-get update && \
  apt-get install -y snips-platform-voice snips-tts snips-pegasus snips-watch

RUN mkdir -p /usr/share/snips && \
  chown -R snips /usr/share/snips && \
  mkdir -p /var/lib/snips && \
  chown -R snips /var/lib/snips

COPY --chown=snips default-snips.toml /etc/snips.toml

USER snips
