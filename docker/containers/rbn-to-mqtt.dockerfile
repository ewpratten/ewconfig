FROM python:3.13
ENV MODE=cw
ENV MQTT_HOST=
COPY ./scripts/rbn-to-mqtt /rbn-to-mqtt
CMD ["python", "/rbn-to-mqtt", "${MODE}", "${MQTT_HOST}"]