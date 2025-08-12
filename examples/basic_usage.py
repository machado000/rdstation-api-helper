"""
Basic Facebook Ads Report Example

This example demonstrates the basic usage of the google-ads-drv package
to extract data from Facebook Ads API and export it to CSV.
"""
import logging
import pandas as pd

from datetime import date, timedelta
from dotenv import load_dotenv
from time import sleep

from rdstation_api_helper import RDStationAPI
from rdstation_api_helper.utils import setup_logging, save_to_json_file, append_to_json_file


def main():

    load_dotenv()
    setup_logging(level=logging.INFO)

    rd = RDStationAPI()

    start_date = date.today() - timedelta(days=7)
    end_date = date.today()

    # 1. FETCH AND SAVE SEGMENTATIONS
    all_segmentations = rd.get_segmentations(save_json_file=True)

    # 2. FETCH AND SAVE SEGMENTATIONS CONTACTS
    valid_segmentations = [
        seg for seg in all_segmentations
        if 'updated_at' in seg and start_date <= date.fromisoformat(seg['updated_at'][0:10]) <= end_date
    ]

    contact_data = rd.get_segmentation_contacts(valid_segmentations, limit=125, sleep_time=0.6)

    save_to_json_file(contact_data, "rd_segmentation_contacts.json")

    # 3. FETCH UNIQUE UUIDS
    df = pd.DataFrame(contact_data)
    df = df.drop_duplicates(subset='uuid').reset_index(drop=True)
    print(f"The number of 'segmentation_contacts' uniques uuids is: {df.shape[0]}")

    contacts = df.to_dict(orient='records')

    # 4. FETCH AND UPDATE CONTACTS DATA
    batch_size = 100
    batch_count, total_batches = 0, len(contacts) // batch_size + (1 if len(contacts) % batch_size > 0 else 0)
    row_count, total_rows = 0, len(contacts)

    for batch_count, batch in enumerate(rd.process_in_batches(contacts, batch_size), start=1):
        _, contact_data = rd.get_contact_data_parallel(batch)
        if contact_data:
            append_to_json_file(contact_data, "rd_contact_data.json")

        row_count += len(batch)
        logging.info(f"Progress: {batch_count}/{total_batches} batches, {row_count}/{total_rows} rows processed\n")
        sleep(30)

    # 5. FETCH AND UPDATE CONTACTS EVENTS
    batch_size = 100
    batch_count, total_batches = 0, len(contacts) // batch_size + (1 if len(contacts) % batch_size > 0 else 0)
    row_count, total_rows = 0, len(contacts)

    for batch_count, batch in enumerate(rd.process_in_batches(contacts, batch_size), start=1):
        _, events_data = rd.get_contact_events_parallel(batch)
        if events_data:
            append_to_json_file(events_data, "rd_contact_events.json")

        row_count += len(batch)
        logging.info(f"Progress: {batch_count}/{total_batches} batches, {row_count}/{total_rows} rows processed\n")
        sleep(30)

    # 6. FETCH AND UPDATE CONTACTS FUNNEL STATUS
    batch_size = 100
    batch_count, total_batches = 0, len(contacts) // batch_size + (1 if len(contacts) % batch_size > 0 else 0)
    row_count, total_rows = 0, len(contacts)

    for batch_count, batch in enumerate(rd.process_in_batches(contacts, batch_size), start=1):
        _, funnel_status_data = rd.get_contact_funnel_status_parallel(batch)
        if funnel_status_data:
            append_to_json_file(funnel_status_data, "rd_contact_funnel_status.json")

        row_count += len(batch)
        logging.info(f"Progress: {batch_count}/{total_batches} batches, {row_count}/{total_rows} rows processed\n")
        sleep(30)


if __name__ == "__main__":
    main()
