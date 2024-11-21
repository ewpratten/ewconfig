FROM python:3.13

# External config
ENV MODE=cw
ENV MQTT_HOST=

# Dependencies
RUN pip install paho-mqtt

# The script itself
COPY ./scripts/rbn-to-mqtt /rbn-to-mqtt.py

# Run config
CMD ["sh", "-c", "python /rbn-to-mqtt.py $MODE $MQTT_HOST"]