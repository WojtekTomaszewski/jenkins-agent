FROM docker.io/jenkins/inbound-agent:latest

USER 0
WORKDIR /tmp

ARG S6_OVERLAY_VERSION=3.1.5.0
ARG buildkit=buildkit-v0.12.2.linux-amd64.tar.gz

ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz /tmp
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
ADD https://github.com/moby/buildkit/releases/download/v0.12.2/${buildkit} /tmp

RUN apt update; apt install -y runc xz-utils procps
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
RUN tar xvf /tmp/${buildkit}; ls -l /tmp; mv /tmp/bin/buildkitd /tmp/bin/buildctl /usr/local/bin

COPY s6-overlay/buildkitd /etc/s6-overlay/s6-rc.d/buildkitd/
COPY s6-overlay/jenkins-agent /etc/s6-overlay/s6-rc.d/jenkins-agent/
COPY s6-overlay/users /etc/s6-overlay/s6-rc.d/user/


WORKDIR /home/jenkins
ENTRYPOINT ["/init"]