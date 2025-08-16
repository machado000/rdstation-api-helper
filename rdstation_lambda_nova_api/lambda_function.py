import json
import psycopg2
import os

REQUIRED_FIELDS = ["event_type", "entity_type", "event_identifier", "timestamp", "event_timestamp"]


def lambda_handler(event, context):
    try:
        if isinstance(event.get("body"), str):
            # Real webhook from API Gateway
            body = json.loads(event["body"])
        elif "event_type" in event:
            # Direct test payload
            body = event
        else:
            # Fallback - might be wrapped in body
            body = event.get("body", event)

        # Validar campos obrigatórios
        missing = [f for f in REQUIRED_FIELDS if f not in body or body[f] is None]
        if missing:
            return {
                "statusCode": 400,
                "body": json.dumps({"error": f"Campos obrigatórios ausentes: {', '.join(missing)}"})
            }

        # Conectar ao Postgres
        conn = psycopg2.connect(
            host=os.environ["PGHOST"],
            dbname=os.environ["PGDATABASE"],
            user=os.environ["PGUSER"],
            password=os.environ["PGPASSWORD"],
            port=os.environ.get("PGPORT", 5432)
        )
        cur = conn.cursor()

        # Inserir no banco
        cur.execute("""
            INSERT INTO rd_webhooks (
                event_type, entity_type, event_identifier, "timestamp", event_timestamp, contato
            )
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            body["event_type"],
            body["entity_type"],
            body["event_identifier"],
            body["timestamp"],
            body["event_timestamp"],
            json.dumps(body.get("contact", {}))
        ))

        conn.commit()
        cur.close()
        conn.close()

        return {
            "statusCode": 200,
            "body": json.dumps({"message": "Webhook salvo com sucesso"})
        }

    except Exception as e:
        return {
            "statusCode": 500,
            "body": json.dumps({"error": str(e)})
        }
