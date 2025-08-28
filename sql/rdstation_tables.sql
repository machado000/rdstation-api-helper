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
	tags _text NULL,
	legal_bases jsonb NULL,
	links jsonb NULL,
	k text NULL,
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
	phone text NULL,
	CONSTRAINT rd_contacts_pk PRIMARY KEY (uuid)
);
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
	event_identifier text NOT NULL,
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
	utm_channel text NULL,
	CONSTRAINT rd_conversion_events_pk PRIMARY KEY (uuid, event_identifier, event_timestamp)
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
CREATE TRIGGER set_last_update BEFORE
UPDATE
    ON
    public.rd_contact_funnel_status FOR EACH ROW EXECUTE FUNCTION update_last_update_column();

--------------------------------------------------------------------------------
-- public.receita_por_procedimento definition
CREATE TABLE public.receita_por_procedimento (
	id serial4 NOT NULL,
	atend text NULL,
	a text NULL,
	celular text NULL,
	b text NULL,
	c text NULL,
	e_mail text NULL,
	d text NULL,
	cd_proced text NULL,
	e text NULL,
	procedimento text NULL,
	f text NULL,
	grupo text NULL,
	g text NULL,
	h text NULL,
	setor text NULL,
	i text NULL,
	j text NULL,
	k text NULL,
	l text NULL,
	dt_lanca date NULL,
	m text NULL,
	n text NULL,
	o text NULL,
	hora text NULL,
	p text NULL,
	qtd numeric NULL,
	q text NULL,
	vl_uni numeric NULL,
	u text NULL,
	v text NULL,
	x text NULL,
	vl_total numeric NULL,
	ajuste_unidade numeric NULL,
	ajuste_unidade_de_negocio text NULL,
	ajuste_semana text NULL,
	lead_telefone text NULL,
	lead_email text NULL,
	considerar text NULL,
	spreadsheet_key text NULL,
	file_name text NULL,
	read_at timestamp NULL,
	updated_at timestamp DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NULL,
	CONSTRAINT receita_por_procedimento_pkey PRIMARY KEY (id)
);

--------------------------------------------------------------------------------
-- public.campaign_mapping definition
CREATE TABLE public.campaign_mapping (
	id serial4 NOT NULL,
	business_unit text NULL,
	campaign_name text NULL,
	source_name text NULL,
	e text NULL,
	utm_campaign text NULL,
	utm_source text NULL,
	utm_channel text NULL,
	utm_medium text NULL,
	utm_content text NULL,
	vincular_event_identifier _text NULL,
	vincular_landing_page _text NULL,
	vincular_tag _text NULL,
	n text NULL,
	o text NULL,
	updated_at timestamp DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NULL,
	active bool DEFAULT true NULL,
	CONSTRAINT campaign_mapping_id_pkey PRIMARY KEY (id),
	CONSTRAINT campaign_mapping_unique UNIQUE (utm_campaign, utm_source)
);

--------------------------------------------------------------------------------
-- public.dim_business_unit definition
CREATE TABLE public.dim_business_unit (
	id serial4 NOT NULL,
	business_unit text NULL,
	business_unit_name text NULL,
	business_unit_tags _text NULL,
	e text NULL,
	f text NULL,
	g text NULL,
	updated_at timestamp DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NULL,
	CONSTRAINT dim_business_unit_id_pkey PRIMARY KEY (id)
);
CREATE TRIGGER set_updated_at BEFORE
UPDATE
    ON
    public.dim_business_unit FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

--------------------------------------------------------------------------------
-- public.dim_contact_origin definition
CREATE TABLE public.dim_contact_origin (
	id serial4 NOT NULL,
	origin text NOT NULL,
	utm_source text NULL,
	utm_channel text NULL,
	utm_medium text NULL,
	active bool DEFAULT true NULL,
	updated_at timestamp DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NULL,
	CONSTRAINT dim_origin_unique UNIQUE (origin)
);
CREATE INDEX idx_dim_origin_active ON public.dim_contact_origin USING btree (origin) WHERE (active = true);

