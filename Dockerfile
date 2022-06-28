FROM scratch

ADD target/rootfs/* /

ENTRYPOINT [ "/init" ]
