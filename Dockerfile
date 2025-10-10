FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install software-properties-common -y && \
    add-apt-repository ppa:git-core/ppa -y && \
    apt install -y git

ADD ["https://github.com/thoughtworks/talisman/releases/download/v1.37.0/talisman_linux_amd64", "/talisman"]
RUN chmod +x /talisman

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
