--
-- PostgreSQL database dump
--

-- Dumped from database version 10.1
-- Dumped by pg_dump version 10.1

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = public, pg_catalog;

--
-- Name: users_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_seq OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users (
    id integer DEFAULT nextval('users_seq'::regclass) NOT NULL,
    email character varying(249) NOT NULL,
    password character varying(255) NOT NULL,
    username character varying(100) DEFAULT NULL::character varying,
    status smallint DEFAULT '0'::smallint NOT NULL,
    verified smallint DEFAULT '0'::smallint NOT NULL,
    resettable smallint DEFAULT '1'::smallint NOT NULL,
    roles_mask integer DEFAULT 0 NOT NULL,
    registered integer NOT NULL,
    last_login integer,
    CONSTRAINT users_id_check CHECK ((id > 0)),
    CONSTRAINT users_last_login_check CHECK ((last_login > 0)),
    CONSTRAINT users_registered_check CHECK ((registered > 0)),
    CONSTRAINT users_resettable_check CHECK ((resettable > 0))
);


ALTER TABLE users OWNER TO postgres;

--
-- Name: users_confirmations_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_confirmations_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_confirmations_seq OWNER TO postgres;

--
-- Name: users_confirmations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users_confirmations (
    id integer DEFAULT nextval('users_confirmations_seq'::regclass) NOT NULL,
    user_id integer NOT NULL,
    email character varying(249) NOT NULL,
    selector character varying(16) NOT NULL,
    token character varying(255) NOT NULL,
    expires integer NOT NULL,
    CONSTRAINT users_confirmations_expires_check CHECK ((expires > 0)),
    CONSTRAINT users_confirmations_id_check CHECK ((id > 0)),
    CONSTRAINT users_confirmations_user_id_check CHECK ((user_id > 0))
);


ALTER TABLE users_confirmations OWNER TO postgres;

--
-- Name: users_remembered_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_remembered_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_remembered_seq OWNER TO postgres;

--
-- Name: users_remembered; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users_remembered (
    id integer DEFAULT nextval('users_remembered_seq'::regclass) NOT NULL,
    user integer NOT NULL,
    selector character varying(24) NOT NULL,
    token character varying(255) NOT NULL,
    expires integer NOT NULL,
    CONSTRAINT users_remembered_expires_check CHECK ((expires > 0)),
    CONSTRAINT users_remembered_id_check CHECK ((id > 0)),
    CONSTRAINT users_remembered_user_id_check CHECK ((user_id > 0))
);


ALTER TABLE users_remembered OWNER TO postgres;

--
-- Name: users_resets_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_resets_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE users_resets_seq OWNER TO postgres;

--
-- Name: users_resets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users_resets (
    id integer DEFAULT nextval('users_resets_seq'::regclass) NOT NULL,
    user integer NOT NULL,
    selector character varying(20) NOT NULL,
    token character varying(255) NOT NULL,
    expires integer NOT NULL,
    CONSTRAINT users_resets_expires_check CHECK ((expires > 0)),
    CONSTRAINT users_resets_id_check CHECK ((id > 0)),
    CONSTRAINT users_resets_user_id_check CHECK ((user_id > 0))
);


ALTER TABLE users_resets OWNER TO postgres;

--
-- Name: users_throttling; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE users_throttling (
    bucket character varying(44) NOT NULL,
    tokens double precision NOT NULL,
    replenished_at integer NOT NULL,
    expires_at integer NOT NULL,
    CONSTRAINT users_throttling_expires_at_check CHECK ((expires_at > 0)),
    CONSTRAINT users_throttling_replenished_at_check CHECK ((replenished_at > 0)),
    CONSTRAINT users_throttling_tokens_check CHECK ((tokens > (0)::double precision))
);


ALTER TABLE users_throttling OWNER TO postgres;

--
-- Name: users email; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT email UNIQUE (email);


--
-- Name: users_confirmations users_confirmations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_confirmations
    ADD CONSTRAINT users_confirmations_pkey PRIMARY KEY (id);


--
-- Name: users_confirmations users_confirmations_selector_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_confirmations
    ADD CONSTRAINT users_confirmations_selector_key UNIQUE (selector);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users_remembered users_remembered_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_remembered
    ADD CONSTRAINT users_remembered_pkey PRIMARY KEY (id);


--
-- Name: users_remembered users_remembered_selector_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_remembered
    ADD CONSTRAINT users_remembered_selector_key UNIQUE (selector);


--
-- Name: users_resets users_resets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_resets
    ADD CONSTRAINT users_resets_pkey PRIMARY KEY (id);


--
-- Name: users_resets users_resets_selector_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_resets
    ADD CONSTRAINT users_resets_selector_key UNIQUE (selector);


--
-- Name: users_throttling users_throttling_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users_throttling
    ADD CONSTRAINT users_throttling_pkey PRIMARY KEY (bucket);


--
-- Name: email_expires; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX email_expires ON users_confirmations USING btree (email, expires);


--
-- Name: expires_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX expires_at ON users_throttling USING btree (expires_at);


--
-- Name: user_expires; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_expires ON users_resets USING btree (user_id, expires);


--
-- Name: user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX user_id ON users_confirmations USING btree (user_id);


--
-- Name: users_remember; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_remember ON users_remembered USING btree (user_id);


--
-- PostgreSQL database dump complete
--
