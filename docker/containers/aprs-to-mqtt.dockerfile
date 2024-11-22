FROM python:3.13

# External config
ENV MQTT_HOST=

# Dependencies
RUN pip install paho-mqtt

# The script itself
COPY ./scripts/aprs-to-mqtt /aprs-to-mqtt.py

# Run config
CMD ["sh", "-c", "python /aprs-to-mqtt.py $MQTT_HOST"]