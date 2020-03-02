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

SET default_tablespace = '';

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: blockchain_wallet; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blockchain_wallet (
    id integer NOT NULL,
    created timestamp without time zone,
    updated timestamp without time zone,
    address character varying,
    _encrypted_private_key character varying,
    wei_topup_threshold bigint,
    wei_target_balance bigint,
    last_topup_task_uuid character varying
);


ALTER TABLE public.blockchain_wallet OWNER TO postgres;

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

ALTER SEQUENCE public.blockchain_address_id_seq OWNED BY public.blockchain_wallet.id;


--
-- Name: blockchain_task; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blockchain_task (
    id integer NOT NULL,
    created timestamp without time zone,
    updated timestamp without time zone,
    function character varying,
    args json,
    kwargs json,
    is_send_eth boolean,
    recipient_address character varying,
    gas_limit bigint,
    signing_wallet_id integer,
    abi_type character varying,
    _type character varying,
    contract_address character varying,
    contract_name character varying,
    _amount numeric(27,0),
    uuid character varying,
    status_text character varying,
    previous_invocations integer
);


ALTER TABLE public.blockchain_task OWNER TO postgres;

--
-- Name: blockchain_task_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.blockchain_task_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.blockchain_task_id_seq OWNER TO postgres;

--
-- Name: blockchain_task_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.blockchain_task_id_seq OWNED BY public.blockchain_task.id;


--
-- Name: blockchain_transaction; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.blockchain_transaction (
    id integer NOT NULL,
    created timestamp without time zone,
    updated timestamp without time zone,
    _status character varying,
    error character varying,
    message character varying,
    block integer,
    submitted_date timestamp without time zone,
    mined_date timestamp without time zone,
    hash character varying,
    nonce integer,
    nonce_consumed boolean,
    blockchain_task_id integer,
    signing_wallet_id integer,
    ignore boolean,
    contract_address character varying,
    first_block_hash character varying
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
-- Name: task_dependencies; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.task_dependencies (
    posterior_task_id integer NOT NULL,
    prior_task_id integer NOT NULL
);


ALTER TABLE public.task_dependencies OWNER TO postgres;

--
-- Name: blockchain_task id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_task ALTER COLUMN id SET DEFAULT nextval('public.blockchain_task_id_seq'::regclass);


--
-- Name: blockchain_transaction id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_transaction ALTER COLUMN id SET DEFAULT nextval('public.blockchain_transaction_id_seq'::regclass);


--
-- Name: blockchain_wallet id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_wallet ALTER COLUMN id SET DEFAULT nextval('public.blockchain_address_id_seq'::regclass);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: blockchain_wallet blockchain_address_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_wallet
    ADD CONSTRAINT blockchain_address_pkey PRIMARY KEY (id);


--
-- Name: blockchain_task blockchain_task_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_task
    ADD CONSTRAINT blockchain_task_pkey PRIMARY KEY (id);


--
-- Name: blockchain_transaction blockchain_transaction_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_transaction
    ADD CONSTRAINT blockchain_transaction_pkey PRIMARY KEY (id);


--
-- Name: ix_blockchain_task_uuid; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_blockchain_task_uuid ON public.blockchain_task USING btree (uuid);


--
-- Name: ix_blockchain_wallet_address; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_blockchain_wallet_address ON public.blockchain_wallet USING btree (address);


--
-- Name: blockchain_task blockchain_task_signing_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_task
    ADD CONSTRAINT blockchain_task_signing_wallet_id_fkey FOREIGN KEY (signing_wallet_id) REFERENCES public.blockchain_wallet(id);


--
-- Name: blockchain_transaction blockchain_transaction_blockchain_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_transaction
    ADD CONSTRAINT blockchain_transaction_blockchain_task_id_fkey FOREIGN KEY (blockchain_task_id) REFERENCES public.blockchain_task(id);


--
-- Name: blockchain_transaction blockchain_transaction_signing_wallet_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.blockchain_transaction
    ADD CONSTRAINT blockchain_transaction_signing_wallet_id_fkey FOREIGN KEY (signing_wallet_id) REFERENCES public.blockchain_wallet(id);


--
-- Name: task_dependencies task_dependencies_posterior_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_dependencies
    ADD CONSTRAINT task_dependencies_posterior_task_id_fkey FOREIGN KEY (posterior_task_id) REFERENCES public.blockchain_task(id);


--
-- Name: task_dependencies task_dependencies_prior_task_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.task_dependencies
    ADD CONSTRAINT task_dependencies_prior_task_id_fkey FOREIGN KEY (prior_task_id) REFERENCES public.blockchain_task(id);


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
-- Name: TABLE blockchain_wallet; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.blockchain_wallet TO read_only;


--
-- Name: TABLE blockchain_task; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.blockchain_task TO read_only;
GRANT SELECT ON TABLE public.blockchain_task TO accenture;


--
-- Name: TABLE blockchain_transaction; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.blockchain_transaction TO read_only;
GRANT SELECT ON TABLE public.blockchain_transaction TO accenture;


--
-- Name: TABLE task_dependencies; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT ON TABLE public.task_dependencies TO read_only;
GRANT SELECT ON TABLE public.task_dependencies TO accenture;


--
-- PostgreSQL database dump complete
--

