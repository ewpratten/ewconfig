FROM python:3.13

# External config
ENV MODE=cw
ENV MQTT_HOST=

# Dependencies
RUN pip install paho-mqtt

# The script itself
COPY ./scripts/rbn-to-mqtt /rbn-to-mqtt

# Run config
CMD ["python", "/rbn-to-mqtt", "${MODE}", "${MQTT_HOST}"]