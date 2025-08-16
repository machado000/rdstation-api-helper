import json
import psycopg2
import os


def lambda_handler(event, context):
    try:
        if isinstance(event.get("body"), str):
            body = json.loads(event["body"])
        else:
            body = event.get("body", event)

        if "leads" not in body or not body["leads"]:
            return {"statusCode": 400, "body": json.dumps({"error": "Campo 'leads' ausente ou vazio"})}

        conn = psycopg2.connect(
            host=os.environ["PGHOST"],
            dbname=os.environ["PGDATABASE"],
            user=os.environ["PGUSER"],
            password=os.environ["PGPASSWORD"],
            port=os.environ.get("PGPORT", 5432)
        )
        cur = conn.cursor()

        for lead in body["leads"]:
            cur.execute("""
                INSERT INTO leads_webhook (
                    lead_id, uuid, email, name, company, job_title, bio, created_at, opportunity,
                    number_conversions, user_email, first_conversion, last_conversion, custom_fields,
                    website, personal_phone, mobile_phone, city, state, lead_stage, tags, fit_score, interest
                ) VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)
            """, (
                lead.get("id"),
                lead.get("uuid"),
                lead.get("email"),
                lead.get("name"),
                lead.get("company"),
                lead.get("job_title"),
                lead.get("bio"),
                lead.get("created_at"),
                lead.get("opportunity") == "true",
                int(lead.get("number_conversions", 0)),
                lead.get("user"),
                json.dumps(lead.get("first_conversion", {})),
                json.dumps(lead.get("last_conversion", {})),
                json.dumps(lead.get("custom_fields", {})),
                lead.get("website"),
                lead.get("personal_phone"),
                lead.get("mobile_phone"),
                lead.get("city"),
                lead.get("state"),
                lead.get("lead_stage"),
                json.dumps(lead.get("tags", [])),
                lead.get("fit_score"),
                int(lead.get("interest", 0))
            ))

        conn.commit()
        cur.close()
        conn.close()

        return {"statusCode": 200, "body": json.dumps({"message": "Leads salvos com sucesso"})}

    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}
