FROM scratch

ADD target/rootfs /

ENV PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
CMD [ "/bin/init" ]