--------------------------------------------------------------------------------
-- public.dim_event_identifier definition
CREATE TABLE public.dim_event_identifier (
	id serial4 NOT NULL,
	event_identifier text NOT NULL,
	active bool DEFAULT true NULL,
	updated_at timestamp DEFAULT timezone('America/Sao_Paulo'::text, CURRENT_TIMESTAMP) NULL,
	event_name text NULL,
	CONSTRAINT dim_event_identifier_unique UNIQUE (event_identifier)
);
CREATE INDEX dim_event_identifier_active_idx ON public.dim_event_identifier USING btree (event_identifier, active);

--------------------------------------------------------------------------------
-- public.rd_contacts_revised definition
CREATE TABLE public.rd_contacts_revised (
	"uuid" text NULL,
	email text NULL,
	phone text NULL,
	tags text NULL,
	especialidade text NULL,
	especie text NULL,
	exame text NULL,
	first_event timestamptz NULL,
	event_identifier text NULL,
	utm_campaign text NULL,
	utm_source text NULL,
	utm_channel text NULL,
	utm_medium text NULL,
	last_event timestamptz NULL,
	event_count int8 NULL
);

--------------------------------------------------------------------------------
-- public.rd_leads_revised definition
CREATE TABLE public.rd_leads_revised (
	"uuid" text NULL,
	business_unit text NULL,
	tags text NULL,
	origin text NULL,
	event_identifier text NULL,
	event_timestamp timestamptz NULL,
	utm_source text NULL,
	utm_medium text NULL,
	utm_campaign text NULL,
	utm_term text NULL,
	utm_content text NULL,
	utm_channel text NULL
);

--------------------------------------------------------------------------------
-- public.receita_por_procedimento_revised definition
CREATE TABLE public.receita_por_procedimento_revised (
	atend text NULL,
	celular text NULL,
	e_mail text NULL,
	setor text NULL,
	dt_lanca date NULL,
	ajuste_semana text NULL,
	considerar text NULL,
	vl_total float8 NULL,
	business_unit text NULL,
	"uuid" text NULL
);

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

-- public.v_rd_contacts_summarized source
CREATE OR REPLACE VIEW public.v_rd_contacts_summarized
AS SELECT DISTINCT uuid,
    email,
    phone,
    tags,
    especialidade,
    especie,
    exame,
    first_event,
    event_identifier,
    utm_campaign,
    utm_source,
    utm_channel,
    utm_medium,
    last_event,
    event_count
   FROM ( SELECT rc.uuid,
            rc.email,
            COALESCE(rc.phone, rc.mobile_phone, rc.personal_phone) AS phone,
            rc.tags,
            COALESCE(rc.cf_especialidade_ls, rc.cf_especialidade) AS especialidade,
            COALESCE(rc.cf_especie_ls, rc.cf_especie) AS especie,
            COALESCE(rc.cf_exame_ls, rc.cf_exame) AS exame,
            min(rce.event_timestamp) OVER (PARTITION BY rc.uuid) AS first_event,
            first_value(rce.event_identifier) OVER (PARTITION BY rc.uuid ORDER BY rce.event_timestamp) AS event_identifier,
            first_value(rce.utm_campaign) OVER (PARTITION BY rc.uuid ORDER BY rce.event_timestamp) AS utm_campaign,
            first_value(rce.utm_source) OVER (PARTITION BY rc.uuid ORDER BY rce.event_timestamp) AS utm_source,
            first_value(rce.utm_channel) OVER (PARTITION BY rc.uuid ORDER BY rce.event_timestamp) AS utm_channel,
            first_value(rce.utm_medium) OVER (PARTITION BY rc.uuid ORDER BY rce.event_timestamp) AS utm_medium,
            max(rce.event_timestamp) OVER (PARTITION BY rc.uuid) AS last_event,
            count(rce.event_identifier) OVER (PARTITION BY rc.uuid) AS event_count
           FROM rd_contacts rc
             LEFT JOIN rd_conversion_events rce ON rc.uuid = rce.uuid
             LEFT JOIN dim_event_identifier dei ON rce.event_identifier = dei.event_identifier AND dei.active = true) t;

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