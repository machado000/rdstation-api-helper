"""
Basic RD Station API Helper Example

This example demonstrates the basic usage of the rdstation-api-helper package
to extract data from RD Station API and save it as JSON or SQL Table.
"""
import logging
import pandas as pd

from datetime import date, timedelta  # noqa
from dotenv import load_dotenv
from time import sleep

from rdstation_api_helper import RDStationAPI
from rdstation_api_helper.dataclasses import Segmentation, SegmentationContact, ContactFunnelStatus, Contact, ConversionEvents  # noqa
from rdstation_api_helper.utils import PostgresDB, setup_logging


def main():

    load_dotenv()
    setup_logging(level=logging.INFO)

    pgsql = PostgresDB()
    rd = RDStationAPI()

    start_date, end_date = date.today() - timedelta(days=90), date.today()  # noqa

    # 1. FETCH AND SAVE SEGMENTATIONS
    all_segmentations = rd.get_segmentations(save_json_file=True)

    pgsql.save_to_sql(all_segmentations, Segmentation, upsert_values=True)

    # 2. FETCH AND SAVE SEGMENTATIONS CONTACTS
    exclude_list = ["exemplo", "excluir", "teste", "Todos os contatos da base de Leads"]

    valid_segmentations = [
        seg for seg in all_segmentations
        if not any(pattern.lower() in seg['name'].lower() for pattern in exclude_list)
    ]

    date_range_segmentations = [
        seg for seg in valid_segmentations
        if 'updated_at' in seg and start_date <= date.fromisoformat(seg['updated_at'][0:10]) <= end_date
    ]

    contacts = rd.get_segmentation_contacts(date_range_segmentations, limit=125, sleep_time=0.6, save_json_file=True)

    pgsql.save_to_sql(contacts, SegmentationContact, upsert_values=True)

    # 3. FETCH UNIQUE UUIDS

    df = pd.DataFrame(contacts)
    df_1 = df[['uuid']].drop_duplicates().reset_index(drop=True)
    # df_1 = pd.read_sql_table('v_segmentation_contacts_unique', engine, columns=['uuid'])

    contacts = df_1['uuid'].to_list()
    logging.info(f"The number of 'segmentation_contacts' uniques uuids is: {len(contacts)}")

    # 4. FETCH AND UPDATE CONTACTS DATA

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

    # 5. FETCH AND UPDATE CONTACTS EVENTS

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

    # 6. FETCH AND UPDATE CONTACTS FUNNEL STATUS

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


if __name__ == "__main__":
    main()
