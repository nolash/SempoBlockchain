--
-- PostgreSQL database dump
--

-- Dumped from database version 11.5
-- Dumped by pg_dump version 12.1

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
-- Name: fiatrampstatusenum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.fiatrampstatusenum AS ENUM (
    'PENDING',
    'FAILED',
    'COMPLETE'
);


ALTER TYPE public.fiatrampstatusenum OWNER TO postgres;

--
-- Name: tokentype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tokentype AS ENUM (
    'LIQUID',
    'RESERVE'
);


ALTER TYPE public.tokentype OWNER TO postgres;

--
-- Name: transferaccounttype; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.transferaccounttype AS ENUM (
    'USER',
    'ORGANISATION',
    'FLOAT',
    'CONTRACT'
);


ALTER TYPE public.transferaccounttype OWNER TO postgres;

--
-- Name: transfermodeenum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.transfermodeenum AS ENUM (
    'NFC',
    'SMS',
    'QR',
    'INTERNAL',
    'OTHER'
);


ALTER TYPE public.transfermodeenum OWNER TO postgres;

--
-- Name: transferstatusenum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.transferstatusenum AS ENUM (
    'PENDING',
    'COMPLETE',
    'REJECTED'
);


ALTER TYPE public.transferstatusenum OWNER TO postgres;

--
-- Name: transfersubtypeenum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.transfersubtypeenum AS ENUM (
    'DISBURSEMENT',
    'RECLAMATION',
    'AGENT_IN',
    'AGENT_OUT',
    'FEE',
    'INCENTIVE',
    'STANDARD'
);


ALTER TYPE public.transfersubtypeenum OWNER TO postgres;

--
-- Name: transfertypeenum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.transfertypeenum AS ENUM (
    'PAYMENT',
    'DEPOSIT',
    'WITHDRAWAL',
    'EXCHANGE'
);


ALTER TYPE public.transfertypeenum OWNER TO postgres;

SET default_tablespace = '';

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: bank_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bank_account (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    bank_country character varying,
    routing_number character varying,
    account_number character varying,
    currency character varying,
    kyc_application_id integer,
    wyre_id character varying
);


ALTER TABLE public.bank_account OWNER TO postgres;

--
-- Name: bank_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bank_account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.bank_account_id_seq OWNER TO postgres;

--
-- Name: bank_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bank_account_id_seq OWNED BY public.bank_account.id;


--
-- Name: blacklist_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blacklist_tokens (
    id integer NOT NULL,
    token character varying(500) NOT NULL,
    blacklisted_on timestamp without time zone NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone
);


ALTER TABLE public.blacklist_tokens OWNER TO postgres;

--
-- Name: blacklist_tokens_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.blacklist_tokens_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.blacklist_tokens_id_seq OWNER TO postgres;

--
-- Name: blacklist_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.blacklist_tokens_id_seq OWNED BY public.blacklist_tokens.id;


--
-- Name: blockchain_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blockchain_address (
    id integer NOT NULL,
    created timestamp without time zone,
    address character varying,
    encoded_private_key character varying,
    transfer_account_id integer,
    authorising_user_id integer,
    updated timestamp without time zone,
    type character varying,
    organisation_id integer,
    is_public boolean
);


ALTER TABLE public.blockchain_address OWNER TO postgres;

--
-- Name: blockchain_address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.blockchain_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.blockchain_address_id_seq OWNER TO postgres;

--
-- Name: blockchain_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.blockchain_address_id_seq OWNED BY public.blockchain_address.id;


--
-- Name: blockchain_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blockchain_transaction (
    id integer NOT NULL,
    created timestamp without time zone,
    submitted_date timestamp without time zone,
    added_date timestamp without time zone,
    hash character varying,
    credit_transfer_id integer,
    authorising_user_id integer,
    updated timestamp without time zone,
    block integer,
    status character varying,
    transaction_type character varying,
    message character varying,
    signing_blockchain_address_id integer,
    nonce integer,
    has_output_txn boolean,
    is_bitcoin boolean
);


ALTER TABLE public.blockchain_transaction OWNER TO postgres;

--
-- Name: blockchain_transaction_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.blockchain_transaction_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.blockchain_transaction_id_seq OWNER TO postgres;

--
-- Name: blockchain_transaction_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.blockchain_transaction_id_seq OWNED BY public.blockchain_transaction.id;


--
-- Name: kyc_application; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kyc_application (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    wyre_id character varying,
    kyc_status character varying,
    first_name character varying,
    last_name character varying,
    phone character varying,
    business_legal_name character varying,
    business_type character varying,
    tax_id character varying,
    website character varying,
    date_established character varying,
    country character varying,
    street_address character varying,
    street_address_2 character varying,
    city character varying,
    region character varying,
    postal_code character varying,
    beneficial_owners json,
    type character varying,
    kyc_actions json,
    trulioo_id character varying,
    user_id integer,
    kyc_attempts integer,
    dob character varying,
    namescan_scan_id character varying,
    organisation_id integer,
    other_data json,
    multiple_documents_verified boolean
);


ALTER TABLE public.kyc_application OWNER TO postgres;

--
-- Name: business_verification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.business_verification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.business_verification_id_seq OWNER TO postgres;

--
-- Name: business_verification_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.business_verification_id_seq OWNED BY public.kyc_application.id;


--
-- Name: credit_transfer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.credit_transfer (
    id integer NOT NULL,
    created timestamp without time zone,
    resolved_date timestamp without time zone,
    transfer_type public.transfertypeenum,
    transfer_mode public.transfermodeenum,
    transfer_status public.transferstatusenum,
    sender_transfer_account_id integer,
    recipient_transfer_account_id integer,
    recipient_user_id integer,
    sender_user_id integer,
    resolution_message character varying,
    authorising_user_id integer,
    updated timestamp without time zone,
    recipient_blockchain_address_id integer,
    sender_blockchain_address_id integer,
    transfer_use json,
    uuid character varying,
    token_id integer,
    transfer_metadata jsonb,
    transfer_subtype public.transfersubtypeenum,
    _transfer_amount_wei numeric(27,0),
    is_public boolean,
    blockchain_task_uuid character varying,
    exclude_from_limit_calcs boolean
);


