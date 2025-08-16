/*
	This SQL file defines the schema and structure for tables used by the RD Station API Helper project.
	It is intended to store, organize, and manage data related to RD Station API integrations,
	such as leads, events, and synchronization metadata.
*/

--------------------------------------------------------------------------------
-- CREATE REQUIRED TABLES
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- public.rd_segmentations definition
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
-- Table Triggers
CREATE TRIGGER set_last_update BEFORE
UPDATE
    ON
    public.rd_segmentations FOR EACH ROW EXECUTE FUNCTION update_last_update_column();

--------------------------------------------------------------------------------
-- public.rd_segmentation_contacts definition
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
-- Table Triggers
CREATE TRIGGER set_last_update BEFORE
UPDATE
    ON
    public.rd_segmentation_contacts FOR EACH ROW EXECUTE FUNCTION update_last_update_column();

--------------------------------------------------------------------------------
-- public.rd_contacts definition
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
-- Table Triggers
CREATE TRIGGER set_last_update BEFORE
UPDATE
    ON
    public.rd_contacts FOR EACH ROW EXECUTE FUNCTION update_last_update_column();

--------------------------------------------------------------------------------
-- public.rd_conversion_events definition
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
CREATE INDEX idx_rd_conversion_events_event_identifier ON public.rd_conversion_events USING btree (event_identifier);
CREATE INDEX idx_rd_conversion_events_uuid ON public.rd_conversion_events USING btree (uuid);

--------------------------------------------------------------------------------
-- public.rd_contact_funnel_status definition
CREATE TABLE public.rd_contact_funnel_status (
	"uuid" uuid NOT NULL,
	lifecycle_stage text NULL,
	opportunity bool NULL,
	contact_owner_email text NULL,
	interest int4 NULL,
	fit int4 NULL,
	origin text NULL,
	last_update timestamp DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NULL,
	CONSTRAINT rd_funnel_status_pkey PRIMARY KEY (uuid)
);
CREATE INDEX idx_rd_contact_funnel_status_uuid ON public.rd_contact_funnel_status USING btree (uuid);
-- Table Triggers
CREATE TRIGGER set_last_update BEFORE
UPDATE
    ON
    public.rd_contact_funnel_status FOR EACH ROW EXECUTE FUNCTION update_last_update_column();

--------------------------------------------------------------------------------
-- public.receita_por_procedimento_summary definition
CREATE TABLE public.receita_por_procedimento_summary (
	atend text NULL,
	celular text NULL,
	e_mail text NULL,
	setor text NULL,
	dt_lanca date NULL,
	ajuste_semana text NULL,
	considerar text NULL,
	vl_total float8 NULL,
	business_unit text NULL,
	updated_at timestamp DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NULL
);
-- Table Triggers
CREATE TRIGGER set_updated_at BEFORE
UPDATE
    ON
    public.receita_por_procedimento_summary FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

--------------------------------------------------------------------------------
-- Table structure for table "dim_event_identifier"
CREATE TABLE public.dim_event_identifier (
	id serial4 NOT NULL,
	event_identifier text NOT NULL,
	active bool DEFAULT true NULL,
	updated_at timestamp DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NULL,
	CONSTRAINT dim_event_identifier_unique UNIQUE (event_identifier)
);
CREATE INDEX idx_dim_event_identifier_active ON public.dim_event_identifier USING btree (event_identifier) WHERE (active = true);

--------------------------------------------------------------------------------
-- Table structure for table "rd_webhook"
CREATE TABLE public.rd_webhook (
	id int4 DEFAULT nextval('rd_webhooks_id_seq'::regclass) NOT NULL,
	event_type text NULL,
	entity_type text NULL,
	event_identifier text NULL,
	"timestamp" timestamptz NULL,
	event_timestamp timestamptz NULL,
	contato jsonb NULL,
	inserted_at timestamptz DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NULL,
	"uuid" text GENERATED ALWAYS AS (contato ->> 'uuid'::text) STORED NULL,
	CONSTRAINT rd_webhooks_pkey PRIMARY KEY (id)
);

--------------------------------------------------------------------------------
-- Table structure for table "rd_webhook_v1"
CREATE TABLE public.rd_webhook_v1 (
	id int4 DEFAULT nextval('rd_webhooks_v1_id_seq'::regclass) NOT NULL,
	lead_id text NOT NULL,
	"uuid" uuid NOT NULL,
	email text NULL,
	"name" text NULL,
	company text NULL,
	job_title text NULL,
	bio text NULL,
	created_at timestamptz NULL,
	opportunity bool NULL,
	number_conversions int4 NULL,
	user_email text NULL,
	first_conversion jsonb NULL,
	last_conversion jsonb NULL,
	custom_fields jsonb NULL,
	website text NULL,
	personal_phone text NULL,
	mobile_phone text NULL,
	city text NULL,
	state text NULL,
	lead_stage text NULL,
	tags jsonb NULL,
	fit_score text NULL,
	interest int4 NULL,
	inserted_at timestamptz DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NULL,
	CONSTRAINT rd_webhooks_v1_pkey PRIMARY KEY (id)
);

--------------------------------------------------------------------------------
-- CREATE REQUIRED VIEWS FOR DASHBOARDS
--------------------------------------------------------------------------------

-- View structure for view "v_rd_contacts_with_conversions"
CREATE OR REPLACE VIEW public.v_rd_contacts_with_conversions
AS SELECT ac.uuid,
    ac.email,
    COALESCE(ac.mobile_phone, ac.personal_phone) AS phone,
    ac.business_unit,
    COALESCE(ac.cf_especialidade_ls, ac.cf_especialidade) AS especialidade,
    COALESCE(ac.cf_especie_ls, ac.cf_especie) AS especie,
    COALESCE(ac.cf_exame_ls, ac.cf_exame) AS exame,
    ac.cf_tipo_de_atendimento,
    ac.cf_bu,
    ac.cf_utm_source,
    ac.cf_utm_medium,
    ac.cf_utm_campaign,
    ac.cf_id_do_lead,
    ac.cf_origem_do_lead,
    cfs.origin,
    vc.event_identifier,
    vc.event_timestamp,
    vc.utm_source,
    vc.utm_medium,
    vc.utm_campaign,
    vc.utm_term,
    vc.utm_content
   FROM rd_contacts ac
     JOIN rd_conversion_events vc ON ac.uuid = vc.uuid
     JOIN dim_event_identifier dei ON vc.event_identifier = dei.event_identifier AND dei.active = true
     LEFT JOIN rd_contact_funnel_status cfs ON ac.uuid = cfs.uuid;

--------------------------------------------------------------------------------
-- CREATE REQUIRED FUNCTIONS AND TRIGGERS FOR TABLES
--------------------------------------------------------------------------------

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