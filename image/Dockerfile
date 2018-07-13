
FROM cirepo/nix:2.0.4-alpine-3.7


USER root


ARG IMAGE_ARG_FILESERVER

# http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
# http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.tar.gz
# http://download.oracle.com/otn-pub/java/jdk/8u172-b11/a58eab1ec242421181065cdc37240b08/jdk-8u172-linux-x64.tar.gz
# jdk-8u171-linux-x64.tar.gz sha256: b6dd2837efaaec4109b36cfbb94a774db100029f98b0d78be68c27bec0275982 #sha256sum -c /data/jdk-8u171-linux-x64.tar.gz.sha256
# http://ftp.osuosl.org/pub/funtoo/distfiles/oracle-java/
# http://funtoo.neu.edu.cn/funtoo/distfiles/oracle-java/
ARG IMAGE_ARG_JAVA8_VERSION_MINOR
ARG IMAGE_ARG_JAVA8_VERSION_BUILD
ARG IMAGE_ARG_JAVA8_PACKAGE
ARG IMAGE_ARG_JAVA8_PACKAGE_DIGEST


ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH=${JAVA_HOME}/bin:${PATH}


COPY --from=cirepo/glibc:2.23-r3-alpine-3.7-archive /data/root /


COPY --chown=root:root docker /data


RUN set -ex \
  && echo ===== Install JDK8 ===== \
  && mkdir -p $(dirname ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}) \
  && if [ ! -f /data/${IMAGE_ARG_JAVA8_PACKAGE:-jdk}-8u${IMAGE_ARG_JAVA8_VERSION_MINOR:-171}-linux-x64.tar.gz ]; then \
       ${ARIA2C_DOWNLOAD} --header="Cookie: oraclelicense=accept-securebackup-cookie" \
       -d /data -o ${IMAGE_ARG_JAVA8_PACKAGE:-jdk}-8u${IMAGE_ARG_JAVA8_VERSION_MINOR:-171}-linux-x64.tar.gz \
       ${IMAGE_ARG_FILESERVER:-http://download.oracle.com}/otn-pub/java/jdk/8u${IMAGE_ARG_JAVA8_VERSION_MINOR:-171}-b${IMAGE_ARG_JAVA8_VERSION_BUILD:-11}/${IMAGE_ARG_JAVA8_PACKAGE_DIGEST:-512cd62ec5174c3487ac17c61aaa89e8}/${IMAGE_ARG_JAVA8_PACKAGE:-jdk}-8u${IMAGE_ARG_JAVA8_VERSION_MINOR:-171}-linux-x64.tar.gz; \
     fi \
  && tar -xzf /data/${IMAGE_ARG_JAVA8_PACKAGE:-jdk}-8u${IMAGE_ARG_JAVA8_VERSION_MINOR:-171}-linux-x64.tar.gz -C $(dirname ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}) \
  && rm -f /data/${IMAGE_ARG_JAVA8_PACKAGE:-jdk}-8u${IMAGE_ARG_JAVA8_VERSION_MINOR:-171}-linux-x64.tar.gz \
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
  && JAVA_VERSION=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}') \
  && echo OSX style JAVA_HOME is /Library/Java/JavaVirtualMachines/jdk${JAVA_VERSION}.jdk/Contents/Home \
  && mkdir -p /Library/Java/JavaVirtualMachines/jdk${JAVA_VERSION}.jdk/Contents \
  && ln -s ${JAVA_HOME} /Library/Java/JavaVirtualMachines/jdk${JAVA_VERSION}.jdk/Contents/Home \
  && echo AppVeyor style JAVA_HOME \
  && ln -s ${JAVA_HOME} /usr/lib/jvm/java-8-openjdk-amd64 \
  && POLICY_DIR="UnlimitedJCEPolicyJDK8" \
  && if [ ! -f /data/jce_policy-8.zip ]; then \
       ${ARIA2C_DOWNLOAD} --header="Cookie: oraclelicense=accept-securebackup-cookie" \
       -d /data -o jce_policy-8.zip ${IMAGE_ARG_FILESERVER:-http://download.oracle.com}/otn-pub/java/jce/8/jce_policy-8.zip; \
     fi \
  && unzip /data/jce_policy-8.zip \
  && cp -f ${POLICY_DIR}/US_export_policy.jar ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/security/US_export_policy.jar \
  && cp -f ${POLICY_DIR}/local_policy.jar ${JAVA_HOME:-/usr/lib/jvm/java-8-oracle}/jre/lib/security/local_policy.jar \
  && rm -rf ${POLICY_DIR} \
  && rm -f /data/jce_policy-8.zip \
  && rm -rf /tmp/* /var/cache/apk/*

## Install OpenJDK 8 (latest edition)
#RUN apt-get -q update &&\
#    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew" --no-install-recommends openjdk-8-jdk-headless &&\
#    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin


USER alpine
