/*
	This SQL file defines the schema and structure for tables used by the RD Station API Helper project.
	It is intended to store, organize, and manage data related to RD Station API integrations,
	such as leads, events, and synchronization metadata.
*/


-- Table structure for table "rd_segmentations"
CREATE TABLE public.rd_segmentations (
	id text NOT NULL,
	"name" text NULL,
	standard bool NULL,
	created_at timestamp NULL,
	updated_at timestamp NULL,
	process_status text NULL,
	links json NULL,
	last_update timestamp DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NULL,
	CONSTRAINT rd_segmentations_pk PRIMARY KEY (id)
);

-- Table structure for table "rd_segmentation_contacts"
CREATE TABLE public.rd_segmentation_contacts (
	"uuid" uuid NOT NULL,
	"name" varchar(255) NULL,
	email varchar(255) NULL,
	last_conversion_date timestamp NULL,
	created_at timestamp NULL,
	links json NULL,
	segmentation_id text NOT NULL,
	segmentation_name text NULL,
	last_update timestamp DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NULL,
	business_unit text NULL,
	k text NULL,
	CONSTRAINT rd_segmentation_contacts_pk PRIMARY KEY (uuid, segmentation_id)
);

-- Table structure for table "rd_contacts"
CREATE TABLE public.rd_contacts (
	"uuid" uuid NOT NULL,
	email text NOT NULL,
	"name" text NULL,
	state text NULL,
	city text NULL,
	mobile_phone text NULL,
	personal_phone text NULL,
	tags jsonb NULL,
	legal_bases jsonb NULL,
	links jsonb NULL,
	business_unit text NULL,
	cf_especialidade_ls text NULL,
	cf_especie_ls text NULL,
	cf_exame_ls text NULL,
	cf_especialidade text NULL,
	cf_especie text NULL,
	cf_exame text NULL,
	cf_tipo_de_atendimento text NULL,
	cf_bu text NULL,
	cf_utm_source text NULL,
	cf_utm_medium text NULL,
	cf_utm_campaign text NULL,
	cf_id_do_lead text NULL,
	cf_origem_do_lead text NULL,
	cf_ultima_atualizacao text NULL,
	cf_plug_contact_owner text NULL,
	cf_plug_opportunity_origin text NULL,
	cf_plug_funnel_stage text NULL,
	cf_plug_deal_pipeline text NULL,
	cf_plug_lost_reason text NULL,
	last_update timestamp DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NULL,
	CONSTRAINT rd_contacts_pk PRIMARY KEY (uuid)
);

-- Table structure for table "rd_conversion_events"
CREATE TABLE public.rd_conversion_events (
	"uuid" uuid NOT NULL,
	event_type text NOT NULL,
	event_family text NULL,
	event_identifier text NULL,
	event_timestamp timestamptz NOT NULL,
	payload jsonb NULL,
	traffic_source jsonb NULL,
	utm_source text NULL,
	utm_medium text NULL,
	utm_campaign text NULL,
	utm_term text NULL,
	utm_content text NULL,
	tags jsonb NULL,
	last_update timestamp DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NULL,
	CONSTRAINT rd_conversion_events_pk PRIMARY KEY (uuid, event_type, event_timestamp)
);

-- Table structure for table "rd_contact_funnel_status" 
CREATE TABLE public.rd_contact_funnel_status (
	"uuid" uuid NOT NULL,
	lifecycle_stage varchar(50) NULL,
	opportunity bool NULL,
	contact_owner_email varchar(255) NULL,
	interest int4 NULL,
	fit int4 NULL,
	origin varchar(255) NULL,
    last_update timestamp NULL,
	CONSTRAINT rd_funnel_status_pkey PRIMARY KEY (uuid)
);

-- View structure for view "v_segmentation_contacts_unique"
CREATE OR REPLACE VIEW public.v_segmentation_contacts_unique
AS SELECT DISTINCT uuid,
    name,
    email
   FROM rd_segmentation_contacts;


-- Functions and Triggers for updating timestamp columns
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.updated_at = timezone('Brazil/East', CURRENT_TIMESTAMP);
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_last_update_column()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.last_update = timezone('Brazil/East', CURRENT_TIMESTAMP);
  RETURN NEW;
END;
$function$
;

CREATE OR REPLACE TRIGGER set_last_update
BEFORE UPDATE ON public.meta_ads_metrics
FOR EACH ROW
EXECUTE FUNCTION update_last_update_column();