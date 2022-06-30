FROM scratch

# add rootfs
ADD target/rootfs /
ENV PATH=/home/linuxbrew/.linuxbrew/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV HOME=/root

# create root user
RUN touch /etc/passwd
RUN touch /etc/group
RUN addgroup -g 0 root
RUN adduser -D -G root -u 0 root

# login shell
USER root
WORKDIR /root
CMD [ "/bin/nu", "-l" ]
