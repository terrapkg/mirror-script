# A simple Dockerfile in case one wants to run this as a container :P
FROM registry.access.redhat.com/ubi9/ubi-minimal

RUN microdnf install -y rsync openssh-clients && microdnf clean all -y

ENV MIRROR_DIR /data

VOLUME /data

COPY mirror.sh /mirror.sh

ENTRYPOINT ["/mirror.sh"]
