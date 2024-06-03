FROM node:18 as keycloakify_jar_builder
RUN apt-get update && \
    apt-get install -y openjdk-17-jdk && \
    apt-get install -y maven;
COPY ./keycloakify/package.json ./keycloakify/yarn.lock /opt/app/
WORKDIR /opt/app
RUN yarn install --frozen-lockfile
COPY ./keycloakify/ /opt/app/
RUN yarn build-keycloak-theme

FROM quay.io/keycloak/keycloak:latest as builder
WORKDIR /opt/keycloak
# NOTE: If you are using a version of Keycloak prior to 23 you must use 
# the retrocompat-*.jar. Look inside your target directory there is two jars file
# one *.jar and the other retrocompat-*.jar
COPY --from=keycloakify_jar_builder /opt/app/dist_keycloak/target/retrocompat-*.jar /opt/keycloak/providers/
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/