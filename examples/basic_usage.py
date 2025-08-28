"""
Basic RD Station API Helper Example

This example demonstrates the basic usage of the rdstation-api-helper package
to extract data from RD Station API and save it as JSON or SQL Table.
"""
import logging

from datetime import date, timedelta  # noqa
from dotenv import load_dotenv
from time import sleep

from rdstation_api_helper import RDStationAPI, setup_logging
from rdstation_api_helper.dataclasses import Segmentation, SegmentationContact, ContactFunnelStatus, Contact, ConversionEvents  # noqa
from rdstation_api_helper.utils import PostgresDB


def main():

    load_dotenv()
    setup_logging(level=logging.INFO)

    pgsql = PostgresDB()
    rd = RDStationAPI()

    # Set up date range for fetching data
    start_date = date.today() - timedelta(days=1)  # noqa
    end_date = date.today()  # noqa
    start_date_str = start_date.isoformat()
    end_date_str = end_date.isoformat()

    # 1. LIST NEW UUIDs ON WEBHOOK EVENTS
    new_events = rd.get_webhook_events(start_date_str, end_date_str, engine=pgsql.engine)
    new_uuids = list({event['uuid'] for event in new_events if 'uuid' in event})
    contacts = new_uuids

    if not contacts:
        logging.info(f"No new UUIDs found in webhook events between {start_date_str} and {end_date_str}.")
        return

    logging.info(f"Found {len(new_uuids)} new UUIDs from webhook events between {start_date_str} and {end_date_str}.")

    # 2. FETCH AND UPDATE CONTACTS DATA

    # Process contacts in batches
    batch_size = 100
    batch_count, total_batches = 0, len(contacts) // batch_size + (1 if len(contacts) % batch_size > 0 else 0)
    row_count, total_rows = 0, len(contacts)

    for batch_count, batch in enumerate(rd.process_in_batches(contacts, batch_size), start=1):
        _, contact_data = rd.get_contact_data_parallel(batch)
        if contact_data:
            pgsql.save_to_sql(contact_data, Contact, upsert_values=True)

        row_count += len(batch)
        logging.info(f"Progress: {batch_count}/{total_batches} batches, {row_count}/{total_rows} rows processed\n")
        sleep(30)

    # 3. FETCH AND UPDATE CONTACTS EVENTS

    # Process contacts in batches
    batch_size = 100
    batch_count, total_batches = 0, len(contacts) // batch_size + (1 if len(contacts) % batch_size > 0 else 0)
    row_count, total_rows = 0, len(contacts)

    for batch_count, batch in enumerate(rd.process_in_batches(contacts, batch_size), start=1):
        _, events_data = rd.get_contact_events_parallel(batch)
        if events_data:
            pgsql.save_to_sql(events_data, ConversionEvents, upsert_values=True)

        row_count += len(batch)
        logging.info(f"Progress: {batch_count}/{total_batches} batches, {row_count}/{total_rows} rows processed\n")
        sleep(30)

    # 4. FETCH AND UPDATE CONTACTS FUNNEL STATUS

    # Process contacts in batches
    batch_size = 100
    batch_count, total_batches = 0, len(contacts) // batch_size + (1 if len(contacts) % batch_size > 0 else 0)
    row_count, total_rows = 0, len(contacts)

    for batch_count, batch in enumerate(rd.process_in_batches(contacts, batch_size), start=1):
        _, funnel_status_data = rd.get_contact_funnel_status_parallel(batch)
        if funnel_status_data:
            pgsql.save_to_sql(funnel_status_data, ContactFunnelStatus, upsert_values=True)

        row_count += len(batch)
        logging.info(f"Progress: {batch_count}/{total_batches} batches, {row_count}/{total_rows} rows processed\n")
        sleep(30)

    # 5. FETCH AND SAVE SEGMENTATIONS
    all_segmentations = rd.get_segmentations(save_json_file=False)

    pgsql.save_to_sql(all_segmentations, Segmentation, upsert_values=True)

    # 6. FETCH AND SAVE SEGMENTATIONS CONTACTS
    exclude_list = ["exemplo", "excluir", "teste", "Todos os contatos da base de Leads"]

    valid_segmentations = [
        seg for seg in all_segmentations
        if not any(pattern.lower() in seg['name'].lower() for pattern in exclude_list)
    ]

    date_range_segmentations = [
        seg for seg in valid_segmentations
        if 'updated_at' in seg and start_date <= date.fromisoformat(seg['updated_at'][0:10]) <= end_date
    ]

    contacts = rd.get_segmentation_contacts(date_range_segmentations, limit=125, sleep_time=0.6, save_json_file=False)

    pgsql.save_to_sql(contacts, SegmentationContact, upsert_values=True)


if __name__ == "__main__":
    main()
