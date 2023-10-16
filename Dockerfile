FROM container-registry.oracle.com/os/oraclelinux:6

RUN yum -y install oracle-softwarecollection-release-el6 && \
    yum -y install \
        rh-python36 \
        devtoolset-8-gcc-c++ && \
    yum clean all && rm -rf /var/cache/yum

ENV PATH=/opt/rh/rh-python36/root/usr/bin:/opt/rh/devtoolset-8/root/usr/bin:$PATH

RUN python3 -m pip install pip --upgrade && \
    python3 -m pip install conan cmake ninja

RUN conan profile detect

COPY repro.sh /root/repro.sh

CMD ["/bin/bash", "/root/repro.sh"]

