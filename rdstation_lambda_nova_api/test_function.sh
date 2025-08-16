#FUNCTION_URL=https://mvz34gvfiwgy5geogovsnooo7u0jevvu.lambda-url.us-east-1.on.aws/

curl -XPOST "https://mvz34gvfiwgy5geogovsnooo7u0jevvu.lambda-url.us-east-1.on.aws/" \
-H "Content-Type: application/json" \
-d '{"event_type": "WEBHOOK.CONVERTED","entity_type": "CONTACT","event_identifier": "test","timestamp": "2025-08-15T00:00:00Z","event_timestamp": "2025-08-15T00:00:00Z"}'
