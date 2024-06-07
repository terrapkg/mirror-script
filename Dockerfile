# A simple Dockerfile in case one wants to run this as a container :P
FROM registry.access.redhat.com/ubi9/ubi-minimal

LABEL maintainer="Cappy Ishihara <cappy@fyralabs.com>"
LABEL description="A simple container to mirror the Fyra Labs repositories."

# enable EPEL

RUN rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm

RUN microdnf install -y rsync openssh-clients rclone && microdnf clean all -y

ENV MIRROR_DIR /data

VOLUME /data

COPY mirror.sh /mirror.sh

ENTRYPOINT ["/mirror.sh"]
