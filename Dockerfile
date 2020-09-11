FROM alpine

ADD . /opt/ldap-passwd-webui
WORKDIR /opt/ldap-passwd-webui
RUN apk add py3-pip py3-waitress \
    && pip install -r requirements.txt

ENTRYPOINT [ "/opt/ldap-passwd-webui/entrypoint.sh" ]
CMD [ "run" ]