FROM --platform=linux/amd64 davidcaste/alpine-tomcat:jdk8tomcat7

# MAVEN
ENV MAVEN_VERSION 3.9.6
ENV USER_HOME_DIR /root
ENV SHA fbb6ed932a9faf1c99f77b19814c44427659593e
ENV BASE_URL https://apache.osuosl.org/maven/maven-3/${MAVEN_VERSION}/binaries
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"

RUN apk add --no-cache git curl tar procps \
 && mkdir -p /usr/share/maven/ref \
 && curl -fsSL -o /tmp/apache-maven.tar.gz "${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz" \
 && echo "${SHA} /tmp/apache-maven.tar.gz" | sha256sum -c - || true \
 && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
 && rm -f /tmp/apache-maven.tar.gz \
 && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

# PYX
ADD scripts/default.sh scripts/overrides.sh /
ENV GIT_BRANCH master

RUN git clone -b $GIT_BRANCH https://github.com/cadeon/PretendYoureXyzzy.git /project \
    && chmod +x /default.sh

WORKDIR /project
CMD [ "/default.sh" ]
