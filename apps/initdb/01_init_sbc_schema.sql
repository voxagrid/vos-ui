--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Ubuntu 15.2-1.pgdg22.04+1)
-- Dumped by pg_dump version 15.2 (Ubuntu 15.2-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET search_path = public, pg_catalog;
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Extensions required by VOS-UI Suite
--
CREATE EXTENSION IF NOT EXISTS "pgcrypto" WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS "pg_trgm" WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS "timescaledb" CASCADE;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cdr_records; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.cdr_records (
    server_id character varying(64) NOT NULL,
    call_time timestamp with time zone NOT NULL,
    flowno bigint NOT NULL,
    id integer,
    callere164 character varying(64),
    calleraccesse164 character varying(64),
    calleee164 character varying(64),
    calleeaccesse164 character varying(64),
    callertogatewaye164 character varying(64),
    calleetogatewaye164 character varying(64),
    callerareacode character varying(64),
    calleeareacode character varying(64),
    callerip character varying(64),
    callerrtpip character varying(64),
    callercodec character varying(64),
    calleeip character varying(64),
    calleertpip character varying(64),
    calleecodec character varying(64),
    rtpforward integer DEFAULT 0,
    callergatewayid character varying(64),
    calleegatewayid character varying(64),
    callerproductid character varying(64),
    calleeproductid character varying(64),
    callertype integer,
    calleetype integer,
    starttime bigint NOT NULL,
    stoptime bigint,
    recordstarttime bigint,
    holdtime integer DEFAULT 0,
    feetime integer DEFAULT 0,
    callerpdd integer DEFAULT 0,
    calleepdd integer DEFAULT 0,
    customeraccount character varying(255),
    customername character varying(255),
    billingmode integer DEFAULT 0,
    billingtype integer DEFAULT 0,
    calllevel integer DEFAULT 0,
    cdrlevel integer DEFAULT 0,
    fee double precision DEFAULT 0,
    tax double precision DEFAULT 0,
    suitefee double precision DEFAULT 0,
    suitefeetime integer DEFAULT 0,
    incomefee double precision DEFAULT 0,
    incometax double precision DEFAULT 0,
    agentaccount character varying(255),
    agentname character varying(255),
    agentcdr_id integer,
    agentfee double precision DEFAULT 0,
    agenttax double precision DEFAULT 0,
    agentsuitefee double precision DEFAULT 0,
    agentsuitefeetime integer DEFAULT 0,
    agentfeetime integer DEFAULT 0,
    softswitchname character varying(64),
    softswitchcallid bigint,
    callercallid character varying(64),
    calleroriginalcallid character varying(64),
    calleecallid character varying(64),
    calleroriginalinfo character varying(255),
    transactionid character varying(64),
    enddirection integer,
    endreason integer,
    sipreasonheader character varying(64),
    invitetime bigint DEFAULT 0,
    firstresponsetime bigint DEFAULT 0,
    answertime bigint DEFAULT 0,
    waittime integer DEFAULT 0,
    is_device_ringing boolean DEFAULT false,
    device_reach_status character varying(32) DEFAULT 'UNKNOWN'::character varying
);


--
-- Name: telemetry_noc_stages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.telemetry_noc_stages (
    bucket_time timestamp with time zone NOT NULL,
    customer_account character varying(64) DEFAULT ''::character varying NOT NULL,
    caller_gateway character varying(64) DEFAULT ''::character varying NOT NULL,
    callee_gateway character varying(64) DEFAULT ''::character varying NOT NULL,
    caller_ip character varying(45) DEFAULT ''::character varying NOT NULL,
    callee_ip character varying(45) DEFAULT ''::character varying NOT NULL,
    new_calls integer DEFAULT 0 NOT NULL,
    cps numeric(8,2) DEFAULT 0.00 NOT NULL,
    talking_count integer DEFAULT 0 NOT NULL,
    ringing_count integer DEFAULT 0 NOT NULL,
    early_media_count integer DEFAULT 0 NOT NULL,
    trying_count integer DEFAULT 0 NOT NULL,
    setup_count integer DEFAULT 0 NOT NULL,
    total_calls integer DEFAULT 0 NOT NULL
);


--
-- Name: app_api_catalog; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_api_catalog (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    category character varying(50) NOT NULL,
    name character varying(100) NOT NULL,
    method character varying(10) NOT NULL,
    path character varying(255) NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    required_role character varying(50) DEFAULT 'ALL'::character varying NOT NULL,
    requires_vos_server boolean DEFAULT false,
    default_headers jsonb DEFAULT '{}'::jsonb,
    default_params jsonb DEFAULT '{}'::jsonb,
    default_body text DEFAULT ''::text,
    sort_order integer DEFAULT 0,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: app_audit_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_audit_logs (
    id bigint NOT NULL,
    user_id uuid,
    username character varying(64),
    server_id character varying(64),
    action character varying(64) NOT NULL,
    resource_type character varying(64),
    resource_id character varying(128),
    payload jsonb,
    client_ip character varying(64),
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: app_audit_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_audit_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_audit_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_audit_logs_id_seq OWNED BY public.app_audit_logs.id;


--
-- Name: app_callerid_calendar_exceptions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_callerid_calendar_exceptions (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    exception_date date NOT NULL,
    exception_type character varying(32) NOT NULL,
    description character varying(255) NOT NULL,
    customer_account character varying(64) DEFAULT 'ALL'::character varying,
    is_active boolean DEFAULT true,
    created_by character varying(64) DEFAULT 'admin'::character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE app_callerid_calendar_exceptions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.app_callerid_calendar_exceptions IS 'Tabel kalender libur dan lembur operasional untuk mengontrol otomasi rotasi Caller ID';


--
-- Name: COLUMN app_callerid_calendar_exceptions.exception_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_callerid_calendar_exceptions.exception_type IS 'HOLIDAY: pause rotasi; WORKDAY_OVERRIDE: paksa rotasi aktif meski weekend';


--
-- Name: app_callerid_inventory; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_callerid_inventory (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    pool_id uuid NOT NULL,
    caller_id character varying(64) NOT NULL,
    status character varying(32) DEFAULT 'AVAILABLE'::character varying NOT NULL,
    current_gateway character varying(64),
    assigned_date date,
    last_used_at timestamp with time zone,
    cooldown_until timestamp with time zone,
    total_uses integer DEFAULT 0 NOT NULL,
    total_calls_served bigint DEFAULT 0 NOT NULL,
    notes text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: app_callerid_pool_gateways; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_callerid_pool_gateways (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    pool_id uuid NOT NULL,
    gateway_name character varying(64) NOT NULL,
    current_caller_id character varying(64),
    last_rotated_at timestamp with time zone,
    next_rotation_scheduled timestamp with time zone,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: app_callerid_pools; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_callerid_pools (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    pool_name character varying(64) NOT NULL,
    customer_account character varying(64) NOT NULL,
    carrier character varying(32) NOT NULL,
    rotation_mode character varying(32) DEFAULT 'SHIFT_BASED'::character varying NOT NULL,
    shifts_json jsonb DEFAULT '["07:00", "12:30"]'::jsonb NOT NULL,
    active_days jsonb DEFAULT '[1, 2, 3, 4, 5]'::jsonb NOT NULL,
    cooldown_days integer DEFAULT 7 NOT NULL,
    is_active boolean DEFAULT true NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: app_callerid_rotation_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_callerid_rotation_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    customer_account character varying(64) NOT NULL,
    pool_id uuid,
    pool_name character varying(64) NOT NULL,
    gateway_name character varying(64) NOT NULL,
    carrier character varying(32) NOT NULL,
    old_caller_id character varying(64),
    new_caller_id character varying(64) NOT NULL,
    rotation_type character varying(32) NOT NULL,
    rotation_status character varying(32) DEFAULT 'SUCCESS'::character varying NOT NULL,
    error_message text,
    rotated_by character varying(64) DEFAULT 'SYSTEM_SCHEDULER'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: app_cdr_export_schedules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_cdr_export_schedules (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    name character varying(128) NOT NULL,
    customer_account character varying(64) NOT NULL,
    caller_ip character varying(64) DEFAULT NULL::character varying,
    callee_prefix character varying(64) DEFAULT NULL::character varying,
    day_of_month integer DEFAULT 1,
    time_of_day character varying(8) DEFAULT '00:05'::character varying,
    notify_email boolean DEFAULT false,
    email_recipient character varying(255) DEFAULT NULL::character varying,
    notify_telegram boolean DEFAULT false,
    telegram_chat_id character varying(64) DEFAULT NULL::character varying,
    is_active boolean DEFAULT true,
    last_run_at timestamp with time zone,
    last_status character varying(32) DEFAULT NULL::character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    filter_params jsonb DEFAULT '{}'::jsonb,
    email_cc character varying(255) DEFAULT NULL::character varying,
    email_bcc character varying(255) DEFAULT NULL::character varying,
    auto_generate_invoice boolean DEFAULT true,
    send_invoice_email boolean DEFAULT true
);


--
-- Name: app_cdr_exported_files; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_cdr_exported_files (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    schedule_id uuid,
    customer_account character varying(64) NOT NULL,
    period_type character varying(16) DEFAULT 'MONTHLY'::character varying NOT NULL,
    period_label character varying(64) NOT NULL,
    file_name character varying(255) NOT NULL,
    file_path character varying(512) NOT NULL,
    file_size_bytes bigint DEFAULT 0,
    total_calls bigint DEFAULT 0,
    total_duration_sec bigint DEFAULT 0,
    total_fee numeric(15,4) DEFAULT 0,
    status character varying(32) DEFAULT 'COMPLETED'::character varying,
    generated_by character varying(64) DEFAULT 'CRON_SCHEDULER'::character varying,
    caller_ip character varying(64) DEFAULT NULL::character varying,
    callee_prefix character varying(64) DEFAULT NULL::character varying,
    download_count integer DEFAULT 0,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    filter_params jsonb DEFAULT '{}'::jsonb,
    clean_asr numeric(5,2) DEFAULT 0.00,
    clean_acd_sec numeric(8,2) DEFAULT 0.00,
    answered_calls bigint DEFAULT 0,
    generation_duration_ms bigint DEFAULT 0,
    summary_metrics jsonb DEFAULT '{}'::jsonb,
    daily_breakdown jsonb DEFAULT '[]'::jsonb,
    invoice_no character varying(64) DEFAULT NULL::character varying,
    invoice_pdf_path character varying(512) DEFAULT NULL::character varying,
    invoice_pdf_size bigint DEFAULT 0,
    email_status character varying(32) DEFAULT 'PENDING'::character varying,
    email_recipient character varying(255) DEFAULT NULL::character varying,
    email_sent_at timestamp with time zone,
    email_error_message text,
    email_retry_count integer DEFAULT 0,
    telegram_status character varying(32) DEFAULT 'PENDING'::character varying,
    telegram_sent_at timestamp with time zone,
    telegram_error_message text,
    clean_ner numeric(5,2) DEFAULT 0.00,
    approval_status character varying(20) DEFAULT 'PENDING'::character varying,
    approved_by character varying(64) DEFAULT NULL::character varying,
    approved_at timestamp with time zone,
    rejection_reason text
);


--
-- Name: app_cdr_sync_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_cdr_sync_logs (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    server_id character varying(64) NOT NULL,
    table_name character varying(64) NOT NULL,
    sync_date character varying(10) NOT NULL,
    trigger_type character varying(32) DEFAULT 'MANUAL'::character varying NOT NULL,
    status character varying(20) DEFAULT 'RUNNING'::character varying NOT NULL,
    total_source_records bigint DEFAULT 0 NOT NULL,
    total_inserted bigint DEFAULT 0 NOT NULL,
    total_skipped bigint DEFAULT 0 NOT NULL,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    completed_at timestamp with time zone,
    duration_ms bigint DEFAULT 0,
    triggered_by character varying(64) DEFAULT 'system'::character varying,
    error_message text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: app_gateway_period_control; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_gateway_period_control (
    id integer NOT NULL,
    gateway_name character varying(255) NOT NULL,
    type character varying(32) NOT NULL,
    weekdays character varying(64) DEFAULT '1,2,3,4,5,6,7'::character varying NOT NULL,
    begin_time character varying(32) DEFAULT '00:00:00'::character varying NOT NULL,
    end_time character varying(32) DEFAULT '23:59:59'::character varying NOT NULL,
    operation character varying(32) DEFAULT ''::character varying,
    mode character varying(32) DEFAULT ''::character varying,
    param_value character varying(255) DEFAULT ''::character varying,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: app_gateway_period_control_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_gateway_period_control_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_gateway_period_control_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_gateway_period_control_id_seq OWNED BY public.app_gateway_period_control.id;


--
-- Name: app_http_request_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_http_request_logs (
    id bigint NOT NULL,
    request_id character varying(64),
    "timestamp" timestamp with time zone DEFAULT now() NOT NULL,
    client_ip character varying(64),
    user_id uuid,
    username character varying(64),
    server_id character varying(64),
    method character varying(16) NOT NULL,
    path text NOT NULL,
    query_params text,
    request_headers jsonb,
    request_payload text,
    response_status integer NOT NULL,
    response_payload text,
    duration_ms bigint NOT NULL,
    error_message text,
    created_at timestamp with time zone DEFAULT now() NOT NULL
);


--
-- Name: app_http_request_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_http_request_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_http_request_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_http_request_logs_id_seq OWNED BY public.app_http_request_logs.id;


--
-- Name: app_modules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_modules (
    id character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    group_title character varying(64) NOT NULL,
    path character varying(128) NOT NULL,
    icon character varying(64) DEFAULT 'LayoutDashboard'::character varying,
    sort_order integer DEFAULT 100,
    is_customer_visible boolean DEFAULT false,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: app_noc_alert_history; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_noc_alert_history (
    id bigint NOT NULL,
    rule_id integer,
    rule_code character varying(64) NOT NULL,
    severity character varying(16) NOT NULL,
    target_entity character varying(128),
    summary text NOT NULL,
    details jsonb,
    status character varying(16) DEFAULT 'ACTIVE'::character varying,
    acknowledged_by character varying(64),
    acknowledged_at timestamp with time zone,
    triggered_at timestamp with time zone DEFAULT now(),
    resolved_at timestamp with time zone
);


--
-- Name: app_noc_alert_history_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_noc_alert_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_noc_alert_history_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_noc_alert_history_id_seq OWNED BY public.app_noc_alert_history.id;


--
-- Name: app_noc_alert_rules; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_noc_alert_rules (
    id integer NOT NULL,
    rule_code character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    metric_type character varying(32) NOT NULL,
    target_scope character varying(32) DEFAULT 'ALL'::character varying,
    scope_id character varying(64),
    condition_op character varying(8) NOT NULL,
    threshold_value double precision NOT NULL,
    window_minutes integer DEFAULT 5,
    min_attempts integer DEFAULT 20,
    severity character varying(16) DEFAULT 'WARNING'::character varying,
    channels jsonb DEFAULT '["WEB", "TELEGRAM"]'::jsonb,
    cooldown_minutes integer DEFAULT 15,
    is_active boolean DEFAULT true,
    last_triggered_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: app_noc_alert_rules_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_noc_alert_rules_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_noc_alert_rules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_noc_alert_rules_id_seq OWNED BY public.app_noc_alert_rules.id;


--
-- Name: app_refresh_tokens; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_refresh_tokens (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    user_id uuid NOT NULL,
    token_hash character varying(128) NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    revoked boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: app_role_permissions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_role_permissions (
    role_id uuid NOT NULL,
    module_id character varying(64) NOT NULL,
    can_view boolean DEFAULT false,
    can_create boolean DEFAULT false,
    can_edit boolean DEFAULT false,
    can_delete boolean DEFAULT false,
    can_execute boolean DEFAULT false,
    can_export boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: app_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_roles (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    code character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    description text,
    scope_type character varying(32) DEFAULT 'NOC'::character varying NOT NULL,
    is_system boolean DEFAULT false,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    CONSTRAINT app_roles_scope_type_check CHECK (((scope_type)::text = ANY (ARRAY[('SYSTEM'::character varying)::text, ('NOC'::character varying)::text, ('CUSTOMER'::character varying)::text])))
);


--
-- Name: app_system_configs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_system_configs (
    config_key character varying(64) NOT NULL,
    config_value text NOT NULL,
    value_type character varying(16) DEFAULT 'string'::character varying NOT NULL,
    category character varying(32) DEFAULT 'SYSTEM'::character varying NOT NULL,
    title character varying(128) NOT NULL,
    description text,
    unit character varying(16) DEFAULT ''::character varying,
    is_editable boolean DEFAULT true NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    updated_at timestamp with time zone DEFAULT now() NOT NULL,
    default_value text DEFAULT ''::text NOT NULL
);


--
-- Name: app_telco_operators; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_telco_operators (
    id integer NOT NULL,
    code character varying(32) NOT NULL,
    name character varying(64) NOT NULL,
    network_type character varying(16) NOT NULL,
    badge_color character varying(16) DEFAULT '#3B82F6'::character varying,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


--
-- Name: app_telco_operators_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_telco_operators_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_telco_operators_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_telco_operators_id_seq OWNED BY public.app_telco_operators.id;


--
-- Name: app_telco_prefixes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_telco_prefixes (
    id integer NOT NULL,
    operator_id integer,
    prefix character varying(16) NOT NULL,
    description character varying(64),
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: app_telco_prefixes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_telco_prefixes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_telco_prefixes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_telco_prefixes_id_seq OWNED BY public.app_telco_prefixes.id;


--
-- Name: app_user_customer_access; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_user_customer_access (
    user_id uuid NOT NULL,
    customer_account character varying(64) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: app_user_roles; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_user_roles (
    user_id uuid NOT NULL,
    role_id uuid NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: app_user_vos_access; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_user_vos_access (
    user_id uuid NOT NULL,
    server_id character varying(64) NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: app_users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_users (
    id uuid DEFAULT gen_random_uuid() NOT NULL,
    username character varying(64) NOT NULL,
    password_hash character varying(255) NOT NULL,
    full_name character varying(128),
    role character varying(64) NOT NULL,
    customer_account character varying(64),
    all_servers_access boolean DEFAULT true,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    clearing_account character varying(64) DEFAULT NULL::character varying
);


--
-- Name: app_vos_api_doc_params; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_vos_api_doc_params (
    id integer NOT NULL,
    api_name character varying(100) NOT NULL,
    format_category character varying(20) NOT NULL,
    format_title character varying(100) NOT NULL,
    param_name character varying(100) NOT NULL,
    requirement character varying(5) NOT NULL,
    data_type character varying(50) NOT NULL,
    description text,
    enum_values jsonb DEFAULT '{}'::jsonb,
    sort_order integer NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    label character varying(150) DEFAULT ''::character varying,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: app_vos_api_doc_params_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_vos_api_doc_params_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_vos_api_doc_params_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_vos_api_doc_params_id_seq OWNED BY public.app_vos_api_doc_params.id;


--
-- Name: app_vos_api_docs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_vos_api_docs (
    api_name character varying(100) NOT NULL,
    section_no character varying(20) NOT NULL,
    title character varying(150) NOT NULL,
    endpoint_uri character varying(255) NOT NULL,
    http_method character varying(10) DEFAULT 'POST'::character varying,
    module_group character varying(50) NOT NULL,
    page_start integer,
    page_end integer,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: app_vos_end_reasons; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_vos_end_reasons (
    code integer NOT NULL,
    reason_text character varying(64) NOT NULL,
    protocol character varying(32) NOT NULL,
    leg_type character varying(32) NOT NULL,
    kpi_category character varying(32) NOT NULL,
    q850_cause integer,
    sip_status integer,
    is_egress_seizure boolean DEFAULT false NOT NULL,
    is_ner_success boolean DEFAULT false NOT NULL,
    is_asr_success boolean DEFAULT false NOT NULL,
    title_en character varying(128) NOT NULL,
    description_id text NOT NULL,
    impact_recommendation text NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    sub_category character varying(32) DEFAULT 'OTHER'::character varying
);


--
-- Name: app_vos_routing_gateways; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_vos_routing_gateways (
    gateway_name character varying(64) NOT NULL,
    clearing_account_id character varying(64) NOT NULL,
    clearing_account_name character varying(128),
    remote_ip character varying(64),
    line_limit integer DEFAULT 30,
    lock_type integer DEFAULT 0,
    is_active boolean DEFAULT true,
    updated_at timestamp with time zone DEFAULT now(),
    created_at timestamp with time zone DEFAULT now()
);


--
-- Name: TABLE app_vos_routing_gateways; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.app_vos_routing_gateways IS 'Tabel katalog dimensi gateway rute keluar (Leg-B Egress) yang disinkronkan dari VOS3000 port 6099';


--
-- Name: COLUMN app_vos_routing_gateways.clearing_account_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_vos_routing_gateways.clearing_account_id IS 'ID Akun Vendor Clearing (e_customer type=2) yang menerima biaya terminasi';


--
-- Name: app_vos_servers; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_vos_servers (
    id character varying(64) NOT NULL,
    name character varying(128) NOT NULL,
    api_url character varying(255) NOT NULL,
    mysql_host character varying(128) DEFAULT '127.0.0.1'::character varying,
    mysql_port integer DEFAULT 3306,
    mysql_user character varying(64) DEFAULT 'root'::character varying,
    mysql_password character varying(128) DEFAULT ''::character varying,
    mysql_database character varying(64) DEFAULT 'vos3000'::character varying,
    location character varying(128) DEFAULT 'Primary Data Center'::character varying,
    max_channels integer DEFAULT 2000,
    is_primary boolean DEFAULT false,
    is_active boolean DEFAULT true,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    cdr_sync_time character varying(8) DEFAULT '00:05'::character varying NOT NULL,
    cdr_sync_enabled boolean DEFAULT true NOT NULL,
    last_sync_date character varying(10) DEFAULT ''::character varying NOT NULL,
    last_sync_status character varying(20) DEFAULT 'IDLE'::character varying NOT NULL,
    agent_secret character varying(128) DEFAULT 'voxagrid-agent-secret-2026'::character varying NOT NULL,
    db_connection_mode character varying(32) DEFAULT 'AGENT_PROXY'::character varying NOT NULL,
    api_connection_mode character varying(32) DEFAULT 'AGENT_PROXY'::character varying NOT NULL
);


--
-- Name: COLUMN app_vos_servers.cdr_sync_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_vos_servers.cdr_sync_time IS 'Jadwal harian waktu lokal (format HH:mm) penarikan CDR H-1, misal 00:05 atau 00:15';


--
-- Name: COLUMN app_vos_servers.cdr_sync_enabled; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_vos_servers.cdr_sync_enabled IS 'Flag aktif/nonaktif proses sinkronisasi otomatis harian';


--
-- Name: COLUMN app_vos_servers.last_sync_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_vos_servers.last_sync_date IS 'Tanggal kalender terakhir (YYYY-MM-DD) saat sinkronisasi harian berhasil';


--
-- Name: COLUMN app_vos_servers.last_sync_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_vos_servers.last_sync_status IS 'Status sinkronisasi terakhir: IDLE | RUNNING | SUCCESS | FAILED';


--
-- Name: app_audit_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_audit_logs ALTER COLUMN id SET DEFAULT nextval('public.app_audit_logs_id_seq'::regclass);


--
-- Name: app_gateway_period_control id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_gateway_period_control ALTER COLUMN id SET DEFAULT nextval('public.app_gateway_period_control_id_seq'::regclass);


--
-- Name: app_http_request_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_http_request_logs ALTER COLUMN id SET DEFAULT nextval('public.app_http_request_logs_id_seq'::regclass);


--
-- Name: app_noc_alert_history id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_noc_alert_history ALTER COLUMN id SET DEFAULT nextval('public.app_noc_alert_history_id_seq'::regclass);


--
-- Name: app_noc_alert_rules id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_noc_alert_rules ALTER COLUMN id SET DEFAULT nextval('public.app_noc_alert_rules_id_seq'::regclass);


--
-- Name: app_telco_operators id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_telco_operators ALTER COLUMN id SET DEFAULT nextval('public.app_telco_operators_id_seq'::regclass);


--
-- Name: app_telco_prefixes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_telco_prefixes ALTER COLUMN id SET DEFAULT nextval('public.app_telco_prefixes_id_seq'::regclass);


--
-- Name: app_vos_api_doc_params id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_vos_api_doc_params ALTER COLUMN id SET DEFAULT nextval('public.app_vos_api_doc_params_id_seq'::regclass);


--
-- Name: app_api_catalog app_api_catalog_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_api_catalog
    ADD CONSTRAINT app_api_catalog_pkey PRIMARY KEY (id);


--
-- Name: app_audit_logs app_audit_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_audit_logs
    ADD CONSTRAINT app_audit_logs_pkey PRIMARY KEY (id);


--
-- Name: app_callerid_calendar_exceptions app_callerid_calendar_exceptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_callerid_calendar_exceptions
    ADD CONSTRAINT app_callerid_calendar_exceptions_pkey PRIMARY KEY (id);


--
-- Name: app_callerid_inventory app_callerid_inventory_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_callerid_inventory
    ADD CONSTRAINT app_callerid_inventory_pkey PRIMARY KEY (id);


--
-- Name: app_callerid_inventory app_callerid_inventory_pool_id_caller_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_callerid_inventory
    ADD CONSTRAINT app_callerid_inventory_pool_id_caller_id_key UNIQUE (pool_id, caller_id);


--
-- Name: app_callerid_pool_gateways app_callerid_pool_gateways_gateway_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_callerid_pool_gateways
    ADD CONSTRAINT app_callerid_pool_gateways_gateway_name_key UNIQUE (gateway_name);


--
-- Name: app_callerid_pool_gateways app_callerid_pool_gateways_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_callerid_pool_gateways
    ADD CONSTRAINT app_callerid_pool_gateways_pkey PRIMARY KEY (id);


--
-- Name: app_callerid_pools app_callerid_pools_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_callerid_pools
    ADD CONSTRAINT app_callerid_pools_pkey PRIMARY KEY (id);


--
-- Name: app_callerid_pools app_callerid_pools_pool_name_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_callerid_pools
    ADD CONSTRAINT app_callerid_pools_pool_name_key UNIQUE (pool_name);


--
-- Name: app_callerid_rotation_logs app_callerid_rotation_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_callerid_rotation_logs
    ADD CONSTRAINT app_callerid_rotation_logs_pkey PRIMARY KEY (id);


--
-- Name: app_cdr_export_schedules app_cdr_export_schedules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_cdr_export_schedules
    ADD CONSTRAINT app_cdr_export_schedules_pkey PRIMARY KEY (id);


--
-- Name: app_cdr_exported_files app_cdr_exported_files_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_cdr_exported_files
    ADD CONSTRAINT app_cdr_exported_files_pkey PRIMARY KEY (id);


--
-- Name: app_cdr_sync_logs app_cdr_sync_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_cdr_sync_logs
    ADD CONSTRAINT app_cdr_sync_logs_pkey PRIMARY KEY (id);


--
-- Name: app_gateway_period_control app_gateway_period_control_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_gateway_period_control
    ADD CONSTRAINT app_gateway_period_control_pkey PRIMARY KEY (id);


--
-- Name: app_http_request_logs app_http_request_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_http_request_logs
    ADD CONSTRAINT app_http_request_logs_pkey PRIMARY KEY (id);


--
-- Name: app_modules app_modules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_modules
    ADD CONSTRAINT app_modules_pkey PRIMARY KEY (id);


--
-- Name: app_noc_alert_history app_noc_alert_history_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_noc_alert_history
    ADD CONSTRAINT app_noc_alert_history_pkey PRIMARY KEY (id);


--
-- Name: app_noc_alert_rules app_noc_alert_rules_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_noc_alert_rules
    ADD CONSTRAINT app_noc_alert_rules_pkey PRIMARY KEY (id);


--
-- Name: app_noc_alert_rules app_noc_alert_rules_rule_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_noc_alert_rules
    ADD CONSTRAINT app_noc_alert_rules_rule_code_key UNIQUE (rule_code);


--
-- Name: app_refresh_tokens app_refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_refresh_tokens
    ADD CONSTRAINT app_refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: app_refresh_tokens app_refresh_tokens_token_hash_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_refresh_tokens
    ADD CONSTRAINT app_refresh_tokens_token_hash_key UNIQUE (token_hash);


--
-- Name: app_role_permissions app_role_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_role_permissions
    ADD CONSTRAINT app_role_permissions_pkey PRIMARY KEY (role_id, module_id);


--
-- Name: app_roles app_roles_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_roles
    ADD CONSTRAINT app_roles_code_key UNIQUE (code);


--
-- Name: app_roles app_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_roles
    ADD CONSTRAINT app_roles_pkey PRIMARY KEY (id);


--
-- Name: app_system_configs app_system_configs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_system_configs
    ADD CONSTRAINT app_system_configs_pkey PRIMARY KEY (config_key);


--
-- Name: app_telco_operators app_telco_operators_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_telco_operators
    ADD CONSTRAINT app_telco_operators_code_key UNIQUE (code);


--
-- Name: app_telco_operators app_telco_operators_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_telco_operators
    ADD CONSTRAINT app_telco_operators_pkey PRIMARY KEY (id);


--
-- Name: app_telco_prefixes app_telco_prefixes_operator_id_prefix_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_telco_prefixes
    ADD CONSTRAINT app_telco_prefixes_operator_id_prefix_key UNIQUE (operator_id, prefix);


--
-- Name: app_telco_prefixes app_telco_prefixes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_telco_prefixes
    ADD CONSTRAINT app_telco_prefixes_pkey PRIMARY KEY (id);


--
-- Name: app_user_customer_access app_user_customer_access_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user_customer_access
    ADD CONSTRAINT app_user_customer_access_pkey PRIMARY KEY (user_id, customer_account);


--
-- Name: app_user_roles app_user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user_roles
    ADD CONSTRAINT app_user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: app_user_vos_access app_user_vos_access_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user_vos_access
    ADD CONSTRAINT app_user_vos_access_pkey PRIMARY KEY (user_id, server_id);


--
-- Name: app_users app_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_users
    ADD CONSTRAINT app_users_pkey PRIMARY KEY (id);


--
-- Name: app_users app_users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_users
    ADD CONSTRAINT app_users_username_key UNIQUE (username);


--
-- Name: app_vos_api_doc_params app_vos_api_doc_params_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_vos_api_doc_params
    ADD CONSTRAINT app_vos_api_doc_params_pkey PRIMARY KEY (id);


--
-- Name: app_vos_api_docs app_vos_api_docs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_vos_api_docs
    ADD CONSTRAINT app_vos_api_docs_pkey PRIMARY KEY (api_name);


--
-- Name: app_vos_end_reasons app_vos_end_reasons_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_vos_end_reasons
    ADD CONSTRAINT app_vos_end_reasons_pkey PRIMARY KEY (code);


--
-- Name: app_vos_routing_gateways app_vos_routing_gateways_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_vos_routing_gateways
    ADD CONSTRAINT app_vos_routing_gateways_pkey PRIMARY KEY (gateway_name);


--
-- Name: app_vos_servers app_vos_servers_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_vos_servers
    ADD CONSTRAINT app_vos_servers_pkey PRIMARY KEY (id);

CREATE UNIQUE INDEX idx_unique_active_api_url ON public.app_vos_servers (lower(RTRIM(api_url, '/'))) WHERE (is_active = true);
CREATE UNIQUE INDEX idx_unique_active_mysql_endpoint ON public.app_vos_servers (lower(TRIM(mysql_host)), mysql_port) WHERE (is_active = true AND db_connection_mode = 'DIRECT_MYSQL');


--
-- Name: cdr_records cdr_records_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.cdr_records
    ADD CONSTRAINT cdr_records_pkey PRIMARY KEY (call_time, server_id, flowno);


--
-- Name: app_callerid_calendar_exceptions uq_callerid_cal_date_acc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_callerid_calendar_exceptions
    ADD CONSTRAINT uq_callerid_cal_date_acc UNIQUE (exception_date, customer_account);


--
-- Name: cdr_records_call_time_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX cdr_records_call_time_idx ON public.cdr_records USING btree (call_time DESC);


--
-- Name: idx_api_catalog_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_api_catalog_category ON public.app_api_catalog USING btree (category);


--
-- Name: idx_api_catalog_method; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_api_catalog_method ON public.app_api_catalog USING btree (method);


--
-- Name: idx_api_catalog_sort; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_api_catalog_sort ON public.app_api_catalog USING btree (sort_order);


--
-- Name: idx_app_users_customer_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_app_users_customer_account ON public.app_users USING btree (customer_account);


--
-- Name: idx_app_users_username; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_app_users_username ON public.app_users USING btree (username);


--
-- Name: idx_app_vos_end_reasons_subcat; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_app_vos_end_reasons_subcat ON public.app_vos_end_reasons USING btree (sub_category);


--
-- Name: idx_audit_logs_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_logs_created_at ON public.app_audit_logs USING btree (created_at DESC);


--
-- Name: idx_audit_logs_server_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_logs_server_id ON public.app_audit_logs USING btree (server_id);


--
-- Name: idx_audit_logs_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_audit_logs_user_id ON public.app_audit_logs USING btree (user_id);


--
-- Name: idx_cal_exceptions_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cal_exceptions_account ON public.app_callerid_calendar_exceptions USING btree (customer_account);


--
-- Name: idx_cal_exceptions_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cal_exceptions_date ON public.app_callerid_calendar_exceptions USING btree (exception_date, is_active);


--
-- Name: idx_callerid_inventory_caller_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_callerid_inventory_caller_id ON public.app_callerid_inventory USING btree (caller_id);


--
-- Name: idx_callerid_inventory_cooldown; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_callerid_inventory_cooldown ON public.app_callerid_inventory USING btree (cooldown_until) WHERE ((status)::text = 'COOLING_DOWN'::text);


--
-- Name: idx_callerid_inventory_pool_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_callerid_inventory_pool_status ON public.app_callerid_inventory USING btree (pool_id, status);


--
-- Name: idx_callerid_pool_gateways_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_callerid_pool_gateways_name ON public.app_callerid_pool_gateways USING btree (gateway_name);


--
-- Name: idx_callerid_pool_gateways_pool; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_callerid_pool_gateways_pool ON public.app_callerid_pool_gateways USING btree (pool_id);


--
-- Name: idx_callerid_pools_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_callerid_pools_account ON public.app_callerid_pools USING btree (customer_account);


--
-- Name: idx_callerid_pools_carrier; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_callerid_pools_carrier ON public.app_callerid_pools USING btree (carrier);


--
-- Name: idx_callerid_rotation_logs_acc_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_callerid_rotation_logs_acc_date ON public.app_callerid_rotation_logs USING btree (customer_account, created_at DESC);


--
-- Name: idx_callerid_rotation_logs_gw_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_callerid_rotation_logs_gw_date ON public.app_callerid_rotation_logs USING btree (gateway_name, created_at DESC);


--
-- Name: idx_cdr_account_calltime_talking; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_account_calltime_talking ON public.cdr_records USING btree (customeraccount, call_time DESC) WHERE (feetime > 0);


--
-- Name: idx_cdr_agent_calltime; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_agent_calltime ON public.cdr_records USING btree (agentaccount, call_time DESC);


--
-- Name: idx_cdr_agentaccount; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_agentaccount ON public.cdr_records USING btree (agentaccount);


--
-- Name: idx_cdr_callee_trgm; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_callee_trgm ON public.cdr_records USING gin (calleee164 public.gin_trgm_ops);


--
-- Name: idx_cdr_calleeaccesse164; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_calleeaccesse164 ON public.cdr_records USING btree (calleeaccesse164);


--
-- Name: idx_cdr_calleee164; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_calleee164 ON public.cdr_records USING btree (calleee164);


--
-- Name: idx_cdr_calleegatewayid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_calleegatewayid ON public.cdr_records USING btree (calleegatewayid);


--
-- Name: idx_cdr_calleegw_calltime; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_calleegw_calltime ON public.cdr_records USING btree (calleegatewayid, call_time DESC);


--
-- Name: idx_cdr_calleeip; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_calleeip ON public.cdr_records USING btree (calleeip);


--
-- Name: idx_cdr_calleetogatewaye164; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_calleetogatewaye164 ON public.cdr_records USING btree (calleetogatewaye164);


--
-- Name: idx_cdr_calleraccesse164; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_calleraccesse164 ON public.cdr_records USING btree (calleraccesse164);


--
-- Name: idx_cdr_callere164; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_callere164 ON public.cdr_records USING btree (callere164);


--
-- Name: idx_cdr_callergatewayid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_callergatewayid ON public.cdr_records USING btree (callergatewayid);


--
-- Name: idx_cdr_callerip; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_callerip ON public.cdr_records USING btree (callerip);


--
-- Name: idx_cdr_callertogatewaye164; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_callertogatewaye164 ON public.cdr_records USING btree (callertogatewaye164);


--
-- Name: idx_cdr_customeraccount; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_customeraccount ON public.cdr_records USING btree (customeraccount);


--
-- Name: idx_cdr_customername; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_customername ON public.cdr_records USING btree (customername);


--
-- Name: idx_cdr_endreason; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_endreason ON public.cdr_records USING btree (endreason);


--
-- Name: idx_cdr_files_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_files_account ON public.app_cdr_exported_files USING btree (customer_account);


--
-- Name: idx_cdr_files_approval_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_files_approval_status ON public.app_cdr_exported_files USING btree (customer_account, approval_status);


--
-- Name: idx_cdr_files_created; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_files_created ON public.app_cdr_exported_files USING btree (created_at DESC);


--
-- Name: idx_cdr_files_email_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_files_email_status ON public.app_cdr_exported_files USING btree (email_status);


--
-- Name: idx_cdr_files_filter_params; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_files_filter_params ON public.app_cdr_exported_files USING gin (filter_params);


--
-- Name: idx_cdr_files_invoice_no; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_files_invoice_no ON public.app_cdr_exported_files USING btree (invoice_no);


--
-- Name: idx_cdr_holdtime; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_holdtime ON public.cdr_records USING btree (holdtime);


--
-- Name: idx_cdr_records_answertime; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_records_answertime ON public.cdr_records USING btree (call_time DESC, answertime DESC) WHERE (answertime > 0);


--
-- Name: idx_cdr_records_invitetime; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_records_invitetime ON public.cdr_records USING btree (call_time DESC, invitetime DESC);


--
-- Name: idx_cdr_device_ringing; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_device_ringing ON public.cdr_records USING btree (call_time DESC, is_device_ringing);


--
-- Name: idx_cdr_schedules_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_schedules_account ON public.app_cdr_export_schedules USING btree (customer_account);


--
-- Name: idx_cdr_schedules_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_schedules_active ON public.app_cdr_export_schedules USING btree (is_active);


--
-- Name: idx_cdr_schedules_filter_params; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_schedules_filter_params ON public.app_cdr_export_schedules USING gin (filter_params);


--
-- Name: idx_cdr_softswitchcallid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_softswitchcallid ON public.cdr_records USING btree (softswitchcallid);


--
-- Name: idx_cdr_stoptime; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_stoptime ON public.cdr_records USING btree (stoptime);


--
-- Name: idx_cdr_sync_logs_server_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_sync_logs_server_time ON public.app_cdr_sync_logs USING btree (server_id, started_at DESC);


--
-- Name: idx_cdr_sync_logs_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_sync_logs_status ON public.app_cdr_sync_logs USING btree (status);


--
-- Name: idx_cdr_sync_logs_sync_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_sync_logs_sync_date ON public.app_cdr_sync_logs USING btree (sync_date);


--
-- Name: idx_cdr_sync_logs_table; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_cdr_sync_logs_table ON public.app_cdr_sync_logs USING btree (table_name);


--
-- Name: idx_http_req_logs_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_http_req_logs_created_at ON public.app_http_request_logs USING btree (created_at DESC);


--
-- Name: idx_http_req_logs_method; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_http_req_logs_method ON public.app_http_request_logs USING btree (method);


--
-- Name: idx_http_req_logs_path; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_http_req_logs_path ON public.app_http_request_logs USING btree (path);


--
-- Name: idx_http_req_logs_server_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_http_req_logs_server_id ON public.app_http_request_logs USING btree (server_id);


--
-- Name: idx_http_req_logs_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_http_req_logs_status ON public.app_http_request_logs USING btree (response_status);


--
-- Name: idx_http_req_logs_username; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_http_req_logs_username ON public.app_http_request_logs USING btree (username);


--
-- Name: idx_modules_sort; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_modules_sort ON public.app_modules USING btree (sort_order);


--
-- Name: idx_noc_alert_history_state; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_noc_alert_history_state ON public.app_noc_alert_history USING btree (status, triggered_at DESC);


--
-- Name: idx_noc_alert_rules_active; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_noc_alert_rules_active ON public.app_noc_alert_rules USING btree (is_active) WHERE (is_active = true);


--
-- Name: idx_noc_telemetry_cust; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_noc_telemetry_cust ON public.telemetry_noc_stages USING btree (customer_account, bucket_time DESC);


--
-- Name: idx_noc_telemetry_eggw; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_noc_telemetry_eggw ON public.telemetry_noc_stages USING btree (callee_gateway, bucket_time DESC);


--
-- Name: idx_noc_telemetry_ingw; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_noc_telemetry_ingw ON public.telemetry_noc_stages USING btree (caller_gateway, bucket_time DESC);


--
-- Name: idx_noc_telemetry_ips; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_noc_telemetry_ips ON public.telemetry_noc_stages USING btree (caller_ip, callee_ip, bucket_time DESC);


--
-- Name: idx_noc_telemetry_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_noc_telemetry_time ON public.telemetry_noc_stages USING btree (bucket_time DESC);


--
-- Name: idx_period_ctrl_gw; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_period_ctrl_gw ON public.app_gateway_period_control USING btree (gateway_name, type);


--
-- Name: idx_refresh_token_hash; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_refresh_token_hash ON public.app_refresh_tokens USING btree (token_hash);


--
-- Name: idx_refresh_token_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_refresh_token_user_id ON public.app_refresh_tokens USING btree (user_id);


--
-- Name: idx_rg_clearing_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rg_clearing_account ON public.app_vos_routing_gateways USING btree (clearing_account_id);


--
-- Name: idx_rg_remote_ip; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_rg_remote_ip ON public.app_vos_routing_gateways USING btree (remote_ip);


--
-- Name: idx_role_permissions_role; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_role_permissions_role ON public.app_role_permissions USING btree (role_id);


--
-- Name: idx_roles_scope; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_roles_scope ON public.app_roles USING btree (scope_type);


--
-- Name: idx_system_configs_category; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_system_configs_category ON public.app_system_configs USING btree (category);


--
-- Name: idx_telco_prefixes_lookup; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_telco_prefixes_lookup ON public.app_telco_prefixes USING btree (prefix) WHERE (is_active = true);


--
-- Name: idx_user_customer_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_customer_user ON public.app_user_customer_access USING btree (user_id);


--
-- Name: idx_user_roles_user; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_roles_user ON public.app_user_roles USING btree (user_id);


--
-- Name: idx_users_clearing_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_clearing_account ON public.app_users USING btree (clearing_account);


--
-- Name: idx_vos_doc_params_label; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vos_doc_params_label ON public.app_vos_api_doc_params USING btree (api_name, label);


--
-- Name: idx_vos_doc_params_lookup; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vos_doc_params_lookup ON public.app_vos_api_doc_params USING btree (api_name, format_category, sort_order);


--
-- Name: idx_vos_doc_params_search; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vos_doc_params_search ON public.app_vos_api_doc_params USING gin (to_tsvector('simple'::regconfig, (((param_name)::text || ' '::text) || COALESCE(description, ''::text))));


--
-- Name: idx_vos_end_reasons_kpi; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vos_end_reasons_kpi ON public.app_vos_end_reasons USING btree (kpi_category);


--
-- Name: idx_vos_end_reasons_leg; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vos_end_reasons_leg ON public.app_vos_end_reasons USING btree (leg_type);


--
-- Name: idx_vos_end_reasons_ner; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vos_end_reasons_ner ON public.app_vos_end_reasons USING btree (is_ner_success);


--
-- Name: idx_vos_end_reasons_protocol; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_vos_end_reasons_protocol ON public.app_vos_end_reasons USING btree (protocol);


--
-- Name: telemetry_noc_stages_bucket_time_idx; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX telemetry_noc_stages_bucket_time_idx ON public.telemetry_noc_stages USING btree (bucket_time DESC);


-- (ts_insert_blocker triggers handled dynamically by create_hypertable)


--
-- Name: app_audit_logs app_audit_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_audit_logs
    ADD CONSTRAINT app_audit_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id) ON DELETE SET NULL;


--
-- Name: app_callerid_inventory app_callerid_inventory_pool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_callerid_inventory
    ADD CONSTRAINT app_callerid_inventory_pool_id_fkey FOREIGN KEY (pool_id) REFERENCES public.app_callerid_pools(id) ON DELETE CASCADE;


--
-- Name: app_callerid_pool_gateways app_callerid_pool_gateways_pool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_callerid_pool_gateways
    ADD CONSTRAINT app_callerid_pool_gateways_pool_id_fkey FOREIGN KEY (pool_id) REFERENCES public.app_callerid_pools(id) ON DELETE CASCADE;


--
-- Name: app_callerid_rotation_logs app_callerid_rotation_logs_pool_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_callerid_rotation_logs
    ADD CONSTRAINT app_callerid_rotation_logs_pool_id_fkey FOREIGN KEY (pool_id) REFERENCES public.app_callerid_pools(id) ON DELETE SET NULL;


--
-- Name: app_cdr_exported_files app_cdr_exported_files_schedule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_cdr_exported_files
    ADD CONSTRAINT app_cdr_exported_files_schedule_id_fkey FOREIGN KEY (schedule_id) REFERENCES public.app_cdr_export_schedules(id) ON DELETE SET NULL;


--
-- Name: app_http_request_logs app_http_request_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_http_request_logs
    ADD CONSTRAINT app_http_request_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id) ON DELETE SET NULL;


--
-- Name: app_noc_alert_history app_noc_alert_history_rule_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_noc_alert_history
    ADD CONSTRAINT app_noc_alert_history_rule_id_fkey FOREIGN KEY (rule_id) REFERENCES public.app_noc_alert_rules(id) ON DELETE SET NULL;


--
-- Name: app_refresh_tokens app_refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_refresh_tokens
    ADD CONSTRAINT app_refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- Name: app_role_permissions app_role_permissions_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_role_permissions
    ADD CONSTRAINT app_role_permissions_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.app_modules(id) ON DELETE CASCADE;


--
-- Name: app_role_permissions app_role_permissions_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_role_permissions
    ADD CONSTRAINT app_role_permissions_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.app_roles(id) ON DELETE CASCADE;


--
-- Name: app_telco_prefixes app_telco_prefixes_operator_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_telco_prefixes
    ADD CONSTRAINT app_telco_prefixes_operator_id_fkey FOREIGN KEY (operator_id) REFERENCES public.app_telco_operators(id) ON DELETE CASCADE;


--
-- Name: app_user_customer_access app_user_customer_access_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user_customer_access
    ADD CONSTRAINT app_user_customer_access_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- Name: app_user_roles app_user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user_roles
    ADD CONSTRAINT app_user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.app_roles(id) ON DELETE CASCADE;


--
-- Name: app_user_roles app_user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user_roles
    ADD CONSTRAINT app_user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- Name: app_user_vos_access app_user_vos_access_server_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user_vos_access
    ADD CONSTRAINT app_user_vos_access_server_id_fkey FOREIGN KEY (server_id) REFERENCES public.app_vos_servers(id) ON DELETE CASCADE;


--
-- Name: app_user_vos_access app_user_vos_access_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_user_vos_access
    ADD CONSTRAINT app_user_vos_access_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.app_users(id) ON DELETE CASCADE;


--
-- Name: app_users app_users_role_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_users
    ADD CONSTRAINT app_users_role_fkey FOREIGN KEY (role) REFERENCES public.app_roles(code) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: app_vos_api_doc_params app_vos_api_doc_params_api_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_vos_api_doc_params
    ADD CONSTRAINT app_vos_api_doc_params_api_name_fkey FOREIGN KEY (api_name) REFERENCES public.app_vos_api_docs(api_name) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2 (Ubuntu 15.2-1.pgdg22.04+1)
-- Dumped by pg_dump version 15.2 (Ubuntu 15.2-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Data for Name: app_api_catalog; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_api_catalog (id, category, name, method, path, description, required_role, requires_vos_server, default_headers, default_params, default_body, sort_order, is_active, created_at, updated_at) FROM stdin;
f56b2a94-34c1-4e6a-b446-32cf20860d89	CDR Analytics	Get End Reason Dictionary	GET	/api/v1/cdrs/end-reasons	Mengambil peta in-memory kode pemutusan VOS3000 (200 kode) dengan lookup O(1)	ALL	f	{}	{}		1	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
ba0fcf76-3a10-4c4c-970b-10deae179f1d	CDR Analytics	Get CDR Summary & KPIs	GET	/api/v1/cdrs/summary	Agregasi metrik KPI panggilan (Total Calls, ASR %, ACD, PDD, Billed Revenue, Profit Margin)	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{"source": "auto"}		3	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
49199a80-67fb-406a-b8f0-3b3b3fdfa3c0	CDR Analytics	Get 24-Hour Traffic Trend	GET	/api/v1/cdrs/hourly	Distribusi volume panggilan dan status terjawab per jam (00:00 - 23:00)	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{"source": "auto"}		4	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
4f23877e-b0d8-40c4-acc5-c1761c8f419d	CDR Analytics	Get CDR Filter Options	GET	/api/v1/cdrs/options	Daftar unik customer account dan gateway yang aktif bertransaksi hari ini	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		5	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
ceb8ec1a-11b7-4846-b745-20fd536a7094	CDR Analytics	Trigger Manual CDR Sync	POST	/api/v1/cdrs/sync	Pemicu sinkronisasi manual tabel CDR dari MySQL ke PostgreSQL TimescaleDB	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"table_name": "", "date": ""}	7	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
ed4fcecc-778d-4093-9df3-3b69e62f7ee3	CDR ETL Sync	List CDR Sync Audit Logs	GET	/api/v1/system/cdr-sync-logs	Mengambil riwayat log sinkronisasi ETL harian MySQL ke TimescaleDB	ADMIN	f	{}	{"page": "1", "per_page": "20"}		10	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
82c365cb-be9f-424f-97a9-163ee26166c6	CDR ETL Sync	Get CDR Sync Performance Stats	GET	/api/v1/system/cdr-sync-logs/stats	Agregasi performa engine ETL (Total Jobs, Success Rate, Total Inserted)	ADMIN	f	{}	{}		11	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
c0724b0f-8176-46b7-bf05-b997061a8381	CDR ETL Sync	Trigger ETL Daily Sync Job	POST	/api/v1/system/cdr-sync-logs/trigger	Memicu sinkronisasi tabel H-1 spesifik atau seluruh tabel yang tersedia	ADMIN	f	{}	{}	{"server_id": "vos-node-01", "sync_date": "yesterday"}	12	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
71ef16e1-e7c2-4b6d-b08b-4cf9155695c3	CDR ETL Sync	Purge / Truncate Sync Audit Logs	DELETE	/api/v1/system/cdr-sync-logs	Mengosongkan seluruh riwayat log audit sinkronisasi ETL	ADMIN	f	{}	{}		13	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
6306b08f-5206-4f8b-941b-d7dd9726bd18	Active Calls	List Active SIP Sessions	GET	/api/v1/current-calls	Mengambil daftar sesi panggilan aktif VOS3000 secara langsung	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		20	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
bab85fba-7eaa-48a7-a937-aeaa5ecbb9f5	Active Calls	Force Disconnect Active Call	POST	/api/v1/current-calls/disconnect	Memutus paksa sesi panggilan SIP aktif berdasarkan Call ID	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"call_id": 12345}	21	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
1f12265b-af7a-4ff0-8745-b9e5c58dee0f	Customer Accounts	List Customer Accounts	GET	/api/v1/customers	Mengambil daftar akun pelanggan dan saldo terkini dari VOS3000	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		30	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
1f39986e-b7cb-4562-8d5a-1c4b50bbf325	Customer Accounts	Get Customer Account Detail	GET	/api/v1/customers/{account}	Mengambil detail konfigurasi akun pelanggan spesifik	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		31	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
e93977fb-3932-43b7-b80b-0514761d1f93	Customer Accounts	Create Customer Account	POST	/api/v1/customers	Mendaftarkan akun pelanggan baru ke sistem VOS3000	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"account": "cust_test_01", "name": "Customer Test", "password": "TestPassword123!", "feeRateGroup": "Standard"}	32	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
4cbd763c-85b4-45e7-8ab3-173a7e71123b	Customer Accounts	Modify Customer Account	PUT	/api/v1/customers/{account}	Memperbarui konfigurasi akun pelanggan di VOS3000	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"name": "Customer Test Updated", "feeRateGroup": "Standard"}	33	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
42e46db7-3373-48bc-8cc8-f143609a3aaa	Customer Accounts	Deposit / Payment Customer Balance	POST	/api/v1/customers/{account}/pay	Melakukan top up saldo / pembayaran ke akun pelanggan	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"amount": 100000, "memo": "Dev API Top Up Test"}	34	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
d61f3cd3-20a1-4b5e-ba01-5c85f1f65c47	Customer Accounts	Delete Customer Account	DELETE	/api/v1/customers/{account}	Menghapus akun pelanggan dari sistem VOS3000	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		35	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
341ba9f9-271a-4b8a-bbd9-a0bdfe1f24c7	Tariff Rates	List Fee Rate Groups	GET	/api/v1/rates/groups	Mengambil daftar grup paket tarif dari VOS3000	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		40	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
6d480406-5ae6-4524-b911-dcc078d4ec04	Tariff Rates	Get Fee Rates in Group	GET	/api/v1/rates/groups/{name}/rates	Mengambil seluruh aturan tarif prefiks dalam grup tertentu	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		41	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
639a539b-2e19-4c57-80fb-de13fd209a23	Tariff Rates	Create Rate Group	POST	/api/v1/rates/groups	Membuat grup paket tarif baru di VOS3000	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"name": "Rate_Group_Test", "memo": "Dev API Rate Test"}	42	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
3574a4ed-fcec-44c9-b70b-685503065368	Tariff Rates	Modify Rate Group	PUT	/api/v1/rates/groups/{name}	Mengubah nama atau deskripsi grup tarif	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"memo": "Updated memo"}	43	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
016c7c8d-9fd4-4b94-92b1-53e8a506ecb4	Tariff Rates	Delete Rate Group	DELETE	/api/v1/rates/groups/{name}	Menghapus grup paket tarif dari VOS3000	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		44	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
69b40c81-f2c0-4652-802e-853e83700925	Tariff Rates	Add Prefix Rate Rule	POST	/api/v1/rates/groups/{name}/rates	Menambahkan aturan tarif per prefiks tujuan	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"areaCode": "628", "fee": 150.0, "billingType": 0}	45	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
2aacd3e9-03b0-4fa7-8422-9c616d8022cd	Tariff Rates	Delete Prefix Rate Rule	DELETE	/api/v1/rates/groups/{name}/rates/{areaCode}	Menghapus aturan tarif prefiks tertentu	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		46	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
9cdca37e-92cc-4f7d-9e3d-83b3a96e6944	Gateways	List Mapping Gateways	GET	/api/v1/gateways/mappings	Mengambil daftar Mapping Gateway (Inbound/Client Trunk)	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		50	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
cc8151c1-ef41-4479-b682-16aed9aa5237	Gateways	List Online Mapping Gateways	GET	/api/v1/gateways/mappings/online	Mengambil status registrasi live Mapping Gateway	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		51	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
32a21980-145f-4fce-aae4-23572f4c98f6	Gateways	Create Mapping Gateway	POST	/api/v1/gateways/mappings	Mendaftarkan Mapping Gateway baru di VOS3000	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"gatewayId": "GW_MAP_TEST", "ip": "192.168.1.200", "port": 5060, "account": "iaf_portal"}	52	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
2c04924f-4deb-48ac-b6df-9d29b88ad961	Gateways	Modify Mapping Gateway	PUT	/api/v1/gateways/mappings/{name}	Memperbarui konfigurasi Mapping Gateway di VOS3000	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"ip": "192.168.1.201", "port": 5060}	53	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
47c82b65-e046-4a45-9e6a-14a54b8cb94d	Gateways	Delete Mapping Gateway	DELETE	/api/v1/gateways/mappings/{name}	Menghapus Mapping Gateway dari VOS3000	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		54	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
20a3d2a5-a3e8-4742-b6a6-848b3e1f487b	Gateways	List Routing Gateways	GET	/api/v1/gateways/routings	Mengambil daftar Routing Gateway (Outbound/Vendor Trunk)	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		55	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
1afdf73c-0ce9-4676-92c9-64fb004aae64	Gateways	List Online Routing Gateways	GET	/api/v1/gateways/routings/online	Mengambil status registrasi live Routing Gateway	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		56	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
faba2a16-6dd0-4cbb-a4b9-233b30272e94	Gateways	Create Routing Gateway	POST	/api/v1/gateways/routings	Mendaftarkan Routing Gateway baru di VOS3000	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"gatewayId": "GW_ROUT_TEST", "ip": "192.168.1.210", "port": 5060}	57	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
9c6c03ef-0ced-4b6d-b23a-6de28de87f8a	Gateways	Modify Routing Gateway	PUT	/api/v1/gateways/routings/{name}	Memperbarui konfigurasi Routing Gateway di VOS3000	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"ip": "192.168.1.211", "port": 5060}	58	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
a6aa319e-8e39-43fb-8640-be8a24870471	Gateways	Delete Routing Gateway	DELETE	/api/v1/gateways/routings/{name}	Menghapus Routing Gateway dari VOS3000	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		59	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
ef6fe1f5-4156-43b4-b23a-2318cc85ab48	VOS Servers	List Registered Servers	GET	/api/v1/servers	Mengambil daftar seluruh node VOS3000 yang terdaftar di middleware	ALL	f	{}	{}		60	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
a030d438-60ac-40e1-8a02-9e728b46e5dd	VOS Servers	Get Server License Info	GET	/api/v1/servers/license	Memeriksa masa berlaku lisensi VOS3000 softswitch	ALL	f	{}	{}		61	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
04c1ed1b-383f-47ea-b6ca-5edbc8ec5565	User Management	List Users & Permissions	GET	/api/v1/users	Mengambil daftar user web management, role, dan izin server	ADMIN	f	{}	{}		70	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
59de6ff3-800e-4b6f-9af4-d07ea95f2360	User Management	Create User	POST	/api/v1/users	Membuat user baru dengan role ADMIN, OPERATOR, atau CUSTOMER	ADMIN	f	{}	{}	{"username": "test_operator", "password": "Password123!", "full_name": "Test Operator", "role": "OPERATOR", "all_servers_access": true}	71	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
c83b9dac-a27d-4b1f-b8ee-793a070127d0	User Management	Update User	PUT	/api/v1/users/{id}	Memperbarui data profil, peran (role), atau izin server user	ADMIN	f	{}	{}	{"full_name": "Test Operator Updated", "role": "OPERATOR", "all_servers_access": true}	72	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
3cd74c01-b261-4fff-8e9f-74e6d30e1476	User Management	Toggle User Active Status	PATCH	/api/v1/users/{id}/active	Mengaktifkan atau menonaktifkan status login pengguna	ADMIN	f	{}	{}	{"is_active": false}	73	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
f0e09107-873c-46a3-b82e-f73adbd1ab51	User Management	Delete User	DELETE	/api/v1/users/{id}	Menghapus akun pengguna dari database middleware	ADMIN	f	{}	{}		74	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
b402e7e3-f830-46c1-83b0-c1f658db5b31	Authentication	User Login	POST	/api/v1/auth/login	Autentikasi akun dan menghasilkan pasangan Access Token & Refresh Token	PUBLIC	f	{}	{}	{"username": "admin", "password": "voxagrid"}	80	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
76240fad-8e40-4e33-bd30-41053ccaac42	Authentication	Refresh Token	POST	/api/v1/auth/refresh	Memperbarui Access Token berumur pendek menggunakan Refresh Token	PUBLIC	f	{}	{}	{"refresh_token": "<refresh_token>"}	81	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
42909fb8-4f0a-45f4-9f91-e70d873b333b	Authentication	Get Profile (Me)	GET	/api/v1/auth/me	Mengambil profil dan klaim hak akses pengguna yang sedang login	ALL	f	{}	{}		82	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
75193f3f-4eaa-4b14-93e6-25df446645b9	Authentication	Logout & Revoke Token	POST	/api/v1/auth/logout	Mengakhiri sesi dan memasukkan access token ke daftar hitam Redis	ALL	f	{}	{}	{"refresh_token": ""}	83	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
94082bd6-2419-4a07-84bc-08532dad2300	Authentication	Get WebSocket Ticket	GET	/api/v1/auth/ws-ticket	Menghasilkan tiket sekali pakai (One-Time Ticket 30s) untuk koneksi WebSocket	ALL	f	{}	{}		84	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
dbe87daa-7f37-4af2-a6f3-518d5c6a4407	System Operations	Health Check	GET	/health	Pemeriksaan status hidup (liveness/readiness) Go Middleware	PUBLIC	f	{}	{}		90	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
2553feae-0ffa-4930-805e-73b69a9a9969	System Operations	Get Softswitch Apply Status	GET	/api/v1/system/apply/status	Cek status proses sinkronisasi softswitch MBX port 6099	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		91	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
a6286736-fc61-4965-863a-d3523bae6b61	System Operations	Apply Softswitch Changes	POST	/api/v1/system/apply	Mengeksekusi tombol "Apply" VOS GUI untuk reload routing ke MBX memory	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		92	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
d0f47f73-ba8b-4eb3-877a-e60c631673d9	System Operations	List HTTP Audit Request Logs	GET	/api/v1/system/request-logs	Mengambil daftar riwayat audit log request HTTP yang masuk ke middleware	ADMIN	f	{}	{"page": "1", "per_page": "20"}		93	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
080930ff-500b-4eee-94e2-8f5a4c74b5ad	System Operations	Clear HTTP Request Logs	DELETE	/api/v1/system/request-logs	Mengosongkan seluruh riwayat log request HTTP audit	ADMIN	f	{}	{}		94	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
76319560-732b-40b5-8ba0-728675aca339	System Operations	Explore Postgres Tables	GET	/api/v1/system/db/postgres/tables	Melihat daftar tabel dan statistik ukuran database SBC PostgreSQL	ADMIN	f	{}	{}		95	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
fd2a25f6-f20d-41c7-abfa-4b557ef2e734	System Operations	Get VOS3000 Native Catalog	GET	/api/v1/system/vos-api/catalog	Daftar 90 endpoint resmi VOS3000 Web Service port 6099	ADMIN	f	{}	{}		97	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
74ccdb3c-2f61-4c62-8aa9-27cc5f92a105	System Operations	Get Internal API Catalog	GET	/api/v1/system/api-catalog	Daftar katalog API internal VOS-UI Go Middleware yang tersimpan di PostgreSQL	ADMIN	f	{}	{}		98	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
18ee59fb-2d7a-4cc1-a541-73271ad6be5b	System Operations	Generate RBAC Dev Token	POST	/api/v1/system/dev/tokens/generate	Menghasilkan token JWT uji coba secara instan untuk role ADMIN, OPERATOR, atau CUSTOMER	ADMIN	f	{}	{}	{"role": "ADMIN", "username": "admin", "expires_in_minutes": 60}	99	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
ffddea7f-0de5-4859-b493-7857fdbf9681	VOS Servers	Check Server Node Health	GET	/api/v1/servers/{id}/health	Cek konektivitas dan latensi node VOS3000 spesifik	ALL	f	{}	{"id": "vos-node-02"}		62	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
f357a800-a46f-485b-a00e-2ced179cb00e	VOS Servers	Unregister Server Node	DELETE	/api/v1/servers/{id}	Menghapus node VOS3000 dari daftar cluster middleware	ADMIN	f	{}	{"id": "vos-node-03"}		65	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
005592d6-f4a5-4f77-931a-874a31ccd794	VOS Servers	Update Server Settings	PUT	/api/v1/servers/{id}	Memperbarui kredensial, IP, atau jadwal sync node VOS	ADMIN	f	{}	{"id": "vos-node-02"}	{\n  "name": "Surabaya DR Site Node",\n  "api_url": "http://10.0.0.2:6099",\n  "mysql_host": "10.0.0.2",\n  "db_connection_mode": "AGENT_PROXY",\n  "location": "Surabaya Rungkut Tier-3",\n  "max_channels": 2000,\n  "is_active": true,\n  "cdr_sync_time": "00:10",\n  "cdr_sync_enabled": true,\n  "agent_secret": "voxagrid-agent-secret-2026"\n}	64	t	2026-10-07 09:10:15.512021+07	2026-10-30 05:45:00+07
24ca72be-1f41-4e04-a9f5-d27d5c71d9bc	System Operations	Execute Dev API Test Proxy	POST	/api/v1/system/dev/test	Mengeksekusi request uji coba ke REST API internal lokal secara transparan	ADMIN	f	{}	{}	{"method": "GET", "path": "/api/v1/cdrs/end-reasons", "headers": {"Authorization": "Bearer <token>"}, "body": ""}	100	t	2026-10-07 09:17:51.959477+07	2026-10-07 09:17:51.959477+07
697b25cb-9454-4453-ad50-abca7beecac6	CDR Analytics	Query CDR Records (Hybrid)	GET	/api/v1/cdrs	Kueri rekaman CDR hibrida dengan 16 parameter filter VOS GUI baku (Agent ID, Account, Caller/Callee Wildcard, Hold Time, In/Out Gateway, IP, Select Time Begin/End)	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{"page": "1", "callee": "", "caller": "", "source": "auto", "agent_id": "", "per_page": "20", "account_id": "", "select_time": "begin", "hold_time_max": "", "hold_time_min": ""}		2	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
10b76d08-4fc4-427a-b2e9-216218c7189b	CDR Analytics	Export CDRs to CSV (Streaming)	GET	/api/v1/cdrs/export	Streaming ekspor data CDR ke format RFC 4180 CSV dengan UTF-8 BOM, mendukung seluruh 16 filter baku VOS GUI	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{"callee": "", "caller": "", "format": "csv", "agent_id": "", "account_id": "", "select_time": "begin", "min_duration": "0", "answered_only": "false", "hold_time_max": "", "hold_time_min": ""}		6	t	2026-10-07 09:10:15.512021+07	2026-10-07 09:10:15.512021+07
ab4828e9-a1aa-4c6f-bfae-9f95a01a6bf7	SIP Debug Trace	Get Trace Status	GET	/api/v1/traces/status	Mengambil status debug trace global (VOS softswitch) dan daftar gateway (routing/mapping) yang sedang aktif ditrace	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		100	t	2026-10-07 14:43:37.008851+07	2026-10-07 14:43:37.008851+07
b171c20e-760b-4e36-852d-86ab16bf91e7	SIP Debug Trace	Get Recent Traced Calls	GET	/api/v1/traces/recent-calls	Mengambil daftar panggilan yang terekam dalam buffer trace aktif (Call ID, Caller, Callee, Start Time)	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{"limit": "50"}		101	t	2026-10-07 14:43:37.008851+07	2026-10-07 14:43:37.008851+07
b4172269-7e24-479e-b9d6-d9c41d5aa144	SIP Debug Trace	Control Global Debug Trace	POST	/api/v1/traces/control	Mengaktifkan atau menonaktifkan SIP debug trace global VOS3000 softswitch (MGC 8008123)	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"action": "enable", "duration_seconds": 600, "max_size_mb": 50}	103	t	2026-10-07 14:43:37.008851+07	2026-10-07 14:43:37.008851+07
a1b33fa1-e187-4ff0-9f9b-1b383bed7c12	SIP Debug Trace	Control Gateway Targeted Trace	POST	/api/v1/traces/gateways/control	Mengaktifkan atau menonaktifkan SIP call tracing spesifik pada Routing Gateway atau Mapping Gateway tertentu	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"action": "enable", "gateway_type": "routing", "gateway_name": "IAF-TELCO-SME", "duration_seconds": 600}	104	t	2026-10-07 14:43:37.008851+07	2026-10-07 14:43:37.008851+07
a5cd819e-f8ad-4524-9d84-fb1d6e4c2b01	SIP Debug Trace	Get SIP Call Flow Diagram (Homer Standard)	GET	/api/v1/traces/calls/61906	Mengambil ladder diagram SIP flow terstruktur Homer, parsed headers, SDP details, dan internal routing memos VOS3000. Parameter URL dapat diisi Flow No (contoh: 61906) atau 19-digit Softswitch Call ID.	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		102	t	2026-10-07 14:43:37.008851+07	2026-10-07 14:43:37.008851+07
164e8308-f1d8-4a25-913b-cb9caacb19bc	SIP Debug Trace	Export SIP Call Flow as PCAP	GET	/api/v1/traces/calls/61906/pcap	Mengekspor rekaman jejak sinyal SIP ke berkas biner standar PCAP (libpcap) yang dapat langsung diunduh dan dibuka di Wireshark atau sngrep.	ALL	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		104	t	2026-10-07 17:17:32.587088+07	2026-10-07 17:17:32.587088+07
ce8afd60-d863-437d-a31e-88256a3ce41c	VosApplyAgent (Port 9095)	Check Agent Health	GET	/api/v1/system/agent/health	Pemeriksaan liveness micro-server HTTP VosApplyAgent yang berjalan di dalam JVM VOS3000 host port 9095	ADMIN	t	{}	{}		101	t	2026-10-07 09:31:49.243413+07	2026-10-07 09:31:49.243413+07
6b629a18-ba9c-4d29-b9e6-1bb844cfb3d8	VosApplyAgent (Port 9095)	Check MBX Softswitch Status	GET	/api/v1/system/agent/status	Mengecek status koneksi socket MGC MBX3000 softswitch (MBX ID, socket ID, config serial) dari port 9095	ADMIN	t	{}	{}		102	t	2026-10-07 09:31:49.243413+07	2026-10-07 09:31:49.243413+07
868684e3-960e-4fcb-b474-7d3493697aff	VosApplyAgent (Port 9095)	Trigger Softswitch Apply (Reload Memory)	POST	/api/v1/system/agent/apply	Memicu reload memori live softswitch MBX3000 via protokol MGC TaskSynchronizeMbx (ekuivalen tombol Apply VOS GUI)	ADMIN	t	{}	{}		103	t	2026-10-07 09:31:49.243413+07	2026-10-07 09:31:49.243413+07
eb260b42-ec79-4b04-a576-9aa2c1e002c1	VosApplyAgent (Port 9095)	Fix Rate Group Ownership (user_id=1)	POST	/api/v1/system/agent/fix-ownership	Mengubah kepemilikan grup tarif baru ke user_id = 1 (admin) agar otomatis tampil di GUI desktop VOS Client	ADMIN	t	{}	{}		104	t	2026-10-07 09:31:49.243413+07	2026-10-07 09:31:49.243413+07
ffe0be82-e552-4e2d-9024-2db4a32f814a	Web Access Control (Port 9096)	Get Host Web Server Port (Tomcat)	GET	/api/v1/system/agent/web-server-port	Mendapatkan HTTP API PORT atau WEB SERVER PORT Apache Tomcat di host port (default 6099) dari berkas /home/kunshiweb/base/apache-tomcat/conf/server.xml via VosHostMonitor port 9096	ADMIN	t	{}	{}		105	t	2026-10-08 08:38:42.473444+07	2026-10-08 08:38:42.473444+07
8d2903c6-6d8c-4eab-8a5a-6dd98a199b3a	Process Monitor (Port 9096)	Get VOS3000 Process Monitor Status	GET	/api/v1/system/processes	Mengambil status live 10 daemon VOS3000 (mbx3000d, vos3000d, empd, callserviced, mgcd, webserverd, webdatad, audioplayerd, mediarecordd, servermonitord) beserta PID, Uptime, RAM, CPU %, dan status sinkronisasi MySQL e_moexternal (type=4).	OPERATOR	t	{"X-VOS-Server-ID": "vos-node-01"}	{"refresh": "false"}		10	t	2026-10-21 09:51:50.910001+07	2026-10-21 09:51:50.910001+07
4d0b27bc-1e7a-4e55-8432-d014199e7607	Process Monitor (Port 9096)	Restart / Start VOS3000 Daemon Service	POST	/api/v1/system/processes/restart	Me-restart atau menghidupkan service daemon VOS3000 tertentu pada server aktif. Dijaga oleh parameter keamanan process_monitor_allow_restart (MONITORING) di System Parameters.	ADMIN	t	{"Content-Type": "application/json", "X-VOS-Server-ID": "vos-node-01"}	{}	{"service": "servermonitord", "action": "restart"}	20	t	2026-10-21 09:51:50.910001+07	2026-10-21 09:51:50.910001+07
49380463-5e30-49ee-93fa-29476c41be33	Process Monitor (Port 9096)	Sync Process Monitor to VOS3000 Desktop GUI	POST	/api/v1/system/processes/sync-gui	Memastikan wrapper boot-safe /usr/sbin/runlevel dan urutan Should-Start terpasang, lalu me-restart servermonitord agar seluruh 9 service VOS3000 tersinkronisasi ke tabel MySQL e_moexternal (type=4) dan tampil di VOS3000 GUI.	ADMIN	t	{"Content-Type": "application/json", "X-VOS-Server-ID": "vos-node-01"}	{}	{}	30	t	2026-10-21 09:51:50.910001+07	2026-10-21 09:51:50.910001+07
92b1c2ef-db5f-4bed-8a17-f8802b88ad06	MySQL Database & Security (Port 9096)	Test MySQL Connection (VOS Host)	POST	/api/v1/servers/test-mysql	Menguji konektivitas ke basis data MySQL VOS softswitch. Secara default menggunakan mode AGENT_PROXY via VosHostMonitor (Port 9096) dengan proteksi Zero Open Port 3306. Mendukung fallback ke mode DIRECT_MYSQL (Port 3306 legacy).	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{\n  "server_id": "vos-node-01",\n  "db_connection_mode": "AGENT_PROXY",\n  "mysql_host": "127.0.0.1",\n  "agent_secret": "voxagrid-agent-secret-2026"\n}	120	t	2026-10-22 12:42:32.356942+07	2026-10-30 05:45:00+07
56ccc6db-895d-41e2-b0af-70a8703fc4a6	MySQL Database & Security (Port 9096)	Get MySQL Users & Privileges (Unified Endpoint - Port 9096)	GET	/api/v1/system/db/mysql/users	Mengambil daftar seluruh pengguna MySQL VOS3000 beserta ringkasan privileges dan klasifikasi tingkat akses (SUPERUSER, READ_ONLY, READ_WRITE, ANONYMOUS). Dilengkapi filter opsional per username dan host untuk inspeksi granular raw grants via VosHostMonitor port 9096.	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{"host": "127.0.0.1", "username": "voxagrid"}		121	t	2026-10-22 12:10:02.134871+07	2026-10-22 12:10:02.134871+07
86b85d43-9c5c-490f-b27b-33df2f12188f	MySQL Database & Security (Port 9096)	Grant MySQL Read-Only Access (Port 9096)	POST	/api/v1/system/db/mysql/grant-readonly	Memberikan hak akses READ ONLY (SELECT, SHOW VIEW) pada database VOS3000 MySQL via VosHostMonitor port 9096 dan otomatis mengupdate bind-address=0.0.0.0 pada /etc/my.cnf jika masih localhost	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"username": "voxagrid", "password": "voxagrid", "database": "vos3000", "allow_ip": "127.0.0.1"}	122	t	2026-10-22 11:43:19.851397+07	2026-10-22 11:43:19.851397+07
39147a16-9e12-4ed8-9a17-64f0726ccc51	Web Access Control (Port 9096)	View Web Access Control (Whitelist via Host 9096)	GET	/api/v1/system/web_access_control/view	Mengambil daftar whitelist IP Apache Tomcat VOS3000 dari tabel e_web_access_control via VosHostMonitor port 9096	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}		106	t	2026-10-21 14:34:13.225372+07	2026-10-21 14:34:13.225372+07
50bc109b-76ab-4936-9829-7b2d43433ea3	Web Access Control (Port 9096)	Add Whitelist IP (Atomic Host 9096 + Graceful Reload)	POST	/api/v1/system/web_access_control/add	Menambahkan IP baru ke daftar allowip e_web_access_control dan reload konfigurasi Apache Tomcat secara live via VosHostMonitor port 9096	ADMIN	t	{"Content-Type": "application/json", "X-VOS-Server-ID": "vos-node-01"}	{}	{"ip": "10.0.0.10"}	107	t	2026-10-21 14:34:13.225372+07	2026-10-21 14:34:13.225372+07
2bc9f1aa-c3cd-4e23-bd8d-a18dc2f75b06	Web Access Control (Port 9096)	Delete Whitelist IP (Atomic Host 9096 + Graceful Reload)	POST	/api/v1/system/web_access_control/delete	Menghapus IP dari daftar allowip e_web_access_control dan reload konfigurasi Apache Tomcat secara live via VosHostMonitor port 9096	ADMIN	t	{"Content-Type": "application/json", "X-VOS-Server-ID": "vos-node-01"}	{}	{"ip": "10.0.0.10"}	108	t	2026-10-21 14:34:13.225372+07	2026-10-21 14:34:13.225372+07
f117a4cd-1507-41e2-af7d-a91006ad8f55	MySQL Database & Security (Port 9096)	Explore MySQL Tables & Schema (DB Explorer)	GET	/api/v1/system/db/mysql/tables	Melihat daftar tabel dan statistik ukuran database VOS3000 MySQL via Agent Proxy (Port 9096)	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{"server_id": "vos-node-01"}		124	t	2026-10-07 09:10:15.512021+07	2026-10-30 05:45:00+07
6014786a-e1e6-45df-b78b-096df17d9cfd	MySQL Database & Security (Port 9096)	Delete MySQL User & Revoke All Privileges (Port 9096)	POST	/api/v1/system/db/mysql/delete-user	Menghapus akun pengguna MySQL VOS3000 dan mencabut seluruh hak akses (REVOKE ALL PRIVILEGES, GRANT OPTION & DROP USER) secara tuntas via VosHostMonitor port 9096. Dilengkapi proteksi pengamanan akun inti sistem (root, vos3000, webdata).	ADMIN	t	{"X-VOS-Server-ID": "vos-node-01"}	{}	{"username": "voxagrid", "host": "127.0.0.1"}	123	t	2026-10-22 12:10:02.138654+07	2026-10-22 12:10:02.138654+07
a1c43f8e-89a1-42cb-b1b7-4c28131e5001	MySQL Database & Security (Port 9096)	Get MySQL Table Structure (DB Explorer)	GET	/api/v1/system/db/mysql/tables/{tableName}	Mendapatkan skema kolom, tipe data, primary key, dan definisi indeks tabel MySQL VOS3000 via Agent Proxy (Port 9096).	ADMIN	f	{}	{"server_id": "vos-node-01"}		125	t	2026-10-30 05:45:00+07	2026-10-30 05:45:00+07
b2d54e9f-9ab2-43dc-c2c8-5d39242f6002	MySQL Database & Security (Port 9096)	Browse MySQL Table Data (DB Explorer)	GET	/api/v1/system/db/mysql/tables/{tableName}/data	Menjelajah isi rekaman baris tabel MySQL VOS3000 dengan dukungan pagination, sorting kolom, dan filter pencarian via Agent Proxy (Port 9096).	ADMIN	f	{}	{"page": "1", "pageSize": "25", "server_id": "vos-node-01"}		126	t	2026-10-30 05:45:00+07	2026-10-30 05:45:00+07
85c75609-6579-4e00-a2af-c1665d60a390	VOS Servers	Test VOS Web API Connectivity (Port 6099)	POST	/api/v1/servers/test-web-api	Menguji konektivitas TCP socket ke port upstream VOS Web API (Apache Tomcat / Port 6099) dan mengukur latensi round-trip secara presisi sebelum mendaftarkan atau menyimpan konfigurasi node softswitch.	ADMIN	f	{"Content-Type": "application/json"}	{}	{"host": "127.0.0.1", "port": 6099}	66	t	2026-10-22 13:04:20.702838+07	2026-10-22 13:04:20.702838+07
8bd8af22-1734-4fd1-87fb-ebe5a8bcc8ab	VosApplyAgent (Port 9095)	Test vos-apply-agent Connectivity (Port 9095)	POST	/api/v1/servers/test-agent	Menguji handshake HTTP health check dan otentikasi X-VOS-Agent-Key ke daemon vos-apply-agent pada port 9095 host VOS serta mengukur latensi respons.	ADMIN	f	{"Content-Type": "application/json"}	{}	{"host": "127.0.0.1", "port": 9095, "agent_secret": "voxagrid-agent-secret-2026"}	100	t	2026-10-22 13:04:20.706492+07	2026-10-22 13:04:20.706492+07
e903d78b-e0ff-4415-b43a-2d641545034b	Process Monitor (Port 9096)	Test vos-host-monitor Connectivity (Port 9096)	POST	/api/v1/servers/test-agent	Menguji handshake HTTP health check dan otentikasi X-VOS-Agent-Key ke daemon standalone vos-host-monitor pada port 9096 host VOS serta mengukur latensi respons.	ADMIN	f	{"Content-Type": "application/json"}	{}	{"host": "127.0.0.1", "port": 9096, "agent_secret": "voxagrid-agent-secret-2026"}	5	t	2026-10-22 13:04:20.706788+07	2026-10-22 13:04:20.706788+07
02a7c047-ffde-4d4c-bbf9-b0c1611a16e8	VOS Servers	Register New VOS Node	POST	/api/v1/servers	Mendaftarkan node VOS3000 baru ke dalam cluster	ADMIN	f	{}	{}	{\n  "id": "vos-node-03",\n  "name": "VOS Disaster Recovery",\n  "host": "10.0.0.3",\n  "web_port": 6099,\n  "api_url": "http://10.0.0.3:6099",\n  "mysql_host": "10.0.0.3",\n  "db_connection_mode": "AGENT_PROXY",\n  "location": "Surabaya DR Site",\n  "max_channels": 1000,\n  "cdr_sync_time": "00:25",\n  "agent_secret": "voxagrid-agent-secret-2026"\n}	63	t	2026-10-07 09:10:15.512021+07	2026-10-30 05:45:00+07
\.


--
-- Data for Name: app_modules; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_modules (id, name, group_title, path, icon, sort_order, is_customer_visible, is_active, created_at, updated_at) FROM stdin;
dashboard	NOC Dashboard	REALTIME & OPERATIONAL	/	LayoutDashboard	10	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
current_calls	Current Calls	REALTIME & OPERATIONAL	/current-calls	Radio	20	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
cdrs	CDR Analytics	REALTIME & OPERATIONAL	/cdrs	FileText	30	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
customers	Account Management	REALTIME & OPERATIONAL	/customers	Users	40	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
rates	Rate Management	REALTIME & OPERATIONAL	/rates	Tag	50	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
noc_vendor_quality	Vendor Route Quality	NOC INTELLIGENCE & QUALITY	/noc/vendor-quality	Activity	110	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
noc_traffic_ccr	Traffic & CCR Timeseries	NOC INTELLIGENCE & QUALITY	/noc/traffic-ccr	LineChart	120	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
noc_ingress_leakage	Ingress Drop Leakage	NOC INTELLIGENCE & QUALITY	/noc/ingress-leakage	AlertOctagon	130	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
noc_silent_failures	Dead Air & Silent Failure	NOC INTELLIGENCE & QUALITY	/noc/silent-failures	VolumeX	140	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
noc_telco_matrix	Indonesia Telco Matrix	NOC INTELLIGENCE & QUALITY	/noc/telco-matrix	Signal	150	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
noc_alert_settings	NOC Alarms & Policy	NOC INTELLIGENCE & QUALITY	/noc/alert-settings	Bell	160	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
noc_end_reasons	End Reason Taxonomy	NOC INTELLIGENCE & QUALITY	/noc/end-reasons	BookOpen	170	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
settings	Server & License	PLATFORM & CLUSTER CONTROL	/settings	Settings	210	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
process_monitor	Host Process Monitor	PLATFORM & CLUSTER CONTROL	/system/process-monitor	Activity	220	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
users	User Management	PLATFORM & CLUSTER CONTROL	/users	UserCheck	230	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
cdr_sync_audit	CDR Settlement Audit	PLATFORM & CLUSTER CONTROL	/cdr-sync-audit	RefreshCw	240	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
db_hub	Database Hub	ENGINEERING & LAB TOOLS	/db/postgres	Database	310	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
api_testing	API Diagnostic Studio	ENGINEERING & LAB TOOLS	/api-testing	FlaskConical	320	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
system_configs	System Parameters & Dynamic Config	ENGINEERING & LAB TOOLS	/system/configs	Sliders	330	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
request_logs	HTTP Request Logs & Audit	ENGINEERING & LAB TOOLS	/request-logs	ScrollText	340	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
vos_api	VOS3000 Native API Console	ENGINEERING & LAB TOOLS	/vos-api	Terminal	350	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
routing_gateways	Routing Gateways (Egress)	REALTIME & OPERATIONAL	/gateways?tab=routing	GitBranch	60	t	t	2026-10-23 16:28:31.256026+07	2026-10-23 16:28:31.256026+07
mapping_gateways	Mapping Gateways (Ingress)	REALTIME & OPERATIONAL	/gateways?tab=mapping	Server	65	t	t	2026-10-23 16:28:31.256026+07	2026-10-23 16:28:31.256026+07
gateway_analysis	Gateway Analisis	REALTIME & OPERATIONAL	/gateways/analysis	Teal	70	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
cdr_export	Billing & Settlement	BILLING & FINANCIAL	/billing	FileSpreadsheet	85	t	t	2026-10-23 17:12:38.18351+07	2026-10-26 12:29:48.097914+07
callerid_pools	Dynamic Caller ID	Routing & Gateway	/callerid-pools	PhoneForwarded	45	t	t	2026-10-27 12:17:19.376953+07	2026-10-27 12:17:19.376953+07
vendor_daily_analysis	Vendor Wholesale Daily	REALTIME & OPERATIONAL	/gateways/vendor-daily	Building2	75	f	t	2026-10-28 09:26:56.218833+07	2026-10-28 09:26:56.218833+07
\.


--
-- Data for Name: app_noc_alert_rules; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_noc_alert_rules (id, rule_code, name, metric_type, target_scope, scope_id, condition_op, threshold_value, window_minutes, min_attempts, severity, channels, cooldown_minutes, is_active, last_triggered_at, created_at, updated_at) FROM stdin;
3	VENDOR_CONGESTION	Vendor Trunk Congestion (34 / 503)	END_REASON_SPIKE	ALL	\N	>=	15	5	20	CRITICAL	["WEB", "TELEGRAM"]	15	t	\N	2026-10-10 15:32:46.127364+07	2026-10-10 15:32:46.127364+07
5	CODEC_MISMATCH	Audio Codec Mismatch (-45 / 488)	CODEC_MISMATCH	ALL	\N	>=	3	10	5	WARNING	["WEB"]	30	t	\N	2026-10-10 15:32:46.127364+07	2026-10-10 15:32:46.127364+07
1	CLEARING_DEPLETED	Clearing Account Deposit Habis (-63)	INGRESS_DROP	ALL	\N	>=	75	15	25	CRITICAL	null	5	t	\N	2026-10-10 15:32:46.127364+07	2026-10-12 21:24:16.082147+07
4	DEAD_AIR_TIMEOUT	Vendor Process Timeout (-34 Dead Air)	END_REASON_SPIKE	ALL	\N	>=	5	5	10	WARNING	["WEB", "TELEGRAM"]	15	t	\N	2026-10-10 15:32:46.127364+07	2026-10-10 15:32:46.127364+07
6	LOW_NER_RADAR	Clean NER Rute Vendor Anjlok (< 60%)	CLEAN_NER	ALL	\N	<	60	10	30	CRITICAL	["WEB", "TELEGRAM"]	15	t	\N	2026-10-10 15:32:46.127364+07	2026-10-10 15:32:46.127364+07
2	MISSING_ROUTE	Rute Dialplan Tidak Ditemukan (-69)	INGRESS_DROP	ALL	\N	>=	5	5	5	WARNING	["WEB", "TELEGRAM"]	15	t	\N	2026-10-10 15:32:46.127364+07	2026-10-10 15:32:46.127364+07
\.


--
-- Data for Name: app_roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_roles (id, code, name, description, scope_type, is_system, created_at, updated_at) FROM stdin;
09b11494-6458-4b42-8515-cbe68e9d308d	ADMIN	Super Administrator	Full control root access ke seluruh node VOS, database, routing, dan pengaturan otorisasi sistem	SYSTEM	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	OPERATOR	NOC General Operator	Akses operasional pemantauan rute, analisis kualitas, dan gateway multi-node	NOC	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
65d01478-539a-423a-bb92-d820e5ced5f0	NOC_L1	NOC Tier-1 (View Only)	Akses pemantauan dashboard, current calls, dan analitik kualitas (Tanpa hak modifikasi rute/gateway)	NOC	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
84846f41-1e06-47df-8b52-af541f0aace1	NOC_L2	NOC Tier-2 (Routing Specialist)	Akses penuh untuk rekayasa rute, penambahan gateway, dan pengelolaan tarif pada node yang diizinkan	NOC	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
46f4b1db-8d02-44a6-8318-30ffd8c72335	BILLING	Billing & CDR Auditor	Akses audit CDR historis, rekonsiliasi finansial, dan ekspor laporan CSV	NOC	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
b510b2f8-1872-4337-99cd-66903351dd14	CUSTOMER	Customer Portal User	Portal mandiri pelanggan untuk pemantauan live calls, CDR, CCR timeseries, dan ekspor billing akun	CUSTOMER	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
\.


--
-- Data for Name: app_role_permissions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_role_permissions (role_id, module_id, can_view, can_create, can_edit, can_delete, can_execute, can_export, created_at, updated_at) FROM stdin;
09b11494-6458-4b42-8515-cbe68e9d308d	dashboard	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	current_calls	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	cdrs	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	customers	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	rates	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	cdr_export	t	t	t	t	t	t	2026-10-23 17:12:38.18351+07	2026-10-23 17:12:38.18351+07
09b11494-6458-4b42-8515-cbe68e9d308d	gateway_analysis	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	noc_vendor_quality	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	noc_traffic_ccr	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	noc_ingress_leakage	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	noc_silent_failures	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	noc_telco_matrix	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	noc_alert_settings	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	noc_end_reasons	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	settings	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	process_monitor	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	users	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	cdr_sync_audit	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	db_hub	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	api_testing	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	system_configs	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	request_logs	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	vos_api	t	t	t	t	t	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	dashboard	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	current_calls	t	f	f	f	t	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	cdrs	t	f	f	f	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	customers	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	rates	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
46f4b1db-8d02-44a6-8318-30ffd8c72335	cdr_export	t	t	t	t	t	t	2026-10-23 17:12:38.18351+07	2026-10-23 17:12:38.18351+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	gateway_analysis	t	f	f	f	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	noc_vendor_quality	t	f	f	f	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	noc_traffic_ccr	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	noc_ingress_leakage	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	noc_silent_failures	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	noc_telco_matrix	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	noc_alert_settings	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	noc_end_reasons	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	settings	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	process_monitor	t	f	f	f	t	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	cdr_sync_audit	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	api_testing	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	vos_api	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
65d01478-539a-423a-bb92-d820e5ced5f0	dashboard	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
65d01478-539a-423a-bb92-d820e5ced5f0	current_calls	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
65d01478-539a-423a-bb92-d820e5ced5f0	cdrs	t	f	f	f	f	t	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
09b11494-6458-4b42-8515-cbe68e9d308d	callerid_pools	t	t	t	t	t	t	2026-10-27 12:17:19.3837+07	2026-10-27 12:17:19.3837+07
65d01478-539a-423a-bb92-d820e5ced5f0	gateway_analysis	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
65d01478-539a-423a-bb92-d820e5ced5f0	noc_vendor_quality	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
65d01478-539a-423a-bb92-d820e5ced5f0	noc_traffic_ccr	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
65d01478-539a-423a-bb92-d820e5ced5f0	noc_ingress_leakage	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
65d01478-539a-423a-bb92-d820e5ced5f0	noc_silent_failures	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
65d01478-539a-423a-bb92-d820e5ced5f0	noc_telco_matrix	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
65d01478-539a-423a-bb92-d820e5ced5f0	noc_end_reasons	t	f	f	f	f	f	2026-10-23 14:28:19.991455+07	2026-10-23 14:28:19.991455+07
84846f41-1e06-47df-8b52-af541f0aace1	dashboard	t	f	f	f	f	t	2026-10-23 16:03:42.142132+07	2026-10-23 16:03:42.142132+07
84846f41-1e06-47df-8b52-af541f0aace1	current_calls	t	f	f	f	f	t	2026-10-23 16:03:42.142132+07	2026-10-23 16:03:42.142132+07
84846f41-1e06-47df-8b52-af541f0aace1	cdrs	t	f	f	f	f	t	2026-10-23 16:03:42.142132+07	2026-10-23 16:03:42.142132+07
84846f41-1e06-47df-8b52-af541f0aace1	customers	t	t	t	f	f	t	2026-10-23 16:03:42.142132+07	2026-10-23 16:03:42.142132+07
84846f41-1e06-47df-8b52-af541f0aace1	rates	t	t	t	t	f	t	2026-10-23 16:03:42.142132+07	2026-10-23 16:03:42.142132+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	cdr_export	t	f	f	f	f	t	2026-10-23 17:12:38.18351+07	2026-10-23 17:12:38.18351+07
84846f41-1e06-47df-8b52-af541f0aace1	gateway_analysis	t	f	f	f	f	t	2026-10-23 16:03:42.142132+07	2026-10-23 16:03:42.142132+07
84846f41-1e06-47df-8b52-af541f0aace1	noc_vendor_quality	t	f	f	f	f	t	2026-10-23 16:03:42.142132+07	2026-10-23 16:03:42.142132+07
84846f41-1e06-47df-8b52-af541f0aace1	noc_traffic_ccr	t	f	f	f	f	t	2026-10-23 16:03:42.142132+07	2026-10-23 16:03:42.142132+07
84846f41-1e06-47df-8b52-af541f0aace1	settings	t	f	f	f	f	t	2026-10-23 16:03:42.142132+07	2026-10-23 16:03:42.142132+07
84846f41-1e06-47df-8b52-af541f0aace1	process_monitor	t	f	f	f	f	f	2026-10-23 16:03:42.142132+07	2026-10-23 16:03:42.142132+07
84846f41-1e06-47df-8b52-af541f0aace1	db_hub	t	f	f	f	f	f	2026-10-23 16:03:42.142132+07	2026-10-23 16:03:42.142132+07
65d01478-539a-423a-bb92-d820e5ced5f0	cdr_export	t	f	f	f	f	t	2026-10-23 17:12:38.18351+07	2026-10-23 17:12:38.18351+07
84846f41-1e06-47df-8b52-af541f0aace1	cdr_export	t	f	f	f	f	t	2026-10-23 17:12:38.18351+07	2026-10-23 17:12:38.18351+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	callerid_pools	t	t	t	t	t	t	2026-10-27 12:17:19.38635+07	2026-10-27 12:17:19.38635+07
84846f41-1e06-47df-8b52-af541f0aace1	callerid_pools	t	t	t	t	t	t	2026-10-27 12:17:19.38635+07	2026-10-27 12:17:19.38635+07
b510b2f8-1872-4337-99cd-66903351dd14	callerid_pools	t	f	f	f	f	t	2026-10-27 12:17:19.386841+07	2026-10-27 12:17:19.386841+07
65d01478-539a-423a-bb92-d820e5ced5f0	callerid_pools	t	f	f	f	f	f	2026-10-27 12:17:19.387139+07	2026-10-27 12:17:19.387139+07
46f4b1db-8d02-44a6-8318-30ffd8c72335	callerid_pools	t	f	f	f	f	f	2026-10-27 12:17:19.387139+07	2026-10-27 12:17:19.387139+07
09b11494-6458-4b42-8515-cbe68e9d308d	vendor_daily_analysis	t	t	t	t	t	t	2026-10-28 09:26:56.218833+07	2026-10-28 09:26:56.218833+07
84846f41-1e06-47df-8b52-af541f0aace1	vendor_daily_analysis	t	t	t	t	t	t	2026-10-28 09:26:56.218833+07	2026-10-28 09:26:56.218833+07
65d01478-539a-423a-bb92-d820e5ced5f0	vendor_daily_analysis	t	f	f	f	f	t	2026-10-28 09:26:56.218833+07	2026-10-28 09:26:56.218833+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	vendor_daily_analysis	t	f	f	f	f	t	2026-10-28 09:43:13.111581+07	2026-10-28 09:43:13.111581+07
b510b2f8-1872-4337-99cd-66903351dd14	dashboard	t	f	f	f	f	f	2026-10-26 11:51:53.168597+07	2026-10-26 11:51:53.168597+07
b510b2f8-1872-4337-99cd-66903351dd14	current_calls	t	f	f	f	f	f	2026-10-26 11:51:53.168597+07	2026-10-26 11:51:53.168597+07
b510b2f8-1872-4337-99cd-66903351dd14	cdrs	t	f	f	f	f	t	2026-10-26 11:51:53.168597+07	2026-10-26 11:51:53.168597+07
b510b2f8-1872-4337-99cd-66903351dd14	mapping_gateways	t	f	f	f	f	f	2026-10-26 11:51:53.168597+07	2026-10-26 11:51:53.168597+07
b510b2f8-1872-4337-99cd-66903351dd14	gateway_analysis	t	f	f	f	f	f	2026-10-26 11:51:53.168597+07	2026-10-26 11:51:53.168597+07
b510b2f8-1872-4337-99cd-66903351dd14	cdr_export	t	f	f	f	f	t	2026-10-26 11:51:53.168597+07	2026-10-26 11:51:53.168597+07
b510b2f8-1872-4337-99cd-66903351dd14	noc_traffic_ccr	t	f	f	f	f	f	2026-10-26 11:51:53.168597+07	2026-10-26 11:51:53.168597+07
09b11494-6458-4b42-8515-cbe68e9d308d	routing_gateways	t	t	t	t	t	t	2026-10-23 16:28:31.256026+07	2026-10-23 16:28:31.256026+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	routing_gateways	t	f	f	f	f	f	2026-10-23 16:28:31.256026+07	2026-10-23 16:28:31.256026+07
65d01478-539a-423a-bb92-d820e5ced5f0	routing_gateways	t	f	f	f	f	f	2026-10-23 16:28:31.256026+07	2026-10-23 16:28:31.256026+07
84846f41-1e06-47df-8b52-af541f0aace1	routing_gateways	t	t	t	t	t	t	2026-10-23 16:28:31.256026+07	2026-10-23 16:28:31.256026+07
09b11494-6458-4b42-8515-cbe68e9d308d	mapping_gateways	t	t	t	t	t	t	2026-10-23 16:28:31.256026+07	2026-10-23 16:28:31.256026+07
a0f66a5a-8be1-415d-a589-09384ec78ef6	mapping_gateways	t	f	f	f	f	f	2026-10-23 16:28:31.256026+07	2026-10-23 16:28:31.256026+07
65d01478-539a-423a-bb92-d820e5ced5f0	mapping_gateways	t	f	f	f	f	f	2026-10-23 16:28:31.256026+07	2026-10-23 16:28:31.256026+07
84846f41-1e06-47df-8b52-af541f0aace1	mapping_gateways	t	t	t	t	t	t	2026-10-23 16:28:31.256026+07	2026-10-23 16:28:31.256026+07
46f4b1db-8d02-44a6-8318-30ffd8c72335	dashboard	t	f	f	f	f	t	2026-10-23 15:46:45.989432+07	2026-10-23 15:46:45.989432+07
46f4b1db-8d02-44a6-8318-30ffd8c72335	cdrs	t	f	f	f	f	t	2026-10-23 15:46:45.989432+07	2026-10-23 15:46:45.989432+07
46f4b1db-8d02-44a6-8318-30ffd8c72335	customers	t	f	f	f	f	t	2026-10-23 15:46:45.989432+07	2026-10-23 15:46:45.989432+07
46f4b1db-8d02-44a6-8318-30ffd8c72335	rates	t	f	f	f	f	t	2026-10-23 15:46:45.989432+07	2026-10-23 15:46:45.989432+07
46f4b1db-8d02-44a6-8318-30ffd8c72335	noc_traffic_ccr	t	f	f	f	f	t	2026-10-23 15:46:45.989432+07	2026-10-23 15:46:45.989432+07
46f4b1db-8d02-44a6-8318-30ffd8c72335	cdr_sync_audit	t	f	f	f	f	t	2026-10-23 15:46:45.989432+07	2026-10-23 15:46:45.989432+07
46f4b1db-8d02-44a6-8318-30ffd8c72335	vendor_daily_analysis	t	f	f	f	f	t	2026-10-28 09:43:13.111581+07	2026-10-28 09:43:13.111581+07
\.


--
-- Data for Name: app_system_configs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_system_configs (config_key, config_value, value_type, category, title, description, unit, is_editable, created_at, updated_at, default_value) FROM stdin;
http_req_logs_retention_days	14	int	MAINTENANCE	HTTP Request Logs Retention	Batas hari retensi penyimpanan HTTP Request & Payload audit logs sebelum otomatis dibersihkan oleh worker.	days	t	2026-10-12 12:01:47.598521+07	2026-10-12 12:04:20.171038+07	7
live_cdr_sync_interval_sec	5	int	CDR_SYNC	Live CDR Sync Frequency	Frekuensi worker background penarikan CDR panggilan hari ini dari MySQL VOS ke TimescaleDB.	sec	t	2026-10-12 11:21:20.347469+07	2026-10-12 12:05:49.70797+07	15
max_login_failed_attempts	10	int	SECURITY	Max Failed Login Attempts	Batas maksimal akumulasi percobaan login gagal per alamat IP sebelum akses diblokir sementara via Redis sliding window.	times	t	2026-10-12 11:21:20.347469+07	2026-10-27 06:44:21.950501+07	5
noc_telemetry_worker_enabled	true	bool	MONITORING	NOC Telemetry Worker Enabled	Aktifkan atau nonaktifkan background worker pengumpul data telemetri panggilan aktif (CCR & CPS).		t	2026-10-16 17:04:40.981056+07	2026-10-16 17:04:40.981056+07	true
noc_telemetry_interval_sec	5	int	MONITORING	NOC Telemetry Collection Interval	Frekuensi background worker Go menarik snapshot panggilan aktif dari VOS3000 untuk disimpan ke time-series database.	sec	t	2026-10-16 17:04:40.981056+07	2026-10-16 17:42:17.279363+07	5
live_cdr_sync_batch_size	5000	int	CDR_SYNC	Live CDR Batch Limit	Batas maksimum rekaman CDR yang ditarik per batch per server agar tidak membebani memori Go.	rows	t	2026-10-12 11:21:20.347469+07	2026-10-12 11:21:20.347469+07	5000
noc_alert_eval_interval_sec	30	int	NOC_ALERT	NOC Alert Evaluator Interval	Frekuensi worker evaluasi terhadap ambang batas anomali trafik NOC (congestion, dead air, low NER).	sec	t	2026-10-12 11:21:20.347469+07	2026-10-12 11:21:20.347469+07	30
noc_telegram_bot_token		string	NOC_ALERT	Telegram Bot Token	Token bot Telegram untuk integrasi pengiriman notifikasi alarm anomali trafik ke group/channel.		t	2026-10-12 11:21:20.347469+07	2026-10-12 11:21:20.347469+07	
noc_telegram_chat_id		string	NOC_ALERT	Telegram Alert Chat ID	ID Group / Channel Telegram penerima siaran notifikasi alarm NOC.		t	2026-10-12 11:21:20.347469+07	2026-10-12 11:21:20.347469+07	
ws_current_calls_poll_ms	1500	int	MONITORING	WebSocket Calls Poller Rate	Frekuensi polling backend ke VOS API GetCurrentCall untuk disiarkan secara live ke WebSocket browser.	ms	t	2026-10-12 11:21:20.347469+07	2026-10-12 11:21:20.347469+07	1500
ws_ticket_duration_sec	30	int	MONITORING	WebSocket Ticket TTL	Masa aktif One-Time WS Ticket untuk otentikasi koneksi WebSocket client browser.	sec	t	2026-10-12 11:21:20.347469+07	2026-10-12 11:21:20.347469+07	30
noc_cache_ttl_sec	20	int	CACHE_PERF	NOC Analytics Cache TTL	Masa aktif Redis cache untuk hasil kueri analitik NOC (Vendor Quality, Ingress Leakage, Telco Matrix).	sec	t	2026-10-12 11:21:20.347469+07	2026-10-12 11:29:43.218842+07	20
vos_api_cache_ttl_sec	30	int	CACHE_PERF	VOS API Semi-Static Cache TTL	Masa aktif Redis cache untuk data semi-statis VOS API (GetAllCustomers, GetFeeRateGroup).	sec	t	2026-10-12 11:21:20.347469+07	2026-10-12 11:21:20.347469+07	30
jwt_access_token_min	15	int	SECURITY	JWT Access Token Expiry	Masa aktif Access Token JWT untuk otorisasi sesi pengguna.	min	t	2026-10-12 11:21:20.347469+07	2026-10-12 11:21:20.347469+07	15
ui_var_label_allow_toggle	true	bool	UI_PREFERENCE	Master UI Variable Labels (*var) Toggle	Master switch pengaktifan penayangan nama variabel teknis (*var) di Web UI. Jika di-set FALSE (OFF), tombol *var di header akan dikunci OFF dan dinonaktifkan dari GUI.		t	2026-10-12 12:18:03.003076+07	2026-10-22 16:49:45.413708+07	true
journal_auto_purge_enabled	true	bool	MAINTENANCE	Journal Auto-Purge	Mengaktifkan pembersihan otomatis berkala untuk systemd journal dan HTTP request audit logs.		t	2026-10-12 11:55:14.623021+07	2026-10-12 11:55:14.623021+07	true
journal_purge_interval_hours	24	int	MAINTENANCE	Journal Purge Interval	Frekuensi jadwal eksekusi worker pembersihan journal log (misal: setiap 24 jam).	hours	t	2026-10-12 11:55:14.623021+07	2026-10-12 11:55:14.623021+07	24
journal_max_retention_days	7	int	MAINTENANCE	Journal Max Retention	Batas retensi umur maksimum log systemd journal dan HTTP request logs sebelum di-vacuum/purge.	days	t	2026-10-12 11:55:14.623021+07	2026-10-12 11:55:14.623021+07	7
journal_max_size_mb	100	int	MAINTENANCE	Journal Max Disk Size	Batas maksimum ukuran disk yang boleh ditempati oleh file systemd journal (journalctl --vacuum-size).	MB	t	2026-10-12 11:55:14.623021+07	2026-10-12 11:55:14.623021+07	100
cdr_sync_logs_retention_days	60	int	MAINTENANCE	CDR Sync Logs Retention	Batas hari retensi riwayat log audit sinkronisasi CDR (app_cdr_sync_logs) sebelum otomatis dibersihkan oleh worker.	days	t	2026-10-12 12:01:47.598521+07	2026-10-12 12:01:47.598521+07	60
smtp_host	smtp.hostinger.com	string	NOTIFICATION	SMTP Server Host	Alamat host mail server SMTP untuk pengiriman invoice email	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	smtp.hostinger.com
smtp_port	465	int	NOTIFICATION	SMTP Server Port	Port TCP SMTP (465 SSL atau 587 STARTTLS)	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	465
process_monitor_allow_restart	false	bool	MONITORING	Allow Service Restart in Process Monitor	Mengizinkan Administrator melakukan aksi Restart / Start pada service daemon VOS3000 langsung dari menu Process Monitor. Jika diset FALSE (default), halaman Process Monitor beroperasi dalam mode Read-Only.		t	2026-10-21 09:51:50.904416+07	2026-10-21 11:26:52.965657+07	false
redis_explorer_allow_delete	false	bool	SECURITY	Allow Key Deletion in Redis Explorer	Mengizinkan Administrator melakukan aksi Hapus Key langsung dari menu Redis Database Explorer. Jika diset FALSE (default), halaman Redis Explorer beroperasi dalam mode Read-Only.		t	2026-10-30 16:00:00+07	2026-10-30 16:00:00+07	false
smtp_encryption	SSL	string	NOTIFICATION	SMTP Encryption	Protokol enkripsi mail server: SSL, STARTTLS, atau NONE	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	SSL
smtp_username	info@voxagrid.net	string	NOTIFICATION	SMTP Username	Username otentikasi mail server (alamat email lengkap Hostinger)	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	info@voxagrid.net
smtp_password		string	NOTIFICATION	SMTP Password	Password otentikasi akun email pengirim Hostinger	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	
smtp_from_name	VoxaGrid Carrier Billing	string	NOTIFICATION	Sender Display Name	Nama tampilan pengirim yang muncul di inbox email pelanggan	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	VoxaGrid Carrier Billing
smtp_from_email	info@voxagrid.net	string	NOTIFICATION	Sender Email Address	Alamat email From pengirim tagihan invoice	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	info@voxagrid.net
smtp_reply_to	info@voxagrid.net	string	NOTIFICATION	Reply-To Email	Alamat email balasan untuk pertanyaan billing pelanggan	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	info@voxagrid.net
smtp_bcc_archive	info@voxagrid.net	string	NOTIFICATION	BCC Archive Email	Alamat email internal tembusan arsip invoice terkirim	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	info@voxagrid.net
smtp_enabled	false	bool	NOTIFICATION	SMTP Dispatch Enabled	Saklar master pengiriman email tagihan otomatis ke pelanggan	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	false
billing_telegram_bot_token		string	NOTIFICATION	Billing Telegram Bot Token	API Bot Token Telegram untuk notifikasi ringkasan billing	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	
billing_telegram_chat_id		string	NOTIFICATION	Billing Telegram Chat ID	Default Chat ID / Group Telegram penerima laporan billing	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	
billing_telegram_alerts_enabled	false	bool	NOTIFICATION	Billing Telegram Alerts Enabled	Saklar master notifikasi Telegram billing	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	false
invoice_bank_name	Bank Mandiri (Persero) Tbk	string	BILLING	Remittance Bank Name	Nama bank rekening penerimaan transfer pembayaran settlement	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	Bank Mandiri (Persero) Tbk
invoice_bank_account_name	PT VoxaGrid Telematika Indonesia	string	BILLING	Beneficiary Account Name	Nama pemilik rekening bank tujuan pembayaran	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	PT VoxaGrid Telematika Indonesia
invoice_bank_account_no	123-00-9876543-2	string	BILLING	Bank Account Number	Nomor rekening bank tujuan transfer	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	123-00-9876543-2
invoice_bank_swift	BMRIIDJA	string	BILLING	Bank SWIFT / BIC Code	Kode SWIFT bank untuk wire transfer internasional	\N	t	2026-10-26 12:29:48.097914+07	2026-10-26 12:29:48.097914+07	BMRIIDJA
login_rate_limit_enabled	true	bool	SECURITY	Login Rate Limiting Protection	Mengaktifkan atau menonaktifkan proteksi brute force login berbasis Redis sliding window.	flag	t	2026-10-26 21:45:09.122883+07	2026-10-26 21:45:09.122883+07	true
login_rate_limit_lockout_min	10	int	SECURITY	Login Lockout Window Duration	Durasi masa blokir sementara pada Redis (dalam menit) jika akumulasi kegagalan login mencapai batas.	min	t	2026-10-26 21:45:09.122883+07	2026-10-26 21:45:09.122883+07	10
invoice_tax_rate_percent	12	numeric	BILLING	VAT / Tax Rate (%)	Persentase tarif PPN faktur komersial (0 jika tanpa pajak)	%	t	2026-10-26 12:29:48.097914+07	2026-10-27 11:28:23.303455+07	11
invoice_payment_terms_days	14	int	BILLING	Payment Terms (Days)	Standar batas hari jatuh tempo pembayaran (Net 14)	days	t	2026-10-26 12:29:48.097914+07	2026-10-27 11:28:23.308755+07	14
invoice_remittance_title	WIRE TRANSFER & REMITTANCE INSTRUCTIONS:	string	BILLING	Remittance Box Title	Judul kotak instruksi pembayaran transfer bank pada dokumen invoice	\N	t	2026-10-27 11:07:41.684187+07	2026-10-27 11:28:23.31419+07	WIRE TRANSFER & REMITTANCE INSTRUCTIONS:
invoice_remittance_content	Bank Name: {BANK_NAME}\nAccount Name: {ACCOUNT_NAME}\nAccount Number: {ACCOUNT_NO}\nSWIFT / BIC Code: {SWIFT_CODE}\nPlease quote payment ref '{INVOICE_NO}' on your transfer slip.	string	BILLING	Remittance Instructions Template	Template multi-line instruksi transfer bank (mendukung variabel {INVOICE_NO}, {BANK_NAME}, {ACCOUNT_NO}, dll.)	\N	t	2026-10-27 11:07:41.684187+07	2026-10-27 11:28:23.319726+07	Bank Name: {BANK_NAME}\nAccount Name: {ACCOUNT_NAME}\nAccount Number: {ACCOUNT_NO}\nSWIFT / BIC Code: {SWIFT_CODE}\nPlease quote payment ref '{INVOICE_NO}' on your transfer slip.
invoice_signature_title	AUTHORIZED SETTLEMENT SIGNATURE	string	BILLING	Signature Block Title	Judul kotak otorisasi stempel dan tanda tangan elektronik	\N	t	2026-10-27 11:07:41.684187+07	2026-10-27 11:28:23.32516+07	AUTHORIZED SETTLEMENT SIGNATURE
invoice_signature_note	Electronically Verified - {COMPANY_NAME}	string	BILLING	Signature Verification Subtitle	Teks verifikasi elektronik di bawah kotak tanda tangan	\N	t	2026-10-27 11:07:41.684187+07	2026-10-27 11:28:23.330612+07	Electronically Verified - {COMPANY_NAME}
callerid_telegram_chat_id		string	NOTIFICATION	Caller ID Telegram Chat ID (Opsional)	ID Chat/Group Telegram spesifik penerima alert rotasi Caller ID. Jika dikosongkan, otomatis menggunakan billing_telegram_chat_id.		t	2026-10-27 15:21:47.741465+07	2026-10-27 15:21:47.741465+07	
callerid_rotation_telegram_alert_enabled	false	bool	NOTIFICATION	Caller ID Rotation Telegram Alerts	Kirimkan notifikasi bot Telegram otomatis saat terjadi rotasi nomor Caller ID (Scheduled Shift, Manual Force, atau Emergency Burn Spam)	on/off	t	2026-10-27 15:21:47.741465+07	2026-10-27 15:25:53.461781+07	false
vendor_daily_sync_interval_sec	60	int	GATEWAYS	Vendor Daily Gateway Sync Frequency	Frekuensi sinkronisasi otomatis gateway routing dan vendor clearing account dari VOS3000 port 6099 ke PostgreSQL.	sec	t	2026-10-28 09:26:56.218833+07	2026-10-28 09:26:56.218833+07	60
vendor_daily_cache_ttl_sec	60	int	GATEWAYS	Vendor Daily Redis Cache TTL	Masa berlaku cache Redis untuk agregasi trafik dan profitabilitas harian vendor.	sec	t	2026-10-28 09:26:56.218833+07	2026-10-28 09:26:56.218833+07	60
invoice_company_name	PT VoxaGrid Telematika Indonesia	string	BILLING	Company Entity Name	Nama legal perusahaan penerbit invoice tagihan wholesale	\N	t	2026-10-26 12:29:48.097914+07	2026-10-27 11:28:23.273147+07	PT VoxaGrid Telematika Indonesia
invoice_company_tax_id	01.234.567.8-012.000	string	BILLING	Company Tax ID / NPWP	Nomor pokok wajib pajak perusahaan untuk faktur komersial	\N	t	2026-10-26 12:29:48.097914+07	2026-10-27 11:28:23.28596+07	01.234.567.8-012.000
invoice_company_phone	+62 21 7997980	string	BILLING	Company Contact Phone	Nomor telepon kantor / 24-7 hotline NOC billing	\N	t	2026-10-26 12:29:48.097914+07	2026-10-27 11:28:23.291792+07	+62 21 5082 1000
invoice_company_address	Cyber 2 Tower Lt. 18, Jl. HR Rasuna Said, Jakarta Selatan, 12950	string	BILLING	Company Legal Address	Alamat legal kantor yang dicantumkan pada header invoice	\N	t	2026-10-26 12:29:48.097914+07	2026-10-27 11:28:23.297597+07	Cyber 2 Tower Lt. 18, Jl. HR Rasuna Said, Jakarta Selatan, 12950
\.


--
-- Data for Name: app_telco_operators; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_telco_operators (id, code, name, network_type, badge_color, is_active, created_at, updated_at) FROM stdin;
1	TELKOMSEL	Telkomsel Mobile	MOBILE	#EF4444	t	2026-10-10 15:32:46.127364+07	2026-10-10 15:32:46.127364+07
2	INDOSAT	Indosat Ooredoo	MOBILE	#EAB308	t	2026-10-10 15:32:46.127364+07	2026-10-10 15:32:46.127364+07
3	TRI	Tri (Hutchison 3)	MOBILE	#F97316	t	2026-10-10 15:32:46.127364+07	2026-10-10 15:32:46.127364+07
4	XL	XL Axiata	MOBILE	#3B82F6	t	2026-10-10 15:32:46.127364+07	2026-10-10 15:32:46.127364+07
5	AXIS	AXIS	MOBILE	#A855F7	t	2026-10-10 15:32:46.127364+07	2026-10-10 15:32:46.127364+07
6	SMARTFREN	Smartfren	MOBILE	#EC4899	t	2026-10-10 15:32:46.127364+07	2026-10-10 15:32:46.127364+07
7	TELKOM_PSTN	Telkom PSTN / Fixed	FIXED	#64748B	t	2026-10-10 15:32:46.127364+07	2026-10-10 15:32:46.127364+07
8	SPECIAL	Special / Toll-Free / DID	SPECIAL	#10B981	t	2026-10-10 15:32:46.127364+07	2026-10-10 15:32:46.127364+07
9	USA_INTL	United States	INTERNATIONAL	#3B82F6	t	2026-10-28 13:42:50.965449+07	2026-10-28 13:42:50.965449+07
10	ID_NATIONAL	Indonesia	NATIONAL	#10B981	t	2026-10-28 13:42:50.965449+07	2026-10-28 13:42:50.965449+07
11	ID_PSTN	Indonesia (Fixed / PSTN)	FIXED	#64748B	t	2026-10-28 13:42:50.965449+07	2026-10-28 13:42:50.965449+07
12	ID_CELLULAR	Indonesia (Cellular)	MOBILE	#F59E0B	t	2026-10-28 13:42:50.965449+07	2026-10-28 13:42:50.965449+07
\.


--
-- Data for Name: app_telco_prefixes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_telco_prefixes (id, operator_id, prefix, description, is_active, created_at) FROM stdin;
1	1	0811	KartuHalo	t	2026-10-10 15:32:46.127364+07
2	1	62811	KartuHalo Int	t	2026-10-10 15:32:46.127364+07
3	1	0812	SimPATI	t	2026-10-10 15:32:46.127364+07
4	1	62812	SimPATI Int	t	2026-10-10 15:32:46.127364+07
5	1	0813	SimPATI	t	2026-10-10 15:32:46.127364+07
6	1	62813	SimPATI Int	t	2026-10-10 15:32:46.127364+07
7	1	0821	SimPATI	t	2026-10-10 15:32:46.127364+07
8	1	62821	SimPATI Int	t	2026-10-10 15:32:46.127364+07
9	1	0822	SimPATI Loop	t	2026-10-10 15:32:46.127364+07
10	1	62822	SimPATI Loop Int	t	2026-10-10 15:32:46.127364+07
11	1	0823	Kartu AS	t	2026-10-10 15:32:46.127364+07
12	1	62823	Kartu AS Int	t	2026-10-10 15:32:46.127364+07
13	1	0851	By.U / AS	t	2026-10-10 15:32:46.127364+07
14	1	62851	By.U / AS Int	t	2026-10-10 15:32:46.127364+07
15	1	0852	Kartu AS	t	2026-10-10 15:32:46.127364+07
16	1	62852	Kartu AS Int	t	2026-10-10 15:32:46.127364+07
17	1	0853	Kartu AS	t	2026-10-10 15:32:46.127364+07
18	1	62853	Kartu AS Int	t	2026-10-10 15:32:46.127364+07
19	2	0814	Indosat M2	t	2026-10-10 15:32:46.127364+07
20	2	62814	Indosat M2 Int	t	2026-10-10 15:32:46.127364+07
21	2	0815	Matrix / Mentari	t	2026-10-10 15:32:46.127364+07
22	2	62815	Matrix / Mentari Int	t	2026-10-10 15:32:46.127364+07
23	2	0816	Matrix / Mentari	t	2026-10-10 15:32:46.127364+07
24	2	62816	Matrix / Mentari Int	t	2026-10-10 15:32:46.127364+07
25	2	0855	Matrix	t	2026-10-10 15:32:46.127364+07
26	2	62855	Matrix Int	t	2026-10-10 15:32:46.127364+07
27	2	0856	IM3	t	2026-10-10 15:32:46.127364+07
28	2	62856	IM3 Int	t	2026-10-10 15:32:46.127364+07
29	2	0857	IM3	t	2026-10-10 15:32:46.127364+07
30	2	62857	IM3 Int	t	2026-10-10 15:32:46.127364+07
31	2	0858	Mentari	t	2026-10-10 15:32:46.127364+07
32	2	62858	Mentari Int	t	2026-10-10 15:32:46.127364+07
33	3	0895	Tri (3)	t	2026-10-10 15:32:46.127364+07
34	3	62895	Tri (3) Int	t	2026-10-10 15:32:46.127364+07
35	3	0896	Tri (3)	t	2026-10-10 15:32:46.127364+07
36	3	62896	Tri (3) Int	t	2026-10-10 15:32:46.127364+07
37	3	0897	Tri (3)	t	2026-10-10 15:32:46.127364+07
38	3	62897	Tri (3) Int	t	2026-10-10 15:32:46.127364+07
39	3	0898	Tri (3)	t	2026-10-10 15:32:46.127364+07
40	3	62898	Tri (3) Int	t	2026-10-10 15:32:46.127364+07
41	3	0899	Tri (3)	t	2026-10-10 15:32:46.127364+07
42	3	62899	Tri (3) Int	t	2026-10-10 15:32:46.127364+07
43	4	0817	XL Prabayar/Prioritas	t	2026-10-10 15:32:46.127364+07
44	4	62817	XL Int	t	2026-10-10 15:32:46.127364+07
45	4	0818	XL Prabayar/Prioritas	t	2026-10-10 15:32:46.127364+07
46	4	62818	XL Int	t	2026-10-10 15:32:46.127364+07
47	4	0819	XL Prabayar/Prioritas	t	2026-10-10 15:32:46.127364+07
48	4	62819	XL Int	t	2026-10-10 15:32:46.127364+07
49	4	0859	XL Prabayar	t	2026-10-10 15:32:46.127364+07
50	4	62859	XL Int	t	2026-10-10 15:32:46.127364+07
51	4	0877	XL Prabayar	t	2026-10-10 15:32:46.127364+07
52	4	62877	XL Int	t	2026-10-10 15:32:46.127364+07
53	4	0878	XL Prabayar	t	2026-10-10 15:32:46.127364+07
54	4	62878	XL Int	t	2026-10-10 15:32:46.127364+07
55	5	0831	AXIS	t	2026-10-10 15:32:46.127364+07
56	5	62831	AXIS Int	t	2026-10-10 15:32:46.127364+07
57	5	0832	AXIS	t	2026-10-10 15:32:46.127364+07
58	5	62832	AXIS Int	t	2026-10-10 15:32:46.127364+07
59	5	0833	AXIS	t	2026-10-10 15:32:46.127364+07
60	5	62833	AXIS Int	t	2026-10-10 15:32:46.127364+07
61	5	0838	AXIS	t	2026-10-10 15:32:46.127364+07
62	5	62838	AXIS Int	t	2026-10-10 15:32:46.127364+07
63	6	0881	Smartfren	t	2026-10-10 15:32:46.127364+07
64	6	62881	Smartfren Int	t	2026-10-10 15:32:46.127364+07
65	6	0882	Smartfren	t	2026-10-10 15:32:46.127364+07
66	6	62882	Smartfren Int	t	2026-10-10 15:32:46.127364+07
67	6	0883	Smartfren	t	2026-10-10 15:32:46.127364+07
68	6	62883	Smartfren Int	t	2026-10-10 15:32:46.127364+07
69	6	0884	Smartfren	t	2026-10-10 15:32:46.127364+07
70	6	62884	Smartfren Int	t	2026-10-10 15:32:46.127364+07
71	6	0885	Smartfren	t	2026-10-10 15:32:46.127364+07
72	6	62885	Smartfren Int	t	2026-10-10 15:32:46.127364+07
73	6	0886	Smartfren	t	2026-10-10 15:32:46.127364+07
74	6	62886	Smartfren Int	t	2026-10-10 15:32:46.127364+07
75	6	0887	Smartfren	t	2026-10-10 15:32:46.127364+07
76	6	62887	Smartfren Int	t	2026-10-10 15:32:46.127364+07
77	6	0888	Smartfren	t	2026-10-10 15:32:46.127364+07
78	6	62888	Smartfren Int	t	2026-10-10 15:32:46.127364+07
79	6	0889	Smartfren	t	2026-10-10 15:32:46.127364+07
80	6	62889	Smartfren Int	t	2026-10-10 15:32:46.127364+07
81	7	021	Jabodetabek PSTN	t	2026-10-10 15:32:46.127364+07
82	7	6221	Jabodetabek PSTN Int	t	2026-10-10 15:32:46.127364+07
83	7	022	Bandung PSTN	t	2026-10-10 15:32:46.127364+07
84	7	6222	Bandung PSTN Int	t	2026-10-10 15:32:46.127364+07
85	7	031	Surabaya PSTN	t	2026-10-10 15:32:46.127364+07
86	7	6231	Surabaya PSTN Int	t	2026-10-10 15:32:46.127364+07
87	7	024	Semarang PSTN	t	2026-10-10 15:32:46.127364+07
88	7	6224	Semarang PSTN Int	t	2026-10-10 15:32:46.127364+07
89	7	061	Medan PSTN	t	2026-10-10 15:32:46.127364+07
90	7	6261	Medan PSTN Int	t	2026-10-10 15:32:46.127364+07
91	7	0361	Denpasar Bali PSTN	t	2026-10-10 15:32:46.127364+07
92	7	62361	Denpasar Bali Int	t	2026-10-10 15:32:46.127364+07
93	8	1500	Call Center 1500xxx	t	2026-10-10 15:32:46.127364+07
94	8	140	Shortcode 140xx	t	2026-10-10 15:32:46.127364+07
95	8	0800	Toll-Free Bebas Pulsa	t	2026-10-10 15:32:46.127364+07
96	8	62800	Toll-Free Int	t	2026-10-10 15:32:46.127364+07
97	9	1	USA / North America	t	2026-10-28 13:42:50.965449+07
98	10	62	Indonesia National	t	2026-10-28 13:42:50.965449+07
99	11	2	Indonesia (Domestic / PSTN)	t	2026-10-28 13:42:50.965449+07
100	12	8	Indonesia (Mobile / Cellular)	t	2026-10-28 13:42:50.965449+07
\.


--
-- Data for Name: app_users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_users (id, username, password_hash, full_name, role, customer_account, all_servers_access, is_active, created_at, updated_at, clearing_account) FROM stdin;
5b8fd3cb-14f8-42da-9a19-f2f98f2e4104	admin	$2a$12$2Ybd0nrtvqmgGSYY2A/ZdeQhIPtsMJbnDr.6XWQHbcQkkhALhAWh2	Super Administrator	ADMIN	\N	t	t	2026-10-02 09:57:32.6422+07	2026-10-26 12:29:48.34156+07	\N
\.


--
-- Data for Name: app_user_roles; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_user_roles (user_id, role_id, created_at) FROM stdin;
5b8fd3cb-14f8-42da-9a19-f2f98f2e4104	09b11494-6458-4b42-8515-cbe68e9d308d	2026-10-23 14:28:19.991455+07
\.


--
-- Data for Name: app_vos_api_docs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_vos_api_docs (api_name, section_no, title, endpoint_uri, http_method, module_group, page_start, page_end, created_at, updated_at) FROM stdin;
GetGatewayMapping	2.12	Get Mapping Gateway	/external/server/GetGatewayMapping	POST	Mapping Gateway	51	62	2026-10-03 17:30:46.236549+07	2026-10-03 17:56:44.888252+07
CreateGatewayMapping	2.10	Create Gateway Mapping	/external/server/CreateGatewayMapping	POST	Mapping Gateway	29	39	2026-10-03 18:08:51.62775+07	2026-10-03 18:08:51.62775+07
ModifyGatewayMapping	2.11	Modify Mapping Gateway	/external/server/ModifyGatewayMapping	POST	Mapping Gateway	40	50	2026-10-03 18:08:51.62775+07	2026-10-03 18:08:51.62775+07
DeleteGatewayMapping	2.13	Delete Mapping Gateway	/external/server/DeleteGatewayMapping	POST	Mapping Gateway	62	62	2026-10-03 18:08:51.62775+07	2026-10-03 18:08:51.62775+07
GetGatewayMappingOnline	2.14	Get Online Mapping Gateway	/external/server/GetGatewayMappingOnline	POST	Mapping Gateway	63	64	2026-10-03 18:08:51.62775+07	2026-10-03 18:08:51.62775+07
CreateGatewayRouting	2.15	Create Routing Gateway	/external/server/CreateGatewayRouting	POST	Routing Gateway	65	77	2026-10-03 18:22:12.869698+07	2026-10-03 18:22:12.869698+07
ModifyGatewayRouting	2.16	Modify Routing Gateway	/external/server/ModifyGatewayRouting	POST	Routing Gateway	78	89	2026-10-03 18:22:12.869698+07	2026-10-03 18:22:12.869698+07
DeleteGatewayRouting	2.17	Delete Routing Gateway	/external/server/DeleteGatewayRouting	POST	Routing Gateway	90	90	2026-10-03 18:22:12.869698+07	2026-10-03 18:22:12.869698+07
GetGatewayRouting	2.18	Get Routing Gateway	/external/server/GetGatewayRouting	POST	Routing Gateway	91	102	2026-10-03 18:22:12.869698+07	2026-10-03 18:22:12.869698+07
GetGatewayRoutingOnline	2.19	Get Online Routing Gateway	/external/server/GetGatewayRoutingOnline	POST	Routing Gateway	103	104	2026-10-03 18:22:12.869698+07	2026-10-03 18:22:12.869698+07
GetCurrentCall	2.20	Get Current Call	/external/server/GetCurrentCall	POST	Calls & Softswitch	105	108	2026-10-03 18:22:12.869698+07	2026-10-03 18:22:12.869698+07
DisconnectCurrentCall	2.75	Disconnect Current Call	/external/server/DisconnectCurrentCall	POST	Calls & Softswitch	176	176	2026-10-03 18:22:12.869698+07	2026-10-03 18:22:12.869698+07
GetCdr	2.46	Get Cdr	/external/server/GetCdr	POST	CDRs & Billing	136	138	2026-10-03 18:22:12.869698+07	2026-10-03 18:22:12.869698+07
GetFeeRateGroup	2.39	Get Fee Rate Group	/external/server/GetFeeRateGroup	POST	Tariff & Rates	127	127	2026-10-03 18:22:12.869698+07	2026-10-03 18:22:12.869698+07
CreateFeeRateGroup	2.40	Create Fee Rate Group	/external/server/CreateFeeRateGroup	POST	Tariff & Rates	128	128	2026-10-03 18:22:12.869698+07	2026-10-03 18:22:12.869698+07
ModifyFeeRateGroup	2.41	Modify Fee Rate Group	/external/server/ModifyFeeRateGroup	POST	Tariff & Rates	129	129	2026-10-03 18:22:12.869698+07	2026-10-03 18:22:12.869698+07
DeleteFeeRateGroup	2.42	Delete Fee Rate Group	/external/server/DeleteFeeRateGroup	POST	Tariff & Rates	130	130	2026-10-03 18:22:12.869698+07	2026-10-03 18:22:12.869698+07
GetFeeRate	2.43	Get Fee Rate	/external/server/GetFeeRate	POST	Tariff & Rates	131	132	2026-10-03 18:22:12.869698+07	2026-10-03 18:22:12.869698+07
\.


--
-- Data for Name: app_vos_api_doc_params; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_vos_api_doc_params (id, api_name, format_category, format_title, param_name, requirement, data_type, description, enum_values, sort_order, created_at, label, updated_at) FROM stdin;
1436	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	routingGatewayGroups	M	String	Routing gateway group names, separated by comma. Left blank means all	{}	12	2026-10-04 14:18:35.845604+07	Routing gateway group	2026-10-05 08:24:01.238051+07
1523	DeleteGatewayMapping	RESPONSE	Response Format	retCode	M	Integer	Response Return Code (0: Success, !=0: Failed)	{"0": "Success", "1001": "Server Error"}	2	2026-10-04 14:18:35.845604+07	Return Code Status	2026-10-04 14:18:35.845604+07
1524	DeleteGatewayMapping	RESPONSE	Response Format	exception	O	String	Exception error message string if request failed	{}	3	2026-10-04 14:18:35.845604+07	Error Information	2026-10-04 14:18:35.845604+07
1525	GetGatewayMappingOnline	REQUEST	Request Format	names	O	String []	Gateway Names filter array (Blank: All)	{}	1	2026-10-04 14:18:35.845604+07	Gateway names filter	2026-10-04 14:18:35.845604+07
1526	GetGatewayMappingOnline	REQUEST	Request Format	softswitchName	O	String	Target VOS3000 softswitch instance name	{}	2	2026-10-04 14:18:35.845604+07	Softswitch	2026-10-04 14:18:35.845604+07
1527	GetGatewayMappingOnline	RESPONSE	Response Format	retCode	M	Integer	Response Return Code (0: Success, !=0: Failed)	{"0": "Success", "1001": "Server Error"}	3	2026-10-04 14:18:35.845604+07	Return Code Status	2026-10-04 14:18:35.845604+07
1528	GetGatewayMappingOnline	RESPONSE	Response Format	exception	O	String	Exception error message string if request failed	{}	4	2026-10-04 14:18:35.845604+07	Error Information	2026-10-04 14:18:35.845604+07
1529	GetGatewayMappingOnline	RESPONSE	Response Format	infoGatewayMappingOnlines	O	InfoGatewayMappingOnline[]	Array of Online Mapping Gateway Information structures	{}	5	2026-10-04 14:18:35.845604+07	Online mapping gateways list	2026-10-04 14:18:35.845604+07
1530	GetGatewayMappingOnline	STRUCT	InfoGatewayMappingOnline Format	id	M	Integer	Mapping Gateway internal numerical ID	{}	6	2026-10-04 14:18:35.845604+07	Gateway ID	2026-10-04 14:18:35.845604+07
1531	GetGatewayMappingOnline	STRUCT	InfoGatewayMappingOnline Format	name	M	String	Unique ID of the device / Mapping Gateway Name	{}	7	2026-10-04 14:18:35.845604+07	Gateway name	2026-10-04 14:18:35.845604+07
1532	GetGatewayMappingOnline	STRUCT	InfoGatewayMappingOnline Format	currentCall	M	Integer	The number of current sessions maintained by the gateway and total capacity	{}	8	2026-10-04 14:18:35.845604+07	Number of calling	2026-10-04 14:18:35.845604+07
1533	GetGatewayMappingOnline	STRUCT	InfoGatewayMappingOnline Format	capacity	M	Integer	The number of concurrent calls allowed by the gateway (0 means unlimited)	{}	9	2026-10-04 14:18:35.845604+07	Line limit	2026-10-04 14:18:35.845604+07
1534	GetGatewayMappingOnline	STRUCT	InfoGatewayMappingOnline Format	asr	M	double	Display current ASR if mapping gateway enables Real time computing asr	{}	10	2026-10-04 14:18:35.845604+07	Mapping asr	2026-10-04 14:18:35.845604+07
1535	GetGatewayMappingOnline	STRUCT	InfoGatewayMappingOnline Format	acd	M	Long	Display current ACD if mapping gateway enables Real time computing acd	{}	11	2026-10-04 14:18:35.845604+07	Mapping acd	2026-10-04 14:18:35.845604+07
1536	GetGatewayMappingOnline	STRUCT	InfoGatewayMappingOnline Format	remoteIps	M	String	IP addresses of mapping gateways. Multiple addresses and signaling ports separated by commas	{}	12	2026-10-04 14:18:35.845604+07	Ip	2026-10-04 14:18:35.845604+07
1537	GetGatewayMappingOnline	STRUCT	InfoGatewayMappingOnline Format	natIp	O	String	NAT public IP address if detected	{}	13	2026-10-04 14:18:35.845604+07	Public NAT IP	2026-10-04 14:18:35.845604+07
1538	GetGatewayMappingOnline	STRUCT	InfoGatewayMappingOnline Format	localIp	M	String	Local listening IP for gateway registration	{}	14	2026-10-04 14:18:35.845604+07	Registration local ip	2026-10-04 14:18:35.845604+07
1539	GetGatewayMappingOnline	STRUCT	InfoGatewayMappingOnline Format	registerTime	M	Long	The server time of the platform's most recent registration (Epoch UTC ms)	{}	15	2026-10-04 14:18:35.845604+07	Registration time	2026-10-04 14:18:35.845604+07
1540	GetGatewayMappingOnline	STRUCT	InfoGatewayMappingOnline Format	updateTime	M	Long	The time of the most recent confirmation that the platform is online	{}	16	2026-10-04 14:18:35.845604+07	Update time	2026-10-04 14:18:35.845604+07
1541	GetGatewayMappingOnline	STRUCT	InfoGatewayMappingOnline Format	keepTime	M	Long	The time elapsed since the most recent registration (for dynamic gateways)	{}	17	2026-10-04 14:18:35.845604+07	Duration	2026-10-04 14:18:35.845604+07
1542	GetGatewayMappingOnline	STRUCT	InfoGatewayMappingOnline Format	cryptoType	M	Integer	Encryption type (0: No Encryption, 1: RC4)	{"0": "No Encryption", "1": "RC4"}	18	2026-10-04 14:18:35.845604+07	Media encryption type	2026-10-04 14:18:35.845604+07
1543	GetGatewayMappingOnline	STRUCT	InfoGatewayMappingOnline Format	softswitchName	M	String	Target VOS3000 softswitch instance name	{}	19	2026-10-04 14:18:35.845604+07	Softswitch	2026-10-04 14:18:35.845604+07
1544	GetGatewayMappingOnline	STRUCT	InfoGatewayMappingOnline Format	softswitchIp	M	String	Softswitch IP address	{}	20	2026-10-04 14:18:35.845604+07	Softswitch IP	2026-10-04 14:18:35.845604+07
1219	CreateGatewayMapping	REQUEST	Request Format	name	M	String	Unique ID of the device / Mapping Gateway Name	{}	1	2026-10-04 14:18:35.845604+07	Gateway name	2026-10-04 14:18:35.845604+07
1220	CreateGatewayMapping	REQUEST	Request Format	password	O	String	Password used for SIP registration of dynamic gateways	{}	2	2026-10-04 14:18:35.845604+07	Configuration password	2026-10-04 14:18:35.845604+07
1221	CreateGatewayMapping	REQUEST	Request Format	lockType	O	Integer	Gateway lock status	{"0": "No lock", "1": "Lock out", "2": "Lock in", "3": "Lock all"}	3	2026-10-04 14:18:35.845604+07	Lock type	2026-10-04 14:18:35.845604+07
1222	CreateGatewayMapping	REQUEST	Request Format	callLevel	O	Integer	Call permission level for routing	{"1": "Net", "2": "Local", "4": "Domestic", "5": "International"}	4	2026-10-04 14:18:35.845604+07	Call permission	2026-10-04 14:18:35.845604+07
1223	CreateGatewayMapping	REQUEST	Request Format	capacity	O	Integer	The number of concurrent calls allowed by the gateway (0 means unlimited)	{}	5	2026-10-04 14:18:35.845604+07	Line limit	2026-10-04 14:18:35.845604+07
1224	CreateGatewayMapping	REQUEST	Request Format	priority	O	Integer	Priority for static gateway with the same IP to match (smaller number has higher priority)	{}	6	2026-10-04 14:18:35.845604+07	Priority	2026-10-04 14:18:35.845604+07
1225	CreateGatewayMapping	REQUEST	Request Format	gatewayGroups	O	String	Set the gateway's group, used for control several gateways' total concurrency (comma separated)	{}	7	2026-10-04 14:18:35.845604+07	Gateway group	2026-10-04 14:18:35.845604+07
1226	CreateGatewayMapping	REQUEST	Request Format	routingGatewayGroupsAllow	O	Boolean	Permission mode for routing gateway groups: allow or forbidden	{"true": "Allow", "false": "Forbidden"}	8	2026-10-04 14:18:35.845604+07	Routing gateway group (Mode)	2026-10-04 14:18:35.845604+07
1228	CreateGatewayMapping	REQUEST	Request Format	registerType	O	Integer	Mapping gateway type: Static (directly through IP) or Dynamic (registration required)	{"0": "Static", "1": "Dynamic"}	10	2026-10-04 14:18:35.845604+07	Gateway type	2026-10-04 14:18:35.845604+07
1229	CreateGatewayMapping	REQUEST	Request Format	remoteIps	O	String	IP addresses of mapping gateways. Multiple addresses and signaling ports separated by commas	{}	11	2026-10-04 14:18:35.845604+07	Ip	2026-10-04 14:18:35.845604+07
1230	CreateGatewayMapping	REQUEST	Request Format	callerE164CheckEnable	O	Boolean	Enable caller number validation check	{"true": "Enable", "false": "Disable"}	12	2026-10-04 14:18:35.845604+07	Caller check enabled	2026-10-04 14:18:35.845604+07
1231	CreateGatewayMapping	REQUEST	Request Format	callerE164CheckCity	O	Boolean	Enable caller city code validation check	{"true": "Enable", "false": "Disable"}	13	2026-10-04 14:18:35.845604+07	Caller city check	2026-10-04 14:18:35.845604+07
1232	CreateGatewayMapping	REQUEST	Request Format	callerE164CheckMobile	O	Boolean	Enable caller mobile number validation check	{"true": "Enable", "false": "Disable"}	14	2026-10-04 14:18:35.845604+07	Caller mobile check	2026-10-04 14:18:35.845604+07
1233	CreateGatewayMapping	REQUEST	Request Format	callerE164CheckOther	O	Boolean	Enable caller other prefix validation check	{"true": "Enable", "false": "Disable"}	15	2026-10-04 14:18:35.845604+07	Caller other check	2026-10-04 14:18:35.845604+07
1234	CreateGatewayMapping	REQUEST	Request Format	calleeE164CheckEnable	O	Boolean	Enable callee number validation check	{"true": "Enable", "false": "Disable"}	16	2026-10-04 14:18:35.845604+07	Callee check enabled	2026-10-04 14:18:35.845604+07
1235	CreateGatewayMapping	REQUEST	Request Format	calleeE164CheckCity	O	Boolean	Enable callee city code validation check	{"true": "Enable", "false": "Disable"}	17	2026-10-04 14:18:35.845604+07	Callee city check	2026-10-04 14:18:35.845604+07
1236	CreateGatewayMapping	REQUEST	Request Format	calleeE164CheckMobile	O	Boolean	Enable callee mobile number validation check	{"true": "Enable", "false": "Disable"}	18	2026-10-04 14:18:35.845604+07	Callee mobile check	2026-10-04 14:18:35.845604+07
1237	CreateGatewayMapping	REQUEST	Request Format	calleeE164CheckOther	O	Boolean	Enable callee other prefix validation check	{"true": "Enable", "false": "Disable"}	19	2026-10-04 14:18:35.845604+07	Callee other check	2026-10-04 14:18:35.845604+07
1238	CreateGatewayMapping	REQUEST	Request Format	customerPassword	O	String	Password for customer self-service web query portal	{}	20	2026-10-04 14:18:35.845604+07	Self service password	2026-10-04 14:18:35.845604+07
1239	CreateGatewayMapping	REQUEST	Request Format	rtpForwardType	O	Integer	Media proxy (RTP forwarding) mode: Auto, On, Off	{"0": "Auto", "1": "On", "2": "Off"}	21	2026-10-04 14:18:35.845604+07	Media proxy	2026-10-04 14:18:35.845604+07
1240	CreateGatewayMapping	REQUEST	Request Format	mediaCheckDirection	O	Integer	RTP stream interrupt detection mode	{"0": "No detect", "1": "Detect whether VOS sent RTP", "2": "Detect whether VOS received remote RTP", "3": "Bidirection"}	22	2026-10-04 14:18:35.845604+07	Rtp interrupt detection	2026-10-04 14:18:35.845604+07
1241	CreateGatewayMapping	REQUEST	Request Format	calleeE164Restrict	O	Integer	Number restriction on callee: None, Phone number, or Other number	{"0": "None", "1": "Phone number", "2": "Other number"}	23	2026-10-04 14:18:35.845604+07	Number restriction on callee	2026-10-04 14:18:35.845604+07
1242	CreateGatewayMapping	REQUEST	Request Format	maxCallDurationLower	O	Integer	Minimum call duration threshold in seconds (-1: System default, 0: No limit)	{"0": "None", "-1": "Default"}	24	2026-10-04 14:18:35.845604+07	Min conversation limitation(seconds)	2026-10-04 14:18:35.845604+07
1243	CreateGatewayMapping	REQUEST	Request Format	maxCallDurationUpper	O	Integer	Maximum conversation duration limit in seconds (-1: System default, 0: No limit)	{"0": "None", "-1": "Default"}	25	2026-10-04 14:18:35.845604+07	Conversation limitation(seconds)	2026-10-04 14:18:35.845604+07
1244	CreateGatewayMapping	REQUEST	Request Format	allowPhoneBilling	O	Boolean	If caller matches platform phone number, use account that phone number belongs to for billing	{}	26	2026-10-04 14:18:35.845604+07	Allow phone number billing	2026-10-04 14:18:35.845604+07
1245	CreateGatewayMapping	REQUEST	Request Format	allowBindedE164Billing	O	Boolean	If caller matches bind number, use account that bind number belongs to for billing	{}	27	2026-10-04 14:18:35.845604+07	Allow bind number billing	2026-10-04 14:18:35.845604+07
1246	CreateGatewayMapping	REQUEST	Request Format	enablePhoneSetting	O	Boolean	Use phone settings when caller matches phone number	{}	28	2026-10-04 14:18:35.845604+07	Enable phone setting	2026-10-04 14:18:35.845604+07
1247	CreateGatewayMapping	REQUEST	Request Format	denySameCityCodesAllow	O	Boolean	Enable deny same city codes setting	{"true": "Enable", "false": "Disable"}	29	2026-10-04 14:18:35.845604+07	Deny same city codes enabled	2026-10-04 14:18:35.845604+07
1248	CreateGatewayMapping	REQUEST	Request Format	denySameCityCodes	O	String	Deny same city codes settings, separated by comma	{}	30	2026-10-04 14:18:35.845604+07	Deny same city codes list	2026-10-04 14:18:35.845604+07
1249	CreateGatewayMapping	REQUEST	Request Format	checkMobileAreaAllow	O	Boolean	Enable check mobile area settings	{"true": "Enable", "false": "Disable"}	31	2026-10-04 14:18:35.845604+07	Check mobile area enabled	2026-10-04 14:18:35.845604+07
1250	CreateGatewayMapping	REQUEST	Request Format	checkMobileArea	O	String	Mobile area settings, separated by comma	{}	32	2026-10-04 14:18:35.845604+07	Check mobile area list	2026-10-04 14:18:35.845604+07
1251	CreateGatewayMapping	REQUEST	Request Format	calloutCalleePrefixesAllow	O	Boolean	Permission mode for callee prefixes: allow or forbidden	{"true": "Allow", "false": "Forbidden"}	33	2026-10-04 14:18:35.845604+07	Mapping callee prefix (Mode)	2026-10-04 14:18:35.845604+07
1252	CreateGatewayMapping	REQUEST	Request Format	calloutCalleePrefixes	O	String	Prefixes of callee numbers allowed or forbidden to pass through, separated by commas	{}	34	2026-10-04 14:18:35.845604+07	Mapping callee prefix	2026-10-04 14:18:35.845604+07
1253	CreateGatewayMapping	REQUEST	Request Format	calloutCallerPrefixesAllow	O	Boolean	Permission mode for caller prefixes: allow or forbidden	{"true": "Allow", "false": "Forbidden"}	35	2026-10-04 14:18:35.845604+07	Mapping caller prefix (Mode)	2026-10-04 14:18:35.845604+07
1254	CreateGatewayMapping	REQUEST	Request Format	calloutCallerPrefixes	O	String	Prefixes of caller numbers allowed or forbidden to pass through, separated by commas	{}	36	2026-10-04 14:18:35.845604+07	Mapping caller prefix	2026-10-04 14:18:35.845604+07
1255	CreateGatewayMapping	REQUEST	Request Format	rewriteRulesOutCallee	O	String	Rewrite rules for callee number when entering mapping gateway (Initial prefix:Destination prefix)	{}	37	2026-10-04 14:18:35.845604+07	Callee rewrite rule	2026-10-04 14:18:35.845604+07
1256	CreateGatewayMapping	REQUEST	Request Format	rewriteRulesOutCaller	O	String	Rewrite rules for caller number when entering mapping gateway (Initial prefix:Destination prefix)	{}	38	2026-10-04 14:18:35.845604+07	Caller rewrite rule	2026-10-04 14:18:35.845604+07
1257	CreateGatewayMapping	REQUEST	Request Format	rewriteRulesInMobileAreaAllow	O	Boolean	Enable mobile area inbound rewrite rules setting	{"true": "Enable", "false": "Disable"}	39	2026-10-04 14:18:35.845604+07	Mobile area rewrite rules enabled	2026-10-04 14:18:35.845604+07
1258	CreateGatewayMapping	REQUEST	Request Format	rewriteRulesInMobileArea	O	String	Mobile area inbound rewrite rules settings, separated by comma	{}	40	2026-10-04 14:18:35.845604+07	Mobile area rewrite rules list	2026-10-04 14:18:35.845604+07
1259	CreateGatewayMapping	REQUEST	Request Format	timeoutCallProceeding	O	Integer	The maximum time waited after the call reached gateway (-1: System default, 0: None)	{"0": "None", "-1": "Default"}	41	2026-10-04 14:18:35.845604+07	Process timeout(seconds)	2026-10-04 14:18:35.845604+07
1260	CreateGatewayMapping	REQUEST	Request Format	sipResponseAddressMethod	O	Integer	After receive SIP request message, send reply signal to which address: Socket, Via port, or Via	{"0": "Socket", "1": "Via port", "2": "Via"}	42	2026-10-04 14:18:35.845604+07	Reply address	2026-10-04 14:18:35.845604+07
1261	CreateGatewayMapping	REQUEST	Request Format	sipRequestAddressMethod	O	Integer	After call established, send request signal to which address: Socket, Contact Port, or Contact	{"0": "Socket", "1": "Contact Port", "2": "Contact"}	43	2026-10-04 14:18:35.845604+07	Request address	2026-10-04 14:18:35.845604+07
1262	CreateGatewayMapping	REQUEST	Request Format	dtmfSendMethodH323	O	Integer	DTMF transmission method for H.323 calls	{"0": "Auto", "10": "RFC2833", "20": "H.245 alphanumeric", "30": "H.245 signal", "40": "Q.931 keypad", "60": "Off"}	44	2026-10-04 14:18:35.845604+07	Dtmf send(h323)	2026-10-04 14:18:35.845604+07
1263	CreateGatewayMapping	REQUEST	Request Format	dtmfSendMethodSIP	O	Integer	DTMF transmission method for SIP calls	{"0": "Auto", "10": "RFC2833", "50": "SIP INFO", "60": "Off"}	45	2026-10-04 14:18:35.845604+07	Dtmf send(sip)	2026-10-04 14:18:35.845604+07
1264	CreateGatewayMapping	REQUEST	Request Format	dtmfReceiveMethod	O	Integer	DTMF reception method from remote peer (All is recommended)	{"0": "All", "10": "RFC2833", "20": "Signaling", "30": "Off"}	46	2026-10-04 14:18:35.845604+07	Dtmf receive	2026-10-04 14:18:35.845604+07
1265	CreateGatewayMapping	REQUEST	Request Format	dtmfSendPayloadTypeH323	O	Integer	RTP payload type for H.323 RFC2833 DTMF sending (default 101)	{}	47	2026-10-04 14:18:35.845604+07	Payload (H.323)	2026-10-04 14:18:35.845604+07
1266	CreateGatewayMapping	REQUEST	Request Format	dtmfSendPayloadTypeSIP	O	Integer	RTP payload type for SIP RFC2833 DTMF sending (default 101)	{}	48	2026-10-04 14:18:35.845604+07	Payload (SIP)	2026-10-04 14:18:35.845604+07
1267	CreateGatewayMapping	REQUEST	Request Format	dtmfReceivePayloadType	O	Integer	RTP payload type for RFC2833 DTMF reception (default 101)	{}	49	2026-10-04 14:18:35.845604+07	Payload (Receive)	2026-10-04 14:18:35.845604+07
1268	CreateGatewayMapping	REQUEST	Request Format	q931ProgressIndicator	O	Integer	Q.931 Progress Indicator signaling parameter for H.323 calls	{"0": "Off", "1": "Not End-to-End ISDN", "2": "Destination Non-ISDN", "3": "Origination Non-ISDN", "4": "Returned to ISDN", "5": "Service Change", "8": "Inband Info Available", "-1": "Default"}	50	2026-10-04 14:18:35.845604+07	Q.931 ProgressIndicator	2026-10-04 14:18:35.845604+07
1269	CreateGatewayMapping	REQUEST	Request Format	account	O	String	The number/identifier of the billing account for this mapping gateway	{}	51	2026-10-04 14:18:35.845604+07	Account id	2026-10-04 14:18:35.845604+07
1270	CreateGatewayMapping	REQUEST	Request Format	callTimeoutQ931CauseValue	O	Integer	Specify Q.931 disconnect cause value sent to mapping gateway on failure (0: No replace)	{"0": "No replace"}	52	2026-10-04 14:18:35.845604+07	Replace failed reason (Q.931)	2026-10-04 14:18:35.845604+07
1271	CreateGatewayMapping	REQUEST	Request Format	callTimeoutSIPCode	O	Integer	Specify SIP disconnect status code sent to mapping gateway on failure (0: No replace)	{"0": "No replace"}	53	2026-10-04 14:18:35.845604+07	Replace failed reason (SIP)	2026-10-04 14:18:35.845604+07
1272	CreateGatewayMapping	REQUEST	Request Format	sipRemoteRingSignal	O	Integer	Remote ringback signal returned to mapping gateway	{"0": "Passthrough", "1": "183 Session Progress + SDP", "2": "180 Alerting + SDP"}	54	2026-10-04 14:18:35.845604+07	Remote ring back mode	2026-10-04 14:18:35.845604+07
1273	CreateGatewayMapping	REQUEST	Request Format	sipCalleeE164Domain	O	Integer	Extract callee number from SIP signal field: To, Request-Line, or Diversion	{"0": "To", "1": "Request-Line", "2": "Diversion"}	55	2026-10-04 14:18:35.845604+07	Callee	2026-10-04 14:18:35.845604+07
1274	CreateGatewayMapping	REQUEST	Request Format	sipCallerE164Domain	O	Integer	Extract caller number from SIP signal field: From, Remote-Party-ID, or Display	{"0": "From", "1": "Remote-Party-ID", "2": "Display"}	56	2026-10-04 14:18:35.845604+07	Caller	2026-10-04 14:18:35.845604+07
1275	CreateGatewayMapping	REQUEST	Request Format	h323CalleeE164Domain	O	Integer	Extract callee number from H.323 signal field: CalledPartyNumber or DestinationAddress	{"0": "CalledPartyNumber", "1": "DestinationAddress"}	57	2026-10-04 14:18:35.845604+07	Callee (H.323)	2026-10-04 14:18:35.845604+07
1276	CreateGatewayMapping	REQUEST	Request Format	h323CallerE164Domain	O	Integer	Extract caller number from H.323 signal field: CallingPartyNumber, SourceAddress, or Display	{"0": "CallingPartyNumber", "1": "SourceAddress", "2": "Display"}	58	2026-10-04 14:18:35.845604+07	Caller (H.323)	2026-10-04 14:18:35.845604+07
1277	CreateGatewayMapping	REQUEST	Request Format	memo	O	String	Comments / operational notes on this gateway	{}	59	2026-10-04 14:18:35.845604+07	Memo	2026-10-04 14:18:35.845604+07
1278	CreateGatewayMapping	REQUEST	Request Format	sipAuthenticationMethod	O	Integer	Call authentication mode for inbound SIP calls: IP, IP Address and Port, or Authenticate by Password	{"0": "Ip", "1": "IP Address and Port", "2": "Authenticate by Password"}	60	2026-10-04 14:18:35.845604+07	Call authentication mode	2026-10-04 14:18:35.845604+07
1279	CreateGatewayMapping	REQUEST	Request Format	h323FastStart	O	Boolean	Check to enable H.323 FastStart procedure	{"true": "Enable", "false": "Disable"}	61	2026-10-04 14:18:35.845604+07	FastStart	2026-10-04 14:18:35.845604+07
1280	CreateGatewayMapping	REQUEST	Request Format	h323H245Tunneling	O	Boolean	Check to enable H.245 tunneling in Q.931 messages	{"true": "Enable", "false": "Disable"}	62	2026-10-04 14:18:35.845604+07	H245Tunneling	2026-10-04 14:18:35.845604+07
1281	CreateGatewayMapping	REQUEST	Request Format	h323H245InSetup	O	Boolean	Check to enable H.245 in SETUP	{"true": "Enable", "false": "Disable"}	63	2026-10-04 14:18:35.845604+07	H245InSetup	2026-10-04 14:18:35.845604+07
1282	CreateGatewayMapping	REQUEST	Request Format	h323AutoCallProceeding	O	Boolean	Check to send callproceeding when receives SETUP	{"true": "Enable", "false": "Disable"}	64	2026-10-04 14:18:35.845604+07	Send callproceeding immediately	2026-10-04 14:18:35.845604+07
1283	CreateGatewayMapping	REQUEST	Request Format	h323CallProceedingFromSIPTrying	O	Boolean	If caller uses H323 and callee uses SIP, when callee returns Trying, VOS sends callproceeding to caller	{"true": "Enable", "false": "Disable"}	65	2026-10-04 14:18:35.845604+07	Convert trying	2026-10-04 14:18:35.845604+07
1284	CreateGatewayMapping	REQUEST	Request Format	h323AlertingFromSIP183Sdp	O	Boolean	If caller uses H323 and callee uses SIP, when callee returns 183 SDP, VOS sends alerting to caller	{"true": "Enable", "false": "Disable"}	66	2026-10-04 14:18:35.845604+07	Change 183(sdp) to alerting	2026-10-04 14:18:35.845604+07
1285	CreateGatewayMapping	REQUEST	Request Format	h323T38	O	Boolean	Check to include T.38 fax over H.323	{"true": "Enable", "false": "Disable"}	67	2026-10-04 14:18:35.845604+07	Allow t38 (H.323)	2026-10-04 14:18:35.845604+07
1286	CreateGatewayMapping	REQUEST	Request Format	sipTimer	O	Boolean	Enable SIP Session Timer protocol (RFC 4028) to detect dead calls	{"true": "Enable", "false": "Disable"}	68	2026-10-04 14:18:35.845604+07	Enable timer protocol	2026-10-04 14:18:35.845604+07
1287	CreateGatewayMapping	REQUEST	Request Format	sip100Rel	O	Boolean	Send/support 100rel provisional reliable responses (RFC 3262 PRACK)	{"true": "Enable", "false": "Disable"}	69	2026-10-04 14:18:35.845604+07	Enable 100rel	2026-10-04 14:18:35.845604+07
1288	CreateGatewayMapping	REQUEST	Request Format	sipT38	O	Boolean	Allow send T.38 fax signal to/from mapping gateway over SIP	{"true": "Enable", "false": "Disable"}	70	2026-10-04 14:18:35.845604+07	Allow t38 (SIP)	2026-10-04 14:18:35.845604+07
1289	CreateGatewayMapping	REQUEST	Request Format	sipDisplay	O	Integer	SIP display name handling mode (Default, From, Remote-Party-ID, or Ignore)	{"0": "Default", "1": "From", "2": "Remote-Party-ID", "3": "Ignore"}	71	2026-10-04 14:18:35.845604+07	Display	2026-10-04 14:18:35.845604+07
1290	CreateGatewayMapping	REQUEST	Request Format	sipRemotePartyId	O	Boolean	Include Remote-Party-ID header in SIP signaling	{"true": "Include", "false": "Exclude"}	72	2026-10-04 14:18:35.845604+07	Remote-Party-ID	2026-10-04 14:18:35.845604+07
1291	CreateGatewayMapping	REQUEST	Request Format	sipPrivacySupport	O	Boolean	Pass through mapping gateway private domain (RFC 3323 Privacy header)	{"true": "Enable", "false": "Disable"}	73	2026-10-04 14:18:35.845604+07	Support privacy	2026-10-04 14:18:35.845604+07
1292	CreateGatewayMapping	REQUEST	Request Format	groupE164Change	O	Boolean	Use number in Number Transformation table to replace caller ID	{"true": "Enable", "false": "Disable"}	74	2026-10-04 14:18:35.845604+07	Caller transform	2026-10-04 14:18:35.845604+07
1293	CreateGatewayMapping	REQUEST	Request Format	callerAllowLength	O	Integer	Allowed lengths of caller numbers (e.g. fill in "11, 14" means only 11-digit or 14-digit numbers allowed)	{}	75	2026-10-04 14:18:35.845604+07	Caller number allow length	2026-10-04 14:18:35.845604+07
1294	CreateGatewayMapping	REQUEST	Request Format	calleeAllowLength	O	Integer	Allowed lengths of callee numbers (blank allows all, "0" allows none)	{}	76	2026-10-04 14:18:35.845604+07	Callee number allow length	2026-10-04 14:18:35.845604+07
1295	CreateGatewayMapping	REQUEST	Request Format	callerLimitE164GroupsAllow	O	Boolean	Permission mode for caller black/white list group: allow or forbidden	{"true": "Allow", "false": "Forbidden"}	77	2026-10-04 14:18:35.845604+07	Caller black/white list group (Mode)	2026-10-04 14:18:35.845604+07
1296	CreateGatewayMapping	REQUEST	Request Format	callerLimitE164Groups	O	String	Caller black/white list group names, separated by comma	{}	78	2026-10-04 14:18:35.845604+07	Caller black/white list group	2026-10-04 14:18:35.845604+07
1297	CreateGatewayMapping	REQUEST	Request Format	calleeLimitE164GroupsAllow	O	Boolean	Permission mode for callee black/white list group: allow or forbidden	{"true": "Allow", "false": "Forbidden"}	79	2026-10-04 14:18:35.845604+07	Callee black/white list group (Mode)	2026-10-04 14:18:35.845604+07
1298	CreateGatewayMapping	REQUEST	Request Format	calleeLimitE164Groups	O	String	Callee black/white list group names, separated by comma	{}	80	2026-10-04 14:18:35.845604+07	Callee black/white list group	2026-10-04 14:18:35.845604+07
1299	CreateGatewayMapping	REQUEST	Request Format	minProfitPercentEnable	O	Boolean	Enable lowest profit rate threshold check	{"true": "Enable", "false": "Disable"}	81	2026-10-04 14:18:35.845604+07	Lowest profit rate limit (Enable)	2026-10-04 14:18:35.845604+07
1300	CreateGatewayMapping	REQUEST	Request Format	minProfitPercent	O	Integer	This gateway will be locked if profit rate (%) falls below this value	{}	82	2026-10-04 14:18:35.845604+07	Lowest profit rate limit	2026-10-04 14:18:35.845604+07
1301	CreateGatewayMapping	REQUEST	Request Format	maxSecondRatesEnable	O	Boolean	Enable max minute rate threshold check	{"true": "Enable", "false": "Disable"}	83	2026-10-04 14:18:35.845604+07	Max minute rates (Enable)	2026-10-04 14:18:35.845604+07
1302	CreateGatewayMapping	REQUEST	Request Format	maxSecondRates	O	Integer	Max minute rate allowed for callee number (internally stored as second rate = minute rate / 60)	{}	84	2026-10-04 14:18:35.845604+07	Max minute rates	2026-10-04 14:18:35.845604+07
1303	CreateGatewayMapping	REQUEST	Request Format	firstRoutePolicy	O	Integer	First priority routing strategy: None (system default), ASR, or Lowest rate per second	{"0": "None", "1": "ASR", "2": "Lowest rate per second"}	85	2026-10-04 14:18:35.845604+07	First routing strategy	2026-10-04 14:18:35.845604+07
1304	CreateGatewayMapping	REQUEST	Request Format	secondRoutePolicy	O	Integer	Second priority routing strategy: None, ASR, or Lowest rate per second	{"0": "None", "1": "ASR", "2": "Lowest rate per second"}	86	2026-10-04 14:18:35.845604+07	Second routing strategy	2026-10-04 14:18:35.845604+07
1305	CreateGatewayMapping	REQUEST	Request Format	h323G729SendMode	O	Integer	H.323 G.729 codec negotiation mode: Auto, G729, G729a, or G729&G729a	{"0": "Auto", "1": "G729", "2": "G729a", "3": "G729&G729a"}	87	2026-10-04 14:18:35.845604+07	G729 negotiation mode (H.323)	2026-10-04 14:18:35.845604+07
1306	CreateGatewayMapping	REQUEST	Request Format	sipG729SendMode	O	Integer	SIP G.729 codec negotiation mode: Auto, G729, G729a, or G729&G729a	{"0": "Auto", "1": "G729", "2": "G729a", "3": "G729&G729a"}	88	2026-10-04 14:18:35.845604+07	G729 negotiation mode (SIP)	2026-10-04 14:18:35.845604+07
1307	CreateGatewayMapping	REQUEST	Request Format	sipG729Annexb	O	Integer	SIP G.729 Annex B voice activity detection negotiation	{"0": "Auto", "1": "yes", "2": "no", "3": "None", "4": "Passthrough"}	89	2026-10-04 14:18:35.845604+07	G729 annexb	2026-10-04 14:18:35.845604+07
1308	CreateGatewayMapping	REQUEST	Request Format	sipG723Annexa	O	Integer	SIP G.723.1 Annex A silence suppression negotiation	{"0": "Auto", "1": "yes", "2": "no", "3": "None", "4": "Passthrough"}	90	2026-10-04 14:18:35.845604+07	G723 annexa	2026-10-04 14:18:35.845604+07
1309	CreateGatewayMapping	REQUEST	Request Format	h323CodecAssign	O	Boolean	Codec negotiation policy for H.323: Auto negotiation or Softswitch specified	{"true": "Softswitch specified", "false": "Auto negotiation"}	91	2026-10-04 14:18:35.845604+07	H.323 Codec Negotiation Policy	2026-10-04 14:18:35.845604+07
1310	CreateGatewayMapping	REQUEST	Request Format	h323Codecs	O	Vector<String>	Prioritized list of codecs specified for H.323 softswitch negotiation	{}	92	2026-10-04 14:18:35.845604+07	Specify codec (H.323)	2026-10-04 14:18:35.845604+07
1311	CreateGatewayMapping	REQUEST	Request Format	sipCodecAssign	O	Boolean	Codec negotiation policy for SIP: Auto negotiation or Softswitch specified	{"true": "Softswitch specified", "false": "Auto negotiation"}	93	2026-10-04 14:18:35.845604+07	SIP Codec Negotiation Policy	2026-10-04 14:18:35.845604+07
1312	CreateGatewayMapping	REQUEST	Request Format	sipCodecs	O	Vector<String>	Prioritized list of codecs specified for SIP softswitch negotiation	{}	94	2026-10-04 14:18:35.845604+07	Specify codec (SIP)	2026-10-04 14:18:35.845604+07
1313	CreateGatewayMapping	REQUEST	Request Format	forwardSignalRewriteE164GroupEnable	O	Boolean	Check to enable forwarding signal rewrite pool	{"true": "Enable", "false": "Disable"}	95	2026-10-04 14:18:35.845604+07	Enable forwarding signal rewrite pool	2026-10-04 14:18:35.845604+07
1314	CreateGatewayMapping	REQUEST	Request Format	forwardSignalRewriteE164Group	O	String	Add prefix for callee number by proportion (Proportion:Route prefix) or Forward Pool Group	{}	96	2026-10-04 14:18:35.845604+07	Add prefix to the callee / Forward Pool	2026-10-04 14:18:35.845604+07
1315	CreateGatewayMapping	REQUEST	Request Format	lrnEnable	O	Boolean	Enable Location Routing Number (LRN) dip query via SCP server	{"true": "Enable", "false": "Disable"}	97	2026-10-04 14:18:35.845604+07	Query lrn	2026-10-04 14:18:35.845604+07
1316	CreateGatewayMapping	REQUEST	Request Format	lrnEatPrefixLength	O	Integer	Cut specified number of prefix digits from LRN response, then use remaining digits for billing	{}	98	2026-10-04 14:18:35.845604+07	Eat prefix length	2026-10-04 14:18:35.845604+07
1317	CreateGatewayMapping	REQUEST	Request Format	lrnFailureAction	O	Integer	Action taken when LRN query fails: Reject or Continue	{"0": "Reject", "1": "Continue"}	99	2026-10-04 14:18:35.845604+07	Failure action	2026-10-04 14:18:35.845604+07
1318	CreateGatewayMapping	REQUEST	Request Format	lrnInterstateBillingPrefix	O	String	Prefix prepended to billing code for interstate calls	{}	100	2026-10-04 14:18:35.845604+07	Interstate billing prefix	2026-10-04 14:18:35.845604+07
1319	CreateGatewayMapping	REQUEST	Request Format	lrnUndeterminedBillingPrefix	O	String	Prefix prepended to billing code when interstate status cannot be determined	{}	101	2026-10-04 14:18:35.845604+07	Undetermined billing prefix	2026-10-04 14:18:35.845604+07
1320	CreateGatewayMapping	RESPONSE	Response Format	retCode	M	Integer	Response Return Code (0: Success, !=0: Failed)	{"0": "Success", "1001": "Server Error"}	102	2026-10-04 14:18:35.845604+07	Return Code Status	2026-10-04 14:18:35.845604+07
1321	CreateGatewayMapping	RESPONSE	Response Format	exception	O	String	Exception error message string if request failed	{}	103	2026-10-04 14:18:35.845604+07	Error Information	2026-10-04 14:18:35.845604+07
1322	ModifyGatewayMapping	REQUEST	Request Format	name	M	String	Unique ID of the device / Mapping Gateway Name	{}	1	2026-10-04 14:18:35.845604+07	Gateway name	2026-10-04 14:18:35.845604+07
1323	ModifyGatewayMapping	REQUEST	Request Format	password	O	String	Password used for SIP registration of dynamic gateways	{}	2	2026-10-04 14:18:35.845604+07	Configuration password	2026-10-04 14:18:35.845604+07
1324	ModifyGatewayMapping	REQUEST	Request Format	lockType	O	Integer	Gateway lock status	{"0": "No lock", "1": "Lock out", "2": "Lock in", "3": "Lock all"}	3	2026-10-04 14:18:35.845604+07	Lock type	2026-10-04 14:18:35.845604+07
1325	ModifyGatewayMapping	REQUEST	Request Format	callLevel	O	Integer	Call permission level for routing	{"1": "Net", "2": "Local", "4": "Domestic", "5": "International"}	4	2026-10-04 14:18:35.845604+07	Call permission	2026-10-04 14:18:35.845604+07
1326	ModifyGatewayMapping	REQUEST	Request Format	capacity	O	Integer	The number of concurrent calls allowed by the gateway (0 means unlimited)	{}	5	2026-10-04 14:18:35.845604+07	Line limit	2026-10-04 14:18:35.845604+07
1327	ModifyGatewayMapping	REQUEST	Request Format	priority	O	Integer	Priority for static gateway with the same IP to match (smaller number has higher priority)	{}	6	2026-10-04 14:18:35.845604+07	Priority	2026-10-04 14:18:35.845604+07
768	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	natIp	O	String	NATAddress	{}	14	2026-10-03 18:22:12.869698+07	Nat IP	2026-10-03 18:22:12.869698+07
1328	ModifyGatewayMapping	REQUEST	Request Format	gatewayGroups	O	String	Set the gateway's group, used for control several gateways' total concurrency (comma separated)	{}	7	2026-10-04 14:18:35.845604+07	Gateway group	2026-10-04 14:18:35.845604+07
1329	ModifyGatewayMapping	REQUEST	Request Format	routingGatewayGroupsAllow	O	Boolean	Permission mode for routing gateway groups: allow or forbidden	{"true": "Allow", "false": "Forbidden"}	8	2026-10-04 14:18:35.845604+07	Routing gateway group (Mode)	2026-10-04 14:18:35.845604+07
1330	ModifyGatewayMapping	REQUEST	Request Format	routingGatewayGroups	O	String	Routing gateway group names, separated by comma. Left blank means all	{}	9	2026-10-04 14:18:35.845604+07	Routing gateway group	2026-10-04 14:18:35.845604+07
1331	ModifyGatewayMapping	REQUEST	Request Format	registerType	O	Integer	Mapping gateway type: Static (directly through IP) or Dynamic (registration required)	{"0": "Static", "1": "Dynamic"}	10	2026-10-04 14:18:35.845604+07	Gateway type	2026-10-04 14:18:35.845604+07
1332	ModifyGatewayMapping	REQUEST	Request Format	remoteIps	O	String	IP addresses of mapping gateways. Multiple addresses and signaling ports separated by commas	{}	11	2026-10-04 14:18:35.845604+07	Ip	2026-10-04 14:18:35.845604+07
1333	ModifyGatewayMapping	REQUEST	Request Format	callerE164CheckEnable	O	Boolean	Enable caller number validation check	{"true": "Enable", "false": "Disable"}	12	2026-10-04 14:18:35.845604+07	Caller check enabled	2026-10-04 14:18:35.845604+07
1334	ModifyGatewayMapping	REQUEST	Request Format	callerE164CheckCity	O	Boolean	Enable caller city code validation check	{"true": "Enable", "false": "Disable"}	13	2026-10-04 14:18:35.845604+07	Caller city check	2026-10-04 14:18:35.845604+07
1335	ModifyGatewayMapping	REQUEST	Request Format	callerE164CheckMobile	O	Boolean	Enable caller mobile number validation check	{"true": "Enable", "false": "Disable"}	14	2026-10-04 14:18:35.845604+07	Caller mobile check	2026-10-04 14:18:35.845604+07
1336	ModifyGatewayMapping	REQUEST	Request Format	callerE164CheckOther	O	Boolean	Enable caller other prefix validation check	{"true": "Enable", "false": "Disable"}	15	2026-10-04 14:18:35.845604+07	Caller other check	2026-10-04 14:18:35.845604+07
1337	ModifyGatewayMapping	REQUEST	Request Format	calleeE164CheckEnable	O	Boolean	Enable callee number validation check	{"true": "Enable", "false": "Disable"}	16	2026-10-04 14:18:35.845604+07	Callee check enabled	2026-10-04 14:18:35.845604+07
1338	ModifyGatewayMapping	REQUEST	Request Format	calleeE164CheckCity	O	Boolean	Enable callee city code validation check	{"true": "Enable", "false": "Disable"}	17	2026-10-04 14:18:35.845604+07	Callee city check	2026-10-04 14:18:35.845604+07
1339	ModifyGatewayMapping	REQUEST	Request Format	calleeE164CheckMobile	O	Boolean	Enable callee mobile number validation check	{"true": "Enable", "false": "Disable"}	18	2026-10-04 14:18:35.845604+07	Callee mobile check	2026-10-04 14:18:35.845604+07
1340	ModifyGatewayMapping	REQUEST	Request Format	calleeE164CheckOther	O	Boolean	Enable callee other prefix validation check	{"true": "Enable", "false": "Disable"}	19	2026-10-04 14:18:35.845604+07	Callee other check	2026-10-04 14:18:35.845604+07
1341	ModifyGatewayMapping	REQUEST	Request Format	customerPassword	O	String	Password for customer self-service web query portal	{}	20	2026-10-04 14:18:35.845604+07	Self service password	2026-10-04 14:18:35.845604+07
1342	ModifyGatewayMapping	REQUEST	Request Format	rtpForwardType	O	Integer	Media proxy (RTP forwarding) mode: Auto, On, Off	{"0": "Auto", "1": "On", "2": "Off"}	21	2026-10-04 14:18:35.845604+07	Media proxy	2026-10-04 14:18:35.845604+07
1343	ModifyGatewayMapping	REQUEST	Request Format	mediaCheckDirection	O	Integer	RTP stream interrupt detection mode	{"0": "No detect", "1": "Detect whether VOS sent RTP", "2": "Detect whether VOS received remote RTP", "3": "Bidirection"}	22	2026-10-04 14:18:35.845604+07	Rtp interrupt detection	2026-10-04 14:18:35.845604+07
1344	ModifyGatewayMapping	REQUEST	Request Format	calleeE164Restrict	O	Integer	Number restriction on callee: None, Phone number, or Other number	{"0": "None", "1": "Phone number", "2": "Other number"}	23	2026-10-04 14:18:35.845604+07	Number restriction on callee	2026-10-04 14:18:35.845604+07
425	CreateGatewayRouting	REQUEST	Request Format	prefix	O	String	Gateway Prefix	{}	2	2026-10-03 18:22:12.869698+07	Gateway Prefix	2026-10-03 18:22:12.869698+07
1345	ModifyGatewayMapping	REQUEST	Request Format	maxCallDurationLower	O	Integer	Minimum call duration threshold in seconds (-1: System default, 0: No limit)	{"0": "None", "-1": "Default"}	24	2026-10-04 14:18:35.845604+07	Min conversation limitation(seconds)	2026-10-04 14:18:35.845604+07
1346	ModifyGatewayMapping	REQUEST	Request Format	maxCallDurationUpper	O	Integer	Maximum conversation duration limit in seconds (-1: System default, 0: No limit)	{"0": "None", "-1": "Default"}	25	2026-10-04 14:18:35.845604+07	Conversation limitation(seconds)	2026-10-04 14:18:35.845604+07
1347	ModifyGatewayMapping	REQUEST	Request Format	allowPhoneBilling	O	Boolean	If caller matches platform phone number, use account that phone number belongs to for billing	{}	26	2026-10-04 14:18:35.845604+07	Allow phone number billing	2026-10-04 14:18:35.845604+07
1348	ModifyGatewayMapping	REQUEST	Request Format	allowBindedE164Billing	O	Boolean	If caller matches bind number, use account that bind number belongs to for billing	{}	27	2026-10-04 14:18:35.845604+07	Allow bind number billing	2026-10-04 14:18:35.845604+07
1349	ModifyGatewayMapping	REQUEST	Request Format	enablePhoneSetting	O	Boolean	Use phone settings when caller matches phone number	{}	28	2026-10-04 14:18:35.845604+07	Enable phone setting	2026-10-04 14:18:35.845604+07
1350	ModifyGatewayMapping	REQUEST	Request Format	denySameCityCodesAllow	O	Boolean	Enable deny same city codes setting	{"true": "Enable", "false": "Disable"}	29	2026-10-04 14:18:35.845604+07	Deny same city codes enabled	2026-10-04 14:18:35.845604+07
1351	ModifyGatewayMapping	REQUEST	Request Format	denySameCityCodes	O	String	Deny same city codes settings, separated by comma	{}	30	2026-10-04 14:18:35.845604+07	Deny same city codes list	2026-10-04 14:18:35.845604+07
1352	ModifyGatewayMapping	REQUEST	Request Format	checkMobileAreaAllow	O	Boolean	Enable check mobile area settings	{"true": "Enable", "false": "Disable"}	31	2026-10-04 14:18:35.845604+07	Check mobile area enabled	2026-10-04 14:18:35.845604+07
1353	ModifyGatewayMapping	REQUEST	Request Format	checkMobileArea	O	String	Mobile area settings, separated by comma	{}	32	2026-10-04 14:18:35.845604+07	Check mobile area list	2026-10-04 14:18:35.845604+07
1354	ModifyGatewayMapping	REQUEST	Request Format	calloutCalleePrefixesAllow	O	Boolean	Permission mode for callee prefixes: allow or forbidden	{"true": "Allow", "false": "Forbidden"}	33	2026-10-04 14:18:35.845604+07	Mapping callee prefix (Mode)	2026-10-04 14:18:35.845604+07
1355	ModifyGatewayMapping	REQUEST	Request Format	calloutCalleePrefixes	O	String	Prefixes of callee numbers allowed or forbidden to pass through, separated by commas	{}	34	2026-10-04 14:18:35.845604+07	Mapping callee prefix	2026-10-04 14:18:35.845604+07
1356	ModifyGatewayMapping	REQUEST	Request Format	calloutCallerPrefixesAllow	O	Boolean	Permission mode for caller prefixes: allow or forbidden	{"true": "Allow", "false": "Forbidden"}	35	2026-10-04 14:18:35.845604+07	Mapping caller prefix (Mode)	2026-10-04 14:18:35.845604+07
1357	ModifyGatewayMapping	REQUEST	Request Format	calloutCallerPrefixes	O	String	Prefixes of caller numbers allowed or forbidden to pass through, separated by commas	{}	36	2026-10-04 14:18:35.845604+07	Mapping caller prefix	2026-10-04 14:18:35.845604+07
1358	ModifyGatewayMapping	REQUEST	Request Format	rewriteRulesOutCallee	O	String	Rewrite rules for callee number when entering mapping gateway (Initial prefix:Destination prefix)	{}	37	2026-10-04 14:18:35.845604+07	Callee rewrite rule	2026-10-04 14:18:35.845604+07
1359	ModifyGatewayMapping	REQUEST	Request Format	rewriteRulesOutCaller	O	String	Rewrite rules for caller number when entering mapping gateway (Initial prefix:Destination prefix)	{}	38	2026-10-04 14:18:35.845604+07	Caller rewrite rule	2026-10-04 14:18:35.845604+07
1360	ModifyGatewayMapping	REQUEST	Request Format	rewriteRulesInMobileAreaAllow	O	Boolean	Enable mobile area inbound rewrite rules setting	{"true": "Enable", "false": "Disable"}	39	2026-10-04 14:18:35.845604+07	Mobile area rewrite rules enabled	2026-10-04 14:18:35.845604+07
1361	ModifyGatewayMapping	REQUEST	Request Format	rewriteRulesInMobileArea	O	String	Mobile area inbound rewrite rules settings, separated by comma	{}	40	2026-10-04 14:18:35.845604+07	Mobile area rewrite rules list	2026-10-04 14:18:35.845604+07
1362	ModifyGatewayMapping	REQUEST	Request Format	timeoutCallProceeding	O	Integer	The maximum time waited after the call reached gateway (-1: System default, 0: None)	{"0": "None", "-1": "Default"}	41	2026-10-04 14:18:35.845604+07	Process timeout(seconds)	2026-10-04 14:18:35.845604+07
1363	ModifyGatewayMapping	REQUEST	Request Format	sipResponseAddressMethod	O	Integer	After receive SIP request message, send reply signal to which address: Socket, Via port, or Via	{"0": "Socket", "1": "Via port", "2": "Via"}	42	2026-10-04 14:18:35.845604+07	Reply address	2026-10-04 14:18:35.845604+07
1364	ModifyGatewayMapping	REQUEST	Request Format	sipRequestAddressMethod	O	Integer	After call established, send request signal to which address: Socket, Contact Port, or Contact	{"0": "Socket", "1": "Contact Port", "2": "Contact"}	43	2026-10-04 14:18:35.845604+07	Request address	2026-10-04 14:18:35.845604+07
1365	ModifyGatewayMapping	REQUEST	Request Format	dtmfSendMethodH323	O	Integer	DTMF transmission method for H.323 calls	{"0": "Auto", "10": "RFC2833", "20": "H.245 alphanumeric", "30": "H.245 signal", "40": "Q.931 keypad", "60": "Off"}	44	2026-10-04 14:18:35.845604+07	Dtmf send(h323)	2026-10-04 14:18:35.845604+07
1366	ModifyGatewayMapping	REQUEST	Request Format	dtmfSendMethodSIP	O	Integer	DTMF transmission method for SIP calls	{"0": "Auto", "10": "RFC2833", "50": "SIP INFO", "60": "Off"}	45	2026-10-04 14:18:35.845604+07	Dtmf send(sip)	2026-10-04 14:18:35.845604+07
1367	ModifyGatewayMapping	REQUEST	Request Format	dtmfReceiveMethod	O	Integer	DTMF reception method from remote peer (All is recommended)	{"0": "All", "10": "RFC2833", "20": "Signaling", "30": "Off"}	46	2026-10-04 14:18:35.845604+07	Dtmf receive	2026-10-04 14:18:35.845604+07
1368	ModifyGatewayMapping	REQUEST	Request Format	dtmfSendPayloadTypeH323	O	Integer	RTP payload type for H.323 RFC2833 DTMF sending (default 101)	{}	47	2026-10-04 14:18:35.845604+07	Payload (H.323)	2026-10-04 14:18:35.845604+07
1369	ModifyGatewayMapping	REQUEST	Request Format	dtmfSendPayloadTypeSIP	O	Integer	RTP payload type for SIP RFC2833 DTMF sending (default 101)	{}	48	2026-10-04 14:18:35.845604+07	Payload (SIP)	2026-10-04 14:18:35.845604+07
1370	ModifyGatewayMapping	REQUEST	Request Format	dtmfReceivePayloadType	O	Integer	RTP payload type for RFC2833 DTMF reception (default 101)	{}	49	2026-10-04 14:18:35.845604+07	Payload (Receive)	2026-10-04 14:18:35.845604+07
1371	ModifyGatewayMapping	REQUEST	Request Format	q931ProgressIndicator	O	Integer	Q.931 Progress Indicator signaling parameter for H.323 calls	{"0": "Off", "1": "Not End-to-End ISDN", "2": "Destination Non-ISDN", "3": "Origination Non-ISDN", "4": "Returned to ISDN", "5": "Service Change", "8": "Inband Info Available", "-1": "Default"}	50	2026-10-04 14:18:35.845604+07	Q.931 ProgressIndicator	2026-10-04 14:18:35.845604+07
1372	ModifyGatewayMapping	REQUEST	Request Format	account	O	String	The number/identifier of the billing account for this mapping gateway	{}	51	2026-10-04 14:18:35.845604+07	Account id	2026-10-04 14:18:35.845604+07
1373	ModifyGatewayMapping	REQUEST	Request Format	callTimeoutQ931CauseValue	O	Integer	Specify Q.931 disconnect cause value sent to mapping gateway on failure (0: No replace)	{"0": "No replace"}	52	2026-10-04 14:18:35.845604+07	Replace failed reason (Q.931)	2026-10-04 14:18:35.845604+07
1374	ModifyGatewayMapping	REQUEST	Request Format	callTimeoutSIPCode	O	Integer	Specify SIP disconnect status code sent to mapping gateway on failure (0: No replace)	{"0": "No replace"}	53	2026-10-04 14:18:35.845604+07	Replace failed reason (SIP)	2026-10-04 14:18:35.845604+07
1375	ModifyGatewayMapping	REQUEST	Request Format	sipRemoteRingSignal	O	Integer	Remote ringback signal returned to mapping gateway	{"0": "Passthrough", "1": "183 Session Progress + SDP", "2": "180 Alerting + SDP"}	54	2026-10-04 14:18:35.845604+07	Remote ring back mode	2026-10-04 14:18:35.845604+07
658	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	gatewayGroups	M	String	Gateway Groups	{}	10	2026-10-03 18:22:12.869698+07	Gateway Groups	2026-10-03 18:22:12.869698+07
659	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	capacity	M	Integer	LineLimit	{}	11	2026-10-03 18:22:12.869698+07	Concurrent Line Limit	2026-10-03 18:22:12.869698+07
660	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	lockType	M	Integer	LockType 0:NoLock 3:Lock All Default:0	{"0": "NoLock", "3": "Lock"}	12	2026-10-03 18:22:12.869698+07	Lock Status	2026-10-03 18:22:12.869698+07
1376	ModifyGatewayMapping	REQUEST	Request Format	sipCalleeE164Domain	O	Integer	Extract callee number from SIP signal field: To, Request-Line, or Diversion	{"0": "To", "1": "Request-Line", "2": "Diversion"}	55	2026-10-04 14:18:35.845604+07	Callee	2026-10-04 14:18:35.845604+07
1377	ModifyGatewayMapping	REQUEST	Request Format	sipCallerE164Domain	O	Integer	Extract caller number from SIP signal field: From, Remote-Party-ID, or Display	{"0": "From", "1": "Remote-Party-ID", "2": "Display"}	56	2026-10-04 14:18:35.845604+07	Caller	2026-10-04 14:18:35.845604+07
1378	ModifyGatewayMapping	REQUEST	Request Format	h323CalleeE164Domain	O	Integer	Extract callee number from H.323 signal field: CalledPartyNumber or DestinationAddress	{"0": "CalledPartyNumber", "1": "DestinationAddress"}	57	2026-10-04 14:18:35.845604+07	Callee (H.323)	2026-10-04 14:18:35.845604+07
1379	ModifyGatewayMapping	REQUEST	Request Format	h323CallerE164Domain	O	Integer	Extract caller number from H.323 signal field: CallingPartyNumber, SourceAddress, or Display	{"0": "CallingPartyNumber", "1": "SourceAddress", "2": "Display"}	58	2026-10-04 14:18:35.845604+07	Caller (H.323)	2026-10-04 14:18:35.845604+07
1380	ModifyGatewayMapping	REQUEST	Request Format	memo	O	String	Comments / operational notes on this gateway	{}	59	2026-10-04 14:18:35.845604+07	Memo	2026-10-04 14:18:35.845604+07
1381	ModifyGatewayMapping	REQUEST	Request Format	sipAuthenticationMethod	O	Integer	Call authentication mode for inbound SIP calls: IP, IP Address and Port, or Authenticate by Password	{"0": "Ip", "1": "IP Address and Port", "2": "Authenticate by Password"}	60	2026-10-04 14:18:35.845604+07	Call authentication mode	2026-10-04 14:18:35.845604+07
1382	ModifyGatewayMapping	REQUEST	Request Format	h323FastStart	O	Boolean	Check to enable H.323 FastStart procedure	{"true": "Enable", "false": "Disable"}	61	2026-10-04 14:18:35.845604+07	FastStart	2026-10-04 14:18:35.845604+07
1383	ModifyGatewayMapping	REQUEST	Request Format	h323H245Tunneling	O	Boolean	Check to enable H.245 tunneling in Q.931 messages	{"true": "Enable", "false": "Disable"}	62	2026-10-04 14:18:35.845604+07	H245Tunneling	2026-10-04 14:18:35.845604+07
1384	ModifyGatewayMapping	REQUEST	Request Format	h323H245InSetup	O	Boolean	Check to enable H.245 in SETUP	{"true": "Enable", "false": "Disable"}	63	2026-10-04 14:18:35.845604+07	H245InSetup	2026-10-04 14:18:35.845604+07
1385	ModifyGatewayMapping	REQUEST	Request Format	h323AutoCallProceeding	O	Boolean	Check to send callproceeding when receives SETUP	{"true": "Enable", "false": "Disable"}	64	2026-10-04 14:18:35.845604+07	Send callproceeding immediately	2026-10-04 14:18:35.845604+07
1386	ModifyGatewayMapping	REQUEST	Request Format	h323CallProceedingFromSIPTrying	O	Boolean	If caller uses H323 and callee uses SIP, when callee returns Trying, VOS sends callproceeding to caller	{"true": "Enable", "false": "Disable"}	65	2026-10-04 14:18:35.845604+07	Convert trying	2026-10-04 14:18:35.845604+07
1387	ModifyGatewayMapping	REQUEST	Request Format	h323AlertingFromSIP183Sdp	O	Boolean	If caller uses H323 and callee uses SIP, when callee returns 183 SDP, VOS sends alerting to caller	{"true": "Enable", "false": "Disable"}	66	2026-10-04 14:18:35.845604+07	Change 183(sdp) to alerting	2026-10-04 14:18:35.845604+07
1388	ModifyGatewayMapping	REQUEST	Request Format	h323T38	O	Boolean	Check to include T.38 fax over H.323	{"true": "Enable", "false": "Disable"}	67	2026-10-04 14:18:35.845604+07	Allow t38 (H.323)	2026-10-04 14:18:35.845604+07
1389	ModifyGatewayMapping	REQUEST	Request Format	sipTimer	O	Boolean	Enable SIP Session Timer protocol (RFC 4028) to detect dead calls	{"true": "Enable", "false": "Disable"}	68	2026-10-04 14:18:35.845604+07	Enable timer protocol	2026-10-04 14:18:35.845604+07
1390	ModifyGatewayMapping	REQUEST	Request Format	sip100Rel	O	Boolean	Send/support 100rel provisional reliable responses (RFC 3262 PRACK)	{"true": "Enable", "false": "Disable"}	69	2026-10-04 14:18:35.845604+07	Enable 100rel	2026-10-04 14:18:35.845604+07
1391	ModifyGatewayMapping	REQUEST	Request Format	sipT38	O	Boolean	Allow send T.38 fax signal to/from mapping gateway over SIP	{"true": "Enable", "false": "Disable"}	70	2026-10-04 14:18:35.845604+07	Allow t38 (SIP)	2026-10-04 14:18:35.845604+07
1392	ModifyGatewayMapping	REQUEST	Request Format	sipDisplay	O	Integer	SIP display name handling mode (Default, From, Remote-Party-ID, or Ignore)	{"0": "Default", "1": "From", "2": "Remote-Party-ID", "3": "Ignore"}	71	2026-10-04 14:18:35.845604+07	Display	2026-10-04 14:18:35.845604+07
1393	ModifyGatewayMapping	REQUEST	Request Format	sipRemotePartyId	O	Boolean	Include Remote-Party-ID header in SIP signaling	{"true": "Include", "false": "Exclude"}	72	2026-10-04 14:18:35.845604+07	Remote-Party-ID	2026-10-04 14:18:35.845604+07
1394	ModifyGatewayMapping	REQUEST	Request Format	sipPrivacySupport	O	Boolean	Pass through mapping gateway private domain (RFC 3323 Privacy header)	{"true": "Enable", "false": "Disable"}	73	2026-10-04 14:18:35.845604+07	Support privacy	2026-10-04 14:18:35.845604+07
1395	ModifyGatewayMapping	REQUEST	Request Format	groupE164Change	O	Boolean	Use number in Number Transformation table to replace caller ID	{"true": "Enable", "false": "Disable"}	74	2026-10-04 14:18:35.845604+07	Caller transform	2026-10-04 14:18:35.845604+07
1396	ModifyGatewayMapping	REQUEST	Request Format	callerAllowLength	O	Integer	Allowed lengths of caller numbers (e.g. fill in "11, 14" means only 11-digit or 14-digit numbers allowed)	{}	75	2026-10-04 14:18:35.845604+07	Caller number allow length	2026-10-04 14:18:35.845604+07
1397	ModifyGatewayMapping	REQUEST	Request Format	calleeAllowLength	O	Integer	Allowed lengths of callee numbers (blank allows all, "0" allows none)	{}	76	2026-10-04 14:18:35.845604+07	Callee number allow length	2026-10-04 14:18:35.845604+07
1398	ModifyGatewayMapping	REQUEST	Request Format	callerLimitE164GroupsAllow	O	Boolean	Permission mode for caller black/white list group: allow or forbidden	{"true": "Allow", "false": "Forbidden"}	77	2026-10-04 14:18:35.845604+07	Caller black/white list group (Mode)	2026-10-04 14:18:35.845604+07
1399	ModifyGatewayMapping	REQUEST	Request Format	callerLimitE164Groups	O	String	Caller black/white list group names, separated by comma	{}	78	2026-10-04 14:18:35.845604+07	Caller black/white list group	2026-10-04 14:18:35.845604+07
1400	ModifyGatewayMapping	REQUEST	Request Format	calleeLimitE164GroupsAllow	O	Boolean	Permission mode for callee black/white list group: allow or forbidden	{"true": "Allow", "false": "Forbidden"}	79	2026-10-04 14:18:35.845604+07	Callee black/white list group (Mode)	2026-10-04 14:18:35.845604+07
1401	ModifyGatewayMapping	REQUEST	Request Format	calleeLimitE164Groups	O	String	Callee black/white list group names, separated by comma	{}	80	2026-10-04 14:18:35.845604+07	Callee black/white list group	2026-10-04 14:18:35.845604+07
1402	ModifyGatewayMapping	REQUEST	Request Format	minProfitPercentEnable	O	Boolean	Enable lowest profit rate threshold check	{"true": "Enable", "false": "Disable"}	81	2026-10-04 14:18:35.845604+07	Lowest profit rate limit (Enable)	2026-10-04 14:18:35.845604+07
1403	ModifyGatewayMapping	REQUEST	Request Format	minProfitPercent	O	Integer	This gateway will be locked if profit rate (%) falls below this value	{}	82	2026-10-04 14:18:35.845604+07	Lowest profit rate limit	2026-10-04 14:18:35.845604+07
1404	ModifyGatewayMapping	REQUEST	Request Format	maxSecondRatesEnable	O	Boolean	Enable max minute rate threshold check	{"true": "Enable", "false": "Disable"}	83	2026-10-04 14:18:35.845604+07	Max minute rates (Enable)	2026-10-04 14:18:35.845604+07
1405	ModifyGatewayMapping	REQUEST	Request Format	maxSecondRates	O	Integer	Max minute rate allowed for callee number (internally stored as second rate = minute rate / 60)	{}	84	2026-10-04 14:18:35.845604+07	Max minute rates	2026-10-04 14:18:35.845604+07
1406	ModifyGatewayMapping	REQUEST	Request Format	firstRoutePolicy	O	Integer	First priority routing strategy: None (system default), ASR, or Lowest rate per second	{"0": "None", "1": "ASR", "2": "Lowest rate per second"}	85	2026-10-04 14:18:35.845604+07	First routing strategy	2026-10-04 14:18:35.845604+07
1407	ModifyGatewayMapping	REQUEST	Request Format	secondRoutePolicy	O	Integer	Second priority routing strategy: None, ASR, or Lowest rate per second	{"0": "None", "1": "ASR", "2": "Lowest rate per second"}	86	2026-10-04 14:18:35.845604+07	Second routing strategy	2026-10-04 14:18:35.845604+07
1408	ModifyGatewayMapping	REQUEST	Request Format	h323G729SendMode	O	Integer	H.323 G.729 codec negotiation mode: Auto, G729, G729a, or G729&G729a	{"0": "Auto", "1": "G729", "2": "G729a", "3": "G729&G729a"}	87	2026-10-04 14:18:35.845604+07	G729 negotiation mode (H.323)	2026-10-04 14:18:35.845604+07
1409	ModifyGatewayMapping	REQUEST	Request Format	sipG729SendMode	O	Integer	SIP G.729 codec negotiation mode: Auto, G729, G729a, or G729&G729a	{"0": "Auto", "1": "G729", "2": "G729a", "3": "G729&G729a"}	88	2026-10-04 14:18:35.845604+07	G729 negotiation mode (SIP)	2026-10-04 14:18:35.845604+07
1410	ModifyGatewayMapping	REQUEST	Request Format	sipG729Annexb	O	Integer	SIP G.729 Annex B voice activity detection negotiation	{"0": "Auto", "1": "yes", "2": "no", "3": "None", "4": "Passthrough"}	89	2026-10-04 14:18:35.845604+07	G729 annexb	2026-10-04 14:18:35.845604+07
1411	ModifyGatewayMapping	REQUEST	Request Format	sipG723Annexa	O	Integer	SIP G.723.1 Annex A silence suppression negotiation	{"0": "Auto", "1": "yes", "2": "no", "3": "None", "4": "Passthrough"}	90	2026-10-04 14:18:35.845604+07	G723 annexa	2026-10-04 14:18:35.845604+07
1412	ModifyGatewayMapping	REQUEST	Request Format	h323CodecAssign	O	Boolean	Codec negotiation policy for H.323: Auto negotiation or Softswitch specified	{"true": "Softswitch specified", "false": "Auto negotiation"}	91	2026-10-04 14:18:35.845604+07	H.323 Codec Negotiation Policy	2026-10-04 14:18:35.845604+07
1413	ModifyGatewayMapping	REQUEST	Request Format	h323Codecs	O	Vector<String>	Prioritized list of codecs specified for H.323 softswitch negotiation	{}	92	2026-10-04 14:18:35.845604+07	Specify codec (H.323)	2026-10-04 14:18:35.845604+07
1414	ModifyGatewayMapping	REQUEST	Request Format	sipCodecAssign	O	Boolean	Codec negotiation policy for SIP: Auto negotiation or Softswitch specified	{"true": "Softswitch specified", "false": "Auto negotiation"}	93	2026-10-04 14:18:35.845604+07	SIP Codec Negotiation Policy	2026-10-04 14:18:35.845604+07
1415	ModifyGatewayMapping	REQUEST	Request Format	sipCodecs	O	Vector<String>	Prioritized list of codecs specified for SIP softswitch negotiation	{}	94	2026-10-04 14:18:35.845604+07	Specify codec (SIP)	2026-10-04 14:18:35.845604+07
1416	ModifyGatewayMapping	REQUEST	Request Format	forwardSignalRewriteE164GroupEnable	M	Boolean	Check to enable forwarding signal rewrite pool	{"true": "Enable", "false": "Disable"}	95	2026-10-04 14:18:35.845604+07	Enable forwarding signal rewrite pool	2026-10-04 14:18:35.845604+07
1417	ModifyGatewayMapping	REQUEST	Request Format	forwardSignalRewriteE164Group	M	String	Add prefix for callee number by proportion (Proportion:Route prefix) or Forward Pool Group	{}	96	2026-10-04 14:18:35.845604+07	Add prefix to the callee / Forward Pool	2026-10-04 14:18:35.845604+07
1418	ModifyGatewayMapping	REQUEST	Request Format	lrnEnable	O	Boolean	Enable Location Routing Number (LRN) dip query via SCP server	{"true": "Enable", "false": "Disable"}	97	2026-10-04 14:18:35.845604+07	Query lrn	2026-10-04 14:18:35.845604+07
1419	ModifyGatewayMapping	REQUEST	Request Format	lrnEatPrefixLength	O	Integer	Cut specified number of prefix digits from LRN response, then use remaining digits for billing	{}	98	2026-10-04 14:18:35.845604+07	Eat prefix length	2026-10-04 14:18:35.845604+07
1420	ModifyGatewayMapping	REQUEST	Request Format	lrnFailureAction	O	Integer	Action taken when LRN query fails: Reject or Continue	{"0": "Reject", "1": "Continue"}	99	2026-10-04 14:18:35.845604+07	Failure action	2026-10-04 14:18:35.845604+07
1421	ModifyGatewayMapping	REQUEST	Request Format	lrnInterstateBillingPrefix	O	String	Prefix prepended to billing code for interstate calls	{}	100	2026-10-04 14:18:35.845604+07	Interstate billing prefix	2026-10-04 14:18:35.845604+07
1422	ModifyGatewayMapping	REQUEST	Request Format	lrnUndeterminedBillingPrefix	O	String	Prefix prepended to billing code when interstate status cannot be determined	{}	101	2026-10-04 14:18:35.845604+07	Undetermined billing prefix	2026-10-04 14:18:35.845604+07
1423	ModifyGatewayMapping	RESPONSE	Response Format	retCode	M	Integer	Response Return Code (0: Success, !=0: Failed)	{"0": "Success", "1001": "Server Error"}	102	2026-10-04 14:18:35.845604+07	Return Code Status	2026-10-04 14:18:35.845604+07
1424	ModifyGatewayMapping	RESPONSE	Response Format	exception	O	String	Exception error message string if request failed	{}	103	2026-10-04 14:18:35.845604+07	Error Information	2026-10-04 14:18:35.845604+07
1425	GetGatewayMapping	REQUEST	Request Format	names	M	String []	Gateway Names filter array (Blank: All)	{}	1	2026-10-04 14:18:35.845604+07	Gateway names filter	2026-10-04 14:18:35.845604+07
1426	GetGatewayMapping	RESPONSE	Response Format	retCode	M	Integer	Response Return Code (0: Success, !=0: Failed)	{"0": "Success", "1001": "Server Error"}	2	2026-10-04 14:18:35.845604+07	Return Code Status	2026-10-04 14:18:35.845604+07
1427	GetGatewayMapping	RESPONSE	Response Format	exception	O	String	Exception error message string if request failed	{}	3	2026-10-04 14:18:35.845604+07	Error Information	2026-10-04 14:18:35.845604+07
1428	GetGatewayMapping	RESPONSE	Response Format	infoGatewayMappings	O	InfoGatewayMapping[]	Array of InfoGatewayMapping structures	{}	4	2026-10-04 14:18:35.845604+07	Gateway mappings list	2026-10-04 14:18:35.845604+07
1429	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	name	M	String	Unique ID of the device / Mapping Gateway Name	{}	5	2026-10-04 14:18:35.845604+07	Gateway name	2026-10-04 14:18:35.845604+07
1430	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	lockType	M	Integer	Gateway lock status	{"0": "No lock", "1": "Lock out", "2": "Lock in", "3": "Lock all"}	6	2026-10-04 14:18:35.845604+07	Lock type	2026-10-04 14:18:35.845604+07
1431	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	callLevel	M	Integer	Call permission level for routing	{"1": "Net", "2": "Local", "4": "Domestic", "5": "International"}	7	2026-10-04 14:18:35.845604+07	Call permission	2026-10-04 14:18:35.845604+07
1432	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	capacity	M	Integer	The number of concurrent calls allowed by the gateway (0 means unlimited)	{}	8	2026-10-04 14:18:35.845604+07	Line limit	2026-10-04 14:18:35.845604+07
1433	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	priority	M	Integer	Priority for static gateway with the same IP to match (smaller number has higher priority)	{}	9	2026-10-04 14:18:35.845604+07	Priority	2026-10-04 14:18:35.845604+07
1434	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	gatewayGroups	M	String	Set the gateway's group, used for control several gateways' total concurrency (comma separated)	{}	10	2026-10-04 14:18:35.845604+07	Gateway group	2026-10-04 14:18:35.845604+07
1437	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	registerType	M	Integer	Mapping gateway type: Static (directly through IP) or Dynamic (registration required)	{"0": "Static", "1": "Dynamic"}	13	2026-10-04 14:18:35.845604+07	Gateway type	2026-10-04 14:18:35.845604+07
1438	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	remoteIps	M	String	IP addresses of mapping gateways. Multiple addresses and signaling ports separated by commas	{}	14	2026-10-04 14:18:35.845604+07	Ip	2026-10-04 14:18:35.845604+07
1439	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	callerE164CheckEnable	M	Boolean	Enable caller number validation check	{"true": "Enable", "false": "Disable"}	15	2026-10-04 14:18:35.845604+07	Caller check enabled	2026-10-04 14:18:35.845604+07
1435	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	routingGatewayGroupsAllow	M	Boolean	Permission mode for routing gateway groups: allow or forbidden	{"true": "Allow", "false": "Forbidden"}	11	2026-10-04 14:18:35.845604+07	Routing gateway group (Mode)	2026-10-05 08:24:02.840775+07
1440	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	callerE164CheckCity	M	Boolean	Enable caller city code validation check	{"true": "Enable", "false": "Disable"}	16	2026-10-04 14:18:35.845604+07	Caller city check	2026-10-04 14:18:35.845604+07
1441	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	callerE164CheckMobile	M	Boolean	Enable caller mobile number validation check	{"true": "Enable", "false": "Disable"}	17	2026-10-04 14:18:35.845604+07	Caller mobile check	2026-10-04 14:18:35.845604+07
1442	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	callerE164CheckOther	M	Boolean	Enable caller other prefix validation check	{"true": "Enable", "false": "Disable"}	18	2026-10-04 14:18:35.845604+07	Caller other check	2026-10-04 14:18:35.845604+07
1443	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	calleeE164CheckEnable	M	Boolean	Enable callee number validation check	{"true": "Enable", "false": "Disable"}	19	2026-10-04 14:18:35.845604+07	Callee check enabled	2026-10-04 14:18:35.845604+07
1444	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	calleeE164CheckCity	M	Boolean	Enable callee city code validation check	{"true": "Enable", "false": "Disable"}	20	2026-10-04 14:18:35.845604+07	Callee city check	2026-10-04 14:18:35.845604+07
1445	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	calleeE164CheckMobile	M	Boolean	Enable callee mobile number validation check	{"true": "Enable", "false": "Disable"}	21	2026-10-04 14:18:35.845604+07	Callee mobile check	2026-10-04 14:18:35.845604+07
1446	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	calleeE164CheckOther	M	Boolean	Enable callee other prefix validation check	{"true": "Enable", "false": "Disable"}	22	2026-10-04 14:18:35.845604+07	Callee other check	2026-10-04 14:18:35.845604+07
1447	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	rtpForwardType	M	Integer	Media proxy (RTP forwarding) mode: Auto, On, Off	{"0": "Auto", "1": "On", "2": "Off"}	23	2026-10-04 14:18:35.845604+07	Media proxy	2026-10-04 14:18:35.845604+07
1448	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	mediaCheckDirection	M	Integer	RTP stream interrupt detection mode	{"0": "No detect", "1": "Detect whether VOS sent RTP", "2": "Detect whether VOS received remote RTP", "3": "Bidirection"}	24	2026-10-04 14:18:35.845604+07	Rtp interrupt detection	2026-10-04 14:18:35.845604+07
1449	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	calleeE164Restrict	M	Integer	Number restriction on callee: None, Phone number, or Other number	{"0": "None", "1": "Phone number", "2": "Other number"}	25	2026-10-04 14:18:35.845604+07	Number restriction on callee	2026-10-04 14:18:35.845604+07
1450	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	maxCallDurationLower	M	Integer	Minimum call duration threshold in seconds (-1: System default, 0: No limit)	{"0": "None", "-1": "Default"}	26	2026-10-04 14:18:35.845604+07	Min conversation limitation(seconds)	2026-10-04 14:18:35.845604+07
1451	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	maxCallDurationUpper	M	Integer	Maximum conversation duration limit in seconds (-1: System default, 0: No limit)	{"0": "None", "-1": "Default"}	27	2026-10-04 14:18:35.845604+07	Conversation limitation(seconds)	2026-10-04 14:18:35.845604+07
1452	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	allowPhoneBilling	M	Boolean	If caller matches platform phone number, use account that phone number belongs to for billing	{}	28	2026-10-04 14:18:35.845604+07	Allow phone number billing	2026-10-04 14:18:35.845604+07
1453	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	allowBindedE164Billing	M	Boolean	If caller matches bind number, use account that bind number belongs to for billing	{}	29	2026-10-04 14:18:35.845604+07	Allow bind number billing	2026-10-04 14:18:35.845604+07
1454	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	enablePhoneSetting	M	Boolean	Use phone settings when caller matches phone number	{}	30	2026-10-04 14:18:35.845604+07	Enable phone setting	2026-10-04 14:18:35.845604+07
1455	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	denySameCityCodesAllow	M	Boolean	Enable deny same city codes setting	{"true": "Enable", "false": "Disable"}	31	2026-10-04 14:18:35.845604+07	Deny same city codes enabled	2026-10-04 14:18:35.845604+07
1456	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	denySameCityCodes	M	String	Deny same city codes settings, separated by comma	{}	32	2026-10-04 14:18:35.845604+07	Deny same city codes list	2026-10-04 14:18:35.845604+07
1457	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	checkMobileAreaAllow	M	Boolean	Enable check mobile area settings	{"true": "Enable", "false": "Disable"}	33	2026-10-04 14:18:35.845604+07	Check mobile area enabled	2026-10-04 14:18:35.845604+07
1458	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	checkMobileArea	M	String	Mobile area settings, separated by comma	{}	34	2026-10-04 14:18:35.845604+07	Check mobile area list	2026-10-04 14:18:35.845604+07
1459	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	calloutCalleePrefixesAllow	M	Boolean	Permission mode for callee prefixes: allow or forbidden	{"true": "Allow", "false": "Forbidden"}	35	2026-10-04 14:18:35.845604+07	Mapping callee prefix (Mode)	2026-10-04 14:18:35.845604+07
1460	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	calloutCalleePrefixes	M	String	Prefixes of callee numbers allowed or forbidden to pass through, separated by commas	{}	36	2026-10-04 14:18:35.845604+07	Mapping callee prefix	2026-10-04 14:18:35.845604+07
1461	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	calloutCallerPrefixesAllow	M	Boolean	Permission mode for caller prefixes: allow or forbidden	{"true": "Allow", "false": "Forbidden"}	37	2026-10-04 14:18:35.845604+07	Mapping caller prefix (Mode)	2026-10-04 14:18:35.845604+07
1462	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	calloutCallerPrefixes	M	String	Prefixes of caller numbers allowed or forbidden to pass through, separated by commas	{}	38	2026-10-04 14:18:35.845604+07	Mapping caller prefix	2026-10-04 14:18:35.845604+07
1463	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	rewriteRulesOutCallee	M	String	Rewrite rules for callee number when entering mapping gateway (Initial prefix:Destination prefix)	{}	39	2026-10-04 14:18:35.845604+07	Callee rewrite rule	2026-10-04 14:18:35.845604+07
1464	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	rewriteRulesOutCaller	M	String	Rewrite rules for caller number when entering mapping gateway (Initial prefix:Destination prefix)	{}	40	2026-10-04 14:18:35.845604+07	Caller rewrite rule	2026-10-04 14:18:35.845604+07
1465	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	rewriteRulesInMobileAreaAllow	M	Boolean	Enable mobile area inbound rewrite rules setting	{"true": "Enable", "false": "Disable"}	41	2026-10-04 14:18:35.845604+07	Mobile area rewrite rules enabled	2026-10-04 14:18:35.845604+07
1466	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	rewriteRulesInMobileArea	M	String	Mobile area inbound rewrite rules settings, separated by comma	{}	42	2026-10-04 14:18:35.845604+07	Mobile area rewrite rules list	2026-10-04 14:18:35.845604+07
1467	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	timeoutCallProceeding	M	Integer	The maximum time waited after the call reached gateway (-1: System default, 0: None)	{"0": "None", "-1": "Default"}	43	2026-10-04 14:18:35.845604+07	Process timeout(seconds)	2026-10-04 14:18:35.845604+07
1468	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipResponseAddressMethod	M	Integer	After receive SIP request message, send reply signal to which address: Socket, Via port, or Via	{"0": "Socket", "1": "Via port", "2": "Via"}	44	2026-10-04 14:18:35.845604+07	Reply address	2026-10-04 14:18:35.845604+07
1469	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipRequestAddressMethod	M	Integer	After call established, send request signal to which address: Socket, Contact Port, or Contact	{"0": "Socket", "1": "Contact Port", "2": "Contact"}	45	2026-10-04 14:18:35.845604+07	Request address	2026-10-04 14:18:35.845604+07
424	CreateGatewayRouting	REQUEST	Request Format	name	M	String	RoutingGateway Name	{}	1	2026-10-03 18:22:12.869698+07	Gateway Name	2026-10-03 18:22:12.869698+07
1470	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	dtmfSendMethodH323	M	Integer	DTMF transmission method for H.323 calls	{"0": "Auto", "10": "RFC2833", "20": "H.245 alphanumeric", "30": "H.245 signal", "40": "Q.931 keypad", "60": "Off"}	46	2026-10-04 14:18:35.845604+07	Dtmf send(h323)	2026-10-04 14:18:35.845604+07
1471	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	dtmfSendMethodSIP	M	Integer	DTMF transmission method for SIP calls	{"0": "Auto", "10": "RFC2833", "50": "SIP INFO", "60": "Off"}	47	2026-10-04 14:18:35.845604+07	Dtmf send(sip)	2026-10-04 14:18:35.845604+07
1472	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	dtmfReceiveMethod	M	Integer	DTMF reception method from remote peer (All is recommended)	{"0": "All", "10": "RFC2833", "20": "Signaling", "30": "Off"}	48	2026-10-04 14:18:35.845604+07	Dtmf receive	2026-10-04 14:18:35.845604+07
1473	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	dtmfSendPayloadTypeH323	M	Integer	RTP payload type for H.323 RFC2833 DTMF sending (default 101)	{}	49	2026-10-04 14:18:35.845604+07	Payload (H.323)	2026-10-04 14:18:35.845604+07
1474	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	dtmfSendPayloadTypeSIP	M	Integer	RTP payload type for SIP RFC2833 DTMF sending (default 101)	{}	50	2026-10-04 14:18:35.845604+07	Payload (SIP)	2026-10-04 14:18:35.845604+07
1475	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	dtmfReceivePayloadType	M	Integer	RTP payload type for RFC2833 DTMF reception (default 101)	{}	51	2026-10-04 14:18:35.845604+07	Payload (Receive)	2026-10-04 14:18:35.845604+07
1476	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	q931ProgressIndicator	M	Integer	Q.931 Progress Indicator signaling parameter for H.323 calls	{"0": "Off", "1": "Not End-to-End ISDN", "2": "Destination Non-ISDN", "3": "Origination Non-ISDN", "4": "Returned to ISDN", "5": "Service Change", "8": "Inband Info Available", "-1": "Default"}	52	2026-10-04 14:18:35.845604+07	Q.931 ProgressIndicator	2026-10-04 14:18:35.845604+07
1477	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	account	M	String	The number/identifier of the billing account for this mapping gateway	{}	53	2026-10-04 14:18:35.845604+07	Account id	2026-10-04 14:18:35.845604+07
1478	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	callTimeoutQ931CauseValue	M	Integer	Specify Q.931 disconnect cause value sent to mapping gateway on failure (0: No replace)	{"0": "No replace"}	54	2026-10-04 14:18:35.845604+07	Replace failed reason (Q.931)	2026-10-04 14:18:35.845604+07
1479	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	callTimeoutSIPCode	M	Integer	Specify SIP disconnect status code sent to mapping gateway on failure (0: No replace)	{"0": "No replace"}	55	2026-10-04 14:18:35.845604+07	Replace failed reason (SIP)	2026-10-04 14:18:35.845604+07
1480	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipRemoteRingSignal	M	Integer	Remote ringback signal returned to mapping gateway	{"0": "Passthrough", "1": "183 Session Progress + SDP", "2": "180 Alerting + SDP"}	56	2026-10-04 14:18:35.845604+07	Remote ring back mode	2026-10-04 14:18:35.845604+07
1481	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipCalleeE164Domain	M	Integer	Extract callee number from SIP signal field: To, Request-Line, or Diversion	{"0": "To", "1": "Request-Line", "2": "Diversion"}	57	2026-10-04 14:18:35.845604+07	Callee	2026-10-04 14:18:35.845604+07
1482	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipCallerE164Domain	M	Integer	Extract caller number from SIP signal field: From, Remote-Party-ID, or Display	{"0": "From", "1": "Remote-Party-ID", "2": "Display"}	58	2026-10-04 14:18:35.845604+07	Caller	2026-10-04 14:18:35.845604+07
1483	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	h323CalleeE164Domain	M	Integer	Extract callee number from H.323 signal field: CalledPartyNumber or DestinationAddress	{"0": "CalledPartyNumber", "1": "DestinationAddress"}	59	2026-10-04 14:18:35.845604+07	Callee (H.323)	2026-10-04 14:18:35.845604+07
1484	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	h323CallerE164Domain	M	Integer	Extract caller number from H.323 signal field: CallingPartyNumber, SourceAddress, or Display	{"0": "CallingPartyNumber", "1": "SourceAddress", "2": "Display"}	60	2026-10-04 14:18:35.845604+07	Caller (H.323)	2026-10-04 14:18:35.845604+07
1485	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	memo	M	String	Comments / operational notes on this gateway	{}	61	2026-10-04 14:18:35.845604+07	Memo	2026-10-04 14:18:35.845604+07
1486	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipAuthenticationMethod	M	Integer	Call authentication mode for inbound SIP calls: IP, IP Address and Port, or Authenticate by Password	{"0": "Ip", "1": "IP Address and Port", "2": "Authenticate by Password"}	62	2026-10-04 14:18:35.845604+07	Call authentication mode	2026-10-04 14:18:35.845604+07
1487	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	h323FastStart	M	Boolean	Check to enable H.323 FastStart procedure	{"true": "Enable", "false": "Disable"}	63	2026-10-04 14:18:35.845604+07	FastStart	2026-10-04 14:18:35.845604+07
1488	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	h323H245Tunneling	M	Boolean	Check to enable H.245 tunneling in Q.931 messages	{"true": "Enable", "false": "Disable"}	64	2026-10-04 14:18:35.845604+07	H245Tunneling	2026-10-04 14:18:35.845604+07
1489	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	h323H245InSetup	M	Boolean	Check to enable H.245 in SETUP	{"true": "Enable", "false": "Disable"}	65	2026-10-04 14:18:35.845604+07	H245InSetup	2026-10-04 14:18:35.845604+07
1490	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	h323AutoCallProceeding	M	Boolean	Check to send callproceeding when receives SETUP	{"true": "Enable", "false": "Disable"}	66	2026-10-04 14:18:35.845604+07	Send callproceeding immediately	2026-10-04 14:18:35.845604+07
1491	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	h323CallProceedingFromSIPTrying	M	Boolean	If caller uses H323 and callee uses SIP, when callee returns Trying, VOS sends callproceeding to caller	{"true": "Enable", "false": "Disable"}	67	2026-10-04 14:18:35.845604+07	Convert trying	2026-10-04 14:18:35.845604+07
1492	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	h323AlertingFromSIP183Sdp	M	Boolean	If caller uses H323 and callee uses SIP, when callee returns 183 SDP, VOS sends alerting to caller	{"true": "Enable", "false": "Disable"}	68	2026-10-04 14:18:35.845604+07	Change 183(sdp) to alerting	2026-10-04 14:18:35.845604+07
1493	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	h323T38	M	Boolean	Check to include T.38 fax over H.323	{"true": "Enable", "false": "Disable"}	69	2026-10-04 14:18:35.845604+07	Allow t38 (H.323)	2026-10-04 14:18:35.845604+07
1494	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipTimer	M	Boolean	Enable SIP Session Timer protocol (RFC 4028) to detect dead calls	{"true": "Enable", "false": "Disable"}	70	2026-10-04 14:18:35.845604+07	Enable timer protocol	2026-10-04 14:18:35.845604+07
1495	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sip100Rel	M	Boolean	Send/support 100rel provisional reliable responses (RFC 3262 PRACK)	{"true": "Enable", "false": "Disable"}	71	2026-10-04 14:18:35.845604+07	Enable 100rel	2026-10-04 14:18:35.845604+07
1496	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipT38	M	Boolean	Allow send T.38 fax signal to/from mapping gateway over SIP	{"true": "Enable", "false": "Disable"}	72	2026-10-04 14:18:35.845604+07	Allow t38 (SIP)	2026-10-04 14:18:35.845604+07
1497	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipDisplay	M	Integer	SIP display name handling mode (Default, From, Remote-Party-ID, or Ignore)	{"0": "Default", "1": "From", "2": "Remote-Party-ID", "3": "Ignore"}	73	2026-10-04 14:18:35.845604+07	Display	2026-10-04 14:18:35.845604+07
1498	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipRemotePartyId	M	Boolean	Include Remote-Party-ID header in SIP signaling	{"true": "Include", "false": "Exclude"}	74	2026-10-04 14:18:35.845604+07	Remote-Party-ID	2026-10-04 14:18:35.845604+07
1499	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipPPreferredIdentity	M	Boolean	SIP P-Preferred-Identity header handling mode	{"0": "None", "1": "Passthrough", "2": "Caller"}	75	2026-10-04 14:18:35.845604+07	P-Preferred-Identity	2026-10-04 14:18:35.845604+07
426	CreateGatewayRouting	REQUEST	Request Format	prefixStyle	O	Integer	PrefixMode 0:Terminal 1:Continual	{"0": "Terminal", "1": "Continual"}	3	2026-10-03 18:22:12.869698+07	Prefix Style (0: Terminal, 1: Continual)	2026-10-03 18:22:12.869698+07
427	CreateGatewayRouting	REQUEST	Request Format	password	O	String	Gateway Password Default:Random Create	{}	4	2026-10-03 18:22:12.869698+07	SIP Register Password	2026-10-03 18:22:12.869698+07
428	CreateGatewayRouting	REQUEST	Request Format	customerPassword	O	String	SelfServicePassword	{}	5	2026-10-03 18:22:12.869698+07	Customer Web Query Password	2026-10-03 18:22:12.869698+07
429	CreateGatewayRouting	REQUEST	Request Format	gatewayGroups	O	String	Gateway Groups	{}	6	2026-10-03 18:22:12.869698+07	Gateway Groups	2026-10-03 18:22:12.869698+07
430	CreateGatewayRouting	REQUEST	Request Format	capacity	O	Integer	LineLimit	{}	7	2026-10-03 18:22:12.869698+07	Concurrent Line Limit	2026-10-03 18:22:12.869698+07
431	CreateGatewayRouting	REQUEST	Request Format	lockType	O	Integer	LockType 0:NoLock 3:Lock All Default:0	{"0": "NoLock", "3": "Lock"}	8	2026-10-03 18:22:12.869698+07	Lock Status	2026-10-03 18:22:12.869698+07
432	CreateGatewayRouting	REQUEST	Request Format	priority	O	Integer	Priority	{}	9	2026-10-03 18:22:12.869698+07	Routing Priority	2026-10-03 18:22:12.869698+07
433	CreateGatewayRouting	REQUEST	Request Format	registerType	O	Integer	RegisterType 0:Static 1:Dynamic 2:Register	{"0": "Static", "1": "Dynamic", "2": "Register"}	10	2026-10-03 18:22:12.869698+07	SIP Register Type	2026-10-03 18:22:12.869698+07
434	CreateGatewayRouting	REQUEST	Request Format	remoteIp	O	String	IP	{}	11	2026-10-03 18:22:12.869698+07	Remote IP Address	2026-10-03 18:22:12.869698+07
435	CreateGatewayRouting	REQUEST	Request Format	rtpForwardType	O	Integer	MediaProxy 0:Auto 1:Enable 2:Disable Default:0	{"0": "Auto", "1": "Enable", "2": "Disable"}	12	2026-10-03 18:22:12.869698+07	Media Proxy / RTP Forward	2026-10-03 18:22:12.869698+07
436	CreateGatewayRouting	REQUEST	Request Format	encrypt	O	Boolean	true:Encrypt false:NoEncrypt	{"true": "Encrypt", "false": "NoEncrypt"}	13	2026-10-03 18:22:12.869698+07	Encryption Enabled	2026-10-03 18:22:12.869698+07
437	CreateGatewayRouting	REQUEST	Request Format	protocol	O	Integer	Protocol 0:H323 1:SIP	{"0": "H323", "1": "SIP"}	14	2026-10-03 18:22:12.869698+07	Signaling Protocol (1: SIP, 2: H.323)	2026-10-03 18:22:12.869698+07
438	CreateGatewayRouting	REQUEST	Request Format	signalPort	O	Integer	Signaling Port H323Default:1720 SIPDefault:5060	{}	15	2026-10-03 18:22:12.869698+07	Signaling Port Number	2026-10-03 18:22:12.869698+07
439	CreateGatewayRouting	REQUEST	Request Format	localIp	O	String	LocalIP Blank:Auto	{}	16	2026-10-03 18:22:12.869698+07	Local IP	2026-10-03 18:22:12.869698+07
440	CreateGatewayRouting	REQUEST	Request Format	mediaCheckDirection	O	Integer	RTP Interrupt Detection Mode 0:NoDetect 1: Detect whether VOS has sentRTPto Remote 2: Detect whether VOS has received RemoteRTP 3:DetectBothSide'sRTP Default:0	{"0": "NoDetect", "1": "", "2": "", "3": "DetectBothSide'sRTP"}	17	2026-10-03 18:22:12.869698+07	Media Check Direction	2026-10-03 18:22:12.869698+07
441	CreateGatewayRouting	REQUEST	Request Format	maxCallDurationLower	O	Integer	-1:UseSystem Parameter 0:Nolimit	{"0": "Nolimit", "-1": "UseSystem"}	18	2026-10-03 18:22:12.869698+07	Max Call Duration Lower	2026-10-03 18:22:12.869698+07
442	CreateGatewayRouting	REQUEST	Request Format	maxCallDurationUpper	O	Integer	-1:UseSystem Parameter 0:Nolimit	{"0": "Nolimit", "-1": "UseSystem"}	19	2026-10-03 18:22:12.869698+07	Max Call Duration Upper	2026-10-03 18:22:12.869698+07
443	CreateGatewayRouting	REQUEST	Request Format	calleeE164Restrict	O	Integer	Callee Limit 0:NoLimit 1:LimitCalleeisPhone 2:LimitCalleenotPhone	{"0": "NoLimit", "1": "LimitCalleeisPhone", "2": "LimitCalleenotPhone"}	20	2026-10-03 18:22:12.869698+07	Callee E.164 Restrict	2026-10-03 18:22:12.869698+07
444	CreateGatewayRouting	REQUEST	Request Format	callerE164CheckEnable	O	Boolean	true:EnableCallerCheck false:DisableCaller Check	{"true": "EnableCallerCheck", "false": "DisableCaller"}	21	2026-10-03 18:22:12.869698+07	Caller E.164 Check Enable	2026-10-03 18:22:12.869698+07
445	CreateGatewayRouting	REQUEST	Request Format	callerE164CheckCity	O	Boolean	true:EnableCallerCity Check false:DisableCallerCity Check	{"true": "EnableCallerCity", "false": "DisableCallerCity"}	22	2026-10-03 18:22:12.869698+07	Caller E.164 Check City	2026-10-03 18:22:12.869698+07
446	CreateGatewayRouting	REQUEST	Request Format	callerE164CheckMobile	O	Boolean	true:EnableCallerMobile Check false: Disable Caller Mobile Check	{"true": "EnableCallerMobile", "false": ""}	23	2026-10-03 18:22:12.869698+07	Caller E.164 Check Mobile	2026-10-03 18:22:12.869698+07
447	CreateGatewayRouting	REQUEST	Request Format	callerE164CheckOther	O	Boolean	true:EnableCallerOther Check false: Disable Caller Other Check	{"true": "EnableCallerOther", "false": ""}	24	2026-10-03 18:22:12.869698+07	Caller E.164 Check Other	2026-10-03 18:22:12.869698+07
448	CreateGatewayRouting	REQUEST	Request Format	calleeE164CheckEnable	O	Boolean	true:EnableCallee Check false:DisableCallee Check	{"true": "EnableCallee", "false": "DisableCallee"}	25	2026-10-03 18:22:12.869698+07	Callee E.164 Check Enable	2026-10-03 18:22:12.869698+07
449	CreateGatewayRouting	REQUEST	Request Format	calleeE164CheckCity	O	Boolean	true:EnableCallee City Check false:DisableCalleeCity Check	{"true": "EnableCallee", "false": "DisableCalleeCity"}	26	2026-10-03 18:22:12.869698+07	Callee E.164 Check City	2026-10-03 18:22:12.869698+07
450	CreateGatewayRouting	REQUEST	Request Format	calleeE164CheckMobile	O	Boolean	true:EnableCallee Mobile Check false: Disable Callee Mobile Check	{"true": "EnableCallee", "false": ""}	27	2026-10-03 18:22:12.869698+07	Callee E.164 Check Mobile	2026-10-03 18:22:12.869698+07
451	CreateGatewayRouting	REQUEST	Request Format	calleeE164CheckOther	O	Boolean	true:EnableCallee Other Check false: Disable Callee Other Check	{"true": "EnableCallee", "false": ""}	28	2026-10-03 18:22:12.869698+07	Callee E.164 Check Other	2026-10-03 18:22:12.869698+07
452	CreateGatewayRouting	REQUEST	Request Format	callinCallerPrefixesAllow	O	Boolean	true:Enable callinCallerPrefixes false:Disable callinCallerPrefixes	{"true": "Enable", "false": "Disable"}	29	2026-10-03 18:22:12.869698+07	Callin Caller Prefixes Allow	2026-10-03 18:22:12.869698+07
453	CreateGatewayRouting	REQUEST	Request Format	callinCallerPrefixes	O	String	CallerPrefixesList	{}	30	2026-10-03 18:22:12.869698+07	Callin Caller Prefixes	2026-10-03 18:22:12.869698+07
454	CreateGatewayRouting	REQUEST	Request Format	callinCalleePrefixesAllow	O	Boolean	true:Enable callinCalleePrefixes false:Disable callinCalleePrefixes	{"true": "Enable", "false": "Disable"}	31	2026-10-03 18:22:12.869698+07	Callin Callee Prefixes Allow	2026-10-03 18:22:12.869698+07
455	CreateGatewayRouting	REQUEST	Request Format	callinCalleePrefixes	O	String	Callee Prefixes List	{}	32	2026-10-03 18:22:12.869698+07	Callin Callee Prefixes	2026-10-03 18:22:12.869698+07
456	CreateGatewayRouting	REQUEST	Request Format	callinForwardPrefixesAllow	O	Boolean	true: Enable callinForwardPrefixes settings false: Disable callinForwardPrefixes settings	{"true": "", "false": ""}	33	2026-10-03 18:22:12.869698+07	Callin Forward Prefixes Allow	2026-10-03 18:22:12.869698+07
457	CreateGatewayRouting	REQUEST	Request Format	callinForwardPrefixes	O	String	Call in forward prefixes settings	{}	34	2026-10-03 18:22:12.869698+07	Callin Forward Prefixes	2026-10-03 18:22:12.869698+07
458	CreateGatewayRouting	REQUEST	Request Format	rewriteRulesInCaller	O	String	CallerRewrite Rule	{}	35	2026-10-03 18:22:12.869698+07	Rewrite Rules In Caller	2026-10-03 18:22:12.869698+07
459	CreateGatewayRouting	REQUEST	Request Format	rewriteRulesInCallee	O	String	Callee RewriteRule	{}	36	2026-10-03 18:22:12.869698+07	Rewrite Rules In Callee	2026-10-03 18:22:12.869698+07
460	CreateGatewayRouting	REQUEST	Request Format	rewriteRulesInMobileAreaAllow	O	Boolean	true:Enable rewriteRulesInMobileArea false:Disable rewriteRulesInMobileArea	{"true": "Enable", "false": "Disable"}	37	2026-10-03 18:22:12.869698+07	Rewrite Rules In Mobile Area Allow	2026-10-03 18:22:12.869698+07
461	CreateGatewayRouting	REQUEST	Request Format	rewriteRulesInMobileArea	O	String	MobileAreaRewrite Rules Settings,separate by comma	{}	38	2026-10-03 18:22:12.869698+07	Rewrite Rules In Mobile Area	2026-10-03 18:22:12.869698+07
462	CreateGatewayRouting	REQUEST	Request Format	timeoutSetup	O	Integer	H323 Setup Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	39	2026-10-03 18:22:12.869698+07	Timeout Setup	2026-10-03 18:22:12.869698+07
463	CreateGatewayRouting	REQUEST	Request Format	timeoutCallProceeding	O	Integer	H323CallProceeding Timeout(Unit:Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	40	2026-10-03 18:22:12.869698+07	Timeout Call Proceeding	2026-10-03 18:22:12.869698+07
464	CreateGatewayRouting	REQUEST	Request Format	timeoutCallProceedingOlc	O	Integer	H323CallProceeding include Open Logical Channel Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	41	2026-10-03 18:22:12.869698+07	Timeout Call Proceeding Olc	2026-10-03 18:22:12.869698+07
465	CreateGatewayRouting	REQUEST	Request Format	timeoutAlerting	O	Integer	H323Alerting Timeout(Unit:Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	42	2026-10-03 18:22:12.869698+07	Timeout Alerting	2026-10-03 18:22:12.869698+07
466	CreateGatewayRouting	REQUEST	Request Format	timeoutInvite	O	Integer	SIP Invite Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	43	2026-10-03 18:22:12.869698+07	Timeout Invite	2026-10-03 18:22:12.869698+07
467	CreateGatewayRouting	REQUEST	Request Format	timeoutTrying	O	Integer	SIP Trying Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	44	2026-10-03 18:22:12.869698+07	Timeout Trying	2026-10-03 18:22:12.869698+07
468	CreateGatewayRouting	REQUEST	Request Format	timeoutSessionProgressSdp	O	Integer	SIPSessionProgress include SDP Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	45	2026-10-03 18:22:12.869698+07	Timeout Session Progress Sdp	2026-10-03 18:22:12.869698+07
469	CreateGatewayRouting	REQUEST	Request Format	timeoutSessionProgress	O	Integer	SIPSessionProgress Timeout(Unit:Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	46	2026-10-03 18:22:12.869698+07	Timeout Session Progress	2026-10-03 18:22:12.869698+07
470	CreateGatewayRouting	REQUEST	Request Format	timeoutRinging	O	Integer	SIP Ring Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	47	2026-10-03 18:22:12.869698+07	Timeout Ringing	2026-10-03 18:22:12.869698+07
471	CreateGatewayRouting	REQUEST	Request Format	denyCallerCalleeAllow	O	Boolean	true:Enable denyCallerCallee false:Disable denyCallerCallee	{"true": "Enable", "false": "Disable"}	48	2026-10-03 18:22:12.869698+07	Deny Caller Callee Allow	2026-10-03 18:22:12.869698+07
472	CreateGatewayRouting	REQUEST	Request Format	denyCallerCallee	O	String	Format: [<Caller>: <Callee>[,<Caller>: <Callee>]…] e.g.:025:010,021:023	{}	49	2026-10-03 18:22:12.869698+07	Deny Caller Callee	2026-10-03 18:22:12.869698+07
473	CreateGatewayRouting	REQUEST	Request Format	denySameCityCodesAllow	O	Boolean	true:Enable denySameCityCodes Setting false:Disable denySameCityCodes Setting	{"true": "Enable", "false": "Disable"}	50	2026-10-03 18:22:12.869698+07	Deny Same City Codes Allow	2026-10-03 18:22:12.869698+07
474	CreateGatewayRouting	REQUEST	Request Format	denySameCityCodes	O	String	Deny Same City Codes Settings,use commato separate	{}	51	2026-10-03 18:22:12.869698+07	Deny Same City Codes	2026-10-03 18:22:12.869698+07
769	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	localIp	M	String	RegisterIP	{}	15	2026-10-03 18:22:12.869698+07	Local IP	2026-10-03 18:22:12.869698+07
475	CreateGatewayRouting	REQUEST	Request Format	checkMobileAreaAllow	O	Boolean	true:Enable checkMobileAreaSettings false:Disable checkMobileArea Settings	{"true": "Enable", "false": "Disable"}	52	2026-10-03 18:22:12.869698+07	Check Mobile Area Allow	2026-10-03 18:22:12.869698+07
476	CreateGatewayRouting	REQUEST	Request Format	checkMobileArea	O	String	Mobile Area Settings, use commato separate	{}	53	2026-10-03 18:22:12.869698+07	Check Mobile Area	2026-10-03 18:22:12.869698+07
477	CreateGatewayRouting	REQUEST	Request Format	stopSwitchAfterOlc	O	Integer	Stop Switch Gateway After Open LogicalChannel 0:UseSystemParameter 1:Disable 2:Enable Default:0	{"0": "UseSystemParameter", "1": "Disable", "2": "Enable"}	54	2026-10-03 18:22:12.869698+07	Stop Switch After Olc	2026-10-03 18:22:12.869698+07
478	CreateGatewayRouting	REQUEST	Request Format	stopSwitchAfterSdp	O	Integer	Stop Switch Gateway After ReceivedSDP 0:UseSystemParameter 1:Disable 2:Enable Default:0	{"0": "UseSystemParameter", "1": "Disable", "2": "Enable"}	55	2026-10-03 18:22:12.869698+07	Stop Switch After Sdp	2026-10-03 18:22:12.869698+07
479	CreateGatewayRouting	REQUEST	Request Format	stopSwitchAfterRtpStart	O	Integer	Stop Switch Gateway After ReceivedRTP 0:UseSystemParameter 1:Disable 2:Enable Default:0	{"0": "UseSystemParameter", "1": "Disable", "2": "Enable"}	56	2026-10-03 18:22:12.869698+07	Stop Switch After RTP Start	2026-10-03 18:22:12.869698+07
480	CreateGatewayRouting	REQUEST	Request Format	stopSwitchAfterUserBusy	O	Integer	Stop Switch Gateway After ReceivedUserBusy 0:UseSystemParameter 1:Disable 2:Enable Default:0	{"0": "UseSystemParameter", "1": "Disable", "2": "Enable"}	57	2026-10-03 18:22:12.869698+07	Stop Switch After User Busy	2026-10-03 18:22:12.869698+07
481	CreateGatewayRouting	REQUEST	Request Format	switchUntilConnect	O	Integer	SwitchGateway Until Connect 0:UseSystemParameter 1:Disable 2:Enable Default:0	{"0": "UseSystemParameter", "1": "Disable", "2": "Enable"}	58	2026-10-03 18:22:12.869698+07	Switch Until Connect	2026-10-03 18:22:12.869698+07
482	CreateGatewayRouting	REQUEST	Request Format	sipResponseAddressMethod	O	Integer	SIPResponseAddress 0:ResponsetoRequest Address 1: Response to Request IP useportfromVia	{"0": "ResponsetoRequest", "1": ""}	59	2026-10-03 18:22:12.869698+07	SIP Response Address Method	2026-10-03 18:22:12.869698+07
483	CreateGatewayRouting	REQUEST	Request Format	sipRequestAddressMethod	O	Integer	SIPRequestAddress 0:ToOriginal Address 1: To Original IP and Port from Contact 2:ToContact	{"0": "ToOriginal", "1": "", "2": "ToContact"}	60	2026-10-03 18:22:12.869698+07	SIP Request Address Method	2026-10-03 18:22:12.869698+07
484	CreateGatewayRouting	REQUEST	Request Format	dtmfSendMethodH323	O	Integer	0:Auto 10:RFC2833 20:H.245 alphanumeric 30:H.245 signal 40:Q.931 keypad 60:Off	{"0": "Auto", "10": "RFC2833", "20": "H.245", "30": "H.245", "40": "Q.931", "60": "Off"}	61	2026-10-03 18:22:12.869698+07	DTMF Send Method (H.323)	2026-10-03 18:22:12.869698+07
485	CreateGatewayRouting	REQUEST	Request Format	dtmfSendMethodSIP	O	Integer	0:Auto 10:RFC2833 50:SIP Info 60:Off	{"0": "Auto", "10": "RFC2833", "50": "SIP", "60": "Off"}	62	2026-10-03 18:22:12.869698+07	DTMF Send Method (SIP)	2026-10-03 18:22:12.869698+07
486	CreateGatewayRouting	REQUEST	Request Format	dtmfReceiveMethod	O	Integer	0:All 10:RFC2833 20:Signaling 30:Off	{"0": "All", "10": "RFC2833", "20": "Signaling", "30": "Off"}	63	2026-10-03 18:22:12.869698+07	DTMF Receive Method	2026-10-03 18:22:12.869698+07
487	CreateGatewayRouting	REQUEST	Request Format	dtmfSendPayloadTypeH323	O	Integer	Payload Type for H323 DTMFSend	{}	64	2026-10-03 18:22:12.869698+07	DTMF Send Payload Type (H.323)	2026-10-03 18:22:12.869698+07
488	CreateGatewayRouting	REQUEST	Request Format	dtmfSendPayloadTypeSIP	O	Integer	PayloadType forSIP DTMF Send	{}	65	2026-10-03 18:22:12.869698+07	DTMF Send Payload Type (SIP)	2026-10-03 18:22:12.869698+07
489	CreateGatewayRouting	REQUEST	Request Format	dtmfReceivePayloadType	O	Integer	Payload Type for DTMF Receive	{}	66	2026-10-03 18:22:12.869698+07	DTMF Receive Payload Type	2026-10-03 18:22:12.869698+07
490	CreateGatewayRouting	REQUEST	Request Format	q931NumberingPlan	O	Integer	Q931NumberingPlan -1:UseSystem Parameter 0:UnknownPlan 1:ISDNPlan 3:DataPlan 4:TelexPlan 8:NationalStandardPlan 9:PrivatePlan 15:ReservedPlan	{"0": "UnknownPlan", "1": "ISDNPlan", "3": "DataPlan", "4": "TelexPlan", "8": "NationalStandardPlan", "-1": "UseSystem"}	67	2026-10-03 18:22:12.869698+07	Q931 Numbering Plan	2026-10-03 18:22:12.869698+07
520	CreateGatewayRouting	REQUEST	Request Format	sipCodecAssign	O	Boolean	true:Assign SIPCodecs false:AutoNegotiation	{"true": "Assign", "false": "AutoNegotiation"}	97	2026-10-03 18:22:12.869698+07	SIP Codec Assign	2026-10-03 18:22:12.869698+07
491	CreateGatewayRouting	REQUEST	Request Format	q931NumberType	O	Integer	Q931NumberType -1:UseSystem Parameter 0:UnknownType 1:InternationalType 2:NationalType 3:NetworkSpecificType 4:SubscriberType 6:AbbreviatedType 7:ReservedType	{"0": "UnknownType", "1": "InternationalType", "2": "NationalType", "3": "NetworkSpecificType", "4": "SubscriberType", "6": "AbbreviatedType", "-1": "UseSystem"}	68	2026-10-03 18:22:12.869698+07	Q931 Number Type	2026-10-03 18:22:12.869698+07
492	CreateGatewayRouting	REQUEST	Request Format	q931PresentationIndicator	O	Integer	Q931PresentationIndicator -1:UseSystem Parameter 0:Presentationallowed 1:Presentationrestricted 2: Number not available due tointerworking 3:Reserved 4:None	{"0": "Presentationallowed", "1": "Presentationrestricted", "2": "", "3": "Reserved", "4": "None", "-1": "UseSystem"}	69	2026-10-03 18:22:12.869698+07	Q931 Presentation Indicator	2026-10-03 18:22:12.869698+07
493	CreateGatewayRouting	REQUEST	Request Format	q931ScreeningIndicator	O	Integer	Q931ScreeningIndicator -1:UseSystem Parameter 0:User-provided,not screened 1:User-provided,verified andpassed 2:User-provided,verified and failed 3:Network provided 4:None	{"0": "User-provided,not", "1": "User-provided,verified", "2": "User-provided,verified", "3": "Network", "4": "None", "-1": "UseSystem"}	70	2026-10-03 18:22:12.869698+07	Q931 Screening Indicator	2026-10-03 18:22:12.869698+07
494	CreateGatewayRouting	REQUEST	Request Format	clearingAccount	O	String	Clearing AccountName	{}	71	2026-10-03 18:22:12.869698+07	Clearing Account	2026-10-03 18:22:12.869698+07
495	CreateGatewayRouting	REQUEST	Request Format	h323FastStart	O	Boolean	true:EnableH323 faststart false:DisableH323fast start	{"true": "EnableH323", "false": "DisableH323fast"}	72	2026-10-03 18:22:12.869698+07	H.323 Fast Start	2026-10-03 18:22:12.869698+07
496	CreateGatewayRouting	REQUEST	Request Format	h323H245Tunneling	O	Boolean	true: Enable H323 H245 tunneling false: Disable H323 H245 tunneling	{"true": "", "false": ""}	73	2026-10-03 18:22:12.869698+07	H.323 H245 Tunneling	2026-10-03 18:22:12.869698+07
497	CreateGatewayRouting	REQUEST	Request Format	h323H245InSetup	O	Boolean	true: Enable H323 H245 in Setup false: Disable H323 H245 in Setup	{"true": "", "false": ""}	74	2026-10-03 18:22:12.869698+07	H.323 H245 In Setup	2026-10-03 18:22:12.869698+07
498	CreateGatewayRouting	REQUEST	Request Format	h323T38	O	Boolean	true:EnableH323 T38 false:DisableH323T38	{"true": "EnableH323", "false": "DisableH323T38"}	75	2026-10-03 18:22:12.869698+07	H.323 T38	2026-10-03 18:22:12.869698+07
499	CreateGatewayRouting	REQUEST	Request Format	sipTimer	O	Boolean	true: Enable SIP Timer (RFC4028) false:DiableSIPTimer	{"true": "", "false": "DiableSIPTimer"}	76	2026-10-03 18:22:12.869698+07	SIP Timer	2026-10-03 18:22:12.869698+07
500	CreateGatewayRouting	REQUEST	Request Format	sip100Rel	O	Boolean	true:EnableSIP 100rel false:DisableSIP100rel	{"true": "EnableSIP", "false": "DisableSIP100rel"}	77	2026-10-03 18:22:12.869698+07	SIP100 Rel	2026-10-03 18:22:12.869698+07
501	CreateGatewayRouting	REQUEST	Request Format	sipT38	O	Boolean	true:EnableSIP T38 false:DisableSIPT38	{"true": "EnableSIP", "false": "DisableSIPT38"}	78	2026-10-03 18:22:12.869698+07	SIP T38	2026-10-03 18:22:12.869698+07
813	GetCdr	REQUEST	Request Format	callerE164	O	String	Caller	{}	2	2026-10-03 18:22:12.869698+07	Caller Number	2026-10-03 18:22:12.869698+07
502	CreateGatewayRouting	REQUEST	Request Format	sipDisplay	O	Boolean	true:IncludeDisplay false:ExcludeDisplay	{"true": "IncludeDisplay", "false": "ExcludeDisplay"}	79	2026-10-03 18:22:12.869698+07	SIP Display	2026-10-03 18:22:12.869698+07
503	CreateGatewayRouting	REQUEST	Request Format	sipRemotePartyId	O	Boolean	true:Include RemotePartyId false:Exclude RemotePartyId	{"true": "Include", "false": "Exclude"}	80	2026-10-03 18:22:12.869698+07	SIP Remote Party ID	2026-10-03 18:22:12.869698+07
504	CreateGatewayRouting	REQUEST	Request Format	sipPrivacy	O	Integer	0:None 1:Passthrough 2:id	{"0": "None", "1": "Passthrough", "2": "id"}	81	2026-10-03 18:22:12.869698+07	SIP Privacy	2026-10-03 18:22:12.869698+07
505	CreateGatewayRouting	REQUEST	Request Format	sipPPreferredIdentity	O	Integer	0:None 1:Passthrough 2:Callernumber	{"0": "None", "1": "Passthrough", "2": "Callernumber"}	82	2026-10-03 18:22:12.869698+07	SIP Ppreferred IDentity	2026-10-03 18:22:12.869698+07
506	CreateGatewayRouting	REQUEST	Request Format	sipPAssertedIdentity	O	Integer	0:None 1:Passthrough 2:Callernumber	{"0": "None", "1": "Passthrough", "2": "Callernumber"}	83	2026-10-03 18:22:12.869698+07	SIP Passerted IDentity	2026-10-03 18:22:12.869698+07
507	CreateGatewayRouting	REQUEST	Request Format	groupE164Change	O	Boolean	true: Enable Group E164 Change false: Disable Group E164 Change	{"true": "", "false": ""}	84	2026-10-03 18:22:12.869698+07	Group E.164 Change	2026-10-03 18:22:12.869698+07
508	CreateGatewayRouting	REQUEST	Request Format	callerAllowLength	O	Integer	MaskofCallerAllow Length 0:AllowAll Length 1<<x:Allow Length isx (x<32)	{"0": "AllowAll"}	85	2026-10-03 18:22:12.869698+07	Caller Allow Length	2026-10-03 18:22:12.869698+07
509	CreateGatewayRouting	REQUEST	Request Format	calleeAllowLength	O	Integer	MaskofCalleeAllow Length 0:AllowAll Length 1<<x:Allow Length isx (x<32)	{"0": "AllowAll"}	86	2026-10-03 18:22:12.869698+07	Callee Allow Length	2026-10-03 18:22:12.869698+07
510	CreateGatewayRouting	REQUEST	Request Format	callerLimitE164GroupsAllow	O	Boolean	true:Allow callerLimitE164Groups false:Forbidden callerLimitE164Groups	{"true": "Allow", "false": "Forbidden"}	87	2026-10-03 18:22:12.869698+07	Caller Limit E.164 Groups Allow	2026-10-03 18:22:12.869698+07
511	CreateGatewayRouting	REQUEST	Request Format	callerLimitE164Groups	O	String	Caller List, separate by comma	{}	88	2026-10-03 18:22:12.869698+07	Caller Limit E.164 Groups	2026-10-03 18:22:12.869698+07
512	CreateGatewayRouting	REQUEST	Request Format	calleeLimitE164GroupsAllow	O	Boolean	true:Allow calleeLimitE164Groups false:Forbidden calleeLimitE164Groups	{"true": "Allow", "false": "Forbidden"}	89	2026-10-03 18:22:12.869698+07	Callee Limit E.164 Groups Allow	2026-10-03 18:22:12.869698+07
513	CreateGatewayRouting	REQUEST	Request Format	calleeLimitE164Groups	O	String	Callee List, separate by comma	{}	90	2026-10-03 18:22:12.869698+07	Callee Limit E.164 Groups	2026-10-03 18:22:12.869698+07
514	CreateGatewayRouting	REQUEST	Request Format	h323G729SendMode	O	Integer	H323 G729 Negotiation Mode 0: Auto, keep original G729 codec 1: G729, treat G729a or G729 as G729 2: G729a, treat G729a or G729 as G729a 3: G729&G729a,treat G729 or G729a as G729 and G729a	{"0": "", "1": "", "2": "", "3": ""}	91	2026-10-03 18:22:12.869698+07	H.323 G729 Send Mode	2026-10-03 18:22:12.869698+07
515	CreateGatewayRouting	REQUEST	Request Format	sipG729SendMode	O	Integer	SIPG729 Negotiation Mode 0: Auto, keep original G729 codec 1: G729, treat G729a or G729 as G729 2: G729a, treat G729a or G729 as G729a 3: G729&G729a,treat G729 or G729a as G729 and G729a	{"0": "", "1": "", "2": "", "3": ""}	92	2026-10-03 18:22:12.869698+07	SIP G729 Send Mode	2026-10-03 18:22:12.869698+07
516	CreateGatewayRouting	REQUEST	Request Format	sipG729Annexb	O	Integer	G729 annexb 0:Auto 1:annex=yes 2:annex=no 3:noannex 4:transmitannex	{"0": "Auto", "1": "annex=yes", "2": "annex=no", "3": "noannex", "4": "transmitannex"}	93	2026-10-03 18:22:12.869698+07	SIP G729 Annexb	2026-10-03 18:22:12.869698+07
517	CreateGatewayRouting	REQUEST	Request Format	sipG723Annexa	O	Integer	G723 annexa 0:Auto 1:annex=yes 2:annex=no 3:noannex 4:transmitannex	{"0": "Auto", "1": "annex=yes", "2": "annex=no", "3": "noannex", "4": "transmitannex"}	94	2026-10-03 18:22:12.869698+07	SIP G723 Annexa	2026-10-03 18:22:12.869698+07
518	CreateGatewayRouting	REQUEST	Request Format	h323CodecAssign	O	Boolean	true:Assign H323Codecs false:AutoNegotiation	{"true": "Assign", "false": "AutoNegotiation"}	95	2026-10-03 18:22:12.869698+07	H.323 Codec Assign	2026-10-03 18:22:12.869698+07
519	CreateGatewayRouting	REQUEST	Request Format	h323Codecs	O	Vector<String>	H323CodecList	{}	96	2026-10-03 18:22:12.869698+07	H.323 Codecs	2026-10-03 18:22:12.869698+07
521	CreateGatewayRouting	REQUEST	Request Format	sipCodecs	O	Vector<String>	SIPCodec List	{}	98	2026-10-03 18:22:12.869698+07	SIP Codecs	2026-10-03 18:22:12.869698+07
522	CreateGatewayRouting	REQUEST	Request Format	feerateRestrict	O	Boolean	true: Check Callee Fee Rate false:NoCheck	{"true": "", "false": "NoCheck"}	99	2026-10-03 18:22:12.869698+07	Feerate Restrict	2026-10-03 18:22:12.869698+07
523	CreateGatewayRouting	REQUEST	Request Format	leastCostRouting	O	Boolean	(feerateRestrict must be true) true:On false:Off	{"true": "On", "false": "Off"}	100	2026-10-03 18:22:12.869698+07	Least Cost Routing	2026-10-03 18:22:12.869698+07
524	CreateGatewayRouting	REQUEST	Request Format	minProfitPercentEnable	O	Boolean	EnableMinProfitPercent	{}	101	2026-10-03 18:22:12.869698+07	Min Profit Percent Enable	2026-10-03 18:22:12.869698+07
525	CreateGatewayRouting	REQUEST	Request Format	minProfitPercent	O	Integer	Min ProfitRate e.g.10means 10% Range:-10000to 10000	{}	102	2026-10-03 18:22:12.869698+07	Min Profit Percent	2026-10-03 18:22:12.869698+07
526	CreateGatewayRouting	REQUEST	Request Format	maxSecondRatesEnable	O	Boolean	EnableMax Second Rate	{}	103	2026-10-03 18:22:12.869698+07	Max Second Rates Enable	2026-10-03 18:22:12.869698+07
527	CreateGatewayRouting	REQUEST	Request Format	maxSecondRates	O	Integer	MaxSecondRates e.g. if minute rate is 0.6, set this valueas 0.01	{}	104	2026-10-03 18:22:12.869698+07	Max Second Rates	2026-10-03 18:22:12.869698+07
528	CreateGatewayRouting	REQUEST	Request Format	enablePhoneDisplay	O	Boolean	true: Use phone display numberas caller false: Use phone number as caller clearingAccountUseCallout	{"true": "", "false": ""}	105	2026-10-03 18:22:12.869698+07	Enable Phone Display	2026-10-03 18:22:12.869698+07
529	CreateGatewayRouting	REQUEST	Request Format	E164	O	Boolean	true: Use Callee after rewriteas Clearing Account false:UseCalleebefore rewriteas Clearing Account	{"true": "", "false": "UseCalleebefore"}	106	2026-10-03 18:22:12.869698+07	E.164	2026-10-03 18:22:12.869698+07
530	CreateGatewayRouting	REQUEST	Request Format	softswitchName	O	String	SoftSwitchName	{}	107	2026-10-03 18:22:12.869698+07	VOS Softswitch Name	2026-10-03 18:22:12.869698+07
531	CreateGatewayRouting	REQUEST	Request Format	forwardSignalRewriteE164GroupEnable	O	Boolean	true:EnableForward SignalRewrite false:DisableForward SignalRewrite	{"true": "EnableForward", "false": "DisableForward"}	108	2026-10-03 18:22:12.869698+07	Forward Signal Rewrite E.164 Group Enable	2026-10-03 18:22:12.869698+07
532	CreateGatewayRouting	REQUEST	Request Format	forwardSignalRewriteE164Group	O	String	Forward SignalRewrite E164Group	{}	109	2026-10-03 18:22:12.869698+07	Forward Signal Rewrite E.164 Group	2026-10-03 18:22:12.869698+07
533	CreateGatewayRouting	RESPONSE	Response Format	retCode	M	Integer	ResponseCode	{}	110	2026-10-03 18:22:12.869698+07	Return Code Status	2026-10-03 18:22:12.869698+07
534	CreateGatewayRouting	RESPONSE	Response Format	exception	O	String	ErrorInformation	{}	111	2026-10-03 18:22:12.869698+07	Error Information	2026-10-03 18:22:12.869698+07
535	ModifyGatewayRouting	REQUEST	Request Format	name	M	String	RoutingGateway Name	{}	1	2026-10-03 18:22:12.869698+07	Gateway Name	2026-10-03 18:22:12.869698+07
536	ModifyGatewayRouting	REQUEST	Request Format	prefix	O	String	Gateway Prefix	{}	2	2026-10-03 18:22:12.869698+07	Gateway Prefix	2026-10-03 18:22:12.869698+07
814	GetCdr	REQUEST	Request Format	calleeE164	O	String	Callee	{}	3	2026-10-03 18:22:12.869698+07	Callee Number	2026-10-03 18:22:12.869698+07
537	ModifyGatewayRouting	REQUEST	Request Format	prefixStyle	O	Integer	PrefixMode 0:Terminal 1:Continual	{"0": "Terminal", "1": "Continual"}	3	2026-10-03 18:22:12.869698+07	Prefix Style (0: Terminal, 1: Continual)	2026-10-03 18:22:12.869698+07
538	ModifyGatewayRouting	REQUEST	Request Format	password	O	String	Gateway Password Default:Random Create	{}	4	2026-10-03 18:22:12.869698+07	SIP Register Password	2026-10-03 18:22:12.869698+07
539	ModifyGatewayRouting	REQUEST	Request Format	customerPassword	O	String	SelfServicePassword	{}	5	2026-10-03 18:22:12.869698+07	Customer Web Query Password	2026-10-03 18:22:12.869698+07
540	ModifyGatewayRouting	REQUEST	Request Format	gatewayGroups	O	String	Gateway Groups	{}	6	2026-10-03 18:22:12.869698+07	Gateway Groups	2026-10-03 18:22:12.869698+07
541	ModifyGatewayRouting	REQUEST	Request Format	capacity	O	Integer	LineLimit	{}	7	2026-10-03 18:22:12.869698+07	Concurrent Line Limit	2026-10-03 18:22:12.869698+07
542	ModifyGatewayRouting	REQUEST	Request Format	lockType	O	Integer	LockType 0:NoLock 3:Lock All Default:0	{"0": "NoLock", "3": "Lock"}	8	2026-10-03 18:22:12.869698+07	Lock Status	2026-10-03 18:22:12.869698+07
543	ModifyGatewayRouting	REQUEST	Request Format	priority	O	Integer	Priority	{}	9	2026-10-03 18:22:12.869698+07	Routing Priority	2026-10-03 18:22:12.869698+07
544	ModifyGatewayRouting	REQUEST	Request Format	registerType	O	Integer	RegisterType 0:Static 1:Dynamic 2:Register	{"0": "Static", "1": "Dynamic", "2": "Register"}	10	2026-10-03 18:22:12.869698+07	SIP Register Type	2026-10-03 18:22:12.869698+07
545	ModifyGatewayRouting	REQUEST	Request Format	remoteIp	O	String	IP	{}	11	2026-10-03 18:22:12.869698+07	Remote IP Address	2026-10-03 18:22:12.869698+07
546	ModifyGatewayRouting	REQUEST	Request Format	rtpForwardType	O	Integer	MediaProxy 0:Auto 1:Enable 2:Disable Default:0	{"0": "Auto", "1": "Enable", "2": "Disable"}	12	2026-10-03 18:22:12.869698+07	Media Proxy / RTP Forward	2026-10-03 18:22:12.869698+07
547	ModifyGatewayRouting	REQUEST	Request Format	encrypt	O	Boolean	true:Encrypt false:NoEncrypt	{"true": "Encrypt", "false": "NoEncrypt"}	13	2026-10-03 18:22:12.869698+07	Encryption Enabled	2026-10-03 18:22:12.869698+07
548	ModifyGatewayRouting	REQUEST	Request Format	protocol	O	Integer	Protocol 0:H323 1:SIP	{"0": "H323", "1": "SIP"}	14	2026-10-03 18:22:12.869698+07	Signaling Protocol (1: SIP, 2: H.323)	2026-10-03 18:22:12.869698+07
549	ModifyGatewayRouting	REQUEST	Request Format	signalPort	O	Integer	Signaling Port H323Default:1720 SIPDefault:5060	{}	15	2026-10-03 18:22:12.869698+07	Signaling Port Number	2026-10-03 18:22:12.869698+07
550	ModifyGatewayRouting	REQUEST	Request Format	localIp	O	String	LocalIP Blank:Auto	{}	16	2026-10-03 18:22:12.869698+07	Local IP	2026-10-03 18:22:12.869698+07
551	ModifyGatewayRouting	REQUEST	Request Format	mediaCheckDirection	O	Integer	RTP Interrupt Detection Mode 0:NoDetect 1: Detect whether VOS has sentRTPto Remote 2: Detect whether VOS has received RemoteRTP 3:DetectBothSide'sRTP Default:0	{"0": "NoDetect", "1": "", "2": "", "3": "DetectBothSide'sRTP"}	17	2026-10-03 18:22:12.869698+07	Media Check Direction	2026-10-03 18:22:12.869698+07
552	ModifyGatewayRouting	REQUEST	Request Format	maxCallDurationLower	O	Integer	-1:UseSystem Parameter 0:Nolimit	{"0": "Nolimit", "-1": "UseSystem"}	18	2026-10-03 18:22:12.869698+07	Max Call Duration Lower	2026-10-03 18:22:12.869698+07
553	ModifyGatewayRouting	REQUEST	Request Format	maxCallDurationUpper	O	Integer	-1:UseSystem Parameter 0:Nolimit	{"0": "Nolimit", "-1": "UseSystem"}	19	2026-10-03 18:22:12.869698+07	Max Call Duration Upper	2026-10-03 18:22:12.869698+07
554	ModifyGatewayRouting	REQUEST	Request Format	calleeE164Restrict	O	Integer	Callee Limit 0:NoLimit 1:LimitCalleeisPhone 2:LimitCalleenotPhone	{"0": "NoLimit", "1": "LimitCalleeisPhone", "2": "LimitCalleenotPhone"}	20	2026-10-03 18:22:12.869698+07	Callee E.164 Restrict	2026-10-03 18:22:12.869698+07
555	ModifyGatewayRouting	REQUEST	Request Format	callerE164CheckEnable	O	Boolean	true:EnableCallerCheck false:DisableCaller Check	{"true": "EnableCallerCheck", "false": "DisableCaller"}	21	2026-10-03 18:22:12.869698+07	Caller E.164 Check Enable	2026-10-03 18:22:12.869698+07
556	ModifyGatewayRouting	REQUEST	Request Format	callerE164CheckCity	O	Boolean	true:EnableCallerCity Check false:DisableCallerCity Check	{"true": "EnableCallerCity", "false": "DisableCallerCity"}	22	2026-10-03 18:22:12.869698+07	Caller E.164 Check City	2026-10-03 18:22:12.869698+07
557	ModifyGatewayRouting	REQUEST	Request Format	callerE164CheckMobile	O	Boolean	true:EnableCallerMobile Check false: Disable Caller Mobile Check	{"true": "EnableCallerMobile", "false": ""}	23	2026-10-03 18:22:12.869698+07	Caller E.164 Check Mobile	2026-10-03 18:22:12.869698+07
558	ModifyGatewayRouting	REQUEST	Request Format	callerE164CheckOther	O	Boolean	true:EnableCallerOther Check false: Disable Caller Other Check	{"true": "EnableCallerOther", "false": ""}	24	2026-10-03 18:22:12.869698+07	Caller E.164 Check Other	2026-10-03 18:22:12.869698+07
559	ModifyGatewayRouting	REQUEST	Request Format	calleeE164CheckEnable	O	Boolean	true:EnableCallee Check false:DisableCallee Check	{"true": "EnableCallee", "false": "DisableCallee"}	25	2026-10-03 18:22:12.869698+07	Callee E.164 Check Enable	2026-10-03 18:22:12.869698+07
560	ModifyGatewayRouting	REQUEST	Request Format	calleeE164CheckCity	O	Boolean	true:EnableCallee City Check false:DisableCalleeCity Check	{"true": "EnableCallee", "false": "DisableCalleeCity"}	26	2026-10-03 18:22:12.869698+07	Callee E.164 Check City	2026-10-03 18:22:12.869698+07
561	ModifyGatewayRouting	REQUEST	Request Format	calleeE164CheckMobile	O	Boolean	true:EnableCallee Mobile Check false: Disable Callee Mobile Check	{"true": "EnableCallee", "false": ""}	27	2026-10-03 18:22:12.869698+07	Callee E.164 Check Mobile	2026-10-03 18:22:12.869698+07
562	ModifyGatewayRouting	REQUEST	Request Format	calleeE164CheckOther	O	Boolean	true:EnableCallee Other Check false: Disable Callee Other Check	{"true": "EnableCallee", "false": ""}	28	2026-10-03 18:22:12.869698+07	Callee E.164 Check Other	2026-10-03 18:22:12.869698+07
563	ModifyGatewayRouting	REQUEST	Request Format	callinCallerPrefixesAllow	O	Boolean	true:Enable callinCallerPrefixes false:Disable callinCallerPrefixes	{"true": "Enable", "false": "Disable"}	29	2026-10-03 18:22:12.869698+07	Callin Caller Prefixes Allow	2026-10-03 18:22:12.869698+07
564	ModifyGatewayRouting	REQUEST	Request Format	callinCallerPrefixes	O	String	CallerPrefixesList	{}	30	2026-10-03 18:22:12.869698+07	Callin Caller Prefixes	2026-10-03 18:22:12.869698+07
565	ModifyGatewayRouting	REQUEST	Request Format	callinCalleePrefixesAllow	O	Boolean	true:Enable callinCalleePrefixes false:Disable callinCalleePrefixes	{"true": "Enable", "false": "Disable"}	31	2026-10-03 18:22:12.869698+07	Callin Callee Prefixes Allow	2026-10-03 18:22:12.869698+07
566	ModifyGatewayRouting	REQUEST	Request Format	callinCalleePrefixes	O	String	Callee Prefixes List	{}	32	2026-10-03 18:22:12.869698+07	Callin Callee Prefixes	2026-10-03 18:22:12.869698+07
567	ModifyGatewayRouting	REQUEST	Request Format	callinForwardPrefixesAllow	O	Boolean	true: Enable callinForwardPrefixes settings false: Disable callinForwardPrefixes settings	{"true": "", "false": ""}	33	2026-10-03 18:22:12.869698+07	Callin Forward Prefixes Allow	2026-10-03 18:22:12.869698+07
568	ModifyGatewayRouting	REQUEST	Request Format	callinForwardPrefixes	O	String	Call in forward prefixes settings	{}	34	2026-10-03 18:22:12.869698+07	Callin Forward Prefixes	2026-10-03 18:22:12.869698+07
569	ModifyGatewayRouting	REQUEST	Request Format	rewriteRulesInCaller	O	String	CallerRewrite Rule	{}	35	2026-10-03 18:22:12.869698+07	Rewrite Rules In Caller	2026-10-03 18:22:12.869698+07
570	ModifyGatewayRouting	REQUEST	Request Format	rewriteRulesInCallee	O	String	Callee RewriteRule	{}	36	2026-10-03 18:22:12.869698+07	Rewrite Rules In Callee	2026-10-03 18:22:12.869698+07
571	ModifyGatewayRouting	REQUEST	Request Format	rewriteRulesInMobileAreaAllow	O	Boolean	true:Enable rewriteRulesInMobileArea false:Disable rewriteRulesInMobileArea	{"true": "Enable", "false": "Disable"}	37	2026-10-03 18:22:12.869698+07	Rewrite Rules In Mobile Area Allow	2026-10-03 18:22:12.869698+07
572	ModifyGatewayRouting	REQUEST	Request Format	rewriteRulesInMobileArea	O	String	MobileAreaRewrite Rules Settings,separate by comma	{}	38	2026-10-03 18:22:12.869698+07	Rewrite Rules In Mobile Area	2026-10-03 18:22:12.869698+07
573	ModifyGatewayRouting	REQUEST	Request Format	timeoutSetup	O	Integer	H323 Setup Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	39	2026-10-03 18:22:12.869698+07	Timeout Setup	2026-10-03 18:22:12.869698+07
574	ModifyGatewayRouting	REQUEST	Request Format	timeoutCallProceeding	O	Integer	H323CallProceeding Timeout(Unit:Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	40	2026-10-03 18:22:12.869698+07	Timeout Call Proceeding	2026-10-03 18:22:12.869698+07
575	ModifyGatewayRouting	REQUEST	Request Format	timeoutCallProceedingOlc	O	Integer	H323CallProceeding include Open Logical Channel Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	41	2026-10-03 18:22:12.869698+07	Timeout Call Proceeding Olc	2026-10-03 18:22:12.869698+07
576	ModifyGatewayRouting	REQUEST	Request Format	timeoutAlerting	O	Integer	H323Alerting Timeout(Unit:Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	42	2026-10-03 18:22:12.869698+07	Timeout Alerting	2026-10-03 18:22:12.869698+07
577	ModifyGatewayRouting	REQUEST	Request Format	timeoutInvite	O	Integer	SIP Invite Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	43	2026-10-03 18:22:12.869698+07	Timeout Invite	2026-10-03 18:22:12.869698+07
578	ModifyGatewayRouting	REQUEST	Request Format	timeoutTrying	O	Integer	SIP Trying Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	44	2026-10-03 18:22:12.869698+07	Timeout Trying	2026-10-03 18:22:12.869698+07
579	ModifyGatewayRouting	REQUEST	Request Format	timeoutSessionProgressSdp	O	Integer	SIPSessionProgress include SDP Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	45	2026-10-03 18:22:12.869698+07	Timeout Session Progress Sdp	2026-10-03 18:22:12.869698+07
580	ModifyGatewayRouting	REQUEST	Request Format	timeoutSessionProgress	O	Integer	SIPSessionProgress Timeout(Unit:Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	46	2026-10-03 18:22:12.869698+07	Timeout Session Progress	2026-10-03 18:22:12.869698+07
581	ModifyGatewayRouting	REQUEST	Request Format	timeoutRinging	O	Integer	SIP Ring Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	47	2026-10-03 18:22:12.869698+07	Timeout Ringing	2026-10-03 18:22:12.869698+07
582	ModifyGatewayRouting	REQUEST	Request Format	denyCallerCalleeAllow	O	Boolean	true:Enable denyCallerCallee false:Disable denyCallerCallee	{"true": "Enable", "false": "Disable"}	48	2026-10-03 18:22:12.869698+07	Deny Caller Callee Allow	2026-10-03 18:22:12.869698+07
583	ModifyGatewayRouting	REQUEST	Request Format	denyCallerCallee	O	String	Format:[<Caller>: <Callee>[,<Caller>: <Callee>]…] e.g.:025:010,021:023	{}	49	2026-10-03 18:22:12.869698+07	Deny Caller Callee	2026-10-03 18:22:12.869698+07
584	ModifyGatewayRouting	REQUEST	Request Format	denySameCityCodesAllow	O	Boolean	true:Enable denySameCityCodes Setting false:Disable denySameCityCodes Setting	{"true": "Enable", "false": "Disable"}	50	2026-10-03 18:22:12.869698+07	Deny Same City Codes Allow	2026-10-03 18:22:12.869698+07
585	ModifyGatewayRouting	REQUEST	Request Format	denySameCityCodes	O	String	Deny Same City Codes Settings,use commato separate	{}	51	2026-10-03 18:22:12.869698+07	Deny Same City Codes	2026-10-03 18:22:12.869698+07
586	ModifyGatewayRouting	REQUEST	Request Format	checkMobileAreaAllow	O	Boolean	true:Enable checkMobileAreaSettings false:Disable checkMobileArea Settings	{"true": "Enable", "false": "Disable"}	52	2026-10-03 18:22:12.869698+07	Check Mobile Area Allow	2026-10-03 18:22:12.869698+07
587	ModifyGatewayRouting	REQUEST	Request Format	checkMobileArea	O	String	Mobile Area Settings, use commato separate	{}	53	2026-10-03 18:22:12.869698+07	Check Mobile Area	2026-10-03 18:22:12.869698+07
588	ModifyGatewayRouting	REQUEST	Request Format	stopSwitchAfterOlc	O	Integer	Stop Switch Gateway After Open LogicalChannel 0:UseSystemParameter 1:Disable 2:Enable Default:0	{"0": "UseSystemParameter", "1": "Disable", "2": "Enable"}	54	2026-10-03 18:22:12.869698+07	Stop Switch After Olc	2026-10-03 18:22:12.869698+07
589	ModifyGatewayRouting	REQUEST	Request Format	stopSwitchAfterSdp	O	Integer	Stop Switch Gateway After ReceivedSDP 0:UseSystemParameter 1:Disable 2:Enable Default:0	{"0": "UseSystemParameter", "1": "Disable", "2": "Enable"}	55	2026-10-03 18:22:12.869698+07	Stop Switch After Sdp	2026-10-03 18:22:12.869698+07
590	ModifyGatewayRouting	REQUEST	Request Format	stopSwitchAfterRtpStart	O	Integer	Stop Switch Gateway After ReceivedRTP 0:UseSystemParameter 1:Disable 2:Enable Default:0	{"0": "UseSystemParameter", "1": "Disable", "2": "Enable"}	56	2026-10-03 18:22:12.869698+07	Stop Switch After RTP Start	2026-10-03 18:22:12.869698+07
657	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	customerPassword	M	String	SelfServicePassword	{}	9	2026-10-03 18:22:12.869698+07	Customer Web Query Password	2026-10-03 18:22:12.869698+07
591	ModifyGatewayRouting	REQUEST	Request Format	stopSwitchAfterUserBusy	O	Integer	Stop Switch Gateway After ReceivedUserBusy 0:UseSystemParameter 1:Disable 2:Enable Default:0	{"0": "UseSystemParameter", "1": "Disable", "2": "Enable"}	57	2026-10-03 18:22:12.869698+07	Stop Switch After User Busy	2026-10-03 18:22:12.869698+07
592	ModifyGatewayRouting	REQUEST	Request Format	switchUntilConnect	O	Integer	SwitchGateway Until Connect 0:UseSystemParameter 1:Disable 2:Enable Default:0	{"0": "UseSystemParameter", "1": "Disable", "2": "Enable"}	58	2026-10-03 18:22:12.869698+07	Switch Until Connect	2026-10-03 18:22:12.869698+07
593	ModifyGatewayRouting	REQUEST	Request Format	sipResponseAddressMethod	O	Integer	SIPResponseAddress 0:ResponsetoRequest Address 1: Response to Request IP useportfromVia	{"0": "ResponsetoRequest", "1": ""}	59	2026-10-03 18:22:12.869698+07	SIP Response Address Method	2026-10-03 18:22:12.869698+07
594	ModifyGatewayRouting	REQUEST	Request Format	sipRequestAddressMethod	O	Integer	SIPRequestAddress 0:ToOriginal Address 1: To Original IP and Port from Contact 2:ToContact	{"0": "ToOriginal", "1": "", "2": "ToContact"}	60	2026-10-03 18:22:12.869698+07	SIP Request Address Method	2026-10-03 18:22:12.869698+07
595	ModifyGatewayRouting	REQUEST	Request Format	dtmfSendMethodH323	O	Integer	0:Auto 10:RFC2833 20:H.245 alphanumeric 30:H.245 signal 40:Q.931 keypad 60:Off	{"0": "Auto", "10": "RFC2833", "20": "H.245", "30": "H.245", "40": "Q.931", "60": "Off"}	61	2026-10-03 18:22:12.869698+07	DTMF Send Method (H.323)	2026-10-03 18:22:12.869698+07
596	ModifyGatewayRouting	REQUEST	Request Format	dtmfSendMethodSIP	O	Integer	0:Auto 10:RFC2833 50:SIP Info 60:Off	{"0": "Auto", "10": "RFC2833", "50": "SIP", "60": "Off"}	62	2026-10-03 18:22:12.869698+07	DTMF Send Method (SIP)	2026-10-03 18:22:12.869698+07
597	ModifyGatewayRouting	REQUEST	Request Format	dtmfReceiveMethod	O	Integer	0:All 10:RFC2833 20:Signaling 30:Off	{"0": "All", "10": "RFC2833", "20": "Signaling", "30": "Off"}	63	2026-10-03 18:22:12.869698+07	DTMF Receive Method	2026-10-03 18:22:12.869698+07
598	ModifyGatewayRouting	REQUEST	Request Format	dtmfSendPayloadTypeH323	O	Integer	Payload Type for H323 DTMFSend	{}	64	2026-10-03 18:22:12.869698+07	DTMF Send Payload Type (H.323)	2026-10-03 18:22:12.869698+07
599	ModifyGatewayRouting	REQUEST	Request Format	dtmfSendPayloadTypeSIP	O	Integer	PayloadType forSIP DTMF Send	{}	65	2026-10-03 18:22:12.869698+07	DTMF Send Payload Type (SIP)	2026-10-03 18:22:12.869698+07
600	ModifyGatewayRouting	REQUEST	Request Format	dtmfReceivePayloadType	O	Integer	Payload Type for DTMF Receive	{}	66	2026-10-03 18:22:12.869698+07	DTMF Receive Payload Type	2026-10-03 18:22:12.869698+07
601	ModifyGatewayRouting	REQUEST	Request Format	q931NumberingPlan	O	Integer	Q931NumberingPlan -1:UseSystem Parameter 0:UnknownPlan 1:ISDNPlan 3:DataPlan 4:TelexPlan 8:NationalStandardPlan 9:PrivatePlan 15:ReservedPlan	{"0": "UnknownPlan", "1": "ISDNPlan", "3": "DataPlan", "4": "TelexPlan", "8": "NationalStandardPlan", "-1": "UseSystem"}	67	2026-10-03 18:22:12.869698+07	Q931 Numbering Plan	2026-10-03 18:22:12.869698+07
602	ModifyGatewayRouting	REQUEST	Request Format	q931NumberType	O	Integer	Q931NumberType -1:UseSystem Parameter 0:UnknownType 1:InternationalType 2:NationalType 3:NetworkSpecificType 4:SubscriberType 6:AbbreviatedType 7:ReservedType	{"0": "UnknownType", "1": "InternationalType", "2": "NationalType", "3": "NetworkSpecificType", "4": "SubscriberType", "6": "AbbreviatedType", "-1": "UseSystem"}	68	2026-10-03 18:22:12.869698+07	Q931 Number Type	2026-10-03 18:22:12.869698+07
603	ModifyGatewayRouting	REQUEST	Request Format	q931PresentationIndicator	O	Integer	Q931PresentationIndicator -1:UseSystem Parameter 0:Presentationallowed 1:Presentationrestricted 2: Number not available due tointerworking 3:Reserved 4:None	{"0": "Presentationallowed", "1": "Presentationrestricted", "2": "", "3": "Reserved", "4": "None", "-1": "UseSystem"}	69	2026-10-03 18:22:12.869698+07	Q931 Presentation Indicator	2026-10-03 18:22:12.869698+07
604	ModifyGatewayRouting	REQUEST	Request Format	q931ScreeningIndicator	O	Integer	Q931ScreeningIndicator -1:UseSystem Parameter 0:User-provided,not screened 1:User-provided,verified and passed 2:User-provided,verified and failed 3:Network provided 4:None	{"0": "User-provided,not", "1": "User-provided,verified", "2": "User-provided,verified", "3": "Network", "4": "None", "-1": "UseSystem"}	70	2026-10-03 18:22:12.869698+07	Q931 Screening Indicator	2026-10-03 18:22:12.869698+07
605	ModifyGatewayRouting	REQUEST	Request Format	clearingAccount	O	String	Clearing AccountName	{}	71	2026-10-03 18:22:12.869698+07	Clearing Account	2026-10-03 18:22:12.869698+07
606	ModifyGatewayRouting	REQUEST	Request Format	h323FastStart	O	Boolean	true:EnableH323 faststart false:DisableH323fast start	{"true": "EnableH323", "false": "DisableH323fast"}	72	2026-10-03 18:22:12.869698+07	H.323 Fast Start	2026-10-03 18:22:12.869698+07
607	ModifyGatewayRouting	REQUEST	Request Format	h323H245Tunneling	O	Boolean	true:EnableH323 H245 tunneling false:DisableH323H245 tunneling	{"true": "EnableH323", "false": "DisableH323H245"}	73	2026-10-03 18:22:12.869698+07	H.323 H245 Tunneling	2026-10-03 18:22:12.869698+07
608	ModifyGatewayRouting	REQUEST	Request Format	h323H245InSetup	O	Boolean	true: Enable H323 H245 in Setup false: Disable H323 H245 in Setup	{"true": "", "false": ""}	74	2026-10-03 18:22:12.869698+07	H.323 H245 In Setup	2026-10-03 18:22:12.869698+07
609	ModifyGatewayRouting	REQUEST	Request Format	h323T38	O	Boolean	true:EnableH323 T38 false:DisableH323T38	{"true": "EnableH323", "false": "DisableH323T38"}	75	2026-10-03 18:22:12.869698+07	H.323 T38	2026-10-03 18:22:12.869698+07
610	ModifyGatewayRouting	REQUEST	Request Format	sipTimer	O	Boolean	true:EnableSIP Timer (RFC4028) false:DiableSIPTimer	{"true": "EnableSIP", "false": "DiableSIPTimer"}	76	2026-10-03 18:22:12.869698+07	SIP Timer	2026-10-03 18:22:12.869698+07
611	ModifyGatewayRouting	REQUEST	Request Format	sip100Rel	O	Boolean	true:EnableSIP 100rel false:DisableSIP100rel	{"true": "EnableSIP", "false": "DisableSIP100rel"}	77	2026-10-03 18:22:12.869698+07	SIP100 Rel	2026-10-03 18:22:12.869698+07
612	ModifyGatewayRouting	REQUEST	Request Format	sipT38	O	Boolean	true:EnableSIP T38 false:DisableSIPT38	{"true": "EnableSIP", "false": "DisableSIPT38"}	78	2026-10-03 18:22:12.869698+07	SIP T38	2026-10-03 18:22:12.869698+07
613	ModifyGatewayRouting	REQUEST	Request Format	sipDisplay	O	Boolean	true:IncludeDisplay false:ExcludeDisplay	{"true": "IncludeDisplay", "false": "ExcludeDisplay"}	79	2026-10-03 18:22:12.869698+07	SIP Display	2026-10-03 18:22:12.869698+07
614	ModifyGatewayRouting	REQUEST	Request Format	sipRemotePartyId	O	Boolean	true:Include RemotePartyId false:Exclude RemotePartyId	{"true": "Include", "false": "Exclude"}	80	2026-10-03 18:22:12.869698+07	SIP Remote Party ID	2026-10-03 18:22:12.869698+07
615	ModifyGatewayRouting	REQUEST	Request Format	sipPrivacy	O	Integer	0:None 1:Passthrough 2:id	{"0": "None", "1": "Passthrough", "2": "id"}	81	2026-10-03 18:22:12.869698+07	SIP Privacy	2026-10-03 18:22:12.869698+07
616	ModifyGatewayRouting	REQUEST	Request Format	sipPPreferredIdentity	O	Integer	0:None 1:Passthrough 2:Callernumber	{"0": "None", "1": "Passthrough", "2": "Callernumber"}	82	2026-10-03 18:22:12.869698+07	SIP Ppreferred IDentity	2026-10-03 18:22:12.869698+07
617	ModifyGatewayRouting	REQUEST	Request Format	sipPAssertedIdentity	O	Integer	0:None 1:Passthrough 2:Callernumber	{"0": "None", "1": "Passthrough", "2": "Callernumber"}	83	2026-10-03 18:22:12.869698+07	SIP Passerted IDentity	2026-10-03 18:22:12.869698+07
618	ModifyGatewayRouting	REQUEST	Request Format	groupE164Change	O	Boolean	true: Enable Group E164 Change false: Disable Group E164 Change	{"true": "", "false": ""}	84	2026-10-03 18:22:12.869698+07	Group E.164 Change	2026-10-03 18:22:12.869698+07
619	ModifyGatewayRouting	REQUEST	Request Format	callerAllowLength	O	Integer	MaskofCallerAllow Length 0:AllowAll Length 1<<x:Allow Length isx (x<32)	{"0": "AllowAll"}	85	2026-10-03 18:22:12.869698+07	Caller Allow Length	2026-10-03 18:22:12.869698+07
620	ModifyGatewayRouting	REQUEST	Request Format	calleeAllowLength	O	Integer	MaskofCalleeAllow Length 0:AllowAll Length 1<<x:Allow Length isx (x<32)	{"0": "AllowAll"}	86	2026-10-03 18:22:12.869698+07	Callee Allow Length	2026-10-03 18:22:12.869698+07
621	ModifyGatewayRouting	REQUEST	Request Format	callerLimitE164GroupsAllow	O	Boolean	true:Allow callerLimitE164Groups false:Forbidden callerLimitE164Groups	{"true": "Allow", "false": "Forbidden"}	87	2026-10-03 18:22:12.869698+07	Caller Limit E.164 Groups Allow	2026-10-03 18:22:12.869698+07
622	ModifyGatewayRouting	REQUEST	Request Format	callerLimitE164Groups	O	String	CallerList,separate by comma	{}	88	2026-10-03 18:22:12.869698+07	Caller Limit E.164 Groups	2026-10-03 18:22:12.869698+07
623	ModifyGatewayRouting	REQUEST	Request Format	calleeLimitE164GroupsAllow	O	Boolean	true:Allow calleeLimitE164Groups false:Forbidden calleeLimitE164Groups	{"true": "Allow", "false": "Forbidden"}	89	2026-10-03 18:22:12.869698+07	Callee Limit E.164 Groups Allow	2026-10-03 18:22:12.869698+07
624	ModifyGatewayRouting	REQUEST	Request Format	calleeLimitE164Groups	O	String	Callee List, separate by comma	{}	90	2026-10-03 18:22:12.869698+07	Callee Limit E.164 Groups	2026-10-03 18:22:12.869698+07
625	ModifyGatewayRouting	REQUEST	Request Format	h323G729SendMode	O	Integer	H323 G729 Negotiation Mode 0: Auto, keep original G729 codec 1: G729, treat G729a or G729 as G729 2: G729a, treat G729a or G729 as G729a 3: G729&G729a,treat G729 or G729a as G729 and G729a	{"0": "", "1": "", "2": "", "3": ""}	91	2026-10-03 18:22:12.869698+07	H.323 G729 Send Mode	2026-10-03 18:22:12.869698+07
626	ModifyGatewayRouting	REQUEST	Request Format	sipG729SendMode	O	Integer	SIPG729 Negotiation Mode 0: Auto, keep original G729 codec 1: G729, treat G729a or G729 as G729 2: G729a, treat G729a or G729 as G729a 3: G729&G729a,treat G729 or G729a as G729 and G729a	{"0": "", "1": "", "2": "", "3": ""}	92	2026-10-03 18:22:12.869698+07	SIP G729 Send Mode	2026-10-03 18:22:12.869698+07
627	ModifyGatewayRouting	REQUEST	Request Format	sipG729Annexb	O	Integer	G729 annexb 0:Auto 1:annex=yes 2:annex=no 3:noannex 4:transmitannex	{"0": "Auto", "1": "annex=yes", "2": "annex=no", "3": "noannex", "4": "transmitannex"}	93	2026-10-03 18:22:12.869698+07	SIP G729 Annexb	2026-10-03 18:22:12.869698+07
628	ModifyGatewayRouting	REQUEST	Request Format	sipG723Annexa	O	Integer	G723 annexa 0:Auto 1:annex=yes 2:annex=no 3:noannex 4:transmitannex	{"0": "Auto", "1": "annex=yes", "2": "annex=no", "3": "noannex", "4": "transmitannex"}	94	2026-10-03 18:22:12.869698+07	SIP G723 Annexa	2026-10-03 18:22:12.869698+07
629	ModifyGatewayRouting	REQUEST	Request Format	h323CodecAssign	O	Boolean	true:Assign H323Codecs false:AutoNegotiation	{"true": "Assign", "false": "AutoNegotiation"}	95	2026-10-03 18:22:12.869698+07	H.323 Codec Assign	2026-10-03 18:22:12.869698+07
630	ModifyGatewayRouting	REQUEST	Request Format	h323Codecs	O	Vector<String>	H323CodecList	{}	96	2026-10-03 18:22:12.869698+07	H.323 Codecs	2026-10-03 18:22:12.869698+07
815	GetCdr	REQUEST	Request Format	callerGateway	O	String	CallerGateway	{}	4	2026-10-03 18:22:12.869698+07	Caller Gateway ID	2026-10-03 18:22:12.869698+07
631	ModifyGatewayRouting	REQUEST	Request Format	sipCodecAssign	O	Boolean	true:Assign SIPCodecs false:AutoNegotiation	{"true": "Assign", "false": "AutoNegotiation"}	97	2026-10-03 18:22:12.869698+07	SIP Codec Assign	2026-10-03 18:22:12.869698+07
632	ModifyGatewayRouting	REQUEST	Request Format	sipCodecs	O	Vector<String>	SIPCodec List	{}	98	2026-10-03 18:22:12.869698+07	SIP Codecs	2026-10-03 18:22:12.869698+07
633	ModifyGatewayRouting	REQUEST	Request Format	feerateRestrict	O	Boolean	true: Check Callee Fee Rate false:NoCheck	{"true": "", "false": "NoCheck"}	99	2026-10-03 18:22:12.869698+07	Feerate Restrict	2026-10-03 18:22:12.869698+07
634	ModifyGatewayRouting	REQUEST	Request Format	leastCostRouting	O	Boolean	(feerateRestrict must be true) true:On false:Off	{"true": "On", "false": "Off"}	100	2026-10-03 18:22:12.869698+07	Least Cost Routing	2026-10-03 18:22:12.869698+07
635	ModifyGatewayRouting	REQUEST	Request Format	minProfitPercentEnable	O	Boolean	EnableMinProfitPercent	{}	101	2026-10-03 18:22:12.869698+07	Min Profit Percent Enable	2026-10-03 18:22:12.869698+07
636	ModifyGatewayRouting	REQUEST	Request Format	minProfitPercent	O	Integer	Min ProfitRate e.g.10means 10% Range:-10000to 10000	{}	102	2026-10-03 18:22:12.869698+07	Min Profit Percent	2026-10-03 18:22:12.869698+07
637	ModifyGatewayRouting	REQUEST	Request Format	maxSecondRatesEnable	O	Boolean	EnableMax Second Rate	{}	103	2026-10-03 18:22:12.869698+07	Max Second Rates Enable	2026-10-03 18:22:12.869698+07
638	ModifyGatewayRouting	REQUEST	Request Format	maxSecondRates	O	Integer	MaxSecondRates e.g. if minute rate is 0.6, set this valueas 0.01	{}	104	2026-10-03 18:22:12.869698+07	Max Second Rates	2026-10-03 18:22:12.869698+07
639	ModifyGatewayRouting	REQUEST	Request Format	enablePhoneDisplay	O	Boolean	true: Use phone display numberas caller false: Use phone number as caller clearingAccountUseCallout	{"true": "", "false": ""}	105	2026-10-03 18:22:12.869698+07	Enable Phone Display	2026-10-03 18:22:12.869698+07
640	ModifyGatewayRouting	REQUEST	Request Format	E164	O	Boolean	true:UseCalleeafter rewriteas ClearingAccount false: Use Callee before rewriteas ClearingAccount	{"true": "UseCalleeafter", "false": ""}	106	2026-10-03 18:22:12.869698+07	E.164	2026-10-03 18:22:12.869698+07
641	ModifyGatewayRouting	REQUEST	Request Format	softswitchName	O	String	SoftSwitchName	{}	107	2026-10-03 18:22:12.869698+07	VOS Softswitch Name	2026-10-03 18:22:12.869698+07
642	ModifyGatewayRouting	REQUEST	Request Format	forwardSignalRewriteE164GroupEnable	O	Boolean	true:EnableForward SignalRewrite false:DisableForward SignalRewrite	{"true": "EnableForward", "false": "DisableForward"}	108	2026-10-03 18:22:12.869698+07	Forward Signal Rewrite E.164 Group Enable	2026-10-03 18:22:12.869698+07
643	ModifyGatewayRouting	REQUEST	Request Format	forwardSignalRewriteE164Group	O	String	Forward SignalRewrite E164Group	{}	109	2026-10-03 18:22:12.869698+07	Forward Signal Rewrite E.164 Group	2026-10-03 18:22:12.869698+07
644	ModifyGatewayRouting	RESPONSE	Response Format	retCode	M	Integer	ResponseCode	{}	110	2026-10-03 18:22:12.869698+07	Return Code Status	2026-10-03 18:22:12.869698+07
645	ModifyGatewayRouting	RESPONSE	Response Format	exception	O	String	ErrorInformation	{}	111	2026-10-03 18:22:12.869698+07	Error Information	2026-10-03 18:22:12.869698+07
646	DeleteGatewayRouting	REQUEST	Request Format	name	M	String	RoutingGateway Name	{}	1	2026-10-03 18:22:12.869698+07	Gateway Name	2026-10-03 18:22:12.869698+07
647	DeleteGatewayRouting	RESPONSE	Response Format	retCode	M	Integer	ResponseCode	{}	2	2026-10-03 18:22:12.869698+07	Return Code Status	2026-10-03 18:22:12.869698+07
648	DeleteGatewayRouting	RESPONSE	Response Format	exception	O	String	ErrorInformation	{}	3	2026-10-03 18:22:12.869698+07	Error Information	2026-10-03 18:22:12.869698+07
649	GetGatewayRouting	REQUEST	Request Format	names	M	String []	Gateway Name Null:All	{}	1	2026-10-03 18:22:12.869698+07	Names Filter	2026-10-03 18:22:12.869698+07
650	GetGatewayRouting	RESPONSE	Response Format	retCode	M	Integer	ResponseCode	{}	2	2026-10-03 18:22:12.869698+07	Return Code Status	2026-10-03 18:22:12.869698+07
651	GetGatewayRouting	RESPONSE	Response Format	exception	O	String	ErrorInformation	{}	3	2026-10-03 18:22:12.869698+07	Error Information	2026-10-03 18:22:12.869698+07
652	GetGatewayRouting	RESPONSE	Response Format	infoGatewayRoutings	O	InfoGatewayRouting []	RoutingGateway Information	{}	4	2026-10-03 18:22:12.869698+07	Routing Gateways List	2026-10-03 18:22:12.869698+07
653	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	name	M	String	RoutingGateway Name	{}	5	2026-10-03 18:22:12.869698+07	Gateway Name	2026-10-03 18:22:12.869698+07
654	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	prefix	M	String	Gateway Prefix	{}	6	2026-10-03 18:22:12.869698+07	Gateway Prefix	2026-10-03 18:22:12.869698+07
655	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	prefixStyle	M	Integer	PrefixMode 0:Terminal 1:Continual	{"0": "Terminal", "1": "Continual"}	7	2026-10-03 18:22:12.869698+07	Prefix Style (0: Terminal, 1: Continual)	2026-10-03 18:22:12.869698+07
656	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	password	M	String	Gateway Password Default:Random Create	{}	8	2026-10-03 18:22:12.869698+07	SIP Register Password	2026-10-03 18:22:12.869698+07
661	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	priority	M	Integer	Priority	{}	13	2026-10-03 18:22:12.869698+07	Routing Priority	2026-10-03 18:22:12.869698+07
662	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	registerType	M	Integer	RegisterType 0:Static 1:Dynamic 2:Register	{"0": "Static", "1": "Dynamic", "2": "Register"}	14	2026-10-03 18:22:12.869698+07	SIP Register Type	2026-10-03 18:22:12.869698+07
663	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	remoteIp	M	String	IP	{}	15	2026-10-03 18:22:12.869698+07	Remote IP Address	2026-10-03 18:22:12.869698+07
664	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	rtpForwardType	M	Integer	MediaProxy 0:Auto 1:Enable 2:Disable Default:0	{"0": "Auto", "1": "Enable", "2": "Disable"}	16	2026-10-03 18:22:12.869698+07	Media Proxy / RTP Forward	2026-10-03 18:22:12.869698+07
665	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	encrypt	M	Boolean	true:Encrypt false:NoEncrypt	{"true": "Encrypt", "false": "NoEncrypt"}	17	2026-10-03 18:22:12.869698+07	Encryption Enabled	2026-10-03 18:22:12.869698+07
666	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	protocol	M	Integer	Protocol 0:H323 1:SIP	{"0": "H323", "1": "SIP"}	18	2026-10-03 18:22:12.869698+07	Signaling Protocol (1: SIP, 2: H.323)	2026-10-03 18:22:12.869698+07
667	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	signalPort	M	Integer	Signaling Port H323Default:1720 SIPDefault:5060	{}	19	2026-10-03 18:22:12.869698+07	Signaling Port Number	2026-10-03 18:22:12.869698+07
668	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	localIp	M	String	LocalIP Blank:Auto	{}	20	2026-10-03 18:22:12.869698+07	Local IP	2026-10-03 18:22:12.869698+07
669	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	mediaCheckDirection	M	Integer	RTP Interrupt Detection Mode 0:NoDetect 1: Detect whether VOS has sentRTPto Remote 2: Detect whether VOS has received RemoteRTP 3:DetectBothSide'sRTP Default:0	{"0": "NoDetect", "1": "", "2": "", "3": "DetectBothSide'sRTP"}	21	2026-10-03 18:22:12.869698+07	Media Check Direction	2026-10-03 18:22:12.869698+07
670	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	maxCallDurationLower	M	Integer	-1:UseSystem Parameter 0:Nolimit	{"0": "Nolimit", "-1": "UseSystem"}	22	2026-10-03 18:22:12.869698+07	Max Call Duration Lower	2026-10-03 18:22:12.869698+07
671	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	maxCallDurationUpper	M	Integer	-1:UseSystem Parameter 0:Nolimit	{"0": "Nolimit", "-1": "UseSystem"}	23	2026-10-03 18:22:12.869698+07	Max Call Duration Upper	2026-10-03 18:22:12.869698+07
672	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	calleeE164Restrict	M	Integer	Callee Limit 0:NoLimit 1:LimitCalleeisPhone 2:LimitCalleenotPhone	{"0": "NoLimit", "1": "LimitCalleeisPhone", "2": "LimitCalleenotPhone"}	24	2026-10-03 18:22:12.869698+07	Callee E.164 Restrict	2026-10-03 18:22:12.869698+07
816	GetCdr	REQUEST	Request Format	calleeGateway	O	String	Callee Gateway	{}	5	2026-10-03 18:22:12.869698+07	Callee Gateway ID	2026-10-03 18:22:12.869698+07
673	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	callerE164CheckEnable	M	Boolean	true:EnableCallerCheck false:DisableCaller Check	{"true": "EnableCallerCheck", "false": "DisableCaller"}	25	2026-10-03 18:22:12.869698+07	Caller E.164 Check Enable	2026-10-03 18:22:12.869698+07
674	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	callerE164CheckCity	M	Boolean	true:EnableCallerCity Check false:DisableCallerCity Check	{"true": "EnableCallerCity", "false": "DisableCallerCity"}	26	2026-10-03 18:22:12.869698+07	Caller E.164 Check City	2026-10-03 18:22:12.869698+07
675	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	callerE164CheckMobile	M	Boolean	true:EnableCallerMobile Check false: Disable Caller Mobile Check	{"true": "EnableCallerMobile", "false": ""}	27	2026-10-03 18:22:12.869698+07	Caller E.164 Check Mobile	2026-10-03 18:22:12.869698+07
676	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	callerE164CheckOther	M	Boolean	true:EnableCallerOther Check false: Disable Caller Other Check	{"true": "EnableCallerOther", "false": ""}	28	2026-10-03 18:22:12.869698+07	Caller E.164 Check Other	2026-10-03 18:22:12.869698+07
677	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	calleeE164CheckEnable	M	Boolean	true:EnableCallee Check false:DisableCallee Check	{"true": "EnableCallee", "false": "DisableCallee"}	29	2026-10-03 18:22:12.869698+07	Callee E.164 Check Enable	2026-10-03 18:22:12.869698+07
678	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	calleeE164CheckCity	M	Boolean	true:EnableCallee City Check false:DisableCalleeCity Check	{"true": "EnableCallee", "false": "DisableCalleeCity"}	30	2026-10-03 18:22:12.869698+07	Callee E.164 Check City	2026-10-03 18:22:12.869698+07
679	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	calleeE164CheckMobile	M	Boolean	true:EnableCallee Mobile Check false: Disable Callee Mobile Check	{"true": "EnableCallee", "false": ""}	31	2026-10-03 18:22:12.869698+07	Callee E.164 Check Mobile	2026-10-03 18:22:12.869698+07
680	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	calleeE164CheckOther	M	Boolean	true:EnableCallee Other Check false: Disable Callee Other Check	{"true": "EnableCallee", "false": ""}	32	2026-10-03 18:22:12.869698+07	Callee E.164 Check Other	2026-10-03 18:22:12.869698+07
681	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	callinCallerPrefixesAllow	M	Boolean	true:Enable callinCallerPrefixes false:Disable callinCallerPrefixes	{"true": "Enable", "false": "Disable"}	33	2026-10-03 18:22:12.869698+07	Callin Caller Prefixes Allow	2026-10-03 18:22:12.869698+07
682	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	callinCallerPrefixes	M	String	CallerPrefixesList	{}	34	2026-10-03 18:22:12.869698+07	Callin Caller Prefixes	2026-10-03 18:22:12.869698+07
683	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	callinCalleePrefixesAllow	M	Boolean	true:Enable callinCalleePrefixes false:Disable callinCalleePrefixes	{"true": "Enable", "false": "Disable"}	35	2026-10-03 18:22:12.869698+07	Callin Callee Prefixes Allow	2026-10-03 18:22:12.869698+07
684	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	callinCalleePrefixes	M	String	Callee Prefixes List	{}	36	2026-10-03 18:22:12.869698+07	Callin Callee Prefixes	2026-10-03 18:22:12.869698+07
685	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	rewriteRulesInCaller	M	String	CallerRewrite Rule	{}	37	2026-10-03 18:22:12.869698+07	Rewrite Rules In Caller	2026-10-03 18:22:12.869698+07
686	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	rewriteRulesInCallee	M	String	Callee RewriteRule	{}	38	2026-10-03 18:22:12.869698+07	Rewrite Rules In Callee	2026-10-03 18:22:12.869698+07
687	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	rewriteRulesInMobileAreaAllow	M	Boolean	true:Enable rewriteRulesInMobileArea false:Disable rewriteRulesInMobileArea	{"true": "Enable", "false": "Disable"}	39	2026-10-03 18:22:12.869698+07	Rewrite Rules In Mobile Area Allow	2026-10-03 18:22:12.869698+07
688	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	rewriteRulesInMobileArea	M	String	MobileAreaRewrite Rules Settings,separate by comma	{}	40	2026-10-03 18:22:12.869698+07	Rewrite Rules In Mobile Area	2026-10-03 18:22:12.869698+07
689	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	timeoutSetup	M	Integer	H323 Setup Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	41	2026-10-03 18:22:12.869698+07	Timeout Setup	2026-10-03 18:22:12.869698+07
690	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	timeoutCallProceeding	M	Integer	H323CallProceeding Timeout(Unit:Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	42	2026-10-03 18:22:12.869698+07	Timeout Call Proceeding	2026-10-03 18:22:12.869698+07
691	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	timeoutCallProceedingOlc	M	Integer	H323CallProceeding include Open Logical Channel Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	43	2026-10-03 18:22:12.869698+07	Timeout Call Proceeding Olc	2026-10-03 18:22:12.869698+07
692	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	timeoutAlerting	M	Integer	H323Alerting Timeout(Unit:Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	44	2026-10-03 18:22:12.869698+07	Timeout Alerting	2026-10-03 18:22:12.869698+07
693	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	timeoutInvite	M	Integer	SIP Invite Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	45	2026-10-03 18:22:12.869698+07	Timeout Invite	2026-10-03 18:22:12.869698+07
694	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	timeoutTrying	M	Integer	SIP Trying Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	46	2026-10-03 18:22:12.869698+07	Timeout Trying	2026-10-03 18:22:12.869698+07
695	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	timeoutSessionProgressSdp	M	Integer	SIPSessionProgress include SDP Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	47	2026-10-03 18:22:12.869698+07	Timeout Session Progress Sdp	2026-10-03 18:22:12.869698+07
696	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	timeoutSessionProgress	M	Integer	SIPSessionProgress Timeout(Unit:Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	48	2026-10-03 18:22:12.869698+07	Timeout Session Progress	2026-10-03 18:22:12.869698+07
697	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	timeoutRinging	M	Integer	SIP Ring Timeout(Unit: Second) 0:UseSystemParameter	{"0": "UseSystemParameter"}	49	2026-10-03 18:22:12.869698+07	Timeout Ringing	2026-10-03 18:22:12.869698+07
698	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	denyCallerCalleeAllow	M	Boolean	true:Enable denyCallerCallee false:Disable denyCallerCallee	{"true": "Enable", "false": "Disable"}	50	2026-10-03 18:22:12.869698+07	Deny Caller Callee Allow	2026-10-03 18:22:12.869698+07
699	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	denyCallerCallee	M	String	Format:[<Caller>: <Callee>[,<Caller>: <Callee>]…] e.g.:025:010,021:023	{}	51	2026-10-03 18:22:12.869698+07	Deny Caller Callee	2026-10-03 18:22:12.869698+07
700	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	denySameCityCodesAllow	M	Boolean	true:Enable denySameCityCodes Setting false:Disable denySameCityCodes Setting	{"true": "Enable", "false": "Disable"}	52	2026-10-03 18:22:12.869698+07	Deny Same City Codes Allow	2026-10-03 18:22:12.869698+07
701	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	denySameCityCodes	M	String	Deny Same City Codes Settings,use commato separate	{}	53	2026-10-03 18:22:12.869698+07	Deny Same City Codes	2026-10-03 18:22:12.869698+07
702	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	checkMobileAreaAllow	M	Boolean	true:Enable checkMobileAreaSettings false:Disable checkMobileArea Settings	{"true": "Enable", "false": "Disable"}	54	2026-10-03 18:22:12.869698+07	Check Mobile Area Allow	2026-10-03 18:22:12.869698+07
703	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	checkMobileArea	M	String	Mobile Area Settings, use commato separate	{}	55	2026-10-03 18:22:12.869698+07	Check Mobile Area	2026-10-03 18:22:12.869698+07
704	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	stopSwitchAfterOlc	M	Integer	Stop Switch Gateway After Open LogicalChannel 0:UseSystemParameter 1:Disable 2:Enable Default:0	{"0": "UseSystemParameter", "1": "Disable", "2": "Enable"}	56	2026-10-03 18:22:12.869698+07	Stop Switch After Olc	2026-10-03 18:22:12.869698+07
705	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	stopSwitchAfterSdp	M	Integer	Stop Switch Gateway After ReceivedSDP 0:UseSystemParameter 1:Disable 2:Enable Default:0	{"0": "UseSystemParameter", "1": "Disable", "2": "Enable"}	57	2026-10-03 18:22:12.869698+07	Stop Switch After Sdp	2026-10-03 18:22:12.869698+07
706	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	stopSwitchAfterRtpStart	M	Integer	Stop Switch Gateway After ReceivedRTP 0:UseSystemParameter 1:Disable 2:Enable Default:0	{"0": "UseSystemParameter", "1": "Disable", "2": "Enable"}	58	2026-10-03 18:22:12.869698+07	Stop Switch After RTP Start	2026-10-03 18:22:12.869698+07
707	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	switchUntilConnect	M	Integer	SwitchGateway Until Connect 0:UseSystemParameter 1:Disable 2:Enable Default:0	{"0": "UseSystemParameter", "1": "Disable", "2": "Enable"}	59	2026-10-03 18:22:12.869698+07	Switch Until Connect	2026-10-03 18:22:12.869698+07
708	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	sipResponseAddressMethod	M	Integer	SIPResponseAddress 0:ResponsetoRequest Address 1: Response to Request IP useportfromVia	{"0": "ResponsetoRequest", "1": ""}	60	2026-10-03 18:22:12.869698+07	SIP Response Address Method	2026-10-03 18:22:12.869698+07
709	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	sipRequestAddressMethod	M	Integer	SIPRequestAddress 0:ToOriginal Address 1: To Original IP and Port from Contact 2:ToContact	{"0": "ToOriginal", "1": "", "2": "ToContact"}	61	2026-10-03 18:22:12.869698+07	SIP Request Address Method	2026-10-03 18:22:12.869698+07
710	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	dtmfSendMethodH323	M	Integer	0:Auto 10:RFC2833 20:H.245 alphanumeric 30:H.245 signal 40:Q.931 keypad 60:Off	{"0": "Auto", "10": "RFC2833", "20": "H.245", "30": "H.245", "40": "Q.931", "60": "Off"}	62	2026-10-03 18:22:12.869698+07	DTMF Send Method (H.323)	2026-10-03 18:22:12.869698+07
711	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	dtmfSendMethodSIP	M	Integer	0:Auto 10:RFC2833 50:SIP Info 60:Off	{"0": "Auto", "10": "RFC2833", "50": "SIP", "60": "Off"}	63	2026-10-03 18:22:12.869698+07	DTMF Send Method (SIP)	2026-10-03 18:22:12.869698+07
712	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	dtmfReceiveMethod	M	Integer	0:All 10:RFC2833 20:Signaling 30:Off	{"0": "All", "10": "RFC2833", "20": "Signaling", "30": "Off"}	64	2026-10-03 18:22:12.869698+07	DTMF Receive Method	2026-10-03 18:22:12.869698+07
713	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	dtmfSendPayloadTypeH323	M	Integer	Payload Type for H323 DTMFSend	{}	65	2026-10-03 18:22:12.869698+07	DTMF Send Payload Type (H.323)	2026-10-03 18:22:12.869698+07
714	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	dtmfSendPayloadTypeSIP	M	Integer	PayloadType forSIP DTMF Send	{}	66	2026-10-03 18:22:12.869698+07	DTMF Send Payload Type (SIP)	2026-10-03 18:22:12.869698+07
715	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	dtmfReceivePayloadType	M	Integer	Payload Type for DTMF Receive	{}	67	2026-10-03 18:22:12.869698+07	DTMF Receive Payload Type	2026-10-03 18:22:12.869698+07
716	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	q931NumberingPlan	M	Integer	Q931NumberingPlan -1:UseSystem Parameter 0:UnknownPlan 1:ISDNPlan 3:DataPlan 4:TelexPlan 8:NationalStandardPlan 9:PrivatePlan 15:ReservedPlan	{"0": "UnknownPlan", "1": "ISDNPlan", "3": "DataPlan", "4": "TelexPlan", "8": "NationalStandardPlan", "-1": "UseSystem"}	68	2026-10-03 18:22:12.869698+07	Q931 Numbering Plan	2026-10-03 18:22:12.869698+07
717	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	q931NumberType	M	Integer	Q931NumberType -1:UseSystem Parameter 0:UnknownType 1:InternationalType 2:NationalType 3:NetworkSpecificType 4:SubscriberType 6:AbbreviatedType 7:ReservedType	{"0": "UnknownType", "1": "InternationalType", "2": "NationalType", "3": "NetworkSpecificType", "4": "SubscriberType", "6": "AbbreviatedType", "-1": "UseSystem"}	69	2026-10-03 18:22:12.869698+07	Q931 Number Type	2026-10-03 18:22:12.869698+07
718	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	q931PresentationIndicator	M	Integer	Q931PresentationIndicator -1:UseSystem Parameter 0:Presentationallowed 1:Presentationrestricted 2: Number not available due tointerworking 3:Reserved 4:None	{"0": "Presentationallowed", "1": "Presentationrestricted", "2": "", "3": "Reserved", "4": "None", "-1": "UseSystem"}	70	2026-10-03 18:22:12.869698+07	Q931 Presentation Indicator	2026-10-03 18:22:12.869698+07
719	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	q931ScreeningIndicator	M	Integer	Q931ScreeningIndicator -1:UseSystem Parameter 0:User-provided,not screened 1:User-provided,verified and passed 2:User-provided,verified and failed 3:Network provided 4:None	{"0": "User-provided,not", "1": "User-provided,verified", "2": "User-provided,verified", "3": "Network", "4": "None", "-1": "UseSystem"}	71	2026-10-03 18:22:12.869698+07	Q931 Screening Indicator	2026-10-03 18:22:12.869698+07
720	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	clearingAccount	M	String	Clearing AccountName	{}	72	2026-10-03 18:22:12.869698+07	Clearing Account	2026-10-03 18:22:12.869698+07
721	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	h323FastStart	M	Boolean	true:EnableH323 faststart false:DisableH323fast start	{"true": "EnableH323", "false": "DisableH323fast"}	73	2026-10-03 18:22:12.869698+07	H.323 Fast Start	2026-10-03 18:22:12.869698+07
722	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	h323H245Tunneling	M	Boolean	true:EnableH323 H245 tunneling false: Disable H323 H245 tunneling	{"true": "EnableH323", "false": ""}	74	2026-10-03 18:22:12.869698+07	H.323 H245 Tunneling	2026-10-03 18:22:12.869698+07
723	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	h323H245InSetup	M	Boolean	true: Enable H323 H245 in Setup false: Disable H323 H245 in Setup	{"true": "", "false": ""}	75	2026-10-03 18:22:12.869698+07	H.323 H245 In Setup	2026-10-03 18:22:12.869698+07
724	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	h323T38	M	Boolean	true:EnableH323 T38 false:DisableH323T38	{"true": "EnableH323", "false": "DisableH323T38"}	76	2026-10-03 18:22:12.869698+07	H.323 T38	2026-10-03 18:22:12.869698+07
725	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	sipTimer	M	Boolean	true: Enable SIP Timer (RFC4028) false:DiableSIPTimer	{"true": "", "false": "DiableSIPTimer"}	77	2026-10-03 18:22:12.869698+07	SIP Timer	2026-10-03 18:22:12.869698+07
726	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	sip100Rel	M	Boolean	true:EnableSIP 100rel false:DisableSIP100rel	{"true": "EnableSIP", "false": "DisableSIP100rel"}	78	2026-10-03 18:22:12.869698+07	SIP100 Rel	2026-10-03 18:22:12.869698+07
727	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	sipT38	M	Boolean	true:EnableSIP T38 false:DisableSIPT38	{"true": "EnableSIP", "false": "DisableSIPT38"}	79	2026-10-03 18:22:12.869698+07	SIP T38	2026-10-03 18:22:12.869698+07
728	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	sipDisplay	M	Boolean	true:IncludeDisplay false:ExcludeDisplay	{"true": "IncludeDisplay", "false": "ExcludeDisplay"}	80	2026-10-03 18:22:12.869698+07	SIP Display	2026-10-03 18:22:12.869698+07
729	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	sipRemotePartyId	M	Boolean	true:Include RemotePartyId false:Exclude RemotePartyId	{"true": "Include", "false": "Exclude"}	81	2026-10-03 18:22:12.869698+07	SIP Remote Party ID	2026-10-03 18:22:12.869698+07
730	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	sipPPreferredIdentity	M	Boolean	true:Include P-Preferred-Identity false:Exclude P-Preferred-Identity	{"true": "Include", "false": "Exclude"}	82	2026-10-03 18:22:12.869698+07	SIP Ppreferred IDentity	2026-10-03 18:22:12.869698+07
731	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	sipPAssertedIdentity	M	Boolean	true:Include P-Asserted-Identity false:Exclude P-Asserted-Identity	{"true": "Include", "false": "Exclude"}	83	2026-10-03 18:22:12.869698+07	SIP Passerted IDentity	2026-10-03 18:22:12.869698+07
732	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	groupE164Change	M	Boolean	true: Enable Group E164 Change false: Disable Group E164 Change	{"true": "", "false": ""}	84	2026-10-03 18:22:12.869698+07	Group E.164 Change	2026-10-03 18:22:12.869698+07
733	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	callerAllowLength	M	Integer	MaskofCallerAllow Length 0:AllowAll Length 1<<x:Allow Length isx (x<32)	{"0": "AllowAll"}	85	2026-10-03 18:22:12.869698+07	Caller Allow Length	2026-10-03 18:22:12.869698+07
734	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	calleeAllowLength	M	Integer	MaskofCalleeAllow Length 0:AllowAll Length 1<<x:Allow Length isx (x<32)	{"0": "AllowAll"}	86	2026-10-03 18:22:12.869698+07	Callee Allow Length	2026-10-03 18:22:12.869698+07
735	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	callerLimitE164GroupsAllow	M	Boolean	true:Allow callerLimitE164Groups false:Forbidden callerLimitE164Groups	{"true": "Allow", "false": "Forbidden"}	87	2026-10-03 18:22:12.869698+07	Caller Limit E.164 Groups Allow	2026-10-03 18:22:12.869698+07
736	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	callerLimitE164Groups	M	String	Caller List, separate by comma	{}	88	2026-10-03 18:22:12.869698+07	Caller Limit E.164 Groups	2026-10-03 18:22:12.869698+07
737	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	calleeLimitE164GroupsAllow	M	Boolean	true:Allow calleeLimitE164Groups false:Forbidden calleeLimitE164Groups	{"true": "Allow", "false": "Forbidden"}	89	2026-10-03 18:22:12.869698+07	Callee Limit E.164 Groups Allow	2026-10-03 18:22:12.869698+07
738	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	calleeLimitE164Groups	M	String	Callee List, separate by comma	{}	90	2026-10-03 18:22:12.869698+07	Callee Limit E.164 Groups	2026-10-03 18:22:12.869698+07
739	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	h323G729SendMode	M	Integer	H323 G729 Negotiation Mode 0: Auto, keep original G729 codec 1: G729, treat G729a or G729 as G729 2: G729a, treat G729a or G729 as G729a 3: G729&G729a,treat G729 or G729a as G729 and G729a	{"0": "", "1": "", "2": "", "3": ""}	91	2026-10-03 18:22:12.869698+07	H.323 G729 Send Mode	2026-10-03 18:22:12.869698+07
740	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	sipG729SendMode	M	Integer	SIPG729 Negotiation Mode 0: Auto, keep original G729 codec 1: G729, treat G729a or G729 as G729 2: G729a, treat G729a or G729 as G729a 3: G729&G729a,treat G729 or G729a as G729 and G729a	{"0": "", "1": "", "2": "", "3": ""}	92	2026-10-03 18:22:12.869698+07	SIP G729 Send Mode	2026-10-03 18:22:12.869698+07
741	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	sipG729Annexb	M	Integer	G729 annexb 0:Auto 1:annex=yes 2:annex=no 3:noannex 4:transmitannex	{"0": "Auto", "1": "annex=yes", "2": "annex=no", "3": "noannex", "4": "transmitannex"}	93	2026-10-03 18:22:12.869698+07	SIP G729 Annexb	2026-10-03 18:22:12.869698+07
742	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	sipG723Annexa	M	Integer	G723 annexa 0:Auto 1:annex=yes 2:annex=no 3:noannex 4:transmitannex	{"0": "Auto", "1": "annex=yes", "2": "annex=no", "3": "noannex", "4": "transmitannex"}	94	2026-10-03 18:22:12.869698+07	SIP G723 Annexa	2026-10-03 18:22:12.869698+07
743	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	h323CodecAssign	M	Boolean	true:Assign H323Codecs false:AutoNegotiation	{"true": "Assign", "false": "AutoNegotiation"}	95	2026-10-03 18:22:12.869698+07	H.323 Codec Assign	2026-10-03 18:22:12.869698+07
744	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	h323Codecs	M	Vector<String>	H323CodecList	{}	96	2026-10-03 18:22:12.869698+07	H.323 Codecs	2026-10-03 18:22:12.869698+07
745	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	sipCodecAssign	M	Boolean	true:Assign SIPCodecs false:AutoNegotiation	{"true": "Assign", "false": "AutoNegotiation"}	97	2026-10-03 18:22:12.869698+07	SIP Codec Assign	2026-10-03 18:22:12.869698+07
746	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	sipCodecs	M	Vector<String>	SIPCodec List	{}	98	2026-10-03 18:22:12.869698+07	SIP Codecs	2026-10-03 18:22:12.869698+07
747	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	feerateRestrict	M	Boolean	true: Check Callee Fee Rate false:NoCheck	{"true": "", "false": "NoCheck"}	99	2026-10-03 18:22:12.869698+07	Feerate Restrict	2026-10-03 18:22:12.869698+07
748	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	leastCostRouting	M	Boolean	(feerateRestrict must be true) true:On false:Off	{"true": "On", "false": "Off"}	100	2026-10-03 18:22:12.869698+07	Least Cost Routing	2026-10-03 18:22:12.869698+07
749	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	minProfitPercent	M	Integer	(feerateRestrict must be true) -1:Nolimit Range:-1-9999 Default:-1	{"-1": "Nolimit"}	101	2026-10-03 18:22:12.869698+07	Min Profit Percent	2026-10-03 18:22:12.869698+07
750	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	enablePhoneDisplay	M	Boolean	true: Use phone display numberas caller false: Use phone number as caller clearingAccountUseCallout	{"true": "", "false": ""}	102	2026-10-03 18:22:12.869698+07	Enable Phone Display	2026-10-03 18:22:12.869698+07
751	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	E164	M	Boolean	true:UseCalleeafter rewriteas ClearingAccount false:UseCalleebefore rewriteas ClearingAccount	{"true": "UseCalleeafter", "false": "UseCalleebefore"}	103	2026-10-03 18:22:12.869698+07	E.164	2026-10-03 18:22:12.869698+07
752	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	softswitchName	O	String	SoftSwitchName	{}	104	2026-10-03 18:22:12.869698+07	VOS Softswitch Name	2026-10-03 18:22:12.869698+07
753	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	forwardSignalRewriteE164GroupEnable	O	Boolean	true:EnableForward SignalRewrite false:DisableForward SignalRewrite	{"true": "EnableForward", "false": "DisableForward"}	105	2026-10-03 18:22:12.869698+07	Forward Signal Rewrite E.164 Group Enable	2026-10-03 18:22:12.869698+07
754	GetGatewayRouting	STRUCT	InfoGatewayRouting Format	forwardSignalRewriteE164Group	O	String	Forward SignalRewrite E164Group	{}	106	2026-10-03 18:22:12.869698+07	Forward Signal Rewrite E.164 Group	2026-10-03 18:22:12.869698+07
755	GetGatewayRoutingOnline	REQUEST	Request Format	names	O	String []	Gateway Name Null:All	{}	1	2026-10-03 18:22:12.869698+07	Names Filter	2026-10-03 18:22:12.869698+07
756	GetGatewayRoutingOnline	REQUEST	Request Format	softswitchName	O	String	SoftSwitchName Null:All	{}	2	2026-10-03 18:22:12.869698+07	VOS Softswitch Name	2026-10-03 18:22:12.869698+07
757	GetGatewayRoutingOnline	RESPONSE	Response Format	retCode	M	Integer	ResponseCode	{}	3	2026-10-03 18:22:12.869698+07	Return Code Status	2026-10-03 18:22:12.869698+07
758	GetGatewayRoutingOnline	RESPONSE	Response Format	exception	O	String	ErrorInformation	{}	4	2026-10-03 18:22:12.869698+07	Error Information	2026-10-03 18:22:12.869698+07
759	GetGatewayRoutingOnline	RESPONSE	Response Format	infoGatewayRoutingOnlines	O	InfoGatewayRoutingOnline\n[]	OnlineRouting Gateway Information	{}	5	2026-10-03 18:22:12.869698+07	Online Routing Gateways List	2026-10-03 18:22:12.869698+07
760	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	id	M	Integer	RoutingGateway ID	{}	6	2026-10-03 18:22:12.869698+07	ID	2026-10-03 18:22:12.869698+07
761	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	name	M	String	RoutingGateway Name	{}	7	2026-10-03 18:22:12.869698+07	Gateway Name	2026-10-03 18:22:12.869698+07
762	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	prefix	M	String	RoutingGateway Prefix	{}	8	2026-10-03 18:22:12.869698+07	Gateway Prefix	2026-10-03 18:22:12.869698+07
763	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	currentCall	M	Integer	CurrentCall	{}	9	2026-10-03 18:22:12.869698+07	Active Concurrent Calls	2026-10-03 18:22:12.869698+07
764	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	capacity	M	Integer	LineLimit	{}	10	2026-10-03 18:22:12.869698+07	Concurrent Line Limit	2026-10-03 18:22:12.869698+07
765	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	asr	M	double	Average Success Ratio	{}	11	2026-10-03 18:22:12.869698+07	ASR (%)	2026-10-03 18:22:12.869698+07
766	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	acd	M	Long	Average Call Duration	{}	12	2026-10-03 18:22:12.869698+07	ACD (Sec)	2026-10-03 18:22:12.869698+07
767	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	remoteIp	M	String	IPlist, usecommato separate	{}	13	2026-10-03 18:22:12.869698+07	Remote IP Address	2026-10-03 18:22:12.869698+07
770	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	registerTime	M	Long	RegisterTime(UTC) 0:Static Gateway	{"0": "Static"}	16	2026-10-03 18:22:12.869698+07	Register Time	2026-10-03 18:22:12.869698+07
771	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	updateTime	M	Long	LastUpdateTime(UTC) 0:Static Gateway	{"0": "Static"}	17	2026-10-03 18:22:12.869698+07	Update Time	2026-10-03 18:22:12.869698+07
772	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	keepTime	M	Long	Online Time(Second) 0:Static Gateway	{"0": "Static"}	18	2026-10-03 18:22:12.869698+07	Call Duration / Uptime (Sec)	2026-10-03 18:22:12.869698+07
773	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	cryptoType	M	Integer	EncryptionType 0:NoEncryption 1:RC4	{"0": "NoEncryption", "1": "RC4"}	19	2026-10-03 18:22:12.869698+07	Crypto Type	2026-10-03 18:22:12.869698+07
774	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	registerName	O	String	RegisterName	{}	20	2026-10-03 18:22:12.869698+07	Register Name	2026-10-03 18:22:12.869698+07
775	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	softswitchName	M	String	SoftSwitchName	{}	21	2026-10-03 18:22:12.869698+07	VOS Softswitch Name	2026-10-03 18:22:12.869698+07
776	GetGatewayRoutingOnline	STRUCT	InfoGatewayRoutingOnlineFormat	softswitchIp	M	String	SoftSwitchIP	{}	22	2026-10-03 18:22:12.869698+07	VOS Softswitch IP	2026-10-03 18:22:12.869698+07
777	GetCurrentCall	REQUEST	Request Format	callerE164s	O	String []	Caller	{}	1	2026-10-03 18:22:12.869698+07	Caller Numbers Filter	2026-10-03 18:22:12.869698+07
778	GetCurrentCall	REQUEST	Request Format	calleeE164s	O	String []	Callee	{}	2	2026-10-03 18:22:12.869698+07	Callee Numbers Filter	2026-10-03 18:22:12.869698+07
779	GetCurrentCall	RESPONSE	Response Format	retCode	M	Integer	ResponseCode	{}	3	2026-10-03 18:22:12.869698+07	Return Code Status	2026-10-03 18:22:12.869698+07
780	GetCurrentCall	RESPONSE	Response Format	exception	O	String	ErrorInformation	{}	4	2026-10-03 18:22:12.869698+07	Error Information	2026-10-03 18:22:12.869698+07
781	GetCurrentCall	RESPONSE	Response Format	infoCurrentCalls	O	InfoCurrentCall[]	CurrentCallInformation	{}	5	2026-10-03 18:22:12.869698+07	Current Calls Information List	2026-10-03 18:22:12.869698+07
782	GetCurrentCall	STRUCT	InfoCurrentCallFormat	callerE164	M	String	Caller	{}	6	2026-10-03 18:22:12.869698+07	Caller Number	2026-10-03 18:22:12.869698+07
783	GetCurrentCall	STRUCT	InfoCurrentCallFormat	calleeE164	M	String	Callee	{}	7	2026-10-03 18:22:12.869698+07	Callee Number	2026-10-03 18:22:12.869698+07
784	GetCurrentCall	STRUCT	InfoCurrentCallFormat	callerGatewayId	M	String	CallerGateway	{}	8	2026-10-03 18:22:12.869698+07	Caller Gateway ID	2026-10-03 18:22:12.869698+07
785	GetCurrentCall	STRUCT	InfoCurrentCallFormat	calleeGatewayId	M	String	Callee Gateway	{}	9	2026-10-03 18:22:12.869698+07	Callee Gateway ID	2026-10-03 18:22:12.869698+07
786	GetCurrentCall	STRUCT	InfoCurrentCallFormat	connectedTime	M	Long	ConnectedTime(UTC)	{}	10	2026-10-03 18:22:12.869698+07	Connected Time (UTC)	2026-10-03 18:22:12.869698+07
787	GetCurrentCall	STRUCT	InfoCurrentCallFormat	keepTime	M	Long	Above 0: Duration (Unit: Million Second) -1:Setup -2:CallProceeding -3:CallProceeding(RTP) -4:Progress -5:Alerting -6:Connect -7:Invite -8:Trying -9:SessionProgress -10:SessionProgress(SDP) -11:Ringing -12:Ok -13:Release -14:Transfering -15:TransferOk -16:TransferFailed -17:TransferCancel	{"0": "", "-1": "Setup", "-2": "CallProceeding"}	11	2026-10-03 18:22:12.869698+07	Call Duration / Uptime (Sec)	2026-10-03 18:22:12.869698+07
788	GetCurrentCall	STRUCT	InfoCurrentCallFormat	callCodec	M	String	Call Codec	{}	12	2026-10-03 18:22:12.869698+07	Negotiated Call Codec	2026-10-03 18:22:12.869698+07
789	GetCurrentCall	STRUCT	InfoCurrentCallFormat	callerCodec	M	String	CallerCodec	{}	13	2026-10-03 18:22:12.869698+07	Caller Codec	2026-10-03 18:22:12.869698+07
790	GetCurrentCall	STRUCT	InfoCurrentCallFormat	calleeCodec	M	String	Callee Codec	{}	14	2026-10-03 18:22:12.869698+07	Callee Codec	2026-10-03 18:22:12.869698+07
791	GetCurrentCall	STRUCT	InfoCurrentCallFormat	callerRtpIp	M	String	CallerRTPInformation	{}	15	2026-10-03 18:22:12.869698+07	Caller RTP Media IP	2026-10-03 18:22:12.869698+07
792	GetCurrentCall	STRUCT	InfoCurrentCallFormat	calleeRtpIp	M	String	Callee RTPInformation	{}	16	2026-10-03 18:22:12.869698+07	Callee RTP Media IP	2026-10-03 18:22:12.869698+07
793	GetCurrentCall	STRUCT	InfoCurrentCallFormat	callerReceiveDtmf	M	Integer	CallerReceiveDTMF Mode 0:Auto 10:RFC2833 20:H.245 alphanumeric 30:H.245 signal 40:Q.931 keypad 50:SIP Info 60:Off	{"0": "Auto", "10": "RFC2833", "20": "H.245", "30": "H.245", "40": "Q.931", "50": "SIP", "60": "Off"}	17	2026-10-03 18:22:12.869698+07	Caller Receive DTMF Mode	2026-10-03 18:22:12.869698+07
794	GetCurrentCall	STRUCT	InfoCurrentCallFormat	callerSendDtmf	M	Integer	SeecallerReceiveDtmf	{}	18	2026-10-03 18:22:12.869698+07	Caller Send DTMF Mode	2026-10-03 18:22:12.869698+07
795	GetCurrentCall	STRUCT	InfoCurrentCallFormat	calleeReceiveDtmf	M	Integer	SeecallerReceiveDtmf	{}	19	2026-10-03 18:22:12.869698+07	Callee Receive DTMF Mode	2026-10-03 18:22:12.869698+07
796	GetCurrentCall	STRUCT	InfoCurrentCallFormat	calleeSendDtmf	M	Integer	SeecallerReceiveDtmf	{}	20	2026-10-03 18:22:12.869698+07	Callee Send DTMF Mode	2026-10-03 18:22:12.869698+07
797	GetCurrentCall	STRUCT	InfoCurrentCallFormat	callerInfoRtpFlowAudio	M	InfoRtpFlow	CallerAudioInformation	{}	21	2026-10-03 18:22:12.869698+07	Caller Audio RTP Flow	2026-10-03 18:22:12.869698+07
798	GetCurrentCall	STRUCT	InfoCurrentCallFormat	calleeInfoRtpFlowAudio	M	InfoRtpFlow	Callee Audio Information	{}	22	2026-10-03 18:22:12.869698+07	Callee Audio RTP Flow	2026-10-03 18:22:12.869698+07
799	GetCurrentCall	STRUCT	InfoCurrentCallFormat	callerInfoRtpFlowVideo	M	InfoRtpFlow	CallerVideoInformation	{}	23	2026-10-03 18:22:12.869698+07	Caller Video RTP Flow	2026-10-03 18:22:12.869698+07
800	GetCurrentCall	STRUCT	InfoCurrentCallFormat	calleeInfoRtpFlowVideo	M	InfoRtpFlow	Callee Video Information	{}	24	2026-10-03 18:22:12.869698+07	Callee Video RTP Flow	2026-10-03 18:22:12.869698+07
801	GetCurrentCall	STRUCT	InfoCurrentCallFormat	callerTerminal	M	String	CallerDeviceName	{}	25	2026-10-03 18:22:12.869698+07	Caller Terminal Device Name	2026-10-03 18:22:12.869698+07
802	GetCurrentCall	STRUCT	InfoCurrentCallFormat	calleeTerminal	M	String	Callee DeviceName	{}	26	2026-10-03 18:22:12.869698+07	Callee Terminal Device Name	2026-10-03 18:22:12.869698+07
803	GetCurrentCall	STRUCT	InfoCurrentCallFormat	callerCryptoType	M	Integer	CallerEncryption Type 0:NoEncryption 1:RC4	{"0": "NoEncryption", "1": "RC4"}	27	2026-10-03 18:22:12.869698+07	Caller Encryption Type	2026-10-03 18:22:12.869698+07
804	GetCurrentCall	STRUCT	InfoCurrentCallFormat	calleeCryptoType	M	Integer	Callee Encryption Type 0:NoEncryption 1:RC4	{"0": "NoEncryption", "1": "RC4"}	28	2026-10-03 18:22:12.869698+07	Callee Encryption Type	2026-10-03 18:22:12.869698+07
805	GetCurrentCall	STRUCT	InfoCurrentCallFormat	callId	M	Integer	Call ID	{}	29	2026-10-03 18:22:12.869698+07	Unique Call ID	2026-10-03 18:22:12.869698+07
806	GetCurrentCall	STRUCT	InfoRtpFlowFormat	rtpPackets	M	Integer	ReceivePackets	{}	30	2026-10-03 18:22:12.869698+07	RTP Packets Count	2026-10-03 18:22:12.869698+07
807	GetCurrentCall	STRUCT	InfoRtpFlowFormat	rtpBytes	M	Integer	ReceiveBytes	{}	31	2026-10-03 18:22:12.869698+07	RTP Bytes Count	2026-10-03 18:22:12.869698+07
808	GetCurrentCall	STRUCT	InfoRtpFlowFormat	rtpDuration	M	Long	Duration (Unit:MicroSecond)	{}	32	2026-10-03 18:22:12.869698+07	RTP Stream Duration	2026-10-03 18:22:12.869698+07
809	DisconnectCurrentCall	REQUEST	Request Format	CallIds	M	Integer	Call Id	{}	1	2026-10-03 18:22:12.869698+07	Call ID	2026-10-03 18:22:12.869698+07
810	DisconnectCurrentCall	RESPONSE	Response Format	retCode	M	Integer	ResponseCode	{}	2	2026-10-03 18:22:12.869698+07	Return Code Status	2026-10-03 18:22:12.869698+07
811	DisconnectCurrentCall	RESPONSE	Response Format	exception	O	String	ErrorInformation	{}	3	2026-10-03 18:22:12.869698+07	Error Information	2026-10-03 18:22:12.869698+07
812	GetCdr	REQUEST	Request Format	accounts	M	String []	AccountNumberList	{}	1	2026-10-03 18:22:12.869698+07	Account Numbers Filter	2026-10-03 18:22:12.869698+07
817	GetCdr	REQUEST	Request Format	beginTime	M	String	BeginTime Format:yyyyMMdd	{}	6	2026-10-03 18:22:12.869698+07	Begin Time Filter	2026-10-03 18:22:12.869698+07
818	GetCdr	REQUEST	Request Format	endTime	M	String	EndTime Format:yyyyMMdd	{}	7	2026-10-03 18:22:12.869698+07	End Time Filter	2026-10-03 18:22:12.869698+07
819	GetCdr	RESPONSE	Response Format	retCode	M	Integer	ResponseCode	{}	8	2026-10-03 18:22:12.869698+07	Return Code Status	2026-10-03 18:22:12.869698+07
820	GetCdr	RESPONSE	Response Format	exception	O	String	ErrorInformation	{}	9	2026-10-03 18:22:12.869698+07	Error Information	2026-10-03 18:22:12.869698+07
821	GetCdr	RESPONSE	Response Format	infoCdrs	O	InfoCdr[]	CDRInformation	{}	10	2026-10-03 18:22:12.869698+07	CDRs Information List	2026-10-03 18:22:12.869698+07
822	GetCdr	STRUCT	InfoCdrFormat	callerE164	M	String	BillingCaller	{}	11	2026-10-03 18:22:12.869698+07	Caller Number	2026-10-03 18:22:12.869698+07
823	GetCdr	STRUCT	InfoCdrFormat	callerAccessE164	M	String	AccessCaller	{}	12	2026-10-03 18:22:12.869698+07	Access Caller Number	2026-10-03 18:22:12.869698+07
824	GetCdr	STRUCT	InfoCdrFormat	callerProductId	M	String	CallerDeviceName	{}	13	2026-10-03 18:22:12.869698+07	Caller Product ID / Device	2026-10-03 18:22:12.869698+07
825	GetCdr	STRUCT	InfoCdrFormat	callerToGatewayE164	M	String	Call OutCaller	{}	14	2026-10-03 18:22:12.869698+07	Call-Out Caller to Gateway	2026-10-03 18:22:12.869698+07
826	GetCdr	STRUCT	InfoCdrFormat	callerGateway	M	String	CallerGateway	{}	15	2026-10-03 18:22:12.869698+07	Caller Gateway ID	2026-10-03 18:22:12.869698+07
827	GetCdr	STRUCT	InfoCdrFormat	callerip	M	String	CallerIP	{}	16	2026-10-03 18:22:12.869698+07	Callerip	2026-10-03 18:22:12.869698+07
828	GetCdr	STRUCT	InfoCdrFormat	calleeE164	M	String	BillingCallee	{}	17	2026-10-03 18:22:12.869698+07	Callee Number	2026-10-03 18:22:12.869698+07
829	GetCdr	STRUCT	InfoCdrFormat	calleeAccessE164	M	String	AccessCallee	{}	18	2026-10-03 18:22:12.869698+07	Callee Access E.164	2026-10-03 18:22:12.869698+07
830	GetCdr	STRUCT	InfoCdrFormat	calleeProductId	M	String	Callee DeviceName	{}	19	2026-10-03 18:22:12.869698+07	Callee Product ID	2026-10-03 18:22:12.869698+07
831	GetCdr	STRUCT	InfoCdrFormat	calleeToGatewayE164	M	String	Call OutCallee	{}	20	2026-10-03 18:22:12.869698+07	Call-Out Callee to Gateway	2026-10-03 18:22:12.869698+07
832	GetCdr	STRUCT	InfoCdrFormat	calleeGateway	M	String	Callee Gateway	{}	21	2026-10-03 18:22:12.869698+07	Callee Gateway ID	2026-10-03 18:22:12.869698+07
833	GetCdr	STRUCT	InfoCdrFormat	calleeip	M	String	CalleIP	{}	22	2026-10-03 18:22:12.869698+07	Callee IP Address	2026-10-03 18:22:12.869698+07
834	GetCdr	STRUCT	InfoCdrFormat	start	M	Long	StartTime(UTC)	{}	23	2026-10-03 18:22:12.869698+07	Call Start Time (UTC)	2026-10-03 18:22:12.869698+07
835	GetCdr	STRUCT	InfoCdrFormat	stop	M	Long	Stop Time(UTC)	{}	24	2026-10-03 18:22:12.869698+07	Call Stop Time (UTC)	2026-10-03 18:22:12.869698+07
836	GetCdr	STRUCT	InfoCdrFormat	holdTime	M	Integer	Call Duration (Second)	{}	25	2026-10-03 18:22:12.869698+07	Call Hold Duration (Sec)	2026-10-03 18:22:12.869698+07
837	GetCdr	STRUCT	InfoCdrFormat	feeTime	M	Integer	Fee Time(Second)	{}	26	2026-10-03 18:22:12.869698+07	Billable Duration (Sec)	2026-10-03 18:22:12.869698+07
838	GetCdr	STRUCT	InfoCdrFormat	fee	M	double	Fee	{}	27	2026-10-03 18:22:12.869698+07	Charge Fee Amount	2026-10-03 18:22:12.869698+07
839	GetCdr	STRUCT	InfoCdrFormat	feePrefix	M	String	BillingPrefix	{}	28	2026-10-03 18:22:12.869698+07	Rate Prefix	2026-10-03 18:22:12.869698+07
840	GetCdr	STRUCT	InfoCdrFormat	suiteFee	M	double	SuiteFee	{}	29	2026-10-03 18:22:12.869698+07	Package Suite Fee	2026-10-03 18:22:12.869698+07
841	GetCdr	STRUCT	InfoCdrFormat	suiteFeeTime	M	Integer	SuiteGiftTime(Second)	{}	30	2026-10-03 18:22:12.869698+07	Package Gift Duration (Sec)	2026-10-03 18:22:12.869698+07
842	GetCdr	STRUCT	InfoCdrFormat	agentFee	M	double	AgentFee	{}	31	2026-10-03 18:22:12.869698+07	Agent / Reseller Fee	2026-10-03 18:22:12.869698+07
843	GetCdr	STRUCT	InfoCdrFormat	agentFeeTime	M	Integer	AgentFeeTime(Second)	{}	32	2026-10-03 18:22:12.869698+07	Agent Billable Duration (Sec)	2026-10-03 18:22:12.869698+07
844	GetCdr	STRUCT	InfoCdrFormat	agentFeePrefix	M	String	AgentBilling Prefix	{}	33	2026-10-03 18:22:12.869698+07	Agent Rate Prefix	2026-10-03 18:22:12.869698+07
845	GetCdr	STRUCT	InfoCdrFormat	agentSuiteFee	M	double	AgentSuite Fee	{}	34	2026-10-03 18:22:12.869698+07	Agent Suite Fee	2026-10-03 18:22:12.869698+07
846	GetCdr	STRUCT	InfoCdrFormat	agentSuiteFeeTime	M	Integer	AgentGiftTime(Second)	{}	35	2026-10-03 18:22:12.869698+07	Agent Gift Duration (Sec)	2026-10-03 18:22:12.869698+07
847	GetCdr	STRUCT	InfoCdrFormat	callLevel	M	Integer	Call Level 1:Net 2:Local 4:Domestic 5:International	{"1": "Net", "2": "Local", "4": "Domestic", "5": "International"}	36	2026-10-03 18:22:12.869698+07	Call Level	2026-10-03 18:22:12.869698+07
848	GetCdr	STRUCT	InfoCdrFormat	account	M	String	AccountNumber	{}	37	2026-10-03 18:22:12.869698+07	Billing Account ID	2026-10-03 18:22:12.869698+07
849	GetCdr	STRUCT	InfoCdrFormat	accountName	M	String	AccountName	{}	38	2026-10-03 18:22:12.869698+07	Customer Account Name	2026-10-03 18:22:12.869698+07
850	GetCdr	STRUCT	InfoCdrFormat	agentAccount	M	String	AgentAccount Number	{}	39	2026-10-03 18:22:12.869698+07	Agent Account	2026-10-03 18:22:12.869698+07
851	GetCdr	STRUCT	InfoCdrFormat	agentName	M	String	AgentAccount Name	{}	40	2026-10-03 18:22:12.869698+07	Agent Name	2026-10-03 18:22:12.869698+07
852	GetCdr	STRUCT	InfoCdrFormat	endDirection	M	Integer	HangupSide 0:Caller 1:Caller 2:Server	{"0": "Caller", "1": "Caller", "2": "Server"}	41	2026-10-03 18:22:12.869698+07	End Direction	2026-10-03 18:22:12.869698+07
853	GetCdr	STRUCT	InfoCdrFormat	endReason	M	Integer	EndReason	{}	42	2026-10-03 18:22:12.869698+07	End Reason	2026-10-03 18:22:12.869698+07
854	GetCdr	STRUCT	InfoCdrFormat	calleeBilling	M	Integer	Billing 0:CallerBilling 1:CalleeBilling 2:ExternalBilling	{"0": "CallerBilling", "1": "CalleeBilling", "2": "ExternalBilling"}	43	2026-10-03 18:22:12.869698+07	Callee Billing	2026-10-03 18:22:12.869698+07
855	GetCdr	STRUCT	InfoCdrFormat	billingMode	M	Integer	BillingMode 0:ByPhoneAccount 1:ByMapping Gateway Account 2:ByBinded Number Account 3:ByActive PhoneCard Account	{"0": "ByPhoneAccount", "1": "ByMapping", "2": "ByBinded", "3": "ByActive"}	44	2026-10-03 18:22:12.869698+07	Billing Mode (0: Phone, 1: Gateway, 2: Binded E.164, 3: Card)	2026-10-03 18:22:12.869698+07
856	GetFeeRateGroup	REQUEST	Request Format	names	O	String []	Fee Rate GroupList	{}	1	2026-10-03 18:22:12.869698+07	Names Filter	2026-10-03 18:22:12.869698+07
857	GetFeeRateGroup	RESPONSE	Response Format	retCode	M	Integer	ResponseCode	{}	2	2026-10-03 18:22:12.869698+07	Return Code Status	2026-10-03 18:22:12.869698+07
858	GetFeeRateGroup	RESPONSE	Response Format	exception	O	String	ErrorInformation	{}	3	2026-10-03 18:22:12.869698+07	Error Information	2026-10-03 18:22:12.869698+07
859	GetFeeRateGroup	RESPONSE	Response Format	infoFeeRateGroups	O	InfoFeeRateGroup[]	Fee Rate GroupInformation	{}	4	2026-10-03 18:22:12.869698+07	Fee Rate Groups List	2026-10-03 18:22:12.869698+07
860	GetFeeRateGroup	STRUCT	InfoFeeRateGroupFormat	name	M	String	Fee Rate GroupName	{}	5	2026-10-03 18:22:12.869698+07	Gateway Name	2026-10-03 18:22:12.869698+07
861	GetFeeRateGroup	STRUCT	InfoFeeRateGroupFormat	memo	M	String	Memo	{}	6	2026-10-03 18:22:12.869698+07	Gateway Notes / Memo	2026-10-03 18:22:12.869698+07
862	CreateFeeRateGroup	REQUEST	Request Format	name	M	String	Fee Rate GroupName	{}	1	2026-10-03 18:22:12.869698+07	Gateway Name	2026-10-03 18:22:12.869698+07
863	CreateFeeRateGroup	REQUEST	Request Format	fakeMinute	O	Integer	EquivalentTimeto60 SecondsforCalling Card	{}	2	2026-10-03 18:22:12.869698+07	Calling Card Equivalent Minute	2026-10-03 18:22:12.869698+07
864	CreateFeeRateGroup	REQUEST	Request Format	memo	O	String	Memo	{}	3	2026-10-03 18:22:12.869698+07	Gateway Notes / Memo	2026-10-03 18:22:12.869698+07
865	CreateFeeRateGroup	RESPONSE	Response Format	retCode	M	Integer	ResponseCode	{}	4	2026-10-03 18:22:12.869698+07	Return Code Status	2026-10-03 18:22:12.869698+07
866	CreateFeeRateGroup	RESPONSE	Response Format	exception	O	String	ErrorInformation	{}	5	2026-10-03 18:22:12.869698+07	Error Information	2026-10-03 18:22:12.869698+07
867	ModifyFeeRateGroup	REQUEST	Request Format	name	M	String	Fee Rate GroupName	{}	1	2026-10-03 18:22:12.869698+07	Gateway Name	2026-10-03 18:22:12.869698+07
868	ModifyFeeRateGroup	REQUEST	Request Format	fakeMinute	O	Integer	EquivalentTimeto60 SecondsforCalling Card	{}	2	2026-10-03 18:22:12.869698+07	Calling Card Equivalent Minute	2026-10-03 18:22:12.869698+07
869	ModifyFeeRateGroup	REQUEST	Request Format	memo	O	String	Memo	{}	3	2026-10-03 18:22:12.869698+07	Gateway Notes / Memo	2026-10-03 18:22:12.869698+07
870	ModifyFeeRateGroup	RESPONSE	Response Format	retCode	M	Integer	ResponseCode	{}	4	2026-10-03 18:22:12.869698+07	Return Code Status	2026-10-03 18:22:12.869698+07
871	ModifyFeeRateGroup	RESPONSE	Response Format	exception	O	String	ErrorInformation	{}	5	2026-10-03 18:22:12.869698+07	Error Information	2026-10-03 18:22:12.869698+07
872	DeleteFeeRateGroup	REQUEST	Request Format	name	M	String	Fee Rate GroupName	{}	1	2026-10-03 18:22:12.869698+07	Gateway Name	2026-10-03 18:22:12.869698+07
873	DeleteFeeRateGroup	RESPONSE	Response Format	retCode	M	Integer	ResponseCode	{}	2	2026-10-03 18:22:12.869698+07	Return Code Status	2026-10-03 18:22:12.869698+07
874	DeleteFeeRateGroup	RESPONSE	Response Format	exception	O	String	ErrorInformation	{}	3	2026-10-03 18:22:12.869698+07	Error Information	2026-10-03 18:22:12.869698+07
875	GetFeeRate	REQUEST	Request Format	feeRateGroup	M	String	Fee Rate Group	{}	1	2026-10-03 18:22:12.869698+07	Fee Rate Group Name	2026-10-03 18:22:12.869698+07
876	GetFeeRate	REQUEST	Request Format	areaCodes	O	String []	AreaCode	{}	2	2026-10-03 18:22:12.869698+07	Area Codes Filter	2026-10-03 18:22:12.869698+07
877	GetFeeRate	RESPONSE	Response Format	retCode	M	Integer	ResponseCode	{}	3	2026-10-03 18:22:12.869698+07	Return Code Status	2026-10-03 18:22:12.869698+07
878	GetFeeRate	RESPONSE	Response Format	exception	O	String	ErrorInformation	{}	4	2026-10-03 18:22:12.869698+07	Error Information	2026-10-03 18:22:12.869698+07
879	GetFeeRate	RESPONSE	Response Format	infoFeeRates	O	InfoFeeRate []	Fee Rate Information	{}	5	2026-10-03 18:22:12.869698+07	Fee Rates List	2026-10-03 18:22:12.869698+07
880	GetFeeRate	STRUCT	InfoFeeRate Format	feePrefix	M	String	RatePrefix	{}	6	2026-10-03 18:22:12.869698+07	Rate Prefix	2026-10-03 18:22:12.869698+07
881	GetFeeRate	STRUCT	InfoFeeRate Format	areaCode	M	String	AreaPrefix	{}	7	2026-10-03 18:22:12.869698+07	Area Code Prefix	2026-10-03 18:22:12.869698+07
882	GetFeeRate	STRUCT	InfoFeeRate Format	type	M	Integer	RateType 1:Net 2:Local 4:Domestic 5:International	{"1": "Net", "2": "Local", "4": "Domestic", "5": "International"}	8	2026-10-03 18:22:12.869698+07	Rate Type	2026-10-03 18:22:12.869698+07
883	GetFeeRate	STRUCT	InfoFeeRate Format	areaName	M	String	AreaName	{}	9	2026-10-03 18:22:12.869698+07	Destination Area Name	2026-10-03 18:22:12.869698+07
884	GetFeeRate	STRUCT	InfoFeeRate Format	infoFeeRateSections	M	InfoFeeRateSection []	SectionRate	{}	10	2026-10-03 18:22:12.869698+07	Fee Rate Sections List	2026-10-03 18:22:12.869698+07
885	GetFeeRate	STRUCT	InfoFeeRate Format	fee	M	double	BillingRate	{}	11	2026-10-03 18:22:12.869698+07	Charge Fee Amount	2026-10-03 18:22:12.869698+07
886	GetFeeRate	STRUCT	InfoFeeRate Format	period	M	Integer	BillingCycle	{}	12	2026-10-03 18:22:12.869698+07	Billing Billing Period	2026-10-03 18:22:12.869698+07
887	GetFeeRate	STRUCT	InfoFeeRate Format	lockType	M	Integer	LockType 0:NoLock 1:Lock	{"0": "NoLock", "1": "Lock"}	13	2026-10-03 18:22:12.869698+07	Lock Status	2026-10-03 18:22:12.869698+07
888	GetFeeRate	STRUCT	InfoFeeRate Format	ivrFee	M	double	BillingRateforCalling Card	{}	14	2026-10-03 18:22:12.869698+07	IVR Charge Rate	2026-10-03 18:22:12.869698+07
889	GetFeeRate	STRUCT	InfoFeeRate Format	ivrPeriod	M	Integer	BillingCycleforCalling CardPrompt	{}	15	2026-10-03 18:22:12.869698+07	IVR Billing Period	2026-10-03 18:22:12.869698+07
890	GetFeeRate	STRUCT	InfoFeeRateSection Format	fee	M	double	MoneyAmount	{}	16	2026-10-03 18:22:12.869698+07	Charge Fee Amount	2026-10-03 18:22:12.869698+07
891	GetFeeRate	STRUCT	InfoFeeRateSection Format	time	M	Integer	ChargedDuration	{}	17	2026-10-03 18:22:12.869698+07	Billing Duration Unit (Sec)	2026-10-03 18:22:12.869698+07
892	GetFeeRate	STRUCT	InfoFeeRateSection Format	position	M	Integer	SerialNumber	{}	18	2026-10-03 18:22:12.869698+07	Section Sequence Number	2026-10-03 18:22:12.869698+07
1227	CreateGatewayMapping	REQUEST	Request Format	routingGatewayGroups	O	String	Routing gateway group names, separated by comma. Left blank means all	{}	9	2026-10-04 14:18:35.845604+07	Routing gateway group	2026-10-05 14:18:59.429219+07
1500	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipPAssertedIdentity	M	Boolean	SIP P-Asserted-Identity header handling mode	{"0": "None", "1": "Pass through", "2": "Caller"}	76	2026-10-04 14:18:35.845604+07	P-Asserted-Identity	2026-10-04 14:18:35.845604+07
1501	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	groupE164Change	M	Boolean	Use number in Number Transformation table to replace caller ID	{"true": "Enable", "false": "Disable"}	77	2026-10-04 14:18:35.845604+07	Caller transform	2026-10-04 14:18:35.845604+07
1502	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	callerAllowLength	M	Integer	Allowed lengths of caller numbers (e.g. fill in "11, 14" means only 11-digit or 14-digit numbers allowed)	{}	78	2026-10-04 14:18:35.845604+07	Caller number allow length	2026-10-04 14:18:35.845604+07
1503	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	calleeAllowLength	M	Integer	Allowed lengths of callee numbers (blank allows all, "0" allows none)	{}	79	2026-10-04 14:18:35.845604+07	Callee number allow length	2026-10-04 14:18:35.845604+07
1504	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	callerLimitE164GroupsAllow	M	Boolean	Permission mode for caller black/white list group: allow or forbidden	{"true": "Allow", "false": "Forbidden"}	80	2026-10-04 14:18:35.845604+07	Caller black/white list group (Mode)	2026-10-04 14:18:35.845604+07
1505	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	callerLimitE164Groups	M	String	Caller black/white list group names, separated by comma	{}	81	2026-10-04 14:18:35.845604+07	Caller black/white list group	2026-10-04 14:18:35.845604+07
1506	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	calleeLimitE164GroupsAllow	M	Boolean	Permission mode for callee black/white list group: allow or forbidden	{"true": "Allow", "false": "Forbidden"}	82	2026-10-04 14:18:35.845604+07	Callee black/white list group (Mode)	2026-10-04 14:18:35.845604+07
1507	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	calleeLimitE164Groups	M	String	Callee black/white list group names, separated by comma	{}	83	2026-10-04 14:18:35.845604+07	Callee black/white list group	2026-10-04 14:18:35.845604+07
1508	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	minProfitPercent	M	Integer	This gateway will be locked if profit rate (%) falls below this value	{}	84	2026-10-04 14:18:35.845604+07	Lowest profit rate limit	2026-10-04 14:18:35.845604+07
1509	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	firstRoutePolicy	M	Integer	First priority routing strategy: None (system default), ASR, or Lowest rate per second	{"0": "None", "1": "ASR", "2": "Lowest rate per second"}	85	2026-10-04 14:18:35.845604+07	First routing strategy	2026-10-04 14:18:35.845604+07
1510	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	secondRoutePolicy	M	Integer	Second priority routing strategy: None, ASR, or Lowest rate per second	{"0": "None", "1": "ASR", "2": "Lowest rate per second"}	86	2026-10-04 14:18:35.845604+07	Second routing strategy	2026-10-04 14:18:35.845604+07
1511	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	h323G729SendMode	M	Integer	H.323 G.729 codec negotiation mode: Auto, G729, G729a, or G729&G729a	{"0": "Auto", "1": "G729", "2": "G729a", "3": "G729&G729a"}	87	2026-10-04 14:18:35.845604+07	G729 negotiation mode (H.323)	2026-10-04 14:18:35.845604+07
1512	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipG729SendMode	M	Integer	SIP G.729 codec negotiation mode: Auto, G729, G729a, or G729&G729a	{"0": "Auto", "1": "G729", "2": "G729a", "3": "G729&G729a"}	88	2026-10-04 14:18:35.845604+07	G729 negotiation mode (SIP)	2026-10-04 14:18:35.845604+07
1513	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipG729Annexb	M	Integer	SIP G.729 Annex B voice activity detection negotiation	{"0": "Auto", "1": "yes", "2": "no", "3": "None", "4": "Passthrough"}	89	2026-10-04 14:18:35.845604+07	G729 annexb	2026-10-04 14:18:35.845604+07
1514	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipG723Annexa	M	Integer	SIP G.723.1 Annex A silence suppression negotiation	{"0": "Auto", "1": "yes", "2": "no", "3": "None", "4": "Passthrough"}	90	2026-10-04 14:18:35.845604+07	G723 annexa	2026-10-04 14:18:35.845604+07
1515	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	h323CodecAssign	M	Boolean	Codec negotiation policy for H.323: Auto negotiation or Softswitch specified	{"true": "Softswitch specified", "false": "Auto negotiation"}	91	2026-10-04 14:18:35.845604+07	H.323 Codec Negotiation Policy	2026-10-04 14:18:35.845604+07
1516	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	h323Codecs	M	Vector<String>	Prioritized list of codecs specified for H.323 softswitch negotiation	{}	92	2026-10-04 14:18:35.845604+07	Specify codec (H.323)	2026-10-04 14:18:35.845604+07
1517	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipCodecAssign	M	Boolean	Codec negotiation policy for SIP: Auto negotiation or Softswitch specified	{"true": "Softswitch specified", "false": "Auto negotiation"}	93	2026-10-04 14:18:35.845604+07	SIP Codec Negotiation Policy	2026-10-04 14:18:35.845604+07
1518	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	sipCodecs	M	Vector<String>	Prioritized list of codecs specified for SIP softswitch negotiation	{}	94	2026-10-04 14:18:35.845604+07	Specify codec (SIP)	2026-10-04 14:18:35.845604+07
1519	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	forwardSignalRewriteE164GroupEnable	O	Boolean	Check to enable forwarding signal rewrite pool	{"true": "Enable", "false": "Disable"}	95	2026-10-04 14:18:35.845604+07	Enable forwarding signal rewrite pool	2026-10-04 14:18:35.845604+07
1520	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	forwardSignalRewriteE164Group	O	String	Add prefix for callee number by proportion (Proportion:Route prefix) or Forward Pool Group	{}	96	2026-10-04 14:18:35.845604+07	Add prefix to the callee / Forward Pool	2026-10-04 14:18:35.845604+07
1521	GetGatewayMapping	STRUCT	InfoGatewayMapping Format	softswitchName	M	String	Target VOS3000 softswitch instance name	{}	97	2026-10-04 14:18:35.845604+07	Softswitch	2026-10-04 14:18:35.845604+07
1522	DeleteGatewayMapping	REQUEST	Request Format	name	M	String	Unique ID of the device / Mapping Gateway Name	{}	1	2026-10-04 14:18:35.845604+07	Gateway name	2026-10-04 14:18:35.845604+07
\.


--
-- Data for Name: app_vos_end_reasons; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_vos_end_reasons (code, reason_text, protocol, leg_type, kpi_category, q850_cause, sip_status, is_egress_seizure, is_ner_success, is_asr_success, title_en, description_id, impact_recommendation, created_at, updated_at, sub_category) FROM stdin;
-53	CalleeAccountInsufficient	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Callee Account Insufficient	Saldo akun penerima (callee account) tidak mencukupi untuk menerima panggilan (fitur collect call / prepaid callee).	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-52	CalleeAccountExpired	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Callee Account Expired	Masa berlaku akun penerima panggilan (callee account) telah kedaluwarsa.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-51	CalleeAccountSignedOff	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Callee Account Signed Off	Akun penerima panggilan (callee account) telah dinonaktifkan (Signed Off).	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-50	CalleeAccountLocked	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Callee Account Locked	Akun penerima panggilan (callee account) berstatus dikunci oleh administrator.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-44	NoExchangeRate	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	No Exchange Rate	Mata uang akun pelanggan berbeda dengan mata uang tarif dan nilai kurs valuta (Exchange Rate) belum disetel.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-22	AccountSignedOff	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Account Signed Off	Akun pelanggan Ingress dinonaktifkan (Account Signed Off).	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-3	AccountNotExist	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Account Not Exist	Akun pelanggan Ingress yang terikat pada Mapping Gateway tidak ditemukan di database.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-2	InsufficientBalance	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Insufficient Balance	Saldo akun pelanggan Inbound habis (money + limit <= 0) atau tidak mencukupi pulsa awal.	Saldo akun pelanggan pemanggil habis atau kurang dari batas minimal. Hubungi pelanggan untuk melakukan pembayaran/top-up.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-79	LrnFail	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Lrn Fail	Kueri ke server eksternal LRN (Location Routing Number) database portabilitas nomor gagal merespons atau timeout.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	ROUTING
-78	RejectLrnPortedNumber	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Reject Lrn Ported Number	Nomor tujuan merupakan nomor yang dipindahkan (ported number) dan ditolak oleh kebijakan routing LRN lokal.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	ROUTING
-73	SMAPReserveFailed	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	S M A P Reserve Failed	Gagal melakukan reservasi resource kanal pada protokol integrasi switching SMAP (Switching Management Application Protocol).	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	ROUTING
-72	SMAPReserveTimeout	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	S M A P Reserve Timeout	Batas waktu reservasi kanal pensinyalan SMAP kedaluwarsa (timeout) sebelum handshake terkonfirmasi.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	ROUTING
-69	NoAvailableRouter	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	No Available Router	Routing Table tidak menemukan rute keluar, atau seluruh Routing Gateway yang cocok sedang offline, dikunci, atau penuh.	Kritis: Routing Table gagal menemukan rute keluar. Segera periksa kecocokan prefix di Routing Table atau pastikan gateway rute tidak berstatus offline/locked.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	ROUTING
-62	RoutingGatewayNoClearingAccount	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Routing Gateway No Clearing Account	Routing Gateway keluar tidak memiliki Akun Kliring (Clearing Account) yang terikat.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	ROUTING
-61	RoutingGatewayAbnormal	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Routing Gateway Abnormal	Kondisi Routing Gateway keluar berstatus abnormal (down, ping timeout, atau error port).	Routing Gateway tujuan terdeteksi tidak normal (abnormal/down). Periksa konektivitas jaringan ke IP vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	ROUTING
-57	CallRedirect	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Call Redirect	Panggilan dialihkan (Call Redirect) oleh sistem ke nomor/tujuan lain.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	ROUTING
-45	AudioCodecsNotMatch	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Audio Codecs Not Match	Format kompresi codec suara pemanggil dan penerima tidak cocok (Audio Codec Mismatch) dan transcoding tidak aktif.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	ROUTING
-82	PullRestricted	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Pull Restricted	Trafik panggilan 'Call Pull' (pemindahan sesi panggilan aktif antar-perangkat) dibatasi oleh hak akses akun.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-81	CallbackSecondPathLimited	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Callback Second Path Limited	Jalur kedua (2nd path / B-leg callback) pada fitur sistem CallBack melebihi batas kanal atau dilarang oleh dialplan.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-70	RestrictedNumber	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Restricted Number	Nomor pemanggil atau tujuan masuk ke dalam daftar proteksi pencegahan penipuan (Fraud / Scam Blacklist).	Nomor pemanggil atau nomor tujuan masuk ke dalam daftar hitam (Blacklist / Anti-Fraud). Periksa tabel pencegahan penipuan.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-67	DomesticBusinessRestricted	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Domestic Business Restricted	Trafik panggilan domestik dibatasi / diblokir oleh konfigurasi perizinan gateway.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-49	CalleeRestrict	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Callee Restrict	Nomor tujuan (Callee E.164) masuk dalam daftar blokir panggilan keluar (Callee Blacklist).	Nomor pemanggil atau nomor tujuan masuk ke dalam daftar hitam (Blacklist / Anti-Fraud). Periksa tabel pencegahan penipuan.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-48	CallerRestrict	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Caller Restrict	Nomor pemanggil (Caller E.164 / CLI) masuk dalam daftar blokir panggilan masuk (Caller Blacklist).	Nomor pemanggil atau nomor tujuan masuk ke dalam daftar hitam (Blacklist / Anti-Fraud). Periksa tabel pencegahan penipuan.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-42	ProtocolRestrict	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Protocol Restrict	Protokol pensinyalan (SIP atau H.323) tidak diizinkan pada gateway terkait.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-38	AccountLocked	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Account Locked	Akun pelanggan Ingress dikunci (Account Locked) oleh administrator sistem.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-36	CallingNumberRestricted	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Calling Number Restricted	Panjang digit nomor pemanggil (Caller CLI Length) di luar batas minimum/maksimum yang diizinkan.	Format nomor atau panjang digit nomor pemanggil/tujuan salah. Minta pengirim memeriksa standarisasi format E.164.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-35	NumberLengthRestricted	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Number Length Restricted	Panjang digit nomor tujuan (Callee Length) di luar batas minimum/maksimum yang diizinkan.	Format nomor atau panjang digit nomor pemanggil/tujuan salah. Minta pengirim memeriksa standarisasi format E.164.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-33	CalledNumberIncorrect	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Called Number Incorrect	Format nomor tujuan salah (mengandung karakter ilegal atau struktur E.164 tidak valid).	Format nomor atau panjang digit nomor pemanggil/tujuan salah. Minta pengirim memeriksa standarisasi format E.164.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-32	CallerPrefixRestricted	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Caller Prefix Restricted	Prefix nomor pemanggil (Caller Prefix) dilarang pada konfigurasi Mapping Gateway.	Prefix pemanggil atau tujuan dibatasi oleh aturan Mapping Gateway. Periksa konfigurasi Callout Prefix Deny.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-31	UnRegistered	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Un Registered	Perangkat terminal pemanggil belum melakukan registrasi SIP (Unregistered).	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-30	CalleeLocked	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Callee Locked	Akun atau ekstensi penerima terkunci (Callee Locked).	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-29	CalleePrefixRestricted	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Callee Prefix Restricted	Prefix nomor tujuan (Callee Prefix) dilarang pada konfigurasi Mapping Gateway.	Prefix pemanggil atau tujuan dibatasi oleh aturan Mapping Gateway. Periksa konfigurasi Callout Prefix Deny.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-28	CallerLocked	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Caller Locked	Akun pemanggil dikunci (Caller Locked) oleh sistem anti-fraud atau isolasi tagihan.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-9	IllegalCall	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Illegal Call	Struktur paket sinyal VoIP ilegal atau terdeteksi serangan injeksi protokol (Illegal Call).	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-1	UnauthorizedCalling	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Unauthorized Calling	IP pengirim tidak terdaftar di Mapping Gateway, atau autentikasi digest SIP ditolak.	IP pemanggil tidak diizinkan atau digest auth gagal. Pastikan IP pelanggan terdaftar pada whitelist Mapping Gateway.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	SECURITY
-75	SystemReadOnly	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	System Read Only	Penyimpanan server penuh (disk full) atau database beralih ke mode read-only untuk proteksi integritas data.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	CAPACITY
-74	LackOfVoicePorts	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Lack Of Voice Ports	Kapasitas port pemrosesan suara DSP / alokasi RTP media ports internal softswitch habis.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	CAPACITY
-60	CallDurationLimited	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Call Duration Limited	Durasi percakapan telah mencapai batas waktu maksimum panggilan (Max Call Duration Limit) yang diizinkan sistem.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	CAPACITY
-25	OverCapacity	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Over Capacity	Jumlah panggilan simultan melebihi batas kapasitas saluran (Account/Gateway Over Capacity Limit).	Batas kapasitas panggilan bersamaan (Capacity / CPS Limit) tercapai. Tingkatkan limit gateway/akun atau upgrade lisensi VOS.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	CAPACITY
-24	OverAuthorizedCapacity	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Over Authorized Capacity	Panggilan melebihi batas kapasitas konkurensi resmi lisensi sistem (Over Authorized License Capacity).	Batas kapasitas panggilan bersamaan (Capacity / CPS Limit) tercapai. Tingkatkan limit gateway/akun atau upgrade lisensi VOS.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	CAPACITY
-68	Reserve Calling Line	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Reserve  Calling  Line	Jalur panggilan dicadangkan (reserved) untuk antrean khusus dan tidak dapat digunakan untuk panggilan reguler.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	OPERATIONAL
-26	AccountExpired	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Account Expired	Masa aktif akun pelanggan Ingress telah kedaluwarsa (Account Expired).	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-46	ThirdPartyAccountNotAvailable	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Third Party Account Not Available	Akun pihak ketiga yang bertindak sebagai penjamin biaya (Third Party Billing Account) tidak tersedia/valid.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	OPERATIONAL
-40	ReasonUnknown40	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Reason Unknown40	Alasan pemutusan tidak terdefinisi (Internal Reason Unknown 40).	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	OPERATIONAL
-23	ForcedHangup	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Forced Hangup	Panggilan diputus paksa secara manual oleh administrator sistem melalui perintah Disconnect / VOS UI.	Panggilan diputus paksa secara manual oleh administrator sistem / NOC via UI atau softswitch console. Pemutusan ini merupakan inisiatif operasional internal, BUKAN kegagalan jaringan vendor Leg-B. Panggilan ini dieksklusi dari evaluasi kegagalan vendor agar tidak merusak metrik ASR/NER.	2026-10-13 07:39:01.577272+07	2026-10-20 12:36:38.480285+07	OPERATIONAL
-19	CallerForwardingNotOnline	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Caller Forwarding Not Online	Tujuan pengalihan panggilan pemanggil (Caller Forwarding Target) sedang offline.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	OPERATIONAL
-18	ForwardNumberNotExist	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Forward Number Not Exist	Nomor tujuan pengalihan panggilan tidak terdaftar atau tidak ditemukan.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	OPERATIONAL
-17	PeriodForwarding	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Period Forwarding	Pengalihan panggilan berdasarkan periode waktu (Period Forwarding) aktif.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	OPERATIONAL
-14	CalleeForwardingLoop	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Callee Forwarding Loop	Terjadi perulangan tak berujung pada rute pengalihan panggilan (Call Forwarding Loop Detected).	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	OPERATIONAL
-13	CalleeForwarding	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Callee Forwarding	Panggilan dialihkan ke nomor lain oleh pihak penerima (Callee Forwarding).	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	OPERATIONAL
-12	CalleeDoNotDisturb	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Callee Do Not Disturb	Penerima mengaktifkan fitur Jangan Ganggu (Do Not Disturb / DND).	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	OPERATIONAL
-4	NoRingAbnormalHangup	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	No Ring Abnormal Hangup	Panggilan ditutup secara abnormal sebelum nada dering (ringback tone) sempat dikirimkan.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	OPERATIONAL
-11	CalleeClosedConnection	VOS_INTERNAL	LEG_B_SEIZED	ANSWERED	\N	\N	t	t	t	Callee Closed Connection	Koneksi pensinyalan ditutup normal oleh pihak penerima (Callee Closed Connection).	Panggilan tersambung normal dan percakapan berhasil dilakukan. Diperhitungkan sebagai panggilan sukses 100% pada metrik ASR dan NER.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	ANSWERED
-8	CalleeHangup	VOS_INTERNAL	LEG_B_SEIZED	ANSWERED	\N	\N	t	t	t	Callee Hangup	Pihak penerima (Leg-B) menutup telepon terlebih dahulu setelah panggilan terhubung (Callee Hangup).	Panggilan tersambung normal dan percakapan berhasil dilakukan. Diperhitungkan sebagai panggilan sukses 100% pada metrik ASR dan NER.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	ANSWERED
16	NormalCallClearing	ITU_T_Q850	LEG_B_SEIZED	ANSWERED	16	\N	t	t	t	Normal Call Clearing	Panggilan tersambung normal dan ditutup secara wajar setelah percakapan selesai (Normal Call Clearing).	Panggilan tersambung normal dan percakapan berhasil dilakukan. Diperhitungkan sebagai panggilan sukses 100% pada metrik ASR dan NER.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	ANSWERED
-10	CallerClosedConnection	VOS_INTERNAL	LEG_B_SEIZED	USER_EVENT	\N	\N	t	t	f	Caller Closed Connection	Pihak pemanggil (Leg-A) menutup telepon atau membatalkan panggilan (Caller Hangup). Jika durasi tagihan feetime > 0 terhitung sebagai panggilan terjawab (Answered), jika feetime = 0 terhitung sebagai panggilan dibatalkan pemanggil (User Event).	Panggilan tersambung normal dan percakapan berhasil dilakukan. Diperhitungkan sebagai panggilan sukses 100% pada metrik ASR dan NER.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_CANCEL
-7	CallerHangup	VOS_INTERNAL	LEG_B_SEIZED	USER_EVENT	\N	\N	t	t	f	Caller Hangup	Pihak pemanggil (Leg-A) menutup telepon atau membatalkan panggilan (Caller Hangup). Jika durasi tagihan feetime > 0 terhitung sebagai panggilan terjawab (Answered), jika feetime = 0 terhitung sebagai panggilan dibatalkan pemanggil (User Event).	Panggilan tersambung normal dan percakapan berhasil dilakukan. Diperhitungkan sebagai panggilan sukses 100% pada metrik ASR dan NER.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_CANCEL
-39	UserBusy	VOS_INTERNAL	LEG_B_SEIZED	USER_EVENT	\N	\N	t	t	f	User Busy	Pihak penerima sedang sibuk berbicara pada panggilan lain (User Busy).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_BUSY
17	UserBusy	ITU_T_Q850	LEG_B_SEIZED	USER_EVENT	17	\N	t	t	f	User Busy	Penerima telepon sedang sibuk berbicara dengan pihak lain (User Busy).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_BUSY
486	Busy Here	SIP_RFC3261	LEG_B_SEIZED	USER_EVENT	\N	486	t	t	f	Busy  Here	Perangkat terminal penerima sedang sibuk melayani panggilan lain (SIP 486 Busy Here).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_BUSY
-6	CallAuthenticationFailure	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Call Authentication Failure	Otentikasi panggilan gagal pada pengecekan PIN, Radius, atau digest security gateway.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-5	RateNotExist	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Rate Not Exist	Tidak ditemukan paket tarif (Fee Rate Group) yang cocok untuk prefix nomor tujuan.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
600	Busy Everywhere	SIP_RFC3261	LEG_B_SEIZED	USER_EVENT	\N	600	t	t	f	Busy  Everywhere	Seluruh perangkat kontak milik penerima dalam kondisi sibuk (SIP 600 Busy Everywhere).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_BUSY
19	NoAnswer	ITU_T_Q850	LEG_B_SEIZED	USER_EVENT	19	\N	t	t	f	No Answer	Telepon berdering fisik namun tidak diangkat oleh penerima hingga batas waktu dering habis (No Answer).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_NO_ANSWER
480	Temporarily Unavailable	SIP_RFC3261	LEG_B_SEIZED	USER_EVENT	\N	480	t	t	f	Temporarily  Unavailable	Pihak penerima sedang tidak dapat dihubungi untuk sementara waktu (SIP 480 Temporarily Unavailable).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_NO_ANSWER
21	CallRejected	ITU_T_Q850	LEG_B_SEIZED	USER_EVENT	21	\N	t	t	f	Call Rejected	Panggilan ditolak secara eksplisit oleh peralatan atau pengguna penerima (Call Rejected).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_REJECT
603	Decline	SIP_RFC3261	LEG_B_SEIZED	USER_EVENT	\N	603	t	t	f	Decline	Pihak penerima secara sadar menolak menerima panggilan masuk (SIP 603 Decline).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_REJECT
34	NoCircuitChannelAvailable	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	34	\N	t	f	f	No Circuit Channel Available	Seluruh sirkuit fisik (timeslot/E1/trunk) pada gateway/sentral vendor tujuan sedang penuh sesak (No Circuit Channel Available).	Kritis: Sirkuit trunk atau server vendor mengalami kelebihan beban (Congestion). Segera alihkan prioritas routing LCR ke vendor cadangan.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_CONGESTION
42	Congestion	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	42	\N	t	f	f	Congestion	Peralatan switching pada sentral jaringan tujuan mengalami kongesti beban tinggi (Congestion).	Kritis: Sirkuit trunk atau server vendor mengalami kelebihan beban (Congestion). Segera alihkan prioritas routing LCR ke vendor cadangan.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_CONGESTION
503	Service Unavailable	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	503	t	f	f	Service  Unavailable	Server softswitch tujuan sedang mengalami kelebihan beban atau pemeliharaan (SIP 503 Service Unavailable).	Kritis: Sirkuit trunk atau server vendor mengalami kelebihan beban (Congestion). Segera alihkan prioritas routing LCR ke vendor cadangan.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_CONGESTION
504	Server Timeout	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	504	t	f	f	Server  Timeout	Server gateway tidak menerima respons tepat waktu dari gateway upstream (SIP 504 Server Timeout).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_CONGESTION
-34	ProcessTimeout	VOS_INTERNAL	LEG_B_SEIZED	EGRESS_FAIL	\N	\N	t	f	f	Process Timeout	Vendor Leg-B lambat/hang pada status Trying; tidak mengirimkan Ringing/180 melewati batas timeoutCallProceeding.	Peringatan: Vendor lambat merespons sinyal (Dead Air / Process Timeout). Pantau stabilitas gateway vendor atau laporkan ke NOC vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_TIMEOUT
-80	MediaForwardingFail	VOS_INTERNAL	LEG_B_SEIZED	EGRESS_FAIL	\N	\N	t	f	f	Media Forwarding Fail	Gagal mengalokasikan port RTP forwarder / proxy media relay pada engine softswitch (koneksi media crash).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_MEDIA_FAIL
1	UnallocatedNumber	ITU_T_Q850	LEG_B_SEIZED	USER_EVENT	1	\N	t	t	f	Unallocated Number	Nomor tujuan tidak terdaftar atau belum dialokasikan pada database sentral telco (Unallocated Number).	Panggilan sukses tersambung ke sentral vendor Leg-B dan operator tujuan mengonfirmasi bahwa nomor tidak terdaftar atau tidak dialokasikan (Unallocated Number / Not Found). Jaringan vendor sehat (sukses di NER ITU-T E.411), namun gagal di ASR karena nomor tujuan tidak valid atau tidak memiliki penerima.	2026-10-13 07:39:01.577272+07	2026-10-27 21:39:08.965877+07	USER_UNALLOCATED
404	Not Found	SIP_RFC3261	LEG_B_SEIZED	USER_EVENT	\N	404	t	t	f	Not  Found	Nomor atau pengguna tujuan tidak ditemukan pada server domain SIP (SIP 404 Not Found).	Panggilan sukses tersambung ke sentral vendor Leg-B dan operator tujuan mengonfirmasi bahwa nomor tidak terdaftar atau tidak dialokasikan (Unallocated Number / Not Found). Jaringan vendor sehat (sukses di NER ITU-T E.411), namun gagal di ASR karena nomor tujuan tidak valid atau tidak memiliki penerima.	2026-10-13 07:39:01.577272+07	2026-10-27 21:39:08.965877+07	USER_UNALLOCATED
604	Does not Exist Anywhere	SIP_RFC3261	LEG_B_SEIZED	USER_EVENT	\N	604	t	t	f	Does not  Exist  Anywhere	Nomor tujuan tidak ada di jaringan telekomunikasi mana pun secara global (SIP 604 Does Not Exist Anywhere).	Panggilan sukses tersambung ke sentral vendor Leg-B dan operator tujuan mengonfirmasi bahwa nomor tidak terdaftar atau tidak dialokasikan (Unallocated Number / Not Found). Jaringan vendor sehat (sukses di NER ITU-T E.411), namun gagal di ASR karena nomor tujuan tidak valid atau tidak memiliki penerima.	2026-10-13 07:39:01.577272+07	2026-10-27 21:39:08.965877+07	USER_UNALLOCATED
-77	MinuteRatesLimited	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Minute Rates Limited	Batas pemakaian pulsa berbasis menit harian/bulanan (Minute Rates Limitation) pada akun telah tercapai.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-76	RateLimited	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Rate Limited	Proteksi laju panggilan lonjakan (Rate Limit / CPS Guard) terpicu karena lonjakan trafik membanjiri softswitch.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-66	ClearingAccountLocked	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Clearing Account Locked	Akun kliring vendor (Clearing Account) berstatus dikunci (Locked) oleh administrator sistem.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-65	ClearingAccountExpired	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Clearing Account Expired	Masa berlaku akun kliring vendor (validTime) telah kedaluwarsa.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-64	ClearingAccountSignedOff	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Clearing Account Signed Off	Akun kliring vendor dinonaktifkan (Signed Off / Inactive).	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-63	ClearingAccountInsufficient	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Clearing Account Insufficient	Saldo deposit akun kliring vendor (money + overdrawLimit) habis, sehingga VOS membatalkan pengiriman ke vendor.	Kritis: Saldo deposit kliring ke vendor habis di sistem VOS. Segera lakukan top-up saldo akun kliring vendor terkait.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-59	NoAccessNumberAuthorization	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	No Access Number Authorization	Pelanggan Inbound tidak memiliki otorisasi untuk menggunakan nomor akses khusus (Access Number / DID).	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-58	NoAccessNumberRate	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	No Access Number Rate	Tarif untuk nomor akses khusus (Access Number Rate) belum didefinisikan dalam tabel tarif.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-56	AccountArrears	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Account Arrears	Pelanggan Inbound memiliki tunggakan pembayaran tagihan yang telah melewati batas toleransi kredit.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
-54	CalleePhoneNoAccount	VOS_INTERNAL	LEG_A_DROP	INGRESS_DROP	\N	\N	f	f	f	Callee Phone No Account	Nomor telepon tujuan (callee phone) tidak terikat ke akun penagihan apa pun di sistem.	Panggilan ditolak pada tahap validasi internal Leg-A sebelum dikirim ke vendor. Panggilan ini wajib dieksklusi dari perhitungan ASR/NER vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	FINANCIAL
52	OutgoingCallsBarred	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	52	\N	t	f	f	Outgoing Calls Barred	Panggilan keluar diblokir pada konfigurasi profil pengguna (Outgoing Calls Barred).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
-43	NoAnswer	VOS_INTERNAL	LEG_B_SEIZED	USER_EVENT	\N	\N	t	t	f	No Answer	Pihak penerima tidak mengangkat telepon hingga batas waktu dering (No Answer) berakhir.	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
-20	CalledPhoneBusy	VOS_INTERNAL	LEG_B_SEIZED	USER_EVENT	\N	\N	t	t	f	Called Phone Busy	Telepon penerima sedang sibuk pada sentral PBX lokal (Called Phone Busy).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
18	NoResponse	ITU_T_Q850	LEG_B_SEIZED	USER_EVENT	18	\N	t	t	f	No Response	Perangkat terminal penerima tidak memberikan respons pensinyalan (No Response).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
20	SubscriberAbsent	ITU_T_Q850	LEG_B_SEIZED	USER_EVENT	20	\N	t	t	f	Subscriber Absent	Pelanggan tujuan sedang tidak aktif, ponsel dimatikan, atau di luar jangkauan (Subscriber Absent).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
22	NumberChanged	ITU_T_Q850	LEG_B_SEIZED	USER_EVENT	22	\N	t	t	f	Number Changed	Nomor telepon tujuan telah dialihkan ke nomor baru (Number Changed).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
23	Redirection	ITU_T_Q850	LEG_B_SEIZED	USER_EVENT	23	\N	t	t	f	Redirection	Panggilan dialihkan ke alamat atau nomor tujuan lain (Redirection).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
26	NonSelectedUserClearing	ITU_T_Q850	LEG_B_SEIZED	USER_EVENT	26	\N	t	t	f	Non Selected User Clearing	Panggilan ditutup oleh pengguna yang tidak dipilih dalam alokasi kanal (Non-Selected User Clearing).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
30	StatusEnquiryResponse	ITU_T_Q850	LEG_B_SEIZED	USER_EVENT	30	\N	t	t	f	Status Enquiry Response	Respons terhadap permintaan pemeriksaan status jaringan pensinyalan (Status Enquiry Response).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
31	NormalUnspecified	ITU_T_Q850	LEG_B_SEIZED	USER_EVENT	31	\N	t	t	f	Normal Unspecified	Pemutusan normal terjadi tanpa adanya spesifikasi kode penyebab khusus (Normal Unspecified).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
35	CallQueued	ITU_T_Q850	LEG_B_SEIZED	USER_EVENT	35	\N	t	t	f	Call Queued	Panggilan dimasukkan ke dalam antrean tunggu saluran oleh jaringan tujuan (Call Queued).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
40	FrameModeOperational	ITU_T_Q850	LEG_B_SEIZED	USER_EVENT	40	\N	t	t	f	Frame Mode Operational	Kanal mode frame berstatus beroperasi normal (Frame Mode Operational).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
300	Multiple Choices	SIP_RFC3261	LEG_B_SEIZED	USER_EVENT	\N	300	t	t	f	Multiple  Choices	Panggilan memiliki beberapa opsi tujuan yang dapat dipilih (SIP 300 Multiple Choices).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
301	Moved Permanently	SIP_RFC3261	LEG_B_SEIZED	USER_EVENT	\N	301	t	t	f	Moved  Permanently	Penerima telah berpindah alamat kontak secara permanen (SIP 301 Moved Permanently).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
302	Moved Temporarily	SIP_RFC3261	LEG_B_SEIZED	USER_EVENT	\N	302	t	t	f	Moved  Temporarily	Penerima dialihkan sementara ke alamat kontak lain (SIP 302 Moved Temporarily).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
380	Alternative Service	SIP_RFC3261	LEG_B_SEIZED	USER_EVENT	\N	380	t	t	f	Alternative  Service	Layanan yang diminta tidak tersedia, namun tersedia alternatif layanan lain (SIP 380 Alternative Service).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
410	Gone	SIP_RFC3261	LEG_B_SEIZED	USER_EVENT	\N	410	t	t	f	Gone	Pengguna tujuan sebelumnya pernah ada namun sekarang telah tiada secara permanen (SIP 410 Gone).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
487	Request Terminated	SIP_RFC3261	LEG_B_SEIZED	USER_EVENT	\N	487	t	t	f	Request  Terminated	Permintaan panggilan dibatalkan oleh pihak pemanggil melalui pesan SIP CANCEL (SIP 487 Request Terminated).	Panggilan sukses sampai ke handset/terminal tujuan, namun pengguna sibuk, tidak menjawab, atau menolak. Jaringan vendor sehat (sukses di NER, gagal di ASR).	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	USER_EVENT
-71	CallHoldFailed	VOS_INTERNAL	LEG_B_SEIZED	EGRESS_FAIL	\N	\N	t	f	f	Call Hold Failed	Fitur penahanan panggilan (Call Hold) gagal diinisiasi pada kanal pensinyalan.	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
-55	NoAudioDataTimeout	VOS_INTERNAL	LEG_B_SEIZED	EGRESS_FAIL	\N	\N	t	f	f	No Audio Data Timeout	Tidak ada paket data audio RTP yang mengalir (Silence / RTP Loss Timeout) setelah panggilan tersambung.	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
-47	CalleeCallForwarding	VOS_INTERNAL	LEG_B_SEIZED	EGRESS_FAIL	\N	\N	t	f	f	Callee Call Forwarding	Panggilan diteruskan oleh pihak penerima (Callee Call Forwarding).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
-41	ConnectionTimeout	VOS_INTERNAL	LEG_B_SEIZED	EGRESS_FAIL	\N	\N	t	f	f	Connection Timeout	Batas waktu tunggu koneksi panggilan (Connection Timeout) berakhir saat menunggu jawaban.	Koneksi ke vendor kedaluwarsa (Setup / Connection Timeout). Periksa rute transmisi IP atau DNS ke gateway vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
-37	SessionTimeout	VOS_INTERNAL	LEG_B_SEIZED	EGRESS_FAIL	\N	\N	t	f	f	Session Timeout	Batas waktu sesi pensinyalan SIP Session-Expires (RFC 4028) berakhir tanpa ada pesan refresh UPDATE/re-INVITE.	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
-27	CallSetupTimeout	VOS_INTERNAL	LEG_B_SEIZED	EGRESS_FAIL	\N	\N	t	f	f	Call Setup Timeout	Batas waktu negosiasi pembentukan panggilan (Call Setup Timeout) berakhir sebelum koneksi terbentuk.	Koneksi ke vendor kedaluwarsa (Setup / Connection Timeout). Periksa rute transmisi IP atau DNS ke gateway vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
-21	CalleeOffLine	VOS_INTERNAL	LEG_B_SEIZED	EGRESS_FAIL	\N	\N	t	f	f	Callee Off Line	Perangkat terminal penerima (IP Phone / SIP client) sedang offline / tidak terdaftar.	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
-16	CallForwardingOnBusy	VOS_INTERNAL	LEG_B_SEIZED	EGRESS_FAIL	\N	\N	t	f	f	Call Forwarding On Busy	Pengalihan panggilan saat kondisi sibuk (Call Forwarding on Busy) aktif.	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
-15	CalleeForwardingNoReply	VOS_INTERNAL	LEG_B_SEIZED	EGRESS_FAIL	\N	\N	t	f	f	Callee Forwarding No Reply	Pengalihan panggilan saat tidak ada jawaban (Call Forwarding on No Reply) aktif.	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
2	NoRouteToNetwork	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	2	\N	t	f	f	No Route To Network	Sirkuit tidak memiliki jalur rute transit menuju jaringan operator tujuan (No Route to Network).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
3	NoRouteToDestination	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	3	\N	t	f	f	No Route To Destination	Jaringan operator tujuan tidak dapat dijangkau dari sirkuit interkoneksi vendor (No Route to Destination).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
4	SendSpecialTone	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	4	\N	t	f	f	Send Special Tone	Sentral jaringan mengirimkan nada informasi khusus (Special Information Tone).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
5	MisdialledTrunkPrefix	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	5	\N	t	f	f	Misdialled Trunk Prefix	Prefix trunk salah dialokasikan atau salah format saat interkoneksi sirkuit (Misdialled Trunk Prefix).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
6	ChannelUnacceptable	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	6	\N	t	f	f	Channel Unacceptable	Saluran komunikasi yang dinegosiasikan tidak dapat diterima oleh peralatan jaringan (Channel Unacceptable).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
7	CallAwarded	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	7	\N	t	f	f	Call Awarded	Panggilan diberikan dan dialokasikan ke saluran yang sudah tersedia (Call Awarded).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
8	Preemption	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	8	\N	t	f	f	Preemption	Panggilan diputus untuk mendahulukan panggilan darurat dengan prioritas lebih tinggi (Preemption).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
9	PreemptionCircuitReserved	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	9	\N	t	f	f	Preemption Circuit Reserved	Sirkuit dicadangkan khusus untuk panggilan prioritas darurat (Preemption Circuit Reserved).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
25	ExchangeRoutingError	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	25	\N	t	f	f	Exchange Routing Error	Terjadi kesalahan routing pada sentral pertukaran jaringan transit (Exchange Routing Error).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
27	DestinationOutOfOrder	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	27	\N	t	f	f	Destination Out Of Order	Peralatan tujuan mengalami kerusakan fisik atau antarmuka jaringan terputus (Destination Out of Order).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
28	InvalidNumberFormat	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	28	\N	t	f	f	Invalid Number Format	Format digit nomor telepon tidak valid atau digit nomor belum lengkap (Invalid Number Format).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
29	FacilityRejected	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	29	\N	t	f	f	Facility Rejected	Fasilitas layanan tambahan yang diminta ditolak oleh jaringan tujuan (Facility Rejected).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
38	NetworkOutOfOrder	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	38	\N	t	f	f	Network Out Of Order	Jaringan komunikasi tujuan sedang mengalami kerusakan / down total (Network Out of Order).	Sentral telco / softswitch vendor mengalami gangguan internal atau server error. Laporkan tiket gangguan ke NOC vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
39	FrameModeOOS	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	39	\N	t	f	f	Frame Mode O O S	Kanal mode frame berstatus tidak dapat beroperasi secara permanen (Frame Mode Out of Service).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
41	TemporaryFailure	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	41	\N	t	f	f	Temporary Failure	Kegagalan sementara pada jaringan tujuan, disarankan mencoba kembali sesaat lagi (Temporary Failure).	Sentral telco / softswitch vendor mengalami gangguan internal atau server error. Laporkan tiket gangguan ke NOC vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
43	AccessInformationDiscarded	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	43	\N	t	f	f	Access Information Discarded	Informasi akses pensinyalan dibuang oleh peralatan jaringan perantara (Access Information Discarded).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
44	RequestedCircuitNotAvailable	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	44	\N	t	f	f	Requested Circuit Not Available	Sirkuit kanal yang diminta tidak tersedia pada tabel alokasi perangkat (Requested Circuit Not Available).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
46	PrecedenceCallBlocked	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	46	\N	t	f	f	Precedence Call Blocked	Panggilan berprioritas lebih tinggi diblokir oleh kebijakan jaringan (Precedence Call Blocked).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
47	ResourceUnavailable	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	47	\N	t	f	f	Resource Unavailable	Sumber daya perangkat jaringan tujuan tidak tersedia secara umum (Resource Unavailable).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
49	QoSNotAvailable	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	49	\N	t	f	f	Qo S Not Available	Kualitas layanan (QoS) yang diminta tidak dapat dipenuhi oleh jaringan transmisi (QoS Not Available).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
50	RequestedFacilityNotSubscribed	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	50	\N	t	f	f	Requested Facility Not Subscribed	Fasilitas layanan jaringan yang diminta belum terdaftar dalam paket langganan (Facility Not Subscribed).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
53	OutgoingCallsBarredInCUG	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	53	\N	t	f	f	Outgoing Calls Barred In C U G	Panggilan keluar diblokir di dalam grup pengguna tertutup (Outgoing Calls Barred in CUG).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
54	IncomingCallsBarred	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	54	\N	t	f	f	Incoming Calls Barred	Panggilan masuk diblokir pada konfigurasi profil penerima (Incoming Calls Barred).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
55	IncomingCallsBarredInCUG	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	55	\N	t	f	f	Incoming Calls Barred In C U G	Panggilan masuk diblokir di dalam grup pengguna tertutup (Incoming Calls Barred in CUG).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
57	BearerCapNotAuthorised	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	57	\N	t	f	f	Bearer Cap Not Authorised	Kemampuan pembawa (Bearer Capability) yang diminta tidak diotorisasi oleh operator (Bearer Cap Not Authorised).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
58	BearerCapNotPresentlyAvailable	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	58	\N	t	f	f	Bearer Cap Not Presently Available	Kemampuan pembawa yang diminta sedang tidak tersedia saat ini di jaringan (Bearer Cap Not Presently Available).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
62	InconsistentOutgoingIE	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	62	\N	t	f	f	Inconsistent Outgoing I E	Elemen informasi pensinyalan keluar tidak konsisten dengan spesifikasi protokol (Inconsistent Outgoing IE).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
63	ServiceOptionNotAvailable	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	63	\N	t	f	f	Service Option Not Available	Opsi layanan yang diminta tidak tersedia pada simpul jaringan tujuan (Service Option Not Available).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
65	BearerCapNotImplemented	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	65	\N	t	f	f	Bearer Cap Not Implemented	Kemampuan pembawa yang diminta belum diimplementasikan pada perangkat (Bearer Cap Not Implemented).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
66	ChannelTypeNotImplemented	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	66	\N	t	f	f	Channel Type Not Implemented	Tipe saluran komunikasi yang diminta belum diimplementasikan pada sentral (Channel Type Not Implemented).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
69	RequestedFacilityNotImplemented	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	69	\N	t	f	f	Requested Facility Not Implemented	Fasilitas jaringan yang diminta belum diimplementasikan oleh penyedia layanan (Facility Not Implemented).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
70	OnlyRestrictedDigitalBearerCapAvailable	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	70	\N	t	f	f	Only Restricted Digital Bearer Cap Available	Hanya kemampuan pembawa digital terbatas yang tersedia pada jaringan tujuan (Restricted Digital Bearer Cap).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
79	ServiceOrOptionNotImplemented	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	79	\N	t	f	f	Service Or Option Not Implemented	Layanan atau opsi pensinyalan yang diminta belum diimplementasikan (Service/Option Not Implemented).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
81	InvalidCallReference	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	81	\N	t	f	f	Invalid Call Reference	Nilai referensi panggilan pada pesan pensinyalan tidak valid (Invalid Call Reference).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
82	IdentifiedChannelNonExistent	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	82	\N	t	f	f	Identified Channel Non Existent	Kanal pensinyalan yang diidentifikasi tidak ada pada konfigurasi perangkat (Identified Channel Non-Existent).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
83	CallIdentifyNotSuspendedCall	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	83	\N	t	f	f	Call Identify Not Suspended Call	Identitas panggilan yang diminta bukan merupakan panggilan yang sedang ditunda (Call Identify Not Suspended).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
84	CallIdentifyInUse	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	84	\N	t	f	f	Call Identify In Use	Identitas panggilan yang diminta sedang digunakan oleh sesi panggilan lain (Call Identify In Use).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
85	NoCallSuspended	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	85	\N	t	f	f	No Call Suspended	Tidak ada panggilan yang sedang dalam status penundaan (No Call Suspended).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
86	ClearedRequestedCallIdentity	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	86	\N	t	f	f	Cleared Requested Call Identity	Identitas panggilan yang diminta telah dihapus dari antrean (Cleared Requested Call Identity).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
87	UserNotInCUG	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	87	\N	t	f	f	User Not In C U G	Pengguna yang dituju bukan merupakan anggota grup pengguna tertutup (User Not in CUG).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
88	IncompatibleDestination	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	88	\N	t	f	f	Incompatible Destination	Tujuan yang dipanggil tidak kompatibel dengan tipe panggilan yang dikirimkan (Incompatible Destination).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
90	NonexistentCUG	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	90	\N	t	f	f	Nonexistent C U G	Grup pengguna tertutup (CUG) yang ditentukan tidak ada dalam sistem jaringan (Nonexistent CUG).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
91	InvalidTransitNetwork	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	91	\N	t	f	f	Invalid Transit Network	Jaringan transit yang dipilih pada parameter pensinyalan tidak valid (Invalid Transit Network).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
95	InvalidMessageUnspecified	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	95	\N	t	f	f	Invalid Message Unspecified	Pesan pensinyalan yang diterima tidak valid atau tidak terspesifikasi (Invalid Message Unspecified).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
96	MandatoryIEMissing	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	96	\N	t	f	f	Mandatory I E Missing	Elemen informasi wajib (Mandatory IE) tidak ditemukan pada pesan pensinyalan (Mandatory IE Missing).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
97	MessageTypeNonexistent	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	97	\N	t	f	f	Message Type Nonexistent	Tipe pesan pensinyalan yang diterima tidak dikenal atau tidak ada dalam standar (Message Type Nonexistent).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
98	MessageNotCompatible	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	98	\N	t	f	f	Message Not Compatible	Pesan pensinyalan tidak kompatibel dengan status tahapan panggilan saat ini (Message Not Compatible).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
99	IENonExistantOrNotImplemented	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	99	\N	t	f	f	I E Non Existant Or Not Implemented	Elemen informasi yang diterima tidak ada atau belum diimplementasikan (IE Nonexistent).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
100	InvalidIEContents	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	100	\N	t	f	f	Invalid I E Contents	Isi parameter di dalam elemen informasi pensinyalan tidak valid (Invalid IE Contents).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
101	MessageNotCompatibleWithCallState	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	101	\N	t	f	f	Message Not Compatible With Call State	Pesan pensinyalan tidak kompatibel dengan kondisi status panggilan saat ini (Message Incompatible With Call State).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
102	TimerExpiry	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	102	\N	t	f	f	Timer Expiry	Batas waktu tunggu pemulihan timer pensinyalan kedaluwarsa (Recovery on Timer Expiry).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
103	ParameterNonexistent	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	103	\N	t	f	f	Parameter Nonexistent	Parameter yang diterima pada paket pensinyalan tidak ada dalam definisi protokol (Parameter Nonexistent).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
110	UnrecognisedParamaterDiscarded	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	110	\N	t	f	f	Unrecognised Paramater Discarded	Parameter pensinyalan yang tidak dikenali dibuang oleh perangkat penerima (Unrecognised Parameter Discarded).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
111	ProtocolErrorUnspecified	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	111	\N	t	f	f	Protocol Error Unspecified	Terjadi kesalahan protokol pensinyalan yang tidak terspesifikasi (Protocol Error Unspecified).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
127	InterworkingUnspecified	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	127	\N	t	f	f	Interworking Unspecified	Terjadi peristiwa interkoneksi antar-jaringan yang tidak terspesifikasi (Interworking Unspecified).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
128	ErrorInCauseIE	ITU_T_Q850	LEG_B_SEIZED	EGRESS_FAIL	128	\N	t	f	f	Error In Cause I E	Format kode penyebab pemutusan pada elemen informasi Cause mengandung kesalahan (Error In Cause IE).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
305	Use Proxy	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	305	t	f	f	Use  Proxy	Panggilan harus dikirimkan melalui proxy perantara yang ditentukan (SIP 305 Use Proxy).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
400	Bad Request	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	400	t	f	f	Bad  Request	Permintaan SIP INVITE tidak dapat diproses karena sintaks pesan rusak (SIP 400 Bad Request).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
401	Unauthorized	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	401	t	f	f	Unauthorized	Permintaan panggilan memerlukan autentikasi identitas digest pengguna (SIP 401 Unauthorized).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
402	Payment Required	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	402	t	f	f	Payment  Required	Panggilan memerlukan pembayaran biaya sebelum dapat diproses (SIP 402 Payment Required).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
403	Forbidden	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	403	t	f	f	Forbidden	Server memahami permintaan panggilan namun menolak untuk memprosesnya (SIP 403 Forbidden).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
405	Method not Allowed	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	405	t	f	f	Method not  Allowed	Metode SIP yang dikirimkan tidak diizinkan pada alamat URI tersebut (SIP 405 Method Not Allowed).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
406	Not Acceptable	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	406	t	f	f	Not  Acceptable	Sumber daya yang diminta tidak dapat diterima sesuai header Accept klien (SIP 406 Not Acceptable).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
407	Proxy Authentication Required	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	407	t	f	f	Proxy  Authentication  Required	Permintaan panggilan memerlukan otentikasi pada server proxy perantara (SIP 407 Proxy Auth Required).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
408	Request Timeout	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	408	t	f	f	Request  Timeout	Server tidak menerima respons tepat waktu dari pihak penerima (SIP 408 Request Timeout).	Koneksi ke vendor kedaluwarsa (Setup / Connection Timeout). Periksa rute transmisi IP atau DNS ke gateway vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
413	Request Entity Too Large	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	413	t	f	f	Request  Entity  Too  Large	Ukuran badan pesan permintaan terlalu besar untuk diproses server (SIP 413 Request Entity Too Large).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
414	Request-URI Too Long	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	414	t	f	f	Request- U R I  Too  Long	Alamat URI permintaan terlalu panjang untuk diproses server (SIP 414 Request-URI Too Long).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
415	Unsupported Media Type	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	415	t	f	f	Unsupported  Media  Type	Format media pada badan pesan SDP tidak didukung oleh perangkat penerima (SIP 415 Unsupported Media Type).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
416	Unsupported URI Scheme	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	416	t	f	f	Unsupported  U R I  Scheme	Skema alamat URI yang digunakan tidak didukung oleh server (SIP 416 Unsupported URI Scheme).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
417	Bad Extension	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	417	t	f	f	Bad  Extension	Ekstensi protokol SIP yang diminta pada header Require tidak didukung (SIP 417 Bad Extension).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
421	Extension Required	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	421	t	f	f	Extension  Required	Ekstensi protokol SIP tertentu wajib disertakan pada permintaan panggilan (SIP 421 Extension Required).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
422	Session Interval Too Small	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	422	t	f	f	Session  Interval  Too  Small	Nilai interval sesi pada header Session-Expires terlalu kecil (SIP 422 Session Interval Too Small).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
423	Interval Too Brief	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	423	t	f	f	Interval  Too  Brief	Waktu sewa sumber daya terlalu singkat dari ambang batas minimum server (SIP 423 Interval Too Brief).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
481	Call/Transaction Does not Exist	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	481	t	f	f	Call/ Transaction  Does not  Exist	Transaksi atau dialog pensinyalan panggilan tidak ditemukan di server (SIP 481 Call Does Not Exist).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
482	Loop Detected	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	482	t	f	f	Loop  Detected	Terjadi perulangan rute transmisi pensinyalan SIP pada jaringan (SIP 482 Loop Detected).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
483	Too Many Hops	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	483	t	f	f	Too  Many  Hops	Jumlah lompatan proxy melebihi batas maksimum header Max-Forwards (SIP 483 Too Many Hops).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
484	Address Incomplete	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	484	t	f	f	Address  Incomplete	Digit alamat nomor tujuan belum lengkap untuk dialokasikan rute (SIP 484 Address Incomplete).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
485	Ambiguous	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	485	t	f	f	Ambiguous	Alamat URI tujuan ambigu dan merujuk pada lebih dari satu kontak (SIP 485 Ambiguous).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
488	Not Acceptable Here	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	488	t	f	f	Not  Acceptable  Here	Aspek parameter media suara pada pesan SDP tidak dapat diterima (SIP 488 Not Acceptable Here).	Format kompresi codec suara pemanggil dan penerima tidak cocok. Sesuaikan daftar codec di Routing Gateway atau aktifkan transcoding.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
491	Request Pending	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	491	t	f	f	Request  Pending	Permintaan transaksi pensinyalan sedang dalam antrean pemrosesan lain (SIP 491 Request Pending).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
500	Server Internal Error	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	500	t	f	f	Server  Internal  Error	Terjadi kesalahan internal yang tidak terduga pada server softswitch (SIP 500 Server Internal Error).	Sentral telco / softswitch vendor mengalami gangguan internal atau server error. Laporkan tiket gangguan ke NOC vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
501	Not Implemented	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	501	t	f	f	Not  Implemented	Fasilitas atau fungsi yang diminta tidak diimplementasikan pada server (SIP 501 Not Implemented).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
502	Bad Gateway	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	502	t	f	f	Bad  Gateway	Server bertindak sebagai gateway dan menerima respons tidak valid dari upstream (SIP 502 Bad Gateway).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
505	Version not Supported	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	505	t	f	f	Version not  Supported	Versi protokol SIP yang digunakan tidak didukung oleh server (SIP 505 Version Not Supported).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
513	Message Too Large	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	513	t	f	f	Message  Too  Large	Ukuran paket pesan pensinyalan terlalu besar untuk ditransmisikan via UDP (SIP 513 Message Too Large).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
606	Not Acceptablefs	SIP_RFC3261	LEG_B_SEIZED	EGRESS_FAIL	\N	606	t	f	f	Not  Acceptablefs	Beberapa aspek dari sesi panggilan yang diminta tidak dapat diterima di mana pun (SIP 606 Not Acceptable).	Kegagalan pada jaringan vendor Leg-B. Menurunkan skor efisiensi jaringan (NER). Periksa kualitas link dan performa trunk vendor.	2026-10-13 07:39:01.577272+07	2026-10-13 07:39:01.577272+07	VENDOR_FAILURE
\.


--
-- Name: app_noc_alert_rules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.app_noc_alert_rules_id_seq', 6, true);


--
-- Name: app_telco_operators_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.app_telco_operators_id_seq', 12, true);


--
-- Name: app_telco_prefixes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.app_telco_prefixes_id_seq', 100, true);


--
-- Name: app_vos_api_doc_params_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.app_vos_api_doc_params_id_seq', 1544, true);


--
-- PostgreSQL database dump complete
--


-- ==============================================================================
-- TIMESCALEDB HYPERTABLE CREATION
-- ==============================================================================
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM pg_extension WHERE extname = 'timescaledb') THEN
        IF NOT EXISTS (SELECT 1 FROM timescaledb_information.hypertables WHERE hypertable_name = 'cdr_records') THEN
            PERFORM public.create_hypertable('public.cdr_records'::regclass, 'call_time'::name, chunk_time_interval => INTERVAL '1 day', if_not_exists => TRUE);
        END IF;
        IF NOT EXISTS (SELECT 1 FROM timescaledb_information.hypertables WHERE hypertable_name = 'telemetry_noc_stages') THEN
            PERFORM public.create_hypertable('public.telemetry_noc_stages'::regclass, 'bucket_time'::name, chunk_time_interval => INTERVAL '1 day', if_not_exists => TRUE);
            PERFORM public.add_retention_policy('public.telemetry_noc_stages'::regclass, INTERVAL '7 days', if_not_exists => TRUE);
        END IF;
    END IF;
END $$;

-- ==============================================================================
-- DEFAULT VOS SERVER NODE SEEDING (Auto-Registration)
-- ==============================================================================
INSERT INTO public.app_vos_servers (
    id, name, api_url, mysql_host, mysql_port, mysql_user, mysql_password, mysql_database, location, max_channels, is_primary, is_active, cdr_sync_time, cdr_sync_enabled, agent_secret
) VALUES (
    'vos-node-01', 'VOS3000 Primary Node', 'http://127.0.0.1:6099', '127.0.0.1', 3306, 'root', '', 'vos3000', 'Primary Data Center', 2000, true, true, '00:05', true, 'voxagrid-agent-secret-2026'
) ON CONFLICT (id) DO NOTHING;

-- ==============================================================================
-- AUTOMATIC 7-DAY TRIAL LICENSE PERSISTENCE & AUDIT TABLE
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.app_license_trial (
    id SERIAL PRIMARY KEY,
    installed_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    last_seen_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    machine_id VARCHAR(64) NOT NULL,
    mac_address VARCHAR(32) NOT NULL,
    hmac_signature VARCHAR(128) NOT NULL,
    is_tampered BOOLEAN NOT NULL DEFAULT FALSE,
    tamper_reason VARCHAR(255),
    is_upgraded BOOLEAN NOT NULL DEFAULT FALSE,
    upgraded_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_license_trial_machine ON public.app_license_trial(machine_id);


-- ==============================================================================
-- Migration: 052_create_ssl_certificates_and_http_config.sql
-- Description: Dynamic SSL Management Suite & HTTP Server Configuration
-- ==============================================================================

-- 1. Tabel Master Sertifikat SSL (Custom, Self-Signed, Let's Encrypt)
CREATE TABLE IF NOT EXISTS public.app_ssl_certificates (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    cert_type VARCHAR(32) NOT NULL CHECK (cert_type IN ('CUSTOM', 'SELF_SIGNED', 'LETS_ENCRYPT')),
    description VARCHAR(255) NOT NULL,
    hostname VARCHAR(255) NOT NULL,
    sans TEXT[] DEFAULT '{}',
    certificate_pem TEXT NOT NULL,
    private_key_pem TEXT NOT NULL,
    chain_pem TEXT DEFAULT '',
    issuer VARCHAR(255) DEFAULT '',
    subject VARCHAR(255) DEFAULT '',
    serial_number VARCHAR(128) DEFAULT '',
    valid_from TIMESTAMPTZ NOT NULL,
    valid_to TIMESTAMPTZ NOT NULL,
    is_expired BOOLEAN DEFAULT FALSE,
    auto_renew BOOLEAN DEFAULT FALSE,
    renew_email VARCHAR(255) DEFAULT '',
    renew_country VARCHAR(10) DEFAULT '',
    renew_state VARCHAR(100) DEFAULT '',
    last_renew_at TIMESTAMPTZ,
    last_renew_status VARCHAR(64) DEFAULT 'IDLE',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_ssl_certs_hostname ON public.app_ssl_certificates(hostname);
CREATE INDEX IF NOT EXISTS idx_ssl_certs_valid_to ON public.app_ssl_certificates(valid_to);

-- 2. Tabel Master Konfigurasi HTTP & HTTPS Server (Singleton Row id=1)
CREATE TABLE IF NOT EXISTS public.app_http_server_config (
    id INT PRIMARY KEY DEFAULT 1 CHECK (id = 1),
    http_port INT NOT NULL DEFAULT 80 CHECK (http_port BETWEEN 1 AND 65535),
    https_port INT NOT NULL DEFAULT 443 CHECK (https_port BETWEEN 1 AND 65535),
    active_cert_id UUID REFERENCES public.app_ssl_certificates(id) ON DELETE SET NULL,
    https_enable BOOLEAN NOT NULL DEFAULT FALSE,
    force_https BOOLEAN NOT NULL DEFAULT FALSE,
    rate_limit_enabled BOOLEAN NOT NULL DEFAULT TRUE,
    api_rate_limit_rps INT NOT NULL DEFAULT 60,
    auth_rate_limit_rps INT NOT NULL DEFAULT 5,
    client_max_body_mb INT NOT NULL DEFAULT 50,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(64) DEFAULT 'system'
);

-- Seed Singleton Row
INSERT INTO public.app_http_server_config (id, http_port, https_port, https_enable, force_https)
VALUES (1, 80, 443, FALSE, FALSE)
ON CONFLICT (id) DO NOTHING;

-- 3. Registrasi API ke Catalog untuk Dynamic RBAC & Swagger API Hub
INSERT INTO public.app_api_catalog (
    category, name, method, path, description, required_role, is_active, created_at, updated_at
) VALUES 
(
    'SSL Management', 'List SSL Certificates', 'GET', '/api/v1/system/ssl/certificates',
    'Mengambil seluruh daftar sertifikat SSL yang terdaftar di sistem', 'ADMIN', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
),
(
    'SSL Management', 'Create / Upload SSL Certificate', 'POST', '/api/v1/system/ssl/certificates',
    'Menambahkan sertifikat SSL baru (Custom CA, Self-Signed, atau Let''s Encrypt)', 'ADMIN', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
),
(
    'SSL Management', 'Delete SSL Certificate', 'DELETE', '/api/v1/system/ssl/certificates/{id}',
    'Menghapus sertifikat SSL tertentu (hanya jika sedang tidak aktif)', 'ADMIN', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
),
(
    'SSL Management', 'Get HTTP Server Config', 'GET', '/api/v1/system/ssl/server-config',
    'Mengambil konfigurasi listener HTTP, HTTPS, dan status sertifikat aktif Nginx', 'ADMIN', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
),
(
    'SSL Management', 'Update HTTP Server Config & Reload', 'PUT', '/api/v1/system/ssl/server-config',
    'Memperbarui konfigurasi port HTTP/HTTPS dan memicu graceful reload Nginx', 'ADMIN', true, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP
)
ON CONFLICT DO NOTHING;
