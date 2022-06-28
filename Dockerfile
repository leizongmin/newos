FROM scratch

ADD target/rootfs /

CMD [ "/bin/init" ]