ALTER TABLE public.credit_transfer OWNER TO postgres;

--
-- Name: credit_transfer_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.credit_transfer_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.credit_transfer_id_seq OWNER TO postgres;

--
-- Name: credit_transfer_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.credit_transfer_id_seq OWNED BY public.credit_transfer.id;


--
-- Name: currency_conversion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.currency_conversion (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    code character varying,
    rate double precision
);


ALTER TABLE public.currency_conversion OWNER TO postgres;

--
-- Name: currency_conversion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.currency_conversion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.currency_conversion_id_seq OWNER TO postgres;

--
-- Name: currency_conversion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.currency_conversion_id_seq OWNED BY public.currency_conversion.id;


--
-- Name: custom_attribute; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.custom_attribute (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    name character varying
);


ALTER TABLE public.custom_attribute OWNER TO postgres;

--
-- Name: custom_attribute_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.custom_attribute_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.custom_attribute_id_seq OWNER TO postgres;

--
-- Name: custom_attribute_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.custom_attribute_id_seq OWNED BY public.custom_attribute.id;


--
-- Name: custom_attribute_user_storage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.custom_attribute_user_storage (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    name character varying,
    value character varying,
    user_id integer,
    uploaded_image_id integer
);


ALTER TABLE public.custom_attribute_user_storage OWNER TO postgres;

--
-- Name: custom_attribute_user_storage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.custom_attribute_user_storage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.custom_attribute_user_storage_id_seq OWNER TO postgres;

--
-- Name: custom_attribute_user_storage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.custom_attribute_user_storage_id_seq OWNED BY public.custom_attribute_user_storage.id;


--
-- Name: device_info; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.device_info (
    id integer NOT NULL,
    created timestamp without time zone,
    unique_id character varying,
    brand character varying,
    model character varying,
    height integer,
    width integer,
    user_id integer,
    authorising_user_id integer,
    updated timestamp without time zone
);


ALTER TABLE public.device_info OWNER TO postgres;

--
-- Name: device_info_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.device_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.device_info_id_seq OWNER TO postgres;

--
-- Name: device_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.device_info_id_seq OWNED BY public.device_info.id;


--
-- Name: email_whitelist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.email_whitelist (
    id integer NOT NULL,
    created timestamp without time zone,
    email character varying,
    allow_partial_match boolean,
    used boolean,
    tier character varying,
    authorising_user_id integer,
    updated timestamp without time zone,
    organisation_id integer,
    referral_code character varying,
    is_public boolean,
    sent integer
);


ALTER TABLE public.email_whitelist OWNER TO postgres;

--
-- Name: email_whitelist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.email_whitelist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.email_whitelist_id_seq OWNER TO postgres;

--
-- Name: email_whitelist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.email_whitelist_id_seq OWNED BY public.email_whitelist.id;


--
-- Name: exchange; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exchange (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    to_desired_amount integer,
    user_id integer,
    from_token_id integer,
    to_token_id integer,
    from_transfer_id integer,
    to_transfer_id integer,
    exchange_rate double precision,
    blockchain_task_uuid character varying
);


ALTER TABLE public.exchange OWNER TO postgres;

--
-- Name: exchange_contract; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exchange_contract (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    blockchain_address character varying,
    contract_registry_blockchain_address character varying,
    subexchange_address_mapping json,
    reserve_token_id integer
);


ALTER TABLE public.exchange_contract OWNER TO postgres;

--
-- Name: exchange_contract_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exchange_contract_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.exchange_contract_id_seq OWNER TO postgres;

--
-- Name: exchange_contract_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exchange_contract_id_seq OWNED BY public.exchange_contract.id;


--
-- Name: exchange_contract_token_association_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.exchange_contract_token_association_table (
    exchange_contract_id integer,
    token_id integer
);


ALTER TABLE public.exchange_contract_token_association_table OWNER TO postgres;

--
-- Name: exchange_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.exchange_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.exchange_id_seq OWNER TO postgres;

--
-- Name: exchange_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.exchange_id_seq OWNED BY public.exchange.id;


--
-- Name: feedback; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.feedback (
    id integer NOT NULL,
    created timestamp without time zone,
    rating double precision,
    additional_information character varying,
    question character varying,
    authorising_user_id integer,
    updated timestamp without time zone,
    user_id integer
);


ALTER TABLE public.feedback OWNER TO postgres;

--
-- Name: feedback_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.feedback_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.feedback_id_seq OWNER TO postgres;

--
-- Name: feedback_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.feedback_id_seq OWNED BY public.feedback.id;


--
-- Name: fiat_ramp; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fiat_ramp (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    _payment_method character varying,
    payment_amount integer,
    payment_reference character varying,
    payment_status public.fiatrampstatusenum,
    credit_transfer_id integer,
    token_id integer,
    payment_metadata jsonb
);


ALTER TABLE public.fiat_ramp OWNER TO postgres;

--
-- Name: fiat_ramp_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fiat_ramp_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fiat_ramp_id_seq OWNER TO postgres;

--
-- Name: fiat_ramp_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fiat_ramp_id_seq OWNED BY public.fiat_ramp.id;


--
-- Name: ip_address; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ip_address (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    _ip inet,
    country character varying,
    user_id integer
);


ALTER TABLE public.ip_address OWNER TO postgres;

--
-- Name: ip_address_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ip_address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ip_address_id_seq OWNER TO postgres;

--
-- Name: ip_address_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ip_address_id_seq OWNED BY public.ip_address.id;


--
-- Name: organisation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisation (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    name character varying,
    token_id integer,
    org_level_transfer_account_id integer,
    system_blockchain_address character varying,
    custom_welcome_message_key character varying,
    is_master boolean,
    primary_blockchain_address character varying,
    _timezone character varying,
    external_auth_username character varying,
    _external_auth_password character varying
);


ALTER TABLE public.organisation OWNER TO postgres;

--
-- Name: organisation_association_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.organisation_association_table (
    organisation_id integer,
    user_id integer,
    transfer_account_id integer,
    credit_transfer_id integer
);


ALTER TABLE public.organisation_association_table OWNER TO postgres;

--
-- Name: organisation_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.organisation_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.organisation_id_seq OWNER TO postgres;

