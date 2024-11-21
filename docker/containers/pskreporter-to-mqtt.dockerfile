FROM python:3.13

# External config
ENV MQTT_HOST=

# Dependencies
RUN pip install paho-mqtt

# The script itself
COPY ./scripts/pskreporter-to-mqtt /pskreporter-to-mqtt.py

# Run config
CMD ["sh", "-c", "python /pskreporter-to-mqtt.py $MQTT_HOST"]