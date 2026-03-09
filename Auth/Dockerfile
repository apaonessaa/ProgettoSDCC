FROM quay.io/keycloak/keycloak:latest

# Bootstrap Keycloak admin
ENV KC_BOOTSTRAP_ADMIN_USERNAME=keycloak-admin
ENV KC_BOOTSTRAP_ADMIN_PASSWORD=Password123!

EXPOSE 8080

ENTRYPOINT ["/opt/keycloak/bin/kc.sh", "start-dev"]