--
-- Name: organisation_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.organisation_id_seq OWNED BY public.organisation.id;


--
-- Name: referrals; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.referrals (
    referred_user_id integer NOT NULL,
    referrer_user_id integer NOT NULL
);


ALTER TABLE public.referrals OWNER TO postgres;

--
-- Name: saved_filter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.saved_filter (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    name character varying,
    filter json,
    is_public boolean,
    organisation_id integer
);


ALTER TABLE public.saved_filter OWNER TO postgres;

--
-- Name: saved_filter_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.saved_filter_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.saved_filter_id_seq OWNER TO postgres;

--
-- Name: saved_filter_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.saved_filter_id_seq OWNED BY public.saved_filter.id;


--
-- Name: settings; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.settings (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    name character varying,
    type character varying,
    value json
);


ALTER TABLE public.settings OWNER TO postgres;

--
-- Name: settings_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.settings_id_seq OWNER TO postgres;

--
-- Name: settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.settings_id_seq OWNED BY public.settings.id;


--
-- Name: spend_approval; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.spend_approval (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    receiving_address character varying,
    token_id integer,
    giving_transfer_account_id integer,
    approval_task_uuid character varying,
    eth_send_task_uuid character varying
);


ALTER TABLE public.spend_approval OWNER TO postgres;

--
-- Name: spend_approval_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.spend_approval_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.spend_approval_id_seq OWNER TO postgres;

--
-- Name: spend_approval_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.spend_approval_id_seq OWNED BY public.spend_approval.id;


--
-- Name: token; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.token (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    address character varying,
    name character varying,
    symbol character varying,
    _decimals integer,
    token_type public.tokentype
);


ALTER TABLE public.token OWNER TO postgres;

--
-- Name: token_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.token_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.token_id_seq OWNER TO postgres;

--
-- Name: token_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.token_id_seq OWNED BY public.token.id;


--
-- Name: transfer_account; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transfer_account (
    id integer NOT NULL,
    created timestamp without time zone,
    is_approved boolean,
    is_vendor boolean,
    name character varying,
    payable_period_length integer,
    payable_period_type character varying,
    payable_epoch timestamp without time zone,
    is_beneficiary boolean,
    authorising_user_id integer,
    updated timestamp without time zone,
    organisation_id integer,
    token_id integer,
    blockchain_address character varying,
    account_type public.transferaccounttype,
    _balance_wei numeric(27,0),
    exchange_contract_id integer,
    is_public boolean,
    is_ghost boolean
);


ALTER TABLE public.transfer_account OWNER TO postgres;

--
-- Name: transfer_account_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transfer_account_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transfer_account_id_seq OWNER TO postgres;

--
-- Name: transfer_account_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transfer_account_id_seq OWNED BY public.transfer_account.id;


--
-- Name: transfer_card; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transfer_card (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    public_serial_number character varying NOT NULL,
    nfc_serial_number character varying,
    "PIN" character varying,
    _amount_loaded integer,
    amount_loaded_signature character varying,
    user_id integer,
    transfer_account_id integer
);


ALTER TABLE public.transfer_card OWNER TO postgres;

--
-- Name: transfer_card_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transfer_card_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transfer_card_id_seq OWNER TO postgres;

--
-- Name: transfer_card_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transfer_card_id_seq OWNED BY public.transfer_card.id;


--
-- Name: transfer_usage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transfer_usage (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    translations json,
    priority integer,
    is_cashout boolean,
    _icon character varying,
    "default" boolean,
    _name character varying
);


ALTER TABLE public.transfer_usage OWNER TO postgres;

--
-- Name: transfer_usage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.transfer_usage_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.transfer_usage_id_seq OWNER TO postgres;

--
-- Name: transfer_usage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.transfer_usage_id_seq OWNED BY public.transfer_usage.id;


--
-- Name: uploaded_resource; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.uploaded_resource (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    filename character varying,
    file_type character varying,
    user_filename character varying,
    reference character varying,
    credit_transfer_id integer,
    user_id integer,
    kyc_application_id integer
);


ALTER TABLE public.uploaded_resource OWNER TO postgres;

--
-- Name: uploaded_resource_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.uploaded_resource_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.uploaded_resource_id_seq OWNER TO postgres;

--
-- Name: uploaded_resource_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.uploaded_resource_id_seq OWNED BY public.uploaded_resource.id;


--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    created timestamp without time zone,
    email character varying,
    password_hash character varying(200),
    is_activated boolean,
    _phone character varying,
    one_time_code character varying,
    nfc_serial_number character varying,
    secret character varying,
    first_name character varying,
    last_name character varying,
    terms_accepted boolean,
    is_disabled boolean,
    _location character varying,
    lat double precision,
    lng double precision,
    authorising_user_id integer,
    updated timestamp without time zone,
    default_currency character varying,
    matched_profile_pictures json,
    _public_serial_number character varying,
    "_TFA_secret" character varying(128),
    "TFA_enabled" boolean,
    _last_seen timestamp without time zone,
    is_phone_verified boolean,
    _held_roles jsonb,
    default_organisation_id integer,
    is_self_sign_up boolean,
    preferred_language character varying,
    password_reset_tokens jsonb,
    default_transfer_account_id integer,
    business_usage_id integer,
    is_public boolean,
    primary_blockchain_address character varying,
    failed_pin_attempts integer,
    pin_hash character varying(200),
    pin_reset_tokens jsonb,
    seen_latest_terms boolean,
    is_market_enabled boolean
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.user_id_seq OWNER TO postgres;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_id_seq OWNED BY public."user".id;


--
-- Name: user_transfer_account_association_table; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_transfer_account_association_table (
    user_id integer,
    transfer_account_id integer
);


ALTER TABLE public.user_transfer_account_association_table OWNER TO postgres;

--
-- Name: ussd_menu; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ussd_menu (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    name character varying NOT NULL,
    description character varying,
    parent_id integer,
    display_key character varying NOT NULL
);


ALTER TABLE public.ussd_menu OWNER TO postgres;

--
-- Name: ussd_menu_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ussd_menu_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ussd_menu_id_seq OWNER TO postgres;

--
-- Name: ussd_menu_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ussd_menu_id_seq OWNED BY public.ussd_menu.id;


