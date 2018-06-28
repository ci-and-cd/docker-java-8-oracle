
FROM alpine:3.7

MAINTAINER haolun


ARG IMAGE_ARG_ALPINE_MIRROR
ARG IMAGE_ARG_FILESERVER

# http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz
# http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jdk-8u172-linux-x64.tar.gz
ARG IMAGE_ARG_JAVA8_VERSION_MINOR
ARG IMAGE_ARG_JAVA8_VERSION_BUILD
ARG IMAGE_ARG_JAVA8_PACKAGE
ARG IMAGE_ARG_JAVA8_PACKAGE_DIGEST


ENV ARIA2C_DOWNLOAD aria2c --file-allocation=none -c -x 10 -s 10 -m 0 --console-log-level=notice --log-level=notice --summary-interval=0
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle



COPY --from=cirepo/alpine-glibc:3.7_2.23-r3 /data/layer.tar /data/layer.tar
RUN tar xf /data/layer.tar -C /


RUN set -ex \
    && echo ===== Install tools ===== \
    && touch /etc/apk/repositories \
    && echo "https://${IMAGE_ARG_ALPINE_MIRROR:-dl-3.alpinelinux.org}/alpine/v3.7/main" > /etc/apk/repositories \
    && echo "https://${IMAGE_ARG_ALPINE_MIRROR:-dl-3.alpinelinux.org}/alpine/v3.7/community" >> /etc/apk/repositories \
    && echo "https://${IMAGE_ARG_ALPINE_MIRROR:-dl-3.alpinelinux.org}/alpine/edge/testing/" >> /etc/apk/repositories \
    && apk add --update aria2 \
    && echo ===== Install JDK8 ===== \
    && mkdir -p $(dirname ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}) \
        && ${ARIA2C_DOWNLOAD} --header="Cookie: oraclelicense=accept-securebackup-cookie" \
        -o ${IMAGE_ARG_JAVA8_PACKAGE:-jdk}.tar.gz \
        ${IMAGE_ARG_FILESERVER:-http://download.oracle.com}/otn-pub/java/jdk/8u${IMAGE_ARG_JAVA8_VERSION_MINOR:-171}-b${IMAGE_ARG_JAVA8_VERSION_BUILD:-11}/${IMAGE_ARG_JAVA8_PACKAGE_DIGEST:-512cd62ec5174c3487ac17c61aaa89e8}/${IMAGE_ARG_JAVA8_PACKAGE:-jdk}-8u${IMAGE_ARG_JAVA8_VERSION_MINOR:-171}-linux-x64.tar.gz \
        && tar -xzf ${IMAGE_ARG_JAVA8_PACKAGE:-jdk}.tar.gz -C $(dirname ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}) \
        && rm -f ${IMAGE_ARG_JAVA8_PACKAGE:-jdk}.tar.gz \
        && mv $(dirname ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle})/jdk1.8.0_${IMAGE_ARG_JAVA8_VERSION_MINOR:-171} ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle} \
        && rm -rf ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/*src.zip \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/lib/missioncontrol \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/lib/visualvm \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/lib/*javafx* \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/plugin.jar \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/ext/jfxrt.jar \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/bin/javaws \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/javaws.jar \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/desktop \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/plugin \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/deploy* \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/*javafx* \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/*jfx* \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/amd64/libdecora_sse.so \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/amd64/libprism_*.so \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/amd64/libfxplugins.so \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/amd64/libglass.so \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/amd64/libgstreamer-lite.so \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/amd64/libjavafx*.so \
               ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/amd64/libjfx*.so \
    && POLICY_DIR="UnlimitedJCEPolicyJDK8" \
    && ${ARIA2C_DOWNLOAD} --header="oraclelicense=accept-securebackup-cookie" \
    -o policy.zip ${IMAGE_ARG_FILESERVER:-http://download.oracle.com}/otn-pub/java/jce/8/jce_policy-8.zip \
    && unzip policy.zip \
    && cp -f ${POLICY_DIR}/US_export_policy.jar ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/security/US_export_policy.jar \
    && cp -f ${POLICY_DIR}/local_policy.jar ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/security/local_policy.jar \
    && rm -rf ${POLICY_DIR} \
    && rm -f policy.zip \
    && rm -rf /tmp/* /var/cache/apk/*

## Install OpenJDK 8 (latest edition)
#RUN apt-get -q update &&\
#    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew" --no-install-recommends openjdk-8-jdk-headless &&\
#    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

ENV PATH ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/bin:${PATH}
