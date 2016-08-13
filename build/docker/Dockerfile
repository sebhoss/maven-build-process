FROM maven:3.3.9-jdk-8
MAINTAINER Sebastian Hoß (mail@shoss.de)

# TODO: https://github.com/docker/hub-feedback/issues/292

RUN mkdir -p /code && \
    mkdir -p /config && \
    mkdir -p /repository && \
    mkdir -p /project

VOLUME /project

COPY build/docker/settings.xml /config/

COPY pom.xml /code/
COPY maven-parents/pom.xml /code/maven-parents/
COPY maven-parents/maven-parents-superpom/pom.xml /code/maven-parents/maven-parents-superpom/
COPY maven-parents/maven-parents-java/pom.xml /code/maven-parents/maven-parents-java/
COPY maven-parents/maven-parents-java/pom.xml /code/maven-parents/maven-parents-java/
COPY maven-parents/maven-parents-java/pom.xml /code/maven-parents/maven-parents-java/
COPY maven-parents/maven-parents-java/maven-parents-java-prototype/pom.xml /code/maven-parents/maven-parents-java/maven-parents-java-prototype/
COPY maven-parents/maven-parents-java/maven-parents-java-stable/pom.xml /code/maven-parents/maven-parents-java/maven-parents-java-stable/
COPY maven-boms/pom.xml /code/maven-boms/
COPY maven-boms/maven-boms-all/pom.xml /code/maven-boms/maven-boms-all/
COPY maven-boms/maven-boms-aspect/pom.xml /code/maven-boms/maven-boms-aspect/
COPY maven-boms/maven-boms-bytecode/pom.xml /code/maven-boms/maven-boms-bytecode/
COPY maven-boms/maven-boms-camel/pom.xml /code/maven-boms/maven-boms-camel/
COPY maven-boms/maven-boms-database/pom.xml /code/maven-boms/maven-boms-database/
COPY maven-boms/maven-boms-eclipse/pom.xml /code/maven-boms/maven-boms-eclipse/
COPY maven-boms/maven-boms-google/pom.xml /code/maven-boms/maven-boms-google/
COPY maven-boms/maven-boms-javax/pom.xml /code/maven-boms/maven-boms-javax/
COPY maven-boms/maven-boms-json/pom.xml /code/maven-boms/maven-boms-json/
COPY maven-boms/maven-boms-maven/pom.xml /code/maven-boms/maven-boms-maven/
COPY maven-boms/maven-boms-pax/pom.xml /code/maven-boms/maven-boms-pax/
COPY maven-boms/maven-boms-scripting/pom.xml /code/maven-boms/maven-boms-scripting/
COPY maven-boms/maven-boms-sebhoss/pom.xml /code/maven-boms/maven-boms-sebhoss/
COPY maven-boms/maven-boms-square/pom.xml /code/maven-boms/maven-boms-square/
COPY maven-boms/maven-boms-testing/pom.xml /code/maven-boms/maven-boms-testing/
COPY maven-boms/maven-boms-wikitext/pom.xml /code/maven-boms/maven-boms-wikitext/
COPY maven-boms/maven-boms-yaml/pom.xml /code/maven-boms/maven-boms-yaml/

WORKDIR /code

ARG NEXUS_HOST
ENV NEXUS_HOST ${NEXUS_HOST:-}

RUN [ -n "${NEXUS_HOST}" ] && \
    echo "${NEXUS_HOST} local-nexus" >> /etc/hosts && \
    mvn dependency:go-offline \
        --settings /config/settings.xml \
        -Dmaven.repo.local=/repository