--
-- Name: ussd_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ussd_session (
    id integer NOT NULL,
    authorising_user_id integer,
    created timestamp without time zone,
    updated timestamp without time zone,
    session_id character varying NOT NULL,
    service_code character varying NOT NULL,
    msisdn character varying NOT NULL,
    user_input character varying,
    state character varying NOT NULL,
    session_data json,
    ussd_menu_id integer NOT NULL,
    user_id integer
);


ALTER TABLE public.ussd_session OWNER TO postgres;

--
-- Name: ussd_session_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ussd_session_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ussd_session_id_seq OWNER TO postgres;

--
-- Name: ussd_session_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ussd_session_id_seq OWNED BY public.ussd_session.id;


--
-- Name: bank_account id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_account ALTER COLUMN id SET DEFAULT nextval('public.bank_account_id_seq'::regclass);


--
-- Name: blacklist_tokens id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blacklist_tokens ALTER COLUMN id SET DEFAULT nextval('public.blacklist_tokens_id_seq'::regclass);


--
-- Name: blockchain_address id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_address ALTER COLUMN id SET DEFAULT nextval('public.blockchain_address_id_seq'::regclass);


--
-- Name: blockchain_transaction id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_transaction ALTER COLUMN id SET DEFAULT nextval('public.blockchain_transaction_id_seq'::regclass);


--
-- Name: credit_transfer id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_transfer ALTER COLUMN id SET DEFAULT nextval('public.credit_transfer_id_seq'::regclass);


--
-- Name: currency_conversion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency_conversion ALTER COLUMN id SET DEFAULT nextval('public.currency_conversion_id_seq'::regclass);


--
-- Name: custom_attribute id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.custom_attribute ALTER COLUMN id SET DEFAULT nextval('public.custom_attribute_id_seq'::regclass);


--
-- Name: custom_attribute_user_storage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.custom_attribute_user_storage ALTER COLUMN id SET DEFAULT nextval('public.custom_attribute_user_storage_id_seq'::regclass);


--
-- Name: device_info id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_info ALTER COLUMN id SET DEFAULT nextval('public.device_info_id_seq'::regclass);


--
-- Name: email_whitelist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_whitelist ALTER COLUMN id SET DEFAULT nextval('public.email_whitelist_id_seq'::regclass);


--
-- Name: exchange id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange ALTER COLUMN id SET DEFAULT nextval('public.exchange_id_seq'::regclass);


--
-- Name: exchange_contract id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange_contract ALTER COLUMN id SET DEFAULT nextval('public.exchange_contract_id_seq'::regclass);


--
-- Name: feedback id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback ALTER COLUMN id SET DEFAULT nextval('public.feedback_id_seq'::regclass);


--
-- Name: fiat_ramp id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fiat_ramp ALTER COLUMN id SET DEFAULT nextval('public.fiat_ramp_id_seq'::regclass);


--
-- Name: ip_address id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ip_address ALTER COLUMN id SET DEFAULT nextval('public.ip_address_id_seq'::regclass);


--
-- Name: kyc_application id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kyc_application ALTER COLUMN id SET DEFAULT nextval('public.business_verification_id_seq'::regclass);


--
-- Name: organisation id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation ALTER COLUMN id SET DEFAULT nextval('public.organisation_id_seq'::regclass);


--
-- Name: saved_filter id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_filter ALTER COLUMN id SET DEFAULT nextval('public.saved_filter_id_seq'::regclass);


--
-- Name: settings id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings ALTER COLUMN id SET DEFAULT nextval('public.settings_id_seq'::regclass);


--
-- Name: spend_approval id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spend_approval ALTER COLUMN id SET DEFAULT nextval('public.spend_approval_id_seq'::regclass);


--
-- Name: token id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token ALTER COLUMN id SET DEFAULT nextval('public.token_id_seq'::regclass);


--
-- Name: transfer_account id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_account ALTER COLUMN id SET DEFAULT nextval('public.transfer_account_id_seq'::regclass);


--
-- Name: transfer_card id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_card ALTER COLUMN id SET DEFAULT nextval('public.transfer_card_id_seq'::regclass);


--
-- Name: transfer_usage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_usage ALTER COLUMN id SET DEFAULT nextval('public.transfer_usage_id_seq'::regclass);


