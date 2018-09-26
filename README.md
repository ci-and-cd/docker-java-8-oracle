# docker-java-8-oracle

Smaller Oracle JDK8 with `Java Cryptography Extension (JCE) Unlimited Strength Jurisdiction Policy Files` on alpine linux
see: [Smaller Java images with Alpine Linux](https://developer.atlassian.com/blog/2015/08/minimal-java-docker-containers/)

Oracle JDK8 installed at `/usr/lib/jvm/java-8-oracle` (travis-ci style JAVA_HOME)


Dockerfile [ci-and-cd/docker-java-8-oracle on Github](https://github.com/ci-and-cd/docker-java-8-oracle)

[cirepo/java-oracle on Docker Hub](https://hub.docker.com/r/cirepo/java-oracle/)


The main caveat to note is that it does use musl libc instead of glibc and friends,
so certain software might run into issues depending on the depth of their libc requirements.
However, most software doesn't have an issue with this,
so this variant is usually a very safe choice.


## Use this image as a “stage” in multi-stage builds

```dockerfile

FROM alpine:3.7
COPY --from=cirepo/glibc:2.23-r3-alpine-3.8-archive /data/root /
COPY --from=cirepo/java-oracle:8u181-alpine-3.8-archive /data/root/usr/lib/jvm/java-8-oracle /usr/lib/jvm/java-8-oracle

```