--
-- Name: uploaded_resource id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploaded_resource ALTER COLUMN id SET DEFAULT nextval('public.uploaded_resource_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user" ALTER COLUMN id SET DEFAULT nextval('public.user_id_seq'::regclass);


--
-- Name: ussd_menu id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ussd_menu ALTER COLUMN id SET DEFAULT nextval('public.ussd_menu_id_seq'::regclass);


--
-- Name: ussd_session id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ussd_session ALTER COLUMN id SET DEFAULT nextval('public.ussd_session_id_seq'::regclass);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: bank_account bank_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_account
    ADD CONSTRAINT bank_account_pkey PRIMARY KEY (id);


--
-- Name: blacklist_tokens blacklist_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blacklist_tokens
    ADD CONSTRAINT blacklist_tokens_pkey PRIMARY KEY (id);


--
-- Name: blacklist_tokens blacklist_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blacklist_tokens
    ADD CONSTRAINT blacklist_tokens_token_key UNIQUE (token);


--
-- Name: blockchain_address blockchain_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_address
    ADD CONSTRAINT blockchain_address_pkey PRIMARY KEY (id);


--
-- Name: blockchain_transaction blockchain_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_transaction
    ADD CONSTRAINT blockchain_transaction_pkey PRIMARY KEY (id);


--
-- Name: kyc_application business_verification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kyc_application
    ADD CONSTRAINT business_verification_pkey PRIMARY KEY (id);


--
-- Name: credit_transfer credit_transfer_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_transfer
    ADD CONSTRAINT credit_transfer_pkey PRIMARY KEY (id);


--
-- Name: credit_transfer credit_transfer_uuid_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_transfer
    ADD CONSTRAINT credit_transfer_uuid_key UNIQUE (uuid);


--
-- Name: currency_conversion currency_conversion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.currency_conversion
    ADD CONSTRAINT currency_conversion_pkey PRIMARY KEY (id);


--
-- Name: custom_attribute custom_attribute_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.custom_attribute
    ADD CONSTRAINT custom_attribute_pkey PRIMARY KEY (id);


--
-- Name: custom_attribute_user_storage custom_attribute_user_storage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.custom_attribute_user_storage
    ADD CONSTRAINT custom_attribute_user_storage_pkey PRIMARY KEY (id);


--
-- Name: device_info device_info_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_info
    ADD CONSTRAINT device_info_pkey PRIMARY KEY (id);


--
-- Name: email_whitelist email_whitelist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_whitelist
    ADD CONSTRAINT email_whitelist_pkey PRIMARY KEY (id);


--
-- Name: exchange_contract exchange_contract_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange_contract
    ADD CONSTRAINT exchange_contract_pkey PRIMARY KEY (id);


--
-- Name: exchange exchange_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange
    ADD CONSTRAINT exchange_pkey PRIMARY KEY (id);


--
-- Name: feedback feedback_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_pkey PRIMARY KEY (id);


--
-- Name: fiat_ramp fiat_ramp_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fiat_ramp
    ADD CONSTRAINT fiat_ramp_pkey PRIMARY KEY (id);


--
-- Name: ip_address ip_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ip_address
    ADD CONSTRAINT ip_address_pkey PRIMARY KEY (id);


--
-- Name: organisation organisation_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation
    ADD CONSTRAINT organisation_pkey PRIMARY KEY (id);


--
-- Name: referrals referrals_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_pkey PRIMARY KEY (referred_user_id, referrer_user_id);


--
-- Name: saved_filter saved_filter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_filter
    ADD CONSTRAINT saved_filter_pkey PRIMARY KEY (id);


--
-- Name: settings settings_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.settings
    ADD CONSTRAINT settings_pkey PRIMARY KEY (id);


--
-- Name: spend_approval spend_approval_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spend_approval
    ADD CONSTRAINT spend_approval_pkey PRIMARY KEY (id);


--
-- Name: token token_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.token
    ADD CONSTRAINT token_pkey PRIMARY KEY (id);


--
-- Name: transfer_account transfer_account_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_account
    ADD CONSTRAINT transfer_account_pkey PRIMARY KEY (id);


--
-- Name: transfer_card transfer_card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_card
    ADD CONSTRAINT transfer_card_pkey PRIMARY KEY (id);


--
-- Name: transfer_usage transfer_usage__name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_usage
    ADD CONSTRAINT transfer_usage__name_key UNIQUE (_name);


--
-- Name: transfer_usage transfer_usage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_usage
    ADD CONSTRAINT transfer_usage_pkey PRIMARY KEY (id);


--
-- Name: uploaded_resource uploaded_resource_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploaded_resource
    ADD CONSTRAINT uploaded_resource_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: ussd_menu ussd_menu_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ussd_menu
    ADD CONSTRAINT ussd_menu_pkey PRIMARY KEY (id);


--
-- Name: ussd_session ussd_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ussd_session
    ADD CONSTRAINT ussd_session_pkey PRIMARY KEY (id);


--
-- Name: ix_credit_transfer_sender_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_credit_transfer_sender_user_id ON public.credit_transfer USING btree (sender_user_id);


--
-- Name: ix_credit_transfer_transfer_type; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_credit_transfer_transfer_type ON public.credit_transfer USING btree (transfer_type);


--
-- Name: ix_exchange_contract_blockchain_address; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_exchange_contract_blockchain_address ON public.exchange_contract USING btree (blockchain_address);


--
-- Name: ix_exchange_contract_contract_registry_blockchain_address; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_exchange_contract_contract_registry_blockchain_address ON public.exchange_contract USING btree (contract_registry_blockchain_address);


--
-- Name: ix_organisation_is_master; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_organisation_is_master ON public.organisation USING btree (is_master);


--
-- Name: ix_token_address; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_token_address ON public.token USING btree (address);


--
-- Name: ix_transfer_card_public_serial_number; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_transfer_card_public_serial_number ON public.transfer_card USING btree (public_serial_number);


--
-- Name: ix_user__phone; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_user__phone ON public."user" USING btree (_phone);


--
-- Name: ix_ussd_menu_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_ussd_menu_name ON public.ussd_menu USING btree (name);


--
-- Name: ix_ussd_session_session_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_ussd_session_session_id ON public.ussd_session USING btree (session_id);


--
-- Name: updated_index; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX updated_index ON public.credit_transfer USING btree (updated);


--
-- Name: bank_account bank_account_kyc_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bank_account
    ADD CONSTRAINT bank_account_kyc_application_id_fkey FOREIGN KEY (kyc_application_id) REFERENCES public.kyc_application(id);


--
-- Name: blockchain_address blockchain_address_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_address
    ADD CONSTRAINT blockchain_address_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES public.organisation(id);


--
-- Name: blockchain_address blockchain_address_transfer_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_address
    ADD CONSTRAINT blockchain_address_transfer_account_id_fkey FOREIGN KEY (transfer_account_id) REFERENCES public.transfer_account(id);


--
-- Name: blockchain_transaction blockchain_transaction_credit_transfer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_transaction
    ADD CONSTRAINT blockchain_transaction_credit_transfer_id_fkey FOREIGN KEY (credit_transfer_id) REFERENCES public.credit_transfer(id);


--
-- Name: blockchain_transaction blockchain_transaction_signing_blockchain_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_transaction
    ADD CONSTRAINT blockchain_transaction_signing_blockchain_address_id_fkey FOREIGN KEY (signing_blockchain_address_id) REFERENCES public.blockchain_address(id);


--
-- Name: credit_transfer credit_transfer_recipient_blockchain_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_transfer
    ADD CONSTRAINT credit_transfer_recipient_blockchain_address_id_fkey FOREIGN KEY (recipient_blockchain_address_id) REFERENCES public.blockchain_address(id);


--
-- Name: credit_transfer credit_transfer_recipient_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_transfer
    ADD CONSTRAINT credit_transfer_recipient_id_fkey FOREIGN KEY (recipient_transfer_account_id) REFERENCES public.transfer_account(id);


--
-- Name: credit_transfer credit_transfer_recipient_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_transfer
    ADD CONSTRAINT credit_transfer_recipient_user_id_fkey FOREIGN KEY (recipient_user_id) REFERENCES public."user"(id);


--
-- Name: credit_transfer credit_transfer_sender_blockchain_address_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_transfer
    ADD CONSTRAINT credit_transfer_sender_blockchain_address_id_fkey FOREIGN KEY (sender_blockchain_address_id) REFERENCES public.blockchain_address(id);


--
-- Name: credit_transfer credit_transfer_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_transfer
    ADD CONSTRAINT credit_transfer_sender_id_fkey FOREIGN KEY (sender_transfer_account_id) REFERENCES public.transfer_account(id);


--
-- Name: credit_transfer credit_transfer_sender_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_transfer
    ADD CONSTRAINT credit_transfer_sender_user_id_fkey FOREIGN KEY (sender_user_id) REFERENCES public."user"(id);


--
-- Name: credit_transfer credit_transfer_token_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.credit_transfer
    ADD CONSTRAINT credit_transfer_token_id_fkey FOREIGN KEY (token_id) REFERENCES public.token(id);


--
-- Name: custom_attribute_user_storage custom_attribute_user_storage_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.custom_attribute_user_storage
    ADD CONSTRAINT custom_attribute_user_storage_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: device_info device_info_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.device_info
    ADD CONSTRAINT device_info_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: email_whitelist email_whitelist_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.email_whitelist
    ADD CONSTRAINT email_whitelist_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES public.organisation(id);


--
-- Name: exchange_contract exchange_contract_reserve_token_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange_contract
    ADD CONSTRAINT exchange_contract_reserve_token_id_fkey FOREIGN KEY (reserve_token_id) REFERENCES public.token(id);


--
-- Name: exchange_contract_token_association_table exchange_contract_token_association_t_exchange_contract_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange_contract_token_association_table
    ADD CONSTRAINT exchange_contract_token_association_t_exchange_contract_id_fkey FOREIGN KEY (exchange_contract_id) REFERENCES public.exchange_contract(id);


--
-- Name: exchange_contract_token_association_table exchange_contract_token_association_table_token_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange_contract_token_association_table
    ADD CONSTRAINT exchange_contract_token_association_table_token_id_fkey FOREIGN KEY (token_id) REFERENCES public.token(id);


--
-- Name: exchange exchange_from_token_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange
    ADD CONSTRAINT exchange_from_token_id_fkey FOREIGN KEY (from_token_id) REFERENCES public.token(id);


--
-- Name: exchange exchange_from_transfer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange
    ADD CONSTRAINT exchange_from_transfer_id_fkey FOREIGN KEY (from_transfer_id) REFERENCES public.credit_transfer(id);


--
-- Name: exchange exchange_to_token_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange
    ADD CONSTRAINT exchange_to_token_id_fkey FOREIGN KEY (to_token_id) REFERENCES public.token(id);


--
-- Name: exchange exchange_to_transfer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange
    ADD CONSTRAINT exchange_to_transfer_id_fkey FOREIGN KEY (to_transfer_id) REFERENCES public.credit_transfer(id);


--
-- Name: exchange exchange_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.exchange
    ADD CONSTRAINT exchange_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: feedback feedback_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.feedback
    ADD CONSTRAINT feedback_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: fiat_ramp fiat_ramp_credit_transfer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fiat_ramp
    ADD CONSTRAINT fiat_ramp_credit_transfer_id_fkey FOREIGN KEY (credit_transfer_id) REFERENCES public.credit_transfer(id);


--
-- Name: fiat_ramp fiat_ramp_token_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fiat_ramp
    ADD CONSTRAINT fiat_ramp_token_id_fkey FOREIGN KEY (token_id) REFERENCES public.token(id);


--
-- Name: organisation fk_org_level_account; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation
    ADD CONSTRAINT fk_org_level_account FOREIGN KEY (org_level_transfer_account_id) REFERENCES public.transfer_account(id);


--
-- Name: ip_address ip_address_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ip_address
    ADD CONSTRAINT ip_address_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: kyc_application kyc_application_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kyc_application
    ADD CONSTRAINT kyc_application_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES public.organisation(id);


--
-- Name: kyc_application kyc_application_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kyc_application
    ADD CONSTRAINT kyc_application_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: organisation_association_table organisation_association_table_credit_transfer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_association_table
    ADD CONSTRAINT organisation_association_table_credit_transfer_id_fkey FOREIGN KEY (credit_transfer_id) REFERENCES public.credit_transfer(id);


--
-- Name: organisation_association_table organisation_association_table_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_association_table
    ADD CONSTRAINT organisation_association_table_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES public.organisation(id);


--
-- Name: organisation_association_table organisation_association_table_transfer_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_association_table
    ADD CONSTRAINT organisation_association_table_transfer_account_id_fkey FOREIGN KEY (transfer_account_id) REFERENCES public.transfer_account(id);


--
-- Name: organisation_association_table organisation_association_table_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation_association_table
    ADD CONSTRAINT organisation_association_table_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: organisation organisation_token_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.organisation
    ADD CONSTRAINT organisation_token_id_fkey FOREIGN KEY (token_id) REFERENCES public.token(id);


--
-- Name: referrals referrals_referred_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_referred_user_id_fkey FOREIGN KEY (referred_user_id) REFERENCES public."user"(id);


--
-- Name: referrals referrals_referrer_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.referrals
    ADD CONSTRAINT referrals_referrer_user_id_fkey FOREIGN KEY (referrer_user_id) REFERENCES public."user"(id);


--
-- Name: saved_filter saved_filter_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.saved_filter
    ADD CONSTRAINT saved_filter_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES public.organisation(id);


--
-- Name: spend_approval spend_approval_giving_transfer_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spend_approval
    ADD CONSTRAINT spend_approval_giving_transfer_account_id_fkey FOREIGN KEY (giving_transfer_account_id) REFERENCES public.transfer_account(id);


--
-- Name: spend_approval spend_approval_token_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.spend_approval
    ADD CONSTRAINT spend_approval_token_id_fkey FOREIGN KEY (token_id) REFERENCES public.token(id);


--
-- Name: transfer_account transfer_account_exchange_contract_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_account
    ADD CONSTRAINT transfer_account_exchange_contract_id_fkey FOREIGN KEY (exchange_contract_id) REFERENCES public.exchange_contract(id);


--
-- Name: transfer_account transfer_account_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_account
    ADD CONSTRAINT transfer_account_organisation_id_fkey FOREIGN KEY (organisation_id) REFERENCES public.organisation(id);


--
-- Name: transfer_account transfer_account_token_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_account
    ADD CONSTRAINT transfer_account_token_id_fkey FOREIGN KEY (token_id) REFERENCES public.token(id);


--
-- Name: transfer_card transfer_card_transfer_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_card
    ADD CONSTRAINT transfer_card_transfer_account_id_fkey FOREIGN KEY (transfer_account_id) REFERENCES public.transfer_account(id);


--
-- Name: transfer_card transfer_card_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.transfer_card
    ADD CONSTRAINT transfer_card_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: uploaded_resource uploaded_resource_credit_transfer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploaded_resource
    ADD CONSTRAINT uploaded_resource_credit_transfer_id_fkey FOREIGN KEY (credit_transfer_id) REFERENCES public.credit_transfer(id);


--
-- Name: uploaded_resource uploaded_resource_kyc_application_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploaded_resource
    ADD CONSTRAINT uploaded_resource_kyc_application_id_fkey FOREIGN KEY (kyc_application_id) REFERENCES public.kyc_application(id);


--
-- Name: uploaded_resource uploaded_resource_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.uploaded_resource
    ADD CONSTRAINT uploaded_resource_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: user user_business_usage_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_business_usage_id_fkey FOREIGN KEY (business_usage_id) REFERENCES public.transfer_usage(id);


--
-- Name: user user_default_organisation_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_default_organisation_id_fkey FOREIGN KEY (default_organisation_id) REFERENCES public.organisation(id);


--
-- Name: user user_default_transfer_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_default_transfer_account_id_fkey FOREIGN KEY (default_transfer_account_id) REFERENCES public.transfer_account(id);


--
-- Name: user_transfer_account_association_table user_transfer_account_association_tabl_transfer_account_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_transfer_account_association_table
    ADD CONSTRAINT user_transfer_account_association_tabl_transfer_account_id_fkey FOREIGN KEY (transfer_account_id) REFERENCES public.transfer_account(id);


--
-- Name: user_transfer_account_association_table user_transfer_account_association_table_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_transfer_account_association_table
    ADD CONSTRAINT user_transfer_account_association_table_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: ussd_session ussd_session_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ussd_session
    ADD CONSTRAINT ussd_session_user_id_fkey FOREIGN KEY (user_id) REFERENCES public."user"(id);


--
-- Name: ussd_session ussd_session_ussd_menu_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ussd_session
    ADD CONSTRAINT ussd_session_ussd_menu_id_fkey FOREIGN KEY (ussd_menu_id) REFERENCES public.ussd_menu(id);


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA public TO read_only;
GRANT USAGE ON SCHEMA public TO accenture;


--
-- Name: TABLE alembic_version; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.alembic_version TO read_only;


--
-- Name: TABLE bank_account; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.bank_account TO read_only;


--
-- Name: TABLE blacklist_tokens; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.blacklist_tokens TO read_only;


--
-- Name: TABLE blockchain_address; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.blockchain_address TO read_only;


--
-- Name: TABLE blockchain_transaction; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.blockchain_transaction TO read_only;


--
-- Name: TABLE kyc_application; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.kyc_application TO read_only;


--
-- Name: TABLE credit_transfer; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.credit_transfer TO read_only;


--
-- Name: COLUMN credit_transfer.id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(id) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.created; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(created) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.resolved_date; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(resolved_date) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.transfer_type; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(transfer_type) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.transfer_mode; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(transfer_mode) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.transfer_status; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(transfer_status) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.sender_transfer_account_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(sender_transfer_account_id) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.recipient_transfer_account_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(recipient_transfer_account_id) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.recipient_user_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(recipient_user_id) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.sender_user_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(sender_user_id) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.resolution_message; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(resolution_message) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.authorising_user_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(authorising_user_id) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.updated; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(updated) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.recipient_blockchain_address_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(recipient_blockchain_address_id) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.sender_blockchain_address_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(sender_blockchain_address_id) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.transfer_use; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(transfer_use) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.uuid; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(uuid) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.token_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(token_id) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.transfer_subtype; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(transfer_subtype) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer._transfer_amount_wei; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(_transfer_amount_wei) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.is_public; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(is_public) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.blockchain_task_uuid; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(blockchain_task_uuid) ON TABLE public.credit_transfer TO accenture;


--
-- Name: COLUMN credit_transfer.exclude_from_limit_calcs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(exclude_from_limit_calcs) ON TABLE public.credit_transfer TO accenture;


--
-- Name: TABLE currency_conversion; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.currency_conversion TO read_only;


--
-- Name: TABLE custom_attribute; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.custom_attribute TO read_only;


--
-- Name: TABLE custom_attribute_user_storage; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.custom_attribute_user_storage TO read_only;


--
-- Name: TABLE device_info; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.device_info TO read_only;


--
-- Name: TABLE email_whitelist; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.email_whitelist TO read_only;


--
-- Name: TABLE exchange; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.exchange TO read_only;
GRANT SELECT ON TABLE public.exchange TO accenture;


--
-- Name: TABLE exchange_contract; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.exchange_contract TO read_only;
GRANT SELECT ON TABLE public.exchange_contract TO accenture;


--
-- Name: TABLE exchange_contract_token_association_table; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.exchange_contract_token_association_table TO read_only;
GRANT SELECT ON TABLE public.exchange_contract_token_association_table TO accenture;


--
-- Name: TABLE feedback; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.feedback TO read_only;


--
-- Name: TABLE fiat_ramp; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.fiat_ramp TO read_only;


--
-- Name: TABLE ip_address; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.ip_address TO read_only;


--
-- Name: TABLE organisation; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.organisation TO read_only;


--
-- Name: COLUMN organisation.id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(id) ON TABLE public.organisation TO accenture;


--
-- Name: COLUMN organisation.authorising_user_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(authorising_user_id) ON TABLE public.organisation TO accenture;


--
-- Name: COLUMN organisation.created; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(created) ON TABLE public.organisation TO accenture;


--
-- Name: COLUMN organisation.updated; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(updated) ON TABLE public.organisation TO accenture;


--
-- Name: COLUMN organisation.name; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(name) ON TABLE public.organisation TO accenture;


--
-- Name: COLUMN organisation.token_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(token_id) ON TABLE public.organisation TO accenture;


--
-- Name: COLUMN organisation.org_level_transfer_account_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(org_level_transfer_account_id) ON TABLE public.organisation TO accenture;


--
-- Name: COLUMN organisation.system_blockchain_address; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(system_blockchain_address) ON TABLE public.organisation TO accenture;


--
-- Name: COLUMN organisation.custom_welcome_message_key; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(custom_welcome_message_key) ON TABLE public.organisation TO accenture;


--
-- Name: COLUMN organisation.is_master; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(is_master) ON TABLE public.organisation TO accenture;


--
-- Name: COLUMN organisation.primary_blockchain_address; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(primary_blockchain_address) ON TABLE public.organisation TO accenture;


--
-- Name: COLUMN organisation._timezone; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(_timezone) ON TABLE public.organisation TO accenture;


--
-- Name: TABLE organisation_association_table; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.organisation_association_table TO read_only;
GRANT SELECT ON TABLE public.organisation_association_table TO accenture;


--
-- Name: TABLE referrals; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.referrals TO read_only;


--
-- Name: TABLE saved_filter; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.saved_filter TO read_only;


--
-- Name: TABLE settings; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.settings TO read_only;


--
-- Name: TABLE spend_approval; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.spend_approval TO read_only;


--
-- Name: COLUMN spend_approval.receiving_address; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(receiving_address) ON TABLE public.spend_approval TO read_only;


--
-- Name: TABLE token; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.token TO read_only;
GRANT SELECT ON TABLE public.token TO accenture;


--
-- Name: TABLE transfer_account; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.transfer_account TO read_only;


--
-- Name: COLUMN transfer_account.id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(id) ON TABLE public.transfer_account TO accenture;


--
-- Name: COLUMN transfer_account.created; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(created) ON TABLE public.transfer_account TO accenture;


--
-- Name: COLUMN transfer_account.is_approved; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(is_approved) ON TABLE public.transfer_account TO accenture;


--
-- Name: COLUMN transfer_account.is_vendor; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(is_vendor) ON TABLE public.transfer_account TO accenture;


--
-- Name: COLUMN transfer_account.is_beneficiary; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(is_beneficiary) ON TABLE public.transfer_account TO accenture;


--
-- Name: COLUMN transfer_account.authorising_user_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(authorising_user_id) ON TABLE public.transfer_account TO accenture;


--
-- Name: COLUMN transfer_account.updated; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(updated) ON TABLE public.transfer_account TO accenture;


--
-- Name: COLUMN transfer_account.organisation_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(organisation_id) ON TABLE public.transfer_account TO accenture;


--
-- Name: COLUMN transfer_account.token_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(token_id) ON TABLE public.transfer_account TO accenture;


--
-- Name: COLUMN transfer_account.blockchain_address; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(blockchain_address) ON TABLE public.transfer_account TO accenture;


--
-- Name: COLUMN transfer_account.account_type; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(account_type) ON TABLE public.transfer_account TO accenture;


--
-- Name: COLUMN transfer_account._balance_wei; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(_balance_wei) ON TABLE public.transfer_account TO accenture;


--
-- Name: COLUMN transfer_account.exchange_contract_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(exchange_contract_id) ON TABLE public.transfer_account TO accenture;


--
-- Name: COLUMN transfer_account.is_public; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(is_public) ON TABLE public.transfer_account TO accenture;


--
-- Name: COLUMN transfer_account.is_ghost; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(is_ghost) ON TABLE public.transfer_account TO accenture;


--
-- Name: TABLE transfer_card; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.transfer_card TO read_only;


--
-- Name: TABLE transfer_usage; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.transfer_usage TO read_only;
GRANT SELECT ON TABLE public.transfer_usage TO accenture;


--
-- Name: TABLE uploaded_resource; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.uploaded_resource TO read_only;


--
-- Name: TABLE "user"; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public."user" TO read_only;


--
-- Name: COLUMN "user".id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(id) ON TABLE public."user" TO accenture;


--
-- Name: COLUMN "user".created; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(created) ON TABLE public."user" TO accenture;


--
-- Name: COLUMN "user".is_activated; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(is_activated) ON TABLE public."user" TO accenture;


--
-- Name: COLUMN "user".updated; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(updated) ON TABLE public."user" TO accenture;


--
-- Name: COLUMN "user".default_currency; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(default_currency) ON TABLE public."user" TO accenture;


--
-- Name: COLUMN "user".is_phone_verified; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(is_phone_verified) ON TABLE public."user" TO accenture;


--
-- Name: COLUMN "user".default_organisation_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(default_organisation_id) ON TABLE public."user" TO accenture;


--
-- Name: COLUMN "user".preferred_language; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(preferred_language) ON TABLE public."user" TO accenture;


--
-- Name: COLUMN "user".default_transfer_account_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(default_transfer_account_id) ON TABLE public."user" TO accenture;


--
-- Name: COLUMN "user".business_usage_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(business_usage_id) ON TABLE public."user" TO accenture;


--
-- Name: COLUMN "user".is_public; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(is_public) ON TABLE public."user" TO accenture;


--
-- Name: COLUMN "user".primary_blockchain_address; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(primary_blockchain_address) ON TABLE public."user" TO accenture;


--
-- Name: COLUMN "user".is_market_enabled; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT(is_market_enabled) ON TABLE public."user" TO accenture;


--
-- Name: TABLE user_transfer_account_association_table; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.user_transfer_account_association_table TO read_only;
GRANT SELECT ON TABLE public.user_transfer_account_association_table TO accenture;


--
-- Name: TABLE ussd_menu; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.ussd_menu TO read_only;
GRANT SELECT ON TABLE public.ussd_menu TO accenture;


--
-- Name: TABLE ussd_session; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.ussd_session TO read_only;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public REVOKE ALL ON TABLES  FROM postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT SELECT ON TABLES  TO read_only;


--
-- PostgreSQL database dump complete
--

