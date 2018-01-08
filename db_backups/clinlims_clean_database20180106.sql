--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: clinlims; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE clinlims WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'en_GB.UTF-8' LC_CTYPE = 'en_GB.UTF-8';


ALTER DATABASE clinlims OWNER TO postgres;

\connect clinlims

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: clinlims; Type: SCHEMA; Schema: -; Owner: clinlims
--

CREATE SCHEMA clinlims;


ALTER SCHEMA clinlims OWNER TO clinlims;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


SET search_path = public, pg_catalog;

--
-- Name: breakpoint; Type: TYPE; Schema: public; Owner: clinlims
--

CREATE TYPE breakpoint AS (
	func oid,
	linenumber integer,
	targetname text
);


ALTER TYPE public.breakpoint OWNER TO clinlims;

--
-- Name: dblink_pkey_results; Type: TYPE; Schema: public; Owner: clinlims
--

CREATE TYPE dblink_pkey_results AS (
	"position" integer,
	colname text
);


ALTER TYPE public.dblink_pkey_results OWNER TO clinlims;

--
-- Name: frame; Type: TYPE; Schema: public; Owner: clinlims
--

CREATE TYPE frame AS (
	level integer,
	targetname text,
	func oid,
	linenumber integer,
	args text
);


ALTER TYPE public.frame OWNER TO clinlims;

--
-- Name: proxyinfo; Type: TYPE; Schema: public; Owner: clinlims
--

CREATE TYPE proxyinfo AS (
	serverversionstr text,
	serverversionnum integer,
	proxyapiver integer,
	serverprocessid integer
);


ALTER TYPE public.proxyinfo OWNER TO clinlims;

--
-- Name: tablefunc_crosstab_2; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tablefunc_crosstab_2 AS (
	row_name text,
	category_1 text,
	category_2 text
);


ALTER TYPE public.tablefunc_crosstab_2 OWNER TO postgres;

--
-- Name: tablefunc_crosstab_3; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tablefunc_crosstab_3 AS (
	row_name text,
	category_1 text,
	category_2 text,
	category_3 text
);


ALTER TYPE public.tablefunc_crosstab_3 OWNER TO postgres;

--
-- Name: tablefunc_crosstab_4; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE tablefunc_crosstab_4 AS (
	row_name text,
	category_1 text,
	category_2 text,
	category_3 text,
	category_4 text
);


ALTER TYPE public.tablefunc_crosstab_4 OWNER TO postgres;

--
-- Name: targetinfo; Type: TYPE; Schema: public; Owner: clinlims
--

CREATE TYPE targetinfo AS (
	target oid,
	schema oid,
	nargs integer,
	argtypes oidvector,
	targetname name,
	argmodes "char"[],
	argnames text[],
	targetlang oid,
	fqname text,
	returnsset boolean,
	returntype oid
);


ALTER TYPE public.targetinfo OWNER TO clinlims;

--
-- Name: var; Type: TYPE; Schema: public; Owner: clinlims
--

CREATE TYPE var AS (
	name text,
	varclass character(1),
	linenumber integer,
	isunique boolean,
	isconst boolean,
	isnotnull boolean,
	dtype oid,
	value text
);


ALTER TYPE public.var OWNER TO clinlims;

--
-- Name: xpath_list(text, text); Type: FUNCTION; Schema: public; Owner: clinlims
--

CREATE FUNCTION xpath_list(text, text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT xpath_list($1,$2,',')$_$;


ALTER FUNCTION public.xpath_list(text, text) OWNER TO clinlims;

--
-- Name: xpath_nodeset(text, text); Type: FUNCTION; Schema: public; Owner: clinlims
--

CREATE FUNCTION xpath_nodeset(text, text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT xpath_nodeset($1,$2,'','')$_$;


ALTER FUNCTION public.xpath_nodeset(text, text) OWNER TO clinlims;

--
-- Name: xpath_nodeset(text, text, text); Type: FUNCTION; Schema: public; Owner: clinlims
--

CREATE FUNCTION xpath_nodeset(text, text, text) RETURNS text
    LANGUAGE sql IMMUTABLE STRICT
    AS $_$SELECT xpath_nodeset($1,$2,'',$3)$_$;


ALTER FUNCTION public.xpath_nodeset(text, text, text) OWNER TO clinlims;

SET search_path = clinlims, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: action; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE action (
    id numeric(10,0) NOT NULL,
    code character varying(10) NOT NULL,
    description character varying(256) NOT NULL,
    type character varying(10) NOT NULL,
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.action OWNER TO clinlims;

--
-- Name: action_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE action_seq
    START WITH 45
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.action_seq OWNER TO clinlims;

--
-- Name: address_part; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE address_part (
    id numeric(10,0) NOT NULL,
    part_name character varying(20) NOT NULL,
    display_order numeric(4,0),
    display_key character varying(20),
    type character(1) DEFAULT 'T'::bpchar NOT NULL
);


ALTER TABLE clinlims.address_part OWNER TO clinlims;

--
-- Name: TABLE address_part; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE address_part IS 'Holds the different parts of an address';


--
-- Name: COLUMN address_part.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN address_part.id IS 'Unique id genereated from address_part seq';


--
-- Name: COLUMN address_part.part_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN address_part.part_name IS 'What part of the address is this, street, commune state etc.';


--
-- Name: COLUMN address_part.display_order; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN address_part.display_order IS 'The order in which they are listed in the standardard address format';


--
-- Name: COLUMN address_part.display_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN address_part.display_key IS 'The display key for localization';


--
-- Name: address_part_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE address_part_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.address_part_seq OWNER TO clinlims;

--
-- Name: analysis; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE analysis (
    id numeric(10,0) NOT NULL,
    sampitem_id numeric(10,0),
    test_sect_id numeric(10,0),
    test_id numeric(10,0),
    revision numeric,
    status character varying(1),
    started_date timestamp without time zone,
    completed_date timestamp without time zone,
    released_date timestamp without time zone,
    printed_date timestamp without time zone,
    is_reportable character varying(1),
    so_send_ready_date timestamp without time zone,
    so_client_reference character varying(240),
    so_notify_received_date timestamp without time zone,
    so_notify_send_date timestamp without time zone,
    so_send_date timestamp without time zone,
    so_send_entry_by character varying(240),
    so_send_entry_date timestamp without time zone,
    analysis_type character varying(10) NOT NULL,
    lastupdated timestamp(6) without time zone,
    parent_analysis_id numeric(10,0),
    parent_result_id numeric(10,0),
    reflex_trigger boolean DEFAULT false,
    status_id numeric(10,0),
    entry_date timestamp with time zone,
    panel_id numeric(10,0),
    comment character varying(1024)
);


ALTER TABLE clinlims.analysis OWNER TO clinlims;

--
-- Name: COLUMN analysis.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.id IS 'Sequential number';


--
-- Name: COLUMN analysis.sampitem_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.sampitem_id IS 'Sample source write in if not already defined';


--
-- Name: COLUMN analysis.test_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.test_id IS 'Sequential value assigned on insert';


--
-- Name: COLUMN analysis.revision; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.revision IS 'revision number';


--
-- Name: COLUMN analysis.status; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.status IS 'Analysis Status; logged in, initiated, completed, released';


--
-- Name: COLUMN analysis.started_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.started_date IS 'Date and time analysis started';


--
-- Name: COLUMN analysis.completed_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.completed_date IS 'Date and time analysis completed';


--
-- Name: COLUMN analysis.released_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.released_date IS 'Date and time analysis was released; basically verified and ready to report';


--
-- Name: COLUMN analysis.printed_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.printed_date IS 'Date and time analysis was last printed for sending out';


--
-- Name: COLUMN analysis.is_reportable; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.is_reportable IS 'Indicates if this analysis should be reported';


--
-- Name: COLUMN analysis.so_send_ready_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.so_send_ready_date IS 'Send out ready date';


--
-- Name: COLUMN analysis.so_notify_received_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.so_notify_received_date IS 'Date that send out facility notificed MDH that they had received the specimen';


--
-- Name: COLUMN analysis.so_notify_send_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.so_notify_send_date IS 'Date that MDH sent out the specimen to a sendout facility';


--
-- Name: COLUMN analysis.so_send_entry_by; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.so_send_entry_by IS 'User name who entered sendout';


--
-- Name: COLUMN analysis.reflex_trigger; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.reflex_trigger IS 'True if this analysis has triggered a reflex test';


--
-- Name: COLUMN analysis.status_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.status_id IS 'foriegn key to status of analysis ';


--
-- Name: COLUMN analysis.entry_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.entry_date IS 'Date on which the results for this analysis was first entered';


--
-- Name: COLUMN analysis.panel_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis.panel_id IS 'If this analysis is part of a panel then this is the id';


--
-- Name: analysis_qaevent; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE analysis_qaevent (
    id numeric(10,0) NOT NULL,
    qa_event_id numeric(10,0),
    analysis_id numeric(10,0),
    lastupdated timestamp(6) without time zone,
    completed_date timestamp without time zone
);


ALTER TABLE clinlims.analysis_qaevent OWNER TO clinlims;

--
-- Name: analysis_qaevent_action; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE analysis_qaevent_action (
    id numeric(10,0) NOT NULL,
    analysis_qaevent_id numeric(10,0) NOT NULL,
    action_id numeric(10,0) NOT NULL,
    created_date timestamp without time zone NOT NULL,
    lastupdated timestamp(6) without time zone,
    sys_user_id numeric(10,0)
);


ALTER TABLE clinlims.analysis_qaevent_action OWNER TO clinlims;

--
-- Name: analysis_qaevent_action_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE analysis_qaevent_action_seq
    START WITH 221
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.analysis_qaevent_action_seq OWNER TO clinlims;

--
-- Name: analysis_qaevent_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE analysis_qaevent_seq
    START WITH 326
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.analysis_qaevent_seq OWNER TO clinlims;

--
-- Name: analysis_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE analysis_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.analysis_seq OWNER TO clinlims;

--
-- Name: analysis_storages; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE analysis_storages (
    id numeric(10,0) NOT NULL,
    storage_id numeric(10,0),
    checkin timestamp without time zone,
    checkout timestamp without time zone,
    analysis_id numeric(10,0)
);


ALTER TABLE clinlims.analysis_storages OWNER TO clinlims;

--
-- Name: COLUMN analysis_storages.checkin; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis_storages.checkin IS 'Date and time sample was moved to this storage_location';


--
-- Name: COLUMN analysis_storages.checkout; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis_storages.checkout IS 'Date and time sample was removed from this storage location';


--
-- Name: analysis_users; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE analysis_users (
    id numeric(10,0) NOT NULL,
    action character varying(1),
    analysis_id numeric(10,0),
    system_user_id numeric(10,0)
);


ALTER TABLE clinlims.analysis_users OWNER TO clinlims;

--
-- Name: COLUMN analysis_users.action; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analysis_users.action IS 'Type of action performed such as test request, complete, release';


--
-- Name: analyte; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE analyte (
    id numeric(10,0) NOT NULL,
    analyte_id numeric(10,0),
    name character varying(60),
    is_active character varying(1),
    external_id character varying(20),
    lastupdated timestamp(6) without time zone,
    local_abbrev character varying(10)
);


ALTER TABLE clinlims.analyte OWNER TO clinlims;

--
-- Name: COLUMN analyte.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyte.name IS 'Name of analyte';


--
-- Name: COLUMN analyte.is_active; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyte.is_active IS 'Flag indicating if the test is active';


--
-- Name: COLUMN analyte.external_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyte.external_id IS 'External ID such as CAS #';


--
-- Name: analyte_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE analyte_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.analyte_seq OWNER TO clinlims;

--
-- Name: analyzer; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE analyzer (
    id numeric(10,0) NOT NULL,
    scrip_id numeric(10,0),
    name character varying(20),
    machine_id character varying(20),
    description character varying(60),
    analyzer_type character varying(30),
    is_active boolean,
    location character varying(60),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.analyzer OWNER TO clinlims;

--
-- Name: COLUMN analyzer.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer.name IS 'Short name for analyzer';


--
-- Name: COLUMN analyzer.machine_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer.machine_id IS 'id which uniquely matches a machine, descriminates between duplicate analyzers';


--
-- Name: COLUMN analyzer.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer.description IS 'analyzer description';


--
-- Name: COLUMN analyzer.analyzer_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer.analyzer_type IS 'Type of analyzer: Mass Spec, HPLC, etc.';


--
-- Name: COLUMN analyzer.is_active; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer.is_active IS 'Flag indicating if the analyzer is active';


--
-- Name: COLUMN analyzer.location; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer.location IS 'Location of analyzer';


--
-- Name: analyzer_result_status; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE analyzer_result_status (
    id numeric(10,0) NOT NULL,
    name character varying(30) NOT NULL,
    description character varying(60)
);


ALTER TABLE clinlims.analyzer_result_status OWNER TO clinlims;

--
-- Name: analyzer_results; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE analyzer_results (
    id numeric(10,0) NOT NULL,
    analyzer_id numeric(10,0) NOT NULL,
    accession_number character varying(20) NOT NULL,
    test_name character varying(20) NOT NULL,
    result character varying(20) NOT NULL,
    units character varying(10),
    status_id numeric(10,0) DEFAULT 1 NOT NULL,
    iscontrol boolean DEFAULT false NOT NULL,
    lastupdated timestamp(6) without time zone,
    read_only boolean DEFAULT false,
    test_id numeric(10,0),
    duplicate_id numeric(10,0),
    positive boolean DEFAULT false,
    complete_date timestamp with time zone,
    test_result_type character varying(1)
);


ALTER TABLE clinlims.analyzer_results OWNER TO clinlims;

--
-- Name: TABLE analyzer_results; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE analyzer_results IS 'A holding table for analyzer results ';


--
-- Name: COLUMN analyzer_results.analyzer_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer_results.analyzer_id IS 'Reference to analyzer table';


--
-- Name: COLUMN analyzer_results.accession_number; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer_results.accession_number IS 'The display version of the accession number.  May be either the extended or normal accession number';


--
-- Name: COLUMN analyzer_results.test_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer_results.test_name IS 'The test name, if a mapping is found then the mapping will be used, if not then the analyzer test name will be useds';


--
-- Name: COLUMN analyzer_results.result; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer_results.result IS 'The result of the test, the meaning depends on the test itself';


--
-- Name: COLUMN analyzer_results.units; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer_results.units IS 'The units as sent from the analyzer';


--
-- Name: COLUMN analyzer_results.status_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer_results.status_id IS 'The status for the this analyzer result';


--
-- Name: COLUMN analyzer_results.iscontrol; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer_results.iscontrol IS 'Is this result a control';


--
-- Name: COLUMN analyzer_results.read_only; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer_results.read_only IS 'Is this result read only';


--
-- Name: COLUMN analyzer_results.test_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer_results.test_id IS 'Test this is result is mapped to';


--
-- Name: COLUMN analyzer_results.duplicate_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer_results.duplicate_id IS 'Reference to another analyzer result with the same analyzer and analyzer test';


--
-- Name: COLUMN analyzer_results.positive; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer_results.positive IS 'Is the test positive';


--
-- Name: COLUMN analyzer_results.complete_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer_results.complete_date IS 'The time stamp for when the analyzsis was done';


--
-- Name: analyzer_results_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE analyzer_results_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.analyzer_results_seq OWNER TO clinlims;

--
-- Name: analyzer_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE analyzer_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.analyzer_seq OWNER TO clinlims;

--
-- Name: analyzer_test_map; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE analyzer_test_map (
    analyzer_id numeric(10,0) NOT NULL,
    analyzer_test_name character varying(30) NOT NULL,
    test_id numeric(10,0) NOT NULL,
    lastupdated timestamp with time zone DEFAULT '2012-04-24 00:30:14.130688+00'::timestamp with time zone
);


ALTER TABLE clinlims.analyzer_test_map OWNER TO clinlims;

--
-- Name: TABLE analyzer_test_map; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE analyzer_test_map IS 'Maps the analyzers names to the tests in database';


--
-- Name: COLUMN analyzer_test_map.analyzer_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer_test_map.analyzer_id IS 'foriegn key to analyzer table';


--
-- Name: COLUMN analyzer_test_map.analyzer_test_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer_test_map.analyzer_test_name IS 'The name the analyzer uses for the test';


--
-- Name: COLUMN analyzer_test_map.test_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN analyzer_test_map.test_id IS 'foriegn key to test table';


--
-- Name: animal_common_name; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE animal_common_name (
    id numeric(10,0) NOT NULL,
    name character varying(30)
);


ALTER TABLE clinlims.animal_common_name OWNER TO clinlims;

--
-- Name: COLUMN animal_common_name.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN animal_common_name.name IS 'Lists the animal common name';


--
-- Name: animal_scientific_name; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE animal_scientific_name (
    id numeric(10,0) NOT NULL,
    comm_anim_id numeric(10,0) NOT NULL,
    name character varying(30)
);


ALTER TABLE clinlims.animal_scientific_name OWNER TO clinlims;

--
-- Name: COLUMN animal_scientific_name.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN animal_scientific_name.id IS 'Sequential Number';


--
-- Name: COLUMN animal_scientific_name.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN animal_scientific_name.name IS 'May include Genus and Species';


--
-- Name: attachment; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE attachment (
    id numeric(10,0) NOT NULL,
    attach_type character varying(20),
    filename character varying(60),
    description character varying(80),
    storage_reference character varying(255)
);


ALTER TABLE clinlims.attachment OWNER TO clinlims;

--
-- Name: attachment_item; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE attachment_item (
    id numeric(10,0) NOT NULL,
    reference_id numeric,
    reference_table_id numeric,
    attachment_id numeric
);


ALTER TABLE clinlims.attachment_item OWNER TO clinlims;

--
-- Name: aux_data; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE aux_data (
    id numeric(10,0) NOT NULL,
    sort_order numeric,
    is_reportable character varying(1),
    auxdata_type character varying(1),
    value character varying(80),
    reference_id numeric,
    reference_table numeric,
    aux_field_id numeric(10,0)
);


ALTER TABLE clinlims.aux_data OWNER TO clinlims;

--
-- Name: COLUMN aux_data.sort_order; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN aux_data.sort_order IS 'The order the analytes (questions) are displayed';


--
-- Name: COLUMN aux_data.is_reportable; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN aux_data.is_reportable IS 'Flag indicating if this entry is reportable';


--
-- Name: COLUMN aux_data.auxdata_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN aux_data.auxdata_type IS 'Type of value: Dictionary, Titer range, Number, Date, String';


--
-- Name: COLUMN aux_data.value; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN aux_data.value IS 'Actual value';


--
-- Name: COLUMN aux_data.reference_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN aux_data.reference_id IS 'Link to record in table to which this entry pertains';


--
-- Name: COLUMN aux_data.reference_table; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN aux_data.reference_table IS 'Link to table that this entry belongs to';


--
-- Name: aux_field; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE aux_field (
    id numeric(10,0) NOT NULL,
    sort_order numeric,
    auxfld_type character varying(1),
    is_active character varying(1),
    is_reportable character varying(1),
    reference_table numeric,
    analyte_id numeric(10,0),
    scriptlet_id numeric(10,0)
);


ALTER TABLE clinlims.aux_field OWNER TO clinlims;

--
-- Name: COLUMN aux_field.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN aux_field.id IS 'Sequential Identifier';


--
-- Name: COLUMN aux_field.sort_order; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN aux_field.sort_order IS 'The order the analystes (questions) are displayed';


--
-- Name: COLUMN aux_field.auxfld_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN aux_field.auxfld_type IS 'Type of field: Required...';


--
-- Name: COLUMN aux_field.is_active; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN aux_field.is_active IS 'Flag indicating is this entry is active';


--
-- Name: COLUMN aux_field.is_reportable; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN aux_field.is_reportable IS 'Default value to reportable flag';


--
-- Name: COLUMN aux_field.reference_table; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN aux_field.reference_table IS 'Link to table in which this entity can be used.';


--
-- Name: aux_field_values; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE aux_field_values (
    id numeric(10,0) NOT NULL,
    auxfldval_type character varying(1),
    value character varying(80),
    aux_field_id numeric(10,0)
);


ALTER TABLE clinlims.aux_field_values OWNER TO clinlims;

--
-- Name: COLUMN aux_field_values.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN aux_field_values.id IS 'Sequential Identifier';


--
-- Name: COLUMN aux_field_values.auxfldval_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN aux_field_values.auxfldval_type IS 'Type of value: Dictionary, titer range, number, date, string';


--
-- Name: COLUMN aux_field_values.value; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN aux_field_values.value IS 'A permissible field value';


--
-- Name: chunking_history; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE chunking_history (
    id integer NOT NULL,
    chunk_length bigint,
    start bigint NOT NULL
);


ALTER TABLE clinlims.chunking_history OWNER TO clinlims;

--
-- Name: chunking_history_id_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE chunking_history_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.chunking_history_id_seq OWNER TO clinlims;

--
-- Name: chunking_history_id_seq; Type: SEQUENCE OWNED BY; Schema: clinlims; Owner: clinlims
--

ALTER SEQUENCE chunking_history_id_seq OWNED BY chunking_history.id;


--
-- Name: city_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE city_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.city_seq OWNER TO clinlims;

--
-- Name: city_state_zip; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE city_state_zip (
    id numeric(10,0),
    city character varying(30),
    state character varying(2),
    zip_code character varying(10),
    county_fips numeric(3,0),
    county character varying(25),
    region_id numeric(3,0),
    region character varying(30),
    state_fips numeric(3,0),
    state_name character varying(30),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.city_state_zip OWNER TO clinlims;

--
-- Name: code_element_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE code_element_type (
    id numeric(10,0) NOT NULL,
    text character varying(60),
    lastupdated timestamp(6) without time zone,
    local_reference_table numeric(10,0)
);


ALTER TABLE clinlims.code_element_type OWNER TO clinlims;

--
-- Name: code_element_type_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE code_element_type_seq
    START WITH 21
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.code_element_type_seq OWNER TO clinlims;

--
-- Name: code_element_xref; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE code_element_xref (
    id numeric(10,0) NOT NULL,
    message_org_id numeric(10,0),
    code_element_type_id numeric(10,0),
    receiver_code_element_id numeric(10,0),
    local_code_element_id numeric(10,0),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.code_element_xref OWNER TO clinlims;

--
-- Name: code_element_xref_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE code_element_xref_seq
    START WITH 41
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.code_element_xref_seq OWNER TO clinlims;

--
-- Name: contact_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE contact_type (
    id numeric(10,0) NOT NULL,
    description character varying(20),
    ct_type character varying(4),
    is_unique character varying(1)
);


ALTER TABLE clinlims.contact_type OWNER TO clinlims;

--
-- Name: COLUMN contact_type.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN contact_type.id IS 'sequential field';


--
-- Name: COLUMN contact_type.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN contact_type.description IS 'Can include such things as "Operator", "Accounting"';


--
-- Name: COLUMN contact_type.ct_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN contact_type.ct_type IS 'Type code';


--
-- Name: COLUMN contact_type.is_unique; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN contact_type.is_unique IS 'Indicates if only 1 of this contact type is allowed per organization';


--
-- Name: county_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE county_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.county_seq OWNER TO clinlims;

--
-- Name: databasechangelog; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE databasechangelog (
    id character varying(63) NOT NULL,
    author character varying(63) NOT NULL,
    filename character varying(200) NOT NULL,
    dateexecuted timestamp with time zone NOT NULL,
    md5sum character varying(32),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(10)
);


ALTER TABLE clinlims.databasechangelog OWNER TO clinlims;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp with time zone,
    lockedby character varying(255)
);


ALTER TABLE clinlims.databasechangeloglock OWNER TO clinlims;

--
-- Name: dictionary; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE dictionary (
    id numeric(10,0) NOT NULL,
    is_active character varying(1),
    dict_entry character varying(4000),
    lastupdated timestamp(6) without time zone,
    local_abbrev character varying(10),
    dictionary_category_id numeric(10,0),
    display_key character varying(60)
);


ALTER TABLE clinlims.dictionary OWNER TO clinlims;

--
-- Name: COLUMN dictionary.is_active; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN dictionary.is_active IS 'Flag indicating if the analyte is active';


--
-- Name: COLUMN dictionary.dict_entry; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN dictionary.dict_entry IS 'Finding, result, interpretation';


--
-- Name: COLUMN dictionary.display_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN dictionary.display_key IS 'Resource file lookup key for localization of displaying the name';


--
-- Name: dictionary_category; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE dictionary_category (
    id numeric(10,0) NOT NULL,
    description character varying(60),
    lastupdated timestamp(6) without time zone,
    local_abbrev character varying(10),
    name character varying(50)
);


ALTER TABLE clinlims.dictionary_category OWNER TO clinlims;

--
-- Name: COLUMN dictionary_category.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN dictionary_category.id IS 'A unique auto generated integer number assigned by database';


--
-- Name: COLUMN dictionary_category.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN dictionary_category.description IS 'Human readable description';


--
-- Name: dictionary_category_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE dictionary_category_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.dictionary_category_seq OWNER TO clinlims;

--
-- Name: dictionary_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE dictionary_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.dictionary_seq OWNER TO clinlims;

--
-- Name: district; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE district (
    id numeric(10,0) NOT NULL,
    city_id numeric(10,0) NOT NULL,
    dist_entry character varying(300),
    lastupdated timestamp without time zone,
    description character varying(50)
);


ALTER TABLE clinlims.district OWNER TO clinlims;

--
-- Name: COLUMN district.dist_entry; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN district.dist_entry IS 'Finding, result, interpretation';


--
-- Name: district_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE district_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.district_seq OWNER TO clinlims;

--
-- Name: document_track; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE document_track (
    id numeric(10,0) NOT NULL,
    table_id numeric(10,0) NOT NULL,
    row_id numeric(10,0) NOT NULL,
    document_type_id numeric(10,0) NOT NULL,
    parent_id numeric(10,0),
    report_generation_time timestamp with time zone,
    lastupdated timestamp with time zone,
    name character varying(80)
);


ALTER TABLE clinlims.document_track OWNER TO clinlims;

--
-- Name: TABLE document_track; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE document_track IS 'Table to track operations on documents.  Expected use is for has a document of some been printed for a sample, qa_event etc';


--
-- Name: COLUMN document_track.table_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN document_track.table_id IS 'The table to which the row_id references';


--
-- Name: COLUMN document_track.row_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN document_track.row_id IS 'The particular record for which a document has been generated';


--
-- Name: COLUMN document_track.document_type_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN document_track.document_type_id IS 'References the type of document which the record has been generated for';


--
-- Name: COLUMN document_track.parent_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN document_track.parent_id IS 'If the document has been generated more than once for this record then this will point to the previous record';


--
-- Name: COLUMN document_track.report_generation_time; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN document_track.report_generation_time IS 'When this report was generated';


--
-- Name: COLUMN document_track.lastupdated; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN document_track.lastupdated IS 'Last time this record was updated';


--
-- Name: COLUMN document_track.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN document_track.name IS 'The name of the report if there is more than one of the type';


--
-- Name: document_track_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE document_track_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.document_track_seq OWNER TO clinlims;

--
-- Name: document_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE document_type (
    id numeric(10,0) NOT NULL,
    name character varying(40) NOT NULL,
    description character varying(80),
    lastupdated timestamp with time zone
);


ALTER TABLE clinlims.document_type OWNER TO clinlims;

--
-- Name: TABLE document_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE document_type IS 'Table which describes document types to be tracked by document_track table';


--
-- Name: COLUMN document_type.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN document_type.name IS 'The name of the document';


--
-- Name: COLUMN document_type.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN document_type.description IS 'The description of the document';


--
-- Name: COLUMN document_type.lastupdated; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN document_type.lastupdated IS 'Last time this record was updated';


--
-- Name: document_type_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE document_type_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.document_type_seq OWNER TO clinlims;

--
-- Name: ethnicity; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE ethnicity (
    id numeric(10,0) NOT NULL,
    ethnic_type character varying(1) NOT NULL,
    description character varying(20),
    is_active character varying(1)
);


ALTER TABLE clinlims.ethnicity OWNER TO clinlims;

--
-- Name: COLUMN ethnicity.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN ethnicity.id IS 'Any code values in tables.';


--
-- Name: COLUMN ethnicity.ethnic_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN ethnicity.ethnic_type IS 'Ethnicity of Patient';


--
-- Name: event_records; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE event_records (
    id integer NOT NULL,
    uuid character varying(40),
    title character varying(255),
    "timestamp" timestamp with time zone DEFAULT ('now'::text)::timestamp(6) with time zone,
    uri character varying(255),
    object character varying(1000),
    category character varying(255),
    date_created timestamp with time zone DEFAULT now(),
    tags character varying(255)
);


ALTER TABLE clinlims.event_records OWNER TO clinlims;

--
-- Name: event_records_id_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE event_records_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.event_records_id_seq OWNER TO clinlims;

--
-- Name: event_records_id_seq; Type: SEQUENCE OWNED BY; Schema: clinlims; Owner: clinlims
--

ALTER SEQUENCE event_records_id_seq OWNED BY event_records.id;


--
-- Name: event_records_offset_marker; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE event_records_offset_marker (
    id integer NOT NULL,
    event_id integer,
    event_count integer,
    category character varying(255)
);


ALTER TABLE clinlims.event_records_offset_marker OWNER TO clinlims;

--
-- Name: event_records_offset_marker_id_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE event_records_offset_marker_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.event_records_offset_marker_id_seq OWNER TO clinlims;

--
-- Name: event_records_offset_marker_id_seq; Type: SEQUENCE OWNED BY; Schema: clinlims; Owner: clinlims
--

ALTER SEQUENCE event_records_offset_marker_id_seq OWNED BY event_records_offset_marker.id;


--
-- Name: event_records_queue; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE event_records_queue (
    id integer NOT NULL,
    uuid character varying(40),
    title character varying(255),
    "timestamp" timestamp with time zone DEFAULT ('now'::text)::timestamp(6) with time zone,
    uri character varying(255),
    object character varying(1000),
    category character varying(255),
    tags character varying(255)
);


ALTER TABLE clinlims.event_records_queue OWNER TO clinlims;

--
-- Name: event_records_queue_id_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE event_records_queue_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.event_records_queue_id_seq OWNER TO clinlims;

--
-- Name: event_records_queue_id_seq; Type: SEQUENCE OWNED BY; Schema: clinlims; Owner: clinlims
--

ALTER SEQUENCE event_records_queue_id_seq OWNED BY event_records_queue.id;


--
-- Name: external_reference; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE external_reference (
    id integer NOT NULL,
    item_id numeric(10,0) NOT NULL,
    external_id character varying(50) NOT NULL,
    type character varying(50) NOT NULL
);


ALTER TABLE clinlims.external_reference OWNER TO clinlims;

--
-- Name: external_reference_id_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE external_reference_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.external_reference_id_seq OWNER TO clinlims;

--
-- Name: external_reference_id_seq; Type: SEQUENCE OWNED BY; Schema: clinlims; Owner: clinlims
--

ALTER SEQUENCE external_reference_id_seq OWNED BY external_reference.id;


--
-- Name: failed_event_retry_log; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE failed_event_retry_log (
    id integer NOT NULL,
    feed_uri character varying(255),
    failed_at timestamp with time zone,
    error_message character varying(4000),
    event_id character varying(255),
    event_content character varying(4000),
    error_hash_code integer
);


ALTER TABLE clinlims.failed_event_retry_log OWNER TO clinlims;

--
-- Name: failed_event_retry_log_id_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE failed_event_retry_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.failed_event_retry_log_id_seq OWNER TO clinlims;

--
-- Name: failed_event_retry_log_id_seq; Type: SEQUENCE OWNED BY; Schema: clinlims; Owner: clinlims
--

ALTER SEQUENCE failed_event_retry_log_id_seq OWNED BY failed_event_retry_log.id;


--
-- Name: failed_events; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE failed_events (
    id integer NOT NULL,
    feed_uri character varying(255),
    error_message character varying(4000),
    event_id character varying(255),
    event_content character varying(4000),
    failed_at timestamp with time zone,
    error_hash_code integer,
    title character varying(255),
    retries integer DEFAULT 0 NOT NULL,
    tags character varying(255)
);


ALTER TABLE clinlims.failed_events OWNER TO clinlims;

--
-- Name: failed_events_id_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE failed_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.failed_events_id_seq OWNER TO clinlims;

--
-- Name: failed_events_id_seq; Type: SEQUENCE OWNED BY; Schema: clinlims; Owner: clinlims
--

ALTER SEQUENCE failed_events_id_seq OWNED BY failed_events.id;


--
-- Name: gender; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE gender (
    id numeric(10,0) NOT NULL,
    gender_type character varying(1),
    description character varying(20),
    lastupdated timestamp(6) without time zone,
    name_key character varying(60)
);


ALTER TABLE clinlims.gender OWNER TO clinlims;

--
-- Name: COLUMN gender.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN gender.id IS 'A unique auto generated integer number assigned by database';


--
-- Name: COLUMN gender.gender_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN gender.gender_type IS 'Gender code (M, F, U)';


--
-- Name: COLUMN gender.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN gender.description IS 'Human readable description';


--
-- Name: gender_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE gender_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.gender_seq OWNER TO clinlims;

--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.hibernate_sequence OWNER TO clinlims;

--
-- Name: history; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE history (
    id numeric(10,0) NOT NULL,
    sys_user_id numeric(10,0) NOT NULL,
    reference_id numeric NOT NULL,
    reference_table numeric NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    activity character varying(1) NOT NULL,
    changes bytea
);


ALTER TABLE clinlims.history OWNER TO clinlims;

--
-- Name: COLUMN history.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN history.id IS 'Sequential number for audit records';


--
-- Name: COLUMN history.sys_user_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN history.sys_user_id IS 'Sequential Identifier';


--
-- Name: COLUMN history.reference_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN history.reference_id IS 'Links to record in table to which this entry pertains';


--
-- Name: COLUMN history.reference_table; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN history.reference_table IS 'Link to table that this entity belongs to';


--
-- Name: COLUMN history."timestamp"; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN history."timestamp" IS 'Date of history record';


--
-- Name: COLUMN history.activity; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN history.activity IS 'U for update, D for delete';


--
-- Name: COLUMN history.changes; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN history.changes IS 'XML image of record prior to change';


--
-- Name: history_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE history_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.history_seq OWNER TO clinlims;

--
-- Name: hl7_encoding_type_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE hl7_encoding_type_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.hl7_encoding_type_seq OWNER TO clinlims;

--
-- Name: htmldb_plan_table; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE htmldb_plan_table (
    statement_id character varying(30),
    plan_id numeric,
    "timestamp" timestamp without time zone,
    remarks character varying(4000),
    operation character varying(30),
    options character varying(255),
    object_node character varying(128),
    object_owner character varying(30),
    object_name character varying(30),
    object_alias character varying(65),
    object_instance numeric,
    object_type character varying(30),
    optimizer character varying(255),
    search_columns numeric,
    id numeric,
    parent_id numeric,
    depth numeric,
    "position" numeric,
    cost numeric,
    cardinality numeric,
    bytes numeric,
    other_tag character varying(255),
    partition_start character varying(255),
    partition_stop character varying(255),
    partition_id numeric,
    other text,
    distribution character varying(30),
    cpu_cost numeric,
    io_cost numeric,
    temp_space numeric,
    access_predicates character varying(4000),
    filter_predicates character varying(4000),
    projection character varying(4000),
    "time" numeric,
    qblock_name character varying(30)
);


ALTER TABLE clinlims.htmldb_plan_table OWNER TO clinlims;

--
-- Name: import_status; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE import_status (
    id integer NOT NULL,
    original_file_name text NOT NULL,
    saved_file_name text NOT NULL,
    error_file_name text,
    type character varying(10) NOT NULL,
    status character varying(25) NOT NULL,
    successful_records numeric(6,0),
    failed_records numeric(6,0),
    stage_name character varying(10),
    uploaded_by character varying(20) NOT NULL,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    stack_trace text
);


ALTER TABLE clinlims.import_status OWNER TO clinlims;

--
-- Name: import_status_id_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE import_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.import_status_id_seq OWNER TO clinlims;

--
-- Name: import_status_id_seq; Type: SEQUENCE OWNED BY; Schema: clinlims; Owner: clinlims
--

ALTER SEQUENCE import_status_id_seq OWNED BY import_status.id;


--
-- Name: instrument; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE instrument (
    id numeric(10,0) NOT NULL,
    scrip_id numeric(10,0),
    name character varying(20),
    description character varying(60),
    instru_type character varying(30),
    is_active character varying(1),
    location character varying(60)
);


ALTER TABLE clinlims.instrument OWNER TO clinlims;

--
-- Name: COLUMN instrument.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN instrument.name IS 'Short name for instrument';


--
-- Name: COLUMN instrument.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN instrument.description IS 'Instrument description';


--
-- Name: COLUMN instrument.instru_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN instrument.instru_type IS 'Type of instrument: Mass Spec, HPLC, etc.';


--
-- Name: COLUMN instrument.is_active; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN instrument.is_active IS 'Flag indicating if the instrument is active';


--
-- Name: COLUMN instrument.location; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN instrument.location IS 'Location of instrument';


--
-- Name: instrument_analyte; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE instrument_analyte (
    id numeric(10,0) NOT NULL,
    analyte_id numeric(10,0),
    instru_id numeric(10,0),
    method_id numeric(10,0),
    result_group numeric
);


ALTER TABLE clinlims.instrument_analyte OWNER TO clinlims;

--
-- Name: COLUMN instrument_analyte.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN instrument_analyte.id IS 'Sequential Identifier';


--
-- Name: COLUMN instrument_analyte.method_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN instrument_analyte.method_id IS 'Sequential number';


--
-- Name: COLUMN instrument_analyte.result_group; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN instrument_analyte.result_group IS 'A program generated group number';


--
-- Name: instrument_log; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE instrument_log (
    id numeric(10,0) NOT NULL,
    instru_id numeric(10,0),
    instlog_type character varying(1),
    event_begin timestamp without time zone,
    event_end timestamp without time zone
);


ALTER TABLE clinlims.instrument_log OWNER TO clinlims;

--
-- Name: COLUMN instrument_log.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN instrument_log.id IS 'Sequential Identifier';


--
-- Name: COLUMN instrument_log.instlog_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN instrument_log.instlog_type IS 'type of log entry: downtime, maintenance';


--
-- Name: COLUMN instrument_log.event_begin; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN instrument_log.event_begin IS 'date-time logged event started';


--
-- Name: COLUMN instrument_log.event_end; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN instrument_log.event_end IS 'Date-time logged event ended';


--
-- Name: inventory_component; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE inventory_component (
    id numeric(10,0) NOT NULL,
    invitem_id numeric(10,0),
    quantity numeric,
    material_component_id numeric(10,0)
);


ALTER TABLE clinlims.inventory_component OWNER TO clinlims;

--
-- Name: COLUMN inventory_component.quantity; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_component.quantity IS 'Quantity of material required';


--
-- Name: inventory_item; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE inventory_item (
    id numeric(10,0) NOT NULL,
    uom_id numeric(10,0),
    name character varying(20),
    description character varying(60),
    quantity_min_level numeric,
    quantity_max_level numeric,
    quantity_to_reorder numeric,
    is_reorder_auto character varying(1),
    is_lot_maintained character varying(1),
    is_active character varying(1),
    average_lead_time numeric,
    average_cost numeric,
    average_daily_use numeric
);


ALTER TABLE clinlims.inventory_item OWNER TO clinlims;

--
-- Name: COLUMN inventory_item.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_item.name IS 'Unique Short Name for this item ie "Red Top Tube"';


--
-- Name: COLUMN inventory_item.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_item.description IS 'Description of Item';


--
-- Name: COLUMN inventory_item.quantity_min_level; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_item.quantity_min_level IS 'Minimum inventory level';


--
-- Name: COLUMN inventory_item.quantity_max_level; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_item.quantity_max_level IS 'Maximum Inventory Level';


--
-- Name: COLUMN inventory_item.quantity_to_reorder; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_item.quantity_to_reorder IS 'Amount to reorder';


--
-- Name: COLUMN inventory_item.is_reorder_auto; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_item.is_reorder_auto IS 'Flag indicating system should automatically reorder';


--
-- Name: COLUMN inventory_item.is_lot_maintained; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_item.is_lot_maintained IS 'Indicates if individual lot information is maintained for this item';


--
-- Name: COLUMN inventory_item.is_active; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_item.is_active IS 'Indicates if this item is available for use.';


--
-- Name: COLUMN inventory_item.average_lead_time; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_item.average_lead_time IS 'Average lead time in days';


--
-- Name: COLUMN inventory_item.average_cost; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_item.average_cost IS 'Average cost per unit';


--
-- Name: COLUMN inventory_item.average_daily_use; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_item.average_daily_use IS 'Seasonally adjusted average usage per day';


--
-- Name: inventory_item_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE inventory_item_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.inventory_item_seq OWNER TO clinlims;

--
-- Name: inventory_location; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE inventory_location (
    id numeric(10,0) NOT NULL,
    storage_id numeric(10,0),
    lot_number character varying(20),
    quantity_onhand numeric,
    expiration_date timestamp without time zone,
    inv_item_id numeric(10,0)
);


ALTER TABLE clinlims.inventory_location OWNER TO clinlims;

--
-- Name: COLUMN inventory_location.lot_number; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_location.lot_number IS 'Lot number';


--
-- Name: COLUMN inventory_location.quantity_onhand; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_location.quantity_onhand IS 'Number of units onhand';


--
-- Name: inventory_location_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE inventory_location_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.inventory_location_seq OWNER TO clinlims;

--
-- Name: inventory_receipt; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE inventory_receipt (
    id numeric(10,0) NOT NULL,
    invitem_id numeric(10,0) NOT NULL,
    received_date timestamp without time zone,
    quantity_received numeric,
    unit_cost numeric,
    qc_reference character varying(20),
    external_reference character varying(20),
    org_id numeric(10,0)
);


ALTER TABLE clinlims.inventory_receipt OWNER TO clinlims;

--
-- Name: COLUMN inventory_receipt.received_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_receipt.received_date IS 'Date and time item was received';


--
-- Name: COLUMN inventory_receipt.quantity_received; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_receipt.quantity_received IS 'Number of units received';


--
-- Name: COLUMN inventory_receipt.unit_cost; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_receipt.unit_cost IS 'Cost per unit item';


--
-- Name: COLUMN inventory_receipt.qc_reference; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_receipt.qc_reference IS 'External QC reference number';


--
-- Name: COLUMN inventory_receipt.external_reference; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN inventory_receipt.external_reference IS 'External reference to purchase order, invoice number.';


--
-- Name: inventory_receipt_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE inventory_receipt_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.inventory_receipt_seq OWNER TO clinlims;

--
-- Name: lab_order_item; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE lab_order_item (
    id numeric(10,0) NOT NULL,
    lab_order_type_id numeric(10,0) NOT NULL,
    table_ref numeric(10,0),
    record_id numeric(10,0),
    identifier character varying(20),
    action character varying(20),
    lastupdated timestamp with time zone DEFAULT now()
);


ALTER TABLE clinlims.lab_order_item OWNER TO clinlims;

--
-- Name: TABLE lab_order_item; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE lab_order_item IS 'Association table between lab order type and the thing they affect';


--
-- Name: COLUMN lab_order_item.lab_order_type_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN lab_order_item.lab_order_type_id IS 'The lab order type this refers to';


--
-- Name: COLUMN lab_order_item.table_ref; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN lab_order_item.table_ref IS 'If the thing it refers to is a db object what table is it in';


--
-- Name: COLUMN lab_order_item.record_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN lab_order_item.record_id IS 'If the thing it refers to is a db object what record in the table is it';


--
-- Name: COLUMN lab_order_item.identifier; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN lab_order_item.identifier IS 'If this is not a db object then another way to identify it.  could be a class name on a form';


--
-- Name: COLUMN lab_order_item.action; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN lab_order_item.action IS 'What should happen if this is in a lab order type';


--
-- Name: lab_order_item_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE lab_order_item_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.lab_order_item_seq OWNER TO clinlims;

--
-- Name: lab_order_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE lab_order_type (
    id numeric(10,0) NOT NULL,
    domain character varying(20) NOT NULL,
    type character varying(40) NOT NULL,
    context character varying(60),
    description character varying(60),
    sort_order numeric,
    lastupdated timestamp with time zone,
    display_key character varying(60)
);


ALTER TABLE clinlims.lab_order_type OWNER TO clinlims;

--
-- Name: TABLE lab_order_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE lab_order_type IS 'If lab differentiates based on the type of order i.e. first visit, follow-up.  The types are defined here';


--
-- Name: COLUMN lab_order_type.domain; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN lab_order_type.domain IS 'Refers to Human, Environmental, New born etc';


--
-- Name: COLUMN lab_order_type.type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN lab_order_type.type IS 'The lab order type i.e. first visit, follow-up etc';


--
-- Name: COLUMN lab_order_type.context; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN lab_order_type.context IS 'What is the context that this type is significant. i.e. Sample Entry, confirmation entry';


--
-- Name: COLUMN lab_order_type.sort_order; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN lab_order_type.sort_order IS 'What is the order when displayed to the user';


--
-- Name: COLUMN lab_order_type.display_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN lab_order_type.display_key IS 'Localization information.  Match found in MessageResource.properties';


--
-- Name: lab_order_type_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE lab_order_type_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.lab_order_type_seq OWNER TO clinlims;

--
-- Name: label; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE label (
    id numeric(10,0) NOT NULL,
    name character varying(30),
    description character varying(60),
    printer_type character(1),
    scriptlet_id numeric(10,0),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.label OWNER TO clinlims;

--
-- Name: label_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE label_seq
    START WITH 3
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.label_seq OWNER TO clinlims;

--
-- Name: login_user; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE login_user (
    id numeric(10,0) NOT NULL,
    login_name character varying(20) NOT NULL,
    password character varying(256) NOT NULL,
    password_expired_dt date NOT NULL,
    account_locked character varying(1) NOT NULL,
    account_disabled character varying(1) NOT NULL,
    is_admin character varying(1) NOT NULL,
    user_time_out character varying(3) NOT NULL
);


ALTER TABLE clinlims.login_user OWNER TO clinlims;

--
-- Name: COLUMN login_user.login_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN login_user.login_name IS 'User LOGIN_NAME from SYSTEM_USER table';


--
-- Name: COLUMN login_user.password; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN login_user.password IS 'User password';


--
-- Name: COLUMN login_user.password_expired_dt; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN login_user.password_expired_dt IS 'Password expiration date';


--
-- Name: COLUMN login_user.account_locked; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN login_user.account_locked IS 'Account locked (Y/N)';


--
-- Name: COLUMN login_user.account_disabled; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN login_user.account_disabled IS 'Account disabled (Y/N)';


--
-- Name: COLUMN login_user.is_admin; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN login_user.is_admin IS 'Indicates if this user is administrator (Y/N)';


--
-- Name: COLUMN login_user.user_time_out; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN login_user.user_time_out IS 'User session time out in minute';


--
-- Name: login_user_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE login_user_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.login_user_seq OWNER TO clinlims;

--
-- Name: markers; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE markers (
    id integer NOT NULL,
    feed_uri_for_last_read_entry character varying(250),
    feed_uri character varying(250) NOT NULL,
    last_read_entry_id character varying(250)
);


ALTER TABLE clinlims.markers OWNER TO clinlims;

--
-- Name: markers_id_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE markers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.markers_id_seq OWNER TO clinlims;

--
-- Name: markers_id_seq; Type: SEQUENCE OWNED BY; Schema: clinlims; Owner: clinlims
--

ALTER SEQUENCE markers_id_seq OWNED BY markers.id;


--
-- Name: menu; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE menu (
    id numeric(10,0) NOT NULL,
    parent_id numeric(10,0),
    presentation_order numeric,
    element_id character varying(40) NOT NULL,
    action_url character varying(120),
    click_action character varying(120),
    display_key character varying(60),
    tool_tip_key character varying(60),
    new_window boolean DEFAULT false
);


ALTER TABLE clinlims.menu OWNER TO clinlims;

--
-- Name: TABLE menu; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE menu IS 'Table for menuing system';


--
-- Name: COLUMN menu.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN menu.id IS 'primary key';


--
-- Name: COLUMN menu.parent_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN menu.parent_id IS 'If this is a submenu then the parent menu id';


--
-- Name: COLUMN menu.presentation_order; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN menu.presentation_order IS 'For top level menus the order across the page for sub menu the order in the popup menu.  If there is a collision then the order is alphebetical';


--
-- Name: COLUMN menu.element_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN menu.element_id IS 'The element id in the context of HTML.';


--
-- Name: COLUMN menu.action_url; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN menu.action_url IS 'If clicking on the element moves to a new page, the url of that page';


--
-- Name: COLUMN menu.click_action; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN menu.click_action IS 'If clicking on the element calls javascript then the javascript call';


--
-- Name: COLUMN menu.display_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN menu.display_key IS 'The message key for what will be displayed in the menu';


--
-- Name: COLUMN menu.tool_tip_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN menu.tool_tip_key IS 'The message key for the tool-tip';


--
-- Name: COLUMN menu.new_window; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN menu.new_window IS 'If true the menu action will be done in a new window';


--
-- Name: menu_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE menu_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.menu_seq OWNER TO clinlims;

--
-- Name: message_org; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE message_org (
    id numeric(10,0) NOT NULL,
    org_id character varying(60),
    is_active character varying(1),
    active_begin timestamp without time zone,
    active_end timestamp without time zone,
    description character varying(60),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.message_org OWNER TO clinlims;

--
-- Name: message_org_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE message_org_seq
    START WITH 41
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.message_org_seq OWNER TO clinlims;

--
-- Name: messagecontrolidseq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE messagecontrolidseq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.messagecontrolidseq OWNER TO clinlims;

--
-- Name: method; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE method (
    id numeric(10,0) NOT NULL,
    name character varying(20) NOT NULL,
    description character varying(60) NOT NULL,
    reporting_description character varying(60),
    is_active character varying(1),
    active_begin timestamp without time zone,
    active_end timestamp without time zone,
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.method OWNER TO clinlims;

--
-- Name: COLUMN method.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method.id IS 'Sequential number';


--
-- Name: COLUMN method.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method.name IS 'Sort name for method';


--
-- Name: COLUMN method.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method.description IS 'Description for Method';


--
-- Name: COLUMN method.reporting_description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method.reporting_description IS 'Description that appears on reports';


--
-- Name: COLUMN method.is_active; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method.is_active IS 'Flag indicating if the test is active';


--
-- Name: COLUMN method.active_begin; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method.active_begin IS 'Date test was moved into production';


--
-- Name: COLUMN method.active_end; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method.active_end IS 'Date test was removed from production';


--
-- Name: method_analyte; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE method_analyte (
    id numeric(10,0) NOT NULL,
    method_id numeric(10,0),
    analyte_id numeric(10,0),
    result_group numeric,
    sort_order numeric,
    ma_type character varying(1)
);


ALTER TABLE clinlims.method_analyte OWNER TO clinlims;

--
-- Name: COLUMN method_analyte.method_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method_analyte.method_id IS 'Sequential number';


--
-- Name: COLUMN method_analyte.result_group; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method_analyte.result_group IS 'a program generated group (sequence) number';


--
-- Name: COLUMN method_analyte.sort_order; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method_analyte.sort_order IS 'The order the analytes are displayed (sort order)';


--
-- Name: COLUMN method_analyte.ma_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method_analyte.ma_type IS 'type of analyte';


--
-- Name: method_result; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE method_result (
    id numeric(10,0) NOT NULL,
    scrip_id numeric(10,0),
    result_group numeric,
    flags character varying(10),
    methres_type character varying(1),
    value character varying(80),
    quant_limit character varying(30),
    cont_level character varying(30),
    method_id numeric(10,0)
);


ALTER TABLE clinlims.method_result OWNER TO clinlims;

--
-- Name: COLUMN method_result.result_group; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method_result.result_group IS 'The method analyte result group number';


--
-- Name: COLUMN method_result.flags; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method_result.flags IS 'A string of 1 character codes: Positive, Reportable';


--
-- Name: COLUMN method_result.methres_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method_result.methres_type IS 'Type of parameter: Dictionary, Titer-range, Number-range, date';


--
-- Name: COLUMN method_result.value; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method_result.value IS 'A possible result value based on type';


--
-- Name: COLUMN method_result.quant_limit; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method_result.quant_limit IS 'Quantitation Limit (if any)';


--
-- Name: COLUMN method_result.cont_level; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN method_result.cont_level IS 'Contaminant level (if any)';


--
-- Name: method_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE method_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.method_seq OWNER TO clinlims;

--
-- Name: mls_lab_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE mls_lab_type (
    id numeric(10,0) NOT NULL,
    description character varying(50) NOT NULL,
    org_mlt_org_mlt_id numeric(10,0)
);


ALTER TABLE clinlims.mls_lab_type OWNER TO clinlims;

--
-- Name: COLUMN mls_lab_type.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN mls_lab_type.id IS 'Sequential ID';


--
-- Name: COLUMN mls_lab_type.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN mls_lab_type.description IS 'Used to define MLS lab types including Level A, Urine, Virology';


--
-- Name: note; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE note (
    id numeric(10,0) NOT NULL,
    sys_user_id numeric(10,0),
    reference_id numeric,
    reference_table numeric,
    note_type character varying(1),
    subject character varying(60),
    text text,
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.note OWNER TO clinlims;

--
-- Name: COLUMN note.sys_user_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN note.sys_user_id IS 'Sequential Identifier';


--
-- Name: COLUMN note.reference_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN note.reference_id IS 'Link to record in table to which this entry pertains.';


--
-- Name: COLUMN note.reference_table; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN note.reference_table IS 'Link to table that this entity belongs to';


--
-- Name: COLUMN note.note_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN note.note_type IS 'Type of comment such as external, internal';


--
-- Name: COLUMN note.subject; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN note.subject IS 'Comment subject';


--
-- Name: note_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE note_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.note_seq OWNER TO clinlims;

--
-- Name: observation_history; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE observation_history (
    id numeric(10,0) NOT NULL,
    patient_id numeric(10,0) NOT NULL,
    sample_id numeric(10,0) NOT NULL,
    observation_history_type_id numeric(10,0) NOT NULL,
    value_type character varying(5) NOT NULL,
    value character varying(80),
    lastupdated timestamp with time zone,
    sample_item_id numeric(10,0)
);


ALTER TABLE clinlims.observation_history OWNER TO clinlims;

--
-- Name: TABLE observation_history; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE observation_history IS 'defines the answer at the time of a interview (with sample) to a demographic question.';


--
-- Name: COLUMN observation_history.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN observation_history.id IS 'primary key';


--
-- Name: COLUMN observation_history.patient_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN observation_history.patient_id IS 'FK linking this information to a patient';


--
-- Name: COLUMN observation_history.sample_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN observation_history.sample_id IS 'FK linking this information to a sample (and a collection date).';


--
-- Name: COLUMN observation_history.observation_history_type_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN observation_history.observation_history_type_id IS 'FK to type table to define what is contained in the value column';


--
-- Name: COLUMN observation_history.value_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN observation_history.value_type IS 'L=local or literal, a value right here in the history table. D=Defined/Dictionary, the value is a foreign key to the Dictionary table. For multiple choice questions with fixed answers.';


--
-- Name: COLUMN observation_history.value; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN observation_history.value IS 'either a literal value for this demo. type, or a Foreign key to dictionary';


--
-- Name: COLUMN observation_history.sample_item_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN observation_history.sample_item_id IS 'Optional refereence to sample item';


--
-- Name: observation_history_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE observation_history_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.observation_history_seq OWNER TO clinlims;

--
-- Name: observation_history_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE observation_history_type (
    id numeric(10,0) NOT NULL,
    type_name character varying(30) NOT NULL,
    description character varying(400),
    lastupdated timestamp with time zone
);


ALTER TABLE clinlims.observation_history_type OWNER TO clinlims;

--
-- Name: TABLE observation_history_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE observation_history_type IS 'defines the possible classes of values allowed in the demo. history table.';


--
-- Name: COLUMN observation_history_type.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN observation_history_type.id IS 'primary key';


--
-- Name: COLUMN observation_history_type.type_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN observation_history_type.type_name IS 'a short tag (1 word) for this type. What was asked "Gender", "HIVPositive" etc.';


--
-- Name: COLUMN observation_history_type.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN observation_history_type.description IS 'a long description of this type.';


--
-- Name: COLUMN observation_history_type.lastupdated; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN observation_history_type.lastupdated IS 'the last time this item was written to the database.';


--
-- Name: observation_history_type_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE observation_history_type_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.observation_history_type_seq OWNER TO clinlims;

--
-- Name: occupation; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE occupation (
    id numeric(10,0) NOT NULL,
    occupation character varying(300),
    lastupdated timestamp without time zone
);


ALTER TABLE clinlims.occupation OWNER TO clinlims;

--
-- Name: occupation_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE occupation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.occupation_seq OWNER TO clinlims;

--
-- Name: or_properties; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE or_properties (
    property_id integer NOT NULL,
    property_key character varying(255) NOT NULL,
    property_value character varying(255)
);


ALTER TABLE clinlims.or_properties OWNER TO clinlims;

--
-- Name: or_tags; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE or_tags (
    tag_id integer NOT NULL,
    tagged_object_id integer NOT NULL,
    tagged_object_class character varying(255) NOT NULL,
    tag_value character varying(255) NOT NULL,
    tag_type character varying(255) NOT NULL
);


ALTER TABLE clinlims.or_tags OWNER TO clinlims;

--
-- Name: order_item; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE order_item (
    id numeric(10,0) NOT NULL,
    ord_id numeric(10,0) NOT NULL,
    quantity_requested numeric,
    quantity_received numeric,
    inv_loc_id numeric(10,0)
);


ALTER TABLE clinlims.order_item OWNER TO clinlims;

--
-- Name: COLUMN order_item.quantity_requested; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN order_item.quantity_requested IS 'Quantity requested by organization';


--
-- Name: COLUMN order_item.quantity_received; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN order_item.quantity_received IS 'Quantity received';


--
-- Name: orders; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE orders (
    id numeric(10,0) NOT NULL,
    org_id numeric(10,0) NOT NULL,
    sys_user_id numeric(10,0),
    ordered_date timestamp without time zone,
    neededby_date timestamp without time zone,
    requested_by character varying(30),
    cost_center character varying(15),
    shipping_type character varying(2),
    shipping_carrier character varying(2),
    shipping_cost numeric,
    delivered_date timestamp without time zone,
    is_external character varying(1),
    external_order_number character varying(20),
    is_filled character varying(1)
);


ALTER TABLE clinlims.orders OWNER TO clinlims;

--
-- Name: COLUMN orders.org_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN orders.org_id IS 'Sequential Numbering Field';


--
-- Name: COLUMN orders.sys_user_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN orders.sys_user_id IS 'Sequential Identifier';


--
-- Name: COLUMN orders.neededby_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN orders.neededby_date IS 'Date-time the order must be received by client';


--
-- Name: COLUMN orders.requested_by; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN orders.requested_by IS 'Name of person/entity who placed the order';


--
-- Name: COLUMN orders.cost_center; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN orders.cost_center IS 'Entity or project the order will be charged against';


--
-- Name: COLUMN orders.shipping_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN orders.shipping_type IS 'Type of shipping such as: Air, ground, First Class, Bulk....';


--
-- Name: COLUMN orders.shipping_carrier; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN orders.shipping_carrier IS 'Company used for shipping: UPS, FedEx, USPS...';


--
-- Name: COLUMN orders.shipping_cost; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN orders.shipping_cost IS 'Shipping Cost';


--
-- Name: COLUMN orders.delivered_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN orders.delivered_date IS 'Date-time shipment received by client (including us)';


--
-- Name: COLUMN orders.is_external; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN orders.is_external IS 'Indicates if current order will be filled by an external vendor';


--
-- Name: COLUMN orders.external_order_number; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN orders.external_order_number IS 'External order number';


--
-- Name: COLUMN orders.is_filled; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN orders.is_filled IS 'Flag indicating if the order has been filled';


--
-- Name: org_hl7_encoding_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE org_hl7_encoding_type (
    organization_id numeric(10,0) NOT NULL,
    encoding_type_id numeric(10,0) NOT NULL,
    lastupdated timestamp with time zone
);


ALTER TABLE clinlims.org_hl7_encoding_type OWNER TO clinlims;

--
-- Name: TABLE org_hl7_encoding_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE org_hl7_encoding_type IS 'mapping table to identify which organization uses which hly encoding schema';


--
-- Name: org_mls_lab_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE org_mls_lab_type (
    org_id numeric NOT NULL,
    mls_lab_id numeric NOT NULL,
    org_mlt_id numeric(10,0) NOT NULL
);


ALTER TABLE clinlims.org_mls_lab_type OWNER TO clinlims;

--
-- Name: COLUMN org_mls_lab_type.org_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN org_mls_lab_type.org_id IS 'foreign key from organization table';


--
-- Name: COLUMN org_mls_lab_type.mls_lab_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN org_mls_lab_type.mls_lab_id IS 'foreign key from MLS lab type table';


--
-- Name: organization; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE organization (
    id numeric(10,0) NOT NULL,
    name character varying(80) NOT NULL,
    city character varying(30),
    zip_code character varying(10),
    mls_sentinel_lab_flag character varying(1) DEFAULT 'N'::character varying NOT NULL,
    org_mlt_org_mlt_id numeric(10,0),
    org_id numeric(10,0),
    short_name character varying(15),
    multiple_unit character varying(30),
    street_address character varying(30),
    state character varying(2),
    internet_address character varying(40),
    clia_num character varying(12),
    pws_id character varying(15),
    lastupdated timestamp(6) without time zone,
    mls_lab_flag character(1),
    is_active character(1),
    local_abbrev character varying(10)
);


ALTER TABLE clinlims.organization OWNER TO clinlims;

--
-- Name: COLUMN organization.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization.id IS 'Sequential Numbering Field';


--
-- Name: COLUMN organization.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization.name IS 'The full name of an organization';


--
-- Name: COLUMN organization.city; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization.city IS 'City';


--
-- Name: COLUMN organization.zip_code; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization.zip_code IS 'Zip code';


--
-- Name: COLUMN organization.mls_sentinel_lab_flag; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization.mls_sentinel_lab_flag IS 'Yes or No field indicating that the submitter is an Minnesota Laboratory System Lab';


--
-- Name: COLUMN organization.org_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization.org_id IS 'Sequential Numbering Field';


--
-- Name: COLUMN organization.short_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization.short_name IS 'A shortened or abbreviated name of an organization. For example "BCBSM" is the short name for Blue Cross Blue Shield Minnesota';


--
-- Name: COLUMN organization.multiple_unit; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization.multiple_unit IS 'Apartment number or unit information';


--
-- Name: COLUMN organization.street_address; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization.street_address IS 'Street address for this organization';


--
-- Name: COLUMN organization.state; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization.state IS 'State or Province';


--
-- Name: COLUMN organization.internet_address; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization.internet_address IS 'A uniform resource locator (URL), ie a website address assigned to an entity or pager.';


--
-- Name: COLUMN organization.clia_num; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization.clia_num IS 'Clinical Laboratory Improvement Amendments number';


--
-- Name: COLUMN organization.pws_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization.pws_id IS 'Public water supply id (SDWIS)';


--
-- Name: organization_address; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE organization_address (
    organization_id numeric(10,0) NOT NULL,
    address_part_id numeric(10,0) NOT NULL,
    type character(1) DEFAULT 'T'::bpchar,
    value character varying(120)
);


ALTER TABLE clinlims.organization_address OWNER TO clinlims;

--
-- Name: TABLE organization_address; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE organization_address IS 'Join table between address parts and an organization';


--
-- Name: COLUMN organization_address.organization_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization_address.organization_id IS 'The id of the organization who this address is attached to';


--
-- Name: COLUMN organization_address.address_part_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization_address.address_part_id IS 'The id of the address part for which we have a value';


--
-- Name: COLUMN organization_address.type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization_address.type IS 'The type of the value, either D for dictionary or T for text';


--
-- Name: COLUMN organization_address.value; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization_address.value IS 'The actual value for this part of the address';


--
-- Name: organization_contact; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE organization_contact (
    id numeric(10,0) NOT NULL,
    organization_id numeric(10,0) NOT NULL,
    person_id numeric(10,0) NOT NULL,
    "position" character varying(32)
);


ALTER TABLE clinlims.organization_contact OWNER TO clinlims;

--
-- Name: TABLE organization_contact; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE organization_contact IS 'A join table between organizations and persons';


--
-- Name: COLUMN organization_contact.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization_contact.id IS 'Unique key for each row';


--
-- Name: COLUMN organization_contact.organization_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization_contact.organization_id IS 'The id of the organization being referred to';


--
-- Name: COLUMN organization_contact.person_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization_contact.person_id IS 'The id of the person being referred to';


--
-- Name: COLUMN organization_contact."position"; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization_contact."position" IS 'The position of the person within the organization';


--
-- Name: organization_contact_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE organization_contact_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.organization_contact_seq OWNER TO clinlims;

--
-- Name: organization_organization_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE organization_organization_type (
    org_id numeric(10,0) NOT NULL,
    org_type_id numeric(10,0) NOT NULL
);


ALTER TABLE clinlims.organization_organization_type OWNER TO clinlims;

--
-- Name: TABLE organization_organization_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE organization_organization_type IS 'many to many mapping table between organization and orginaztion type';


--
-- Name: organization_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE organization_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.organization_seq OWNER TO clinlims;

--
-- Name: organization_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE organization_type (
    id numeric(10,0) NOT NULL,
    short_name character varying(20) NOT NULL,
    description character varying(60),
    name_display_key character varying(60),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.organization_type OWNER TO clinlims;

--
-- Name: TABLE organization_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE organization_type IS 'The type of an organization.  Releationship will be many to many';


--
-- Name: COLUMN organization_type.short_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization_type.short_name IS 'The name to be displayed in when organization type is to be associated with an organization';


--
-- Name: COLUMN organization_type.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization_type.description IS 'Optional longer description of the type';


--
-- Name: COLUMN organization_type.name_display_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN organization_type.name_display_key IS 'Resource file lookup key for localization of displaying the name';


--
-- Name: organization_type_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE organization_type_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.organization_type_seq OWNER TO clinlims;

--
-- Name: package_1; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE package_1 (
    id numeric(10,0) NOT NULL
);


ALTER TABLE clinlims.package_1 OWNER TO clinlims;

--
-- Name: panel; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE panel (
    id numeric(10,0) NOT NULL,
    name character varying(64),
    description character varying(64) NOT NULL,
    lastupdated timestamp(6) without time zone,
    display_key character varying(60),
    sort_order numeric DEFAULT 2147483647,
    is_active character varying(1) DEFAULT 'Y'::character varying
);


ALTER TABLE clinlims.panel OWNER TO clinlims;

--
-- Name: COLUMN panel.display_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN panel.display_key IS 'Resource file lookup key for localization of displaying the name';


--
-- Name: COLUMN panel.is_active; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN panel.is_active IS 'Is this panel currently active';


--
-- Name: panel_item; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE panel_item (
    id numeric(10,0) NOT NULL,
    panel_id numeric(10,0) NOT NULL,
    sort_order numeric,
    test_local_abbrev character varying(100),
    method_name character varying(20),
    lastupdated timestamp(6) without time zone,
    test_name character varying(20),
    test_id numeric(10,0) NOT NULL
);


ALTER TABLE clinlims.panel_item OWNER TO clinlims;

--
-- Name: COLUMN panel_item.sort_order; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN panel_item.sort_order IS 'The order the tests are displayed (sort order)';


--
-- Name: COLUMN panel_item.test_local_abbrev; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN panel_item.test_local_abbrev IS 'Short test name';


--
-- Name: COLUMN panel_item.method_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN panel_item.method_name IS 'Short method name';


--
-- Name: panel_item_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE panel_item_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.panel_item_seq OWNER TO clinlims;

--
-- Name: panel_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE panel_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.panel_seq OWNER TO clinlims;

--
-- Name: patient; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE patient (
    id numeric(10,0) NOT NULL,
    person_id numeric(10,0) NOT NULL,
    race character varying(5),
    gender character varying(1),
    birth_date timestamp without time zone,
    epi_first_name character varying(25),
    epi_middle_name character varying(25),
    epi_last_name character varying(240),
    birth_time timestamp without time zone,
    death_date timestamp without time zone,
    national_id character varying(240),
    ethnicity character varying(1),
    school_attend character varying(240),
    medicare_id character varying(240),
    medicaid_id character varying(240),
    birth_place character varying(35),
    lastupdated timestamp(6) without time zone,
    external_id character varying(20),
    chart_number character varying(20),
    entered_birth_date character varying(10),
    uuid character varying(100)
);


ALTER TABLE clinlims.patient OWNER TO clinlims;

--
-- Name: COLUMN patient.race; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN patient.race IS 'A string of 1 character race code(s)';


--
-- Name: COLUMN patient.gender; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN patient.gender IS 'A one character gender code';


--
-- Name: COLUMN patient.birth_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN patient.birth_date IS 'Date of birth';


--
-- Name: COLUMN patient.birth_time; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN patient.birth_time IS 'Time of birth for newborn patients';


--
-- Name: COLUMN patient.death_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN patient.death_date IS 'Date of death if unexplained illness or death';


--
-- Name: COLUMN patient.national_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN patient.national_id IS 'National Patient ID or SSN';


--
-- Name: COLUMN patient.medicare_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN patient.medicare_id IS 'Medicare Number';


--
-- Name: COLUMN patient.medicaid_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN patient.medicaid_id IS 'Medicaid Number';


--
-- Name: COLUMN patient.entered_birth_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN patient.entered_birth_date IS 'Persons birthdate may not be known and it will be entered with XX for date and/or month';


--
-- Name: patient_identity; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE patient_identity (
    id numeric(10,0) NOT NULL,
    identity_type_id numeric(10,0),
    patient_id numeric(10,0),
    identity_data character varying(255),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.patient_identity OWNER TO clinlims;

--
-- Name: patient_identity_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE patient_identity_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.patient_identity_seq OWNER TO clinlims;

--
-- Name: patient_identity_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE patient_identity_type (
    id numeric(10,0) NOT NULL,
    identity_type character varying(30),
    description character varying(400),
    lastupdated timestamp without time zone
);


ALTER TABLE clinlims.patient_identity_type OWNER TO clinlims;

--
-- Name: patient_identity_type_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE patient_identity_type_seq
    START WITH 30
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.patient_identity_type_seq OWNER TO clinlims;

--
-- Name: patient_occupation; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE patient_occupation (
    id numeric(10,0) NOT NULL,
    patient_id numeric(10,0),
    occupation character varying(400),
    lastupdated timestamp without time zone
);


ALTER TABLE clinlims.patient_occupation OWNER TO clinlims;

--
-- Name: patient_occupation_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE patient_occupation_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.patient_occupation_seq OWNER TO clinlims;

--
-- Name: patient_patient_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE patient_patient_type (
    id numeric(10,0) NOT NULL,
    patient_type_id numeric(10,0),
    patient_id numeric(10,0),
    lastupdated timestamp without time zone
);


ALTER TABLE clinlims.patient_patient_type OWNER TO clinlims;

--
-- Name: patient_patient_type_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE patient_patient_type_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.patient_patient_type_seq OWNER TO clinlims;

--
-- Name: patient_relation_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE patient_relation_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.patient_relation_seq OWNER TO clinlims;

--
-- Name: patient_relations; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE patient_relations (
    id numeric(10,0) NOT NULL,
    pat_id_source numeric(10,0) NOT NULL,
    pat_id numeric(10,0),
    relation character varying(1)
);


ALTER TABLE clinlims.patient_relations OWNER TO clinlims;

--
-- Name: COLUMN patient_relations.relation; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN patient_relations.relation IS 'Type of relation (mother to child, parent to child, sibling)';


--
-- Name: patient_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE patient_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.patient_seq OWNER TO clinlims;

--
-- Name: patient_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE patient_type (
    id numeric(10,0) NOT NULL,
    type character varying(300),
    description character varying(4000),
    lastupdated timestamp without time zone
);


ALTER TABLE clinlims.patient_type OWNER TO clinlims;

--
-- Name: patient_type_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE patient_type_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.patient_type_seq OWNER TO clinlims;

--
-- Name: payment_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE payment_type (
    id numeric(10,0) NOT NULL,
    type character varying(300),
    description character varying(4000)
);


ALTER TABLE clinlims.payment_type OWNER TO clinlims;

--
-- Name: payment_type_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE payment_type_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.payment_type_seq OWNER TO clinlims;

--
-- Name: person; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE person (
    id numeric(10,0) NOT NULL,
    last_name character varying(50),
    first_name character varying(50),
    middle_name character varying(50),
    multiple_unit character varying(30),
    street_address character(30),
    city character(30),
    state character(2),
    zip_code character(10),
    country character varying(20),
    work_phone character varying(17),
    home_phone character(12),
    cell_phone character varying(17),
    fax character varying(17),
    email character varying(60),
    lastupdated timestamp(6) without time zone,
    is_active boolean DEFAULT true
);


ALTER TABLE clinlims.person OWNER TO clinlims;

--
-- Name: COLUMN person.last_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN person.last_name IS 'Last name';


--
-- Name: COLUMN person.first_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN person.first_name IS 'Person Name';


--
-- Name: COLUMN person.middle_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN person.middle_name IS 'Middle Name';


--
-- Name: COLUMN person.multiple_unit; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN person.multiple_unit IS 'Designates a specific part of a building, such as "APT 212"';


--
-- Name: person_address; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE person_address (
    person_id numeric(10,0) NOT NULL,
    address_part_id numeric(10,0) NOT NULL,
    type character(1) DEFAULT 'T'::bpchar,
    value character varying(120)
);


ALTER TABLE clinlims.person_address OWNER TO clinlims;

--
-- Name: TABLE person_address; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE person_address IS 'Join table between address parts and a person';


--
-- Name: COLUMN person_address.person_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN person_address.person_id IS 'The id of the person who this address is attached to';


--
-- Name: COLUMN person_address.address_part_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN person_address.address_part_id IS 'The id of the address part for which we have a value';


--
-- Name: COLUMN person_address.type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN person_address.type IS 'The type of the value, either D for dictionary or T for text';


--
-- Name: COLUMN person_address.value; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN person_address.value IS 'The actual value for this part of the address';


--
-- Name: person_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE person_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.person_seq OWNER TO clinlims;

--
-- Name: program; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE program (
    id numeric(10,0) NOT NULL,
    code character varying(10) NOT NULL,
    name character varying(50) NOT NULL,
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.program OWNER TO clinlims;

--
-- Name: COLUMN program.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN program.name IS 'EPI PROGRAM NAME';


--
-- Name: program_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE program_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.program_seq OWNER TO clinlims;

--
-- Name: project; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE project (
    id numeric(10,0) NOT NULL,
    name character varying(50) NOT NULL,
    sys_user_id numeric(10,0),
    description character varying(60),
    started_date timestamp without time zone,
    completed_date timestamp without time zone,
    is_active character varying(1),
    reference_to character varying(20),
    program_code character varying(10),
    lastupdated timestamp(6) without time zone,
    scriptlet_id numeric(10,0),
    local_abbrev numeric(10,0),
    display_key character varying(60)
);


ALTER TABLE clinlims.project OWNER TO clinlims;

--
-- Name: COLUMN project.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN project.id IS 'Sequential number assigned by sequence';


--
-- Name: COLUMN project.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN project.name IS 'Short name of Project';


--
-- Name: COLUMN project.sys_user_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN project.sys_user_id IS 'Sequential Identifier';


--
-- Name: COLUMN project.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN project.description IS 'Description of Project';


--
-- Name: COLUMN project.started_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN project.started_date IS 'Start date of project';


--
-- Name: COLUMN project.completed_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN project.completed_date IS 'End date of project';


--
-- Name: COLUMN project.is_active; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN project.is_active IS 'Flag indicating if project is active';


--
-- Name: COLUMN project.reference_to; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN project.reference_to IS 'External reference information such as Grant number, contract number or purchase order number associated with this project.';


--
-- Name: COLUMN project.display_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN project.display_key IS 'Resource file lookup key for localization of displaying the name';


--
-- Name: project_organization; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE project_organization (
    project_id numeric(10,0) NOT NULL,
    org_id numeric(10,0) NOT NULL
);


ALTER TABLE clinlims.project_organization OWNER TO clinlims;

--
-- Name: TABLE project_organization; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE project_organization IS 'many to many mapping table between project and organization';


--
-- Name: project_parameter; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE project_parameter (
    id numeric(10,0) NOT NULL,
    projparam_type character varying(1),
    operation character varying(2),
    value character varying(256),
    project_id numeric(10,0),
    param_name character varying(80)
);


ALTER TABLE clinlims.project_parameter OWNER TO clinlims;

--
-- Name: COLUMN project_parameter.projparam_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN project_parameter.projparam_type IS 'Type of parameter: apply-parameter or search-parameter';


--
-- Name: COLUMN project_parameter.operation; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN project_parameter.operation IS 'Operation to be performed: =, <, <=, >, >=,in,!=';


--
-- Name: COLUMN project_parameter.value; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN project_parameter.value IS 'Query or Set value';


--
-- Name: project_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE project_seq
    START WITH 13
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.project_seq OWNER TO clinlims;

--
-- Name: provider; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE provider (
    id numeric(10,0) NOT NULL,
    npi character varying(10),
    person_id numeric(10,0) NOT NULL,
    external_id character varying(50),
    provider_type character varying(1),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.provider OWNER TO clinlims;

--
-- Name: COLUMN provider.npi; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN provider.npi IS 'Unique National Provider ID';


--
-- Name: COLUMN provider.external_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN provider.external_id IS 'National/Local provider reference number such as UPIN or MINC#NIMC';


--
-- Name: COLUMN provider.provider_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN provider.provider_type IS 'Type of Provider (physician, nurse)';


--
-- Name: provider_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE provider_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.provider_seq OWNER TO clinlims;

--
-- Name: qa_event; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qa_event (
    id numeric(10,0) NOT NULL,
    name character varying(20),
    description character varying(120),
    is_billable character varying(1),
    reporting_sequence numeric,
    reporting_text character varying(1000),
    test_id numeric(10,0),
    is_holdable character varying(1) NOT NULL,
    lastupdated timestamp(6) without time zone,
    type numeric(10,0),
    category numeric(10,0),
    display_key character varying(60)
);


ALTER TABLE clinlims.qa_event OWNER TO clinlims;

--
-- Name: COLUMN qa_event.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qa_event.name IS 'Short Name';


--
-- Name: COLUMN qa_event.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qa_event.description IS 'Description of the QA event';


--
-- Name: COLUMN qa_event.is_billable; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qa_event.is_billable IS 'Indicates if analysis with this QA Event is billable';


--
-- Name: COLUMN qa_event.reporting_sequence; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qa_event.reporting_sequence IS 'An overall number that orders the print sequence';


--
-- Name: COLUMN qa_event.test_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qa_event.test_id IS 'Reported/printed text';


--
-- Name: COLUMN qa_event.display_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qa_event.display_key IS 'Resource file lookup key for localization of displaying the name';


--
-- Name: qa_event_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE qa_event_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.qa_event_seq OWNER TO clinlims;

--
-- Name: qa_observation; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qa_observation (
    id numeric(10,0) NOT NULL,
    observed_id numeric(10,0) NOT NULL,
    observed_type character varying(30) NOT NULL,
    qa_observation_type_id numeric(10,0) NOT NULL,
    value_type character varying(1) NOT NULL,
    value character varying(30) NOT NULL,
    lastupdated timestamp with time zone DEFAULT now()
);


ALTER TABLE clinlims.qa_observation OWNER TO clinlims;

--
-- Name: TABLE qa_observation; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE qa_observation IS 'The observation that are about sample/analysis qa_events.  Does not include data about the sample';


--
-- Name: COLUMN qa_observation.observed_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qa_observation.observed_id IS 'The row id for either sample_qaEvent or analysis_qaEvent';


--
-- Name: COLUMN qa_observation.observed_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qa_observation.observed_type IS 'One of ANALYSIS or SAMPLE';


--
-- Name: COLUMN qa_observation.qa_observation_type_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qa_observation.qa_observation_type_id IS 'The type of observation this is';


--
-- Name: COLUMN qa_observation.value_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qa_observation.value_type IS 'Dictionary or literal, D or L';


--
-- Name: COLUMN qa_observation.value; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qa_observation.value IS 'The actual value';


--
-- Name: qa_observation_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE qa_observation_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.qa_observation_seq OWNER TO clinlims;

--
-- Name: qa_observation_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qa_observation_type (
    id numeric(10,0) NOT NULL,
    name character varying(30) NOT NULL,
    description character varying(60),
    lastupdated timestamp with time zone DEFAULT now()
);


ALTER TABLE clinlims.qa_observation_type OWNER TO clinlims;

--
-- Name: TABLE qa_observation_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE qa_observation_type IS 'The types of observation that are about sample/analysis qa_events ';


--
-- Name: qa_observation_type_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE qa_observation_type_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.qa_observation_type_seq OWNER TO clinlims;

--
-- Name: qc; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qc (
    id numeric NOT NULL,
    uom_id numeric(10,0),
    sys_user_id numeric(10,0),
    name character varying(30),
    source character varying(30),
    lot_number character varying(30),
    prepared_date timestamp without time zone,
    prepared_volume numeric,
    usable_date timestamp without time zone,
    expire_date timestamp without time zone
);


ALTER TABLE clinlims.qc OWNER TO clinlims;

--
-- Name: COLUMN qc.sys_user_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qc.sys_user_id IS 'Sequential Identifier';


--
-- Name: COLUMN qc.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qc.name IS 'Descriptive QC name: Positive control for CHL';


--
-- Name: COLUMN qc.source; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qc.source IS 'Name of supplier such as company or in-house';


--
-- Name: COLUMN qc.lot_number; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qc.lot_number IS 'Lot number';


--
-- Name: COLUMN qc.prepared_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qc.prepared_date IS 'Date QC was prepared';


--
-- Name: COLUMN qc.prepared_volume; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qc.prepared_volume IS 'Amount prepared';


--
-- Name: COLUMN qc.usable_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qc.usable_date IS 'Cannot be used before this date';


--
-- Name: COLUMN qc.expire_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qc.expire_date IS 'Cannot be used after this date';


--
-- Name: qc_analytes; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qc_analytes (
    id numeric(10,0) NOT NULL,
    qcanaly_type character varying(1),
    value character varying(80),
    analyte_id numeric(10,0)
);


ALTER TABLE clinlims.qc_analytes OWNER TO clinlims;

--
-- Name: COLUMN qc_analytes.qcanaly_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qc_analytes.qcanaly_type IS 'Type of value: dictionary, titer range, number range, true value';


--
-- Name: COLUMN qc_analytes.value; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN qc_analytes.value IS 'Min max,, true value & % if type is any range';


--
-- Name: qrtz_blob_triggers; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qrtz_blob_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    blob_data bytea
);


ALTER TABLE clinlims.qrtz_blob_triggers OWNER TO clinlims;

--
-- Name: qrtz_calendars; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qrtz_calendars (
    calendar_name character varying(80) NOT NULL,
    calendar bytea NOT NULL
);


ALTER TABLE clinlims.qrtz_calendars OWNER TO clinlims;

--
-- Name: qrtz_cron_triggers; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qrtz_cron_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    cron_expression character varying(80) NOT NULL,
    time_zone_id character varying(80)
);


ALTER TABLE clinlims.qrtz_cron_triggers OWNER TO clinlims;

--
-- Name: qrtz_fired_triggers; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qrtz_fired_triggers (
    entry_id character varying(95) NOT NULL,
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    is_volatile boolean NOT NULL,
    instance_name character varying(80) NOT NULL,
    fired_time bigint NOT NULL,
    priority integer NOT NULL,
    state character varying(16) NOT NULL,
    job_name character varying(80),
    job_group character varying(80),
    is_stateful boolean,
    requests_recovery boolean
);


ALTER TABLE clinlims.qrtz_fired_triggers OWNER TO clinlims;

--
-- Name: qrtz_job_details; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qrtz_job_details (
    job_name character varying(80) NOT NULL,
    job_group character varying(80) NOT NULL,
    description character varying(120),
    job_class_name character varying(128) NOT NULL,
    is_durable boolean NOT NULL,
    is_volatile boolean NOT NULL,
    is_stateful boolean NOT NULL,
    requests_recovery boolean NOT NULL,
    job_data bytea
);


ALTER TABLE clinlims.qrtz_job_details OWNER TO clinlims;

--
-- Name: qrtz_job_listeners; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qrtz_job_listeners (
    job_name character varying(80) NOT NULL,
    job_group character varying(80) NOT NULL,
    job_listener character varying(80) NOT NULL
);


ALTER TABLE clinlims.qrtz_job_listeners OWNER TO clinlims;

--
-- Name: qrtz_locks; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qrtz_locks (
    lock_name character varying(40) NOT NULL
);


ALTER TABLE clinlims.qrtz_locks OWNER TO clinlims;

--
-- Name: qrtz_paused_trigger_grps; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qrtz_paused_trigger_grps (
    trigger_group character varying(80) NOT NULL
);


ALTER TABLE clinlims.qrtz_paused_trigger_grps OWNER TO clinlims;

--
-- Name: qrtz_scheduler_state; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qrtz_scheduler_state (
    instance_name character varying(80) NOT NULL,
    last_checkin_time bigint NOT NULL,
    checkin_interval bigint NOT NULL
);


ALTER TABLE clinlims.qrtz_scheduler_state OWNER TO clinlims;

--
-- Name: qrtz_simple_triggers; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qrtz_simple_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    repeat_count bigint NOT NULL,
    repeat_interval bigint NOT NULL,
    times_triggered bigint NOT NULL
);


ALTER TABLE clinlims.qrtz_simple_triggers OWNER TO clinlims;

--
-- Name: qrtz_trigger_listeners; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qrtz_trigger_listeners (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    trigger_listener character varying(80) NOT NULL
);


ALTER TABLE clinlims.qrtz_trigger_listeners OWNER TO clinlims;

--
-- Name: qrtz_triggers; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE qrtz_triggers (
    trigger_name character varying(80) NOT NULL,
    trigger_group character varying(80) NOT NULL,
    job_name character varying(80) NOT NULL,
    job_group character varying(80) NOT NULL,
    is_volatile boolean NOT NULL,
    description character varying(120),
    next_fire_time bigint,
    prev_fire_time bigint,
    priority integer,
    trigger_state character varying(16) NOT NULL,
    trigger_type character varying(8) NOT NULL,
    start_time bigint NOT NULL,
    end_time bigint,
    calendar_name character varying(80),
    misfire_instr smallint,
    job_data bytea
);


ALTER TABLE clinlims.qrtz_triggers OWNER TO clinlims;

--
-- Name: quartz_cron_scheduler; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE quartz_cron_scheduler (
    id numeric(10,0) NOT NULL,
    cron_statement character varying(32) DEFAULT 'never'::character varying NOT NULL,
    last_run timestamp with time zone,
    active boolean DEFAULT true,
    run_if_past boolean DEFAULT true,
    name character varying(40),
    job_name character varying(60) NOT NULL,
    display_key character varying(60),
    description_key character varying(60)
);


ALTER TABLE clinlims.quartz_cron_scheduler OWNER TO clinlims;

--
-- Name: TABLE quartz_cron_scheduler; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE quartz_cron_scheduler IS 'Sets up the quartz scheduler for cron jobs';


--
-- Name: COLUMN quartz_cron_scheduler.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN quartz_cron_scheduler.id IS 'Id for this schedule';


--
-- Name: COLUMN quartz_cron_scheduler.cron_statement; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN quartz_cron_scheduler.cron_statement IS 'The cron statement for when the job should run. N.B. the default is not a valid cron expression';


--
-- Name: COLUMN quartz_cron_scheduler.last_run; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN quartz_cron_scheduler.last_run IS 'The last time this job was run';


--
-- Name: COLUMN quartz_cron_scheduler.active; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN quartz_cron_scheduler.active IS 'True if the schedule is active, false if it is suspended';


--
-- Name: COLUMN quartz_cron_scheduler.run_if_past; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN quartz_cron_scheduler.run_if_past IS 'True if the job should be run if the application is started after the run time and it has not run yet that day';


--
-- Name: COLUMN quartz_cron_scheduler.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN quartz_cron_scheduler.name IS 'The name for this job';


--
-- Name: COLUMN quartz_cron_scheduler.job_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN quartz_cron_scheduler.job_name IS 'The internal job name, should not be editible by end user';


--
-- Name: COLUMN quartz_cron_scheduler.display_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN quartz_cron_scheduler.display_key IS 'The localized name for this job';


--
-- Name: quartz_cron_scheduler_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE quartz_cron_scheduler_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.quartz_cron_scheduler_seq OWNER TO clinlims;

--
-- Name: race; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE race (
    id numeric(10,0) NOT NULL,
    description character varying(20) NOT NULL,
    race_type character varying(1),
    is_active character(1)
);


ALTER TABLE clinlims.race OWNER TO clinlims;

--
-- Name: receiver_code_element; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE receiver_code_element (
    id numeric(10,0) NOT NULL,
    identifier character varying(20),
    text character varying(60),
    code_system character varying(20),
    lastupdated timestamp(6) without time zone,
    message_org_id numeric(10,0),
    code_element_type_id numeric(10,0)
);


ALTER TABLE clinlims.receiver_code_element OWNER TO clinlims;

--
-- Name: receiver_code_element_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE receiver_code_element_seq
    START WITH 21
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.receiver_code_element_seq OWNER TO clinlims;

--
-- Name: reference_tables; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE reference_tables (
    id numeric(10,0) NOT NULL,
    name character varying(40),
    keep_history character varying(1),
    is_hl7_encoded character varying(1),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.reference_tables OWNER TO clinlims;

--
-- Name: COLUMN reference_tables.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN reference_tables.name IS 'Name of table or module';


--
-- Name: reference_tables_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE reference_tables_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.reference_tables_seq OWNER TO clinlims;

--
-- Name: referral; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE referral (
    id numeric(10,0) NOT NULL,
    analysis_id numeric(10,0),
    organization_id numeric(10,0),
    organization_name character varying(30),
    send_ready_date timestamp with time zone,
    sent_date timestamp with time zone,
    result_recieved_date timestamp with time zone,
    referral_reason_id numeric(10,0),
    referral_type_id numeric(10,0) NOT NULL,
    requester_name character varying(60),
    lastupdated timestamp with time zone,
    canceled boolean DEFAULT false,
    referral_request_date timestamp with time zone
);


ALTER TABLE clinlims.referral OWNER TO clinlims;

--
-- Name: TABLE referral; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE referral IS 'Tracks referrals made to and from the lab.  If referrals should be attached to samples add another column for sample and edit this comment';


--
-- Name: COLUMN referral.analysis_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral.analysis_id IS 'The analysis which will be duplicated at other lab when refering out or which will be be done at this lab when referred in.  ';


--
-- Name: COLUMN referral.organization_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral.organization_id IS 'The organization the sample was sent to or from';


--
-- Name: COLUMN referral.organization_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral.organization_name IS 'The organiztion the sample was sent to or from, if busness rules allow them not to be in the organization table';


--
-- Name: COLUMN referral.send_ready_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral.send_ready_date IS 'The date the referral out results are ready to be sent';


--
-- Name: COLUMN referral.sent_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral.sent_date IS 'The date the referral out results are actually sent';


--
-- Name: COLUMN referral.result_recieved_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral.result_recieved_date IS 'If this was a referral out then the date the results were recieved from the external lab';


--
-- Name: COLUMN referral.referral_reason_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral.referral_reason_id IS 'Why was this referral done';


--
-- Name: COLUMN referral.requester_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral.requester_name IS 'The name of the person who requested that the referral be done';


--
-- Name: COLUMN referral.referral_request_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral.referral_request_date IS 'The date the referral request was made';


--
-- Name: referral_reason; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE referral_reason (
    id numeric(10,0) NOT NULL,
    name character varying(30) NOT NULL,
    description character varying(60),
    display_key character varying(60),
    lastupdated timestamp with time zone
);


ALTER TABLE clinlims.referral_reason OWNER TO clinlims;

--
-- Name: TABLE referral_reason; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE referral_reason IS 'The reason a referral was made to or from the lab';


--
-- Name: COLUMN referral_reason.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral_reason.name IS 'The name of the reason, default value displayed to user if no display_key value';


--
-- Name: COLUMN referral_reason.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral_reason.description IS 'Clarification of the reason';


--
-- Name: COLUMN referral_reason.display_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral_reason.display_key IS 'Key for localization files to display locale appropriate reasons';


--
-- Name: referral_reason_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE referral_reason_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.referral_reason_seq OWNER TO clinlims;

--
-- Name: referral_result; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE referral_result (
    id numeric(10,0) NOT NULL,
    referral_id numeric(10,0) NOT NULL,
    test_id numeric(10,0),
    result_id numeric(10,0),
    referral_report_date timestamp with time zone,
    lastupdated timestamp with time zone
);


ALTER TABLE clinlims.referral_result OWNER TO clinlims;

--
-- Name: TABLE referral_result; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE referral_result IS 'A referral may have one or more results';


--
-- Name: COLUMN referral_result.referral_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral_result.referral_id IS 'The referral for which this is a result. May be one to many';


--
-- Name: COLUMN referral_result.test_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral_result.test_id IS 'When the referral lab reported the results back';


--
-- Name: COLUMN referral_result.result_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral_result.result_id IS 'The result returned by the referral lab';


--
-- Name: referral_result_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE referral_result_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.referral_result_seq OWNER TO clinlims;

--
-- Name: referral_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE referral_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.referral_seq OWNER TO clinlims;

--
-- Name: referral_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE referral_type (
    id numeric(10,0) NOT NULL,
    name character varying(30) NOT NULL,
    description character varying(60),
    display_key character varying(60),
    lastupdated timestamp with time zone
);


ALTER TABLE clinlims.referral_type OWNER TO clinlims;

--
-- Name: TABLE referral_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE referral_type IS 'The type of referral. i.e. a referral into the lab or a referral out of the lab';


--
-- Name: COLUMN referral_type.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral_type.name IS 'The name of the type, default value displayed to user if no display_key value';


--
-- Name: COLUMN referral_type.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral_type.description IS 'Clarification of the type';


--
-- Name: COLUMN referral_type.display_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN referral_type.display_key IS 'Key for localization files to display locale appropriate types';


--
-- Name: referral_type_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE referral_type_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.referral_type_seq OWNER TO clinlims;

--
-- Name: region; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE region (
    id numeric(10,0) NOT NULL,
    region character varying(240) NOT NULL,
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.region OWNER TO clinlims;

--
-- Name: COLUMN region.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN region.id IS 'Sequential Number';


--
-- Name: COLUMN region.region; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN region.region IS 'Epidemiology Region Description used for MLS';


--
-- Name: region_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE region_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.region_seq OWNER TO clinlims;

--
-- Name: report_external_export; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE report_external_export (
    id numeric(10,0) NOT NULL,
    event_date timestamp with time zone NOT NULL,
    collection_date timestamp with time zone NOT NULL,
    sent_date timestamp with time zone,
    type numeric(10,0) NOT NULL,
    data text,
    lastupdated timestamp with time zone,
    send_flag boolean DEFAULT true,
    bookkeeping text
);


ALTER TABLE clinlims.report_external_export OWNER TO clinlims;

--
-- Name: TABLE report_external_export; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE report_external_export IS 'Table for holding aggregated results to be sent to an external application';


--
-- Name: COLUMN report_external_export.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_export.id IS 'primary key';


--
-- Name: COLUMN report_external_export.event_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_export.event_date IS 'The date for which the information was collected.  Granularity assumed to be one day';


--
-- Name: COLUMN report_external_export.collection_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_export.collection_date IS 'The date on which the information was collected.';


--
-- Name: COLUMN report_external_export.sent_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_export.sent_date IS 'The date which the data was successfully sent';


--
-- Name: COLUMN report_external_export.type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_export.type IS 'The type of report this is';


--
-- Name: COLUMN report_external_export.data; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_export.data IS 'Formated data.  May be either JASON or xml.  Many datapoints per row';


--
-- Name: COLUMN report_external_export.lastupdated; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_export.lastupdated IS 'The last time the row was updated for any reason';


--
-- Name: COLUMN report_external_export.send_flag; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_export.send_flag IS 'The data is ready to be sent.  It may have already been sent once';


--
-- Name: COLUMN report_external_export.bookkeeping; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_export.bookkeeping IS 'Data which the application will need to record that this document has been sent';


--
-- Name: report_external_import; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE report_external_import (
    id numeric(10,0) NOT NULL,
    sending_site character varying(20) NOT NULL,
    event_date timestamp with time zone NOT NULL,
    recieved_date timestamp with time zone,
    type character varying(32) NOT NULL,
    updated_flag boolean DEFAULT false,
    data text,
    lastupdated timestamp with time zone
);


ALTER TABLE clinlims.report_external_import OWNER TO clinlims;

--
-- Name: TABLE report_external_import; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE report_external_import IS 'Table for holding aggregated results sent by an external application';


--
-- Name: COLUMN report_external_import.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_import.id IS 'primary key';


--
-- Name: COLUMN report_external_import.sending_site; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_import.sending_site IS 'The site which is sending the info';


--
-- Name: COLUMN report_external_import.event_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_import.event_date IS 'The date for which the information was collected.  Granularity assumed to be one day';


--
-- Name: COLUMN report_external_import.recieved_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_import.recieved_date IS 'The date which the data was received';


--
-- Name: COLUMN report_external_import.type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_import.type IS 'The type of report this is';


--
-- Name: COLUMN report_external_import.data; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_import.data IS 'Formated data.  May be either JASON or xml.  Many datapoints per row';


--
-- Name: COLUMN report_external_import.lastupdated; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN report_external_import.lastupdated IS 'The last time the row was updated for any reason';


--
-- Name: report_external_import_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE report_external_import_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.report_external_import_seq OWNER TO clinlims;

--
-- Name: report_queue_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE report_queue_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.report_queue_seq OWNER TO clinlims;

--
-- Name: report_queue_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE report_queue_type (
    id numeric(10,0) NOT NULL,
    name character varying(32) NOT NULL,
    description character varying(60)
);


ALTER TABLE clinlims.report_queue_type OWNER TO clinlims;

--
-- Name: report_queue_type_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE report_queue_type_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.report_queue_type_seq OWNER TO clinlims;

--
-- Name: requester_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE requester_type (
    id numeric(10,0) NOT NULL,
    requester_type character varying(20) NOT NULL
);


ALTER TABLE clinlims.requester_type OWNER TO clinlims;

--
-- Name: TABLE requester_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE requester_type IS 'The types of entities which can request test.  This table will be used by sample_requester so the type should map to table';


--
-- Name: COLUMN requester_type.requester_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN requester_type.requester_type IS 'The type. i.e. organization or provider';


--
-- Name: requester_type_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE requester_type_seq
    START WITH 2
    INCREMENT BY 1
    MINVALUE 2
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.requester_type_seq OWNER TO clinlims;

--
-- Name: result; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE result (
    id numeric(10,0) NOT NULL,
    analysis_id numeric(10,0),
    sort_order numeric,
    is_reportable character varying(1),
    result_type character varying(1),
    value text,
    analyte_id numeric(10,0),
    test_result_id numeric(10,0),
    lastupdated timestamp(6) without time zone,
    min_normal double precision,
    max_normal double precision,
    parent_id numeric(10,0),
    abnormal boolean DEFAULT false,
    uploaded_file_name character varying(500),
    result_limit_id numeric
);


ALTER TABLE clinlims.result OWNER TO clinlims;

--
-- Name: COLUMN result.analysis_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result.analysis_id IS 'Sequential number';


--
-- Name: COLUMN result.sort_order; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result.sort_order IS 'The order the results are displayed (sort order)';


--
-- Name: COLUMN result.is_reportable; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result.is_reportable IS 'Indicates if the result is reportable.';


--
-- Name: COLUMN result.result_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result.result_type IS 'Type of result: Dictionary, titer, number, date';


--
-- Name: COLUMN result.value; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result.value IS 'Actual result value.';


--
-- Name: COLUMN result.min_normal; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result.min_normal IS 'The min normal value for this result. (May vary by patient sex and age)';


--
-- Name: COLUMN result.max_normal; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result.max_normal IS 'The max normal value for this result. (May vary by patient sex and age)';


--
-- Name: COLUMN result.parent_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result.parent_id IS 'The id of the result that this result is dependent on';


--
-- Name: result_inventory; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE result_inventory (
    id numeric(10,0) NOT NULL,
    inventory_location_id numeric(10,0) NOT NULL,
    result_id numeric(10,0) NOT NULL,
    description character varying(20),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.result_inventory OWNER TO clinlims;

--
-- Name: TABLE result_inventory; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE result_inventory IS 'Table to link analyte, inventory_items and results.  This is to tie a specific test kit to HIV or syphilis test result.';


--
-- Name: COLUMN result_inventory.inventory_location_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_inventory.inventory_location_id IS 'The specific identifiable inventory.  For Haiti this should be a test kit in inventory';


--
-- Name: COLUMN result_inventory.result_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_inventory.result_id IS 'The result which is tied to the inventory';


--
-- Name: COLUMN result_inventory.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_inventory.description IS 'The description of inventory the result refers to.';


--
-- Name: result_inventory_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE result_inventory_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.result_inventory_seq OWNER TO clinlims;

--
-- Name: result_limits; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE result_limits (
    id numeric(10,0) NOT NULL,
    test_id numeric(10,0) NOT NULL,
    test_result_type_id numeric NOT NULL,
    min_age double precision DEFAULT 0,
    max_age double precision DEFAULT 'Infinity'::double precision,
    gender character(1),
    low_normal double precision DEFAULT '-Infinity'::double precision,
    high_normal double precision DEFAULT 'Infinity'::double precision,
    low_valid double precision DEFAULT '-Infinity'::double precision,
    high_valid double precision DEFAULT 'Infinity'::double precision,
    lastupdated timestamp(6) without time zone,
    normal_dictionary_id numeric(10,0),
    always_validate boolean DEFAULT false
);


ALTER TABLE clinlims.result_limits OWNER TO clinlims;

--
-- Name: TABLE result_limits; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE result_limits IS 'This is a mainly read only table for normal and valid limits for given tests.  Currently it assumes that only age and gender matter.  If more criteria matter then refactor';


--
-- Name: COLUMN result_limits.test_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_limits.test_id IS 'Refers to the test table, this is additional information';


--
-- Name: COLUMN result_limits.test_result_type_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_limits.test_result_type_id IS 'The data type of the results';


--
-- Name: COLUMN result_limits.min_age; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_limits.min_age IS 'Should be null or less than max age';


--
-- Name: COLUMN result_limits.max_age; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_limits.max_age IS 'Should be null or greater than min age';


--
-- Name: COLUMN result_limits.gender; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_limits.gender IS 'Should be F or M or null if gender is not a criteria';


--
-- Name: COLUMN result_limits.low_normal; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_limits.low_normal IS 'Low end of normal range';


--
-- Name: COLUMN result_limits.high_normal; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_limits.high_normal IS 'High end of the normal range';


--
-- Name: COLUMN result_limits.low_valid; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_limits.low_valid IS 'Low end of the valid range, any result value lower should be considered suspect';


--
-- Name: COLUMN result_limits.high_valid; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_limits.high_valid IS 'high end of the valid range, any result value higher should be considered suspect';


--
-- Name: COLUMN result_limits.normal_dictionary_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_limits.normal_dictionary_id IS 'Reference to the dictionary value which is normal for test';


--
-- Name: COLUMN result_limits.always_validate; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_limits.always_validate IS 'Is further validation always required no matter what the results';


--
-- Name: result_limits_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE result_limits_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.result_limits_seq OWNER TO clinlims;

--
-- Name: result_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE result_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.result_seq OWNER TO clinlims;

--
-- Name: result_signature; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE result_signature (
    id numeric(10,0) NOT NULL,
    result_id numeric(10,0) NOT NULL,
    system_user_id numeric(10,0),
    is_supervisor boolean DEFAULT false NOT NULL,
    lastupdated timestamp(6) without time zone,
    non_user_name character varying(20)
);


ALTER TABLE clinlims.result_signature OWNER TO clinlims;

--
-- Name: TABLE result_signature; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE result_signature IS 'This matches the person who signed the result form with the result.';


--
-- Name: COLUMN result_signature.result_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_signature.result_id IS 'The result which is being signed';


--
-- Name: COLUMN result_signature.system_user_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_signature.system_user_id IS 'The signer of the result';


--
-- Name: COLUMN result_signature.is_supervisor; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_signature.is_supervisor IS 'Is the signer a supervisor';


--
-- Name: COLUMN result_signature.non_user_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN result_signature.non_user_name IS 'For signers that are not systemUsers';


--
-- Name: result_signature_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE result_signature_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.result_signature_seq OWNER TO clinlims;

--
-- Name: sample; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sample (
    id numeric(10,0) NOT NULL,
    accession_number character varying(20),
    package_id numeric(10,0),
    domain character varying(1),
    next_item_sequence numeric(10,0),
    revision numeric,
    entered_date timestamp without time zone NOT NULL,
    received_date timestamp without time zone NOT NULL,
    collection_date timestamp without time zone,
    client_reference character varying(20),
    status character varying(1),
    released_date timestamp without time zone,
    sticker_rcvd_flag character varying(1),
    sys_user_id numeric(10,0),
    barcode character varying(20),
    transmission_date timestamp without time zone,
    lastupdated timestamp(6) without time zone,
    spec_or_isolate character varying(1),
    priority numeric(1,0),
    status_id numeric(10,0),
    sample_source_id integer,
    uuid character varying(100)
);


ALTER TABLE clinlims.sample OWNER TO clinlims;

--
-- Name: COLUMN sample.status_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample.status_id IS 'foriegn key to status of analysis ';


--
-- Name: sample_animal; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sample_animal (
    id numeric(10,0) NOT NULL,
    sci_name_id numeric(10,0) NOT NULL,
    comm_anim_id numeric(10,0) NOT NULL,
    sampling_location character varying(40),
    collector character varying(40),
    samp_id numeric(10,0) NOT NULL,
    multiple_unit character varying(30),
    street_address character varying(30),
    city character varying(30),
    state character varying(2),
    country character varying(20),
    zip_code character varying(10)
);


ALTER TABLE clinlims.sample_animal OWNER TO clinlims;

--
-- Name: COLUMN sample_animal.sci_name_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_animal.sci_name_id IS 'Sequential Number';


--
-- Name: COLUMN sample_animal.sampling_location; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_animal.sampling_location IS 'Sampling location - name of farm';


--
-- Name: COLUMN sample_animal.collector; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_animal.collector IS 'Person collecting sample';


--
-- Name: COLUMN sample_animal.samp_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_animal.samp_id IS 'MDH Specimen Number';


--
-- Name: COLUMN sample_animal.street_address; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_animal.street_address IS 'Address of animal';


--
-- Name: sample_domain; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sample_domain (
    id numeric(10,0) NOT NULL,
    domain_description character varying(20),
    domain character varying(1),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.sample_domain OWNER TO clinlims;

--
-- Name: COLUMN sample_domain.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_domain.id IS 'A unique auto generated integer number assigned by the database.';


--
-- Name: COLUMN sample_domain.domain_description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_domain.domain_description IS 'Type of sample this can be applied to:environ, human, animal, rabies, bt, newborn.';


--
-- Name: COLUMN sample_domain.domain; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_domain.domain IS 'Code for description: E-Environmental, A-Animal, C-Clinical';


--
-- Name: sample_domain_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE sample_domain_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.sample_domain_seq OWNER TO clinlims;

--
-- Name: sample_environmental; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sample_environmental (
    id numeric(10,0) NOT NULL,
    samp_id numeric(10,0) NOT NULL,
    is_hazardous character varying(1),
    lot_nbr character varying(30),
    description character varying(40),
    chem_samp_num character varying(240),
    street_address character varying(30),
    multiple_unit character varying(30),
    city character varying(30),
    state character varying(2),
    zip_code character varying(10),
    country character varying(20),
    collector character varying(40),
    sampling_location character varying(40)
);


ALTER TABLE clinlims.sample_environmental OWNER TO clinlims;

--
-- Name: COLUMN sample_environmental.samp_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_environmental.samp_id IS 'MDH Specimen Number';


--
-- Name: COLUMN sample_environmental.lot_nbr; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_environmental.lot_nbr IS 'If sample is unopened package of food then include the lot number from the package';


--
-- Name: COLUMN sample_environmental.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_environmental.description IS 'Additional description field for sample attributes.';


--
-- Name: COLUMN sample_environmental.zip_code; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_environmental.zip_code IS 'Zip +4 code';


--
-- Name: COLUMN sample_environmental.collector; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_environmental.collector IS 'Person collecting the sample';


--
-- Name: COLUMN sample_environmental.sampling_location; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_environmental.sampling_location IS 'Sampling location - name of restaurant, store, farm';


--
-- Name: sample_human; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sample_human (
    id numeric(10,0) NOT NULL,
    provider_id numeric(10,0),
    samp_id numeric(10,0) NOT NULL,
    patient_id numeric(10,0),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.sample_human OWNER TO clinlims;

--
-- Name: COLUMN sample_human.samp_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_human.samp_id IS 'MDH Specimen Number';


--
-- Name: sample_human_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE sample_human_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.sample_human_seq OWNER TO clinlims;

--
-- Name: sample_item; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sample_item (
    id numeric(10,0) NOT NULL,
    sort_order numeric NOT NULL,
    sampitem_id numeric(10,0),
    samp_id numeric(10,0),
    source_id numeric(10,0),
    typeosamp_id numeric(10,0),
    uom_id numeric(10,0),
    source_other character varying(40),
    quantity numeric,
    lastupdated timestamp(6) without time zone,
    external_id character varying(20),
    collection_date timestamp with time zone,
    status_id numeric(10,0) NOT NULL,
    collector character varying(60)
);


ALTER TABLE clinlims.sample_item OWNER TO clinlims;

--
-- Name: COLUMN sample_item.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_item.id IS 'Sample source write in if not already defined';


--
-- Name: COLUMN sample_item.sort_order; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_item.sort_order IS 'Sample items unique sequence number for this sample';


--
-- Name: COLUMN sample_item.sampitem_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_item.sampitem_id IS 'Sample source write in if not already defined';


--
-- Name: COLUMN sample_item.samp_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_item.samp_id IS 'MDH Specimen Number';


--
-- Name: COLUMN sample_item.source_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_item.source_id IS 'A unique auto generated integer number assigned by the database.';


--
-- Name: COLUMN sample_item.typeosamp_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_item.typeosamp_id IS 'A unique auto generated integer number assigned by the database';


--
-- Name: COLUMN sample_item.source_other; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_item.source_other IS 'Sample source write in if not already defined';


--
-- Name: COLUMN sample_item.quantity; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_item.quantity IS 'Amount of sample';


--
-- Name: COLUMN sample_item.external_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_item.external_id IS 'An external id that may have been attached to the sample item before it came to the lab';


--
-- Name: COLUMN sample_item.collection_date; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_item.collection_date IS 'The date this sample_item was collected or seperated from other part of sample';


--
-- Name: COLUMN sample_item.status_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_item.status_id IS 'The status of this sample item';


--
-- Name: COLUMN sample_item.collector; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_item.collector IS 'The name of the person who collected the sample';


--
-- Name: sample_item_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE sample_item_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.sample_item_seq OWNER TO clinlims;

--
-- Name: sample_newborn; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sample_newborn (
    id numeric(10,0) NOT NULL,
    weight numeric(5,0),
    multi_birth character(1),
    birth_order numeric(2,0),
    gestational_week numeric(5,2),
    date_first_feeding date,
    breast character(1),
    tpn character(1),
    formula character(1),
    milk character(1),
    soy character(1),
    jaundice character(1),
    antibiotics character(1),
    transfused character(1),
    date_transfusion date,
    medical_record_numeric character varying(18),
    nicu character(1),
    birth_defect character(1),
    pregnancy_complication character(1),
    deceased_sibling character(1),
    cause_of_death character varying(50),
    family_history character(1),
    other character varying(100),
    y_numeric character varying(18),
    yellow_card character(1),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.sample_newborn OWNER TO clinlims;

--
-- Name: sample_org_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE sample_org_seq
    START WITH 112
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.sample_org_seq OWNER TO clinlims;

--
-- Name: sample_organization; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sample_organization (
    id numeric(10,0) NOT NULL,
    org_id numeric(10,0),
    samp_id numeric(10,0),
    samp_org_type character varying(1),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.sample_organization OWNER TO clinlims;

--
-- Name: COLUMN sample_organization.org_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_organization.org_id IS 'Sequential Numbering Field';


--
-- Name: COLUMN sample_organization.samp_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_organization.samp_id IS 'MDH Specimen Number';


--
-- Name: COLUMN sample_organization.samp_org_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_organization.samp_org_type IS 'Type of organization: Primary, Secondary, Billing';


--
-- Name: sample_pdf; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sample_pdf (
    id numeric(10,0) NOT NULL,
    accession_number numeric(10,0) NOT NULL,
    allow_view character varying(1),
    barcode character varying(20)
);


ALTER TABLE clinlims.sample_pdf OWNER TO clinlims;

--
-- Name: sample_pdf_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE sample_pdf_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.sample_pdf_seq OWNER TO clinlims;

--
-- Name: sample_proj_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE sample_proj_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.sample_proj_seq OWNER TO clinlims;

--
-- Name: sample_projects; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sample_projects (
    samp_id numeric(10,0) NOT NULL,
    proj_id numeric(10,0),
    is_permanent character varying(1),
    id numeric(10,0) NOT NULL,
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.sample_projects OWNER TO clinlims;

--
-- Name: COLUMN sample_projects.samp_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_projects.samp_id IS 'MDH Specimen Number';


--
-- Name: COLUMN sample_projects.proj_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_projects.proj_id IS 'Sequential number assigned by sequence';


--
-- Name: COLUMN sample_projects.is_permanent; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_projects.is_permanent IS 'Indicates if project is assigned to this sample permanently (Y/N)';


--
-- Name: sample_qaevent; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sample_qaevent (
    id numeric(10,0) NOT NULL,
    qa_event_id numeric(10,0),
    sample_id numeric(10,0),
    completed_date date,
    lastupdated timestamp without time zone,
    sampleitem_id numeric(10,0),
    entered_date timestamp with time zone
);


ALTER TABLE clinlims.sample_qaevent OWNER TO clinlims;

--
-- Name: COLUMN sample_qaevent.sampleitem_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_qaevent.sampleitem_id IS 'If the qaevent refers to a sampleitem of the sample use this column';


--
-- Name: sample_qaevent_action; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sample_qaevent_action (
    id numeric(10,0) NOT NULL,
    sample_qaevent_id numeric(10,0) NOT NULL,
    action_id numeric(10,0) NOT NULL,
    created_date date NOT NULL,
    lastupdated timestamp(6) without time zone,
    sys_user_id numeric(10,0)
);


ALTER TABLE clinlims.sample_qaevent_action OWNER TO clinlims;

--
-- Name: sample_qaevent_action_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE sample_qaevent_action_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.sample_qaevent_action_seq OWNER TO clinlims;

--
-- Name: sample_qaevent_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE sample_qaevent_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.sample_qaevent_seq OWNER TO clinlims;

--
-- Name: sample_requester; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sample_requester (
    sample_id numeric(10,0) NOT NULL,
    requester_id numeric(10,0) NOT NULL,
    requester_type_id numeric(10,0) NOT NULL,
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.sample_requester OWNER TO clinlims;

--
-- Name: TABLE sample_requester; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE sample_requester IS 'Links a sample to the entity which requested it';


--
-- Name: COLUMN sample_requester.sample_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_requester.sample_id IS 'The sample';


--
-- Name: COLUMN sample_requester.requester_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_requester.requester_id IS 'The requester_id.  The exact table row depends on the requester type';


--
-- Name: COLUMN sample_requester.requester_type_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN sample_requester.requester_type_id IS 'The type from the requester_type table';


--
-- Name: sample_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE sample_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.sample_seq OWNER TO clinlims;

--
-- Name: sample_source; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sample_source (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(50),
    active boolean,
    display_order integer
);


ALTER TABLE clinlims.sample_source OWNER TO clinlims;

--
-- Name: sample_source_id_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE sample_source_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.sample_source_id_seq OWNER TO clinlims;

--
-- Name: sample_source_id_seq; Type: SEQUENCE OWNED BY; Schema: clinlims; Owner: clinlims
--

ALTER SEQUENCE sample_source_id_seq OWNED BY sample_source.id;


--
-- Name: sample_type_panel_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE sample_type_panel_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.sample_type_panel_seq OWNER TO clinlims;

--
-- Name: sample_type_test_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE sample_type_test_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.sample_type_test_seq OWNER TO clinlims;

--
-- Name: source_of_sample; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE source_of_sample (
    id numeric(10,0) NOT NULL,
    description character varying(40),
    domain character varying(1),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.source_of_sample OWNER TO clinlims;

--
-- Name: COLUMN source_of_sample.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN source_of_sample.id IS 'A unique auto generated integer number assigned by the database.';


--
-- Name: COLUMN source_of_sample.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN source_of_sample.description IS 'Description such as left ear, right hand, kitchen sink.';


--
-- Name: COLUMN source_of_sample.domain; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN source_of_sample.domain IS 'Type of sample this can be applied to: Environ, Animal, Clinical';


--
-- Name: type_of_sample; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE type_of_sample (
    id numeric(10,0) NOT NULL,
    description character varying(40) NOT NULL,
    domain character varying(1),
    lastupdated timestamp(6) without time zone,
    local_abbrev character varying(40),
    display_key character varying(60),
    is_active boolean DEFAULT true,
    sort_order numeric DEFAULT 2147483647,
    uuid character varying(40)
);


ALTER TABLE clinlims.type_of_sample OWNER TO clinlims;

--
-- Name: COLUMN type_of_sample.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN type_of_sample.id IS 'A unique auto generated integer number assigned by the database';


--
-- Name: COLUMN type_of_sample.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN type_of_sample.description IS 'Description such as water, tissue, sludge, etc.';


--
-- Name: COLUMN type_of_sample.domain; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN type_of_sample.domain IS 'Type of sample this can be applied to : Environ, Animal, Clinical';


--
-- Name: COLUMN type_of_sample.display_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN type_of_sample.display_key IS 'Resource file lookup key for localization of displaying the name';


--
-- Name: sampletracking; Type: VIEW; Schema: clinlims; Owner: clinlims
--

CREATE VIEW sampletracking AS
    SELECT organizationinfo.accnum, patientinfo.patientid, organizationinfo.cliref, patientinfo.patientlastname, patientinfo.patientfirstname, patientinfo.dateofbirth, organizationinfo.orglocalabbrev AS org_local_abbrev, organizationinfo.orgname, organizationinfo.recddate, typeinfo.tosid, typeinfo.tosdesc, sourceinfo.sosid, sourceinfo.sosdesc, organizationinfo.colldate, sampleinfo.si AS sori FROM (SELECT s.accession_number AS accnum, p.last_name AS patientlastname, p.first_name AS patientfirstname, pt.external_id AS patientid, pt.birth_date AS dateofbirth FROM (((sample s LEFT JOIN sample_human samphum ON ((s.id = samphum.samp_id))) LEFT JOIN patient pt ON ((samphum.patient_id = pt.id))) LEFT JOIN person p ON ((pt.person_id = p.id)))) patientinfo, (SELECT s.accession_number AS accnum, sos.id AS sosid, sos.description AS sosdesc FROM ((sample s LEFT JOIN sample_item sampitem ON ((s.id = sampitem.samp_id))) LEFT JOIN source_of_sample sos ON ((sampitem.source_id = sos.id)))) sourceinfo, (SELECT s.accession_number AS accnum, tos.id AS tosid, tos.description AS tosdesc FROM ((sample s LEFT JOIN sample_item sampitem ON ((s.id = sampitem.samp_id))) LEFT JOIN type_of_sample tos ON ((sampitem.typeosamp_id = tos.id)))) typeinfo, (SELECT s.accession_number AS accnum, org.local_abbrev AS orglocalabbrev, org.name AS orgname, s.received_date AS recddate, s.collection_date AS colldate, s.client_reference AS cliref FROM ((sample s LEFT JOIN sample_organization samporg ON ((s.id = samporg.samp_id))) LEFT JOIN organization org ON ((samporg.org_id = org.id)))) organizationinfo, (SELECT s.accession_number AS accnum, s.spec_or_isolate AS si FROM sample s) sampleinfo WHERE (((((typeinfo.accnum)::text = (organizationinfo.accnum)::text) AND ((sourceinfo.accnum)::text = (organizationinfo.accnum)::text)) AND ((patientinfo.accnum)::text = (organizationinfo.accnum)::text)) AND ((sampleinfo.accnum)::text = (organizationinfo.accnum)::text)) ORDER BY organizationinfo.orglocalabbrev, organizationinfo.recddate, organizationinfo.colldate, typeinfo.tosdesc, sourceinfo.sosdesc;


ALTER TABLE clinlims.sampletracking OWNER TO clinlims;

--
-- Name: sampletype_panel; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sampletype_panel (
    id numeric(10,0) NOT NULL,
    sample_type_id numeric(10,0) NOT NULL,
    panel_id numeric(10,0) NOT NULL
);


ALTER TABLE clinlims.sampletype_panel OWNER TO clinlims;

--
-- Name: sampletype_test; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sampletype_test (
    id numeric(10,0) NOT NULL,
    sample_type_id numeric(10,0) NOT NULL,
    test_id numeric(10,0) NOT NULL,
    is_panel boolean DEFAULT false
);


ALTER TABLE clinlims.sampletype_test OWNER TO clinlims;

--
-- Name: scriptlet; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE scriptlet (
    id numeric(10,0) NOT NULL,
    name character varying(40),
    code_type character varying(1),
    code_source character varying(4000),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.scriptlet OWNER TO clinlims;

--
-- Name: COLUMN scriptlet.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN scriptlet.name IS 'Script name';


--
-- Name: COLUMN scriptlet.code_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN scriptlet.code_type IS 'Flag indicating type of script code : Java, Basic, PLSQL';


--
-- Name: COLUMN scriptlet.lastupdated; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN scriptlet.lastupdated IS 'Body of Source Code';


--
-- Name: scriptlet_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE scriptlet_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.scriptlet_seq OWNER TO clinlims;

--
-- Name: sequence; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE sequence (
    seq_name character varying(30),
    seq_count numeric
);


ALTER TABLE clinlims.sequence OWNER TO clinlims;

--
-- Name: site_information; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE site_information (
    id integer NOT NULL,
    name character varying(32) NOT NULL,
    lastupdated timestamp with time zone,
    description character varying(120),
    value character varying(200),
    encrypted boolean DEFAULT false,
    domain_id numeric(10,0),
    value_type character varying(10) DEFAULT 'text'::character varying NOT NULL,
    instruction_key character varying(40),
    "group" numeric DEFAULT (0)::numeric,
    schedule_id numeric(10,0),
    tag character varying(20),
    dictionary_category_id numeric(10,0)
);


ALTER TABLE clinlims.site_information OWNER TO clinlims;

--
-- Name: TABLE site_information; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE site_information IS 'Information about a specific installation at a site, seperate from an implimentation';


--
-- Name: COLUMN site_information.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN site_information.name IS 'Name by which this information will be found';


--
-- Name: COLUMN site_information.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN site_information.description IS 'Clarification of the name';


--
-- Name: COLUMN site_information.value; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN site_information.value IS 'Value for the named information';


--
-- Name: COLUMN site_information.encrypted; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN site_information.encrypted IS 'Is the value an encrypted value.  Used for passwords';


--
-- Name: COLUMN site_information.value_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN site_information.value_type IS 'The type of value which can be specified for the value. Currently either ''boolean'',''text'' or ''dictionary''';


--
-- Name: COLUMN site_information.instruction_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN site_information.instruction_key IS 'The key in Message_Resource which give the user the text for the meaning and consequences of the information';


--
-- Name: COLUMN site_information."group"; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN site_information."group" IS 'If items should be grouped together when displaying they should have the same group number';


--
-- Name: COLUMN site_information.schedule_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN site_information.schedule_id IS 'quartz_cron_scheduler id if the item is associated with a scheduler ';


--
-- Name: COLUMN site_information.tag; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN site_information.tag IS 'A tag to help determine how the information should be used';


--
-- Name: COLUMN site_information.dictionary_category_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN site_information.dictionary_category_id IS 'Value of the dictionary category if the type of record is dictionary';


--
-- Name: site_information_domain; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE site_information_domain (
    id numeric(10,0) NOT NULL,
    name character varying(20) NOT NULL,
    description character varying(120)
);


ALTER TABLE clinlims.site_information_domain OWNER TO clinlims;

--
-- Name: TABLE site_information_domain; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE site_information_domain IS 'Marks the domains to which site information belongs.  Intended use is administration pages';


--
-- Name: site_information_domain_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE site_information_domain_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.site_information_domain_seq OWNER TO clinlims;

--
-- Name: site_information_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE site_information_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.site_information_seq OWNER TO clinlims;

--
-- Name: source_of_sample_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE source_of_sample_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.source_of_sample_seq OWNER TO clinlims;

--
-- Name: state_code; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE state_code (
    id numeric(10,0) NOT NULL,
    code character varying(240),
    description character varying(240),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.state_code OWNER TO clinlims;

--
-- Name: COLUMN state_code.code; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN state_code.code IS 'State abbreviation';


--
-- Name: COLUMN state_code.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN state_code.description IS 'State Name';


--
-- Name: state_code_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE state_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.state_code_seq OWNER TO clinlims;

--
-- Name: status_of_sample; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE status_of_sample (
    id numeric(10,0) NOT NULL,
    description character varying(240),
    code numeric(3,0) NOT NULL,
    status_type character varying(10) NOT NULL,
    lastupdated timestamp(6) without time zone,
    name character varying(30),
    display_key character varying(60),
    is_active character varying(1) DEFAULT 'Y'::character varying
);


ALTER TABLE clinlims.status_of_sample OWNER TO clinlims;

--
-- Name: COLUMN status_of_sample.is_active; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN status_of_sample.is_active IS 'Either Y or N';


--
-- Name: status_of_sample_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE status_of_sample_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.status_of_sample_seq OWNER TO clinlims;

--
-- Name: storage_location; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE storage_location (
    id numeric(10,0) NOT NULL,
    sort_order numeric,
    name character varying(20),
    location character varying(80),
    is_available character varying(1),
    parent_storageloc_id numeric(10,0),
    storage_unit_id numeric(10,0)
);


ALTER TABLE clinlims.storage_location OWNER TO clinlims;

--
-- Name: COLUMN storage_location.sort_order; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN storage_location.sort_order IS 'The sequence order of this item; sort order used for display';


--
-- Name: COLUMN storage_location.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN storage_location.name IS 'Name of unit: Virology Fridge #1';


--
-- Name: COLUMN storage_location.location; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN storage_location.location IS 'Location of storage';


--
-- Name: COLUMN storage_location.is_available; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN storage_location.is_available IS 'Indicates if storage is available for use.';


--
-- Name: storage_unit; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE storage_unit (
    id numeric(10,0) NOT NULL,
    category character varying(15),
    description character varying(60),
    is_singular character varying(1)
);


ALTER TABLE clinlims.storage_unit OWNER TO clinlims;

--
-- Name: COLUMN storage_unit.category; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN storage_unit.category IS 'type of storage unit: box, fridge, shelf, tube';


--
-- Name: COLUMN storage_unit.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN storage_unit.description IS 'Description of unit: 10 mL tube, 5 shelf fridge.';


--
-- Name: COLUMN storage_unit.is_singular; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN storage_unit.is_singular IS 'Y, N flag indicating if this unit can contain more than one item.';


--
-- Name: system_module; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE system_module (
    id numeric(10,0) NOT NULL,
    name character varying(40),
    description character varying(80),
    has_select_flag character varying(1),
    has_add_flag character varying(1),
    has_update_flag character varying(1),
    has_delete_flag character varying(1)
);


ALTER TABLE clinlims.system_module OWNER TO clinlims;

--
-- Name: COLUMN system_module.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_module.name IS 'Name of security module';


--
-- Name: COLUMN system_module.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_module.description IS 'Description for this security module';


--
-- Name: COLUMN system_module.has_select_flag; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_module.has_select_flag IS 'Flag indicating if this module can be assigned to a user';


--
-- Name: COLUMN system_module.has_add_flag; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_module.has_add_flag IS 'Flag indicating if this module has add capability';


--
-- Name: COLUMN system_module.has_update_flag; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_module.has_update_flag IS 'Flag indicating if this module has update capability';


--
-- Name: COLUMN system_module.has_delete_flag; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_module.has_delete_flag IS 'Flag indicating if this module has delete capability';


--
-- Name: system_module_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE system_module_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.system_module_seq OWNER TO clinlims;

--
-- Name: system_role; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE system_role (
    id numeric(10,0) NOT NULL,
    name character(20) NOT NULL,
    description character varying(80),
    is_grouping_role boolean DEFAULT false,
    grouping_parent numeric(10,0),
    display_key character varying(60),
    active boolean DEFAULT true,
    editable boolean DEFAULT false
);


ALTER TABLE clinlims.system_role OWNER TO clinlims;

--
-- Name: TABLE system_role; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE system_role IS 'Describes the roles a user may have.  ';


--
-- Name: COLUMN system_role.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_role.name IS 'The name of the role, this is how it will appear to the user';


--
-- Name: COLUMN system_role.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_role.description IS 'Notes about the role';


--
-- Name: COLUMN system_role.is_grouping_role; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_role.is_grouping_role IS 'Indicates that this role is only for grouping other roles.  It should not have modules assigned to it';


--
-- Name: COLUMN system_role.grouping_parent; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_role.grouping_parent IS 'Should only refer to a grouping role';


--
-- Name: COLUMN system_role.display_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_role.display_key IS 'key for localizing dropdown lists';


--
-- Name: COLUMN system_role.active; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_role.active IS 'Is this role active for this installation';


--
-- Name: COLUMN system_role.editable; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_role.editable IS 'Is this a role that can be de/activated by the user';


--
-- Name: system_role_module; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE system_role_module (
    id numeric(10,0) NOT NULL,
    has_select character varying(1),
    has_add character varying(1),
    has_update character varying(1),
    has_delete character varying(1),
    system_role_id numeric(10,0) NOT NULL,
    system_module_id numeric(10,0) NOT NULL
);


ALTER TABLE clinlims.system_role_module OWNER TO clinlims;

--
-- Name: system_role_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE system_role_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.system_role_seq OWNER TO clinlims;

--
-- Name: system_user; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE system_user (
    id numeric(10,0) NOT NULL,
    external_id character varying(80),
    login_name character varying(20) NOT NULL,
    last_name character varying(30) NOT NULL,
    first_name character varying(20) NOT NULL,
    initials character varying(3),
    is_active character varying(1) NOT NULL,
    is_employee character varying(1) NOT NULL,
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.system_user OWNER TO clinlims;

--
-- Name: COLUMN system_user.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user.id IS 'Sequential Identifier';


--
-- Name: COLUMN system_user.external_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user.external_id IS 'External ID such as employee number or external system ID.';


--
-- Name: COLUMN system_user.login_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user.login_name IS 'User''s system log in name.';


--
-- Name: COLUMN system_user.last_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user.last_name IS 'Last name of person';


--
-- Name: COLUMN system_user.first_name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user.first_name IS 'Person Name';


--
-- Name: COLUMN system_user.initials; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user.initials IS 'Middle Initial';


--
-- Name: COLUMN system_user.is_active; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user.is_active IS 'Indicates the status of active or inactive for user';


--
-- Name: COLUMN system_user.is_employee; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user.is_employee IS 'Indicates if user is an MDH employee';


--
-- Name: system_user_module; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE system_user_module (
    id numeric(10,0) NOT NULL,
    has_select character varying(1),
    has_add character varying(1),
    has_update character varying(1),
    has_delete character varying(1),
    system_user_id numeric(10,0),
    system_module_id numeric(10,0)
);


ALTER TABLE clinlims.system_user_module OWNER TO clinlims;

--
-- Name: COLUMN system_user_module.has_select; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user_module.has_select IS 'Flag indicating if this user has permission to enter this module';


--
-- Name: COLUMN system_user_module.has_add; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user_module.has_add IS 'Flag indicating if this user has permission to add a record';


--
-- Name: COLUMN system_user_module.has_update; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user_module.has_update IS 'Flag indicating if this person has permission to update a record';


--
-- Name: COLUMN system_user_module.has_delete; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user_module.has_delete IS 'Flag indicating if this person has permission to remove a record';


--
-- Name: system_user_module_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE system_user_module_seq
    START WITH 0
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.system_user_module_seq OWNER TO clinlims;

--
-- Name: system_user_role; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE system_user_role (
    system_user_id numeric(10,0) NOT NULL,
    role_id numeric(10,0) NOT NULL
);


ALTER TABLE clinlims.system_user_role OWNER TO clinlims;

--
-- Name: system_user_section; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE system_user_section (
    id numeric NOT NULL,
    has_view character varying(1),
    has_assign character varying(1),
    has_complete character varying(1),
    has_release character varying(1),
    has_cancel character varying(1),
    system_user_id numeric(10,0),
    test_section_id numeric(10,0)
);


ALTER TABLE clinlims.system_user_section OWNER TO clinlims;

--
-- Name: COLUMN system_user_section.has_view; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user_section.has_view IS 'Flag indicating if user has permission to iew this sections''s records';


--
-- Name: COLUMN system_user_section.has_assign; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user_section.has_assign IS 'Flag indicating if user has permission to assign this section''s tests';


--
-- Name: COLUMN system_user_section.has_complete; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user_section.has_complete IS 'Flag indicating if user has permission to complete this section''s tests';


--
-- Name: COLUMN system_user_section.has_release; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user_section.has_release IS 'Flag indicating if user has permission to release this section''s tests';


--
-- Name: COLUMN system_user_section.has_cancel; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN system_user_section.has_cancel IS 'Flag indicating if user has permission to cancel this section''s tests';


--
-- Name: system_user_section_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE system_user_section_seq
    START WITH 1
    INCREMENT BY 1
    MINVALUE 0
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.system_user_section_seq OWNER TO clinlims;

--
-- Name: system_user_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE system_user_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.system_user_seq OWNER TO clinlims;

--
-- Name: test; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE test (
    id numeric(10,0) NOT NULL,
    method_id numeric(10,0),
    uom_id numeric(10,0),
    description character varying(120) NOT NULL,
    loinc character varying(240),
    reporting_description character varying(60),
    sticker_req_flag character varying(1),
    is_active character varying(1),
    active_begin timestamp without time zone,
    active_end timestamp without time zone,
    is_reportable character varying(1),
    time_holding numeric,
    time_wait numeric,
    time_ta_average numeric,
    time_ta_warning numeric,
    time_ta_max numeric,
    label_qty numeric,
    lastupdated timestamp(6) without time zone,
    label_id numeric(10,0),
    test_trailer_id numeric(10,0),
    test_section_id numeric(10,0),
    scriptlet_id numeric(10,0),
    test_format_id numeric(10,0),
    local_abbrev character varying(50),
    sort_order numeric DEFAULT 2147483647,
    name character varying(60) NOT NULL,
    display_key character varying(60),
    orderable boolean DEFAULT true,
    is_referred_out boolean DEFAULT false
);


ALTER TABLE clinlims.test OWNER TO clinlims;

--
-- Name: COLUMN test.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.id IS 'Sequential value assigned on insert';


--
-- Name: COLUMN test.method_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.method_id IS 'Sequential number';


--
-- Name: COLUMN test.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.description IS 'Description for test';


--
-- Name: COLUMN test.reporting_description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.reporting_description IS 'Description for test that appears on reports';


--
-- Name: COLUMN test.is_active; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.is_active IS 'Active status flag';


--
-- Name: COLUMN test.active_begin; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.active_begin IS 'Active end date';


--
-- Name: COLUMN test.active_end; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.active_end IS 'Active begin date';


--
-- Name: COLUMN test.is_reportable; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.is_reportable IS 'The default flag indicating if ths test is reportable';


--
-- Name: COLUMN test.time_holding; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.time_holding IS 'Max hours between collection and received time';


--
-- Name: COLUMN test.time_wait; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.time_wait IS 'Hours to wait before analysis can begin';


--
-- Name: COLUMN test.time_ta_average; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.time_ta_average IS 'Average hours for test to be reported';


--
-- Name: COLUMN test.time_ta_warning; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.time_ta_warning IS 'Hours before issuing touraround warning for test not reported';


--
-- Name: COLUMN test.time_ta_max; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.time_ta_max IS 'Max hours test should be in laboratory';


--
-- Name: COLUMN test.label_qty; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.label_qty IS 'Number of labels to print';


--
-- Name: COLUMN test.display_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.display_key IS 'Resource file lookup key for localization of displaying the name';


--
-- Name: COLUMN test.orderable; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test.orderable IS 'Should this test show in list of tests which can be ordered.  If not it is a reflex only test';


--
-- Name: test_analyte; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE test_analyte (
    id numeric(10,0) NOT NULL,
    test_id numeric(10,0),
    analyte_id numeric(10,0),
    result_group numeric,
    sort_order numeric,
    testalyt_type character varying(1),
    lastupdated timestamp(6) without time zone,
    is_reportable character varying(1)
);


ALTER TABLE clinlims.test_analyte OWNER TO clinlims;

--
-- Name: COLUMN test_analyte.test_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_analyte.test_id IS 'Sequential value assigned on insert';


--
-- Name: COLUMN test_analyte.result_group; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_analyte.result_group IS 'A program generated group number';


--
-- Name: COLUMN test_analyte.sort_order; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_analyte.sort_order IS 'The order in which the analytes are displayed (sort order)';


--
-- Name: COLUMN test_analyte.testalyt_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_analyte.testalyt_type IS 'Type of analyte: required...';


--
-- Name: test_analyte_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE test_analyte_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.test_analyte_seq OWNER TO clinlims;

--
-- Name: test_code; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE test_code (
    test_id numeric(10,0) NOT NULL,
    code_type_id numeric(10,0) NOT NULL,
    value character varying(20) NOT NULL,
    lastupdated timestamp with time zone
);


ALTER TABLE clinlims.test_code OWNER TO clinlims;

--
-- Name: TABLE test_code; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE test_code IS 'For a given test and schema it gives the encoding';


--
-- Name: COLUMN test_code.test_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_code.test_id IS 'The test for which the coding supports. FK to test table.';


--
-- Name: COLUMN test_code.code_type_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_code.code_type_id IS 'The coding type id of the code';


--
-- Name: COLUMN test_code.value; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_code.value IS 'The actual code';


--
-- Name: test_code_type; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE test_code_type (
    id numeric(10,0) NOT NULL,
    schema_name character varying(32) NOT NULL,
    lastupdated timestamp with time zone
);


ALTER TABLE clinlims.test_code_type OWNER TO clinlims;

--
-- Name: TABLE test_code_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON TABLE test_code_type IS 'The names of the encoding schems supported (SNOMWD, LOINC etc)';


--
-- Name: test_formats; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE test_formats (
    id numeric(10,0) NOT NULL,
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.test_formats OWNER TO clinlims;

--
-- Name: test_reflex; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE test_reflex (
    id numeric(10,0) NOT NULL,
    tst_rslt_id numeric,
    flags character varying(10),
    lastupdated timestamp(6) without time zone,
    test_analyte_id numeric(10,0),
    test_id numeric(10,0),
    add_test_id numeric(10,0),
    sibling_reflex numeric(10,0),
    scriptlet_id numeric(10,0)
);


ALTER TABLE clinlims.test_reflex OWNER TO clinlims;

--
-- Name: COLUMN test_reflex.flags; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_reflex.flags IS 'A string of 1 character codes: duplicate, auto-add';


--
-- Name: COLUMN test_reflex.sibling_reflex; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_reflex.sibling_reflex IS 'Reference to tests and results for reflexes with more than one condition.  All add_test_ids should be the same';


--
-- Name: COLUMN test_reflex.scriptlet_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_reflex.scriptlet_id IS 'If a non-test action should be taken then reference the scriptlet which says what to do';


--
-- Name: test_reflex_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE test_reflex_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.test_reflex_seq OWNER TO clinlims;

--
-- Name: test_result; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE test_result (
    id numeric NOT NULL,
    test_id numeric(10,0) NOT NULL,
    result_group numeric,
    flags character varying(10),
    tst_rslt_type character varying(1),
    value character varying(80),
    significant_digits numeric DEFAULT 0,
    quant_limit character varying(30),
    cont_level character varying(30),
    lastupdated timestamp(6) without time zone,
    scriptlet_id numeric(10,0),
    sort_order numeric(22,0),
    abnormal boolean DEFAULT false,
    is_active boolean DEFAULT true
);


ALTER TABLE clinlims.test_result OWNER TO clinlims;

--
-- Name: COLUMN test_result.test_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_result.test_id IS 'Sequential value assigned on insert';


--
-- Name: COLUMN test_result.result_group; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_result.result_group IS 'the test_analyte result_group number';


--
-- Name: COLUMN test_result.flags; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_result.flags IS 'a string of 1 character codes: Positive, Reportable...';


--
-- Name: COLUMN test_result.tst_rslt_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_result.tst_rslt_type IS 'Type of parameter: Dictionary, Titer Range, Number Range, Date';


--
-- Name: COLUMN test_result.value; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_result.value IS 'Possible result value based on type';


--
-- Name: COLUMN test_result.significant_digits; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_result.significant_digits IS 'Number of decimal digits';


--
-- Name: COLUMN test_result.quant_limit; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_result.quant_limit IS 'Quantitation Limit (if any)';


--
-- Name: COLUMN test_result.cont_level; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_result.cont_level IS 'Contamination Level (if any)';


--
-- Name: test_result_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE test_result_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.test_result_seq OWNER TO clinlims;

--
-- Name: test_section; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE test_section (
    id numeric(10,0) NOT NULL,
    name character varying(40),
    description character varying(60) NOT NULL,
    org_id numeric(10,0),
    is_external character varying(1),
    lastupdated timestamp(6) without time zone,
    parent_test_section numeric(10,0),
    display_key character varying(60),
    sort_order numeric DEFAULT 2147483647,
    is_active character varying(1) DEFAULT 'Y'::character varying,
    uuid character varying(40)
);


ALTER TABLE clinlims.test_section OWNER TO clinlims;

--
-- Name: COLUMN test_section.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_section.name IS 'Short section name';


--
-- Name: COLUMN test_section.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_section.description IS 'MDH Locations including various labs';


--
-- Name: COLUMN test_section.org_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_section.org_id IS 'Sequential Numbering Field';


--
-- Name: COLUMN test_section.is_external; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_section.is_external IS 'Flag indicating if section is external to organization (Y/N)';


--
-- Name: COLUMN test_section.display_key; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_section.display_key IS 'Resource file lookup key for localization of displaying the name';


--
-- Name: test_section_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE test_section_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 20;


ALTER TABLE clinlims.test_section_seq OWNER TO clinlims;

--
-- Name: test_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE test_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.test_seq OWNER TO clinlims;

--
-- Name: test_trailer; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE test_trailer (
    id numeric(10,0) NOT NULL,
    name character varying(20),
    description character varying(60),
    text character varying(4000),
    lastupdated timestamp(6) without time zone
);


ALTER TABLE clinlims.test_trailer OWNER TO clinlims;

--
-- Name: test_trailer_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE test_trailer_seq
    START WITH 2
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.test_trailer_seq OWNER TO clinlims;

--
-- Name: test_worksheet_item; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE test_worksheet_item (
    id numeric(10,0) NOT NULL,
    tw_id numeric(10,0) NOT NULL,
    qc_id numeric,
    "position" numeric,
    cell_type character varying(2)
);


ALTER TABLE clinlims.test_worksheet_item OWNER TO clinlims;

--
-- Name: COLUMN test_worksheet_item."position"; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_worksheet_item."position" IS 'Well location or position within the batch';


--
-- Name: COLUMN test_worksheet_item.cell_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_worksheet_item.cell_type IS 'Cell/position type: First, random, duplicate last, last run';


--
-- Name: test_worksheets; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE test_worksheets (
    id numeric(10,0) NOT NULL,
    test_id numeric(10,0),
    batch_capacity numeric,
    total_capacity numeric,
    number_format character varying(1)
);


ALTER TABLE clinlims.test_worksheets OWNER TO clinlims;

--
-- Name: COLUMN test_worksheets.test_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_worksheets.test_id IS 'Sequential value assigned on insert';


--
-- Name: COLUMN test_worksheets.batch_capacity; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_worksheets.batch_capacity IS 'number of samples (including QC) per batch/plate';


--
-- Name: COLUMN test_worksheets.total_capacity; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_worksheets.total_capacity IS 'Number of samples (including QC) per worksheet';


--
-- Name: COLUMN test_worksheets.number_format; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN test_worksheets.number_format IS 'Specifies the numbering scheme for worksheet cell';


--
-- Name: tobereomved_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE tobereomved_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.tobereomved_seq OWNER TO clinlims;

--
-- Name: type_of_provider; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE type_of_provider (
    id numeric(10,0) NOT NULL,
    description character varying(240),
    tp_code character varying(1)
);


ALTER TABLE clinlims.type_of_provider OWNER TO clinlims;

--
-- Name: COLUMN type_of_provider.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN type_of_provider.id IS 'A unique auto generated integer number assigned by the database.';


--
-- Name: COLUMN type_of_provider.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN type_of_provider.description IS 'Description such as doctor, nurse, clinician, veteranarian.';


--
-- Name: type_of_sample_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE type_of_sample_seq
    START WITH 80
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.type_of_sample_seq OWNER TO clinlims;

--
-- Name: type_of_test_result; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE type_of_test_result (
    id numeric(10,0) NOT NULL,
    test_result_type character varying(1),
    description character varying(20),
    lastupdated timestamp(6) without time zone,
    hl7_value character varying(20)
);


ALTER TABLE clinlims.type_of_test_result OWNER TO clinlims;

--
-- Name: COLUMN type_of_test_result.id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN type_of_test_result.id IS 'A unique auto generated integer number assigned by database';


--
-- Name: COLUMN type_of_test_result.test_result_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN type_of_test_result.test_result_type IS 'Test Result Type (T, N, D)';


--
-- Name: COLUMN type_of_test_result.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN type_of_test_result.description IS 'Human readable description';


--
-- Name: type_of_test_result_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE type_of_test_result_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.type_of_test_result_seq OWNER TO clinlims;

--
-- Name: unit_of_measure; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE unit_of_measure (
    id numeric(10,0) NOT NULL,
    name character varying(20),
    description character varying(60),
    lastupdated timestamp(6) without time zone,
    uuid character varying(40)
);


ALTER TABLE clinlims.unit_of_measure OWNER TO clinlims;

--
-- Name: COLUMN unit_of_measure.name; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN unit_of_measure.name IS 'Name of Unit';


--
-- Name: COLUMN unit_of_measure.description; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN unit_of_measure.description IS 'Description of Unit';


--
-- Name: unit_of_measure_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE unit_of_measure_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.unit_of_measure_seq OWNER TO clinlims;

--
-- Name: user_alert_map; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE user_alert_map (
    user_id integer NOT NULL,
    alert_id integer,
    report_id integer,
    alert_limit integer,
    alert_operator character varying(255),
    map_id integer NOT NULL
);


ALTER TABLE clinlims.user_alert_map OWNER TO clinlims;

--
-- Name: user_group_map; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE user_group_map (
    user_id integer NOT NULL,
    group_id integer NOT NULL,
    map_id integer NOT NULL
);


ALTER TABLE clinlims.user_group_map OWNER TO clinlims;

--
-- Name: user_security; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE user_security (
    user_id integer NOT NULL,
    role_name character varying(255)
);


ALTER TABLE clinlims.user_security OWNER TO clinlims;

--
-- Name: worksheet_analysis; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE worksheet_analysis (
    id numeric(10,0) NOT NULL,
    reference_type character(1),
    reference_id numeric,
    worksheet_item_id numeric(10,0)
);


ALTER TABLE clinlims.worksheet_analysis OWNER TO clinlims;

--
-- Name: COLUMN worksheet_analysis.reference_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN worksheet_analysis.reference_type IS 'Flag indicating if reference points to analysis or QC';


--
-- Name: COLUMN worksheet_analysis.reference_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN worksheet_analysis.reference_id IS 'ID of analysis or QC';


--
-- Name: worksheet_analyte; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE worksheet_analyte (
    id numeric NOT NULL,
    wrkst_anls_id numeric(10,0),
    sort_order numeric,
    result_id numeric(10,0)
);


ALTER TABLE clinlims.worksheet_analyte OWNER TO clinlims;

--
-- Name: COLUMN worksheet_analyte.sort_order; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN worksheet_analyte.sort_order IS 'The order worksheet analytes are displayed (sort order)';


--
-- Name: worksheet_heading; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE worksheet_heading (
    id numeric(10,0),
    worksheet_name character varying(20),
    rownumber numeric(10,0),
    column1 character varying(50),
    column2 character varying(50),
    column3 character varying(50),
    column4 character varying(50),
    column5 character varying(50),
    column6 character varying(50),
    column7 character varying(50),
    column8 character varying(50),
    column9 character varying(50),
    column10 character varying(50),
    type character varying(20)
);


ALTER TABLE clinlims.worksheet_heading OWNER TO clinlims;

--
-- Name: worksheet_item; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE worksheet_item (
    id numeric(10,0) NOT NULL,
    "position" numeric,
    worksheet_id numeric(10,0)
);


ALTER TABLE clinlims.worksheet_item OWNER TO clinlims;

--
-- Name: worksheet_qc; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE worksheet_qc (
    id numeric NOT NULL,
    sort_order numeric,
    wq_type character varying(1),
    value character varying(80),
    worksheet_analysis_id numeric(10,0),
    qc_analyte_id numeric(10,0)
);


ALTER TABLE clinlims.worksheet_qc OWNER TO clinlims;

--
-- Name: COLUMN worksheet_qc.sort_order; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN worksheet_qc.sort_order IS 'The order worksheet analystes are displayed (sort order)';


--
-- Name: COLUMN worksheet_qc.wq_type; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN worksheet_qc.wq_type IS 'Type of result: dictionary, titer, number...';


--
-- Name: COLUMN worksheet_qc.value; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN worksheet_qc.value IS 'Result value';


--
-- Name: worksheets; Type: TABLE; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE TABLE worksheets (
    id numeric(10,0) NOT NULL,
    sys_user_id numeric(10,0) NOT NULL,
    test_id numeric(10,0),
    created timestamp without time zone,
    status character varying(1),
    number_format character varying(1)
);


ALTER TABLE clinlims.worksheets OWNER TO clinlims;

--
-- Name: COLUMN worksheets.sys_user_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN worksheets.sys_user_id IS 'Sequential Identifier';


--
-- Name: COLUMN worksheets.test_id; Type: COMMENT; Schema: clinlims; Owner: clinlims
--

COMMENT ON COLUMN worksheets.test_id IS 'Sequential value assigned on insert';


--
-- Name: zip_code_seq; Type: SEQUENCE; Schema: clinlims; Owner: clinlims
--

CREATE SEQUENCE zip_code_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE clinlims.zip_code_seq OWNER TO clinlims;

--
-- Name: id; Type: DEFAULT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY chunking_history ALTER COLUMN id SET DEFAULT nextval('chunking_history_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY event_records ALTER COLUMN id SET DEFAULT nextval('event_records_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY event_records_offset_marker ALTER COLUMN id SET DEFAULT nextval('event_records_offset_marker_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY event_records_queue ALTER COLUMN id SET DEFAULT nextval('event_records_queue_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY external_reference ALTER COLUMN id SET DEFAULT nextval('external_reference_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY failed_event_retry_log ALTER COLUMN id SET DEFAULT nextval('failed_event_retry_log_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY failed_events ALTER COLUMN id SET DEFAULT nextval('failed_events_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY import_status ALTER COLUMN id SET DEFAULT nextval('import_status_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY markers ALTER COLUMN id SET DEFAULT nextval('markers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_source ALTER COLUMN id SET DEFAULT nextval('sample_source_id_seq'::regclass);


--
-- Data for Name: action; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY action (id, code, description, type, lastupdated) FROM stdin;
1	FSR	Fee sticker received	resolving	2007-08-21 16:48:38.434
2	CDC	Collection date corrected	resolving	2007-08-21 15:58:29.117
3	RQSOC	Request source corrected	resolving	2007-08-21 14:11:01.737
4	SNAC	Submitter name corrected	resolving	2007-08-21 14:21:11.696
26	DLRQR	Delayed request form received	internal	2008-01-11 04:17:09.054
25	CMRE	Communication reviewed	internal	2008-05-01 21:38:41.775
27	DURPS	Duplicate report to submitter	message	2008-01-11 04:22:59.507
28	SPDC	Specimen discarded	internal	2008-01-11 04:20:13.235
29	SCL	Submitter was called	message	2008-01-11 04:22:33.637
30	SPSOC	Specimen source corrected	internal	2008-01-11 04:24:33.863
31	DLRQRQ	Delayed request form requested	message	2008-01-11 04:46:58.057
32	RPDF	Report placed in dead file	internal	2008-01-11 04:47:25.498
33	RQIDC	Request form ID corrected	internal	2008-01-11 04:47:57.136
34	SPCA	Specimen canceled	internal	2008-01-11 04:48:25.614
35	SPIDC	Specimen ID corrected	internal	2008-01-11 04:48:47.451
36	SPUNS	Specimen declared unsatisfactory	internal	2008-01-11 04:49:13.262
\.


--
-- Name: action_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('action_seq', 45, false);


--
-- Data for Name: address_part; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY address_part (id, part_name, display_order, display_key, type) FROM stdin;
7	level1	1	address.level1	T
8	level2	2	address.level2	T
9	level3	3	address.level3	T
10	level4	4	address.level4	T
11	level5	5	address.level5	T
12	level6	6	address.level6	T
\.


--
-- Name: address_part_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('address_part_seq', 12, true);


--
-- Data for Name: analysis; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY analysis (id, sampitem_id, test_sect_id, test_id, revision, status, started_date, completed_date, released_date, printed_date, is_reportable, so_send_ready_date, so_client_reference, so_notify_received_date, so_notify_send_date, so_send_date, so_send_entry_by, so_send_entry_date, analysis_type, lastupdated, parent_analysis_id, parent_result_id, reflex_trigger, status_id, entry_date, panel_id, comment) FROM stdin;
\.


--
-- Data for Name: analysis_qaevent; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY analysis_qaevent (id, qa_event_id, analysis_id, lastupdated, completed_date) FROM stdin;
\.


--
-- Data for Name: analysis_qaevent_action; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY analysis_qaevent_action (id, analysis_qaevent_id, action_id, created_date, lastupdated, sys_user_id) FROM stdin;
\.


--
-- Name: analysis_qaevent_action_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('analysis_qaevent_action_seq', 221, false);


--
-- Name: analysis_qaevent_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('analysis_qaevent_seq', 326, false);


--
-- Name: analysis_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('analysis_seq', 514, true);


--
-- Data for Name: analysis_storages; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY analysis_storages (id, storage_id, checkin, checkout, analysis_id) FROM stdin;
\.


--
-- Data for Name: analysis_users; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY analysis_users (id, action, analysis_id, system_user_id) FROM stdin;
\.


--
-- Data for Name: analyte; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY analyte (id, analyte_id, name, is_active, external_id, lastupdated, local_abbrev) FROM stdin;
44	\N	HIV-2 Result	Y	\N	2007-05-15 13:29:44.989	\N
62	\N	MEP Agar	Y	\N	2007-10-09 08:38:25.01	\N
63	\N	MYP Agar	Y	\N	2007-10-09 08:38:31.459	\N
64	\N	PLET Agar	Y	\N	2007-10-09 08:38:41.299	\N
65	\N	SBA Agar	Y	\N	2007-10-09 08:38:49.58	\N
67	\N	Extraction Kit	Y	\N	2007-12-10 09:04:09.124	\N
68	\N	Amplification Kit	Y	\N	2007-12-10 09:04:16.37	\N
69	\N	Light Cycler	Y	\N	2007-12-10 09:04:24.964	\N
70	\N	ABI 7000	Y	\N	2007-12-10 09:04:36.709	\N
71	\N	i Cycler	Y	\N	2007-12-10 09:04:56.821	\N
72	\N	ABI 7500	Y	\N	2007-12-10 09:05:04.01	\N
73	\N	DFA Capsule Antigen Detection	Y	\N	2007-12-10 09:05:41.24	\N
74	\N	DFA Cell Wall Detection	Y	\N	2007-12-10 09:06:56.313	\N
78	\N	Dilution 1:10	N	\N	2007-12-27 03:05:58.517	\N
89	\N	TRF Spore Detection Interpretation	Y	\N	2007-12-27 05:34:16.557	\N
90	\N	TRF Cell Detection Data Value	Y	\N	2007-12-27 05:34:57.18	\N
91	\N	TRF Cell Detection Result	Y	\N	2007-12-27 05:35:11.751	\N
92	\N	TRF Cell Detection Interpretation	Y	\N	2007-12-27 05:35:25.667	\N
1	\N	Influenza Virus B RNA	Y	\N	2007-02-02 14:09:33.524	\N
45	\N	Final HIV Interpretation 	Y	\N	2007-05-15 13:30:15.23	\N
47	\N	Penicillin	Y	\N	2007-05-18 09:41:04.107	\N
48	\N	Ceftriaxone	Y	\N	2007-05-18 09:41:14.295	\N
49	\N	Ciprofloxacin 	Y	\N	2007-05-18 09:43:17.764	\N
50	\N	Spectinomycin	Y	\N	2007-05-18 09:43:30.214	\N
43	\N	HIV-1 Result	Y	\N	2007-05-15 13:29:33.206	\N
51	\N	Tetracycline	Y	\N	2007-05-18 09:43:37.86	\N
52	\N	Cefixime	Y	\N	2007-05-18 09:43:52.144	\N
53	\N	Azithromycin	Y	\N	2007-05-18 09:44:01.789	\N
15	\N	Isoniazid 0.4 mcg.ml	Y	\N	2007-02-13 14:30:20.194	\N
16	\N	Streptomycin 2.0 mcg/ml	Y	\N	2007-02-13 14:30:43.17	\N
17	\N	Ethambutol 2.5 mcg/ml	Y	\N	2007-02-13 14:30:58.832	\N
18	\N	Pyrazinamide 100 mcg/ml	Y	\N	2007-02-13 14:32:46.073	\N
19	\N	DFA Capsule Antigen Detection from Isolate	Y	\N	2007-12-11 03:56:08.454	\N
8	\N	Respiratory Syncytial Virus A RNA	Y	\N	2007-02-02 14:13:44.532	\N
9	\N	Respiratory Syncytial Virus B RNA	Y	\N	2007-02-02 14:13:56.705	\N
20	\N	DFA Cell Wall Detection from Isolate	Y	\N	2007-12-11 03:56:47.987	\N
38	\N	Comment 8	Y	\N	2007-04-02 09:05:17.216	\N
41	\N	Titer	Y	\N	2007-05-03 15:59:07.522	\N
22	\N	Preliminary Result	Y	\N	2007-03-28 14:00:45.933	\N
23	\N	Result 4	Y	\N	2007-03-28 14:00:51.064	\N
24	\N	Result 5	Y	\N	2007-03-28 14:01:00.965	\N
25	\N	Result 6	Y	\N	2007-03-28 14:01:05.352	\N
26	\N	Result 7	Y	\N	2007-03-28 14:01:16.014	\N
27	\N	Result 8	Y	\N	2007-03-28 14:01:20.594	\N
28	\N	Result 9	Y	\N	2007-03-28 14:01:31.066	\N
29	\N	Preliminary Result Modifier	Y	\N	2007-03-28 16:22:57.579	\N
30	\N	Final Result Modifier	Y	\N	2007-03-28 16:22:21.34	\N
208	\N	Influenza Virus A/H3 RNA	Y	\N	2006-09-07 08:32:05	\N
209	\N	Influenza Virus A/H5 RNA	Y	\N	2006-09-07 08:32:21	\N
210	\N	Influenza Virus A/H7 RNA	Y	\N	2006-10-13 10:34:13.207	\N
211	\N	Influenza Virus A/H9 RNA	Y	\N	2008-01-23 08:02:52.021	\N
212	\N	Final Result	Y	\N	2006-09-07 08:34:31	\N
213	\N	Presumptive Result	Y	\N	2006-09-07 08:34:40	\N
214	\N	Result 1	Y	\N	2006-11-07 08:11:16	\N
215	\N	Result 2	Y	\N	2006-10-20 13:28:24	\N
216	\N	Result 3	Y	\N	2006-10-20 13:28:30	\N
217	\N	Interpretation	Y	\N	2006-09-07 08:35:29	\N
21	\N	Comment	Y	\N	2007-02-27 11:09:27.335	\N
54	\N	Gentamycin Interpretation	Y	\N	2007-06-20 10:01:45.134	\N
220	\N	BAND GP160	Y	\N	2006-10-18 09:19:37.724	\N
221	\N	BAND GP120	Y	\N	2006-10-18 09:19:38.505	\N
222	\N	BAND P65	Y	\N	2006-09-07 08:39:02	\N
223	\N	BAND P55	Y	\N	2006-09-07 08:39:12	\N
224	\N	BAND P51	Y	\N	2006-09-07 08:39:22	\N
225	\N	BAND GP41	Y	\N	2006-10-18 09:19:37.302	\N
226	\N	BAND P40	Y	\N	2006-11-07 13:55:36.669	\N
227	\N	BAND P31	Y	\N	2006-11-06 13:15:38.449	\N
228	\N	BAND P24	Y	\N	2006-11-06 13:15:29.222	\N
229	\N	BAND P18	Y	\N	2006-11-08 08:09:44.805	\N
246	\N	Rnase P Interpretation	Y	\N	2006-09-18 10:27:21	\N
251	\N	Result Status	Y	\N	2006-10-10 09:27:45	\N
252	\N	Probability	Y	\N	2006-10-03 10:24:02	\N
271	\N	Modifier 1	Y	\N	2006-10-20 09:28:32	\N
272	\N	Modifier 2	Y	\N	2006-10-20 09:28:37	\N
273	\N	Modifier 3	Y	\N	2006-10-20 09:28:42	\N
274	\N	Result Status 1	Y	\N	2006-10-20 09:28:51	\N
275	\N	Result Status 2	Y	\N	2006-10-20 09:28:59	\N
276	\N	Result Status 3	Y	\N	2006-10-20 09:29:06	\N
206	\N	Influenza Virus A RNA	Y	\N	2007-02-02 14:19:32.675	\N
207	\N	Influenza Virus A/H1 RNA	Y	\N	2006-09-07 08:31:50	\N
240	\N	BA2 CT value	Y	\N	2006-10-18 09:19:43.005	\N
244	\N	Extraction Method	Y	\N	2006-09-20 16:26:23	\N
245	\N	16S Interpretation	Y	\N	2006-10-25 11:21:09.457	\N
40	\N	Agent	Y	\N	2007-04-12 09:42:50.799	\N
249	\N	Modifier	Y	\N	2006-10-02 10:23:08	\N
250	\N	Quantity	Y	\N	2006-10-03 09:12:43	\N
253	\N	Method	Y	\N	2006-11-08 10:28:43	\N
266	\N	Capsule M-Fadyean	Y	\N	2006-10-11 13:51:30	\N
234	\N	BA3 interpretation	Y	\N	2006-10-18 09:19:39.302	\N
235	\N	16S CT value	Y	\N	2007-06-18 08:49:51.801	\N
232	\N	BA1 interpretation	Y	\N	2006-10-18 09:19:44.442	\N
233	\N	BA2 interpretation	Y	\N	2006-10-18 09:19:42.067	\N
236	\N	Rnase P CT value	Y	\N	2006-10-13 09:57:57.558	\N
237	\N	Result	Y	\N	2006-09-18 10:03:34	\N
46	\N	Western Blot Interpretation	Y	\N	2007-05-15 13:48:03.305	\N
239	\N	BA1 CT value	Y	\N	2006-10-23 14:12:56.284	\N
241	\N	BA3 CT value	Y	\N	2006-10-18 09:19:40.583	\N
242	\N	TRF Spore Detection Dilution	Y	\N	2007-12-27 05:33:28.883	\N
243	\N	TRF Cell Detection Dilution	Y	\N	2007-12-27 05:34:38.238	\N
247	\N	Disclaimer	Y	\N	2006-09-20 16:26:06	\N
256	\N	Rifampin 2.0 mcg/ml	Y	\N	2006-10-10 09:29:37	\N
55	\N	Kanamycin Interpretation	Y	\N	2007-06-20 10:02:26.74	\N
255	\N	Rifampin 1.0 mcg/ml	Y	\N	2006-10-10 09:29:21	\N
257	\N	Isoniazid 0.1 mcg/ml	Y	\N	2006-10-10 09:29:54	\N
258	\N	Colony Morphology	Y	\N	2006-10-11 13:49:58	\N
259	\N	Hemolysis	Y	\N	2006-10-11 13:50:05	\N
260	\N	Gram stain	Y	\N	2006-10-11 13:50:12	\N
261	\N	Motility wet mount	Y	\N	2006-10-11 13:50:35	\N
262	\N	Gamma phage	Y	\N	2006-10-11 13:50:43	\N
263	\N	DFA capsule from specimen	N	\N	2007-12-10 09:06:14.825	\N
264	\N	DFA cell wall from specimen	N	\N	2007-12-10 09:06:14.846	\N
265	\N	Capsule India Ink	Y	\N	2006-10-11 13:51:06	\N
267	\N	Capsule bicarbonate	Y	\N	2006-10-11 13:51:40	\N
268	\N	Catalase	Y	\N	2006-10-11 13:51:46	\N
269	\N	Malachite green for spores	Y	\N	2006-10-11 13:51:57	\N
270	\N	Wet mount for spores	Y	\N	2006-10-11 13:52:38	\N
31	\N	Comment 1	Y	\N	2007-04-02 09:04:22.529	\N
32	\N	Comment 2	Y	\N	2007-04-02 09:04:28.801	\N
33	\N	Comment 3	Y	\N	2007-04-02 09:04:41.088	\N
34	\N	Comment 4	Y	\N	2007-04-02 09:04:46.92	\N
35	\N	Comment 5	Y	\N	2007-04-02 09:04:56.112	\N
36	\N	Comment 6	Y	\N	2007-04-02 09:05:01.84	\N
37	\N	Comment 7	Y	\N	2007-04-02 09:05:08.789	\N
39	\N	Comment 9	Y	\N	2007-04-02 09:05:21.5	\N
56	\N	Gentamycin	Y	\N	2007-06-20 10:02:52.199	\N
57	\N	Kanamycin	Y	\N	2007-06-20 10:03:02.449	\N
58	\N	Motility Standard Media	Y	\N	2007-10-02 08:38:33.138	\N
59	\N	Standard Motility Media	Y	\N	2007-10-09 08:37:56.727	\N
60	\N	Chocolate Agar	Y	\N	2007-10-09 08:38:11.08	\N
61	\N	DEA Agar	Y	\N	2007-10-09 08:38:17.659	\N
66	\N	Test Moiety	Y	\N	2007-12-10 09:03:38.415	\N
75	\N	Choose Equipment	Y	\N	2007-12-11 05:35:57.035	\N
76	\N	Previous FTA Reactivity	Y	\N	2007-12-27 02:40:54.886	\N
77	\N	Fluorescence Grading	Y	\N	2007-12-27 02:41:18.215	\N
79	\N	E. coli 25922	Y	\N	2007-12-27 03:34:33.647	\N
80	\N	P. aeruginosa	Y	\N	2007-12-27 03:39:41.842	\N
81	\N	S. aureus	Y	\N	2007-12-27 03:34:57.55	\N
82	\N	Susceptible	N	\N	2007-12-27 03:41:45.362	\N
83	\N	Nonsusceptible - Contact CDC for confirmation of resistance	N	\N	2007-12-27 03:41:30.012	\N
84	\N	Test Not Performed	N	\N	2007-12-27 03:41:50.671	\N
85	\N	No Pass	Y	\N	2007-12-27 03:36:31.375	\N
86	\N	Pass	Y	\N	2007-12-27 03:36:35.561	\N
87	\N	TRF Spore Detection Date Value	Y	\N	2007-12-27 05:33:47.18	\N
88	\N	TRF Spore Detection Result	Y	\N	2007-12-27 05:34:05.441	\N
93	\N	test kit	Y		2009-04-03 10:15:45.64	TESTKIT
94	\N	Conclusion	Y	\N	2010-10-28 06:12:42.031482	\N
95	\N	generated CD4 Count	Y	\N	2010-10-28 06:13:55.508252	\N
96	\N	VIH Test - Collodial Gold/Shangai Kehua Result	Y	\N	2011-02-02 11:55:53.383208	\N
97	\N	Determine Result	Y	\N	2011-02-02 11:55:53.383208	\N
\.


--
-- Name: analyte_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('analyte_seq', 97, true);


--
-- Data for Name: analyzer; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY analyzer (id, scrip_id, name, machine_id, description, analyzer_type, is_active, location, lastupdated) FROM stdin;
1	\N	sysmex	1	bootstrap machine	\N	t	\N	2009-11-25 15:35:31.343118
3	\N	cobas_integra	\N	cobas_integra	\N	t	\N	2009-12-14 15:35:31.34118
\.


--
-- Data for Name: analyzer_result_status; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY analyzer_result_status (id, name, description) FROM stdin;
1	NOT_REVIEWED	The result has not yet been reviewed by the user
2	ACCEPTED	The result has been reviewed and accepted by the user
3	DECLINED	The result has been reviewed and not accepted by the user
4	MATCHING_ACCESSION_NOT_FOUND	The Lab No does not exist in the system
5	MATCHING_TEST_NOT_FOUND	The Lab No exists but the test has not been entered
6	TEST_MAPPING_NOT_FOUND	The test name from the analyzer is not recognized
7	ERROR	The result sent from the analyzer can not be understood
\.


--
-- Data for Name: analyzer_results; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY analyzer_results (id, analyzer_id, accession_number, test_name, result, units, status_id, iscontrol, lastupdated, read_only, test_id, duplicate_id, positive, complete_date, test_result_type) FROM stdin;
\.


--
-- Name: analyzer_results_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('analyzer_results_seq', 1, false);


--
-- Name: analyzer_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('analyzer_seq', 1, true);


--
-- Data for Name: analyzer_test_map; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY analyzer_test_map (analyzer_id, analyzer_test_name, test_id, lastupdated) FROM stdin;
\.


--
-- Data for Name: animal_common_name; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY animal_common_name (id, name) FROM stdin;
\.


--
-- Data for Name: animal_scientific_name; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY animal_scientific_name (id, comm_anim_id, name) FROM stdin;
\.


--
-- Data for Name: attachment; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY attachment (id, attach_type, filename, description, storage_reference) FROM stdin;
\.


--
-- Data for Name: attachment_item; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY attachment_item (id, reference_id, reference_table_id, attachment_id) FROM stdin;
\.


--
-- Data for Name: aux_data; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY aux_data (id, sort_order, is_reportable, auxdata_type, value, reference_id, reference_table, aux_field_id) FROM stdin;
\.


--
-- Data for Name: aux_field; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY aux_field (id, sort_order, auxfld_type, is_active, is_reportable, reference_table, analyte_id, scriptlet_id) FROM stdin;
\.


--
-- Data for Name: aux_field_values; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY aux_field_values (id, auxfldval_type, value, aux_field_id) FROM stdin;
\.


--
-- Data for Name: chunking_history; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY chunking_history (id, chunk_length, start) FROM stdin;
1	5	1
\.


--
-- Name: chunking_history_id_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('chunking_history_id_seq', 1, true);


--
-- Name: city_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('city_seq', 1, false);


--
-- Data for Name: city_state_zip; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY city_state_zip (id, city, state, zip_code, county_fips, county, region_id, region, state_fips, state_name, lastupdated) FROM stdin;
\.


--
-- Data for Name: code_element_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY code_element_type (id, text, lastupdated, local_reference_table) FROM stdin;
1	TEST	2007-03-07 15:27:58.72	5
2	STATUS OF SAMPLE	2007-03-07 15:28:22.718	40
\.


--
-- Name: code_element_type_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('code_element_type_seq', 21, false);


--
-- Data for Name: code_element_xref; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY code_element_xref (id, message_org_id, code_element_type_id, receiver_code_element_id, local_code_element_id, lastupdated) FROM stdin;
\.


--
-- Name: code_element_xref_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('code_element_xref_seq', 41, false);


--
-- Data for Name: contact_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY contact_type (id, description, ct_type, is_unique) FROM stdin;
\.


--
-- Name: county_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('county_seq', 1, false);


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY databasechangelog (id, author, filename, dateexecuted, md5sum, description, comments, tag, liquibase) FROM stdin;
1	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.231186+00	fbb3d826689c8079383f8966ab37a40	Update Data, Insert Row	Adds Bahmni specific configuration to SiteInfo	\N	1.9.5
2	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.238996+00	9fdf1988edc356d939fb5b19f6159f2	Update Data (x2)	Change default locale to en-GB	\N	1.9.5
3	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.244788+00	d098e13cd4046e6c19a1fad7321f0df	Update Data		\N	1.9.5
4	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.268595+00	7b9e9a516c21e28d94c2e39187d51b6f	Update Data, Delete Data (x2), Insert Row (x6)	Create address fields for Bahmni	\N	1.9.5
5	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.285932+00	8528b491a9adeec15cc65da9e8e111ce	Add Column	Add type to address_part table	\N	1.9.5
6	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.292679+00	8af6aa37796c6f9b93f452ff85488d5e	Update Data	Set address part type to D for department	\N	1.9.5
7	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.317687+00	1dcb504c8dd711c5821f644e7b454443	Create Table (x3)	Adding changes to support openelis atom feed	\N	1.9.5
8	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.326538+00	95743476e0eaa7b9f4ac637baf753042	Add Unique Constraint		\N	1.9.5
9	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.334834+00	12e54dfdf40ef9687b83505587475f	Update Data	Stop the schedulers not required for bahmni	\N	1.9.5
10	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.339659+00	51cafbf15b83cbcd9ffb8682623c7d5	Insert Row		\N	1.9.5
11	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.345208+00	db20a3a4517ec0935f2629547cbed050	Insert Row		\N	1.9.5
12	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.357972+00	dbcf46fdb9d9409e1ea1a7ec655ec7be	Insert Row, Create Table		\N	1.9.5
13	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.383417+00	6530b8fe6597f68c71e3e442c033ceb	Insert Row (x6)		\N	1.9.5
14	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.388415+00	d72983705e445daa95e1964ed3628b12	Insert Row		\N	1.9.5
15	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.401781+00	c117c485e50f7bf2d477caad6b7886	Create Table (x2)		\N	1.9.5
16	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.406682+00	d4f77cf8e7b534b1b48b871bb9b493	Insert Row		\N	1.9.5
17	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.411035+00	3d04e51d52a399d3d4b648c81c15e1e	Add Column		\N	1.9.5
18	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.415412+00	6811141e230d820ac428c1cfd4e4d2f	Add Column		\N	1.9.5
19	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.422054+00	ff83a64a965cf660bf6894e3db880ad	Add Foreign Key Constraint		\N	1.9.5
20	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.428797+00	3d76e547a2a0641b65b672b0e7378ee3	Drop Not-Null Constraint (x2), Insert Row		\N	1.9.5
21	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.439477+00	b6cdf43bf25f3a845f969087a661ac30	Create Table, Add Column, Add Foreign Key Constraint	Add new table sample_source and link to sample table	\N	1.9.5
22	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.447423+00	894861a63f30fe7e96e64ffd433b615	Insert Row (x5)	Data required for sample_source	\N	1.9.5
23	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.45207+00	7352f64602939506841834943dca34	Add Column	Add new column to sample_source for ordering the dropdown display	\N	1.9.5
24	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.459337+00	585f3b499830db5eb6b8120215cac5c	Update Data (x5)	setting values for ordering the sample_sources	\N	1.9.5
25	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.470373+00	9adf28b1628995782f9674c5ff87b34d	Insert Row	Adds the menu items for Validate 'All Test Sections'	\N	1.9.5
26	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.477598+00	7015f392507d7b83e4e698c2b4d4dd6	Update Data (x3), Insert Row, Update Data, Insert Row, Add Column		\N	1.9.5
27	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.484337+00	251f64a93f13df7d5a42376ced4ed342	Insert Row	Add primary relative	\N	1.9.5
28	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.490936+00	888544fe15beb6060dee237783c1b18	Update Data	Make validation of results compulsory	\N	1.9.5
29	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.49824+00	48297d26de5b5eccac6c34c3f7df3caf	Add Column	Add isActive column to Person	\N	1.9.5
30	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.511958+00	12d2aadc4cc456a77445ad2083bc360	Insert Row	Adds referral types	\N	1.9.5
31	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.522204+00	d9f5c984235f6f66087ff6bf81715c1	Update Data, Insert Row	Adding labDashboard menu	\N	1.9.5
32	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.526556+00	4c70d45ef353eed968defa695e14d825	Add Column	Adds uuid for the patient	\N	1.9.5
33	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.531182+00	617f7ee6ab9fa6abf1c1266fd8787	Update Data	Change frequency of patient runs	\N	1.9.5
34	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.54076+00	5018a6c2d6a179c973f056e59ad14e	Update Data	Sets the default for showing the invalid results icon to true	\N	1.9.5
35	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.55562+00	6a32f48c2b8954077897aad23935eb	Insert Row (x2)		\N	1.9.5
36	marks	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.562304+00	98b4f1e285ff50e28bacb2b0ef51bfe8	Insert Row	Adds the upload menu item for Bahmni	\N	1.9.5
37	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.566915+00	f0ea9e1a51c16823072d31ce4a2ce7	Update Data	Validation fails if active inventory items dont have receipt. Inactivating the inventory items	\N	1.9.5
38	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.573472+00	d269c8527ffb1f9555efc54a9e5dfa30	Delete Data (x2)	Remove haiti test section menus for Test Results and Validation	\N	1.9.5
39	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.581802+00	12805cd8ca8c1d735ae85e7be52ee46	Delete Data (x3)	Removing menus not needed for Bahmni	\N	1.9.5
40	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.588105+00	e8ff848c9c216c84404443e15f8441a3	Insert Row	Adds the referredOut menu item for Bahmni	\N	1.9.5
41	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.595659+00	6be8a544315b66d8312e812af42a35	Insert Row (x2)		\N	1.9.5
42	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.603406+00	1aaae69b35317096d42961f3c8b6b71	Insert Row		\N	1.9.5
43	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.610536+00	5917775a48be31488a915e41b538ffc	Update Data	Remove logo in reports	\N	1.9.5
44	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.624245+00	8a2d5752e1d32b8f49e77f3d2483fab1	Create Table		\N	1.9.5
45	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.639448+00	e6baa294c3b1aa33df2673f090c5ea46	Drop Column, Add Column		\N	1.9.5
46	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.644317+00	e7e107053ae43eb4cd6ad7e6a37c8ff	Update Data		\N	1.9.5
47	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.654178+00	a66ff54cc2e52933346841d5b27ba44e	Insert Row (x2)		\N	1.9.5
48	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.660516+00	dc25a6c2c5f6e3385184fd34f1bf1684	Update Data	Set site name	\N	1.9.5
49	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.66871+00	c14e6e9daf5838392a0b09a9d91dd95	Insert Row		\N	1.9.5
50	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.683154+00	5ee6815888a4bdde797d4325649470	Insert Row (x4), Custom SQL (x2)	Adjust modules and roles for the new pages	\N	1.9.5
51	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.686952+00	5c6d25fc2dca78ff406412d24d47dbba	Custom SQL	Increase the column size for panel_item	\N	1.9.5
52	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.693729+00	36fd130967c6682bab92bce958ba2	Update Data, Custom SQL	Fix changeset 50	\N	1.9.5
53	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.698326+00	9b41b352ca5092b2dba895f21b6e6b	Insert Row, Custom SQL	Add module for validation of all sections	\N	1.9.5
54	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.710808+00	842f674f3b3cb019fdbfd3ff2ede7ac3	Insert Row	Add Bahmni Lab Dictionary category	\N	1.9.5
55	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.718408+00	6715f229e975853ebecacb41b6fd4	Update Data (x2), Insert Row		\N	1.9.5
56	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.725384+00	146d4fe87022ab30736691f81dcd505c	Custom SQL (x2)	Increase the column size for result and notes column	\N	1.9.5
57	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.728794+00	e6da70772b21a5c0f633e7244b4dac4b	Insert Row		\N	1.9.5
58	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.732907+00	3f359a4878769e6ef16239635d04f90	Insert Row		\N	1.9.5
59	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.738116+00	f73b81f43c6a8f4960e0f22ec98114e2	Insert Row, Custom SQL	Add health center to list of pages	\N	1.9.5
rel3-57	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.745991+00	d51af10bc22b4992687c5231e1c9ec4	Insert Row (x2)		\N	1.9.5
rel3-58	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.749884+00	42b9d33a45862441b65268fb2e847eb	Add Column	Adds uuid for the sample	\N	1.9.5
60	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.757342+00	3cef778933d433c63e25678377233781	Update Data (x3)	Remove all report senders	\N	1.9.5
61	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.764757+00	3e7bb5d920c8f2aa695ed5b403be11a	Modify Column		\N	1.9.5
62	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.771774+00	5114137b658ea3eff32d1d89e2bb59b	Add Column, Update Data	Add new column to Health Center	\N	1.9.5
63	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.775643+00	31e2978fbb06f8a8b7a658fe2e15ae8	Add Column	Add Abnormal Column to Test Result	\N	1.9.5
64	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.779032+00	958ea25b0be90d745f27ce1eb555b89	Add Column	Add Abnormal Column to Result	\N	1.9.5
65	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.782964+00	95e7c7e911da974716a99edb42afd43	Add Default Value		\N	1.9.5
66	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.795563+00	f71a85ff1cfab5e46527546f917d47	Add Default Value		\N	1.9.5
67	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.801357+00	c36b9624606ff3fa43aedb537229e48e	Update Data		\N	1.9.5
68	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.804274+00	856184dc76f5bd8f1b0b31b2544a11	Update Data		\N	1.9.5
69	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.807157+00	9d47a92a50737b95440d7f6af1ed23	Update Data		\N	1.9.5
70	ict4h	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.815156+00	2cd78aa135eb58cb87939259f7ff89a3	Create Table		\N	1.9.5
71	ict4h	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.819011+00	9fb19a37181d98a114acb757f7a58454	Add Column		\N	1.9.5
72	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.823208+00	58902e1256d5b686f1a35f826d0b2d9	Update Data	Fix changeset 50	\N	1.9.5
73	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.825922+00	e919753073f336be3ca10afb3817db	Custom SQL	Ensure uuid present in sample table	\N	1.9.5
74	ict4h	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.829997+00	1f70ce6b8944c7a10fb24b7b8d2f0a8	Add Column		\N	1.9.5
75	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.833735+00	e460ef295f5bc95048672ca9e4272b6a	Custom SQL	Ensure uuid present in test_section table	\N	1.9.5
76	ict4h	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.836968+00	bcf237419bc957d654bb2262db5ca9b	Add Column		\N	1.9.5
77	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.840547+00	afbfeee908a94b37157b192b8d574bd	Custom SQL	Ensure uuid present in unit_of_measure table	\N	1.9.5
78	ict4h	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.843508+00	d7fdb431abaacf4c76b8dbf89ebba68	Add Column		\N	1.9.5
79	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.846516+00	e78c7a787271c5d765e449b943176	Custom SQL	Ensure uuid present in type_of_sample table	\N	1.9.5
80	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.849664+00	bc99606e1142cc802f80bfc9be249616	Custom SQL	Add event records for existing accession	\N	1.9.5
81	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.853089+00	5a496cfa721934a14fb96f6cbc7d5e0	Insert Row (x2)		\N	1.9.5
82	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.856742+00	2cc73c35d1b716c96085dc23b0e685	Insert Row		\N	1.9.5
83	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.860588+00	d83b4323783eefe889ba1d4b20464def	Delete Data		\N	1.9.5
84	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.863362+00	4e713be5877ee164bed0beb8356442	Custom SQL	Set system user id from non_user_name	\N	1.9.5
85	tw	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.866701+00	a835911eaabff25468bfd3c9a867b775	Custom SQL	Remove all event records incorrectly created with category result	\N	1.9.5
86	Banka	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.874344+00	40e91b9ce8694773c5192adea9aa3d2d	Add Unique Constraint	Add unique constraint for uuid in patient	\N	1.9.5
87	arathy	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.877591+00	6868deb3523648b86efcd7427a0b6af	Update Data	Adding site information for logo image name	\N	1.9.5
88	arathy	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.880802+00	b66de51c225873cba68bbc3d6eaeb3	Update Data	Changing value_type of additional info	\N	1.9.5
89	rohan	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.886821+00	8558363928649f3534f1b4b381e89155	Custom SQL	Change duplicate unit of measures	\N	1.9.5
90	rohan	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.890264+00	d9335ad1e2ecd9272c376a47d84110	Delete Data (x4)	Remove duplicate unit of measures	\N	1.9.5
91	Neha	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.894199+00	a7456a8243b171bce968f99e305bc36f	Custom SQL	Update gender_seq to the latest value	\N	1.9.5
92	Rohan,Neha	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.89815+00	e337dc7d06bc31173bc804a3036a98b	Add Column	Add the uploaded_file_name column to the result table	\N	1.9.5
93	Rohan,Neha	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.901708+00	58adb8ac461ce2bc58d2e81be272eab8	Insert Row	Add uploaded results directory path in site information	\N	1.9.5
94	Arathy	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.904601+00	c68c967d96328a6cb1bd91731f85e2	Add Column	Add result limit id column to the result table	\N	1.9.5
95	Bharti,Arathy	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.908909+00	7b1d768561ead1ffd58388ccbd512b2b	Custom SQL	Adding Hospital name and address	\N	1.9.5
96	Bharti, Arathy	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.911195+00	1c53b5123773829851e5e0622fa69485	Custom SQL	Update gender_seq to the latest value	\N	1.9.5
97	Chethan, Mihir	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.916709+00	656891fd6124062737d415d32b4399	Insert Row (x2)		\N	1.9.5
98	Mihir	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.919957+00	77a3c5fe5ef0f8d671f86fa551c0e3	Custom SQL	Update cron_statement to correct cron schedule	\N	1.9.5
99	Mihir	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.923591+00	7925275d70b5a17c6daa409a59a1b	Custom SQL	Delete reference data atom feed scheduler	\N	1.9.5
100	Mihir, Sravanthi	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.928504+00	20c5a6c93e83e86a7cc396c92864ec3f	Custom SQL	Delete view hiv_patients	\N	1.9.5
101	Mihir, Sravanthi	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.931551+00	381a2449367bedd6383bac4d5c898cc1	Custom SQL	Resize test_section name column	\N	1.9.5
102	Mihir, Hemanth	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.935947+00	c7deddfddad7e4b12fc6cb13a6c7ff7	Custom SQL	Resize type_of_sample local_abbrev column	\N	1.9.5
103	Chethan, Hemanth	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.950114+00	e77af5f1a2ae188dd0129ecd38ff283	Drop View, Modify Column, Custom SQL	altering the data type of name fields to accept 50 characters in person table and sampletracking view	\N	1.9.5
104	Charles, Sravanthi	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.954897+00	6abe62cbbf20be79c4626dea168a4982	Drop Not-Null Constraint		\N	1.9.5
105	Preethi, Sandeep	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.96457+00	2d8debf96edbac8845362b10e0aea4	Add Column		\N	1.9.5
106	Preethi, Sandeep	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.96915+00	bddbd04fe4a918a3fab7715ad4f9b77c	Custom SQL	set active flag for all test results	\N	1.9.5
108	Sudhakar, Abishek	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.980413+00	5cea549b48745cd8dde63cf6f5d1f27f	Add Column, Create Table		\N	1.9.5
109	Shan, Sandeep	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.984413+00	35592da18b4b0f2e8593daf8d8e5e34	Add Column		\N	1.9.5
110	Padma, Hemanth	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.987828+00	a07a406d22de70583646b0c578414	Insert Row		\N	1.9.5
14092015080113	Hemanth	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:50.995349+00	d11cd9dc4ae9d2b3f3ed627eff6c66	Create Table		\N	1.9.5
06102015170630	Achinta, Sudhakar	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:51.002806+00	2fc695cbf4bbd47824d1e58182f6385e	Create Index	Add index to the category column in event_records table for performance (if it is not already present)	\N	1.9.5
151120151208	Sourav	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:51.006501+00	564baeb237118b7a64e85742a271924	Modify Column	altering the data type of identity_data to accept 50 characters in patient_identity table	\N	1.9.5
115420153112	Hanisha,Shashi	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:51.02153+00	7f1ab3e5dff1a49e4432bfc925fbdf19	Add Column	Add isReferredOut Column to Test	\N	1.9.5
120020160501	Hanisha, Shashi	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:51.025887+00	6bf7837debee7b3eab677fe6a3b49b6b	Insert Row	Adding new organization External Lab	\N	1.9.5
042120160501	Hanisha,Shashi	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:51.02916+00	d0b8bef9aecd9c47cd777ce5e067336d	Insert Row		\N	1.9.5
042220160501	Hanisha,Shashi	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:51.03373+00	f8f5ddf4963253bed788489816ba89	Custom SQL	Adding new organization External Lab to organization_organization_type	\N	1.9.5
2016-01-12-1202	Jaswanth, JP	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:51.036708+00	63ed66a6ed7f1cf38d548a189dbf946	Update Data		\N	1.9.5
011920161233	Shashi, Hanisha	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:54.223642+00	479b2fbfdca83dac49acedbb89bf337	Add Column	Creating column date_created for queue table. This indicates the time event was raised or created.	\N	1.9.5
0119290161232	Shashi, Hanisha	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:57.365837+00	b04bc0a48aa3cacd63689d68c76cb78	Add Column	Creating column tags for failed_events table. This is same as atom spec feed.entry.categories.	\N	1.9.5
240220161208	Vinay	./Bahmni/BahmniConfig.xml	2017-12-26 13:07:57.369066+00	fd3a6b69eafdb73e127aab76f370f1	Modify Column	Identity data should contain full length of a concept name, which is 255 characters	\N	1.9.5
140320161800	Vinay	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:00.375676+00	769a8ce4ad984daa9726b39ef8110c	Create Index	Add index on lastupdated for sample	\N	1.9.5
140320161801	Vinay	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:03.643148+00	a97b4bdbe7e96423eacdb3c851159af	Create Index	Add index on lastupdated for analysis	\N	1.9.5
150320161101	Vinay	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:06.69797+00	79f2bbb916f6a5b9fb4550c72740bc3a	Create Index	Add index on patient_id for patient_identity table	\N	1.9.5
201603171606	Jaswanth,Swathi	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:06.702003+00	c9f8cdeaa83559436ee8de2baf33	Update Data	Increase schedule interval to 24 hours	\N	1.9.5
2016-03-24-9732	Jaswanth, Hemanth	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:06.704983+00	c07143d7f2a7b69023c5d77dc9757a67	Update Data		\N	1.9.5
201615041044	Chethan	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:06.708877+00	7fb860ef31724fce990557b9e84a1a4	Update Data	atom-feed-events-offset-marker job should be run on 12 am everyday	\N	1.9.5
20160714-2017-1	Jaswanth,Padma	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:09.632075+00	aebd75a4dca25f94963c13fbe2fb2b5	Add Column	Creating column tags for queue table. Each event can be tagged with multiple tags; as comma separated strings	\N	1.9.5
20160714-2017-2	Jaswanth,Padma	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:12.633226+00	7a1b3b77f7815cfc87985879c2f960ab	Add Column	Creating column tags for event_records table. Each event can be tagged with multiple tags; as comma separated strings	\N	1.9.5
030820161209	Hanisha	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:12.638046+00	9996261a4d9b449f1e7d2f83795d23d8	Custom SQL	Adding the visit location for lab(Used in sync)	\N	1.9.5
230820161641	Jaswanth,Kaustav	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:12.643241+00	9c562532ebf92aeeaeb687883d648dd	Drop Column, Drop Table		\N	1.9.5
20160809	Bindu,Gurpreet	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:12.646662+00	ab9a36cb4dd89b68f9894e7736cc91	Custom SQL	Update allowLanguageChange to true to enable Internationalization in Login page	\N	1.9.5
add-atomfeed-user	Jaswanth	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:12.649791+00	a8d3a4ca961a7bc2697889db54a967c1	Custom SQL	Add user for accessing atomfeed	\N	1.9.5
update-admin-user-password-expiry-date	Jaswanth	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:12.651974+00	f09ccd7a6d790c7fde3af5216ed3aca	Custom SQL	Update admin user password expiry date	\N	1.9.5
assign-module-to-atomfeed-user	Jaswanth	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:12.656528+00	45842815bc6181e5976a93d5bbcfd	Custom SQL	Assign LabDashboard module to atomfeed user	\N	1.9.5
remove-lab-location-config	Padma, Salauddin	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:12.659541+00	1f9b3c3fb1ff1cf19c2bb952b283	Custom SQL	Removing the lab location configuration	\N	1.9.5
configure-default-sample-source	Padma, Salauddin	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:12.662545+00	4ae635a8ea129e917af0e3c3745bfbd7	Custom SQL	Adding the default Sample source configuration	\N	1.9.5
change-sample-source-name-length	Salauddin	./Bahmni/BahmniConfig.xml	2017-12-26 13:08:12.665951+00	8ac795f75b79aa797394e95269224b7	Custom SQL	change sample source name to accept 50 characters	\N	1.9.5
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
\.


--
-- Data for Name: dictionary; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY dictionary (id, is_active, dict_entry, lastupdated, local_abbrev, dictionary_category_id, display_key) FROM stdin;
1245	\N	Kyste	2018-01-05 15:53:10.867	\N	\N	\N
1246	\N	Œuf	2018-01-05 15:53:10.871	\N	\N	\N
1247	\N	Parasite	2018-01-05 15:53:10.875	\N	\N	\N
1217	\N	gram +	2018-01-05 15:53:10.499	\N	\N	\N
1218	\N	gram -	2018-01-05 15:53:10.502	\N	\N	\N
1222	\N	presence microfilaire	2018-01-05 15:53:10.653	\N	\N	\N
1223	\N	absence microfilaire	2018-01-05 15:53:10.657	\N	\N	\N
1264	\N	5	2018-01-05 15:53:10.683	\N	\N	\N
1265	\N	6	2018-01-05 15:53:10.687	\N	\N	\N
1266	\N	7	2018-01-05 15:53:10.69	\N	\N	\N
1267	\N	8	2018-01-05 15:53:10.694	\N	\N	\N
1215	\N	coque	2018-01-05 15:53:10.952	\N	\N	\N
1216	\N	bacille	2018-01-05 15:53:10.957	\N	\N	\N
1268	\N	9	2018-01-05 15:53:10.698	\N	\N	\N
1244	\N	-	2018-01-05 15:53:11.048	\N	\N	\N
1200	\N	microcitaire hypochrome	2018-01-05 15:53:11.137	\N	\N	\N
1201	\N	microcitaire hyperchrome	2018-01-05 15:53:11.143	\N	\N	\N
1202	\N	microcitaire normochrome	2018-01-05 15:53:11.147	\N	\N	\N
1203	\N	macrocitaire hypochrome	2018-01-05 15:53:11.152	\N	\N	\N
1204	\N	macrocitaire hyperchrome	2018-01-05 15:53:11.157	\N	\N	\N
1205	\N	macrocitaire normochrome	2018-01-05 15:53:11.161	\N	\N	\N
1212	\N	Isospora	2018-01-05 15:53:11.466	\N	\N	\N
1213	\N	Cryptosporidium	2018-01-05 15:53:11.471	\N	\N	\N
1214	\N	Cyclospora	2018-01-05 15:53:11.476	\N	\N	\N
1260	\N	isolé	2018-01-05 15:53:11.497	\N	\N	\N
1261	\N	en amas	2018-01-05 15:53:11.503	\N	\N	\N
1262	\N	en chainette	2018-01-05 15:53:11.508	\N	\N	\N
1263	\N	en diplo	2018-01-05 15:53:11.513	\N	\N	\N
1243	\N	++++	2018-01-05 15:53:11.562	\N	\N	\N
1280	\N	MTB -	2018-01-05 15:53:11.573	\N	\N	\N
1281	\N	MTB + RIF -	2018-01-05 15:53:11.578	\N	\N	\N
1282	\N	MTB + RIF +	2018-01-05 15:53:11.583	\N	\N	\N
1283	\N	MTB + RIF indeterminé	2018-01-05 15:53:11.588	\N	\N	\N
1248	\N	Presence de cryptocoque	2018-01-05 15:53:11.671	\N	\N	\N
1249	\N	Absence de cryptocoque	2018-01-05 15:53:11.677	\N	\N	\N
1220	\N	Oui	2018-01-05 15:53:11.688	\N	\N	\N
1221	\N	Non	2018-01-05 15:53:11.694	\N	\N	\N
1210	\N	Positif	2018-01-05 15:53:11.743	\N	\N	\N
1206	\N	A	2018-01-05 15:53:11.761	\N	\N	\N
1207	\N	B	2018-01-05 15:53:11.766	\N	\N	\N
1208	\N	AB	2018-01-05 15:53:11.772	\N	\N	\N
1209	\N	O	2018-01-05 15:53:11.778	\N	\N	\N
1211	\N	Négatif	2018-01-05 15:53:11.79	\N	\N	\N
1219	\N	Scanti	2018-01-05 15:53:11.796	\N	\N	\N
1240	\N	+	2018-01-05 15:53:11.801	\N	\N	\N
1241	\N	++	2018-01-05 15:53:11.807	\N	\N	\N
1242	\N	+++	2018-01-05 15:53:11.812	\N	\N	\N
\.


--
-- Data for Name: dictionary_category; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY dictionary_category (id, description, lastupdated, local_abbrev, name) FROM stdin;
197	Bahmni Lab	2017-12-26 13:07:50.706344	\N	Bahmni Lab
\.


--
-- Name: dictionary_category_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('dictionary_category_seq', 216, true);


--
-- Name: dictionary_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('dictionary_seq', 1299, true);


--
-- Data for Name: district; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY district (id, city_id, dist_entry, lastupdated, description) FROM stdin;
\.


--
-- Name: district_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('district_seq', 1, false);


--
-- Data for Name: document_track; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY document_track (id, table_id, row_id, document_type_id, parent_id, report_generation_time, lastupdated, name) FROM stdin;
58	1	30	4	\N	2018-01-05 10:46:12.946+00	2018-01-05 10:46:12.949+00	patientHaitiClinical
59	1	30	4	58	2018-01-05 10:46:34.772+00	2018-01-05 10:46:34.776+00	patientHaitiClinical
60	1	30	4	59	2018-01-05 11:22:36.355+00	2018-01-05 11:22:36.356+00	patientHaitiClinical
61	1	30	4	60	2018-01-05 11:23:32.473+00	2018-01-05 11:23:32.474+00	patientHaitiClinical
62	1	29	4	\N	2018-01-05 11:26:08.991+00	2018-01-05 11:26:08.992+00	patientHaitiClinical
63	1	28	4	\N	2018-01-05 11:27:34.155+00	2018-01-05 11:27:34.157+00	patientHaitiClinical
\.


--
-- Name: document_track_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('document_track_seq', 63, true);


--
-- Data for Name: document_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY document_type (id, name, description, lastupdated) FROM stdin;
1	nonConformityNotification	Non_Conformity reports to be sent to clinic	2012-04-24 00:30:14.523972+00
2	resultExport	Results sent electronically to other systems	2012-04-24 00:30:14.678323+00
3	malariaCase	malaria case report sent	2012-05-01 16:46:25.085126+00
4	patientReport	Any patient report, name in report_tracker	2013-08-08 08:02:35.04225+00
\.


--
-- Name: document_type_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('document_type_seq', 4, true);


--
-- Data for Name: ethnicity; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY ethnicity (id, ethnic_type, description, is_active) FROM stdin;
\.


--
-- Data for Name: event_records; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY event_records (id, uuid, title, "timestamp", uri, object, category, date_created, tags) FROM stdin;
\.


--
-- Name: event_records_id_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('event_records_id_seq', 10, true);


--
-- Data for Name: event_records_offset_marker; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY event_records_offset_marker (id, event_id, event_count, category) FROM stdin;
\.


--
-- Name: event_records_offset_marker_id_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('event_records_offset_marker_id_seq', 1, false);


--
-- Data for Name: event_records_queue; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY event_records_queue (id, uuid, title, "timestamp", uri, object, category, tags) FROM stdin;
\.


--
-- Name: event_records_queue_id_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('event_records_queue_id_seq', 10, true);


--
-- Data for Name: external_reference; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY external_reference (id, item_id, external_id, type) FROM stdin;
1	784	c7bbfd75-f1f6-11e7-b81f-0a7176ae86de	Test
2	785	c7bc390f-f1f6-11e7-b81f-0a7176ae86de	Test
3	786	c7bc7db0-f1f6-11e7-b81f-0a7176ae86de	Test
4	787	c7bcb17c-f1f6-11e7-b81f-0a7176ae86de	Test
5	788	c7bcecff-f1f6-11e7-b81f-0a7176ae86de	Test
6	789	c7bd223e-f1f6-11e7-b81f-0a7176ae86de	Test
7	790	c7bd5917-f1f6-11e7-b81f-0a7176ae86de	Test
8	791	c7bd8d09-f1f6-11e7-b81f-0a7176ae86de	Test
9	792	c7bdc661-f1f6-11e7-b81f-0a7176ae86de	Test
10	793	c7be0073-f1f6-11e7-b81f-0a7176ae86de	Test
11	794	c7be345b-f1f6-11e7-b81f-0a7176ae86de	Test
12	1200	c7a3ceaa-f1f6-11e7-b81f-0a7176ae86de	CodedAns
13	1201	c7a40aee-f1f6-11e7-b81f-0a7176ae86de	CodedAns
14	1202	c7a4895e-f1f6-11e7-b81f-0a7176ae86de	CodedAns
15	1203	c7a54312-f1f6-11e7-b81f-0a7176ae86de	CodedAns
16	1204	c7a579d3-f1f6-11e7-b81f-0a7176ae86de	CodedAns
17	1205	c7a5b5dc-f1f6-11e7-b81f-0a7176ae86de	CodedAns
18	795	c7be6a2d-f1f6-11e7-b81f-0a7176ae86de	Test
19	796	c7be9dc3-f1f6-11e7-b81f-0a7176ae86de	Test
20	797	c7bed00f-f1f6-11e7-b81f-0a7176ae86de	Test
21	1206	c7a5ee1f-f1f6-11e7-b81f-0a7176ae86de	CodedAns
22	1207	c7a65355-f1f6-11e7-b81f-0a7176ae86de	CodedAns
23	1208	c7a68a8e-f1f6-11e7-b81f-0a7176ae86de	CodedAns
24	1209	c7a6d00d-f1f6-11e7-b81f-0a7176ae86de	CodedAns
25	798	c7bf0495-f1f6-11e7-b81f-0a7176ae86de	Test
26	1210	c769fd0e-f1f6-11e7-b81f-0a7176ae86de	CodedAns
27	1211	c76cc0ff-f1f6-11e7-b81f-0a7176ae86de	CodedAns
28	799	c7c05790-f1f6-11e7-b81f-0a7176ae86de	Test
29	1220	987a1e3f-223c-4a05-981b-ba26eb6e975d	CodedAns
30	1221	494935b6-5fbc-4b77-b460-579d7938d350	CodedAns
31	800	c7c08cc2-f1f6-11e7-b81f-0a7176ae86de	Test
32	1222	c7a83868-f1f6-11e7-b81f-0a7176ae86de	CodedAns
33	1223	c7a8efb5-f1f6-11e7-b81f-0a7176ae86de	CodedAns
34	801	c7c0c094-f1f6-11e7-b81f-0a7176ae86de	Test
35	802	c7c10228-f1f6-11e7-b81f-0a7176ae86de	Test
36	803	c7c1344c-f1f6-11e7-b81f-0a7176ae86de	Test
37	804	c7c165b4-f1f6-11e7-b81f-0a7176ae86de	Test
38	805	c7c19870-f1f6-11e7-b81f-0a7176ae86de	Test
39	806	c7c1cc17-f1f6-11e7-b81f-0a7176ae86de	Test
40	1240	c7a92a13-f1f6-11e7-b81f-0a7176ae86de	CodedAns
41	1241	c7a96d0a-f1f6-11e7-b81f-0a7176ae86de	CodedAns
42	1242	c7a9a386-f1f6-11e7-b81f-0a7176ae86de	CodedAns
43	1243	c7aa022f-f1f6-11e7-b81f-0a7176ae86de	CodedAns
44	1244	c7aa3958-f1f6-11e7-b81f-0a7176ae86de	CodedAns
45	807	c7c20d1f-f1f6-11e7-b81f-0a7176ae86de	Test
46	1245	c7aa9747-f1f6-11e7-b81f-0a7176ae86de	CodedAns
47	1246	c7ab0a92-f1f6-11e7-b81f-0a7176ae86de	CodedAns
48	1247	c7ab4112-f1f6-11e7-b81f-0a7176ae86de	CodedAns
49	808	c7c27700-f1f6-11e7-b81f-0a7176ae86de	Test
50	809	c7c2aada-f1f6-11e7-b81f-0a7176ae86de	Test
51	1212	c7ab9675-f1f6-11e7-b81f-0a7176ae86de	CodedAns
52	1213	c7abf2a8-f1f6-11e7-b81f-0a7176ae86de	CodedAns
53	1214	c7ac4beb-f1f6-11e7-b81f-0a7176ae86de	CodedAns
54	810	c7c2df49-f1f6-11e7-b81f-0a7176ae86de	Test
55	811	c7c311b2-f1f6-11e7-b81f-0a7176ae86de	Test
56	812	c7c3aa44-f1f6-11e7-b81f-0a7176ae86de	Test
57	813	c7c3df40-f1f6-11e7-b81f-0a7176ae86de	Test
58	814	c7c4144a-f1f6-11e7-b81f-0a7176ae86de	Test
59	815	c7c45237-f1f6-11e7-b81f-0a7176ae86de	Test
60	1248	c7aca8db-f1f6-11e7-b81f-0a7176ae86de	CodedAns
61	1249	c7ad318e-f1f6-11e7-b81f-0a7176ae86de	CodedAns
62	816	c7c48791-f1f6-11e7-b81f-0a7176ae86de	Test
63	817	c7c4bcfc-f1f6-11e7-b81f-0a7176ae86de	Test
64	818	c7c50087-f1f6-11e7-b81f-0a7176ae86de	Test
65	1215	c7ad681d-f1f6-11e7-b81f-0a7176ae86de	CodedAns
66	1216	c7adbc68-f1f6-11e7-b81f-0a7176ae86de	CodedAns
67	819	c7c533f3-f1f6-11e7-b81f-0a7176ae86de	Test
68	1217	c7ae181c-f1f6-11e7-b81f-0a7176ae86de	CodedAns
69	1218	c7ae9434-f1f6-11e7-b81f-0a7176ae86de	CodedAns
70	820	c7c56626-f1f6-11e7-b81f-0a7176ae86de	Test
71	1260	c7aef072-f1f6-11e7-b81f-0a7176ae86de	CodedAns
72	1261	c7af4c5d-f1f6-11e7-b81f-0a7176ae86de	CodedAns
73	1262	c7afa66d-f1f6-11e7-b81f-0a7176ae86de	CodedAns
74	1263	c7b00220-f1f6-11e7-b81f-0a7176ae86de	CodedAns
75	821	c7c599f2-f1f6-11e7-b81f-0a7176ae86de	Test
76	822	c7c5cd64-f1f6-11e7-b81f-0a7176ae86de	Test
77	823	c7c60112-f1f6-11e7-b81f-0a7176ae86de	Test
78	824	c7c6355b-f1f6-11e7-b81f-0a7176ae86de	Test
79	825	c7c66aec-f1f6-11e7-b81f-0a7176ae86de	Test
80	826	c7c69f15-f1f6-11e7-b81f-0a7176ae86de	Test
81	827	c7c6d2cb-f1f6-11e7-b81f-0a7176ae86de	Test
82	828	c7c704e1-f1f6-11e7-b81f-0a7176ae86de	Test
83	829	c7c73785-f1f6-11e7-b81f-0a7176ae86de	Test
84	1264	c7b2016a-f1f6-11e7-b81f-0a7176ae86de	CodedAns
85	1265	c7b234f2-f1f6-11e7-b81f-0a7176ae86de	CodedAns
86	1266	c7b37c1d-f1f6-11e7-b81f-0a7176ae86de	CodedAns
87	1267	c7b3ad43-f1f6-11e7-b81f-0a7176ae86de	CodedAns
88	1268	c7b3df36-f1f6-11e7-b81f-0a7176ae86de	CodedAns
89	830	c7c76b80-f1f6-11e7-b81f-0a7176ae86de	Test
90	831	c7c79e69-f1f6-11e7-b81f-0a7176ae86de	Test
91	832	c7c7d418-f1f6-11e7-b81f-0a7176ae86de	Test
92	833	c7c88186-f1f6-11e7-b81f-0a7176ae86de	Test
93	834	c7c8c1e9-f1f6-11e7-b81f-0a7176ae86de	Test
94	835	c7c95914-f1f6-11e7-b81f-0a7176ae86de	Test
95	836	c7c9916a-f1f6-11e7-b81f-0a7176ae86de	Test
96	837	c7c9c56f-f1f6-11e7-b81f-0a7176ae86de	Test
97	838	c7c9f7ab-f1f6-11e7-b81f-0a7176ae86de	Test
98	839	c7ca2c3c-f1f6-11e7-b81f-0a7176ae86de	Test
100	841	c7ca919f-f1f6-11e7-b81f-0a7176ae86de	Test
101	842	c7cac609-f1f6-11e7-b81f-0a7176ae86de	Test
102	843	c7caf89a-f1f6-11e7-b81f-0a7176ae86de	Test
103	844	c7cb2b48-f1f6-11e7-b81f-0a7176ae86de	Test
104	845	c7cb5d77-f1f6-11e7-b81f-0a7176ae86de	Test
105	846	c7cb9249-f1f6-11e7-b81f-0a7176ae86de	Test
106	1219	c7b05de9-f1f6-11e7-b81f-0a7176ae86de	CodedAns
107	847	c7cbc684-f1f6-11e7-b81f-0a7176ae86de	Test
108	848	c7cbf949-f1f6-11e7-b81f-0a7176ae86de	Test
109	1280	c7b0beeb-f1f6-11e7-b81f-0a7176ae86de	CodedAns
110	1281	c7b0f19d-f1f6-11e7-b81f-0a7176ae86de	CodedAns
111	1282	c7b19b05-f1f6-11e7-b81f-0a7176ae86de	CodedAns
112	1283	c7b1cfe4-f1f6-11e7-b81f-0a7176ae86de	CodedAns
113	849	c7cc3d83-f1f6-11e7-b81f-0a7176ae86de	Test
115	851	c7cca58d-f1f6-11e7-b81f-0a7176ae86de	Test
116	852	c7ccd6f6-f1f6-11e7-b81f-0a7176ae86de	Test
117	853	c7cd0c19-f1f6-11e7-b81f-0a7176ae86de	Test
118	854	c7cd4001-f1f6-11e7-b81f-0a7176ae86de	Test
119	855	c7cd72bf-f1f6-11e7-b81f-0a7176ae86de	Test
120	856	c7cda6a2-f1f6-11e7-b81f-0a7176ae86de	Test
121	857	c7cddc11-f1f6-11e7-b81f-0a7176ae86de	Test
122	858	c7ce0e7d-f1f6-11e7-b81f-0a7176ae86de	Test
99	840	c7ca5e9e-f1f6-11e7-b81f-0a7176ae86de	Test
114	850	c7cc732b-f1f6-11e7-b81f-0a7176ae86de	Test
123	859	c7ce4245-f1f6-11e7-b81f-0a7176ae86de	Test
124	860	c7ce77ce-f1f6-11e7-b81f-0a7176ae86de	Test
136	872	c7d1720c-f1f6-11e7-b81f-0a7176ae86de	Test
137	873	c7d1a60b-f1f6-11e7-b81f-0a7176ae86de	Test
138	874	c7d1d907-f1f6-11e7-b81f-0a7176ae86de	Test
139	875	c7d20b59-f1f6-11e7-b81f-0a7176ae86de	Test
140	876	c7d24038-f1f6-11e7-b81f-0a7176ae86de	Test
151	6	6f7515a4-fad1-4263-bcf2-f301d0e2950a	SampleSource
125	861	c7ceab63-f1f6-11e7-b81f-0a7176ae86de	Test
126	862	c7cee128-f1f6-11e7-b81f-0a7176ae86de	Test
130	866	c7cfe2ec-f1f6-11e7-b81f-0a7176ae86de	Test
131	867	c7d01629-f1f6-11e7-b81f-0a7176ae86de	Test
132	868	c7d0a3f0-f1f6-11e7-b81f-0a7176ae86de	Test
133	869	c7d0d7d5-f1f6-11e7-b81f-0a7176ae86de	Test
135	871	c7d14009-f1f6-11e7-b81f-0a7176ae86de	Test
127	863	c7cf1580-f1f6-11e7-b81f-0a7176ae86de	Test
128	864	c7cf4898-f1f6-11e7-b81f-0a7176ae86de	Test
129	865	c7cf8d8c-f1f6-11e7-b81f-0a7176ae86de	Test
134	870	c7d10c43-f1f6-11e7-b81f-0a7176ae86de	Test
141	877	c7d2732b-f1f6-11e7-b81f-0a7176ae86de	Test
142	85	c7b9b361-f1f6-11e7-b81f-0a7176ae86de	Panel
143	86	c7ba5536-f1f6-11e7-b81f-0a7176ae86de	Panel
144	87	c7ba8956-f1f6-11e7-b81f-0a7176ae86de	Panel
145	88	c7babe70-f1f6-11e7-b81f-0a7176ae86de	Panel
146	89	c7baf7aa-f1f6-11e7-b81f-0a7176ae86de	Panel
147	90	c7bb2bed-f1f6-11e7-b81f-0a7176ae86de	Panel
148	91	c7bb60bc-f1f6-11e7-b81f-0a7176ae86de	Panel
149	92	c7bb9527-f1f6-11e7-b81f-0a7176ae86de	Panel
150	93	c7bbc7d6-f1f6-11e7-b81f-0a7176ae86de	Panel
\.


--
-- Name: external_reference_id_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('external_reference_id_seq', 151, true);


--
-- Data for Name: failed_event_retry_log; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY failed_event_retry_log (id, feed_uri, failed_at, error_message, event_id, event_content, error_hash_code) FROM stdin;
\.


--
-- Name: failed_event_retry_log_id_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('failed_event_retry_log_id_seq', 1, false);


--
-- Data for Name: failed_events; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY failed_events (id, feed_uri, error_message, event_id, event_content, failed_at, error_hash_code, title, retries, tags) FROM stdin;
\.


--
-- Name: failed_events_id_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('failed_events_id_seq', 4, true);


--
-- Data for Name: gender; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY gender (id, gender_type, description, lastupdated, name_key) FROM stdin;
145	M	MALE	2006-10-10 13:18:40.094	gender.male
146	F	FEMALE	2006-11-21 12:04:02.372	gender.female
147	O	Other	\N	gender.other
\.


--
-- Name: gender_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('gender_seq', 147, true);


--
-- Name: hibernate_sequence; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('hibernate_sequence', 4819, true);


--
-- Data for Name: history; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY history (id, sys_user_id, reference_id, reference_table, "timestamp", activity, changes) FROM stdin;
1401	1	10	16	2018-01-05 15:53:03.744	I	\N
1402	1	10	198	2018-01-05 15:53:03.764	I	\N
1403	1	10	198	2018-01-05 15:53:03.77	I	\N
1404	1	10	198	2018-01-05 15:53:03.776	I	\N
1405	1	10	198	2018-01-05 15:53:03.784	I	\N
1406	1	10	198	2018-01-05 15:53:03.791	I	\N
1407	1	10	198	2018-01-05 15:53:03.81	I	\N
1408	1	8	15	2018-01-05 15:53:03.812	I	\N
1409	1	12	112	2018-01-05 15:53:03.843	I	\N
1421	1	11	16	2018-01-05 15:53:03.951	I	\N
1422	1	9	15	2018-01-05 15:53:03.96	I	\N
1423	1	13	112	2018-01-05 15:53:03.976	I	\N
1424	1	12	16	2018-01-05 15:53:04.078	I	\N
1425	1	10	15	2018-01-05 15:53:04.081	I	\N
1426	1	14	112	2018-01-05 15:53:04.085	I	\N
1410	1	82	36	2018-01-05 15:53:04.938	I	\N
1411	1	784	5	2018-01-05 15:53:04.947	I	\N
1412	1	83	36	2018-01-05 15:53:04.982	I	\N
1413	1	785	5	2018-01-05 15:53:04.984	I	\N
1427	1	84	36	2018-01-05 15:53:05.015	I	\N
1428	1	786	5	2018-01-05 15:53:05.019	I	\N
1429	1	85	36	2018-01-05 15:53:05.06	I	\N
1430	1	787	5	2018-01-05 15:53:05.067	I	\N
1431	1	788	5	2018-01-05 15:53:05.121	I	\N
1414	1	789	5	2018-01-05 15:53:05.208	I	\N
1415	1	790	5	2018-01-05 15:53:05.236	I	\N
1416	1	791	5	2018-01-05 15:53:05.261	I	\N
1417	1	792	5	2018-01-05 15:53:05.289	I	\N
1441	1	793	5	2018-01-05 15:53:05.324	I	\N
1442	1	794	5	2018-01-05 15:53:05.412	I	\N
1443	1	1200	9	2018-01-05 15:53:05.42	I	\N
1444	1	2587	32	2018-01-05 15:53:05.429	I	\N
1445	1	1201	9	2018-01-05 15:53:05.432	I	\N
1446	1	2588	32	2018-01-05 15:53:05.437	I	\N
1447	1	1202	9	2018-01-05 15:53:05.439	I	\N
1448	1	2589	32	2018-01-05 15:53:05.442	I	\N
1449	1	1203	9	2018-01-05 15:53:05.444	I	\N
1450	1	2590	32	2018-01-05 15:53:05.447	I	\N
1451	1	1204	9	2018-01-05 15:53:05.449	I	\N
1452	1	2591	32	2018-01-05 15:53:05.453	I	\N
1453	1	1205	9	2018-01-05 15:53:05.46	I	\N
1454	1	2592	32	2018-01-05 15:53:05.463	I	\N
1455	1	86	36	2018-01-05 15:53:05.489	I	\N
1456	1	795	5	2018-01-05 15:53:05.495	I	\N
1457	1	796	5	2018-01-05 15:53:05.523	I	\N
1458	1	797	5	2018-01-05 15:53:05.549	I	\N
1459	1	1206	9	2018-01-05 15:53:05.553	I	\N
1460	1	2593	32	2018-01-05 15:53:05.557	I	\N
1461	1	1207	9	2018-01-05 15:53:05.559	I	\N
1462	1	2594	32	2018-01-05 15:53:05.563	I	\N
1463	1	1208	9	2018-01-05 15:53:05.565	I	\N
1464	1	2595	32	2018-01-05 15:53:05.572	I	\N
1465	1	1209	9	2018-01-05 15:53:05.577	I	\N
1466	1	2596	32	2018-01-05 15:53:05.58	I	\N
1467	1	798	5	2018-01-05 15:53:05.605	I	\N
1468	1	1210	9	2018-01-05 15:53:05.608	I	\N
1469	1	2597	32	2018-01-05 15:53:05.61	I	\N
1470	1	1211	9	2018-01-05 15:53:05.612	I	\N
1471	1	2598	32	2018-01-05 15:53:05.615	I	\N
1418	1	799	5	2018-01-05 15:53:05.684	I	\N
1419	1	1220	9	2018-01-05 15:53:05.689	I	\N
1420	1	2599	32	2018-01-05 15:53:05.695	I	\N
1481	1	1221	9	2018-01-05 15:53:05.697	I	\N
1482	1	2600	32	2018-01-05 15:53:05.704	I	\N
1483	1	800	5	2018-01-05 15:53:05.729	I	\N
1484	1	1222	9	2018-01-05 15:53:05.733	I	\N
1485	1	2601	32	2018-01-05 15:53:05.735	I	\N
1486	1	1223	9	2018-01-05 15:53:05.737	I	\N
1487	1	2602	32	2018-01-05 15:53:05.74	I	\N
1501	1	87	36	2018-01-05 15:53:05.779	I	\N
1502	1	801	5	2018-01-05 15:53:05.783	I	\N
1503	1	802	5	2018-01-05 15:53:05.818	I	\N
1504	1	88	36	2018-01-05 15:53:05.849	I	\N
1505	1	803	5	2018-01-05 15:53:05.852	I	\N
1506	1	89	36	2018-01-05 15:53:05.918	I	\N
1507	1	804	5	2018-01-05 15:53:05.92	I	\N
1432	1	90	36	2018-01-05 15:53:05.946	I	\N
1433	1	805	5	2018-01-05 15:53:05.949	I	\N
1434	1	806	5	2018-01-05 15:53:05.979	I	\N
1435	1	1240	9	2018-01-05 15:53:05.984	I	\N
1436	1	2603	32	2018-01-05 15:53:05.988	I	\N
1437	1	1241	9	2018-01-05 15:53:05.99	I	\N
1438	1	2604	32	2018-01-05 15:53:05.993	I	\N
1439	1	1242	9	2018-01-05 15:53:05.995	I	\N
1440	1	2605	32	2018-01-05 15:53:05.997	I	\N
1521	1	1243	9	2018-01-05 15:53:06	I	\N
1522	1	2606	32	2018-01-05 15:53:06.008	I	\N
1523	1	1244	9	2018-01-05 15:53:06.018	I	\N
1524	1	2607	32	2018-01-05 15:53:06.021	I	\N
1525	1	807	5	2018-01-05 15:53:06.046	I	\N
1526	1	1245	9	2018-01-05 15:53:06.049	I	\N
1527	1	2608	32	2018-01-05 15:53:06.052	I	\N
1528	1	1246	9	2018-01-05 15:53:06.056	I	\N
1529	1	2609	32	2018-01-05 15:53:06.059	I	\N
1530	1	1247	9	2018-01-05 15:53:06.06	I	\N
1531	1	2610	32	2018-01-05 15:53:06.063	I	\N
1472	1	808	5	2018-01-05 15:53:06.089	I	\N
1473	1	2611	32	2018-01-05 15:53:06.096	I	\N
1474	1	809	5	2018-01-05 15:53:06.153	I	\N
1475	1	1212	9	2018-01-05 15:53:06.157	I	\N
1476	1	2612	32	2018-01-05 15:53:06.16	I	\N
1477	1	1213	9	2018-01-05 15:53:06.162	I	\N
1478	1	2613	32	2018-01-05 15:53:06.164	I	\N
1479	1	1214	9	2018-01-05 15:53:06.166	I	\N
1480	1	2614	32	2018-01-05 15:53:06.17	I	\N
1541	1	91	36	2018-01-05 15:53:06.212	I	\N
1542	1	810	5	2018-01-05 15:53:06.215	I	\N
1532	1	811	5	2018-01-05 15:53:06.246	I	\N
1543	1	812	5	2018-01-05 15:53:06.27	I	\N
1533	1	813	5	2018-01-05 15:53:06.292	I	\N
1534	1	814	5	2018-01-05 15:53:06.363	I	\N
1535	1	2615	32	2018-01-05 15:53:06.37	I	\N
1536	1	2616	32	2018-01-05 15:53:06.374	I	\N
1537	1	815	5	2018-01-05 15:53:06.398	I	\N
1538	1	1248	9	2018-01-05 15:53:06.405	I	\N
1539	1	2617	32	2018-01-05 15:53:06.414	I	\N
1540	1	1249	9	2018-01-05 15:53:06.416	I	\N
1561	1	2618	32	2018-01-05 15:53:06.418	I	\N
1544	1	816	5	2018-01-05 15:53:06.446	I	\N
1545	1	2619	32	2018-01-05 15:53:06.458	I	\N
1546	1	2620	32	2018-01-05 15:53:06.461	I	\N
1547	1	817	5	2018-01-05 15:53:06.491	I	\N
1548	1	2621	32	2018-01-05 15:53:06.497	I	\N
1549	1	2622	32	2018-01-05 15:53:06.502	I	\N
1550	1	818	5	2018-01-05 15:53:06.551	I	\N
1551	1	1215	9	2018-01-05 15:53:06.558	I	\N
1552	1	2623	32	2018-01-05 15:53:06.563	I	\N
1553	1	1216	9	2018-01-05 15:53:06.565	I	\N
1554	1	2624	32	2018-01-05 15:53:06.57	I	\N
1555	1	819	5	2018-01-05 15:53:06.672	I	\N
1556	1	1217	9	2018-01-05 15:53:06.675	I	\N
1557	1	2625	32	2018-01-05 15:53:06.678	I	\N
1558	1	1218	9	2018-01-05 15:53:06.679	I	\N
1559	1	2626	32	2018-01-05 15:53:06.681	I	\N
1560	1	821	5	2018-01-05 15:53:06.768	I	\N
1601	1	825	5	2018-01-05 15:53:06.942	I	\N
1602	1	2639	32	2018-01-05 15:53:06.949	I	\N
1603	1	2640	32	2018-01-05 15:53:06.953	I	\N
1604	1	2641	32	2018-01-05 15:53:06.961	I	\N
1605	1	2642	32	2018-01-05 15:53:06.972	I	\N
1606	1	827	5	2018-01-05 15:53:07.049	I	\N
1607	1	2645	32	2018-01-05 15:53:07.057	I	\N
1608	1	2646	32	2018-01-05 15:53:07.061	I	\N
1609	1	830	5	2018-01-05 15:53:07.194	I	\N
1610	1	2656	32	2018-01-05 15:53:07.199	I	\N
1611	1	2657	32	2018-01-05 15:53:07.202	I	\N
1612	1	2658	32	2018-01-05 15:53:07.204	I	\N
1613	1	2659	32	2018-01-05 15:53:07.207	I	\N
1614	1	2660	32	2018-01-05 15:53:07.21	I	\N
1615	1	831	5	2018-01-05 15:53:07.231	I	\N
1616	1	2661	32	2018-01-05 15:53:07.236	I	\N
1617	1	2662	32	2018-01-05 15:53:07.239	I	\N
1618	1	92	36	2018-01-05 15:53:07.261	I	\N
1619	1	832	5	2018-01-05 15:53:07.263	I	\N
1620	1	835	5	2018-01-05 15:53:07.364	I	\N
1641	1	2663	32	2018-01-05 15:53:07.374	I	\N
1642	1	2664	32	2018-01-05 15:53:07.377	I	\N
1643	1	836	5	2018-01-05 15:53:07.398	I	\N
1644	1	2665	32	2018-01-05 15:53:07.404	I	\N
1645	1	2666	32	2018-01-05 15:53:07.407	I	\N
1646	1	837	5	2018-01-05 15:53:07.429	I	\N
1647	1	2667	32	2018-01-05 15:53:07.434	I	\N
1648	1	2668	32	2018-01-05 15:53:07.437	I	\N
1649	1	838	5	2018-01-05 15:53:07.458	I	\N
1650	1	2669	32	2018-01-05 15:53:07.462	I	\N
1651	1	2670	32	2018-01-05 15:53:07.466	I	\N
1652	1	839	5	2018-01-05 15:53:07.545	I	\N
1653	1	2671	32	2018-01-05 15:53:07.553	I	\N
1654	1	2672	32	2018-01-05 15:53:07.556	I	\N
1655	1	841	5	2018-01-05 15:53:07.613	I	\N
1656	1	842	5	2018-01-05 15:53:07.638	I	\N
1657	1	2673	32	2018-01-05 15:53:07.642	I	\N
1658	1	2674	32	2018-01-05 15:53:07.651	I	\N
1659	1	843	5	2018-01-05 15:53:07.672	I	\N
1660	1	844	5	2018-01-05 15:53:07.746	I	\N
1661	1	845	5	2018-01-05 15:53:07.773	I	\N
1662	1	846	5	2018-01-05 15:53:07.801	I	\N
1663	1	2675	32	2018-01-05 15:53:07.808	I	\N
1664	1	1219	9	2018-01-05 15:53:07.81	I	\N
1665	1	2676	32	2018-01-05 15:53:07.811	I	\N
1666	1	2677	32	2018-01-05 15:53:07.814	I	\N
1667	1	2678	32	2018-01-05 15:53:07.818	I	\N
1668	1	2679	32	2018-01-05 15:53:07.821	I	\N
1669	1	847	5	2018-01-05 15:53:07.859	I	\N
1670	1	2680	32	2018-01-05 15:53:07.864	I	\N
1671	1	2681	32	2018-01-05 15:53:07.867	I	\N
1672	1	2682	32	2018-01-05 15:53:07.876	I	\N
1673	1	2683	32	2018-01-05 15:53:07.879	I	\N
1674	1	2684	32	2018-01-05 15:53:07.882	I	\N
1675	1	848	5	2018-01-05 15:53:07.912	I	\N
1676	1	1280	9	2018-01-05 15:53:07.914	I	\N
1677	1	2685	32	2018-01-05 15:53:07.919	I	\N
1678	1	1281	9	2018-01-05 15:53:07.921	I	\N
1679	1	2686	32	2018-01-05 15:53:07.928	I	\N
1680	1	1282	9	2018-01-05 15:53:07.93	I	\N
1681	1	2687	32	2018-01-05 15:53:07.932	I	\N
1682	1	1283	9	2018-01-05 15:53:07.933	I	\N
1683	1	2688	32	2018-01-05 15:53:07.935	I	\N
1684	1	849	5	2018-01-05 15:53:08.021	I	\N
1685	1	2689	32	2018-01-05 15:53:08.026	I	\N
1686	1	2690	32	2018-01-05 15:53:08.029	I	\N
1687	1	851	5	2018-01-05 15:53:08.122	I	\N
1688	1	2696	32	2018-01-05 15:53:08.126	I	\N
1689	1	2697	32	2018-01-05 15:53:08.129	I	\N
1690	1	2698	32	2018-01-05 15:53:08.132	I	\N
1691	1	2699	32	2018-01-05 15:53:08.135	I	\N
1692	1	852	5	2018-01-05 15:53:08.161	I	\N
1693	1	2700	32	2018-01-05 15:53:08.168	I	\N
1694	1	2701	32	2018-01-05 15:53:08.171	I	\N
1695	1	853	5	2018-01-05 15:53:08.212	I	\N
1696	1	2702	32	2018-01-05 15:53:08.217	I	\N
1697	1	2703	32	2018-01-05 15:53:08.222	I	\N
1698	1	2704	32	2018-01-05 15:53:08.226	I	\N
1699	1	2705	32	2018-01-05 15:53:08.234	I	\N
1700	1	2706	32	2018-01-05 15:53:08.237	I	\N
1701	1	854	5	2018-01-05 15:53:08.297	I	\N
1702	1	2707	32	2018-01-05 15:53:08.301	I	\N
1703	1	2708	32	2018-01-05 15:53:08.304	I	\N
1704	1	2709	32	2018-01-05 15:53:08.307	I	\N
1705	1	2710	32	2018-01-05 15:53:08.31	I	\N
1706	1	855	5	2018-01-05 15:53:08.331	I	\N
1707	1	2711	32	2018-01-05 15:53:08.336	I	\N
1708	1	2712	32	2018-01-05 15:53:08.339	I	\N
1709	1	856	5	2018-01-05 15:53:08.361	I	\N
1710	1	2713	32	2018-01-05 15:53:08.366	I	\N
1711	1	2714	32	2018-01-05 15:53:08.369	I	\N
1712	1	2715	32	2018-01-05 15:53:08.372	I	\N
1713	1	2716	32	2018-01-05 15:53:08.375	I	\N
1714	1	2717	32	2018-01-05 15:53:08.377	I	\N
1715	1	857	5	2018-01-05 15:53:08.399	I	\N
1716	1	2718	32	2018-01-05 15:53:08.403	I	\N
1717	1	2719	32	2018-01-05 15:53:08.406	I	\N
1718	1	2720	32	2018-01-05 15:53:08.409	I	\N
1719	1	2721	32	2018-01-05 15:53:08.412	I	\N
1720	1	858	5	2018-01-05 15:53:08.432	I	\N
1721	1	2722	32	2018-01-05 15:53:08.436	I	\N
1722	1	2723	32	2018-01-05 15:53:08.439	I	\N
1508	1	820	5	2018-01-05 15:53:06.71	I	\N
1509	1	1260	9	2018-01-05 15:53:06.716	I	\N
1510	1	2627	32	2018-01-05 15:53:06.723	I	\N
1511	1	1261	9	2018-01-05 15:53:06.727	I	\N
1512	1	2628	32	2018-01-05 15:53:06.732	I	\N
1513	1	1262	9	2018-01-05 15:53:06.734	I	\N
1514	1	2629	32	2018-01-05 15:53:06.736	I	\N
1515	1	1263	9	2018-01-05 15:53:06.738	I	\N
1516	1	2630	32	2018-01-05 15:53:06.74	I	\N
1517	1	822	5	2018-01-05 15:53:06.79	I	\N
1518	1	2631	32	2018-01-05 15:53:06.797	I	\N
1519	1	2632	32	2018-01-05 15:53:06.8	I	\N
1520	1	823	5	2018-01-05 15:53:06.821	I	\N
1581	1	2633	32	2018-01-05 15:53:06.827	I	\N
1582	1	2634	32	2018-01-05 15:53:06.831	I	\N
1583	1	824	5	2018-01-05 15:53:06.893	I	\N
1584	1	2635	32	2018-01-05 15:53:06.898	I	\N
1585	1	2636	32	2018-01-05 15:53:06.902	I	\N
1586	1	2637	32	2018-01-05 15:53:06.905	I	\N
1587	1	2638	32	2018-01-05 15:53:06.908	I	\N
1588	1	826	5	2018-01-05 15:53:07.003	I	\N
1589	1	2643	32	2018-01-05 15:53:07.008	I	\N
1590	1	2644	32	2018-01-05 15:53:07.022	I	\N
1591	1	828	5	2018-01-05 15:53:07.084	I	\N
1592	1	2647	32	2018-01-05 15:53:07.088	I	\N
1593	1	2648	32	2018-01-05 15:53:07.092	I	\N
1594	1	2649	32	2018-01-05 15:53:07.094	I	\N
1595	1	2650	32	2018-01-05 15:53:07.097	I	\N
1596	1	829	5	2018-01-05 15:53:07.154	I	\N
1597	1	1264	9	2018-01-05 15:53:07.157	I	\N
1598	1	2651	32	2018-01-05 15:53:07.159	I	\N
1599	1	1265	9	2018-01-05 15:53:07.161	I	\N
1600	1	2652	32	2018-01-05 15:53:07.162	I	\N
1621	1	1266	9	2018-01-05 15:53:07.164	I	\N
1622	1	2653	32	2018-01-05 15:53:07.166	I	\N
1623	1	1267	9	2018-01-05 15:53:07.167	I	\N
1624	1	2654	32	2018-01-05 15:53:07.169	I	\N
1625	1	1268	9	2018-01-05 15:53:07.17	I	\N
1626	1	2655	32	2018-01-05 15:53:07.172	I	\N
1627	1	833	5	2018-01-05 15:53:07.285	I	\N
1628	1	834	5	2018-01-05 15:53:07.343	I	\N
1629	1	93	36	2018-01-05 15:53:07.584	I	\N
1630	1	840	5	2018-01-05 15:53:07.586	I	\N
1631	1	850	5	2018-01-05 15:53:08.069	I	\N
1632	1	2691	32	2018-01-05 15:53:08.08	I	\N
1633	1	2692	32	2018-01-05 15:53:08.083	I	\N
1634	1	2693	32	2018-01-05 15:53:08.086	I	\N
1635	1	2694	32	2018-01-05 15:53:08.094	I	\N
1636	1	2695	32	2018-01-05 15:53:08.097	I	\N
1637	1	859	5	2018-01-05 15:53:08.495	I	\N
1638	1	2724	32	2018-01-05 15:53:08.499	I	\N
1639	1	2725	32	2018-01-05 15:53:08.503	I	\N
1640	1	2726	32	2018-01-05 15:53:08.506	I	\N
1741	1	2727	32	2018-01-05 15:53:08.509	I	\N
1742	1	2728	32	2018-01-05 15:53:08.512	I	\N
1743	1	860	5	2018-01-05 15:53:08.54	I	\N
1744	1	2729	32	2018-01-05 15:53:08.545	I	\N
1745	1	2730	32	2018-01-05 15:53:08.552	I	\N
1746	1	2731	32	2018-01-05 15:53:08.557	I	\N
1747	1	2732	32	2018-01-05 15:53:08.562	I	\N
1748	1	872	5	2018-01-05 15:53:09.206	I	\N
1749	1	873	5	2018-01-05 15:53:09.235	I	\N
1750	1	874	5	2018-01-05 15:53:09.329	I	\N
1751	1	875	5	2018-01-05 15:53:09.355	I	\N
1752	1	94	36	2018-01-05 15:53:09.404	I	\N
1753	1	876	5	2018-01-05 15:53:09.407	I	\N
1754	1	176	29	2018-01-05 15:53:13.935	I	\N
1755	1	177	29	2018-01-05 15:53:14.073	I	\N
1756	1	27	1	2018-01-05 15:53:15.133	I	\N
1757	1	44	23	2018-01-05 15:53:15.14	I	\N
1758	1	469	4	2018-01-05 15:53:15.15	I	\N
1759	1	470	4	2018-01-05 15:53:15.156	I	\N
1760	1	471	4	2018-01-05 15:53:15.182	I	\N
2381	1	472	4	2018-01-05 15:53:15.185	I	\N
2382	1	473	4	2018-01-05 15:53:15.187	I	\N
2383	1	474	4	2018-01-05 15:53:15.19	I	\N
2384	1	475	4	2018-01-05 15:53:15.192	I	\N
2385	1	476	4	2018-01-05 15:53:15.202	I	\N
2386	1	477	4	2018-01-05 15:53:15.212	I	\N
2387	1	478	4	2018-01-05 15:53:15.216	I	\N
2388	1	27	45	2018-01-05 15:53:15.219	I	\N
2389	1	28	1	2018-01-05 15:53:15.299	I	\N
2390	1	45	23	2018-01-05 15:53:15.303	I	\N
2391	1	479	4	2018-01-05 15:53:15.305	I	\N
2392	1	480	4	2018-01-05 15:53:15.307	I	\N
2393	1	481	4	2018-01-05 15:53:15.309	I	\N
2394	1	482	4	2018-01-05 15:53:15.312	I	\N
2395	1	483	4	2018-01-05 15:53:15.316	I	\N
2396	1	484	4	2018-01-05 15:53:15.321	I	\N
2397	1	485	4	2018-01-05 15:53:15.331	I	\N
2398	1	486	4	2018-01-05 15:53:15.333	I	\N
2399	1	487	4	2018-01-05 15:53:15.335	I	\N
2400	1	488	4	2018-01-05 15:53:15.34	I	\N
2401	1	46	23	2018-01-05 15:53:15.342	I	\N
2402	1	489	4	2018-01-05 15:53:15.345	I	\N
2403	1	47	23	2018-01-05 15:53:15.348	I	\N
2404	1	490	4	2018-01-05 15:53:15.355	I	\N
2405	1	48	23	2018-01-05 15:53:15.356	I	\N
2406	1	491	4	2018-01-05 15:53:15.359	I	\N
2407	1	492	4	2018-01-05 15:53:15.361	I	\N
2408	1	493	4	2018-01-05 15:53:15.363	I	\N
2409	1	28	45	2018-01-05 15:53:15.366	I	\N
2410	1	29	1	2018-01-05 15:53:15.411	I	\N
2411	1	49	23	2018-01-05 15:53:15.412	I	\N
2412	1	494	4	2018-01-05 15:53:15.414	I	\N
2413	1	495	4	2018-01-05 15:53:15.416	I	\N
2414	1	496	4	2018-01-05 15:53:15.418	I	\N
2415	1	497	4	2018-01-05 15:53:15.421	I	\N
2416	1	498	4	2018-01-05 15:53:15.423	I	\N
2417	1	499	4	2018-01-05 15:53:15.425	I	\N
2418	1	500	4	2018-01-05 15:53:15.431	I	\N
2419	1	501	4	2018-01-05 15:53:15.433	I	\N
2420	1	502	4	2018-01-05 15:53:15.435	I	\N
2421	1	503	4	2018-01-05 15:53:15.437	I	\N
2422	1	504	4	2018-01-05 15:53:15.439	I	\N
2423	1	505	4	2018-01-05 15:53:15.441	I	\N
2424	1	29	45	2018-01-05 15:53:15.442	I	\N
1488	1	861	5	2018-01-05 15:53:08.602	I	\N
1489	1	2733	32	2018-01-05 15:53:08.612	I	\N
1490	1	2734	32	2018-01-05 15:53:08.616	I	\N
1491	1	862	5	2018-01-05 15:53:08.65	I	\N
1492	1	2735	32	2018-01-05 15:53:08.66	I	\N
1493	1	2736	32	2018-01-05 15:53:08.667	I	\N
1494	1	2737	32	2018-01-05 15:53:08.671	I	\N
1495	1	2738	32	2018-01-05 15:53:08.677	I	\N
1496	1	2739	32	2018-01-05 15:53:08.681	I	\N
1497	1	866	5	2018-01-05 15:53:08.887	I	\N
1498	1	2751	32	2018-01-05 15:53:08.892	I	\N
1499	1	2752	32	2018-01-05 15:53:08.895	I	\N
1500	1	2753	32	2018-01-05 15:53:08.898	I	\N
1761	1	2754	32	2018-01-05 15:53:08.901	I	\N
1762	1	867	5	2018-01-05 15:53:08.926	I	\N
1763	1	2755	32	2018-01-05 15:53:08.941	I	\N
1764	1	2756	32	2018-01-05 15:53:08.945	I	\N
1765	1	868	5	2018-01-05 15:53:08.976	I	\N
1766	1	2757	32	2018-01-05 15:53:08.983	I	\N
1767	1	2758	32	2018-01-05 15:53:08.991	I	\N
1768	1	2759	32	2018-01-05 15:53:08.994	I	\N
1769	1	2760	32	2018-01-05 15:53:08.997	I	\N
1770	1	869	5	2018-01-05 15:53:09.093	I	\N
1771	1	2761	32	2018-01-05 15:53:09.097	I	\N
1772	1	2762	32	2018-01-05 15:53:09.104	I	\N
1773	1	871	5	2018-01-05 15:53:09.173	I	\N
1774	1	2765	32	2018-01-05 15:53:09.177	I	\N
1775	1	2766	32	2018-01-05 15:53:09.18	I	\N
1776	1	82	34	2018-01-05 15:53:12.508	I	\N
1777	1	1220	211	2018-01-05 15:53:12.526	I	\N
1778	1	1221	211	2018-01-05 15:53:12.529	I	\N
1779	1	1222	211	2018-01-05 15:53:12.532	I	\N
1780	1	1223	211	2018-01-05 15:53:12.535	I	\N
1961	1	1224	211	2018-01-05 15:53:12.538	I	\N
1962	1	1225	211	2018-01-05 15:53:12.541	I	\N
1963	1	1226	211	2018-01-05 15:53:12.543	I	\N
1964	1	1227	211	2018-01-05 15:53:12.546	I	\N
1965	1	1228	211	2018-01-05 15:53:12.548	I	\N
1966	1	1229	211	2018-01-05 15:53:12.551	I	\N
1967	1	1230	211	2018-01-05 15:53:12.553	I	\N
1968	1	1231	211	2018-01-05 15:53:12.555	I	\N
1969	1	1232	211	2018-01-05 15:53:12.558	I	\N
1970	1	1233	211	2018-01-05 15:53:12.56	I	\N
1971	1	1234	211	2018-01-05 15:53:12.563	I	\N
1972	1	1235	211	2018-01-05 15:53:12.566	I	\N
1973	1	1236	211	2018-01-05 15:53:12.569	I	\N
1974	1	1237	211	2018-01-05 15:53:12.571	I	\N
1975	1	1238	211	2018-01-05 15:53:12.574	I	\N
1976	1	1239	211	2018-01-05 15:53:12.577	I	\N
1977	1	1240	211	2018-01-05 15:53:12.579	I	\N
1978	1	1241	211	2018-01-05 15:53:12.582	I	\N
1979	1	1242	211	2018-01-05 15:53:12.585	I	\N
1980	1	1243	211	2018-01-05 15:53:12.588	I	\N
1981	1	1244	211	2018-01-05 15:53:12.591	I	\N
1982	1	1245	211	2018-01-05 15:53:12.594	I	\N
1983	1	1246	211	2018-01-05 15:53:12.597	I	\N
1984	1	1247	211	2018-01-05 15:53:12.6	I	\N
1985	1	1248	211	2018-01-05 15:53:12.603	I	\N
1986	1	1249	211	2018-01-05 15:53:12.606	I	\N
1987	1	1250	211	2018-01-05 15:53:12.609	I	\N
1988	1	1251	211	2018-01-05 15:53:12.612	I	\N
1989	1	1252	211	2018-01-05 15:53:12.615	I	\N
1990	1	1253	211	2018-01-05 15:53:12.618	I	\N
1991	1	1254	211	2018-01-05 15:53:12.621	I	\N
1992	1	1255	211	2018-01-05 15:53:12.625	I	\N
1993	1	1256	211	2018-01-05 15:53:12.629	I	\N
1994	1	1257	211	2018-01-05 15:53:12.632	I	\N
1995	1	1258	211	2018-01-05 15:53:12.636	I	\N
1996	1	1259	211	2018-01-05 15:53:12.639	I	\N
1997	1	1260	211	2018-01-05 15:53:12.643	I	\N
1998	1	1261	211	2018-01-05 15:53:12.646	I	\N
1999	1	1262	211	2018-01-05 15:53:12.655	I	\N
2000	1	1263	211	2018-01-05 15:53:12.659	I	\N
2001	1	1264	211	2018-01-05 15:53:12.663	I	\N
2002	1	107	212	2018-01-05 15:53:12.675	I	\N
2003	1	108	212	2018-01-05 15:53:12.684	I	\N
2004	1	109	212	2018-01-05 15:53:12.696	I	\N
2005	1	110	212	2018-01-05 15:53:12.701	I	\N
2006	1	111	212	2018-01-05 15:53:12.705	I	\N
2007	1	112	212	2018-01-05 15:53:12.712	I	\N
2008	1	83	34	2018-01-05 15:53:12.784	I	\N
2009	1	1265	211	2018-01-05 15:53:12.79	I	\N
2010	1	1266	211	2018-01-05 15:53:12.792	I	\N
2011	1	1267	211	2018-01-05 15:53:12.794	I	\N
2012	1	113	212	2018-01-05 15:53:12.797	I	\N
2013	1	196	29	2018-01-05 15:53:14.107	I	\N
2014	1	197	29	2018-01-05 15:53:14.16	I	\N
2015	1	198	29	2018-01-05 15:53:14.236	I	\N
2016	1	199	29	2018-01-05 15:53:14.263	I	\N
2017	1	200	29	2018-01-05 15:53:14.298	I	\N
2018	1	1314	211	2018-01-05 15:53:14.352	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3738343c2f7465737449643e0a
2019	1	1315	211	2018-01-05 15:53:14.353	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3738353c2f7465737449643e0a
2020	1	1316	211	2018-01-05 15:53:14.354	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3834303c2f7465737449643e0a
2281	1	1317	211	2018-01-05 15:53:14.355	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3738363c2f7465737449643e0a
2282	1	1318	211	2018-01-05 15:53:14.355	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3738373c2f7465737449643e0a
2283	1	1319	211	2018-01-05 15:53:14.356	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3738383c2f7465737449643e0a
2284	1	1320	211	2018-01-05 15:53:14.357	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3738393c2f7465737449643e0a
2285	1	1321	211	2018-01-05 15:53:14.358	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739303c2f7465737449643e0a
2286	1	1322	211	2018-01-05 15:53:14.359	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739313c2f7465737449643e0a
2287	1	1323	211	2018-01-05 15:53:14.36	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739323c2f7465737449643e0a
2288	1	1324	211	2018-01-05 15:53:14.361	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739333c2f7465737449643e0a
2289	1	1325	211	2018-01-05 15:53:14.362	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739343c2f7465737449643e0a
2290	1	1326	211	2018-01-05 15:53:14.363	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739353c2f7465737449643e0a
2291	1	1327	211	2018-01-05 15:53:14.364	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739363c2f7465737449643e0a
2292	1	1328	211	2018-01-05 15:53:14.365	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739373c2f7465737449643e0a
2293	1	1329	211	2018-01-05 15:53:14.366	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739383c2f7465737449643e0a
1562	1	863	5	2018-01-05 15:53:08.715	I	\N
1563	1	2740	32	2018-01-05 15:53:08.724	I	\N
1564	1	2741	32	2018-01-05 15:53:08.729	I	\N
1565	1	2742	32	2018-01-05 15:53:08.733	I	\N
1566	1	2743	32	2018-01-05 15:53:08.737	I	\N
1567	1	864	5	2018-01-05 15:53:08.809	I	\N
1568	1	2744	32	2018-01-05 15:53:08.816	I	\N
1569	1	2745	32	2018-01-05 15:53:08.823	I	\N
1570	1	865	5	2018-01-05 15:53:08.845	I	\N
1571	1	2746	32	2018-01-05 15:53:08.85	I	\N
1572	1	2747	32	2018-01-05 15:53:08.853	I	\N
1573	1	2748	32	2018-01-05 15:53:08.856	I	\N
1574	1	2749	32	2018-01-05 15:53:08.859	I	\N
1575	1	2750	32	2018-01-05 15:53:08.862	I	\N
1576	1	870	5	2018-01-05 15:53:09.134	I	\N
1577	1	2763	32	2018-01-05 15:53:09.139	I	\N
1578	1	2764	32	2018-01-05 15:53:09.143	I	\N
1579	1	95	36	2018-01-05 15:53:09.435	I	\N
1580	1	877	5	2018-01-05 15:53:09.443	I	\N
1781	1	85	13	2018-01-05 15:53:09.47	I	\N
1782	1	518	14	2018-01-05 15:53:09.496	I	\N
1783	1	519	14	2018-01-05 15:53:09.503	I	\N
1784	1	520	14	2018-01-05 15:53:09.506	I	\N
1785	1	521	14	2018-01-05 15:53:09.509	I	\N
1786	1	522	14	2018-01-05 15:53:09.511	I	\N
1787	1	523	14	2018-01-05 15:53:09.513	I	\N
1788	1	524	14	2018-01-05 15:53:09.52	I	\N
1789	1	525	14	2018-01-05 15:53:09.522	I	\N
1790	1	526	14	2018-01-05 15:53:09.526	I	\N
1791	1	527	14	2018-01-05 15:53:09.534	I	\N
1792	1	86	13	2018-01-05 15:53:09.6	I	\N
1793	1	528	14	2018-01-05 15:53:09.604	I	\N
1794	1	529	14	2018-01-05 15:53:09.606	I	\N
1795	1	530	14	2018-01-05 15:53:09.607	I	\N
1796	1	87	13	2018-01-05 15:53:09.625	I	\N
1797	1	531	14	2018-01-05 15:53:09.628	I	\N
1798	1	532	14	2018-01-05 15:53:09.63	I	\N
1799	1	88	13	2018-01-05 15:53:09.651	I	\N
1800	1	533	14	2018-01-05 15:53:09.657	I	\N
1801	1	534	14	2018-01-05 15:53:09.66	I	\N
1802	1	535	14	2018-01-05 15:53:09.662	I	\N
1803	1	89	13	2018-01-05 15:53:09.684	I	\N
1804	1	536	14	2018-01-05 15:53:09.69	I	\N
1805	1	537	14	2018-01-05 15:53:09.692	I	\N
1806	1	538	14	2018-01-05 15:53:09.693	I	\N
1807	1	539	14	2018-01-05 15:53:09.695	I	\N
1808	1	90	13	2018-01-05 15:53:09.714	I	\N
1809	1	540	14	2018-01-05 15:53:09.717	I	\N
1810	1	541	14	2018-01-05 15:53:09.718	I	\N
1811	1	542	14	2018-01-05 15:53:09.72	I	\N
1812	1	91	13	2018-01-05 15:53:09.79	I	\N
1813	1	543	14	2018-01-05 15:53:09.794	I	\N
1814	1	544	14	2018-01-05 15:53:09.797	I	\N
1815	1	545	14	2018-01-05 15:53:09.799	I	\N
1816	1	546	14	2018-01-05 15:53:09.8	I	\N
1817	1	547	14	2018-01-05 15:53:09.802	I	\N
1818	1	548	14	2018-01-05 15:53:09.804	I	\N
1819	1	549	14	2018-01-05 15:53:09.806	I	\N
1820	1	550	14	2018-01-05 15:53:09.809	I	\N
1821	1	551	14	2018-01-05 15:53:09.817	I	\N
1822	1	552	14	2018-01-05 15:53:09.821	I	\N
1823	1	553	14	2018-01-05 15:53:09.822	I	\N
1824	1	554	14	2018-01-05 15:53:09.824	I	\N
1825	1	555	14	2018-01-05 15:53:09.826	I	\N
1826	1	556	14	2018-01-05 15:53:09.828	I	\N
1827	1	92	13	2018-01-05 15:53:09.85	I	\N
1828	1	557	14	2018-01-05 15:53:09.854	I	\N
1829	1	558	14	2018-01-05 15:53:09.855	I	\N
1830	1	559	14	2018-01-05 15:53:09.858	I	\N
1831	1	560	14	2018-01-05 15:53:09.86	I	\N
1832	1	561	14	2018-01-05 15:53:09.862	I	\N
1833	1	562	14	2018-01-05 15:53:09.863	I	\N
1834	1	563	14	2018-01-05 15:53:09.865	I	\N
1835	1	564	14	2018-01-05 15:53:09.867	I	\N
1836	1	565	14	2018-01-05 15:53:09.868	I	\N
1837	1	566	14	2018-01-05 15:53:09.871	I	\N
1838	1	93	13	2018-01-05 15:53:09.892	I	\N
1839	1	567	14	2018-01-05 15:53:09.895	I	\N
1840	1	568	14	2018-01-05 15:53:09.897	I	\N
1841	1	569	14	2018-01-05 15:53:09.9	I	\N
1842	1	530	14	2018-01-05 15:53:11.829	D	\\x3c736f72744f726465723e333c2f736f72744f726465723e0a3c746573744e616d653e5465737420646520636f6d7061746962696c69743f3c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3630373c2f6c617374757064617465643e0a
1843	1	529	14	2018-01-05 15:53:11.831	D	\\x3c736f72744f726465723e323c2f736f72744f726465723e0a3c746573744e616d653e47726f75706167652073616e6775696e205268657375733c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3630363c2f6c617374757064617465643e0a
1844	1	528	14	2018-01-05 15:53:11.832	D	\\x3c736f72744f726465723e313c2f736f72744f726465723e0a3c746573744e616d653e47726f75706167652073616e6775696e2041424f3c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3630343c2f6c617374757064617465643e0a
1845	1	570	14	2018-01-05 15:53:11.843	I	\N
1846	1	571	14	2018-01-05 15:53:11.848	I	\N
1847	1	572	14	2018-01-05 15:53:11.853	I	\N
1848	1	556	14	2018-01-05 15:53:11.867	D	\\x3c736f72744f726465723e31343c2f736f72744f726465723e0a3c746573744e616d653e47656e65587065727420544220284c4352293c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3832383c2f6c617374757064617465643e0a
1849	1	555	14	2018-01-05 15:53:11.889	D	\\x3c736f72744f726465723e31333c2f736f72744f726465723e0a3c746573744e616d653e476c79636f7261636869653c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3832363c2f6c617374757064617465643e0a
1850	1	554	14	2018-01-05 15:53:11.893	D	\\x3c736f72744f726465723e31323c2f736f72744f726465723e0a3c746573744e616d653e4d6963726f73636f706965205442202d20526563686572636865206465204241415220284c4352293c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3832343c2f6c617374757064617465643e0a
1851	1	553	14	2018-01-05 15:53:11.897	D	\\x3c736f72744f726465723e31313c2f736f72744f726465723e0a3c746573744e616d653e28496620706f7369746966292047726f7570656d656e743c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3832323c2f6c617374757064617465643e0a
1852	1	552	14	2018-01-05 15:53:11.899	D	\\x3c736f72744f726465723e31303c2f736f72744f726465723e0a3c746573744e616d653e28496620706f73697469662920436f6c6f726174696f6e3c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3832313c2f6c617374757064617465643e0a
1853	1	551	14	2018-01-05 15:53:11.902	D	\\x3c736f72744f726465723e393c2f736f72744f726465723e0a3c746573744e616d653e28496620706f73697469662920466f726d653c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3831373c2f6c617374757064617465643e0a
1854	1	550	14	2018-01-05 15:53:11.904	D	\\x3c736f72744f726465723e383c2f736f72744f726465723e0a3c746573744e616d653e4772616d3c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3830393c2f6c617374757064617465643e0a
1855	1	549	14	2018-01-05 15:53:11.906	D	\\x3c736f72744f726465723e373c2f736f72744f726465723e0a3c746573744e616d653e50726f7465696e6f7261636869652028746573742064652050616e6479293c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3830363c2f6c617374757064617465643e0a
1856	1	548	14	2018-01-05 15:53:11.908	D	\\x3c736f72744f726465723e363c2f736f72744f726465723e0a3c746573744e616d653e456e637265206465206368696e653c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3830343c2f6c617374757064617465643e0a
1857	1	547	14	2018-01-05 15:53:11.911	D	\\x3c736f72744f726465723e353c2f736f72744f726465723e0a3c746573744e616d653e437261673c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3830323c2f6c617374757064617465643e0a
2169	1	1360	211	2018-01-05 15:53:13.511	I	\N
1858	1	546	14	2018-01-05 15:53:11.913	D	\\x3c736f72744f726465723e343c2f736f72744f726465723e0a3c746573744e616d653e464c202d204e455554253c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e383c2f6c617374757064617465643e0a
1859	1	545	14	2018-01-05 15:53:11.915	D	\\x3c736f72744f726465723e333c2f736f72744f726465723e0a3c746573744e616d653e464c202d204d5844253c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3739393c2f6c617374757064617465643e0a
1860	1	544	14	2018-01-05 15:53:11.917	D	\\x3c736f72744f726465723e323c2f736f72744f726465723e0a3c746573744e616d653e464c202d204c594d253c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3739373c2f6c617374757064617465643e0a
1861	1	543	14	2018-01-05 15:53:11.919	D	\\x3c736f72744f726465723e313c2f736f72744f726465723e0a3c746573744e616d653e4e756d65726174696f6e2047423c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3739343c2f6c617374757064617465643e0a
1862	1	573	14	2018-01-05 15:53:11.941	I	\N
1863	1	574	14	2018-01-05 15:53:11.946	I	\N
1864	1	575	14	2018-01-05 15:53:11.951	I	\N
1865	1	576	14	2018-01-05 15:53:11.956	I	\N
1866	1	577	14	2018-01-05 15:53:11.961	I	\N
1867	1	578	14	2018-01-05 15:53:11.966	I	\N
1868	1	579	14	2018-01-05 15:53:11.982	I	\N
1869	1	580	14	2018-01-05 15:53:11.993	I	\N
1870	1	581	14	2018-01-05 15:53:11.999	I	\N
1871	1	582	14	2018-01-05 15:53:12.008	I	\N
1872	1	583	14	2018-01-05 15:53:12.013	I	\N
1873	1	584	14	2018-01-05 15:53:12.018	I	\N
1874	1	585	14	2018-01-05 15:53:12.034	I	\N
1875	1	586	14	2018-01-05 15:53:12.039	I	\N
1876	1	532	14	2018-01-05 15:53:12.054	D	\\x3c736f72744f726465723e323c2f736f72744f726465723e0a3c746573744e616d653e43443420252028656e66616e7473206465202d203520616e73293c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e36333c2f6c617374757064617465643e0a
1877	1	531	14	2018-01-05 15:53:12.057	D	\\x3c736f72744f726465723e313c2f736f72744f726465723e0a3c746573744e616d653e4344343c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3632383c2f6c617374757064617465643e0a
1878	1	587	14	2018-01-05 15:53:12.065	I	\N
1879	1	588	14	2018-01-05 15:53:12.071	I	\N
1880	1	535	14	2018-01-05 15:53:12.094	D	\\x3c736f72744f726465723e333c2f736f72744f726465723e0a3c746573744e616d653e43686c6f72653c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3636323c2f6c617374757064617465643e0a
1881	1	534	14	2018-01-05 15:53:12.097	D	\\x3c736f72744f726465723e323c2f736f72744f726465723e0a3c746573744e616d653e706f7461737369756d3c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e36363c2f6c617374757064617465643e0a
1882	1	533	14	2018-01-05 15:53:12.099	D	\\x3c736f72744f726465723e313c2f736f72744f726465723e0a3c746573744e616d653e736f6469756d3c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3635373c2f6c617374757064617465643e0a
1883	1	589	14	2018-01-05 15:53:12.107	I	\N
1884	1	590	14	2018-01-05 15:53:12.113	I	\N
1885	1	591	14	2018-01-05 15:53:12.125	I	\N
1886	1	569	14	2018-01-05 15:53:12.14	D	\\x3c736f72744f726465723e333c2f736f72744f726465723e0a3c746573744e616d653e476c79633f6d69653c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e393c2f6c617374757064617465643e0a
1887	1	568	14	2018-01-05 15:53:12.143	D	\\x3c736f72744f726465723e323c2f736f72744f726465723e0a3c746573744e616d653e4750543c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3839373c2f6c617374757064617465643e0a
1888	1	567	14	2018-01-05 15:53:12.145	D	\\x3c736f72744f726465723e313c2f736f72744f726465723e0a3c746573744e616d653e4372656174696e696e653c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3839353c2f6c617374757064617465643e0a
1889	1	592	14	2018-01-05 15:53:12.153	I	\N
1890	1	593	14	2018-01-05 15:53:12.158	I	\N
1891	1	594	14	2018-01-05 15:53:12.165	I	\N
1892	1	539	14	2018-01-05 15:53:12.185	D	\\x3c736f72744f726465723e343c2f736f72744f726465723e0a3c746573744e616d653e50686f737068617461736520616c63616c696e653c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3639353c2f6c617374757064617465643e0a
1893	1	538	14	2018-01-05 15:53:12.189	D	\\x3c736f72744f726465723e333c2f736f72744f726465723e0a3c746573744e616d653e47616d6d612047543c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3639333c2f6c617374757064617465643e0a
1894	1	537	14	2018-01-05 15:53:12.191	D	\\x3c736f72744f726465723e323c2f736f72744f726465723e0a3c746573744e616d653e42696c69727562696e6520646972656374453c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3639323c2f6c617374757064617465643e0a
1895	1	536	14	2018-01-05 15:53:12.194	D	\\x3c736f72744f726465723e313c2f736f72744f726465723e0a3c746573744e616d653e42696c69727562696e6520746f74616c453c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e36393c2f6c617374757064617465643e0a
1896	1	595	14	2018-01-05 15:53:12.203	I	\N
1897	1	596	14	2018-01-05 15:53:12.209	I	\N
1898	1	597	14	2018-01-05 15:53:12.216	I	\N
1899	1	598	14	2018-01-05 15:53:12.221	I	\N
1900	1	542	14	2018-01-05 15:53:12.236	D	\\x3c736f72744f726465723e333c2f736f72744f726465723e0a3c746573744e616d653e53656c6c657320492e4f3c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e37323c2f6c617374757064617465643e0a
1901	1	541	14	2018-01-05 15:53:12.238	D	\\x3c736f72744f726465723e323c2f736f72744f726465723e0a3c746573744e616d653e53656c6c65732044697265637473202d20547970653c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3731383c2f6c617374757064617465643e0a
1902	1	540	14	2018-01-05 15:53:12.241	D	\\x3c736f72744f726465723e313c2f736f72744f726465723e0a3c746573744e616d653e53656c6c65732044697265637473202d204b4f503c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3731373c2f6c617374757064617465643e0a
1903	1	599	14	2018-01-05 15:53:12.25	I	\N
1904	1	600	14	2018-01-05 15:53:12.255	I	\N
1905	1	601	14	2018-01-05 15:53:12.261	I	\N
1906	1	566	14	2018-01-05 15:53:12.275	D	\\x3c736f72744f726465723e31303c2f736f72744f726465723e0a3c746573744e616d653e4c6575636f63797465733c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3837313c2f6c617374757064617465643e0a
1907	1	565	14	2018-01-05 15:53:12.278	D	\\x3c736f72744f726465723e393c2f736f72744f726465723e0a3c746573744e616d653e70483c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3836383c2f6c617374757064617465643e0a
1908	1	564	14	2018-01-05 15:53:12.28	D	\\x3c736f72744f726465723e383c2f736f72744f726465723e0a3c746573744e616d653e476c75636f73653c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3836373c2f6c617374757064617465643e0a
1909	1	563	14	2018-01-05 15:53:12.282	D	\\x3c736f72744f726465723e373c2f736f72744f726465723e0a3c746573744e616d653e4163696465206173636f7262697175653c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3836353c2f6c617374757064617465643e0a
1910	1	562	14	2018-01-05 15:53:12.285	D	\\x3c736f72744f726465723e363c2f736f72744f726465723e0a3c746573744e616d653e436f72707320633f746f6e69717565733c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3836333c2f6c617374757064617465643e0a
1911	1	561	14	2018-01-05 15:53:12.287	D	\\x3c736f72744f726465723e353c2f736f72744f726465723e0a3c746573744e616d653e4e697472697465733c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3836323c2f6c617374757064617465643e0a
1912	1	560	14	2018-01-05 15:53:12.29	D	\\x3c736f72744f726465723e343c2f736f72744f726465723e0a3c746573744e616d653e50726f743f696e65733c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e38363c2f6c617374757064617465643e0a
1913	1	559	14	2018-01-05 15:53:12.292	D	\\x3c736f72744f726465723e333c2f736f72744f726465723e0a3c746573744e616d653e42696c69727562696e653c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3835383c2f6c617374757064617465643e0a
1914	1	558	14	2018-01-05 15:53:12.295	D	\\x3c736f72744f726465723e323c2f736f72744f726465723e0a3c746573744e616d653e55726f62696c696e6f673f6e653c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3835353c2f6c617374757064617465643e0a
1915	1	557	14	2018-01-05 15:53:12.297	D	\\x3c736f72744f726465723e313c2f736f72744f726465723e0a3c746573744e616d653e53616e672028683f6d617475726965293c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3835343c2f6c617374757064617465643e0a
1916	1	602	14	2018-01-05 15:53:12.316	I	\N
1917	1	603	14	2018-01-05 15:53:12.321	I	\N
1918	1	604	14	2018-01-05 15:53:12.327	I	\N
1919	1	605	14	2018-01-05 15:53:12.333	I	\N
1920	1	606	14	2018-01-05 15:53:12.338	I	\N
1921	1	607	14	2018-01-05 15:53:12.344	I	\N
1922	1	608	14	2018-01-05 15:53:12.349	I	\N
1923	1	609	14	2018-01-05 15:53:12.355	I	\N
1924	1	610	14	2018-01-05 15:53:12.361	I	\N
1925	1	611	14	2018-01-05 15:53:12.367	I	\N
1926	1	527	14	2018-01-05 15:53:12.381	D	\\x3c736f72744f726465723e31303c2f736f72744f726465723e0a3c746573744e616d653e4e455554253c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3533343c2f6c617374757064617465643e0a
1927	1	526	14	2018-01-05 15:53:12.384	D	\\x3c736f72744f726465723e393c2f736f72744f726465723e0a3c746573744e616d653e4d5844252028456f73696e6f2b4d6f6e6f6379746573293c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3532363c2f6c617374757064617465643e0a
2170	1	1361	211	2018-01-05 15:53:13.514	I	\N
1928	1	525	14	2018-01-05 15:53:12.386	D	\\x3c736f72744f726465723e383c2f736f72744f726465723e0a3c746573744e616d653e4c594d253c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3532323c2f6c617374757064617465643e0a
1929	1	524	14	2018-01-05 15:53:12.389	D	\\x3c736f72744f726465723e373c2f736f72744f726465723e0a3c746573744e616d653e506c61717565747465733c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e35323c2f6c617374757064617465643e0a
1930	1	523	14	2018-01-05 15:53:12.391	D	\\x3c736f72744f726465723e363c2f736f72744f726465723e0a3c746573744e616d653e43434d483c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3531333c2f6c617374757064617465643e0a
1931	1	522	14	2018-01-05 15:53:12.394	D	\\x3c736f72744f726465723e353c2f736f72744f726465723e0a3c746573744e616d653e56474d3c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3531313c2f6c617374757064617465643e0a
1932	1	521	14	2018-01-05 15:53:12.396	D	\\x3c736f72744f726465723e343c2f736f72744f726465723e0a3c746573744e616d653e48656d61746f63726974653c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3530393c2f6c617374757064617465643e0a
1933	1	520	14	2018-01-05 15:53:12.399	D	\\x3c736f72744f726465723e333c2f736f72744f726465723e0a3c746573744e616d653e48656d6f676c6f62696e653c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3530363c2f6c617374757064617465643e0a
1934	1	519	14	2018-01-05 15:53:12.401	D	\\x3c736f72744f726465723e323c2f736f72744f726465723e0a3c746573744e616d653e476c6f62756c657320526f756765733c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3530333c2f6c617374757064617465643e0a
1935	1	518	14	2018-01-05 15:53:12.404	D	\\x3c736f72744f726465723e313c2f736f72744f726465723e0a3c746573744e616d653e476c6f62756c657320426c616e63733c2f746573744e616d653e0a3c6c617374757064617465643e323031382d30312d30352031353a35333a30392e3439363c2f6c617374757064617465643e0a
1936	1	612	14	2018-01-05 15:53:12.423	I	\N
1937	1	613	14	2018-01-05 15:53:12.429	I	\N
1938	1	614	14	2018-01-05 15:53:12.435	I	\N
1939	1	615	14	2018-01-05 15:53:12.441	I	\N
1940	1	616	14	2018-01-05 15:53:12.447	I	\N
1941	1	617	14	2018-01-05 15:53:12.452	I	\N
1942	1	618	14	2018-01-05 15:53:12.458	I	\N
1943	1	619	14	2018-01-05 15:53:12.464	I	\N
1944	1	620	14	2018-01-05 15:53:12.47	I	\N
1945	1	621	14	2018-01-05 15:53:12.476	I	\N
1946	1	84	34	2018-01-05 15:53:12.821	I	\N
1947	1	1268	211	2018-01-05 15:53:12.828	I	\N
1948	1	1269	211	2018-01-05 15:53:12.831	I	\N
1949	1	1270	211	2018-01-05 15:53:12.834	I	\N
1950	1	1271	211	2018-01-05 15:53:12.837	I	\N
1951	1	1272	211	2018-01-05 15:53:12.839	I	\N
1952	1	1273	211	2018-01-05 15:53:12.842	I	\N
1953	1	1274	211	2018-01-05 15:53:12.844	I	\N
1954	1	1275	211	2018-01-05 15:53:12.847	I	\N
1955	1	1276	211	2018-01-05 15:53:12.849	I	\N
1956	1	1277	211	2018-01-05 15:53:12.852	I	\N
1957	1	1278	211	2018-01-05 15:53:12.854	I	\N
1958	1	114	212	2018-01-05 15:53:12.859	I	\N
1959	1	85	34	2018-01-05 15:53:12.881	I	\N
1960	1	1279	211	2018-01-05 15:53:12.885	I	\N
2021	1	1280	211	2018-01-05 15:53:12.887	I	\N
2022	1	1281	211	2018-01-05 15:53:12.89	I	\N
2023	1	1282	211	2018-01-05 15:53:12.893	I	\N
2024	1	1283	211	2018-01-05 15:53:12.895	I	\N
2025	1	1284	211	2018-01-05 15:53:12.897	I	\N
2026	1	1285	211	2018-01-05 15:53:12.899	I	\N
2027	1	1286	211	2018-01-05 15:53:12.901	I	\N
2028	1	1287	211	2018-01-05 15:53:12.903	I	\N
2029	1	1288	211	2018-01-05 15:53:12.905	I	\N
2030	1	1289	211	2018-01-05 15:53:12.908	I	\N
2031	1	1290	211	2018-01-05 15:53:12.91	I	\N
2032	1	1291	211	2018-01-05 15:53:12.912	I	\N
2033	1	1292	211	2018-01-05 15:53:12.914	I	\N
2034	1	115	212	2018-01-05 15:53:12.919	I	\N
2035	1	86	34	2018-01-05 15:53:12.937	I	\N
2036	1	1293	211	2018-01-05 15:53:12.941	I	\N
2037	1	1294	211	2018-01-05 15:53:12.943	I	\N
2038	1	1295	211	2018-01-05 15:53:12.945	I	\N
2039	1	87	34	2018-01-05 15:53:12.964	I	\N
2040	1	1296	211	2018-01-05 15:53:12.968	I	\N
2041	1	1297	211	2018-01-05 15:53:12.97	I	\N
2042	1	1298	211	2018-01-05 15:53:12.972	I	\N
2043	1	88	34	2018-01-05 15:53:13.022	I	\N
2044	1	1299	211	2018-01-05 15:53:13.027	I	\N
2045	1	1300	211	2018-01-05 15:53:13.029	I	\N
2046	1	1301	211	2018-01-05 15:53:13.031	I	\N
2047	1	89	34	2018-01-05 15:53:13.054	I	\N
2048	1	1302	211	2018-01-05 15:53:13.058	I	\N
2049	1	1303	211	2018-01-05 15:53:13.06	I	\N
2050	1	1304	211	2018-01-05 15:53:13.062	I	\N
2051	1	90	34	2018-01-05 15:53:13.079	I	\N
2052	1	1305	211	2018-01-05 15:53:13.083	I	\N
2053	1	1306	211	2018-01-05 15:53:13.085	I	\N
2054	1	1307	211	2018-01-05 15:53:13.087	I	\N
2055	1	91	34	2018-01-05 15:53:13.104	I	\N
2056	1	1308	211	2018-01-05 15:53:13.108	I	\N
2057	1	1309	211	2018-01-05 15:53:13.109	I	\N
2058	1	1310	211	2018-01-05 15:53:13.111	I	\N
2059	1	92	34	2018-01-05 15:53:13.131	I	\N
2060	1	1311	211	2018-01-05 15:53:13.141	I	\N
2061	1	1312	211	2018-01-05 15:53:13.143	I	\N
2062	1	1313	211	2018-01-05 15:53:13.145	I	\N
2063	1	1220	211	2018-01-05 15:53:13.308	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3738343c2f7465737449643e0a
2064	1	1221	211	2018-01-05 15:53:13.309	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3738353c2f7465737449643e0a
2065	1	1222	211	2018-01-05 15:53:13.31	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3834303c2f7465737449643e0a
2066	1	1223	211	2018-01-05 15:53:13.311	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3738363c2f7465737449643e0a
2067	1	1224	211	2018-01-05 15:53:13.312	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3738373c2f7465737449643e0a
2068	1	1225	211	2018-01-05 15:53:13.312	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3738383c2f7465737449643e0a
2069	1	1226	211	2018-01-05 15:53:13.313	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3738393c2f7465737449643e0a
2070	1	1227	211	2018-01-05 15:53:13.314	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739303c2f7465737449643e0a
2071	1	1228	211	2018-01-05 15:53:13.315	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739313c2f7465737449643e0a
2072	1	1229	211	2018-01-05 15:53:13.316	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739323c2f7465737449643e0a
2073	1	1230	211	2018-01-05 15:53:13.317	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739333c2f7465737449643e0a
2074	1	1231	211	2018-01-05 15:53:13.317	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739343c2f7465737449643e0a
2075	1	1232	211	2018-01-05 15:53:13.318	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739353c2f7465737449643e0a
2076	1	1233	211	2018-01-05 15:53:13.319	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739363c2f7465737449643e0a
2077	1	1234	211	2018-01-05 15:53:13.32	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739373c2f7465737449643e0a
2078	1	1235	211	2018-01-05 15:53:13.321	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739383c2f7465737449643e0a
2079	1	1236	211	2018-01-05 15:53:13.322	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739393c2f7465737449643e0a
2255	1	1400	211	2018-01-05 15:53:13.853	I	\N
2080	1	1237	211	2018-01-05 15:53:13.322	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3830303c2f7465737449643e0a
2081	1	1238	211	2018-01-05 15:53:13.323	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3830313c2f7465737449643e0a
2082	1	1239	211	2018-01-05 15:53:13.324	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3830323c2f7465737449643e0a
2083	1	1240	211	2018-01-05 15:53:13.325	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3830333c2f7465737449643e0a
2084	1	1241	211	2018-01-05 15:53:13.326	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3830343c2f7465737449643e0a
2085	1	1242	211	2018-01-05 15:53:13.326	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3830353c2f7465737449643e0a
2086	1	1243	211	2018-01-05 15:53:13.327	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3830363c2f7465737449643e0a
2087	1	1244	211	2018-01-05 15:53:13.328	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833323c2f7465737449643e0a
2088	1	1245	211	2018-01-05 15:53:13.329	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833333c2f7465737449643e0a
2089	1	1246	211	2018-01-05 15:53:13.33	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833343c2f7465737449643e0a
2090	1	1247	211	2018-01-05 15:53:13.33	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833353c2f7465737449643e0a
2091	1	1248	211	2018-01-05 15:53:13.331	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837363c2f7465737449643e0a
2092	1	1249	211	2018-01-05 15:53:13.332	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837373c2f7465737449643e0a
2093	1	1250	211	2018-01-05 15:53:13.333	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833363c2f7465737449643e0a
2094	1	1251	211	2018-01-05 15:53:13.334	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833373c2f7465737449643e0a
2095	1	1252	211	2018-01-05 15:53:13.334	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837303c2f7465737449643e0a
2096	1	1253	211	2018-01-05 15:53:13.335	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837313c2f7465737449643e0a
2097	1	1254	211	2018-01-05 15:53:13.336	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833383c2f7465737449643e0a
2098	1	1255	211	2018-01-05 15:53:13.337	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833393c2f7465737449643e0a
2099	1	1256	211	2018-01-05 15:53:13.338	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3834323c2f7465737449643e0a
2100	1	1257	211	2018-01-05 15:53:13.339	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3834333c2f7465737449643e0a
2101	1	1258	211	2018-01-05 15:53:13.339	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837323c2f7465737449643e0a
2102	1	1259	211	2018-01-05 15:53:13.34	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837333c2f7465737449643e0a
2103	1	1260	211	2018-01-05 15:53:13.341	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3834343c2f7465737449643e0a
2104	1	1261	211	2018-01-05 15:53:13.342	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3834353c2f7465737449643e0a
2105	1	1262	211	2018-01-05 15:53:13.343	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837343c2f7465737449643e0a
2106	1	1263	211	2018-01-05 15:53:13.343	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837353c2f7465737449643e0a
2107	1	1264	211	2018-01-05 15:53:13.344	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3834313c2f7465737449643e0a
2108	1	1314	211	2018-01-05 15:53:13.347	I	\N
2109	1	1315	211	2018-01-05 15:53:13.349	I	\N
2110	1	1316	211	2018-01-05 15:53:13.351	I	\N
2111	1	1317	211	2018-01-05 15:53:13.353	I	\N
2112	1	1318	211	2018-01-05 15:53:13.356	I	\N
2113	1	1319	211	2018-01-05 15:53:13.358	I	\N
2114	1	1320	211	2018-01-05 15:53:13.36	I	\N
2115	1	1321	211	2018-01-05 15:53:13.362	I	\N
2116	1	1322	211	2018-01-05 15:53:13.365	I	\N
2117	1	1323	211	2018-01-05 15:53:13.367	I	\N
2118	1	1324	211	2018-01-05 15:53:13.37	I	\N
2119	1	1325	211	2018-01-05 15:53:13.372	I	\N
2120	1	1326	211	2018-01-05 15:53:13.375	I	\N
2121	1	1327	211	2018-01-05 15:53:13.377	I	\N
2122	1	1328	211	2018-01-05 15:53:13.38	I	\N
2123	1	1329	211	2018-01-05 15:53:13.382	I	\N
2124	1	1330	211	2018-01-05 15:53:13.385	I	\N
2125	1	1331	211	2018-01-05 15:53:13.392	I	\N
2126	1	1332	211	2018-01-05 15:53:13.395	I	\N
2127	1	1333	211	2018-01-05 15:53:13.398	I	\N
2128	1	1334	211	2018-01-05 15:53:13.4	I	\N
2129	1	1335	211	2018-01-05 15:53:13.403	I	\N
2130	1	1336	211	2018-01-05 15:53:13.406	I	\N
2131	1	1337	211	2018-01-05 15:53:13.409	I	\N
2132	1	1338	211	2018-01-05 15:53:13.411	I	\N
2133	1	1339	211	2018-01-05 15:53:13.414	I	\N
2134	1	1340	211	2018-01-05 15:53:13.417	I	\N
2135	1	1341	211	2018-01-05 15:53:13.419	I	\N
2136	1	1342	211	2018-01-05 15:53:13.422	I	\N
2137	1	1343	211	2018-01-05 15:53:13.425	I	\N
2138	1	1344	211	2018-01-05 15:53:13.428	I	\N
2139	1	1345	211	2018-01-05 15:53:13.431	I	\N
2140	1	1346	211	2018-01-05 15:53:13.433	I	\N
2141	1	1347	211	2018-01-05 15:53:13.436	I	\N
2142	1	1348	211	2018-01-05 15:53:13.439	I	\N
2143	1	1349	211	2018-01-05 15:53:13.442	I	\N
2144	1	1350	211	2018-01-05 15:53:13.445	I	\N
2145	1	1351	211	2018-01-05 15:53:13.447	I	\N
2146	1	1352	211	2018-01-05 15:53:13.45	I	\N
2147	1	1353	211	2018-01-05 15:53:13.453	I	\N
2148	1	1354	211	2018-01-05 15:53:13.456	I	\N
2149	1	1355	211	2018-01-05 15:53:13.459	I	\N
2150	1	1356	211	2018-01-05 15:53:13.462	I	\N
2151	1	1357	211	2018-01-05 15:53:13.465	I	\N
2152	1	1358	211	2018-01-05 15:53:13.468	I	\N
2153	1	107	212	2018-01-05 15:53:13.47	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c70616e656c49643e38353c2f70616e656c49643e0a
2154	1	108	212	2018-01-05 15:53:13.472	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c70616e656c49643e38363c2f70616e656c49643e0a
2155	1	109	212	2018-01-05 15:53:13.473	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c70616e656c49643e38373c2f70616e656c49643e0a
2156	1	111	212	2018-01-05 15:53:13.474	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c70616e656c49643e38383c2f70616e656c49643e0a
2157	1	112	212	2018-01-05 15:53:13.476	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c70616e656c49643e38393c2f70616e656c49643e0a
2158	1	110	212	2018-01-05 15:53:13.477	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c70616e656c49643e39333c2f70616e656c49643e0a
2159	1	116	212	2018-01-05 15:53:13.481	I	\N
2160	1	117	212	2018-01-05 15:53:13.484	I	\N
2161	1	118	212	2018-01-05 15:53:13.487	I	\N
2162	1	119	212	2018-01-05 15:53:13.491	I	\N
2163	1	120	212	2018-01-05 15:53:13.494	I	\N
2164	1	121	212	2018-01-05 15:53:13.497	I	\N
2165	1	1265	211	2018-01-05 15:53:13.502	D	\\x3c747970654f6653616d706c6549643e38333c2f747970654f6653616d706c6549643e0a3c7465737449643e3830373c2f7465737449643e0a
2166	1	1266	211	2018-01-05 15:53:13.503	D	\\x3c747970654f6653616d706c6549643e38333c2f747970654f6653616d706c6549643e0a3c7465737449643e3830383c2f7465737449643e0a
2167	1	1267	211	2018-01-05 15:53:13.504	D	\\x3c747970654f6653616d706c6549643e38333c2f747970654f6653616d706c6549643e0a3c7465737449643e3830393c2f7465737449643e0a
2168	1	1359	211	2018-01-05 15:53:13.508	I	\N
2171	1	113	212	2018-01-05 15:53:13.516	D	\\x3c747970654f6653616d706c6549643e38333c2f747970654f6653616d706c6549643e0a3c70616e656c49643e39303c2f70616e656c49643e0a
2172	1	122	212	2018-01-05 15:53:13.519	I	\N
2173	1	1268	211	2018-01-05 15:53:13.524	D	\\x3c747970654f6653616d706c6549643e38343c2f747970654f6653616d706c6549643e0a3c7465737449643e3836393c2f7465737449643e0a
2174	1	1269	211	2018-01-05 15:53:13.526	D	\\x3c747970654f6653616d706c6549643e38343c2f747970654f6653616d706c6549643e0a3c7465737449643e3832323c2f7465737449643e0a
2175	1	1270	211	2018-01-05 15:53:13.527	D	\\x3c747970654f6653616d706c6549643e38343c2f747970654f6653616d706c6549643e0a3c7465737449643e3832333c2f7465737449643e0a
2176	1	1271	211	2018-01-05 15:53:13.528	D	\\x3c747970654f6653616d706c6549643e38343c2f747970654f6653616d706c6549643e0a3c7465737449643e3832343c2f7465737449643e0a
2177	1	1272	211	2018-01-05 15:53:13.529	D	\\x3c747970654f6653616d706c6549643e38343c2f747970654f6653616d706c6549643e0a3c7465737449643e3832353c2f7465737449643e0a
2178	1	1273	211	2018-01-05 15:53:13.531	D	\\x3c747970654f6653616d706c6549643e38343c2f747970654f6653616d706c6549643e0a3c7465737449643e3832363c2f7465737449643e0a
2179	1	1274	211	2018-01-05 15:53:13.532	D	\\x3c747970654f6653616d706c6549643e38343c2f747970654f6653616d706c6549643e0a3c7465737449643e3832373c2f7465737449643e0a
2180	1	1275	211	2018-01-05 15:53:13.533	D	\\x3c747970654f6653616d706c6549643e38343c2f747970654f6653616d706c6549643e0a3c7465737449643e3832383c2f7465737449643e0a
2181	1	1276	211	2018-01-05 15:53:13.534	D	\\x3c747970654f6653616d706c6549643e38343c2f747970654f6653616d706c6549643e0a3c7465737449643e3832393c2f7465737449643e0a
2182	1	1277	211	2018-01-05 15:53:13.536	D	\\x3c747970654f6653616d706c6549643e38343c2f747970654f6653616d706c6549643e0a3c7465737449643e3833303c2f7465737449643e0a
2183	1	1278	211	2018-01-05 15:53:13.537	D	\\x3c747970654f6653616d706c6549643e38343c2f747970654f6653616d706c6549643e0a3c7465737449643e3833313c2f7465737449643e0a
2184	1	1362	211	2018-01-05 15:53:13.54	I	\N
2185	1	1363	211	2018-01-05 15:53:13.544	I	\N
2186	1	1364	211	2018-01-05 15:53:13.547	I	\N
2187	1	1365	211	2018-01-05 15:53:13.55	I	\N
2188	1	1366	211	2018-01-05 15:53:13.554	I	\N
2189	1	1367	211	2018-01-05 15:53:13.557	I	\N
2190	1	1368	211	2018-01-05 15:53:13.56	I	\N
2191	1	1369	211	2018-01-05 15:53:13.564	I	\N
2192	1	1370	211	2018-01-05 15:53:13.567	I	\N
2193	1	1371	211	2018-01-05 15:53:13.571	I	\N
2194	1	1372	211	2018-01-05 15:53:13.575	I	\N
2195	1	114	212	2018-01-05 15:53:13.577	D	\\x3c747970654f6653616d706c6549643e38343c2f747970654f6653616d706c6549643e0a3c70616e656c49643e39323c2f70616e656c49643e0a
2196	1	123	212	2018-01-05 15:53:13.58	I	\N
2197	1	1279	211	2018-01-05 15:53:13.586	D	\\x3c747970654f6653616d706c6549643e38353c2f747970654f6653616d706c6549643e0a3c7465737449643e3831303c2f7465737449643e0a
2198	1	1280	211	2018-01-05 15:53:13.587	D	\\x3c747970654f6653616d706c6549643e38353c2f747970654f6653616d706c6549643e0a3c7465737449643e3831313c2f7465737449643e0a
2199	1	1281	211	2018-01-05 15:53:13.588	D	\\x3c747970654f6653616d706c6549643e38353c2f747970654f6653616d706c6549643e0a3c7465737449643e3831323c2f7465737449643e0a
2200	1	1282	211	2018-01-05 15:53:13.59	D	\\x3c747970654f6653616d706c6549643e38353c2f747970654f6653616d706c6549643e0a3c7465737449643e3831333c2f7465737449643e0a
2201	1	1283	211	2018-01-05 15:53:13.591	D	\\x3c747970654f6653616d706c6549643e38353c2f747970654f6653616d706c6549643e0a3c7465737449643e3831343c2f7465737449643e0a
2202	1	1284	211	2018-01-05 15:53:13.592	D	\\x3c747970654f6653616d706c6549643e38353c2f747970654f6653616d706c6549643e0a3c7465737449643e3831353c2f7465737449643e0a
2203	1	1285	211	2018-01-05 15:53:13.594	D	\\x3c747970654f6653616d706c6549643e38353c2f747970654f6653616d706c6549643e0a3c7465737449643e3831363c2f7465737449643e0a
2204	1	1286	211	2018-01-05 15:53:13.595	D	\\x3c747970654f6653616d706c6549643e38353c2f747970654f6653616d706c6549643e0a3c7465737449643e3831373c2f7465737449643e0a
2205	1	1287	211	2018-01-05 15:53:13.597	D	\\x3c747970654f6653616d706c6549643e38353c2f747970654f6653616d706c6549643e0a3c7465737449643e3831383c2f7465737449643e0a
2206	1	1288	211	2018-01-05 15:53:13.602	D	\\x3c747970654f6653616d706c6549643e38353c2f747970654f6653616d706c6549643e0a3c7465737449643e3831393c2f7465737449643e0a
2207	1	1289	211	2018-01-05 15:53:13.603	D	\\x3c747970654f6653616d706c6549643e38353c2f747970654f6653616d706c6549643e0a3c7465737449643e3832303c2f7465737449643e0a
2208	1	1290	211	2018-01-05 15:53:13.605	D	\\x3c747970654f6653616d706c6549643e38353c2f747970654f6653616d706c6549643e0a3c7465737449643e3834363c2f7465737449643e0a
2209	1	1291	211	2018-01-05 15:53:13.606	D	\\x3c747970654f6653616d706c6549643e38353c2f747970654f6653616d706c6549643e0a3c7465737449643e3832313c2f7465737449643e0a
2210	1	1292	211	2018-01-05 15:53:13.608	D	\\x3c747970654f6653616d706c6549643e38353c2f747970654f6653616d706c6549643e0a3c7465737449643e3836383c2f7465737449643e0a
2211	1	1373	211	2018-01-05 15:53:13.612	I	\N
2212	1	1374	211	2018-01-05 15:53:13.618	I	\N
2213	1	1375	211	2018-01-05 15:53:13.623	I	\N
2214	1	1376	211	2018-01-05 15:53:13.629	I	\N
2215	1	1377	211	2018-01-05 15:53:13.634	I	\N
2216	1	1378	211	2018-01-05 15:53:13.638	I	\N
2217	1	1379	211	2018-01-05 15:53:13.649	I	\N
2218	1	1380	211	2018-01-05 15:53:13.663	I	\N
2219	1	1381	211	2018-01-05 15:53:13.676	I	\N
2220	1	1382	211	2018-01-05 15:53:13.681	I	\N
2221	1	1383	211	2018-01-05 15:53:13.697	I	\N
2222	1	1384	211	2018-01-05 15:53:13.702	I	\N
2223	1	1385	211	2018-01-05 15:53:13.706	I	\N
2224	1	1386	211	2018-01-05 15:53:13.713	I	\N
2225	1	115	212	2018-01-05 15:53:13.718	D	\\x3c747970654f6653616d706c6549643e38353c2f747970654f6653616d706c6549643e0a3c70616e656c49643e39313c2f70616e656c49643e0a
2226	1	124	212	2018-01-05 15:53:13.726	I	\N
2227	1	1293	211	2018-01-05 15:53:13.738	D	\\x3c747970654f6653616d706c6549643e38363c2f747970654f6653616d706c6549643e0a3c7465737449643e3834373c2f7465737449643e0a
2228	1	1294	211	2018-01-05 15:53:13.739	D	\\x3c747970654f6653616d706c6549643e38363c2f747970654f6653616d706c6549643e0a3c7465737449643e3834383c2f7465737449643e0a
2229	1	1295	211	2018-01-05 15:53:13.741	D	\\x3c747970654f6653616d706c6549643e38363c2f747970654f6653616d706c6549643e0a3c7465737449643e3834393c2f7465737449643e0a
2230	1	1387	211	2018-01-05 15:53:13.745	I	\N
2231	1	1388	211	2018-01-05 15:53:13.75	I	\N
2232	1	1389	211	2018-01-05 15:53:13.753	I	\N
2233	1	1296	211	2018-01-05 15:53:13.761	D	\\x3c747970654f6653616d706c6549643e38373c2f747970654f6653616d706c6549643e0a3c7465737449643e3835393c2f7465737449643e0a
2234	1	1297	211	2018-01-05 15:53:13.763	D	\\x3c747970654f6653616d706c6549643e38373c2f747970654f6653616d706c6549643e0a3c7465737449643e3836303c2f7465737449643e0a
2235	1	1298	211	2018-01-05 15:53:13.768	D	\\x3c747970654f6653616d706c6549643e38373c2f747970654f6653616d706c6549643e0a3c7465737449643e3836313c2f7465737449643e0a
2236	1	1390	211	2018-01-05 15:53:13.772	I	\N
2237	1	1391	211	2018-01-05 15:53:13.776	I	\N
2238	1	1392	211	2018-01-05 15:53:13.78	I	\N
2239	1	1299	211	2018-01-05 15:53:13.787	D	\\x3c747970654f6653616d706c6549643e38383c2f747970654f6653616d706c6549643e0a3c7465737449643e3835363c2f7465737449643e0a
2240	1	1300	211	2018-01-05 15:53:13.789	D	\\x3c747970654f6653616d706c6549643e38383c2f747970654f6653616d706c6549643e0a3c7465737449643e3835373c2f7465737449643e0a
2241	1	1301	211	2018-01-05 15:53:13.79	D	\\x3c747970654f6653616d706c6549643e38383c2f747970654f6653616d706c6549643e0a3c7465737449643e3835383c2f7465737449643e0a
2242	1	1393	211	2018-01-05 15:53:13.797	I	\N
2243	1	1394	211	2018-01-05 15:53:13.801	I	\N
2244	1	1395	211	2018-01-05 15:53:13.805	I	\N
2245	1	1302	211	2018-01-05 15:53:13.812	D	\\x3c747970654f6653616d706c6549643e38393c2f747970654f6653616d706c6549643e0a3c7465737449643e3835303c2f7465737449643e0a
2246	1	1303	211	2018-01-05 15:53:13.813	D	\\x3c747970654f6653616d706c6549643e38393c2f747970654f6653616d706c6549643e0a3c7465737449643e3835313c2f7465737449643e0a
2247	1	1304	211	2018-01-05 15:53:13.815	D	\\x3c747970654f6653616d706c6549643e38393c2f747970654f6653616d706c6549643e0a3c7465737449643e3835323c2f7465737449643e0a
2248	1	1396	211	2018-01-05 15:53:13.819	I	\N
2249	1	1397	211	2018-01-05 15:53:13.824	I	\N
2250	1	1398	211	2018-01-05 15:53:13.828	I	\N
2251	1	1305	211	2018-01-05 15:53:13.836	D	\\x3c747970654f6653616d706c6549643e39303c2f747970654f6653616d706c6549643e0a3c7465737449643e3836323c2f7465737449643e0a
2252	1	1306	211	2018-01-05 15:53:13.837	D	\\x3c747970654f6653616d706c6549643e39303c2f747970654f6653616d706c6549643e0a3c7465737449643e3836333c2f7465737449643e0a
2253	1	1307	211	2018-01-05 15:53:13.841	D	\\x3c747970654f6653616d706c6549643e39303c2f747970654f6653616d706c6549643e0a3c7465737449643e3836343c2f7465737449643e0a
2254	1	1399	211	2018-01-05 15:53:13.846	I	\N
2256	1	1401	211	2018-01-05 15:53:13.857	I	\N
2257	1	1308	211	2018-01-05 15:53:13.865	D	\\x3c747970654f6653616d706c6549643e39313c2f747970654f6653616d706c6549643e0a3c7465737449643e3836353c2f7465737449643e0a
2258	1	1309	211	2018-01-05 15:53:13.867	D	\\x3c747970654f6653616d706c6549643e39313c2f747970654f6653616d706c6549643e0a3c7465737449643e3836363c2f7465737449643e0a
2259	1	1310	211	2018-01-05 15:53:13.869	D	\\x3c747970654f6653616d706c6549643e39313c2f747970654f6653616d706c6549643e0a3c7465737449643e3836373c2f7465737449643e0a
2260	1	1402	211	2018-01-05 15:53:13.874	I	\N
2261	1	1403	211	2018-01-05 15:53:13.878	I	\N
2262	1	1404	211	2018-01-05 15:53:13.883	I	\N
2263	1	1311	211	2018-01-05 15:53:13.89	D	\\x3c747970654f6653616d706c6549643e39323c2f747970654f6653616d706c6549643e0a3c7465737449643e3835333c2f7465737449643e0a
2264	1	1312	211	2018-01-05 15:53:13.892	D	\\x3c747970654f6653616d706c6549643e39323c2f747970654f6653616d706c6549643e0a3c7465737449643e3835343c2f7465737449643e0a
2265	1	1313	211	2018-01-05 15:53:13.894	D	\\x3c747970654f6653616d706c6549643e39323c2f747970654f6653616d706c6549643e0a3c7465737449643e3835353c2f7465737449643e0a
2266	1	1405	211	2018-01-05 15:53:13.898	I	\N
2267	1	1406	211	2018-01-05 15:53:13.903	I	\N
2268	1	1407	211	2018-01-05 15:53:13.907	I	\N
2294	1	1330	211	2018-01-05 15:53:14.366	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3739393c2f7465737449643e0a
2295	1	1331	211	2018-01-05 15:53:14.367	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3830303c2f7465737449643e0a
2296	1	1332	211	2018-01-05 15:53:14.368	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3830313c2f7465737449643e0a
2297	1	1333	211	2018-01-05 15:53:14.369	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3830323c2f7465737449643e0a
2298	1	1334	211	2018-01-05 15:53:14.369	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3830333c2f7465737449643e0a
2299	1	1335	211	2018-01-05 15:53:14.37	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3830343c2f7465737449643e0a
2300	1	1336	211	2018-01-05 15:53:14.371	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3830353c2f7465737449643e0a
2301	1	1337	211	2018-01-05 15:53:14.372	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3830363c2f7465737449643e0a
2302	1	1338	211	2018-01-05 15:53:14.373	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833323c2f7465737449643e0a
2303	1	1339	211	2018-01-05 15:53:14.373	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833333c2f7465737449643e0a
2304	1	1340	211	2018-01-05 15:53:14.374	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833343c2f7465737449643e0a
2305	1	1341	211	2018-01-05 15:53:14.375	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833353c2f7465737449643e0a
2306	1	1342	211	2018-01-05 15:53:14.376	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837363c2f7465737449643e0a
2307	1	1343	211	2018-01-05 15:53:14.377	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837373c2f7465737449643e0a
2308	1	1344	211	2018-01-05 15:53:14.378	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833363c2f7465737449643e0a
2309	1	1345	211	2018-01-05 15:53:14.378	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833373c2f7465737449643e0a
2310	1	1346	211	2018-01-05 15:53:14.379	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837303c2f7465737449643e0a
2311	1	1347	211	2018-01-05 15:53:14.38	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837313c2f7465737449643e0a
2312	1	1348	211	2018-01-05 15:53:14.381	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833383c2f7465737449643e0a
2313	1	1349	211	2018-01-05 15:53:14.381	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3833393c2f7465737449643e0a
2314	1	1350	211	2018-01-05 15:53:14.383	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3834323c2f7465737449643e0a
2315	1	1351	211	2018-01-05 15:53:14.384	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3834333c2f7465737449643e0a
2316	1	1352	211	2018-01-05 15:53:14.384	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837323c2f7465737449643e0a
2317	1	1353	211	2018-01-05 15:53:14.385	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837333c2f7465737449643e0a
2318	1	1354	211	2018-01-05 15:53:14.386	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3834343c2f7465737449643e0a
2319	1	1355	211	2018-01-05 15:53:14.387	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3834353c2f7465737449643e0a
2320	1	1356	211	2018-01-05 15:53:14.388	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837343c2f7465737449643e0a
2321	1	1357	211	2018-01-05 15:53:14.389	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3837353c2f7465737449643e0a
2322	1	1358	211	2018-01-05 15:53:14.39	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c7465737449643e3834313c2f7465737449643e0a
2323	1	1408	211	2018-01-05 15:53:14.392	I	\N
2324	1	1409	211	2018-01-05 15:53:14.395	I	\N
2325	1	1410	211	2018-01-05 15:53:14.397	I	\N
2326	1	1411	211	2018-01-05 15:53:14.401	I	\N
2327	1	1412	211	2018-01-05 15:53:14.409	I	\N
2328	1	1413	211	2018-01-05 15:53:14.411	I	\N
2329	1	1414	211	2018-01-05 15:53:14.413	I	\N
2330	1	1415	211	2018-01-05 15:53:14.416	I	\N
2331	1	1416	211	2018-01-05 15:53:14.418	I	\N
2332	1	1417	211	2018-01-05 15:53:14.42	I	\N
2333	1	1418	211	2018-01-05 15:53:14.424	I	\N
2334	1	1419	211	2018-01-05 15:53:14.427	I	\N
2335	1	1420	211	2018-01-05 15:53:14.429	I	\N
2336	1	1421	211	2018-01-05 15:53:14.431	I	\N
2337	1	1422	211	2018-01-05 15:53:14.434	I	\N
2338	1	1423	211	2018-01-05 15:53:14.436	I	\N
2339	1	1424	211	2018-01-05 15:53:14.438	I	\N
2340	1	1425	211	2018-01-05 15:53:14.441	I	\N
2341	1	1426	211	2018-01-05 15:53:14.444	I	\N
2342	1	1427	211	2018-01-05 15:53:14.447	I	\N
2343	1	1428	211	2018-01-05 15:53:14.449	I	\N
2344	1	1429	211	2018-01-05 15:53:14.452	I	\N
2345	1	1430	211	2018-01-05 15:53:14.454	I	\N
2346	1	1431	211	2018-01-05 15:53:14.457	I	\N
2347	1	1432	211	2018-01-05 15:53:14.48	I	\N
2348	1	1433	211	2018-01-05 15:53:14.484	I	\N
2349	1	1434	211	2018-01-05 15:53:14.487	I	\N
2350	1	1435	211	2018-01-05 15:53:14.49	I	\N
2351	1	1436	211	2018-01-05 15:53:14.492	I	\N
2352	1	1437	211	2018-01-05 15:53:14.495	I	\N
2353	1	1438	211	2018-01-05 15:53:14.498	I	\N
2354	1	1439	211	2018-01-05 15:53:14.5	I	\N
2355	1	1440	211	2018-01-05 15:53:14.503	I	\N
2356	1	1441	211	2018-01-05 15:53:14.506	I	\N
2357	1	1442	211	2018-01-05 15:53:14.509	I	\N
2358	1	1443	211	2018-01-05 15:53:14.512	I	\N
2359	1	1444	211	2018-01-05 15:53:14.514	I	\N
2360	1	1445	211	2018-01-05 15:53:14.517	I	\N
2361	1	1446	211	2018-01-05 15:53:14.52	I	\N
2362	1	1447	211	2018-01-05 15:53:14.523	I	\N
2363	1	1448	211	2018-01-05 15:53:14.525	I	\N
2364	1	1449	211	2018-01-05 15:53:14.529	I	\N
2365	1	1450	211	2018-01-05 15:53:14.532	I	\N
2366	1	1451	211	2018-01-05 15:53:14.535	I	\N
2367	1	1452	211	2018-01-05 15:53:14.538	I	\N
2368	1	116	212	2018-01-05 15:53:14.541	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c70616e656c49643e38353c2f70616e656c49643e0a
2369	1	117	212	2018-01-05 15:53:14.542	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c70616e656c49643e38363c2f70616e656c49643e0a
2370	1	118	212	2018-01-05 15:53:14.544	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c70616e656c49643e38373c2f70616e656c49643e0a
2371	1	120	212	2018-01-05 15:53:14.545	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c70616e656c49643e38383c2f70616e656c49643e0a
2372	1	121	212	2018-01-05 15:53:14.546	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c70616e656c49643e38393c2f70616e656c49643e0a
2373	1	119	212	2018-01-05 15:53:14.548	D	\\x3c747970654f6653616d706c6549643e38323c2f747970654f6653616d706c6549643e0a3c70616e656c49643e39333c2f70616e656c49643e0a
2374	1	125	212	2018-01-05 15:53:14.551	I	\N
2375	1	126	212	2018-01-05 15:53:14.554	I	\N
2376	1	127	212	2018-01-05 15:53:14.558	I	\N
2377	1	128	212	2018-01-05 15:53:14.561	I	\N
2378	1	129	212	2018-01-05 15:53:14.564	I	\N
2379	1	130	212	2018-01-05 15:53:14.567	I	\N
1723	1	13	16	2018-01-05 15:53:46.216	I	\N
1724	1	6	19	2018-01-05 15:53:46.22	I	\N
1725	1	11	15	2018-01-05 15:53:46.225	I	\N
2441	1	14	16	2018-01-05 16:03:15.125	I	\N
2442	1	12	15	2018-01-05 16:03:15.13	I	\N
2443	1	15	112	2018-01-05 16:03:15.138	I	\N
2444	1	30	1	2018-01-05 16:03:30.096	I	\N
2445	1	50	23	2018-01-05 16:03:30.102	I	\N
2446	1	506	4	2018-01-05 16:03:30.105	I	\N
2447	1	507	4	2018-01-05 16:03:30.108	I	\N
2448	1	30	45	2018-01-05 16:03:30.11	I	\N
2461	1	508	4	2018-01-05 16:16:07.235	I	\N
2481	1	58	208	2018-01-05 16:16:12.949	I	\N
2501	1	59	208	2018-01-05 16:16:34.776	I	\N
2521	1	70	21	2018-01-05 16:29:08.391	I	\N
2522	1	64	155	2018-01-05 16:29:08.395	I	\N
2523	1	71	21	2018-01-05 16:29:08.398	I	\N
2524	1	65	155	2018-01-05 16:29:08.402	I	\N
2525	1	72	21	2018-01-05 16:29:08.406	I	\N
2526	1	66	155	2018-01-05 16:29:08.408	I	\N
2527	1	73	21	2018-01-05 16:29:08.41	I	\N
2528	1	67	155	2018-01-05 16:29:08.413	I	\N
2529	1	29	1	2018-01-05 16:29:08.447	U	\\x3c73746174757349643e313c2f73746174757349643e0a
2541	1	499	4	2018-01-05 16:29:15.554	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2542	1	497	4	2018-01-05 16:29:15.559	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2543	1	503	4	2018-01-05 16:29:15.562	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2544	1	496	4	2018-01-05 16:29:15.564	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2561	1	15	16	2018-01-05 16:39:00.227	I	\N
2562	1	13	15	2018-01-05 16:39:00.231	I	\N
2563	1	16	112	2018-01-05 16:39:00.235	I	\N
2581	1	60	208	2018-01-05 16:52:36.356	I	\N
2582	1	61	208	2018-01-05 16:53:32.474	I	\N
2601	1	62	208	2018-01-05 16:56:08.992	I	\N
2621	1	74	21	2018-01-05 16:57:08.952	I	\N
2622	1	68	155	2018-01-05 16:57:08.956	I	\N
2623	1	75	21	2018-01-05 16:57:08.958	I	\N
2624	1	69	155	2018-01-05 16:57:08.96	I	\N
2625	1	76	21	2018-01-05 16:57:08.963	I	\N
2626	1	70	155	2018-01-05 16:57:08.965	I	\N
2627	1	77	21	2018-01-05 16:57:08.967	I	\N
2628	1	71	155	2018-01-05 16:57:08.97	I	\N
2629	1	78	21	2018-01-05 16:57:08.973	I	\N
2630	1	72	155	2018-01-05 16:57:08.975	I	\N
2631	1	79	21	2018-01-05 16:57:08.977	I	\N
2632	1	73	155	2018-01-05 16:57:08.979	I	\N
2633	1	80	21	2018-01-05 16:57:08.981	I	\N
2634	1	74	155	2018-01-05 16:57:08.983	I	\N
2635	1	81	21	2018-01-05 16:57:08.985	I	\N
2636	1	75	155	2018-01-05 16:57:08.986	I	\N
2637	1	82	21	2018-01-05 16:57:08.988	I	\N
2638	1	76	155	2018-01-05 16:57:08.99	I	\N
2639	1	83	21	2018-01-05 16:57:08.993	I	\N
2640	1	77	155	2018-01-05 16:57:08.995	I	\N
2641	1	84	21	2018-01-05 16:57:08.996	I	\N
2642	1	78	155	2018-01-05 16:57:08.998	I	\N
2643	1	85	21	2018-01-05 16:57:09	I	\N
2644	1	79	155	2018-01-05 16:57:09.002	I	\N
2645	1	86	21	2018-01-05 16:57:09.004	I	\N
2646	1	80	155	2018-01-05 16:57:09.005	I	\N
2647	1	87	21	2018-01-05 16:57:09.007	I	\N
2648	1	81	155	2018-01-05 16:57:09.009	I	\N
2649	1	88	21	2018-01-05 16:57:09.011	I	\N
2650	1	82	155	2018-01-05 16:57:09.015	I	\N
2651	1	28	1	2018-01-05 16:57:09.049	U	\\x3c73746174757349643e313c2f73746174757349643e0a
2602	1	489	4	2018-01-05 16:57:15.555	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2603	1	491	4	2018-01-05 16:57:15.559	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2604	1	492	4	2018-01-05 16:57:15.562	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2605	1	493	4	2018-01-05 16:57:15.565	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2606	1	490	4	2018-01-05 16:57:15.572	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2607	1	482	4	2018-01-05 16:57:15.579	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2608	1	484	4	2018-01-05 16:57:15.583	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2609	1	481	4	2018-01-05 16:57:15.585	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2610	1	483	4	2018-01-05 16:57:15.588	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2611	1	486	4	2018-01-05 16:57:15.59	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2612	1	487	4	2018-01-05 16:57:15.593	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2613	1	485	4	2018-01-05 16:57:15.595	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2614	1	488	4	2018-01-05 16:57:15.597	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2615	1	480	4	2018-01-05 16:57:15.6	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2616	1	479	4	2018-01-05 16:57:15.602	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2617	1	28	1	2018-01-05 16:57:15.623	U	\\x3c616363657373696f6e4e756d6265723e3c2f616363657373696f6e4e756d6265723e0a3c646f6d61696e3e3c2f646f6d61696e3e0a3c656e7465726564446174653e3c2f656e7465726564446174653e0a3c656e746572656444617465466f72446973706c61793e3c2f656e746572656444617465466f72446973706c61793e0a3c726563656976656454696d657374616d703e3c2f726563656976656454696d657374616d703e0a3c726563656976656444617465466f72446973706c61793e3c2f726563656976656444617465466f72446973706c61793e0a3c726563656976656454696d65466f72446973706c61793e3c2f726563656976656454696d65466f72446973706c61793e0a3c70617469656e743e3c2f70617469656e743e0a3c757569643e3c2f757569643e0a3c73746174757349643e3c2f73746174757349643e0a3c73616d706c65536f757263653e3c2f73616d706c65536f757263653e0a3c6c617374757064617465643e3c2f6c617374757064617465643e0a
2661	1	63	208	2018-01-05 16:57:34.157	I	\N
2681	1	31	1	2018-01-05 18:22:30.135	I	\N
2682	1	51	23	2018-01-05 18:22:30.139	I	\N
2683	1	509	4	2018-01-05 18:22:30.144	I	\N
2684	1	510	4	2018-01-05 18:22:30.147	I	\N
2685	1	511	4	2018-01-05 18:22:30.15	I	\N
2686	1	31	45	2018-01-05 18:22:30.152	I	\N
2701	1	89	21	2018-01-05 18:35:36.141	I	\N
2702	1	83	155	2018-01-05 18:35:36.144	I	\N
2703	1	90	21	2018-01-05 18:35:36.146	I	\N
2704	1	84	155	2018-01-05 18:35:36.148	I	\N
2705	1	91	21	2018-01-05 18:35:36.149	I	\N
2706	1	85	155	2018-01-05 18:35:36.151	I	\N
2707	1	31	1	2018-01-05 18:35:36.16	U	\\x3c73746174757349643e313c2f73746174757349643e0a
2708	1	509	4	2018-01-05 18:35:41.911	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2709	1	511	4	2018-01-05 18:35:41.913	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2710	1	510	4	2018-01-05 18:35:41.915	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2711	1	31	1	2018-01-05 18:35:41.923	U	\\x3c616363657373696f6e4e756d6265723e3c2f616363657373696f6e4e756d6265723e0a3c646f6d61696e3e3c2f646f6d61696e3e0a3c656e7465726564446174653e3c2f656e7465726564446174653e0a3c656e746572656444617465466f72446973706c61793e3c2f656e746572656444617465466f72446973706c61793e0a3c726563656976656454696d657374616d703e3c2f726563656976656454696d657374616d703e0a3c726563656976656444617465466f72446973706c61793e3c2f726563656976656444617465466f72446973706c61793e0a3c726563656976656454696d65466f72446973706c61793e3c2f726563656976656454696d65466f72446973706c61793e0a3c70617469656e743e3c2f70617469656e743e0a3c757569643e3c2f757569643e0a3c73746174757349643e3c2f73746174757349643e0a3c73616d706c65536f757263653e3c2f73616d706c65536f757263653e0a3c6c617374757064617465643e3c2f6c617374757064617465643e0a
2721	1	92	21	2018-01-05 18:35:59.98	I	\N
2722	1	86	155	2018-01-05 18:35:59.983	I	\N
2723	1	93	21	2018-01-05 18:35:59.985	I	\N
2724	1	87	155	2018-01-05 18:35:59.987	I	\N
2725	1	94	21	2018-01-05 18:35:59.989	I	\N
2726	1	88	155	2018-01-05 18:35:59.99	I	\N
2727	1	30	1	2018-01-05 18:36:00.023	U	\\x3c73746174757349643e313c2f73746174757349643e0a
2741	1	508	4	2018-01-05 18:36:05.53	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2742	1	506	4	2018-01-05 18:36:05.534	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2743	1	507	4	2018-01-05 18:36:05.537	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2744	1	30	1	2018-01-05 18:36:05.544	U	\\x3c616363657373696f6e4e756d6265723e3c2f616363657373696f6e4e756d6265723e0a3c646f6d61696e3e3c2f646f6d61696e3e0a3c656e7465726564446174653e3c2f656e7465726564446174653e0a3c656e746572656444617465466f72446973706c61793e3c2f656e746572656444617465466f72446973706c61793e0a3c726563656976656454696d657374616d703e3c2f726563656976656454696d657374616d703e0a3c726563656976656444617465466f72446973706c61793e3c2f726563656976656444617465466f72446973706c61793e0a3c726563656976656454696d65466f72446973706c61793e3c2f726563656976656454696d65466f72446973706c61793e0a3c70617469656e743e3c2f70617469656e743e0a3c757569643e3c2f757569643e0a3c73746174757349643e3c2f73746174757349643e0a3c73616d706c65536f757263653e3c2f73616d706c65536f757263653e0a3c6c617374757064617465643e3c2f6c617374757064617465643e0a
2761	1	16	16	2018-01-06 16:47:15.213	I	\N
2762	1	14	15	2018-01-06 16:47:15.229	I	\N
2763	1	17	112	2018-01-06 16:47:15.25	I	\N
2781	1	18	112	2018-01-06 16:47:15.327	I	\N
2782	1	19	112	2018-01-06 16:47:15.33	I	\N
2801	1	32	1	2018-01-06 16:47:30.136	I	\N
2802	1	52	23	2018-01-06 16:47:30.144	I	\N
2803	1	512	4	2018-01-06 16:47:30.153	I	\N
2804	1	513	4	2018-01-06 16:47:30.163	I	\N
2805	1	514	4	2018-01-06 16:47:30.167	I	\N
2806	1	32	45	2018-01-06 16:47:30.172	I	\N
2807	1	15	15	2018-01-06 16:48:07.382	I	\N
2821	1	95	21	2018-01-06 16:48:26.071	I	\N
2822	1	89	155	2018-01-06 16:48:26.08	I	\N
2823	1	96	21	2018-01-06 16:48:26.083	I	\N
2824	1	90	155	2018-01-06 16:48:26.085	I	\N
2825	1	97	21	2018-01-06 16:48:26.087	I	\N
2826	1	91	155	2018-01-06 16:48:26.088	I	\N
2827	1	32	1	2018-01-06 16:48:26.125	U	\\x3c73746174757349643e313c2f73746174757349643e0a
2841	1	514	4	2018-01-06 16:48:31.051	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2842	1	513	4	2018-01-06 16:48:31.057	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2843	1	512	4	2018-01-06 16:48:31.06	U	\\x3c72656c6561736564446174653e3c2f72656c6561736564446174653e0a3c72656c656173656444617465466f72446973706c61793e3c2f72656c656173656444617465466f72446973706c61793e0a3c73746174757349643e31363c2f73746174757349643e0a
2844	1	32	1	2018-01-06 16:48:31.081	U	\\x3c616363657373696f6e4e756d6265723e3c2f616363657373696f6e4e756d6265723e0a3c646f6d61696e3e3c2f646f6d61696e3e0a3c656e7465726564446174653e3c2f656e7465726564446174653e0a3c656e746572656444617465466f72446973706c61793e3c2f656e746572656444617465466f72446973706c61793e0a3c726563656976656454696d657374616d703e3c2f726563656976656454696d657374616d703e0a3c726563656976656444617465466f72446973706c61793e3c2f726563656976656444617465466f72446973706c61793e0a3c726563656976656454696d65466f72446973706c61793e3c2f726563656976656454696d65466f72446973706c61793e0a3c70617469656e743e3c2f70617469656e743e0a3c757569643e3c2f757569643e0a3c73746174757349643e3c2f73746174757349643e0a3c73616d706c65536f757263653e3c2f73616d706c65536f757263653e0a3c6c617374757064617465643e3c2f6c617374757064617465643e0a
\.


--
-- Name: history_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('history_seq', 2860, true);


--
-- Name: hl7_encoding_type_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('hl7_encoding_type_seq', 4, true);


--
-- Data for Name: htmldb_plan_table; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY htmldb_plan_table (statement_id, plan_id, "timestamp", remarks, operation, options, object_node, object_owner, object_name, object_alias, object_instance, object_type, optimizer, search_columns, id, parent_id, depth, "position", cost, cardinality, bytes, other_tag, partition_start, partition_stop, partition_id, other, distribution, cpu_cost, io_cost, temp_space, access_predicates, filter_predicates, projection, "time", qblock_name) FROM stdin;
7146420525171748	1	2008-05-08 14:33:14	\N	SELECT STATEMENT	\N	\N	\N	\N	\N	\N	\N	ALL_ROWS	\N	0	\N	0	238	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	\N	3	\N
7146420525171748	1	2008-05-08 14:33:14	<remarks><info type="db_version">10.2.0.1</info><info type="parse_schema"><![CDATA["CLINLIMS"]]></info><info type="plan_hash">288471584</info><outline_data><hint><![CDATA[FULL(@"SEL$1" "CITY_STATE_ZIP"@"SEL$1")]]></hint><hint><![CDATA[OUTLINE_LEAF(@"SEL$1")]]></hint><hint><![CDATA[ALL_ROWS]]></hint><hint><![CDATA[OPTIMIZER_FEATURES_ENABLE('10.2.0.1')]]></hint><hint><![CDATA[IGNORE_OPTIM_EMBEDDED_HINTS]]></hint></outline_data></remarks>	TABLE ACCESS	FULL	\N	CLINLIMS	CITY_STATE_ZIP	CITY_STATE_ZIP@SEL$1	1	TABLE	ANALYZED	\N	1	0	1	1	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	"CITY_STATE_ZIP"."ID"[NUMBER,22], "CITY_STATE_ZIP"."CITY"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE"[VARCHAR2,2], "CITY_STATE_ZIP"."ZIP_CODE"[VARCHAR2,10], "CITY_STATE_ZIP"."COUNTY_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."COUNTY"[VARCHAR2,25], "CITY_STATE_ZIP"."REGION_ID"[NUMBER,22], "CITY_STATE_ZIP"."REGION"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."STATE_NAME"[VARCHAR2,30], "CITY_STATE_ZIP"."LASTUPDATED"[TIMESTAMP,11]	3	SEL$1
7146722603172428	2	2008-05-08 14:33:20	\N	SELECT STATEMENT	\N	\N	\N	\N	\N	\N	\N	ALL_ROWS	\N	0	\N	0	238	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	\N	3	\N
7146722603172428	2	2008-05-08 14:33:20	<remarks><info type="db_version">10.2.0.1</info><info type="parse_schema"><![CDATA["CLINLIMS"]]></info><info type="plan_hash">288471584</info><outline_data><hint><![CDATA[FULL(@"SEL$1" "CITY_STATE_ZIP"@"SEL$1")]]></hint><hint><![CDATA[OUTLINE_LEAF(@"SEL$1")]]></hint><hint><![CDATA[ALL_ROWS]]></hint><hint><![CDATA[OPTIMIZER_FEATURES_ENABLE('10.2.0.1')]]></hint><hint><![CDATA[IGNORE_OPTIM_EMBEDDED_HINTS]]></hint></outline_data></remarks>	TABLE ACCESS	FULL	\N	CLINLIMS	CITY_STATE_ZIP	CITY_STATE_ZIP@SEL$1	1	TABLE	ANALYZED	\N	1	0	1	1	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	"CITY_STATE_ZIP"."ID"[NUMBER,22], "CITY_STATE_ZIP"."CITY"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE"[VARCHAR2,2], "CITY_STATE_ZIP"."ZIP_CODE"[VARCHAR2,10], "CITY_STATE_ZIP"."COUNTY_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."COUNTY"[VARCHAR2,25], "CITY_STATE_ZIP"."REGION_ID"[NUMBER,22], "CITY_STATE_ZIP"."REGION"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."STATE_NAME"[VARCHAR2,30], "CITY_STATE_ZIP"."LASTUPDATED"[TIMESTAMP,11]	3	SEL$1
7146420525171748	1	2008-05-08 14:33:14	\N	SELECT STATEMENT	\N	\N	\N	\N	\N	\N	\N	ALL_ROWS	\N	0	\N	0	238	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	\N	3	\N
7146420525171748	1	2008-05-08 14:33:14	<remarks><info type="db_version">10.2.0.1</info><info type="parse_schema"><![CDATA["CLINLIMS"]]></info><info type="plan_hash">288471584</info><outline_data><hint><![CDATA[FULL(@"SEL$1" "CITY_STATE_ZIP"@"SEL$1")]]></hint><hint><![CDATA[OUTLINE_LEAF(@"SEL$1")]]></hint><hint><![CDATA[ALL_ROWS]]></hint><hint><![CDATA[OPTIMIZER_FEATURES_ENABLE('10.2.0.1')]]></hint><hint><![CDATA[IGNORE_OPTIM_EMBEDDED_HINTS]]></hint></outline_data></remarks>	TABLE ACCESS	FULL	\N	CLINLIMS	CITY_STATE_ZIP	CITY_STATE_ZIP@SEL$1	1	TABLE	ANALYZED	\N	1	0	1	1	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	"CITY_STATE_ZIP"."ID"[NUMBER,22], "CITY_STATE_ZIP"."CITY"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE"[VARCHAR2,2], "CITY_STATE_ZIP"."ZIP_CODE"[VARCHAR2,10], "CITY_STATE_ZIP"."COUNTY_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."COUNTY"[VARCHAR2,25], "CITY_STATE_ZIP"."REGION_ID"[NUMBER,22], "CITY_STATE_ZIP"."REGION"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."STATE_NAME"[VARCHAR2,30], "CITY_STATE_ZIP"."LASTUPDATED"[TIMESTAMP,11]	3	SEL$1
7146722603172428	2	2008-05-08 14:33:20	\N	SELECT STATEMENT	\N	\N	\N	\N	\N	\N	\N	ALL_ROWS	\N	0	\N	0	238	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	\N	3	\N
7146722603172428	2	2008-05-08 14:33:20	<remarks><info type="db_version">10.2.0.1</info><info type="parse_schema"><![CDATA["CLINLIMS"]]></info><info type="plan_hash">288471584</info><outline_data><hint><![CDATA[FULL(@"SEL$1" "CITY_STATE_ZIP"@"SEL$1")]]></hint><hint><![CDATA[OUTLINE_LEAF(@"SEL$1")]]></hint><hint><![CDATA[ALL_ROWS]]></hint><hint><![CDATA[OPTIMIZER_FEATURES_ENABLE('10.2.0.1')]]></hint><hint><![CDATA[IGNORE_OPTIM_EMBEDDED_HINTS]]></hint></outline_data></remarks>	TABLE ACCESS	FULL	\N	CLINLIMS	CITY_STATE_ZIP	CITY_STATE_ZIP@SEL$1	1	TABLE	ANALYZED	\N	1	0	1	1	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	"CITY_STATE_ZIP"."ID"[NUMBER,22], "CITY_STATE_ZIP"."CITY"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE"[VARCHAR2,2], "CITY_STATE_ZIP"."ZIP_CODE"[VARCHAR2,10], "CITY_STATE_ZIP"."COUNTY_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."COUNTY"[VARCHAR2,25], "CITY_STATE_ZIP"."REGION_ID"[NUMBER,22], "CITY_STATE_ZIP"."REGION"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."STATE_NAME"[VARCHAR2,30], "CITY_STATE_ZIP"."LASTUPDATED"[TIMESTAMP,11]	3	SEL$1
7146420525171748	1	2008-05-08 14:33:14	\N	SELECT STATEMENT	\N	\N	\N	\N	\N	\N	\N	ALL_ROWS	\N	0	\N	0	238	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	\N	3	\N
7146420525171748	1	2008-05-08 14:33:14	<remarks><info type="db_version">10.2.0.1</info><info type="parse_schema"><![CDATA["CLINLIMS"]]></info><info type="plan_hash">288471584</info><outline_data><hint><![CDATA[FULL(@"SEL$1" "CITY_STATE_ZIP"@"SEL$1")]]></hint><hint><![CDATA[OUTLINE_LEAF(@"SEL$1")]]></hint><hint><![CDATA[ALL_ROWS]]></hint><hint><![CDATA[OPTIMIZER_FEATURES_ENABLE('10.2.0.1')]]></hint><hint><![CDATA[IGNORE_OPTIM_EMBEDDED_HINTS]]></hint></outline_data></remarks>	TABLE ACCESS	FULL	\N	CLINLIMS	CITY_STATE_ZIP	CITY_STATE_ZIP@SEL$1	1	TABLE	ANALYZED	\N	1	0	1	1	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	"CITY_STATE_ZIP"."ID"[NUMBER,22], "CITY_STATE_ZIP"."CITY"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE"[VARCHAR2,2], "CITY_STATE_ZIP"."ZIP_CODE"[VARCHAR2,10], "CITY_STATE_ZIP"."COUNTY_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."COUNTY"[VARCHAR2,25], "CITY_STATE_ZIP"."REGION_ID"[NUMBER,22], "CITY_STATE_ZIP"."REGION"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."STATE_NAME"[VARCHAR2,30], "CITY_STATE_ZIP"."LASTUPDATED"[TIMESTAMP,11]	3	SEL$1
7146722603172428	2	2008-05-08 14:33:20	\N	SELECT STATEMENT	\N	\N	\N	\N	\N	\N	\N	ALL_ROWS	\N	0	\N	0	238	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	\N	3	\N
7146722603172428	2	2008-05-08 14:33:20	<remarks><info type="db_version">10.2.0.1</info><info type="parse_schema"><![CDATA["CLINLIMS"]]></info><info type="plan_hash">288471584</info><outline_data><hint><![CDATA[FULL(@"SEL$1" "CITY_STATE_ZIP"@"SEL$1")]]></hint><hint><![CDATA[OUTLINE_LEAF(@"SEL$1")]]></hint><hint><![CDATA[ALL_ROWS]]></hint><hint><![CDATA[OPTIMIZER_FEATURES_ENABLE('10.2.0.1')]]></hint><hint><![CDATA[IGNORE_OPTIM_EMBEDDED_HINTS]]></hint></outline_data></remarks>	TABLE ACCESS	FULL	\N	CLINLIMS	CITY_STATE_ZIP	CITY_STATE_ZIP@SEL$1	1	TABLE	ANALYZED	\N	1	0	1	1	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	"CITY_STATE_ZIP"."ID"[NUMBER,22], "CITY_STATE_ZIP"."CITY"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE"[VARCHAR2,2], "CITY_STATE_ZIP"."ZIP_CODE"[VARCHAR2,10], "CITY_STATE_ZIP"."COUNTY_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."COUNTY"[VARCHAR2,25], "CITY_STATE_ZIP"."REGION_ID"[NUMBER,22], "CITY_STATE_ZIP"."REGION"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."STATE_NAME"[VARCHAR2,30], "CITY_STATE_ZIP"."LASTUPDATED"[TIMESTAMP,11]	3	SEL$1
7146420525171748	1	2008-05-08 14:33:14	\N	SELECT STATEMENT	\N	\N	\N	\N	\N	\N	\N	ALL_ROWS	\N	0	\N	0	238	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	\N	3	\N
7146420525171748	1	2008-05-08 14:33:14	<remarks><info type="db_version">10.2.0.1</info><info type="parse_schema"><![CDATA["CLINLIMS"]]></info><info type="plan_hash">288471584</info><outline_data><hint><![CDATA[FULL(@"SEL$1" "CITY_STATE_ZIP"@"SEL$1")]]></hint><hint><![CDATA[OUTLINE_LEAF(@"SEL$1")]]></hint><hint><![CDATA[ALL_ROWS]]></hint><hint><![CDATA[OPTIMIZER_FEATURES_ENABLE('10.2.0.1')]]></hint><hint><![CDATA[IGNORE_OPTIM_EMBEDDED_HINTS]]></hint></outline_data></remarks>	TABLE ACCESS	FULL	\N	CLINLIMS	CITY_STATE_ZIP	CITY_STATE_ZIP@SEL$1	1	TABLE	ANALYZED	\N	1	0	1	1	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	"CITY_STATE_ZIP"."ID"[NUMBER,22], "CITY_STATE_ZIP"."CITY"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE"[VARCHAR2,2], "CITY_STATE_ZIP"."ZIP_CODE"[VARCHAR2,10], "CITY_STATE_ZIP"."COUNTY_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."COUNTY"[VARCHAR2,25], "CITY_STATE_ZIP"."REGION_ID"[NUMBER,22], "CITY_STATE_ZIP"."REGION"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."STATE_NAME"[VARCHAR2,30], "CITY_STATE_ZIP"."LASTUPDATED"[TIMESTAMP,11]	3	SEL$1
7146722603172428	2	2008-05-08 14:33:20	\N	SELECT STATEMENT	\N	\N	\N	\N	\N	\N	\N	ALL_ROWS	\N	0	\N	0	238	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	\N	3	\N
7146722603172428	2	2008-05-08 14:33:20	<remarks><info type="db_version">10.2.0.1</info><info type="parse_schema"><![CDATA["CLINLIMS"]]></info><info type="plan_hash">288471584</info><outline_data><hint><![CDATA[FULL(@"SEL$1" "CITY_STATE_ZIP"@"SEL$1")]]></hint><hint><![CDATA[OUTLINE_LEAF(@"SEL$1")]]></hint><hint><![CDATA[ALL_ROWS]]></hint><hint><![CDATA[OPTIMIZER_FEATURES_ENABLE('10.2.0.1')]]></hint><hint><![CDATA[IGNORE_OPTIM_EMBEDDED_HINTS]]></hint></outline_data></remarks>	TABLE ACCESS	FULL	\N	CLINLIMS	CITY_STATE_ZIP	CITY_STATE_ZIP@SEL$1	1	TABLE	ANALYZED	\N	1	0	1	1	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	"CITY_STATE_ZIP"."ID"[NUMBER,22], "CITY_STATE_ZIP"."CITY"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE"[VARCHAR2,2], "CITY_STATE_ZIP"."ZIP_CODE"[VARCHAR2,10], "CITY_STATE_ZIP"."COUNTY_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."COUNTY"[VARCHAR2,25], "CITY_STATE_ZIP"."REGION_ID"[NUMBER,22], "CITY_STATE_ZIP"."REGION"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."STATE_NAME"[VARCHAR2,30], "CITY_STATE_ZIP"."LASTUPDATED"[TIMESTAMP,11]	3	SEL$1
7146420525171748	1	2008-05-08 14:33:14	\N	SELECT STATEMENT	\N	\N	\N	\N	\N	\N	\N	ALL_ROWS	\N	0	\N	0	238	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	\N	3	\N
7146420525171748	1	2008-05-08 14:33:14	<remarks><info type="db_version">10.2.0.1</info><info type="parse_schema"><![CDATA["CLINLIMS"]]></info><info type="plan_hash">288471584</info><outline_data><hint><![CDATA[FULL(@"SEL$1" "CITY_STATE_ZIP"@"SEL$1")]]></hint><hint><![CDATA[OUTLINE_LEAF(@"SEL$1")]]></hint><hint><![CDATA[ALL_ROWS]]></hint><hint><![CDATA[OPTIMIZER_FEATURES_ENABLE('10.2.0.1')]]></hint><hint><![CDATA[IGNORE_OPTIM_EMBEDDED_HINTS]]></hint></outline_data></remarks>	TABLE ACCESS	FULL	\N	CLINLIMS	CITY_STATE_ZIP	CITY_STATE_ZIP@SEL$1	1	TABLE	ANALYZED	\N	1	0	1	1	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	"CITY_STATE_ZIP"."ID"[NUMBER,22], "CITY_STATE_ZIP"."CITY"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE"[VARCHAR2,2], "CITY_STATE_ZIP"."ZIP_CODE"[VARCHAR2,10], "CITY_STATE_ZIP"."COUNTY_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."COUNTY"[VARCHAR2,25], "CITY_STATE_ZIP"."REGION_ID"[NUMBER,22], "CITY_STATE_ZIP"."REGION"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."STATE_NAME"[VARCHAR2,30], "CITY_STATE_ZIP"."LASTUPDATED"[TIMESTAMP,11]	3	SEL$1
7146722603172428	2	2008-05-08 14:33:20	\N	SELECT STATEMENT	\N	\N	\N	\N	\N	\N	\N	ALL_ROWS	\N	0	\N	0	238	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	\N	3	\N
7146722603172428	2	2008-05-08 14:33:20	<remarks><info type="db_version">10.2.0.1</info><info type="parse_schema"><![CDATA["CLINLIMS"]]></info><info type="plan_hash">288471584</info><outline_data><hint><![CDATA[FULL(@"SEL$1" "CITY_STATE_ZIP"@"SEL$1")]]></hint><hint><![CDATA[OUTLINE_LEAF(@"SEL$1")]]></hint><hint><![CDATA[ALL_ROWS]]></hint><hint><![CDATA[OPTIMIZER_FEATURES_ENABLE('10.2.0.1')]]></hint><hint><![CDATA[IGNORE_OPTIM_EMBEDDED_HINTS]]></hint></outline_data></remarks>	TABLE ACCESS	FULL	\N	CLINLIMS	CITY_STATE_ZIP	CITY_STATE_ZIP@SEL$1	1	TABLE	ANALYZED	\N	1	0	1	1	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	"CITY_STATE_ZIP"."ID"[NUMBER,22], "CITY_STATE_ZIP"."CITY"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE"[VARCHAR2,2], "CITY_STATE_ZIP"."ZIP_CODE"[VARCHAR2,10], "CITY_STATE_ZIP"."COUNTY_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."COUNTY"[VARCHAR2,25], "CITY_STATE_ZIP"."REGION_ID"[NUMBER,22], "CITY_STATE_ZIP"."REGION"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."STATE_NAME"[VARCHAR2,30], "CITY_STATE_ZIP"."LASTUPDATED"[TIMESTAMP,11]	3	SEL$1
7146420525171748	1	2008-05-08 14:33:14	\N	SELECT STATEMENT	\N	\N	\N	\N	\N	\N	\N	ALL_ROWS	\N	0	\N	0	238	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	\N	3	\N
7146420525171748	1	2008-05-08 14:33:14	<remarks><info type="db_version">10.2.0.1</info><info type="parse_schema"><![CDATA["CLINLIMS"]]></info><info type="plan_hash">288471584</info><outline_data><hint><![CDATA[FULL(@"SEL$1" "CITY_STATE_ZIP"@"SEL$1")]]></hint><hint><![CDATA[OUTLINE_LEAF(@"SEL$1")]]></hint><hint><![CDATA[ALL_ROWS]]></hint><hint><![CDATA[OPTIMIZER_FEATURES_ENABLE('10.2.0.1')]]></hint><hint><![CDATA[IGNORE_OPTIM_EMBEDDED_HINTS]]></hint></outline_data></remarks>	TABLE ACCESS	FULL	\N	CLINLIMS	CITY_STATE_ZIP	CITY_STATE_ZIP@SEL$1	1	TABLE	ANALYZED	\N	1	0	1	1	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	"CITY_STATE_ZIP"."ID"[NUMBER,22], "CITY_STATE_ZIP"."CITY"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE"[VARCHAR2,2], "CITY_STATE_ZIP"."ZIP_CODE"[VARCHAR2,10], "CITY_STATE_ZIP"."COUNTY_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."COUNTY"[VARCHAR2,25], "CITY_STATE_ZIP"."REGION_ID"[NUMBER,22], "CITY_STATE_ZIP"."REGION"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."STATE_NAME"[VARCHAR2,30], "CITY_STATE_ZIP"."LASTUPDATED"[TIMESTAMP,11]	3	SEL$1
7146722603172428	2	2008-05-08 14:33:20	\N	SELECT STATEMENT	\N	\N	\N	\N	\N	\N	\N	ALL_ROWS	\N	0	\N	0	238	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	\N	3	\N
7146722603172428	2	2008-05-08 14:33:20	<remarks><info type="db_version">10.2.0.1</info><info type="parse_schema"><![CDATA["CLINLIMS"]]></info><info type="plan_hash">288471584</info><outline_data><hint><![CDATA[FULL(@"SEL$1" "CITY_STATE_ZIP"@"SEL$1")]]></hint><hint><![CDATA[OUTLINE_LEAF(@"SEL$1")]]></hint><hint><![CDATA[ALL_ROWS]]></hint><hint><![CDATA[OPTIMIZER_FEATURES_ENABLE('10.2.0.1')]]></hint><hint><![CDATA[IGNORE_OPTIM_EMBEDDED_HINTS]]></hint></outline_data></remarks>	TABLE ACCESS	FULL	\N	CLINLIMS	CITY_STATE_ZIP	CITY_STATE_ZIP@SEL$1	1	TABLE	ANALYZED	\N	1	0	1	1	238	79529	5726088	\N	\N	\N	\N	\N	\N	33895495	232	\N	\N	\N	"CITY_STATE_ZIP"."ID"[NUMBER,22], "CITY_STATE_ZIP"."CITY"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE"[VARCHAR2,2], "CITY_STATE_ZIP"."ZIP_CODE"[VARCHAR2,10], "CITY_STATE_ZIP"."COUNTY_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."COUNTY"[VARCHAR2,25], "CITY_STATE_ZIP"."REGION_ID"[NUMBER,22], "CITY_STATE_ZIP"."REGION"[VARCHAR2,30], "CITY_STATE_ZIP"."STATE_FIPS"[NUMBER,22], "CITY_STATE_ZIP"."STATE_NAME"[VARCHAR2,30], "CITY_STATE_ZIP"."LASTUPDATED"[TIMESTAMP,11]	3	SEL$1
\.


--
-- Data for Name: import_status; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY import_status (id, original_file_name, saved_file_name, error_file_name, type, status, successful_records, failed_records, stage_name, uploaded_by, start_time, end_time, stack_trace) FROM stdin;
\.


--
-- Name: import_status_id_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('import_status_id_seq', 1, false);


--
-- Data for Name: instrument; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY instrument (id, scrip_id, name, description, instru_type, is_active, location) FROM stdin;
\.


--
-- Data for Name: instrument_analyte; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY instrument_analyte (id, analyte_id, instru_id, method_id, result_group) FROM stdin;
\.


--
-- Data for Name: instrument_log; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY instrument_log (id, instru_id, instlog_type, event_begin, event_end) FROM stdin;
\.


--
-- Data for Name: inventory_component; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY inventory_component (id, invitem_id, quantity, material_component_id) FROM stdin;
\.


--
-- Data for Name: inventory_item; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY inventory_item (id, uom_id, name, description, quantity_min_level, quantity_max_level, quantity_to_reorder, is_reorder_auto, is_lot_maintained, is_active, average_lead_time, average_cost, average_daily_use) FROM stdin;
20	\N	HIV testKit	HIV	\N	\N	\N	\N	\N	N	\N	\N	\N
21	\N	SyphlisTK	SYPHILIS	\N	\N	\N	\N	\N	N	\N	\N	\N
\.


--
-- Name: inventory_item_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('inventory_item_seq', 21, true);


--
-- Data for Name: inventory_location; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY inventory_location (id, storage_id, lot_number, quantity_onhand, expiration_date, inv_item_id) FROM stdin;
19	\N	1	\N	2011-08-12 00:00:00	20
20	\N	1	\N	\N	21
\.


--
-- Name: inventory_location_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('inventory_location_seq', 20, true);


--
-- Data for Name: inventory_receipt; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY inventory_receipt (id, invitem_id, received_date, quantity_received, unit_cost, qc_reference, external_reference, org_id) FROM stdin;
\.


--
-- Name: inventory_receipt_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('inventory_receipt_seq', 20, true);


--
-- Data for Name: lab_order_item; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY lab_order_item (id, lab_order_type_id, table_ref, record_id, identifier, action, lastupdated) FROM stdin;
\.


--
-- Name: lab_order_item_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('lab_order_item_seq', 1, false);


--
-- Data for Name: lab_order_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY lab_order_type (id, domain, type, context, description, sort_order, lastupdated, display_key) FROM stdin;
\.


--
-- Name: lab_order_type_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('lab_order_type_seq', 1, false);


--
-- Data for Name: label; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY label (id, name, description, printer_type, scriptlet_id, lastupdated) FROM stdin;
62	MOLECULAR EPI - TEST	TEST LABEL FOR MOLECULAR EPIDEMIOLOGY	P	13	2008-05-01 21:25:56.575
65	labelname1	labeldescr1	P	12	2006-11-20 15:31:47
68	testa	test	t	11	2006-12-13 10:06:03.873
69	testb	test	t	12	2006-12-13 10:05:58.435
70	testc	test	t	12	2006-12-13 10:05:43.107
60	Diane Test	Diane Test	P	11	2008-05-01 21:26:17.387
61	VIROLOGY-TEST	TEST LABELS FOR VIROLOGY	P	12	2006-09-07 08:06:40
71	12	12	1	11	2006-12-13 10:56:53.37
67	test	test	t	12	2006-12-13 10:05:04.56
64	NO LABEL	NO LABEL	P	\N	2006-10-25 08:09:35
66	Label Name 2	Label Desc 2	P	13	2008-05-05 23:13:30.414
1	aaa	aaa	\N	\N	2007-10-11 09:33:32.059
2	a	a	\N	\N	2007-10-10 16:45:24.842
\.


--
-- Name: label_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('label_seq', 3, false);


--
-- Data for Name: login_user; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY login_user (id, login_name, password, password_expired_dt, account_locked, account_disabled, is_admin, user_time_out) FROM stdin;
130	user	FVSAQzka8nEbrZUyGU3iTQ==	2021-02-14	N	N	N	480
1	admin	n2OrWHXVm/BQsgd1YZJoCA==	2020-04-02	N	N	Y	220
148	atomfeed	SyPE4ibAjS4D3vOsEyjisw==	2036-05-02	N	N	N	120
\.


--
-- Name: login_user_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('login_user_seq', 148, true);


--
-- Data for Name: markers; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY markers (id, feed_uri_for_last_read_entry, feed_uri, last_read_entry_id) FROM stdin;
\.


--
-- Name: markers_id_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('markers_id_seq', 6, true);


--
-- Data for Name: menu; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY menu (id, parent_id, presentation_order, element_id, action_url, click_action, display_key, tool_tip_key, new_window) FROM stdin;
107	\N	1	menu_home	/Dashboard.do	\N	banner.menu.home	tooltip.bannner.menu.home	f
109	108	1	menu_sample_add	/SamplePatientEntry.do	\N	banner.menu.sampleAdd	tooltip.bannner.menu.sampleAdd	f
110	108	2	menu_sample_edit	/SampleEdit.do?type=readwrite	\N	banner.menu.sampleEdit	tooltip.banner.menu.sampleEdit	f
112	111	1	menu_patient_add_or_edit	/PatientManagement.do	\N	banner.menu.patient.addOrEdit	tooltip.banner.menu.patient.addOrEdit	f
145	144	1	menu_results_patient	/PatientResults.do	\N	banner.menu.results.patient	tooltip.banner.menu.results.patient	f
146	144	2	menu_results_accession	/AccessionResults.do	\N	banner.menu.results.accession	tooltip.banner.menu.results.accession	f
147	144	3	menu_results_status	/StatusResults.do?blank=true	\N	banner.menu.results.status	tooltip.banner.menu.results.status	f
144	130	1	menu_results_search	\N	\N	banner.menu.results.search	tooltip.banner.menu.results.search	f
163	162	1	menu_reports_status	\N	\N	openreports.statusreports.title	tooltip.openreports.statusreports.title	f
164	163	1	menu_reports_status_patient	/Report.do?type=patient&report=patientHaitiClinical	\N	openreports.patientTestStatus	tooltip.openreports.patientTestStatus	f
168	162	3	menu_reports_nonconformity	\N	\N	reports.nonConformity.menu	tooltip.reports.nonConformity.menu	f
169	168	1	menu_reports_nonconformity_date	/Report.do?type=patient&report=haitiClinicalNonConformityByDate	\N	reports.nonConformity.byDate.report	tooltip.reports.nonConformity.byDate.report	f
170	168	2	menu_reports_nonconformity_section	/Report.do?type=patient&report=haitiClinicalNonConformityBySectionReason	\N	reports.nonConformity.bySectionReason.report	tooltip.reports.nonConformity.bySectionReason.report	f
171	162	5	menu_reports_auditTrail	/AuditTrailReport.do	\N	reports.auditTrail	reports.auditTrail	f
174	148	200	menu_resultvalidation_All	/ResultValidation.do?type=All+Sections&test=	\N	banner.menu.resultvalidation.AllSections	banner.menu.resultvalidation.AllSections	f
108	\N	3	menu_sample	\N	\N	banner.menu.sample	tooltip.bannner.menu.sample	f
111	\N	4	menu_patient	\N	\N	banner.menu.patient	tooltip.bannner.menu.patient	f
113	\N	5	menu_nonconformity	/NonConformity.do	\N	banner.menu.nonconformity	tooltip.banner.menu.nonconformity	f
130	\N	7	menu_results	\N	\N	banner.menu.results	tooltip.bannner.menu.results	f
148	\N	8	menu_resultvalidation	\N	\N	banner.menu.resultvalidation	tooltip.banner.menu.resultvalidation	f
162	\N	10	menu_reports	\N	\N	banner.menu.reports	tooltip.banner.menu.reports	f
172	\N	11	menu_administration	/MasterListsPage.do	\N	banner.menu.administration	tooltip.banner.menu.administration	f
173	\N	12	menu_help	/documentation/HaitiClinical_fr.pdf	\N	banner.menu.help	tooltip.banner.menu.help	t
175	\N	2	menu_labDashboard	/LabDashboard.do	\N	banner.menu.labdashboard	tooltip.banner.menu.labdashboard	f
176	\N	10	blah	/Upload.do	\N	banner.menu.upload	banner.menu.upload	f
178	162	2	menu_reports_aggregate	\N	\N	openreports.aggregate.title	tooltip.openreports.aggregate.title	f
179	178	2	menu_reports_aggregate_all	/Report.do?type=indicator&report=indicatorHaitiClinicalAllTests	\N	openreports.all.tests.aggregate	tooltip.openreports.all.tests.aggregate	f
177	130	3	menu_results_referredOut	/ReferredOutTests.do	\N	banner.menu.referredOut	tooltip.banner.menu.referredOut	f
180	130	2	menu_results_logbook	\N	\N	banner.menu.results.logbook	tooltip.banner.menu.results.logbook	f
\.


--
-- Name: menu_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('menu_seq', 180, true);


--
-- Data for Name: message_org; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY message_org (id, org_id, is_active, active_begin, active_end, description, lastupdated) FROM stdin;
\.


--
-- Name: message_org_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('message_org_seq', 41, false);


--
-- Name: messagecontrolidseq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('messagecontrolidseq', 1, false);


--
-- Data for Name: method; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY method (id, name, description, reporting_description, is_active, active_begin, active_end, lastupdated) FROM stdin;
1	EIA 	Enzyme-linked immunoassay	EIA 	Y	2007-04-24 00:00:00	\N	2007-04-24 13:46:47.063
31	PCR	Polymerase Chain Reaction	\N	Y	2006-09-18 00:00:00	\N	2006-09-29 14:32:51
32	STAIN	Stain	\N	Y	2006-09-29 00:00:00	\N	2006-09-29 14:32:57
33	CULTURE	Culture	\N	Y	2006-09-29 00:00:00	\N	2006-11-01 08:10:49.606
34	PROBE	Probe	\N	Y	2006-09-29 00:00:00	\N	2006-09-29 14:33:05
35	BIOCHEMICAL	Biochemical	\N	Y	2006-09-29 00:00:00	\N	2006-11-08 09:16:24.377
27	Diane Test	Diane Test	\N	Y	2006-09-06 00:00:00	\N	2006-10-23 15:35:39.534
36	HPLC	High Pressure Liquid Chromatography	\N	Y	2006-09-29 00:00:00	\N	2006-09-29 14:31:50
37	DNA SEQUENCING	DNA Sequencing	\N	Y	2006-09-29 00:00:00	\N	2006-10-23 15:35:40.691
3	AUTO	Automated (Haiti)		Y	2009-02-24 00:00:00	\N	2009-02-24 16:26:17.507
4	MANUAL	test done manually (Haiti)		Y	2009-02-24 00:00:00	\N	2009-02-24 16:26:47.604
5	HIV_TEST_KIT	Uses Hiv test kit		Y	2009-03-05 00:00:00	\N	2009-03-05 14:26:19.46
6	SYPHILIS_TEST_KIT	Test kit for syphilis		Y	2009-03-05 00:00:00	\N	2009-03-05 14:28:11.61
\.


--
-- Data for Name: method_analyte; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY method_analyte (id, method_id, analyte_id, result_group, sort_order, ma_type) FROM stdin;
\.


--
-- Data for Name: method_result; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY method_result (id, scrip_id, result_group, flags, methres_type, value, quant_limit, cont_level, method_id) FROM stdin;
\.


--
-- Name: method_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('method_seq', 6, true);


--
-- Data for Name: mls_lab_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY mls_lab_type (id, description, org_mlt_org_mlt_id) FROM stdin;
\.


--
-- Data for Name: note; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY note (id, sys_user_id, reference_id, reference_table, note_type, subject, text, lastupdated) FROM stdin;
\.


--
-- Name: note_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('note_seq', 140, true);


--
-- Data for Name: observation_history; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY observation_history (id, patient_id, sample_id, observation_history_type_id, value_type, value, lastupdated, sample_item_id) FROM stdin;
\.


--
-- Name: observation_history_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('observation_history_seq', 1, false);


--
-- Data for Name: observation_history_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY observation_history_type (id, type_name, description, lastupdated) FROM stdin;
1	initialSampleCondition	The condition of the sample when it was delievered to the lab	2011-02-16 22:48:42.513601+00
2	paymentStatus	The payment status of the patient	2012-04-24 00:30:14.756638+00
\.


--
-- Name: observation_history_type_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('observation_history_type_seq', 2, true);


--
-- Data for Name: occupation; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY occupation (id, occupation, lastupdated) FROM stdin;
\.


--
-- Name: occupation_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('occupation_seq', 1, false);


--
-- Data for Name: or_properties; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY or_properties (property_id, property_key, property_value) FROM stdin;
1870	base.directory	/usr/share/tomcat5.5/webapps/openreports/reports/
1871	temp.directory	/usr/share/tomcat5.5/webapps/openreports/temp/
1872	report.generation.directory	/usr/share/tomcat5.5/webapps/openreports/generatedreports/
1873	date.format	dd/MM/yyyy
1874	mail.auth.password	barLAC28
1875	mail.auth.user	admin
1876	mail.smtp.auth	false
1877	mail.smtp.host	
1878	xmla.catalog	
1879	xmla.datasource	
1880	xmla.uri	
\.


--
-- Data for Name: or_tags; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY or_tags (tag_id, tagged_object_id, tagged_object_class, tag_value, tag_type) FROM stdin;
\.


--
-- Data for Name: order_item; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY order_item (id, ord_id, quantity_requested, quantity_received, inv_loc_id) FROM stdin;
\.


--
-- Data for Name: orders; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY orders (id, org_id, sys_user_id, ordered_date, neededby_date, requested_by, cost_center, shipping_type, shipping_carrier, shipping_cost, delivered_date, is_external, external_order_number, is_filled) FROM stdin;
\.


--
-- Data for Name: org_hl7_encoding_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY org_hl7_encoding_type (organization_id, encoding_type_id, lastupdated) FROM stdin;
\.


--
-- Data for Name: org_mls_lab_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY org_mls_lab_type (org_id, mls_lab_id, org_mlt_id) FROM stdin;
\.


--
-- Data for Name: organization; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY organization (id, name, city, zip_code, mls_sentinel_lab_flag, org_mlt_org_mlt_id, org_id, short_name, multiple_unit, street_address, state, internet_address, clia_num, pws_id, lastupdated, mls_lab_flag, is_active, local_abbrev) FROM stdin;
3	Haiti	Seattle	98103	N	\N	\N			DNA	WA			\N	2008-11-20 13:48:42.141	N	Y	22
1283	External Lab	\N	\N	N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Y	\N
1284	Bahmni	\N	\N	N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	Y	\N
\.


--
-- Data for Name: organization_address; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY organization_address (organization_id, address_part_id, type, value) FROM stdin;
\.


--
-- Data for Name: organization_contact; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY organization_contact (id, organization_id, person_id, "position") FROM stdin;
\.


--
-- Name: organization_contact_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('organization_contact_seq', 1, false);


--
-- Data for Name: organization_organization_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY organization_organization_type (org_id, org_type_id) FROM stdin;
1283	3
\.


--
-- Name: organization_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('organization_seq', 1284, true);


--
-- Data for Name: organization_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY organization_type (id, short_name, description, name_display_key, lastupdated) FROM stdin;
1	TestKitVender	Organization selling HIV test kits	db.organization.type.name.testkit	2009-12-17 12:07:12.477554
3	referralLab	An organization to which samples may be sent	orgainzation.type.referral.lab	2010-11-23 10:30:22.117828
4	referring clinic	Name of org who can order lab tests	organization.type.referral.in.lab	2011-02-16 14:46:31.32568
5	resultRequester	An organization which can request lab results	org_type.resultRequester	2012-04-23 17:30:16.500759
\.


--
-- Name: organization_type_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('organization_type_seq', 5, true);


--
-- Data for Name: package_1; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY package_1 (id) FROM stdin;
\.


--
-- Data for Name: panel; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY panel (id, name, description, lastupdated, display_key, sort_order, is_active) FROM stdin;
86	Demande de Transfusion Sanguine(Blood Transfusion Request)	Demande de Transfusion Sanguine(Blood Transfusion Request)	2018-01-05 15:53:11.821	\N	46	Y
91	LCR (Panel)	LCR (Panel)	2018-01-05 15:53:11.861	\N	55	Y
87	CD4 (Panel)	CD4 (Panel)	2018-01-05 15:53:12.048	\N	47	Y
88	Ionogramme	Ionogramme	2018-01-05 15:53:12.081	\N	49	Y
93	Biochimie	Biochimie	2018-01-05 15:53:12.133	\N	48	Y
89	Bilan post hepatique (ANALYSIS DONE AT EXTERNAL FACILITY)	Bilan post hepatique (ANALYSIS DONE AT EXTERNAL FACILITY)	2018-01-05 15:53:12.177	\N	50	Y
90	Selles (Panel)	Selles (Panel)	2018-01-05 15:53:12.229	\N	51	Y
92	Urine bandelette	Urine bandelette	2018-01-05 15:53:12.269	\N	70	Y
85	Hemogramme	Hemogramme	2018-01-05 15:53:12.375	\N	45	Y
\.


--
-- Data for Name: panel_item; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY panel_item (id, panel_id, sort_order, test_local_abbrev, method_name, lastupdated, test_name, test_id) FROM stdin;
570	86	1	Groupage sanguin ABO	\N	2018-01-05 15:53:11.843	\N	797
571	86	2	Groupage sanguin Rhesus	\N	2018-01-05 15:53:11.848	\N	798
572	86	3	Test de compatibilité	\N	2018-01-05 15:53:11.853	\N	799
573	91	1	Numeration GB	\N	2018-01-05 15:53:11.941	\N	810
574	91	2	FL - LYM%	\N	2018-01-05 15:53:11.946	\N	811
575	91	3	FL - MXD%	\N	2018-01-05 15:53:11.951	\N	812
576	91	4	FL - NEUT%	\N	2018-01-05 15:53:11.956	\N	813
577	91	5	Crag	\N	2018-01-05 15:53:11.961	\N	814
578	91	6	Encre de chine	\N	2018-01-05 15:53:11.966	\N	815
579	91	7	Proteinorachie (test de Pandy)	\N	2018-01-05 15:53:11.982	\N	816
580	91	8	Gram	\N	2018-01-05 15:53:11.993	\N	817
581	91	9	(If positif) Forme	\N	2018-01-05 15:53:11.999	\N	818
582	91	10	(If positif) Coloration	\N	2018-01-05 15:53:12.008	\N	819
583	91	11	(If positif) Groupement	\N	2018-01-05 15:53:12.013	\N	820
584	91	12	Microscopie TB - Recherche de BAAR (LCR)	\N	2018-01-05 15:53:12.018	\N	846
585	91	13	Glycorachie	\N	2018-01-05 15:53:12.034	\N	821
586	91	14	GeneXpert TB (LCR)	\N	2018-01-05 15:53:12.039	\N	868
587	87	1	CD4	\N	2018-01-05 15:53:12.065	\N	801
588	87	2	CD4 % (enfants de - 5 ans)	\N	2018-01-05 15:53:12.071	\N	802
589	88	1	sodium	\N	2018-01-05 15:53:12.107	\N	832
590	88	2	potassium	\N	2018-01-05 15:53:12.113	\N	833
591	88	3	Chlore	\N	2018-01-05 15:53:12.125	\N	834
592	93	1	Creatinine	\N	2018-01-05 15:53:12.153	\N	803
593	93	2	GPT	\N	2018-01-05 15:53:12.158	\N	804
594	93	3	Glycémie	\N	2018-01-05 15:53:12.165	\N	805
595	89	1	Bilirubine totalE	\N	2018-01-05 15:53:12.203	\N	872
596	89	2	Bilirubine directE	\N	2018-01-05 15:53:12.209	\N	873
597	89	3	Gamma GT	\N	2018-01-05 15:53:12.216	\N	844
598	89	4	Phosphatase alcaline	\N	2018-01-05 15:53:12.221	\N	845
599	90	1	Selles Directs - KOP	\N	2018-01-05 15:53:12.25	\N	807
600	90	2	Selles Directs - Type	\N	2018-01-05 15:53:12.255	\N	808
601	90	3	Selles I.O	\N	2018-01-05 15:53:12.261	\N	809
602	92	1	Sang (hématurie)	\N	2018-01-05 15:53:12.316	\N	869
603	92	2	Urobilinogène	\N	2018-01-05 15:53:12.321	\N	822
604	92	3	Bilirubine	\N	2018-01-05 15:53:12.327	\N	823
605	92	4	Protéines	\N	2018-01-05 15:53:12.333	\N	824
606	92	5	Nitrites	\N	2018-01-05 15:53:12.338	\N	825
607	92	6	Corps cétoniques	\N	2018-01-05 15:53:12.344	\N	826
608	92	7	Acide ascorbique	\N	2018-01-05 15:53:12.349	\N	827
609	92	8	Glucose	\N	2018-01-05 15:53:12.355	\N	828
610	92	9	pH	\N	2018-01-05 15:53:12.361	\N	829
611	92	10	Leucocytes	\N	2018-01-05 15:53:12.367	\N	830
612	85	1	Globules Blancs	\N	2018-01-05 15:53:12.423	\N	784
613	85	2	Globules Rouges	\N	2018-01-05 15:53:12.429	\N	785
614	85	3	Hemoglobine	\N	2018-01-05 15:53:12.435	\N	840
615	85	4	Hematocrite	\N	2018-01-05 15:53:12.441	\N	786
616	85	5	VGM	\N	2018-01-05 15:53:12.447	\N	787
617	85	6	CCMH	\N	2018-01-05 15:53:12.452	\N	788
618	85	7	Plaquettes	\N	2018-01-05 15:53:12.458	\N	789
619	85	8	LYM%	\N	2018-01-05 15:53:12.464	\N	790
620	85	9	MXD% (Eosino+Monocytes)	\N	2018-01-05 15:53:12.47	\N	791
621	85	10	NEUT%	\N	2018-01-05 15:53:12.476	\N	792
\.


--
-- Name: panel_item_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('panel_item_seq', 621, true);


--
-- Name: panel_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('panel_seq', 93, true);


--
-- Data for Name: patient; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY patient (id, person_id, race, gender, birth_date, epi_first_name, epi_middle_name, epi_last_name, birth_time, death_date, national_id, ethnicity, school_attend, medicare_id, medicaid_id, birth_place, lastupdated, external_id, chart_number, entered_birth_date, uuid) FROM stdin;
\.


--
-- Data for Name: patient_identity; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY patient_identity (id, identity_type_id, patient_id, identity_data, lastupdated) FROM stdin;
\.


--
-- Name: patient_identity_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('patient_identity_seq', 19, true);


--
-- Data for Name: patient_identity_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY patient_identity_type (id, identity_type, description, lastupdated) FROM stdin;
2	ST	ST Number	2008-11-05 10:36:39.615
3	AKA	Also known as name	2008-11-05 10:36:39.615
4	MOTHER	Mothers name	2008-11-05 10:36:39.615
1	NATIONAL	National ID	2008-11-05 10:36:39.615
5	INSURANCE	Primary insurance number	\N
6	OCCUPATION	patients occupation	\N
9	SUBJECT	Subject Number	2010-01-06 12:56:16.166813
8	ORG_SITE	Organization Site	2010-01-06 12:56:39.622399
11	MOTHERS_INITIAL	Initial of mothers first name	2010-03-15 13:15:08.22301
14	GUID	\N	2011-03-10 13:25:23.644
30	EDUCATION	Patients education level	2013-08-08 08:02:34.866733
31	MARITIAL	Patients maritial status	2013-08-08 08:02:34.866733
32	NATIONALITY	Patients nationality	2013-08-08 08:02:34.866733
33	OTHER NATIONALITY	Named nationality if OTHER is selected	2013-08-08 08:02:34.866733
34	HEALTH DISTRICT	Patients health district	2013-08-08 08:02:34.866733
35	HEALTH REGION	Patients health region	2013-08-08 08:02:34.866733
36	PRIMARYRELATIVE	Father's/Husband's name	2017-12-26 13:07:50.4833
\.


--
-- Name: patient_identity_type_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('patient_identity_type_seq', 36, true);


--
-- Data for Name: patient_occupation; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY patient_occupation (id, patient_id, occupation, lastupdated) FROM stdin;
\.


--
-- Name: patient_occupation_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('patient_occupation_seq', 1, false);


--
-- Data for Name: patient_patient_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY patient_patient_type (id, patient_type_id, patient_id, lastupdated) FROM stdin;
\.


--
-- Name: patient_patient_type_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('patient_patient_type_seq', 2, true);


--
-- Name: patient_relation_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('patient_relation_seq', 1, false);


--
-- Data for Name: patient_relations; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY patient_relations (id, pat_id_source, pat_id, relation) FROM stdin;
\.


--
-- Name: patient_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('patient_seq', 15, true);


--
-- Data for Name: patient_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY patient_type (id, type, description, lastupdated) FROM stdin;
1	R	Referré	2009-07-09 13:06:10.215545
2	E	Patient Externe	2009-07-09 13:06:10.215545
3	H	Hospitalisé	2009-07-09 13:06:10.215545
4	U	Urgences	2009-07-09 13:06:10.215545
5	P	Patient Privé	2009-07-09 13:06:10.215545
\.


--
-- Name: patient_type_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('patient_type_seq', 20, true);


--
-- Data for Name: payment_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY payment_type (id, type, description) FROM stdin;
\.


--
-- Name: payment_type_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('payment_type_seq', 1, false);


--
-- Data for Name: person; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY person (id, last_name, first_name, middle_name, multiple_unit, street_address, city, state, zip_code, country, work_phone, home_phone, cell_phone, fax, email, lastupdated, is_active) FROM stdin;
13	UNKNOWN_	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:46.216	\N
\.


--
-- Data for Name: person_address; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY person_address (person_id, address_part_id, type, value) FROM stdin;
\.


--
-- Name: person_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('person_seq', 16, true);


--
-- Data for Name: program; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY program (id, code, name, lastupdated) FROM stdin;
\.


--
-- Name: program_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('program_seq', 1, false);


--
-- Data for Name: project; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY project (id, name, sys_user_id, description, started_date, completed_date, is_active, reference_to, program_code, lastupdated, scriptlet_id, local_abbrev, display_key) FROM stdin;
\.


--
-- Data for Name: project_organization; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY project_organization (project_id, org_id) FROM stdin;
\.


--
-- Data for Name: project_parameter; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY project_parameter (id, projparam_type, operation, value, project_id, param_name) FROM stdin;
\.


--
-- Name: project_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('project_seq', 13, false);


--
-- Data for Name: provider; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY provider (id, npi, person_id, external_id, provider_type, lastupdated) FROM stdin;
6	\N	13	\N	\N	2018-01-05 15:53:46.22
\.


--
-- Name: provider_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('provider_seq', 6, true);


--
-- Data for Name: qa_event; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qa_event (id, name, description, is_billable, reporting_sequence, reporting_text, test_id, is_holdable, lastupdated, type, category, display_key) FROM stdin;
67	Insufficient	Insufficient sample	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.insufficient
68	Hemolytic	Hemolytic sample	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.hemolytic
69	Mislabeled	Bad or mislabled sample	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.mislabled
70	No form	 No form with sample	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.noForm
71	Incorrect Form	Form not filled out correctly	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.formNotCorrect
72	No Sample	No sample with form	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.noSample
73	Bloodstained Tube	Bloodstained tube	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.bloodstained.tube
74	Bloodstained Form	Bloodstained form	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.bloodstained.form
75	Other	Other	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.other
76	Broken	Broken tube/container	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.broken
77	Contaminated	Contaminated sample	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.contaminated
78	Frozen	Frozen sample	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.frozen
79	Inadequate	Inadequate sample	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.inadequate
80	unrefrigerated	unrefrigerated sample	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.unrefrigerated
81	Overturned	Overturned specimen	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.overturned
66	Coagulated	Coagulated sample	\N	\N	\N	\N	Y	2012-04-23 17:30:24.343465	\N	\N	qa_event.coagulated
\.


--
-- Name: qa_event_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('qa_event_seq', 85, true);


--
-- Data for Name: qa_observation; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qa_observation (id, observed_id, observed_type, qa_observation_type_id, value_type, value, lastupdated) FROM stdin;
\.


--
-- Name: qa_observation_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('qa_observation_seq', 1, true);


--
-- Data for Name: qa_observation_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qa_observation_type (id, name, description, lastupdated) FROM stdin;
1	authorizer	The name of the person who authorized the event	2013-08-08 08:02:34.982965+00
2	section	The section in which this happened	2013-08-08 08:02:34.982965+00
3	documentNumber	The qa document tracking number	2013-08-08 08:02:34.982965+00
\.


--
-- Name: qa_observation_type_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('qa_observation_type_seq', 3, true);


--
-- Data for Name: qc; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qc (id, uom_id, sys_user_id, name, source, lot_number, prepared_date, prepared_volume, usable_date, expire_date) FROM stdin;
\.


--
-- Data for Name: qc_analytes; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qc_analytes (id, qcanaly_type, value, analyte_id) FROM stdin;
\.


--
-- Data for Name: qrtz_blob_triggers; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qrtz_blob_triggers (trigger_name, trigger_group, blob_data) FROM stdin;
\.


--
-- Data for Name: qrtz_calendars; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qrtz_calendars (calendar_name, calendar) FROM stdin;
\.


--
-- Data for Name: qrtz_cron_triggers; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qrtz_cron_triggers (trigger_name, trigger_group, cron_expression, time_zone_id) FROM stdin;
\.


--
-- Data for Name: qrtz_fired_triggers; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qrtz_fired_triggers (entry_id, trigger_name, trigger_group, is_volatile, instance_name, fired_time, priority, state, job_name, job_group, is_stateful, requests_recovery) FROM stdin;
\.


--
-- Data for Name: qrtz_job_details; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qrtz_job_details (job_name, job_group, description, job_class_name, is_durable, is_volatile, is_stateful, requests_recovery, job_data) FROM stdin;
\.


--
-- Data for Name: qrtz_job_listeners; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qrtz_job_listeners (job_name, job_group, job_listener) FROM stdin;
\.


--
-- Data for Name: qrtz_locks; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qrtz_locks (lock_name) FROM stdin;
TRIGGER_ACCESS
JOB_ACCESS
CALENDAR_ACCESS
STATE_ACCESS
MISFIRE_ACCESS
\.


--
-- Data for Name: qrtz_paused_trigger_grps; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qrtz_paused_trigger_grps (trigger_group) FROM stdin;
\.


--
-- Data for Name: qrtz_scheduler_state; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qrtz_scheduler_state (instance_name, last_checkin_time, checkin_interval) FROM stdin;
\.


--
-- Data for Name: qrtz_simple_triggers; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qrtz_simple_triggers (trigger_name, trigger_group, repeat_count, repeat_interval, times_triggered) FROM stdin;
\.


--
-- Data for Name: qrtz_trigger_listeners; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qrtz_trigger_listeners (trigger_name, trigger_group, trigger_listener) FROM stdin;
\.


--
-- Data for Name: qrtz_triggers; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY qrtz_triggers (trigger_name, trigger_group, job_name, job_group, is_volatile, description, next_fire_time, prev_fire_time, priority, trigger_state, trigger_type, start_time, end_time, calendar_name, misfire_instr, job_data) FROM stdin;
\.


--
-- Data for Name: quartz_cron_scheduler; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY quartz_cron_scheduler (id, cron_statement, last_run, active, run_if_past, name, job_name, display_key, description_key) FROM stdin;
2	never	\N	f	t	gather site indicators	gatherSiteIndicators	schedule.name.gatherSiteIndicators	schedule.description.gatherSiteIndicators
3	never	2012-05-06 09:40:00.013+00	f	t	send malaria surviellance report	sendMalariaSurviellanceReport	schedule.name.sendMalariaServiellanceReport	schedule.description.sendMalariaServiellanceReport
1	never	2012-05-06 18:11:00.004+00	f	t	send site indicators	sendSiteIndicators	schedule.name.sendSiteIndicators	schedule.description.sendSiteIndicators
12	0 0 0 1/1 * ? *	\N	t	t	atom-feed-events-offset-marker	atom-feed-events-offset-marker	schedule.name.atomFeedEventsOffsetMarker	schedule.name.atomFeedEventsOffsetMarker
7	0 0/1 * * * ?	2018-01-06 12:12:00.01+00	t	t	atom-feed-openmrs-patient-failed	atom-feed-openmrs-patient-failed	schedule.name.atomFeedOpenMRSPatient.failed	schedule.name.atomFeedOpenMRSPatient.failed
9	0/15 * * * * ?	2018-01-06 12:12:15+00	t	t	atom-feed-openmrs-encounter-failed	atom-feed-openmrs-encounter-failed	schedule.name.atomFeedOpenMRSEncounter.failed	schedule.name.atomFeedOpenMRSEncounter.failed
14	0/15 * * * * ?	2018-01-06 12:12:15+00	t	t	atom-feed-openmrs-lab-failed	atom-feed-openmrs-lab-failed	schedule.name.atomFeedOpenMRSLab.failed	schedule.name.atomFeedOpenMRSLab.failed
8	0/15 * * * * ?	2018-01-06 12:12:15+00	t	t	atom-feed-openmrs-encounter	atom-feed-openmrs-encounter	schedule.name.atomFeedOpenMRSEncounter	schedule.name.atomFeedOpenMRSEncounter
4	0/15 * * * * ?	2018-01-06 12:12:15.005+00	t	t	atom-feed-openmrs-patient	atom-feed-openmrs-patient	schedule.name.atomFeedOpenMRSPatient	schedule.name.atomFeedOpenMRSPatient
13	0/15 * * * * ?	2018-01-06 12:12:15+00	t	t	atom-feed-openmrs-lab	atom-feed-openmrs-lab	schedule.name.atomFeedOpenMRSLab	schedule.name.atomFeedOpenMRSLab
15	0/2 * * * * ?	2018-01-06 12:12:18+00	t	t	atom-feed-events-publisher	atom-feed-events-publisher	schedule.name.eventPublisher	schedule.name.eventPublisher
\.


--
-- Name: quartz_cron_scheduler_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('quartz_cron_scheduler_seq', 15, true);


--
-- Data for Name: race; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY race (id, description, race_type, is_active) FROM stdin;
\.


--
-- Data for Name: receiver_code_element; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY receiver_code_element (id, identifier, text, code_system, lastupdated, message_org_id, code_element_type_id) FROM stdin;
\.


--
-- Name: receiver_code_element_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('receiver_code_element_seq', 21, false);


--
-- Data for Name: reference_tables; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY reference_tables (id, name, keep_history, is_hl7_encoded, lastupdated) FROM stdin;
40	STATUS_OF_SAMPLE	Y	Y	\N
39	NOTE	Y	N	\N
1	SAMPLE	Y	N	\N
2	GENDER	Y	N	\N
3	SAMPLE_ORGANIZATION	Y	N	\N
4	ANALYSIS	Y	N	\N
5	TEST	Y	Y	\N
6	CITY	Y	N	\N
7	ANALYTE	Y	Y	\N
8	COUNTY	Y	N	\N
9	DICTIONARY	Y	N	\N
10	DICTIONARY_CATEGORY	Y	N	\N
11	LABEL	Y	N	\N
12	METHOD	Y	N	\N
13	PANEL	Y	N	\N
14	PANEL_ITEM	Y	N	\N
15	PATIENT	Y	N	\N
16	PERSON	Y	N	\N
17	PROGRAM	Y	N	\N
18	PROJECT	Y	N	\N
19	PROVIDER	Y	N	\N
20	REGION	Y	N	\N
21	RESULT	Y	N	\N
22	SAMPLE_DOMAIN	Y	N	\N
23	SAMPLE_ITEM	Y	N	\N
24	SAMPLE_PROJECTS	Y	N	\N
25	SCRIPTLET	Y	N	\N
26	SOURCE_OF_SAMPLE	Y	N	\N
27	STATE_CODE	Y	N	\N
28	SYSTEM_USER	Y	N	\N
29	TEST_SECTION	Y	N	\N
30	TEST_ANALYTE	Y	N	\N
31	TEST_REFLEX	Y	N	\N
32	TEST_RESULT	Y	N	\N
33	TEST_TRAILER	Y	N	\N
34	TYPE_OF_SAMPLE	Y	N	\N
35	TYPE_OF_TEST_RESULT	Y	N	\N
36	UNIT_OF_MEASURE	Y	Y	\N
37	ZIP_CODE	Y	N	\N
38	ORGANIZATION	Y	N	\N
45	SAMPLE_HUMAN	Y	N	\N
46	QA_EVENT	Y	N	\N
48	ANALYSIS_QAEVENT	Y	N	\N
47	ACTION	Y	N	\N
49	ANALYSIS_QAEVENT_ACTION	Y	N	\N
70	REFERENCE_TABLES	N	N	\N
41	CODE_ELEMENT_TYPE	Y	N	\N
42	CODE_ELEMENT_XREF	Y	N	\N
43	MESSAGE_ORG	Y	N	\N
44	RECEIVER_CODE_ELEMENT	Y	N	\N
50	LOGIN_USER	Y	N	\N
51	SYSTEM_MODULE	Y	N	\N
52	SYSTEM_USER_MODULE	Y	N	\N
53	SYSTEM_USER_SECTION	Y	N	\N
110	SAMPLE_NEWBORN	Y	N	\N
111	PATIENT_RELATIONS	Y	N	\N
112	PATIENT_IDENTITY	Y	N	\N
113	PATIENT_PATIENT_TYPE	Y	N	\N
130	PATIENT_TYPE	N	N	\N
154	RESULT_LIMITS	Y	N	2009-02-10 17:11:57.227
155	RESULT_SIGNATURE	Y	N	2009-02-20 13:05:56.666
167	INVENTORY_LOCATION	N	N	2009-03-19 12:20:50.594
168	INVENTORY_ITEM	N	N	2009-03-19 12:20:50.594
169	INVENTORY_RECEIPT	N	N	2009-03-19 12:20:50.594
171	RESULT_INVENTORY	Y	N	2009-03-25 16:20:17.301
172	SYSTEM_ROLE	Y	N	2009-05-20 09:56:52.877513
173	SYSTEM_ROLE_MODULE	Y	N	2009-06-05 11:49:44.562736
174	SYSTEM_ROLE	Y	N	2009-06-05 11:50:56.86615
175	SYSTEM_USER_ROLE	Y	N	2009-06-05 11:59:25.708258
176	SYSTEM_USER_ROLE	Y	N	2009-06-05 12:03:40.526192
177	SYSTEM_ROLE	Y	N	2009-06-05 12:04:41.627999
178	SYSTEM_USER_ROLE	Y	N	2009-06-05 12:04:48.416696
179	SYSTEM_ROLE_MODULE	Y	N	2009-06-05 12:05:01.033811
182	analyzer	Y	N	2009-11-25 15:35:31.308859
183	analyzer_results	Y	N	2009-11-25 15:35:31.569744
184	site_information	Y	N	2010-03-23 17:04:19.671634
187	observation_history_type	Y	N	2010-04-28 14:13:23.717515
186	observation_history	Y	N	2010-04-21 10:38:59.516839
185	observation_history_type	Y	N	2010-04-21 10:38:50.05707
188	SAMPLE_QAEVENT	Y	N	2010-10-28 06:12:39.992393
189	referral_reason	Y	N	2010-10-28 06:13:55.299708
190	referral_type	Y	N	2010-10-28 06:13:55.299708
191	referral	Y	N	2010-10-28 06:13:55.299708
192	referral_result	Y	N	2010-11-23 10:30:22.045552
193	org_hl7_encoding_type	Y	N	2011-03-04 16:38:48.986228
197	address_part	Y	N	2011-03-29 16:23:10.813326
198	person_address	Y	N	2011-03-29 16:23:10.813326
199	organization_address	Y	N	2011-03-29 16:23:10.813326
200	organization_contact	Y	N	2011-03-29 16:23:10.825084
201	SITE_INFORMATION_DOMAIN	Y	N	2012-04-23 17:30:07.193494
202	MENU	Y	N	2012-04-23 17:30:07.25924
203	QUARTZ_CRON_SCHEDULER	Y	N	2012-04-23 17:30:07.331733
204	REPORT_QUEUE_TYPE	Y	N	2012-04-23 17:30:07.402102
205	REPORT_QUEUE	Y	N	2012-04-23 17:30:07.424341
206	REPORT_EXTERNAL_IMPORT	Y	N	2012-04-23 17:30:07.500089
207	document_type	Y	N	2012-04-23 17:30:13.955455
208	document_track	Y	N	2012-04-23 17:30:13.955455
209	ANALYZER_TEST_MAP	Y	N	2012-04-23 17:30:14.633487
210	PATIENT_IDENTITY_TYPE	Y	N	2012-04-23 17:30:14.633487
211	SAMPLETYPE_TEST	Y	N	2012-04-23 17:30:14.633487
212	SAMPLETYPE_PANEL	Y	N	2012-04-23 17:30:14.633487
213	SAMPLE_REQUESTER	Y	N	2012-04-23 17:30:14.633487
195	TEST_CODE	Y	N	2011-03-04 16:38:48.986228
194	TEST_CODE_TYPE	Y	N	2011-03-04 16:38:48.986228
214	QA_OBSERVATION	Y	N	2013-08-08 08:02:34.962871
\.


--
-- Name: reference_tables_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('reference_tables_seq', 214, true);


--
-- Data for Name: referral; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY referral (id, analysis_id, organization_id, organization_name, send_ready_date, sent_date, result_recieved_date, referral_reason_id, referral_type_id, requester_name, lastupdated, canceled, referral_request_date) FROM stdin;
\.


--
-- Data for Name: referral_reason; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY referral_reason (id, name, description, display_key, lastupdated) FROM stdin;
1	Auto Referred Out	Auto Referred Out	referral.reason.autoReferredOut	2017-12-26 13:07:51.023819+00
\.


--
-- Name: referral_reason_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('referral_reason_seq', 1, true);


--
-- Data for Name: referral_result; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY referral_result (id, referral_id, test_id, result_id, referral_report_date, lastupdated) FROM stdin;
\.


--
-- Name: referral_result_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('referral_result_seq', 1, false);


--
-- Name: referral_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('referral_seq', 1, false);


--
-- Data for Name: referral_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY referral_type (id, name, description, display_key, lastupdated) FROM stdin;
1	Confirmation	Sent out to confirm result	referral.type.confirmation	2017-12-26 13:07:50.510489+00
\.


--
-- Name: referral_type_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('referral_type_seq', 1, true);


--
-- Data for Name: region; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY region (id, region, lastupdated) FROM stdin;
\.


--
-- Name: region_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('region_seq', 1, false);


--
-- Data for Name: report_external_export; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY report_external_export (id, event_date, collection_date, sent_date, type, data, lastupdated, send_flag, bookkeeping) FROM stdin;
\.


--
-- Data for Name: report_external_import; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY report_external_import (id, sending_site, event_date, recieved_date, type, updated_flag, data, lastupdated) FROM stdin;
\.


--
-- Name: report_external_import_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('report_external_import_seq', 1, false);


--
-- Name: report_queue_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('report_queue_seq', 124, true);


--
-- Data for Name: report_queue_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY report_queue_type (id, name, description) FROM stdin;
1	labIndicator	Lab indicator reports.  Number of tests run etc
2	Results	Result sharing with iSante
3	malariaCase	malaria case report
\.


--
-- Name: report_queue_type_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('report_queue_type_seq', 3, true);


--
-- Data for Name: requester_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY requester_type (id, requester_type) FROM stdin;
1	organization
2	provider
\.


--
-- Name: requester_type_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('requester_type_seq', 2, false);


--
-- Data for Name: result; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY result (id, analysis_id, sort_order, is_reportable, result_type, value, analyte_id, test_result_id, lastupdated, min_normal, max_normal, parent_id, abnormal, uploaded_file_name, result_limit_id) FROM stdin;
\.


--
-- Data for Name: result_inventory; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY result_inventory (id, inventory_location_id, result_id, description, lastupdated) FROM stdin;
\.


--
-- Name: result_inventory_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('result_inventory_seq', 1, false);


--
-- Data for Name: result_limits; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY result_limits (id, test_id, test_result_type_id, min_age, max_age, gender, low_normal, high_normal, low_valid, high_valid, lastupdated, normal_dictionary_id, always_validate) FROM stdin;
\.


--
-- Name: result_limits_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('result_limits_seq', 624, true);


--
-- Name: result_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('result_seq', 97, true);


--
-- Data for Name: result_signature; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY result_signature (id, result_id, system_user_id, is_supervisor, lastupdated, non_user_name) FROM stdin;
\.


--
-- Name: result_signature_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('result_signature_seq', 91, true);


--
-- Data for Name: sample; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sample (id, accession_number, package_id, domain, next_item_sequence, revision, entered_date, received_date, collection_date, client_reference, status, released_date, sticker_rcvd_flag, sys_user_id, barcode, transmission_date, lastupdated, spec_or_isolate, priority, status_id, sample_source_id, uuid) FROM stdin;
\.


--
-- Data for Name: sample_animal; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sample_animal (id, sci_name_id, comm_anim_id, sampling_location, collector, samp_id, multiple_unit, street_address, city, state, country, zip_code) FROM stdin;
\.


--
-- Data for Name: sample_domain; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sample_domain (id, domain_description, domain, lastupdated) FROM stdin;
28	ANIMAL SAMPLES	A	2006-11-08 10:58:03.229
29	ENVIRONMENTAL	E	2006-09-21 10:06:53
27	HUMAN SAMPLES	H	2006-09-21 10:06:01
2	NEWBORN SAMPLES	N	2008-10-31 15:19:03.544
\.


--
-- Name: sample_domain_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('sample_domain_seq', 2, true);


--
-- Data for Name: sample_environmental; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sample_environmental (id, samp_id, is_hazardous, lot_nbr, description, chem_samp_num, street_address, multiple_unit, city, state, zip_code, country, collector, sampling_location) FROM stdin;
\.


--
-- Data for Name: sample_human; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sample_human (id, provider_id, samp_id, patient_id, lastupdated) FROM stdin;
\.


--
-- Name: sample_human_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('sample_human_seq', 32, true);


--
-- Data for Name: sample_item; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sample_item (id, sort_order, sampitem_id, samp_id, source_id, typeosamp_id, uom_id, source_other, quantity, lastupdated, external_id, collection_date, status_id, collector) FROM stdin;
\.


--
-- Name: sample_item_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('sample_item_seq', 52, true);


--
-- Data for Name: sample_newborn; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sample_newborn (id, weight, multi_birth, birth_order, gestational_week, date_first_feeding, breast, tpn, formula, milk, soy, jaundice, antibiotics, transfused, date_transfusion, medical_record_numeric, nicu, birth_defect, pregnancy_complication, deceased_sibling, cause_of_death, family_history, other, y_numeric, yellow_card, lastupdated) FROM stdin;
\.


--
-- Name: sample_org_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('sample_org_seq', 112, false);


--
-- Data for Name: sample_organization; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sample_organization (id, org_id, samp_id, samp_org_type, lastupdated) FROM stdin;
\.


--
-- Data for Name: sample_pdf; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sample_pdf (id, accession_number, allow_view, barcode) FROM stdin;
\.


--
-- Name: sample_pdf_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('sample_pdf_seq', 1, false);


--
-- Name: sample_proj_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('sample_proj_seq', 1, false);


--
-- Data for Name: sample_projects; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sample_projects (samp_id, proj_id, is_permanent, id, lastupdated) FROM stdin;
\.


--
-- Data for Name: sample_qaevent; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sample_qaevent (id, qa_event_id, sample_id, completed_date, lastupdated, sampleitem_id, entered_date) FROM stdin;
\.


--
-- Data for Name: sample_qaevent_action; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sample_qaevent_action (id, sample_qaevent_id, action_id, created_date, lastupdated, sys_user_id) FROM stdin;
\.


--
-- Name: sample_qaevent_action_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('sample_qaevent_action_seq', 1, false);


--
-- Name: sample_qaevent_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('sample_qaevent_seq', 2, true);


--
-- Data for Name: sample_requester; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sample_requester (sample_id, requester_id, requester_type_id, lastupdated) FROM stdin;
\.


--
-- Name: sample_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('sample_seq', 32, true);


--
-- Data for Name: sample_source; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sample_source (id, name, description, active, display_order) FROM stdin;
6	CHK	CHK	t	6
7	CP Kimia	CP Kimia	t	7
8	CP Lisanga	CP Lisanga	t	8
9	CP Centre Médical Ngaba	CP Centre Médical Ngaba	t	9
10	CP Hopital Roi Baudoin	CP Hopital Roi Baudoin	t	10
11	CP Libundi	CP Libundi	t	11
12	Dispensaire MSF	Dispensaire MSF	t	12
13	EGPAF	EGPAF	t	13
14	ICAP	ICAP	t	14
15	IHAP	IHAP	t	15
16	Autres	Autres	t	16
\.


--
-- Name: sample_source_id_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('sample_source_id_seq', 16, true);


--
-- Name: sample_type_panel_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('sample_type_panel_seq', 130, true);


--
-- Name: sample_type_test_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('sample_type_test_seq', 1452, true);


--
-- Data for Name: sampletype_panel; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sampletype_panel (id, sample_type_id, panel_id) FROM stdin;
122	83	90
123	84	92
124	85	91
125	82	85
126	82	86
127	82	87
128	82	93
129	82	88
130	82	89
\.


--
-- Data for Name: sampletype_test; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sampletype_test (id, sample_type_id, test_id, is_panel) FROM stdin;
1359	83	807	f
1360	83	808	f
1361	83	809	f
1362	84	869	f
1363	84	822	f
1364	84	823	f
1365	84	824	f
1366	84	825	f
1367	84	826	f
1368	84	827	f
1369	84	828	f
1370	84	829	f
1371	84	830	f
1372	84	831	f
1373	85	810	f
1374	85	811	f
1375	85	812	f
1376	85	813	f
1377	85	814	f
1378	85	815	f
1379	85	816	f
1380	85	817	f
1381	85	818	f
1382	85	819	f
1383	85	820	f
1384	85	846	f
1385	85	821	f
1386	85	868	f
1387	86	847	f
1388	86	848	f
1389	86	849	f
1390	87	859	f
1391	87	860	f
1392	87	861	f
1393	88	856	f
1394	88	857	f
1395	88	858	f
1396	89	850	f
1397	89	851	f
1398	89	852	f
1399	90	862	f
1400	90	863	f
1401	90	864	f
1402	91	865	f
1403	91	866	f
1404	91	867	f
1408	82	784	f
1409	82	785	f
1410	82	840	f
1411	82	786	f
1412	82	787	f
1413	82	788	f
1414	82	789	f
1415	82	790	f
1416	82	791	f
1417	82	792	f
1418	82	793	f
1419	82	794	f
1420	82	795	f
1421	82	796	f
1422	82	797	f
1423	82	798	f
1424	82	799	f
1425	82	800	f
1426	82	801	f
1427	82	802	f
1428	82	803	f
1429	82	804	f
1430	82	805	f
1431	82	806	f
1432	82	832	f
1433	82	833	f
1434	82	834	f
1435	82	835	f
1436	82	876	f
1437	82	877	f
1438	82	836	f
1439	82	837	f
1440	82	870	f
1441	82	871	f
1442	82	838	f
1443	82	839	f
1444	82	842	f
1445	82	843	f
1446	82	872	f
1447	82	873	f
1448	82	844	f
1449	82	845	f
1450	82	874	f
1451	82	875	f
1452	82	841	f
1405	92	853	f
1406	92	854	f
1407	92	855	f
\.


--
-- Data for Name: scriptlet; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY scriptlet (id, name, code_type, code_source, lastupdated) FROM stdin;
13	Ais Test	B	C	2006-12-13 11:00:01.748
11	Diane Test	T	Diane test	2006-11-01 13:34:49.667
12	SCRIPTLET	S	test	2006-11-08 10:58:32.964
1	HIV Status Indeterminate	I	HIV Indeterminate	2011-02-02 11:55:53.344606
2	HIV Status Negative	I	HIV N	2011-02-02 11:55:53.344606
3	HIV Status Positive	I	HIV Positive	2011-02-02 11:55:53.344606
\.


--
-- Name: scriptlet_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('scriptlet_seq', 3, true);


--
-- Data for Name: sequence; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY sequence (seq_name, seq_count) FROM stdin;
\.


--
-- Data for Name: site_information; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY site_information (id, name, lastupdated, description, value, encrypted, domain_id, value_type, instruction_key, "group", schedule_id, tag, dictionary_category_id) FROM stdin;
17	modify results role	2012-04-24 00:30:14.552196+00	Should a separate role be required to be able to modify results	true	f	1	boolean	\N	0	\N	\N	\N
19	ResultTechnicianName	2012-04-24 00:30:14.59688+00	If true then the technician name is required for entering results	true	f	1	boolean	instructions.results.technician	0	\N	\N	\N
20	autoFillTechNameBox	2012-04-24 00:30:14.59688+00	If the techs name is required on results then add a box for autofill	true	f	1	boolean	instructions.results.autofilltechbox	0	\N	\N	\N
18	modify results note required	2012-04-24 00:30:14.552196+00	Is a note required when results are modified	true	f	1	boolean	\N	0	\N	\N	\N
25	alertWhenInvalidResult	2012-04-24 00:30:14.768284+00	Should there be an alert when the user enters a result outside of the valid range	true	f	1	boolean	instructions.results.invalidAlert	0	\N	\N	\N
32	reflex_rules	2012-04-24 00:30:25.248429+00	What set of reflex rules are used. From a predefined list	\N	f	6	text	\N	0	\N	\N	\N
11	siteNumber	2011-09-27 16:49:46.515742+00	The site number of the this lab	11404	f	2	text	\N	0	\N	\N	\N
14	patientSearchURL	2011-09-27 16:49:46.51774+00	The service URL from which to import patient demographics	https://192.168.1.50/PatientSearchService/iSante/services/patients	f	2	text	\N	0	\N	\N	\N
15	patientSearchLogOnUser	2011-09-27 16:49:46.518276+00	The user name for using the service	iSanteSvcUser	f	2	text	\N	0	\N	\N	\N
41	statusRules	2012-04-24 00:30:25.342503+00	statusRules determine specific status values for the application, ex: LNSP_haiti	Haiti	f	11	text	\N	0	\N	\N	\N
13	useExternalPatientSource	2011-09-27 16:49:46.517196+00	Use an external source patient demographics true/false	true	f	2	boolean	\N	0	\N	\N	\N
5	appName	2010-10-28 11:13:55.857654+00	The name of the application.	haitiOpenElis	f	8	text	\N	0	\N	\N	\N
39	trackPayment	2012-04-24 00:30:25.331052+00	If true track patient payment for services	false	f	10	boolean	instructions.patient.payment	0	\N	\N	\N
42	reflexAction	2012-04-24 00:30:25.342503+00	reflexActions determine the meaning of the flags in reflexes, ex: RetroCI	Haiti	f	11	text	\N	0	\N	\N	\N
44	passwordRequirements	2012-04-24 00:30:25.342503+00	changes the password requirements depending on site, ex: HAITI	HAITI	f	11	text	\N	0	\N	\N	\N
47	malariaSurURL	2012-04-25 00:25:44.847629+00	The URL for malaria Surveillance reports	https://openelis-dev.cirg.washington.edu/upload/receive-file.pl	f	9	text	instructions.result.malaria.sur.url	2	\N	url	\N
48	malariaSurReport	2012-04-25 00:25:44.847629+00	True to send reports, false otherwise	true	f	9	boolean	instructions.result.malaria.surveillance	2	3	enable	\N
38	resultReportingURL	2012-04-24 00:30:25.292745+00	Where reporting results electronically should be sent	https://openelis-dev.cirg.washington.edu/upload/receive-file.pl	f	9	text	\N	1	\N	url	\N
10	TrainingInstallation	\N	Allows for deletion of all patient and sample data	false	f	2	boolean	\N	0	\N	\N	\N
49	malariaCaseURL	2012-04-25 00:25:44.847629+00	The URL for malaria case reports	https://openelis-dev.cirg.washington.edu/upload/receive-file.pl	f	9	text	instructions.result.malaria.case.url	3	\N	url	\N
21	autoFillTechNameUser	2012-04-24 00:30:14.59688+00	If the techs name is required on results then autofill with logged in user	true	f	1	boolean	instructions.results.autofilltech.user	0	\N	\N	\N
34	testUsageAggregationUserName	2012-04-24 00:30:25.248429+00	The user name for accesses to the service for aggregating test usage	user	f	7	text	\N	0	\N	\N	\N
35	testUsageAggregationPassword	2012-04-24 00:30:25.248429+00	The password for accesser to the service for aggregating test usage	userUSER!	t	7	text	\N	0	\N	\N	\N
33	testUsageAggregationUrl	2012-04-24 00:30:25.248429+00	The url of the site to which test usage will be sent	https://openelis-dev.cirg.washington.edu/LNSP_HaitiOpenElis	f	7	text	\N	0	\N	\N	\N
36	testUsageSendStatus	2012-04-24 00:30:25.266236+00	The status of what happened the last time an attempt was made to send the report	Succès!	f	7	text	\N	0	\N	\N	\N
55	condenseNSF	2013-08-08 08:02:34.823415+00	Should NFS be represented as NFS or as individual tests	false	f	11	boolean	\N	0	\N	\N	\N
56	roleForPatientOnResults	2013-08-08 08:02:34.878224+00	Is patient information restricted to those in correct role	false	f	1	boolean	\N	0	\N	\N	\N
54	configuration name	2013-08-08 08:02:34.806178+00	The name which will appear after the version number in header	Haiti Clinical	f	2	text	\N	0	\N	\N	\N
12	lab director	2011-09-27 16:49:46.516648+00	Name which may appear on reports as lab head	Yolette Francois	f	12	text	\N	0	\N	\N	\N
58	sortQaEvents	2013-08-08 08:02:35.09779+00	sort qa events in lists	true	f	2	boolean	siteInformation.instruction.sortQaEvents	0	\N	\N	\N
57	reportPageNumbers	2013-08-08 08:02:35.049849+00	use page numbers on reports	true	f	12	boolean	siteInformation.instruction.pageNumbers	0	\N	\N	\N
61	lab logo	2013-08-08 08:02:35.287294+00	Provides for uploading lab logo		f	12	logoUpload	siteInformation.instruction.labLogo	0	\N	\N	\N
43	acessionFormat	2012-04-24 00:30:25.342503+00	specifies the format of the acession number,ex: SiteYearNum	DATENUM	f	11	text	\N	0	\N	\N	\N
53	default date locale	2013-08-08 08:02:34.795224+00	The default date local	en-GB	f	2	dictionary	\N	0	\N	\N	177
59	validate all results	2013-08-08 08:02:35.118408+00	all results should be validated even if normal	true	f	1	boolean	siteInformation.instruction.validate.all	0	\N	\N	\N
45	setFieldForm	2012-04-24 00:30:25.342503+00	set form fields for each different implementation, ex: Haiti	bahmni	f	11	text	\N	0	\N	\N	\N
22	showValidationFailureIcon	2012-04-24 00:30:14.608163+00	If the analysis has failed validation show icon on results page	true	f	1	boolean	instructions.results.validationFailIcon	0	\N	\N	\N
60	additional site info	2013-08-08 08:02:35.279543+00	additional information for report header		f	12	text	siteInformation.instruction.headerInfo	0	\N	\N	\N
40	stringContext	2012-04-24 00:30:25.342503+00	The context for the property, ex: Cote d' Iviore		f	11	text	\N	0	\N	\N	\N
37	resultReporting	2012-04-24 00:30:25.292745+00	Should reporting results electronically be enabled	false	f	9	text	\N	1	\N	enable	\N
24	useLogoInReport	2012-04-24 00:30:14.687813+00	Should the site logo be used in the report	true	f	12	boolean	instructions.site.logo	0	\N	\N	\N
16	allowLanguageChange	2012-04-24 00:30:07.039386+00	Allows the user to change the language at login	true	f	2	boolean	\N	0	\N	\N	\N
62	SampleEntryFieldsetOrder	2017-12-26 13:07:49.901199+00	Configures the order in which each section appears in the Add Sample Entry form. Eg: value: patient|samples|order	patient|samples|order	f	\N	text	\N	0	\N	\N	\N
63	AdminUser	2017-12-26 13:07:50.344015+00	Holds the name of the admin user responsible for creating Lab/Panels	admin	f	\N	text	\N	0	\N	\N	\N
64	uploadedFilesDirectory	2017-12-26 13:07:50.650746+00	Configures the directory where the uploaded files are saved.	/uploaded-files/elis/	f	\N	text	\N	0	\N	\N	\N
66	durationInDaysForUploadStatuses	2017-12-26 13:07:50.665044+00	Configures the past number of days for which we display the upload data on Upload Dashboard.	30	f	\N	int	\N	0	\N	\N	\N
52	default language locale	2013-08-08 08:02:34.795224+00	The default language local	fr-FR	f	2	dictionary	\N	0	\N	\N	177
68	resultsValidationPageSize	2017-12-26 13:07:50.732156+00	Configures the number tests per page for result validation	30	f	\N	int	\N	0	\N	\N	\N
50	malariaCaseReport	2012-04-25 00:25:44.847629+00	True to send reports, false otherwise	false	f	9	boolean	instructions.result.malaria.case	3	\N	enable	\N
51	testUsageReporting	2012-05-02 20:18:13.979353+00	Should reporting testUsage electronically be enabled	false	f	7	boolean	instructions.test.usage	0	\N	enable	\N
69	uploadedResultsDirectory	2017-12-26 13:07:50.90099+00	Contains all files uploaded against results	/uploaded_results/	f	\N	text	\N	0	\N	\N	\N
67	resultsPageSize	2017-12-26 13:07:50.728043+00	Configures the number tests per page for result entry	30	f	\N	int	\N	0	\N	\N	\N
71	defaultSampleSource	\N	Configuration for default sample source value 		f	2	text	\N	0	\N	\N	\N
72	defaultOrganizationName	2018-01-05 06:00:41.111827+00	Default organization name for department to be synced from openmrs	Bahmni	f	\N	text	\N	0	\N	\N	\N
65	parentOfUploadedFilesDirectory	2017-12-26 13:07:50.650746+00	Configures the parent directory of uploaded files directory.	/home/MSF	f	\N	text	\N	0	\N	\N	\N
23	SiteName	2012-04-24 00:30:14.645114+00	The name of the site for reports and header	Centre Hospitalier de Kabinda	f	12	text	instructions.site.name	0	\N	\N	\N
8	patientSearchPassword	2010-10-28 11:13:56.491221+00	The password for using the service	***************	t	2	text	\N	0	\N	\N	\N
\.


--
-- Data for Name: site_information_domain; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY site_information_domain (id, name, description) FROM stdin;
1	resultConfiguration	site information which effects the handling of results
2	siteIdentity	Identityfing items which don't change the behavior
3	patientSharing	Items needed to share patient information
4	siteExtras	Items which turn extra capacity on and off
5	formating	Items which specify the format of artifacts
6	rules	Items which change the busness rules and effect the workflow
7	testUsage	Items which change the busness rules and effect the workflow
8	configIdentity	Identityfing items which identify the configuration
10	sampleEntryConfig	Configuration for those items which can appear on the sample entry form
11	hiddenProperties	Configuration properties invisible to the user
9	resultReporting	Items which effect reports being sent electronically
12	printedReportsConfig	items which effect printed reports
\.


--
-- Name: site_information_domain_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('site_information_domain_seq', 12, true);


--
-- Name: site_information_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('site_information_seq', 72, true);


--
-- Data for Name: source_of_sample; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY source_of_sample (id, description, domain, lastupdated) FROM stdin;
43	Ankle	H	2006-09-12 10:09:25
56	Bone marrow	H	2006-09-12 10:14:26
62	Brain meninges	H	2006-09-12 10:24:32
88	Eye lid	H	2006-09-12 10:34:28
91	Finger 1st	H	2006-09-12 10:35:08
102	Head	H	2006-09-12 10:38:14
109	Lingula	H	2006-09-12 10:39:28
205	test11	A	2006-12-11 14:48:24
26	Left Lower Lobe	H	2006-09-12 10:03:04
29	Right Lower Lobe	H	2006-09-12 10:03:24
30	Middle Lobe	H	2006-09-12 10:03:37
31	Acute	H	2006-09-12 10:05:06
32	Convalescent	H	2006-09-12 10:05:19
33	Abdominal	H	2006-11-08 11:10:05.484
34	Amniotic	H	2006-09-12 10:05:53
35	Joint	H	2006-09-12 10:06:04
36	Paracentesis	H	2006-09-12 10:07:23
37	Pericardial	H	2006-09-12 10:07:33
38	Synovial	H	2006-09-12 10:07:43
39	Thoracentesis	H	2006-09-12 10:08:09
40	Vitreous	H	2006-09-12 10:08:20
41	Abdomen	H	2006-11-08 11:09:50.202
42	Adenoid	H	2006-09-12 10:09:17
44	Aorta	H	2006-09-12 10:09:34
45	Arm	H	2006-09-12 10:09:42
46	Axilla	H	2006-09-12 10:09:53
47	Back	H	2006-09-12 10:10:00
48	Bladder	H	2006-09-12 10:10:36
49	Bone	A	2006-11-27 09:21:04
50	Bone tibia	H	2006-09-12 10:13:00
51	Bone femur	H	2006-09-12 10:12:33
52	Bone coccyx	H	2006-09-12 10:13:18
53	Bone clavicle	H	2006-09-12 10:13:32
54	Bone cranium	H	2006-09-12 10:13:46
55	Bone mastoid	H	2006-09-12 10:14:01
57	Bowel	H	2006-09-12 10:14:37
58	Brain	H	2006-09-12 10:23:28
59	Brain frontal lobe	H	2006-09-12 10:23:48
60	Brain subgaleal	H	2006-09-12 10:24:07
61	Brain subdural	H	2006-09-12 10:24:21
63	Brain parietal lobe	H	2006-09-12 10:24:46
64	Brain dura	H	2006-09-12 10:24:56
65	Brain cerebellum	H	2006-09-12 10:25:10
66	Breast	H	2006-09-12 10:25:19
67	Buccal	H	2006-09-12 10:25:37
68	Buttock	H	2006-09-12 10:26:10
69	Calf	H	2006-09-12 10:26:19
70	Cervix	H	2006-09-12 10:26:47
71	Chest	H	2006-09-12 10:26:56
72	Coccyx	H	2006-09-12 10:27:19
73	Colon	H	2006-09-12 10:27:27
74	Composite	H	2006-09-12 10:27:35
75	Disc	H	2006-09-12 10:27:47
76	Duodenum	H	2006-09-12 10:27:58
77	Ear	H	2006-09-12 10:28:05
78	Ear canal	H	2006-09-12 10:28:20
79	Ear mastoid	H	2006-09-12 10:28:32
80	Elbow	H	2006-09-12 10:28:43
81	Endometrium	H	2006-09-12 10:28:53
82	Epidural	H	2006-09-12 10:29:03
83	Epiglottis	H	2006-09-12 10:29:17
84	Esophagus	H	2006-09-12 10:29:37
85	Eye	H	2006-09-12 10:33:46
86	Eye cornea	H	2006-09-12 10:34:00
87	Eye conjunctiva	H	2006-09-12 10:34:19
89	Face	H	2006-09-12 10:34:40
90	Finger	H	2006-09-12 10:34:48
92	Finger 2nd	H	2006-09-12 10:35:19
93	Finger 3rd	H	2006-09-12 10:35:28
94	Finger 4th	H	2006-09-12 10:35:36
95	Finger thumb	H	2006-09-12 10:35:47
96	Foot	H	2006-09-12 10:36:00
97	Gall Bladder	H	2006-09-12 10:37:27
98	Gastric	H	2006-09-12 10:37:35
99	Hair	H	2006-09-12 10:37:42
100	Hand	H	2006-09-12 10:37:52
101	Hard Palate	H	2006-09-12 10:38:03
103	Hip	H	2006-09-12 10:38:25
104	Intestine	H	2006-09-12 10:38:38
105	Jaw	H	2006-09-12 10:38:48
106	Kidney	H	2006-09-12 10:38:58
107	Knee	H	2006-09-12 10:39:07
108	Leg	H	2006-09-12 10:39:20
110	Lip	H	2006-09-12 10:39:43
111	Lumbar	H	2006-09-12 10:39:51
112	Lumbar Disc Space	H	2006-09-12 10:40:03
113	Lymph Node	H	2006-09-12 10:40:14
114	Lymph Node abdominal	H	2006-09-12 10:40:36
115	Lymph Node axillary	H	2006-09-12 10:40:50
116	Lymph Node cervical	H	2006-09-12 10:41:04
117	Lymph Node hilar	H	2006-09-12 10:41:22
118	Lymph Node inguinal	H	2006-09-12 10:41:47
124	Neck	H	2006-09-12 11:34:26
125	Nose	H	2006-09-12 11:34:34
140	Rectum	H	2006-09-12 11:38:12
143	Scrotum	H	2006-09-12 11:39:22
144	Shin	H	2006-09-12 11:39:30
174	Wrist	H	2006-09-12 11:46:47
185	Heart	H	2006-09-12 11:58:15
189	Lymph Node mediastinal	H	2006-09-12 12:45:59
190	Lymph Node mesenteric	H	2006-09-12 12:46:17
191	Lymph Node paratracheal	H	2006-09-12 12:46:30
192	Lymph Node portal	H	2006-09-12 12:47:25
193	Lymph Node post auricular	H	2006-09-12 12:47:42
194	Lymph Node submandibular	H	2006-09-12 12:47:57
195	Lymph Node supraclavicular	H	2006-09-12 12:48:23
196	Lymph Node tracheal	H	2006-09-12 12:48:33
197	Port-a-Cath	H	2006-09-13 08:49:45
198	IV Catheter Tip	H	2006-09-13 08:50:14
120	Urethral	H	2006-09-12 11:33:15
28	Right Upper Lobe	H	2006-09-12 10:03:14
119	Cervical	H	2006-09-12 11:33:05
121	Oral	H	2006-09-12 11:33:38
122	Mandible	H	2006-09-12 11:34:14
123	Nail	H	2006-09-12 11:34:20
126	Nose anterior nares	H	2006-09-12 11:34:59
127	Nose nares	H	2006-09-12 11:35:12
128	Nose turbinate	H	2006-09-12 11:35:22
129	Omentum	H	2006-09-12 11:35:33
130	Paraspinal	H	2006-09-12 11:35:44
131	Paratracheal	H	2006-09-12 11:36:11
132	Parotid	H	2006-09-12 11:36:21
133	Penis	H	2006-09-12 11:36:59
134	Pericardium	H	2006-09-12 11:37:09
135	Perineum	H	2006-09-12 11:37:22
136	Peritoneum	H	2006-09-12 11:37:37
137	Placenta	H	2006-09-12 11:37:45
138	Pleura	H	2006-09-12 11:37:56
139	Prostate	H	2006-09-12 11:38:04
141	Sacrum	H	2006-09-12 11:38:26
142	Scalp	H	2006-09-12 11:38:36
145	Shoulder	H	2006-09-12 11:39:38
146	Sinus	H	2006-09-12 11:39:49
147	Sinus ethmoid	H	2006-09-12 11:40:08
148	Sinus frontal	H	2006-09-12 11:40:17
149	Sinus maxillary	H	2006-09-12 11:41:30
150	Sinus sphenoid	H	2006-09-12 11:41:42
151	Skin	H	2006-09-12 11:41:55
152	Small Bowel	H	2006-09-12 11:42:04
153	Spine	H	2006-09-12 11:42:11
154	Spleen	H	2006-09-12 11:42:20
155	Sternum	H	2006-09-12 11:42:30
156	Stomach	H	2006-09-12 11:42:38
157	Synovium	H	2006-09-12 11:43:00
158	Testicle	H	2006-09-12 11:43:17
159	Thigh	H	2006-09-12 11:43:25
160	Toe	H	2006-09-12 11:43:33
161	Toe great	H	2006-09-12 11:43:58
162	Toe 1st	H	2006-09-12 11:44:10
163	Toe 2nd	H	2006-09-12 11:44:19
164	Toe 3rd	H	2006-09-12 11:44:29
165	Toe 4th	H	2006-09-12 11:44:38
166	Toe 5th	H	2006-09-12 11:45:37
167	Toenail	H	2006-09-12 11:45:48
168	Tongue	H	2006-09-12 11:45:57
169	Tonsil	H	2006-09-12 11:46:04
170	Vagina	H	2006-09-12 11:46:18
171	Vein	H	2006-09-12 11:46:25
172	Vertebra	H	2006-09-12 11:46:32
173	Vulva	H	2006-09-12 11:46:40
175	Other	H	2006-09-12 11:47:35
176	Midstream	H	2006-09-12 11:47:54
177	Clean Catch	H	2006-09-12 11:48:05
178	Catheter	H	2006-09-12 11:48:12
179	Foley Catheter	H	2006-09-12 11:48:33
180	Peripheral	H	2006-09-12 11:48:45
181	EDTA	H	2006-09-12 11:48:51
182	Whole	H	2006-09-12 11:48:57
183	Venous	H	2006-09-12 11:49:06
184	Cord	H	2006-09-12 11:49:11
186	Heart valve	H	2006-09-12 11:58:28
187	Heart aortic	H	2006-09-12 11:58:38
188	Heart pericardium	H	2006-09-12 11:58:49
25	Left Upper Lobe 	H	2006-09-12 10:02:44
\.


--
-- Name: source_of_sample_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('source_of_sample_seq', 1, false);


--
-- Data for Name: state_code; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY state_code (id, code, description, lastupdated) FROM stdin;
\.


--
-- Name: state_code_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('state_code_seq', 1, false);


--
-- Data for Name: status_of_sample; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY status_of_sample (id, description, code, status_type, lastupdated, name, display_key, is_active) FROM stdin;
4	This test has not yet been done	1	ANALYSIS	2010-04-28 15:39:55.011	Not Tested	status.test.notStarted	Y
9	test has been referred to an outside lab and the results have not been returned	1	ANALYSIS	2010-10-28 06:13:55.174221	referred out	status.test.referred.out	Y
10	test has been done at an outside lab and then referred to this lab	1	ANALYSIS	2011-03-29 16:23:08.29256	referred in	status.test.referred.in	Y
6	The results of the analysis are final	1	ANALYSIS	2010-04-28 15:39:55.011	Finalized	status.test.valid	Y
7	The Biologist did not accept this result as valid	1	ANALYSIS	2012-04-23 17:30:24.415051	Biologist Rejection	status.test.biologist.reject	Y
15	Test was requested but then canceled	1	ANALYSIS	2012-04-23 17:30:24.415051	Test Canceled	status.test.canceled	Y
16	The results of the test were accepted by technician as being valid	1	ANALYSIS	2012-04-23 17:30:24.415051	Technical Acceptance	status.test.tech.accepted	Y
17	The results of the test were not accepted by the technicain	1	ANALYSIS	2012-04-23 17:30:24.415051	Technical Rejected	status.test.tech.rejected	Y
1	No tests have been run for this order	1	ORDER	2010-04-28 15:39:55.011	Test Entered	status.sample.notStarted	Y
2	Some tests have been run on this order	1	ORDER	2010-04-28 15:39:55.011	Testing Started	status.sample.started	Y
3	All tests have been run on this order	1	ORDER	2010-04-28 15:39:55.011	Testing finished	status.sample.finished	Y
18	The sample has been canceled by the user	1	SAMPLE	2013-08-08 08:02:34.640284	SampleCanceled	status.sample.entered	Y
19	The sample has been entered into the system	1	SAMPLE	2013-08-08 08:02:34.640284	SampleEntered	status.sample.entered	Y
11	The order is non-conforming	1	ORDER	2012-04-23 17:30:13.485907	NonConforming	status.sample.nonConforming	N
14	The order is non-conforming	1	ORDER	2012-04-23 17:30:24.383612	NonConforming	status.sample.nonConforming	N
12	The order is non-conforming	1	ANALYSIS	2012-04-23 17:30:13.485907	NonConforming	status.analysis.nonConforming	N
13	The order is non-conforming	1	ANALYSIS	2012-04-23 17:30:24.330299	NonConforming	status.analysis.nonconforming	N
20	The results of the test were accepted by technician as being valid for referred out test	1	ANALYSIS	2017-12-26 13:07:50.55281	Technical Acceptance RO	status.test.referred.out.tech.accepted	Y
21	The results of the analysis are final for referred out test	1	ANALYSIS	2017-12-26 13:07:50.55281	Finalized RO	status.test.referred.out.valid	Y
22	The Biologist did not accept this result as valid for referred out test	1	ANALYSIS	2017-12-26 13:07:50.602123	Biologist Rejection RO	status.test.referred.out.biologist.reject	Y
\.


--
-- Name: status_of_sample_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('status_of_sample_seq', 22, true);


--
-- Data for Name: storage_location; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY storage_location (id, sort_order, name, location, is_available, parent_storageloc_id, storage_unit_id) FROM stdin;
\.


--
-- Data for Name: storage_unit; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY storage_unit (id, category, description, is_singular) FROM stdin;
\.


--
-- Data for Name: system_module; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY system_module (id, name, description, has_select_flag, has_add_flag, has_update_flag, has_delete_flag) FROM stdin;
1	PanelItem	Master Lists => Panel Item => edit	Y	Y	Y	N
2	DictionaryCategory	Master Lists => Dictionary Category => edit	Y	Y	Y	N
3	Dictionary	Master Lists => Dictonary => edit	Y	Y	Y	N
4	Gender	Master Lists => Gender => edit	Y	Y	Y	N
5	LoginUser	Master Lists => Login User => Edit	Y	Y	Y	N
6	Organization	Master Lists => Organization => edit	Y	Y	Y	N
7	Panel	Master Lists => Panel	Y	Y	Y	Y
8	PatientResults	Results->By Patient	N	N	N	N
9	ResultLimits	Master Lists => ResultLimits => edit	Y	Y	Y	N
10	Result	Master Lists => Result => edit	Y	Y	Y	N
11	Role	Master Lists => Role => edit	Y	Y	Y	N
12	StatusOfSample	Master Lists => StatusOfSample => edit	Y	Y	Y	N
13	SystemModule	Master Lists => System Module	Y	Y	Y	N
14	SystemUser	Master Lists => System User	Y	Y	Y	N
15	Test	Master Lists => Test	Y	Y	Y	N
16	SampleEntry	Sample->Sample Entry	N	N	N	N
17	MasterList	Administration	N	N	N	N
18	Inventory	Inventory	N	N	N	N
26	StatusResults	Results->By Status	N	N	N	N
27	ReportAdmin	Master Lists => OR Admin	Y	Y	Y	N
28	ReportUserDetail	Reports	Y	Y	Y	N
29	ReportUserOption	Reports	Y	Y	Y	N
30	ReportUserRun	Reports	Y	Y	Y	N
31	TypeOfTestResult	Master Lists => Type Of Test Result	Y	Y	Y	N
32	SystemUserModule	Master Lists => System User Module	Y	Y	Y	N
33	ResultsEntry	Result Management => Results Entry	Y	Y	Y	N
34	TestSection	Master Lists => Test Section	Y	Y	Y	N
35	TypeOfSample	Master Lists => Type Of Sample	Y	Y	Y	N
36	UnitOfMeasure	Master Lists => Unit Of Measure	N	N	N	N
40	UserRole	MasterList => UserRole	Y	Y	Y	Y
41	PatientType	MasterList => PatientType	Y	Y	Y	Y
42	TypeOfSamplePanel	MasterList => Associtate type of sample with panel	Y	Y	Y	Y
43	TypeOfSampleTest	MasterList => Associtate type of sample with tests	Y	Y	Y	Y
44	UnifiedSystemUser	MasterList->ManageUsers	Y	Y	Y	Y
45	LogbookResults	Results=>logbook=>save	Y	Y	Y	Y
46	SamplePatientEntry	Sample->SampleEntry	Y	Y	Y	Y
47	SiteInformation	MasterList=>Site Information	Y	Y	Y	Y
48	AnalyzerTestName	MasterList->Analyzer Test Name	Y	Y	Y	Y
49	AnalyzerResults	Results->Analyzers	Y	Y	Y	Y
51	SampleEntryByProject:initial	Sample=>CreateSample=>initial	Y	Y	Y	Y
52	SampleEntryByProject:verify	Sample=>CreateSample=>verify	Y	Y	Y	Y
55	PatientEntryByProject:initial	Patient=>Enter=>initial	Y	Y	Y	Y
56	PatientEntryByProject:verify	Patient=>Enter=>verify	Y	Y	Y	Y
60	LogbookResults:serology	Results=>Enter=>serology	Y	Y	Y	Y
61	LogbookResults:virology	Results=>Enter=>virology	Y	Y	Y	Y
63	AccessionResults	Results=>Search=>Lab No.	Y	Y	Y	Y
65	AnalyzerResults:cobas_integra	Results=>Analyzer=>cobas_integra	Y	Y	Y	Y
66	AnalyzerResults:sysmex	Results=>Analyzer=>sysmex	Y	Y	Y	Y
67	AnalyzerResults:facscalibur	Results=>Analyzer=>facscalibur	Y	Y	Y	Y
68	AnalyzerResults:evolis	Results=>Analyzer=>evolis	Y	Y	Y	Y
69	Workplan:test	Workplan=>test	Y	Y	Y	Y
70	Workplan:serology	Workplan=>serology	Y	Y	Y	Y
71	Workplan:immunology	Workplan=>immunology	Y	Y	Y	Y
72	Workplan:hematology	Workplan=>hematology	Y	Y	Y	Y
73	Workplan:biochemistry	Workplan=>biochemistry	Y	Y	Y	Y
74	Workplan:virology	Workplan=>virology	Y	Y	Y	Y
84	TestResult	Admin=>TestResult	Y	Y	Y	Y
86	TestReflex	Admin=>TestReflex	Y	Y	Y	Y
87	TestAnalyte	Admin=>TestAnalyte	Y	Y	Y	Y
97	Method	Admin=>Method	Y	Y	Y	Y
53	SampleEditByProject:readwrite	Sample=>SampleEditByProject:readwrite	Y	Y	Y	Y
54	SampleEditByProject:readonly	Sample=>SampleEditByProject:readonly	Y	Y	Y	Y
20	LogbookResults:chem	Results->By Logbook->Chem	N	N	N	N
25	LogbookResults:HIV	Results->By Logbook->VCT	N	N	N	N
19	LogbookResults:bacteriology	Results->By Logbook->Bacteria	N	N	N	N
21	LogbookResults:ECBU	Results->By Logbook->ECBU	N	N	N	N
22	LogbookResults:hematology	Results->By Logbook->Hemaology	N	N	N	N
23	LogbookResults:immuno	Results->By Logbook->Immuno	N	N	N	N
24	LogbookResults:parasitology	Results->By Logbook->Parasitology	N	N	N	N
101	Analyte	Admin=>Analyte	Y	Y	Y	Y
106	SampleEdit	Sample=>edit	Y	Y	Y	Y
107	NonConformity	NonConformity	Y	Y	Y	Y
108	Report:patient	Patient reports	Y	Y	Y	Y
109	Report:summary	Lab summary reports	Y	Y	Y	Y
110	Report:indicator	Lab quality indicator reports	Y	Y	Y	Y
111	ResultValidation:serology	Validation=>serology	Y	Y	Y	Y
112	ResultValidation:immunology	Validation=>immunology	Y	Y	Y	Y
113	ResultValidation:hematology	Validation=>hematology	Y	Y	Y	Y
114	ResultValidation:biochemistry	Validation=>biochemistry	Y	Y	Y	Y
115	ResultValidation:virology	Validation=>virology	Y	Y	Y	Y
116	PatientEditByProject:readwrite	Patient=>PatientEdit	Y	Y	Y	Y
117	PatientEditByProject:readonly	Patient=>PatientConsult	Y	Y	Y	Y
118	SampleEdit:readwrite	Sample -> edit	Y	Y	Y	Y
123	SampleEdit:readonly	Sample=>SampleConsult	Y	Y	Y	Y
173	ReportUserDetail:patientARV2	Report=>patient=>ARV follow-up Save	Y	Y	Y	Y
174	ReportUserDetail:patientEID	Report=>patient=>EID	Y	Y	Y	Y
185	ReferredOutTests	Results=>Referrals	Y	Y	Y	Y
253	SampleConfirmationEntry	Sample=>sample confirmation	Y	Y	Y	Y
322	LogbookResults:mycobacteriology	Results=>logbooks=>mycobacteriology	Y	Y	Y	Y
341	AnalyzerResults:facscanto	Results=>Analyzer=>facscanto	Y	Y	Y	Y
349	Workplan:chem	Workplan=>chem	Y	Y	Y	Y
350	Workplan:cytobacteriology	Workplan=>cytobacteriology	Y	Y	Y	Y
351	Workplan:bacteriology	Workplan=>bacteriology	Y	Y	Y	Y
352	Workplan:ECBU	Workplan=>ECBU	Y	Y	Y	Y
353	Workplan:parasitology	Workplan=>parasitology	Y	Y	Y	Y
354	Workplan:immuno	Workplan=>immuno	Y	Y	Y	Y
355	Workplan:HIV	Workplan=>HIV	Y	Y	Y	Y
356	Workplan:molecularBio	Workplan=>molecularBio	Y	Y	Y	Y
357	Workplan:liquidBio	Workplan=>liquidBio	Y	Y	Y	Y
358	Workplan:mycrobacteriology	Workplan=>mycrobacteriology	Y	Y	Y	Y
359	Workplan:endocrin	Workplan=>endocrin	Y	Y	Y	Y
360	Workplan:serologie	Workplan=>serologie	Y	Y	Y	Y
405	LogbookResults:mycrobacteriology	Results=>logbooks=>mycrobacteriology	Y	Y	Y	Y
406	LogbookResults:cytobacteriology	Results=>logbooks=>cytobacteriology	Y	Y	Y	Y
407	LogbookResults:molecularBio	Results=>logbooks=>molecularBio	Y	Y	Y	Y
408	LogbookResults:liquidBio	Results=>logbooks=>liquidBio	Y	Y	Y	Y
409	LogbookResults:endocrin	Results=>logbooks=>endocrin	Y	Y	Y	Y
410	Workplan:panel	Workplan=>panel	Y	Y	Y	Y
411	Workplan:virologie	workplan-unit-virology	Y	Y	Y	Y
412	LogbookResults:virologie	results-section-virology	Y	Y	Y	Y
495	Workplan:mycology	Workplan=>mycology	Y	Y	Y	Y
496	LogbookResults:mycology	LogbookResults=>mycology	Y	Y	Y	Y
508	LogbookResults:serologie	Results=>Enter=>serologie	Y	Y	Y	Y
667	LogbookResults:serolo-immunology	LogbookResults=>serology-immunology	Y	Y	Y	Y
668	LogbookResults:immunology	LogbookResults=>immunology	Y	Y	Y	Y
669	LogbookResults:hemato-immunology	LogbookResults=>hemato-immunology	Y	Y	Y	Y
670	LogbookResults:biochemistry	LogbookResults=>biochemistry	Y	Y	Y	Y
671	Workplan:hemato-immunology	workplan=>units=>hemato-immunology	Y	Y	Y	Y
672	Workplan:serology-immunology	workplan=>units=>serology-immunology	Y	Y	Y	Y
673	ResultValidation:Hemto-Immunology	validation=>units=>Hemato-Immunity	Y	Y	Y	Y
675	ResultValidation:Serology-Immunology	validation=>units=>Serology-Immunity	Y	Y	Y	Y
676	ResultValidation	validation return	Y	Y	Y	Y
677	PatientDataOnResults	Able to view patient data when looking at results	Y	Y	Y	Y
678	AuditTrailView	Report=>view audit log	Y	Y	Y	Y
679	AnalyzerResults:cobasDBS	Result=>analyzers=>CobasTaqmanDBS	Y	Y	Y	Y
680	ResultValidation:molecularBio	ResultValidation=>molecularBio	Y	Y	Y	Y
681	ResultValidation:Cytobacteriologie	ResultValidation=>Cytobacteriologie	Y	Y	Y	Y
682	ResultValidation:ECBU	ResultValidation=>ECBU	Y	Y	Y	Y
683	ResultValidation:Parasitology	ResultValidation=>Parasitology	Y	Y	Y	Y
684	ResultValidation:Liquides biologique	ResultValidation=>Liquides biologique	Y	Y	Y	Y
685	ResultValidation:Mycobacteriology	ResultValidation=>Mycobacteriology	Y	Y	Y	Y
686	ResultValidation:Endocrinologie	ResultValidation=>Endocrinologie	Y	Y	Y	Y
687	ResultValidation:Serologie	ResultValidation=>Serologie	Y	Y	Y	Y
688	ResultValidation:VCT	ResultValidation=>VCT	Y	Y	Y	Y
689	ResultValidation:virologie	ResultValidation=>virologie	Y	Y	Y	Y
690	ResultValidation:Bacteria	ResultValidation=>Bacteria	Y	Y	Y	Y
691	ResultValidation:mycology	ResultValidation=>mycology	Y	Y	Y	Y
692	AnalyzerResults:cobasc311	AnalyzerResults=>cobasc311	Y	Y	Y	Y
694	Upload	Upload	N	N	N	N
693	LabDashboard	Lab Dashboard	N	N	N	N
695	ResultValidation:All Sections	Validation of all sections	N	N	N	N
696	HealthCenter	HealthCenter ajax page	N	N	N	N
\.


--
-- Name: system_module_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('system_module_seq', 696, true);


--
-- Data for Name: system_role; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY system_role (id, name, description, is_grouping_role, grouping_parent, display_key, active, editable) FROM stdin;
1	Maintenance Admin   	Change tests, panels etc.	f	\N	\N	t	f
2	User Admin          	Add/remove users and assign roles.	f	\N	\N	t	f
4	Intake              	Sample entry and patient management.	f	\N	\N	t	f
5	Results entry       	Enter and review results.	f	\N	\N	t	f
6	Inventory mgr       	Add and de/reactivate kits.	f	\N	\N	t	f
7	Reports             	Generate reports.	f	\N	\N	t	f
10	Quality control     	Able to do QC (e.g. nonconformity)	f	\N	role.quality.control	t	f
9	Results modifier    	Has permission to modify already entered results	f	\N	role.result.modifier	t	t
11	Audit Trail         	Able to view the audit trail	f	\N	role.audittrail	t	f
3	Validation          	Able to validate results	f	\N	\N	t	f
12	LabDashboard        	View Lab Dashboard	f	\N	\N	t	f
13	Upload              	csv upload facility	f	\N	\N	t	f
\.


--
-- Data for Name: system_role_module; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY system_role_module (id, has_select, has_add, has_update, has_delete, system_role_id, system_module_id) FROM stdin;
259	Y	Y	Y	Y	1	17
260	Y	Y	Y	Y	1	87
261	Y	Y	Y	Y	1	48
262	Y	Y	Y	Y	1	3
263	Y	Y	Y	Y	1	4
264	Y	Y	Y	Y	1	97
265	Y	Y	Y	Y	1	6
266	Y	Y	Y	Y	1	7
267	Y	Y	Y	Y	1	1
268	Y	Y	Y	Y	1	41
269	Y	Y	Y	Y	1	9
270	Y	Y	Y	Y	1	11
271	Y	Y	Y	Y	1	47
272	Y	Y	Y	Y	1	12
273	Y	Y	Y	Y	1	15
274	Y	Y	Y	Y	1	86
275	Y	Y	Y	Y	1	84
276	Y	Y	Y	Y	1	34
277	Y	Y	Y	Y	1	35
278	Y	Y	Y	Y	1	42
279	Y	Y	Y	Y	1	43
280	Y	Y	Y	Y	1	31
281	Y	Y	Y	Y	1	36
282	Y	Y	Y	Y	1	27
283	Y	Y	Y	Y	1	13
284	Y	Y	Y	Y	1	32
285	Y	Y	Y	Y	1	44
286	Y	Y	Y	Y	1	101
287	Y	Y	Y	Y	2	17
288	Y	Y	Y	Y	2	44
289	Y	Y	Y	Y	4	46
290	Y	Y	Y	Y	5	8
291	Y	Y	Y	Y	5	26
292	Y	Y	Y	Y	5	63
293	Y	Y	Y	Y	5	20
294	Y	Y	Y	Y	5	25
295	Y	Y	Y	Y	5	19
296	Y	Y	Y	Y	5	21
297	Y	Y	Y	Y	5	22
298	Y	Y	Y	Y	5	23
299	Y	Y	Y	Y	5	24
300	Y	Y	Y	Y	5	45
301	Y	Y	Y	Y	6	18
302	Y	Y	Y	Y	7	28
303	Y	Y	Y	Y	7	29
304	Y	Y	Y	Y	7	30
305	Y	Y	Y	Y	4	118
306	Y	Y	Y	Y	4	123
307	Y	Y	Y	Y	4	106
308	Y	Y	Y	Y	4	118
309	Y	Y	Y	Y	4	123
310	Y	Y	Y	Y	4	106
311	Y	Y	Y	Y	5	185
312	Y	Y	Y	Y	7	108
258	Y	Y	Y	Y	5	185
313	Y	Y	Y	Y	7	110
314	Y	Y	Y	Y	5	322
315	Y	Y	Y	Y	5	69
316	Y	Y	Y	Y	5	72
317	Y	Y	Y	Y	5	349
318	Y	Y	Y	Y	5	350
319	Y	Y	Y	Y	5	352
320	Y	Y	Y	Y	5	353
321	Y	Y	Y	Y	5	354
322	Y	Y	Y	Y	5	356
323	Y	Y	Y	Y	5	357
324	Y	Y	Y	Y	5	358
325	Y	Y	Y	Y	5	359
326	Y	Y	Y	Y	5	360
327	Y	Y	Y	Y	5	355
328	Y	Y	Y	Y	10	107
329	Y	Y	Y	Y	5	405
330	Y	Y	Y	Y	5	406
331	Y	Y	Y	Y	5	407
332	Y	Y	Y	Y	5	408
333	Y	Y	Y	Y	5	409
334	Y	Y	Y	Y	5	60
335	Y	Y	Y	Y	5	410
336	Y	Y	Y	Y	5	356
337	Y	Y	Y	Y	5	411
338	Y	Y	Y	Y	5	412
339	Y	Y	Y	Y	5	508
340	Y	Y	Y	Y	11	678
341	Y	Y	Y	Y	3	113
342	Y	Y	Y	Y	3	114
343	Y	Y	Y	Y	3	681
344	Y	Y	Y	Y	3	682
345	Y	Y	Y	Y	3	683
346	Y	Y	Y	Y	3	112
347	Y	Y	Y	Y	3	680
348	Y	Y	Y	Y	3	684
349	Y	Y	Y	Y	3	685
350	Y	Y	Y	Y	3	686
351	Y	Y	Y	Y	3	687
352	Y	Y	Y	Y	3	688
353	Y	Y	Y	Y	3	676
354	Y	Y	Y	Y	13	694
355	Y	Y	Y	Y	12	693
356	Y	Y	Y	Y	3	695
357	Y	Y	Y	Y	4	696
\.


--
-- Name: system_role_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('system_role_seq', 13, true);


--
-- Data for Name: system_user; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY system_user (id, external_id, login_name, last_name, first_name, initials, is_active, is_employee, lastupdated) FROM stdin;
1	1	admin	ELIS	Open	OE	Y	Y	2006-11-08 11:11:14.312
106	1	user	User	User	UU	Y	Y	2011-02-14 16:40:02.925
122	\N	atomfeed	atomfeed	atomfeed	\N	Y	N	2017-12-26 13:08:12.648535
\.


--
-- Data for Name: system_user_module; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY system_user_module (id, has_select, has_add, has_update, has_delete, system_user_id, system_module_id) FROM stdin;
\.


--
-- Name: system_user_module_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('system_user_module_seq', 357, true);


--
-- Data for Name: system_user_role; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY system_user_role (system_user_id, role_id) FROM stdin;
106	4
106	6
106	7
106	5
106	3
106	2
106	10
106	9
122	12
\.


--
-- Data for Name: system_user_section; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY system_user_section (id, has_view, has_assign, has_complete, has_release, has_cancel, system_user_id, test_section_id) FROM stdin;
\.


--
-- Name: system_user_section_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('system_user_section_seq', 1, false);


--
-- Name: system_user_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('system_user_seq', 122, true);


--
-- Data for Name: test; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY test (id, method_id, uom_id, description, loinc, reporting_description, sticker_req_flag, is_active, active_begin, active_end, is_reportable, time_holding, time_wait, time_ta_average, time_ta_warning, time_ta_max, label_qty, lastupdated, label_id, test_trailer_id, test_section_id, scriptlet_id, test_format_id, local_abbrev, sort_order, name, display_key, orderable, is_referred_out) FROM stdin;
869	\N	\N	Sang (hématurie)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.97	\N	\N	176	\N	\N	\N	71	Sang (hématurie)	\N	t	f
867	\N	\N	Rivalta (Synovial)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.989	\N	\N	176	\N	\N	\N	102	Rivalta (Synovial)	\N	t	f
871	\N	\N	Hépatite C	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.089	\N	\N	177	\N	\N	\N	34	Hépatite C	\N	t	f
868	\N	\N	GeneXpert TB (LCR)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.3	\N	\N	200	\N	\N	\N	69	GeneXpert TB (LCR)	\N	t	f
866	\N	\N	Genexpert (Synovial)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.312	\N	\N	200	\N	\N	\N	101	Genexpert (Synovial)	\N	t	f
862	\N	\N	Microscopie TB - Recherche de BAAR (Ganglionnaire)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.323	\N	\N	200	\N	\N	\N	97	Microscopie TB - Recherche de BAAR (Ganglionnaire)	\N	t	f
854	\N	\N	Genexpert (Gastrique)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.305	\N	\N	200	\N	\N	\N	89	Genexpert (Gastrique)	\N	t	f
802	\N	84	CD4 % (enfants de - 5 ans)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.187	\N	\N	197	\N	\N	\N	20	CD4 % (enfants de - 5 ans)	\N	t	f
793	\N	84	Numération reticulocyte	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.944	\N	\N	176	\N	\N	\N	11	Numération reticulocyte	\N	t	f
794	\N	\N	Typage anémie	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.949	\N	\N	176	\N	\N	\N	12	Typage anémie	\N	t	f
800	\N	\N	Sang Frais (Goutte fraiche)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.952	\N	\N	176	\N	\N	\N	18	Sang Frais (Goutte fraiche)	\N	t	f
806	\N	\N	GE	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.956	\N	\N	176	\N	\N	\N	24	GE	\N	t	f
807	\N	\N	Selles Directs - KOP	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.96	\N	\N	176	\N	\N	\N	52	Selles Directs - KOP	\N	t	f
810	\N	91	Numeration GB	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.967	\N	\N	176	\N	\N	\N	56	Numeration GB	\N	t	f
836	\N	\N	HIV - Determine	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.078	\N	\N	177	\N	\N	\N	31	HIV - Determine	\N	t	f
842	\N	\N	Crag serique	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.08	\N	\N	177	\N	\N	\N	37	Crag serique	\N	t	f
798	\N	\N	Groupage sanguin Rhesus	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.082	\N	\N	177	\N	\N	\N	16	Groupage sanguin Rhesus	\N	t	f
837	\N	\N	HIV - Unigold	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.085	\N	\N	177	\N	\N	\N	32	HIV - Unigold	\N	t	f
870	\N	\N	Hépatite B	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.087	\N	\N	177	\N	\N	\N	33	Hépatite B	\N	t	f
803	\N	88	Creatinine	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.11	\N	\N	196	\N	\N	\N	21	Creatinine	\N	t	f
804	\N	89	GPT	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.12	\N	\N	196	\N	\N	\N	22	GPT	\N	t	f
821	\N	90	Glycorachie	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.123	\N	\N	196	\N	\N	\N	68	Glycorachie	\N	t	f
832	\N	92	sodium	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.126	\N	\N	196	\N	\N	\N	25	sodium	\N	t	f
833	\N	92	potassium	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.135	\N	\N	196	\N	\N	\N	26	potassium	\N	t	f
844	\N	88	Gamma GT	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.141	\N	\N	196	\N	\N	\N	41	Gamma GT	\N	t	f
845	\N	88	Phosphatase alcaline	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.143	\N	\N	196	\N	\N	\N	42	Phosphatase alcaline	\N	t	f
784	\N	82	Globules Blancs	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.163	\N	\N	197	\N	\N	\N	1	Globules Blancs	\N	t	f
785	\N	83	Globules Rouges	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.165	\N	\N	197	\N	\N	\N	2	Globules Rouges	\N	t	f
840	\N	93	Hemoglobine	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.167	\N	\N	197	\N	\N	\N	3	Hemoglobine	\N	t	f
786	\N	84	Hematocrite	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.169	\N	\N	197	\N	\N	\N	4	Hematocrite	\N	t	f
787	\N	85	VGM	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.171	\N	\N	197	\N	\N	\N	5	VGM	\N	t	f
788	\N	84	CCMH	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.173	\N	\N	197	\N	\N	\N	6	CCMH	\N	t	f
789	\N	82	Plaquettes	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.175	\N	\N	197	\N	\N	\N	7	Plaquettes	\N	t	f
790	\N	84	LYM%	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.176	\N	\N	197	\N	\N	\N	8	LYM%	\N	t	f
791	\N	84	MXD% (Eosino+Monocytes)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.178	\N	\N	197	\N	\N	\N	9	MXD% (Eosino+Monocytes)	\N	t	f
792	\N	84	NEUT%	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.18	\N	\N	197	\N	\N	\N	10	NEUT%	\N	t	f
801	\N	87	CD4	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.184	\N	\N	197	\N	\N	\N	19	CD4	\N	t	f
877	\N	95	Charge Virale HIV - Logarithme	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.242	\N	\N	198	\N	\N	\N	30	Charge Virale HIV - Logarithme	\N	t	f
795	\N	86	Temps de coagulation	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.266	\N	\N	199	\N	\N	\N	13	Temps de coagulation	\N	t	f
796	\N	86	Temps de saignement	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.268	\N	\N	199	\N	\N	\N	14	Temps de saignement	\N	t	f
805	\N	90	Glycémie	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.269	\N	\N	199	\N	\N	\N	23	Glycémie	\N	t	f
838	\N	\N	Malaria	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.271	\N	\N	199	\N	\N	\N	35	Malaria	\N	t	f
839	\N	\N	Syphilis	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.273	\N	\N	199	\N	\N	\N	36	Syphilis	\N	t	f
843	\N	92	Lactate	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.275	\N	\N	199	\N	\N	\N	38	Lactate	\N	t	f
841	\N	93	Hemoglobine*	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.277	\N	\N	199	\N	\N	\N	103	Hemoglobine*	\N	t	f
848	\N	\N	Genexpert (Crachat)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.302	\N	\N	200	\N	\N	\N	86	Genexpert (Crachat)	\N	t	f
851	\N	\N	Genexpert (Pus)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.303	\N	\N	200	\N	\N	\N	83	Genexpert (Pus)	\N	t	f
857	\N	\N	Genexpert (Ascite)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.307	\N	\N	200	\N	\N	\N	92	Genexpert (Ascite)	\N	t	f
863	\N	\N	Genexpert (Ganglionnaire)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.31	\N	\N	200	\N	\N	\N	98	Genexpert (Ganglionnaire)	\N	t	f
847	\N	\N	Microscopie TB - Recherche de BAAR (Crachat)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.314	\N	\N	200	\N	\N	\N	85	Microscopie TB - Recherche de BAAR (Crachat)	\N	t	f
853	\N	\N	Microscopie TB - Recherche de BAAR (Gastrique)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.317	\N	\N	200	\N	\N	\N	88	Microscopie TB - Recherche de BAAR (Gastrique)	\N	t	f
859	\N	\N	Microscopie TB - Recherche de BAAR (Pleural)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.321	\N	\N	200	\N	\N	\N	94	Microscopie TB - Recherche de BAAR (Pleural)	\N	t	f
865	\N	\N	Microscopie TB - Recherche de BAAR (Synovial)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.325	\N	\N	200	\N	\N	\N	100	Microscopie TB - Recherche de BAAR (Synovial)	\N	t	f
831	\N	\N	Test de Grossesse	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.973	\N	\N	176	\N	\N	\N	81	Test de Grossesse	\N	t	f
852	\N	\N	Rivalta (Pus)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.976	\N	\N	176	\N	\N	\N	84	Rivalta (Pus)	\N	t	f
849	\N	\N	Rivalta (Crachat)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.978	\N	\N	176	\N	\N	\N	87	Rivalta (Crachat)	\N	t	f
855	\N	\N	Rivalta (Gastrique)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.98	\N	\N	176	\N	\N	\N	90	Rivalta (Gastrique)	\N	t	f
858	\N	\N	Rivalta (Ascite)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.982	\N	\N	176	\N	\N	\N	93	Rivalta (Ascite)	\N	t	f
861	\N	\N	Rivalta (Pleural)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.984	\N	\N	176	\N	\N	\N	96	Rivalta (Pleural)	\N	t	f
809	\N	\N	Selles I.O	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.993	\N	\N	176	\N	\N	\N	54	Selles I.O	\N	t	f
811	\N	84	FL - LYM%	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.995	\N	\N	176	\N	\N	\N	57	FL - LYM%	\N	t	f
812	\N	84	FL - MXD%	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.997	\N	\N	176	\N	\N	\N	58	FL - MXD%	\N	t	f
813	\N	84	FL - NEUT%	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.999	\N	\N	176	\N	\N	\N	59	FL - NEUT%	\N	t	f
814	\N	\N	Crag	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.004	\N	\N	176	\N	\N	\N	60	Crag	\N	t	f
816	\N	\N	Proteinorachie (test de Pandy)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.01	\N	\N	176	\N	\N	\N	62	Proteinorachie (test de Pandy)	\N	t	f
818	\N	\N	(If positif) Forme	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.021	\N	\N	176	\N	\N	\N	64	(If positif) Forme	\N	t	f
819	\N	\N	(If positif) Coloration	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.024	\N	\N	176	\N	\N	\N	65	(If positif) Coloration	\N	t	f
820	\N	\N	(If positif) Groupement	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.027	\N	\N	176	\N	\N	\N	66	(If positif) Groupement	\N	t	f
846	\N	\N	Microscopie TB - Recherche de BAAR (LCR)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.032	\N	\N	176	\N	\N	\N	67	Microscopie TB - Recherche de BAAR (LCR)	\N	t	f
822	\N	\N	Urobilinogène	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.034	\N	\N	176	\N	\N	\N	72	Urobilinogène	\N	t	f
823	\N	\N	Bilirubine	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.038	\N	\N	176	\N	\N	\N	73	Bilirubine	\N	t	f
824	\N	\N	Protéines	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.04	\N	\N	176	\N	\N	\N	74	Protéines	\N	t	f
825	\N	\N	Nitrites	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.042	\N	\N	176	\N	\N	\N	75	Nitrites	\N	t	f
826	\N	\N	Corps cétoniques	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.044	\N	\N	176	\N	\N	\N	76	Corps cétoniques	\N	t	f
828	\N	\N	Glucose	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.048	\N	\N	176	\N	\N	\N	78	Glucose	\N	t	f
829	\N	\N	pH	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.05	\N	\N	176	\N	\N	\N	79	pH	\N	t	f
830	\N	\N	Leucocytes	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.052	\N	\N	176	\N	\N	\N	80	Leucocytes	\N	t	f
872	\N	89	Bilirubine totalE	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.128	\N	\N	196	\N	\N	\N	39	Bilirubine totalE	\N	t	f
874	\N	92	Calcium	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.131	\N	\N	196	\N	\N	\N	43	Calcium	\N	t	f
875	\N	89	Lipase	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.133	\N	\N	196	\N	\N	\N	44	Lipase	\N	t	f
873	\N	89	Bilirubine directE	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.139	\N	\N	196	\N	\N	\N	40	Bilirubine directE	\N	t	f
876	\N	94	Charge Virale HIV - Value	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.24	\N	\N	198	\N	\N	\N	29	Charge Virale HIV - Value	\N	t	f
864	\N	\N	Rivalta (Ganglionnaire)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.987	\N	\N	176	\N	\N	\N	99	Rivalta (Ganglionnaire)	\N	t	f
808	\N	\N	Selles Directs - Type	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:13.991	\N	\N	176	\N	\N	\N	53	Selles Directs - Type	\N	t	f
815	\N	\N	Encre de chine	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.008	\N	\N	176	\N	\N	\N	61	Encre de chine	\N	t	f
817	\N	\N	Gram	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.012	\N	\N	176	\N	\N	\N	63	Gram	\N	t	f
827	\N	\N	Acide ascorbique	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.046	\N	\N	176	\N	\N	\N	77	Acide ascorbique	\N	t	f
797	\N	\N	Groupage sanguin ABO	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.076	\N	\N	177	\N	\N	\N	15	Groupage sanguin ABO	\N	t	f
799	\N	\N	Test de compatibilité	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.084	\N	\N	177	\N	\N	\N	17	Test de compatibilité	\N	t	f
834	\N	92	Chlore	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.137	\N	\N	196	\N	\N	\N	27	Chlore	\N	t	f
835	\N	\N	EID (PCR)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.238	\N	\N	198	\N	\N	\N	28	EID (PCR)	\N	t	f
860	\N	\N	Genexpert (Pleural)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.309	\N	\N	200	\N	\N	\N	95	Genexpert (Pleural)	\N	t	f
850	\N	\N	Microscopie TB - Recherche de BAAR (Pus)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.316	\N	\N	200	\N	\N	\N	82	Microscopie TB - Recherche de BAAR (Pus)	\N	t	f
856	\N	\N	Microscopie TB - Recherche de BAAR (Ascite)	\N	\N	\N	Y	\N	\N	\N	\N	\N	\N	\N	\N	\N	2018-01-05 15:53:14.319	\N	\N	200	\N	\N	\N	91	Microscopie TB - Recherche de BAAR (Ascite)	\N	t	f
\.


--
-- Data for Name: test_analyte; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY test_analyte (id, test_id, analyte_id, result_group, sort_order, testalyt_type, lastupdated, is_reportable) FROM stdin;
\.


--
-- Name: test_analyte_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('test_analyte_seq', 280, true);


--
-- Data for Name: test_code; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY test_code (test_id, code_type_id, value, lastupdated) FROM stdin;
\.


--
-- Data for Name: test_code_type; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY test_code_type (id, schema_name, lastupdated) FROM stdin;
1	LOINC	2012-04-24 00:30:07.075933+00
2	SNOMED	2012-04-24 00:30:07.075933+00
3	billingCode	2013-08-08 08:02:34.814891+00
4	analyzeCode	2013-08-08 08:02:34.814891+00
\.


--
-- Data for Name: test_formats; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY test_formats (id, lastupdated) FROM stdin;
\.


--
-- Data for Name: test_reflex; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY test_reflex (id, tst_rslt_id, flags, lastupdated, test_analyte_id, test_id, add_test_id, sibling_reflex, scriptlet_id) FROM stdin;
\.


--
-- Name: test_reflex_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('test_reflex_seq', 6, true);


--
-- Data for Name: test_result; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY test_result (id, test_id, result_group, flags, tst_rslt_type, value, significant_digits, quant_limit, cont_level, lastupdated, scriptlet_id, sort_order, abnormal, is_active) FROM stdin;
2611	808	\N	\N	R	\N	\N	\N	\N	2018-01-05 15:53:06.096	\N	\N	\N	t
2724	859	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.795	\N	\N	\N	t
2725	859	\N	\N	D	1219	\N	\N	\N	2018-01-05 15:53:10.798	\N	\N	\N	t
2726	859	\N	\N	D	1240	\N	\N	\N	2018-01-05 15:53:10.802	\N	\N	\N	t
2727	859	\N	\N	D	1241	\N	\N	\N	2018-01-05 15:53:10.805	\N	\N	\N	t
2728	859	\N	\N	D	1242	\N	\N	\N	2018-01-05 15:53:10.809	\N	\N	\N	t
2729	860	\N	\N	D	1280	\N	\N	\N	2018-01-05 15:53:11.576	\N	\N	\N	t
2730	860	\N	\N	D	1281	\N	\N	\N	2018-01-05 15:53:11.581	\N	\N	\N	t
2731	860	\N	\N	D	1282	\N	\N	\N	2018-01-05 15:53:11.586	\N	\N	\N	t
2732	860	\N	\N	D	1283	\N	\N	\N	2018-01-05 15:53:11.591	\N	\N	\N	t
2694	850	\N	\N	D	1241	\N	\N	\N	2018-01-05 15:53:11.633	\N	\N	\N	t
2695	850	\N	\N	D	1242	\N	\N	\N	2018-01-05 15:53:11.638	\N	\N	\N	t
2700	852	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:10.565	\N	\N	\N	t
2701	852	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.569	\N	\N	\N	t
2718	857	\N	\N	D	1280	\N	\N	\N	2018-01-05 15:53:10.766	\N	\N	\N	t
2719	857	\N	\N	D	1281	\N	\N	\N	2018-01-05 15:53:10.769	\N	\N	\N	t
2720	857	\N	\N	D	1282	\N	\N	\N	2018-01-05 15:53:10.772	\N	\N	\N	t
2721	857	\N	\N	D	1283	\N	\N	\N	2018-01-05 15:53:10.776	\N	\N	\N	t
2711	855	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:11.002	\N	\N	\N	t
2712	855	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.006	\N	\N	\N	t
2696	851	\N	\N	D	1280	\N	\N	\N	2018-01-05 15:53:11.2	\N	\N	\N	t
2697	851	\N	\N	D	1281	\N	\N	\N	2018-01-05 15:53:11.204	\N	\N	\N	t
2698	851	\N	\N	D	1282	\N	\N	\N	2018-01-05 15:53:11.209	\N	\N	\N	t
2699	851	\N	\N	D	1283	\N	\N	\N	2018-01-05 15:53:11.214	\N	\N	\N	t
2702	853	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.254	\N	\N	\N	t
2703	853	\N	\N	D	1219	\N	\N	\N	2018-01-05 15:53:11.258	\N	\N	\N	t
2704	853	\N	\N	D	1240	\N	\N	\N	2018-01-05 15:53:11.263	\N	\N	\N	t
2705	853	\N	\N	D	1241	\N	\N	\N	2018-01-05 15:53:11.268	\N	\N	\N	t
2706	853	\N	\N	D	1242	\N	\N	\N	2018-01-05 15:53:11.272	\N	\N	\N	t
2722	858	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:11.38	\N	\N	\N	t
2723	858	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.385	\N	\N	\N	t
2707	854	\N	\N	D	1280	\N	\N	\N	2018-01-05 15:53:11.436	\N	\N	\N	t
2708	854	\N	\N	D	1281	\N	\N	\N	2018-01-05 15:53:11.443	\N	\N	\N	t
2709	854	\N	\N	D	1282	\N	\N	\N	2018-01-05 15:53:11.449	\N	\N	\N	t
2710	854	\N	\N	D	1283	\N	\N	\N	2018-01-05 15:53:11.454	\N	\N	\N	t
2713	856	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.793	\N	\N	\N	t
2714	856	\N	\N	D	1219	\N	\N	\N	2018-01-05 15:53:11.799	\N	\N	\N	t
2715	856	\N	\N	D	1240	\N	\N	\N	2018-01-05 15:53:11.804	\N	\N	\N	t
2716	856	\N	\N	D	1241	\N	\N	\N	2018-01-05 15:53:11.81	\N	\N	\N	t
2717	856	\N	\N	D	1242	\N	\N	\N	2018-01-05 15:53:11.815	\N	\N	\N	t
2755	867	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:10.397	\N	\N	\N	t
2756	867	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.401	\N	\N	\N	t
2735	862	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.413	\N	\N	\N	t
2736	862	\N	\N	D	1219	\N	\N	\N	2018-01-05 15:53:10.416	\N	\N	\N	t
2737	862	\N	\N	D	1240	\N	\N	\N	2018-01-05 15:53:10.419	\N	\N	\N	t
2738	862	\N	\N	D	1241	\N	\N	\N	2018-01-05 15:53:10.422	\N	\N	\N	t
2739	862	\N	\N	D	1242	\N	\N	\N	2018-01-05 15:53:10.425	\N	\N	\N	t
2765	871	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:10.486	\N	\N	\N	t
2766	871	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.488	\N	\N	\N	t
2733	861	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:10.512	\N	\N	\N	t
2734	861	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.515	\N	\N	\N	t
2761	869	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:10.885	\N	\N	\N	t
2762	869	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.889	\N	\N	\N	t
2757	868	\N	\N	D	1280	\N	\N	\N	2018-01-05 15:53:10.922	\N	\N	\N	t
2758	868	\N	\N	D	1281	\N	\N	\N	2018-01-05 15:53:10.926	\N	\N	\N	t
2759	868	\N	\N	D	1282	\N	\N	\N	2018-01-05 15:53:10.93	\N	\N	\N	t
2760	868	\N	\N	D	1283	\N	\N	\N	2018-01-05 15:53:10.933	\N	\N	\N	t
2751	866	\N	\N	D	1280	\N	\N	\N	2018-01-05 15:53:11.399	\N	\N	\N	t
2752	866	\N	\N	D	1281	\N	\N	\N	2018-01-05 15:53:11.412	\N	\N	\N	t
2753	866	\N	\N	D	1282	\N	\N	\N	2018-01-05 15:53:11.417	\N	\N	\N	t
2754	866	\N	\N	D	1283	\N	\N	\N	2018-01-05 15:53:11.423	\N	\N	\N	t
2680	847	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.442	\N	\N	\N	t
2681	847	\N	\N	D	1219	\N	\N	\N	2018-01-05 15:53:10.445	\N	\N	\N	t
2682	847	\N	\N	D	1240	\N	\N	\N	2018-01-05 15:53:10.448	\N	\N	\N	t
2683	847	\N	\N	D	1241	\N	\N	\N	2018-01-05 15:53:10.451	\N	\N	\N	t
2684	847	\N	\N	D	1242	\N	\N	\N	2018-01-05 15:53:10.454	\N	\N	\N	t
2689	849	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:10.47	\N	\N	\N	t
2690	849	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.473	\N	\N	\N	t
2625	819	\N	\N	D	1217	\N	\N	\N	2018-01-05 15:53:10.501	\N	\N	\N	t
2626	819	\N	\N	D	1218	\N	\N	\N	2018-01-05 15:53:10.504	\N	\N	\N	t
2665	836	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:10.528	\N	\N	\N	t
2666	836	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.531	\N	\N	\N	t
2639	825	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.542	\N	\N	\N	t
2640	825	\N	\N	D	1240	\N	\N	\N	2018-01-05 15:53:10.546	\N	\N	\N	t
2641	825	\N	\N	D	1241	\N	\N	\N	2018-01-05 15:53:10.549	\N	\N	\N	t
2642	825	\N	\N	D	1242	\N	\N	\N	2018-01-05 15:53:10.554	\N	\N	\N	t
2669	838	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:10.587	\N	\N	\N	t
2670	838	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.591	\N	\N	\N	t
2601	800	\N	\N	D	1222	\N	\N	\N	2018-01-05 15:53:10.655	\N	\N	\N	t
2602	800	\N	\N	D	1223	\N	\N	\N	2018-01-05 15:53:10.659	\N	\N	\N	t
2740	863	\N	\N	D	1280	\N	\N	\N	2018-01-05 15:53:10.667	\N	\N	\N	t
2741	863	\N	\N	D	1281	\N	\N	\N	2018-01-05 15:53:10.67	\N	\N	\N	t
2742	863	\N	\N	D	1282	\N	\N	\N	2018-01-05 15:53:10.673	\N	\N	\N	t
2743	863	\N	\N	D	1283	\N	\N	\N	2018-01-05 15:53:10.677	\N	\N	\N	t
2651	829	\N	\N	D	1264	\N	\N	\N	2018-01-05 15:53:10.685	\N	\N	\N	t
2652	829	\N	\N	D	1265	\N	\N	\N	2018-01-05 15:53:10.688	\N	\N	\N	t
2653	829	\N	\N	D	1266	\N	\N	\N	2018-01-05 15:53:10.692	\N	\N	\N	t
2654	829	\N	\N	D	1267	\N	\N	\N	2018-01-05 15:53:10.696	\N	\N	\N	t
2655	829	\N	\N	D	1268	\N	\N	\N	2018-01-05 15:53:10.703	\N	\N	\N	t
2667	837	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:10.721	\N	\N	\N	t
2668	837	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.724	\N	\N	\N	t
2673	842	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:10.743	\N	\N	\N	t
2674	842	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.746	\N	\N	\N	t
2633	823	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:10.754	\N	\N	\N	t
2634	823	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.757	\N	\N	\N	t
2746	865	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.817	\N	\N	\N	t
2747	865	\N	\N	D	1219	\N	\N	\N	2018-01-05 15:53:10.821	\N	\N	\N	t
2748	865	\N	\N	D	1240	\N	\N	\N	2018-01-05 15:53:10.824	\N	\N	\N	t
2749	865	\N	\N	D	1241	\N	\N	\N	2018-01-05 15:53:10.828	\N	\N	\N	t
2750	865	\N	\N	D	1242	\N	\N	\N	2018-01-05 15:53:10.831	\N	\N	\N	t
2675	846	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.846	\N	\N	\N	t
2676	846	\N	\N	D	1219	\N	\N	\N	2018-01-05 15:53:10.849	\N	\N	\N	t
2677	846	\N	\N	D	1240	\N	\N	\N	2018-01-05 15:53:10.853	\N	\N	\N	t
2678	846	\N	\N	D	1241	\N	\N	\N	2018-01-05 15:53:10.857	\N	\N	\N	t
2679	846	\N	\N	D	1242	\N	\N	\N	2018-01-05 15:53:10.86	\N	\N	\N	t
2608	807	\N	\N	D	1245	\N	\N	\N	2018-01-05 15:53:10.869	\N	\N	\N	t
2609	807	\N	\N	D	1246	\N	\N	\N	2018-01-05 15:53:10.873	\N	\N	\N	t
2610	807	\N	\N	D	1247	\N	\N	\N	2018-01-05 15:53:10.877	\N	\N	\N	t
2763	870	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:10.909	\N	\N	\N	t
2764	870	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.913	\N	\N	\N	t
2623	818	\N	\N	D	1215	\N	\N	\N	2018-01-05 15:53:10.955	\N	\N	\N	t
2624	818	\N	\N	D	1216	\N	\N	\N	2018-01-05 15:53:10.959	\N	\N	\N	t
2635	824	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.968	\N	\N	\N	t
2636	824	\N	\N	D	1240	\N	\N	\N	2018-01-05 15:53:10.972	\N	\N	\N	t
2637	824	\N	\N	D	1241	\N	\N	\N	2018-01-05 15:53:10.976	\N	\N	\N	t
2638	824	\N	\N	D	1242	\N	\N	\N	2018-01-05 15:53:10.979	\N	\N	\N	t
2615	814	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:10.988	\N	\N	\N	t
2616	814	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:10.992	\N	\N	\N	t
2603	806	\N	\N	D	1240	\N	\N	\N	2018-01-05 15:53:11.026	\N	\N	\N	t
2604	806	\N	\N	D	1241	\N	\N	\N	2018-01-05 15:53:11.035	\N	\N	\N	t
2605	806	\N	\N	D	1242	\N	\N	\N	2018-01-05 15:53:11.041	\N	\N	\N	t
2606	806	\N	\N	D	1243	\N	\N	\N	2018-01-05 15:53:11.045	\N	\N	\N	t
2607	806	\N	\N	D	1244	\N	\N	\N	2018-01-05 15:53:11.05	\N	\N	\N	t
2647	828	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.067	\N	\N	\N	t
2648	828	\N	\N	D	1240	\N	\N	\N	2018-01-05 15:53:11.071	\N	\N	\N	t
2649	828	\N	\N	D	1241	\N	\N	\N	2018-01-05 15:53:11.076	\N	\N	\N	t
2650	828	\N	\N	D	1242	\N	\N	\N	2018-01-05 15:53:11.08	\N	\N	\N	t
2643	826	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:11.09	\N	\N	\N	t
2644	826	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.094	\N	\N	\N	t
2619	816	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:11.112	\N	\N	\N	t
2620	816	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.116	\N	\N	\N	t
2587	794	\N	\N	D	1200	\N	\N	\N	2018-01-05 15:53:11.141	\N	\N	\N	t
2588	794	\N	\N	D	1201	\N	\N	\N	2018-01-05 15:53:11.145	\N	\N	\N	t
2589	794	\N	\N	D	1202	\N	\N	\N	2018-01-05 15:53:11.15	\N	\N	\N	t
2590	794	\N	\N	D	1203	\N	\N	\N	2018-01-05 15:53:11.154	\N	\N	\N	t
2591	794	\N	\N	D	1204	\N	\N	\N	2018-01-05 15:53:11.159	\N	\N	\N	t
2592	794	\N	\N	D	1205	\N	\N	\N	2018-01-05 15:53:11.164	\N	\N	\N	t
2631	822	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:11.176	\N	\N	\N	t
2632	822	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.181	\N	\N	\N	t
2685	848	\N	\N	D	1280	\N	\N	\N	2018-01-05 15:53:11.229	\N	\N	\N	t
2686	848	\N	\N	D	1281	\N	\N	\N	2018-01-05 15:53:11.233	\N	\N	\N	t
2687	848	\N	\N	D	1282	\N	\N	\N	2018-01-05 15:53:11.238	\N	\N	\N	t
2688	848	\N	\N	D	1283	\N	\N	\N	2018-01-05 15:53:11.242	\N	\N	\N	t
2597	798	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:11.29	\N	\N	\N	t
2598	798	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.295	\N	\N	\N	t
2671	839	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:11.334	\N	\N	\N	t
2672	839	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.354	\N	\N	\N	t
2612	809	\N	\N	D	1212	\N	\N	\N	2018-01-05 15:53:11.469	\N	\N	\N	t
2613	809	\N	\N	D	1213	\N	\N	\N	2018-01-05 15:53:11.474	\N	\N	\N	t
2614	809	\N	\N	D	1214	\N	\N	\N	2018-01-05 15:53:11.479	\N	\N	\N	t
2627	820	\N	\N	D	1260	\N	\N	\N	2018-01-05 15:53:11.5	\N	\N	\N	t
2628	820	\N	\N	D	1261	\N	\N	\N	2018-01-05 15:53:11.506	\N	\N	\N	t
2629	820	\N	\N	D	1262	\N	\N	\N	2018-01-05 15:53:11.511	\N	\N	\N	t
2630	820	\N	\N	D	1263	\N	\N	\N	2018-01-05 15:53:11.516	\N	\N	\N	t
2661	831	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:11.528	\N	\N	\N	t
2662	831	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.533	\N	\N	\N	t
2656	830	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.544	\N	\N	\N	t
2657	830	\N	\N	D	1240	\N	\N	\N	2018-01-05 15:53:11.55	\N	\N	\N	t
2658	830	\N	\N	D	1241	\N	\N	\N	2018-01-05 15:53:11.555	\N	\N	\N	t
2659	830	\N	\N	D	1242	\N	\N	\N	2018-01-05 15:53:11.56	\N	\N	\N	t
2660	830	\N	\N	D	1243	\N	\N	\N	2018-01-05 15:53:11.565	\N	\N	\N	t
2621	817	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:11.602	\N	\N	\N	t
2622	817	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.607	\N	\N	\N	t
2691	850	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.618	\N	\N	\N	t
2692	850	\N	\N	D	1219	\N	\N	\N	2018-01-05 15:53:11.623	\N	\N	\N	t
2693	850	\N	\N	D	1240	\N	\N	\N	2018-01-05 15:53:11.628	\N	\N	\N	t
2645	827	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:11.65	\N	\N	\N	t
2646	827	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.655	\N	\N	\N	t
2617	815	\N	\N	D	1248	\N	\N	\N	2018-01-05 15:53:11.674	\N	\N	\N	t
2618	815	\N	\N	D	1249	\N	\N	\N	2018-01-05 15:53:11.679	\N	\N	\N	t
2599	799	\N	\N	D	1220	\N	\N	\N	2018-01-05 15:53:11.691	\N	\N	\N	t
2600	799	\N	\N	D	1221	\N	\N	\N	2018-01-05 15:53:11.697	\N	\N	\N	t
2663	835	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:11.728	\N	\N	\N	t
2664	835	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.733	\N	\N	\N	t
2744	864	\N	\N	D	1210	\N	\N	\N	2018-01-05 15:53:11.746	\N	\N	\N	t
2745	864	\N	\N	D	1211	\N	\N	\N	2018-01-05 15:53:11.751	\N	\N	\N	t
2593	797	\N	\N	D	1206	\N	\N	\N	2018-01-05 15:53:11.764	\N	\N	\N	t
2594	797	\N	\N	D	1207	\N	\N	\N	2018-01-05 15:53:11.769	\N	\N	\N	t
2595	797	\N	\N	D	1208	\N	\N	\N	2018-01-05 15:53:11.775	\N	\N	\N	t
2596	797	\N	\N	D	1209	\N	\N	\N	2018-01-05 15:53:11.781	\N	\N	\N	t
\.


--
-- Name: test_result_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('test_result_seq', 2766, true);


--
-- Data for Name: test_section; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY test_section (id, name, description, org_id, is_external, lastupdated, parent_test_section, display_key, sort_order, is_active, uuid) FROM stdin;
136	user	Indicates user will chose test section	3	N	2013-08-08 08:02:35.294475	\N	\N	2147483647	N	d3148c8c-1b09-45d5-967b-ffeb90afd1a0
156	New	Dummy Section	\N	N	\N	\N	\N	2147483647	N	3818def0-4b50-48f2-9baa-9d499d1a7c6c
176	1	1	1284	\N	2018-01-05 15:53:13.935	\N	\N	0	Y	c7b40e84-f1f6-11e7-b81f-0a7176ae86de
177	2	2	1284	\N	2018-01-05 15:53:14.073	\N	\N	0	Y	c7b43cda-f1f6-11e7-b81f-0a7176ae86de
196	3	3	1284	\N	2018-01-05 15:53:14.107	\N	\N	0	Y	c7b46b9e-f1f6-11e7-b81f-0a7176ae86de
197	4	4	1284	\N	2018-01-05 15:53:14.16	\N	\N	0	Y	c7b49a3c-f1f6-11e7-b81f-0a7176ae86de
198	CV	CV	1284	\N	2018-01-05 15:53:14.236	\N	\N	0	Y	c7b59d43-f1f6-11e7-b81f-0a7176ae86de
199	PR	PR	1284	\N	2018-01-05 15:53:14.263	\N	\N	0	Y	c7b5d1c0-f1f6-11e7-b81f-0a7176ae86de
200	TB	TB	1284	\N	2018-01-05 15:53:14.298	\N	\N	0	Y	c7b6bceb-f1f6-11e7-b81f-0a7176ae86de
\.


--
-- Name: test_section_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('test_section_seq', 215, true);


--
-- Name: test_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('test_seq', 877, true);


--
-- Data for Name: test_trailer; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY test_trailer (id, name, description, text, lastupdated) FROM stdin;
\.


--
-- Name: test_trailer_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('test_trailer_seq', 2, false);


--
-- Data for Name: test_worksheet_item; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY test_worksheet_item (id, tw_id, qc_id, "position", cell_type) FROM stdin;
\.


--
-- Data for Name: test_worksheets; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY test_worksheets (id, test_id, batch_capacity, total_capacity, number_format) FROM stdin;
\.


--
-- Name: tobereomved_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('tobereomved_seq', 1, false);


--
-- Data for Name: type_of_provider; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY type_of_provider (id, description, tp_code) FROM stdin;
\.


--
-- Data for Name: type_of_sample; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY type_of_sample (id, description, domain, lastupdated, local_abbrev, display_key, is_active, sort_order, uuid) FROM stdin;
83	Selles (Sample)	H	2018-01-05 15:53:13.499	Selles (Sample)	\N	t	2	c7b74bac-f1f6-11e7-b81f-0a7176ae86de
84	Urine	H	2018-01-05 15:53:13.522	Urine	\N	t	3	c7b7948c-f1f6-11e7-b81f-0a7176ae86de
85	LCR (Sample)	H	2018-01-05 15:53:13.583	LCR (Sample)	\N	t	4	c7b7f4ce-f1f6-11e7-b81f-0a7176ae86de
86	Crachat	H	2018-01-05 15:53:13.731	Crachat	\N	t	5	c7b82b1d-f1f6-11e7-b81f-0a7176ae86de
87	Liquide d'épanchement pleural	H	2018-01-05 15:53:13.758	Liquide d'épanchement pleural	\N	t	6	c7b8763c-f1f6-11e7-b81f-0a7176ae86de
88	Liquide ascite	H	2018-01-05 15:53:13.784	Liquide ascite	\N	t	7	c7b8c74a-f1f6-11e7-b81f-0a7176ae86de
89	Pus	H	2018-01-05 15:53:13.809	Pus	\N	t	8	c7b8f6f4-f1f6-11e7-b81f-0a7176ae86de
90	Suc ganglionnaire	H	2018-01-05 15:53:13.832	Suc ganglionnaire	\N	t	9	c7b925a3-f1f6-11e7-b81f-0a7176ae86de
91	Liquide Synovial	H	2018-01-05 15:53:13.861	Liquide Synovial	\N	t	10	c7b953ef-f1f6-11e7-b81f-0a7176ae86de
92	Suc gastrique	H	2018-01-05 15:53:13.887	Suc gastrique	\N	t	11	c7b98465-f1f6-11e7-b81f-0a7176ae86de
82	Sang	H	2018-01-05 15:53:14.349	Sang	\N	t	1	c7b6f0e6-f1f6-11e7-b81f-0a7176ae86de
\.


--
-- Name: type_of_sample_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('type_of_sample_seq', 92, true);


--
-- Data for Name: type_of_test_result; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY type_of_test_result (id, test_result_type, description, lastupdated, hl7_value) FROM stdin;
2	D	Dictionary	2006-11-08 11:40:58.824	TX
3	T	Titer	2006-03-29 11:53:15	TX
4	N	Numeric	2006-03-29 11:53:21	NM
1	R	Remark	2010-10-28 06:12:41.971687	TX
5	A	Alpha,no range check	2010-10-28 06:13:53.177655	TX
6	M	Multiselect	2011-01-06 10:57:15.79331	TX
\.


--
-- Name: type_of_test_result_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('type_of_test_result_seq', 6, true);


--
-- Data for Name: unit_of_measure; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY unit_of_measure (id, name, description, lastupdated, uuid) FROM stdin;
82	10³/mm³	\N	2018-01-05 15:53:04.938	\N
83	10⁶/mm³	\N	2018-01-05 15:53:04.982	\N
84	%	\N	2018-01-05 15:53:05.015	\N
85	fl	\N	2018-01-05 15:53:05.06	\N
86	min	\N	2018-01-05 15:53:05.489	\N
87	cells/µl	\N	2018-01-05 15:53:05.779	\N
88	µmol/L	\N	2018-01-05 15:53:05.849	\N
89	UI/L	\N	2018-01-05 15:53:05.918	\N
90	mg/dl	\N	2018-01-05 15:53:05.946	\N
91	cells/mm³	\N	2018-01-05 15:53:06.212	\N
92	mmol/L	\N	2018-01-05 15:53:07.261	\N
93	g/dl	\N	2018-01-05 15:53:07.584	\N
94	copies/ml	\N	2018-01-05 15:53:09.404	\N
95	log	\N	2018-01-05 15:53:09.435	\N
\.


--
-- Name: unit_of_measure_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('unit_of_measure_seq', 95, true);


--
-- Data for Name: user_alert_map; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY user_alert_map (user_id, alert_id, report_id, alert_limit, alert_operator, map_id) FROM stdin;
\.


--
-- Data for Name: user_group_map; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY user_group_map (user_id, group_id, map_id) FROM stdin;
1	1120	0
241	1121	0
\.


--
-- Data for Name: user_security; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY user_security (user_id, role_name) FROM stdin;
1	ROOT_ADMIN_ROLE
1	LOG_VIEWER_ROLE
1	UPLOAD_ROLE
1	GROUP_ADMIN_ROLE
1	DATASOURCE_ADMIN_ROLE
1	CHART_ADMIN_ROLE
1	REPORT_ADMIN_ROLE
1	ADVANCED_SCHEDULER_ROLE
1	PARAMETER_ADMIN_ROLE
1	SCHEDULER_ROLE
1	ROOT_ADMIN_ROLE
1	LOG_VIEWER_ROLE
1	UPLOAD_ROLE
1	GROUP_ADMIN_ROLE
1	DATASOURCE_ADMIN_ROLE
1	CHART_ADMIN_ROLE
1	REPORT_ADMIN_ROLE
1	ADVANCED_SCHEDULER_ROLE
1	PARAMETER_ADMIN_ROLE
1	SCHEDULER_ROLE
1	ROOT_ADMIN_ROLE
1	LOG_VIEWER_ROLE
1	UPLOAD_ROLE
1	GROUP_ADMIN_ROLE
1	DATASOURCE_ADMIN_ROLE
1	CHART_ADMIN_ROLE
1	REPORT_ADMIN_ROLE
1	ADVANCED_SCHEDULER_ROLE
1	PARAMETER_ADMIN_ROLE
1	SCHEDULER_ROLE
1	ROOT_ADMIN_ROLE
1	LOG_VIEWER_ROLE
1	UPLOAD_ROLE
1	GROUP_ADMIN_ROLE
1	DATASOURCE_ADMIN_ROLE
1	CHART_ADMIN_ROLE
1	REPORT_ADMIN_ROLE
1	ADVANCED_SCHEDULER_ROLE
1	PARAMETER_ADMIN_ROLE
1	SCHEDULER_ROLE
1	ROOT_ADMIN_ROLE
1	LOG_VIEWER_ROLE
1	UPLOAD_ROLE
1	GROUP_ADMIN_ROLE
1	DATASOURCE_ADMIN_ROLE
1	CHART_ADMIN_ROLE
1	REPORT_ADMIN_ROLE
1	ADVANCED_SCHEDULER_ROLE
1	PARAMETER_ADMIN_ROLE
1	SCHEDULER_ROLE
1	ROOT_ADMIN_ROLE
1	LOG_VIEWER_ROLE
1	UPLOAD_ROLE
1	GROUP_ADMIN_ROLE
1	DATASOURCE_ADMIN_ROLE
1	CHART_ADMIN_ROLE
1	REPORT_ADMIN_ROLE
1	ADVANCED_SCHEDULER_ROLE
1	PARAMETER_ADMIN_ROLE
1	SCHEDULER_ROLE
\.


--
-- Data for Name: worksheet_analysis; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY worksheet_analysis (id, reference_type, reference_id, worksheet_item_id) FROM stdin;
\.


--
-- Data for Name: worksheet_analyte; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY worksheet_analyte (id, wrkst_anls_id, sort_order, result_id) FROM stdin;
\.


--
-- Data for Name: worksheet_heading; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY worksheet_heading (id, worksheet_name, rownumber, column1, column2, column3, column4, column5, column6, column7, column8, column9, column10, type) FROM stdin;
1	TB	1	Micro Result	Culture Result	Report Date	\N	\N	\N	\N	\N	\N	\N	RESULT
2	GC	1	12 HOUR	24 HOUR	48 HOUR	\N	\N	\N	\N	\N	\N	\N	RESULT
9	US FTA	7	\N	\N	\N	\N	PBS	.	.	.	-	.	QC
10	US FTA	8	\N	\N	\N	\N	Sorbent	.	.	.	-	.	QC
8	US FTA	6	PBS	.	.	.	Nonspecific Control / Sorbent	.	.	.	-	.	QC
11	US FTA	1	    USR     Repeat Quant	   FTA      Current Run	    FTA     Previous Runs	   FTA         Final	  TPPA       Result	Comments	\N	\N	\N	\N	RESULT
26	US FTA	1	TEST	TESTing	\N	\N	\N	\N	\N	\N	\N	\N	ANALYTE
7	US FTA	5	.	.	.	.	Nonspecific Control/ PBS	.	.	.	>2+	.	QC
6	US FTA	4	FITCconjugate Working Dilution:	.	.	.	Minimally Reactive Control	.	.	.	1+	.	QC
5	US FTA	3	Sorbent	.	.	.	Reactive Control / Sorbent	.	.	.	3-4+	.	QC
4	US FTA	2	T Palladium antigen	.	.	.	Reactive Control/PBS	.	.	.	4+	.	QC
3	US FTA	1	Reagent	Source	Lot	Expire Date	Reagent	Source	Lot	Expires	Expect	Actual	QC
25	F	23	KNO3	RT incubation	.	.	\N	\N	\N	\N	\N	\N	ANALYTE
24	F	22	dulcitol	chlamydospores	.	.	\N	\N	\N	\N	\N	\N	ANALYTE
23	F	21	melibiose	ascospores	NO3	.	\N	\N	\N	\N	\N	\N	ANALYTE
22	F	20	trehalose	pigment	gelatin	.	\N	\N	\N	\N	\N	\N	ANALYTE
21	F	19	xylose	germ tubes	urea	probe (histo)	\N	\N	\N	\N	\N	\N	ANALYTE
20	F	18	inositol	urea	T4	probe (blasto)	\N	\N	\N	\N	\N	\N	ANALYTE
19	F	17	raffinose	OTHER TESTS	T3	probe (cocci)	\N	\N	\N	\N	\N	\N	ANALYTE
18	F	16	cellobiose	galactose	T2	PROBE TESTS	\N	\N	\N	\N	\N	\N	ANALYTE
17	F	15	galactose	trehalose	T1	.	\N	\N	\N	\N	\N	\N	ANALYTE
16	F	14	lactose	lactose	37 degrees	lysozyme	\N	\N	\N	\N	\N	\N	ANALYTE
15	F	13	sucrose	sucrose	RT incubation	xanthine	\N	\N	\N	\N	\N	\N	ANALYTE
14	F	12	maltose	maltose	sabs without CH	tyrosine	\N	\N	\N	\N	\N	\N	ANALYTE
13	F	11	dextrose	dextrose	sabs with CH	casein	\N	\N	\N	\N	\N	\N	ANALYTE
12	F	10	ASSIMILATIONS	FERMENTATIONS	FILAMENTOUS	ACTINOMYCETES	\N	\N	\N	\N	\N	\N	ANALYTE
62	US VDRL	1	QL	QN:2	4	8	16	32	64	128	256	Final	RESULT
93	US USR	15	Titer	.	.	.	.	.	.	.	\N	\N	QC
96	US FTA	10	\N	\N	\N	\N	TPPA - control	.	.	.	-	.	QC
95	US FTA	9	\N	\N	\N	\N	TPPA + control	.	.	.	+	.	QC
49	US USR	11	CONTROLS	SOURCE	LOT	EXPIRE DATE	RESULTS Qualitative Expect	RESULTS Qualitative  Actual	RESULTS Quantitative Expect	RESULTS Quantitative Actual	\N	\N	QC
48	US USR	10	Rotation of Slides	178-182	__________	rotations/min	\N	\N	\N	\N	\N	\N	QC
47	US USR	9	Temp of Lab	23-29	__________	degrees C	\N	\N	\N	\N	\N	\N	QC
46	US USR	6	Sterile DI H20	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
45	US USR	8	USR working antigen	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
44	US USR	5	Phosphate Buffer	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
43	US USR	4	EDTA	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
42	US USR	3	Choline Chloride	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
41	US USR	2	VDRL Antigen Kit	Difco	.	.	\N	\N	\N	\N	\N	\N	QC
40	US USR	1	REAGENT	SOURCE	LOT	EXPIRE DATE	\N	\N	\N	\N	\N	\N	QC
52	US USR	14	NC	Difco	.	.	NR	.	.	.	\N	\N	QC
51	US USR	13	LPC	Difco	.	.	WR	.	.	.	\N	\N	QC
50	US USR	12	HPC	Difco	.	.	R	.	.	.	\N	\N	QC
55	HSV TYPING	3	Expiration Date:	________________	Negative Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
54	HSV TYPING	2	Lot:	________________	HSV2 Positive Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
53	HSV TYPING	1	HSV1 / HSV2 Typing Kit:	________________	HSV1 Positive Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
57	HSV TYPING	2	HSV-1 PC	.	.	.	.	.	.	.	\N	\N	RESULT
58	HSV TYPING	3	HSV-1 nc	.	.	.	.	.	.	.	\N	\N	RESULT
60	HSV TYPING	5	HSV-2 nc	.	.	.	.	.	.	.	\N	\N	RESULT
59	HSV TYPING	4	HSV-2 PC	.	.	.	.	.	.	.	\N	\N	RESULT
74	MICRO	6	Pigment	Mannitol	Casein	Gelatin	\N	\N	\N	\N	\N	\N	ANALYTE
73	MICRO	5	Hemolysis	Maltose	Trehalose	Litmus Milk	\N	\N	\N	\N	\N	\N	ANALYTE
72	MICRO	4	O2 Relation	Sucrose	Sorbose	Ornithine	\N	\N	\N	\N	\N	\N	ANALYTE
92	STREP	11	\N	\N	\N	\N	PFGE	\N	\N	\N	\N	\N	ANALYTE
35	US VDRL	8	Rotation of Slides	.	178 - 182	__________	rotation/min	\N	\N	\N	\N	\N	QC
34	US VDRL	7	Temp of Lab	.	23 - 29	__________	degrees C	\N	\N	\N	\N	\N	QC
36	US VDRL	9	CONTROLS	SOURCE	LOT	EXPIRE DATE	RESULT Qualitative Expect	RESULT Qualitative  Actual	RESULT Quantitative Expect	RESULT Quantitative Actual	\N	\N	QC
56	HSV TYPING	1	Specimen ID	Received Date	Source	Pass	HSV1	HSV2	Comments	Mailer	\N	\N	RESULT
27	VI	1	Comments	Results	Interpretation	\N	\N	\N	\N	\N	\N	\N	RESULT
32	US VDRL	5	VDRL working antigen	.	.	.	\N	\N	\N	\N	\N	\N	QC
31	US VDRL	4	10% Saline	.	.	.	\N	\N	\N	\N	\N	\N	QC
30	US VDRL	3	Kahn Saline 0.9%	.	.	.	\N	\N	\N	\N	\N	\N	QC
29	US VDRL	2	VDRL Antigen Kit	Difco	.	.	\N	\N	\N	\N	\N	\N	QC
28	US VDRL	1	REAGENT	SOURCE	LOT	EXPIRE DATE	\N	\N	\N	\N	\N	\N	QC
38	US VDRL	11	LPC	Difco	.	.	WR	.	.	.	\N	\N	QC
37	US VDRL	10	HPC	Difco	.	.	R	.	.	.	\N	\N	QC
39	US VDRL	12	NC	Difco	.	.	NR	.	.	.	\N	\N	QC
61	US USR	1	QL	QN: 2	4	8	16	32	64	128	256	Final	RESULT
68	STREP	6	Factors	PFGE	\N	Catalase	Lact	\N	\N	\N	\N	\N	ANALYTE
67	STREP	5	Group	Latex	Latex	Kilian	Suc	\N	\N	\N	\N	\N	ANALYTE
66	STREP	4	Typing pool	PYR	Hipp	Satellites	Malt	\N	\N	\N	\N	\N	ANALYTE
65	STREP	3	Bile sol	A disc	Camp	X+V	Dex	\N	\N	\N	\N	\N	ANALYTE
64	STREP	2	P disc	GmSt	GmSt	GmSt	GmSt	\N	\N	\N	\N	\N	ANALYTE
63	STREP	1	Strep pneumo	Group A Strep	Group B Strep	H Influenzae	N. meningitidis	\N	\N	\N	\N	\N	ANALYTE
70	MICRO	3	Spores	Lactose	Sorbitol	Arginine	\N	\N	\N	\N	\N	\N	ANALYTE
69	MICRO	2	42	Glucose	Salicin	Lysine	\N	\N	\N	\N	\N	\N	ANALYTE
71	MICRO	1	Colony morphology	.	Gram morphology	.	\N	\N	\N	\N	\N	\N	ANALYTE
79	MICRO	11	MacConkey	Fructose	Motility	Pyruvate	\N	\N	\N	\N	\N	\N	ANALYTE
78	MICRO	10	Serology	Inulin	.	6.5% salt	\N	\N	\N	\N	\N	\N	ANALYTE
77	MICRO	9	Satellites	Cellibiose	Alk Phos	Bile Esculin	\N	\N	\N	\N	\N	\N	ANALYTE
76	MICRO	8	Kilian test	Arabinose	PZA	Esculin	\N	\N	\N	\N	\N	\N	ANALYTE
75	MICRO	7	X+V Req	Xylose	Starch	Cetrimide	\N	\N	\N	\N	\N	\N	ANALYTE
87	MICRO	19	Lecthinase	Ribose	Phenylalanine	.	\N	\N	\N	\N	\N	\N	ANALYTE
86	MICRO	18	Lipase	Rhamnose	Acetate	FREEZE	\N	\N	\N	\N	\N	\N	ANALYTE
85	MICRO	17	.	Raffinose	Citrate	PFGE	\N	\N	\N	\N	\N	\N	ANALYTE
84	MICRO	16	Optochin	MMP	MR         VP	LAP         PYR	\N	\N	\N	\N	\N	\N	ANALYTE
83	MICRO	15	Camp	Melibiose	Indol	Erythromycin	\N	\N	\N	\N	\N	\N	ANALYTE
82	MICRO	14	Bacitracin	Mannose	Nitite	Vancomycin	\N	\N	\N	\N	\N	\N	ANALYTE
81	MICRO	13	Catalase	Glycerol	Nitrate	Coagulase	\N	\N	\N	\N	\N	\N	ANALYTE
80	MICRO	12	Oxidase	Galactose	Urease	MGP	\N	\N	\N	\N	\N	\N	ANALYTE
91	STREP	10	\N	\N	\N	\N	Serology	\N	\N	\N	\N	\N	ANALYTE
90	STREP	9	\N	\N	\N	\N	TM	\N	\N	\N	\N	\N	ANALYTE
89	STREP	8	\N	\N	\N	Serology	Oxidase	\N	\N	\N	\N	\N	ANALYTE
88	STREP	7	\N	\N	\N	Oxidase	Catalase	\N	\N	\N	\N	\N	ANALYTE
94	US USR	7	Kahn's solution	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
1	TB	1	Micro Result	Culture Result	Report Date	\N	\N	\N	\N	\N	\N	\N	RESULT
2	GC	1	12 HOUR	24 HOUR	48 HOUR	\N	\N	\N	\N	\N	\N	\N	RESULT
9	US FTA	7	\N	\N	\N	\N	PBS	.	.	.	-	.	QC
10	US FTA	8	\N	\N	\N	\N	Sorbent	.	.	.	-	.	QC
8	US FTA	6	PBS	.	.	.	Nonspecific Control / Sorbent	.	.	.	-	.	QC
11	US FTA	1	    USR     Repeat Quant	   FTA      Current Run	    FTA     Previous Runs	   FTA         Final	  TPPA       Result	Comments	\N	\N	\N	\N	RESULT
26	US FTA	1	TEST	TESTing	\N	\N	\N	\N	\N	\N	\N	\N	ANALYTE
7	US FTA	5	.	.	.	.	Nonspecific Control/ PBS	.	.	.	>2+	.	QC
6	US FTA	4	FITCconjugate Working Dilution:	.	.	.	Minimally Reactive Control	.	.	.	1+	.	QC
5	US FTA	3	Sorbent	.	.	.	Reactive Control / Sorbent	.	.	.	3-4+	.	QC
4	US FTA	2	T Palladium antigen	.	.	.	Reactive Control/PBS	.	.	.	4+	.	QC
3	US FTA	1	Reagent	Source	Lot	Expire Date	Reagent	Source	Lot	Expires	Expect	Actual	QC
25	F	23	KNO3	RT incubation	.	.	\N	\N	\N	\N	\N	\N	ANALYTE
24	F	22	dulcitol	chlamydospores	.	.	\N	\N	\N	\N	\N	\N	ANALYTE
23	F	21	melibiose	ascospores	NO3	.	\N	\N	\N	\N	\N	\N	ANALYTE
22	F	20	trehalose	pigment	gelatin	.	\N	\N	\N	\N	\N	\N	ANALYTE
21	F	19	xylose	germ tubes	urea	probe (histo)	\N	\N	\N	\N	\N	\N	ANALYTE
20	F	18	inositol	urea	T4	probe (blasto)	\N	\N	\N	\N	\N	\N	ANALYTE
19	F	17	raffinose	OTHER TESTS	T3	probe (cocci)	\N	\N	\N	\N	\N	\N	ANALYTE
18	F	16	cellobiose	galactose	T2	PROBE TESTS	\N	\N	\N	\N	\N	\N	ANALYTE
17	F	15	galactose	trehalose	T1	.	\N	\N	\N	\N	\N	\N	ANALYTE
16	F	14	lactose	lactose	37 degrees	lysozyme	\N	\N	\N	\N	\N	\N	ANALYTE
15	F	13	sucrose	sucrose	RT incubation	xanthine	\N	\N	\N	\N	\N	\N	ANALYTE
14	F	12	maltose	maltose	sabs without CH	tyrosine	\N	\N	\N	\N	\N	\N	ANALYTE
13	F	11	dextrose	dextrose	sabs with CH	casein	\N	\N	\N	\N	\N	\N	ANALYTE
12	F	10	ASSIMILATIONS	FERMENTATIONS	FILAMENTOUS	ACTINOMYCETES	\N	\N	\N	\N	\N	\N	ANALYTE
62	US VDRL	1	QL	QN:2	4	8	16	32	64	128	256	Final	RESULT
93	US USR	15	Titer	.	.	.	.	.	.	.	\N	\N	QC
96	US FTA	10	\N	\N	\N	\N	TPPA - control	.	.	.	-	.	QC
95	US FTA	9	\N	\N	\N	\N	TPPA + control	.	.	.	+	.	QC
49	US USR	11	CONTROLS	SOURCE	LOT	EXPIRE DATE	RESULTS Qualitative Expect	RESULTS Qualitative  Actual	RESULTS Quantitative Expect	RESULTS Quantitative Actual	\N	\N	QC
48	US USR	10	Rotation of Slides	178-182	__________	rotations/min	\N	\N	\N	\N	\N	\N	QC
47	US USR	9	Temp of Lab	23-29	__________	degrees C	\N	\N	\N	\N	\N	\N	QC
46	US USR	6	Sterile DI H20	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
45	US USR	8	USR working antigen	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
44	US USR	5	Phosphate Buffer	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
43	US USR	4	EDTA	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
42	US USR	3	Choline Chloride	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
41	US USR	2	VDRL Antigen Kit	Difco	.	.	\N	\N	\N	\N	\N	\N	QC
40	US USR	1	REAGENT	SOURCE	LOT	EXPIRE DATE	\N	\N	\N	\N	\N	\N	QC
52	US USR	14	NC	Difco	.	.	NR	.	.	.	\N	\N	QC
51	US USR	13	LPC	Difco	.	.	WR	.	.	.	\N	\N	QC
50	US USR	12	HPC	Difco	.	.	R	.	.	.	\N	\N	QC
55	HSV TYPING	3	Expiration Date:	________________	Negative Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
54	HSV TYPING	2	Lot:	________________	HSV2 Positive Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
53	HSV TYPING	1	HSV1 / HSV2 Typing Kit:	________________	HSV1 Positive Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
57	HSV TYPING	2	HSV-1 PC	.	.	.	.	.	.	.	\N	\N	RESULT
58	HSV TYPING	3	HSV-1 nc	.	.	.	.	.	.	.	\N	\N	RESULT
60	HSV TYPING	5	HSV-2 nc	.	.	.	.	.	.	.	\N	\N	RESULT
59	HSV TYPING	4	HSV-2 PC	.	.	.	.	.	.	.	\N	\N	RESULT
74	MICRO	6	Pigment	Mannitol	Casein	Gelatin	\N	\N	\N	\N	\N	\N	ANALYTE
73	MICRO	5	Hemolysis	Maltose	Trehalose	Litmus Milk	\N	\N	\N	\N	\N	\N	ANALYTE
72	MICRO	4	O2 Relation	Sucrose	Sorbose	Ornithine	\N	\N	\N	\N	\N	\N	ANALYTE
92	STREP	11	\N	\N	\N	\N	PFGE	\N	\N	\N	\N	\N	ANALYTE
35	US VDRL	8	Rotation of Slides	.	178 - 182	__________	rotation/min	\N	\N	\N	\N	\N	QC
34	US VDRL	7	Temp of Lab	.	23 - 29	__________	degrees C	\N	\N	\N	\N	\N	QC
36	US VDRL	9	CONTROLS	SOURCE	LOT	EXPIRE DATE	RESULT Qualitative Expect	RESULT Qualitative  Actual	RESULT Quantitative Expect	RESULT Quantitative Actual	\N	\N	QC
56	HSV TYPING	1	Specimen ID	Received Date	Source	Pass	HSV1	HSV2	Comments	Mailer	\N	\N	RESULT
27	VI	1	Comments	Results	Interpretation	\N	\N	\N	\N	\N	\N	\N	RESULT
32	US VDRL	5	VDRL working antigen	.	.	.	\N	\N	\N	\N	\N	\N	QC
31	US VDRL	4	10% Saline	.	.	.	\N	\N	\N	\N	\N	\N	QC
30	US VDRL	3	Kahn Saline 0.9%	.	.	.	\N	\N	\N	\N	\N	\N	QC
29	US VDRL	2	VDRL Antigen Kit	Difco	.	.	\N	\N	\N	\N	\N	\N	QC
28	US VDRL	1	REAGENT	SOURCE	LOT	EXPIRE DATE	\N	\N	\N	\N	\N	\N	QC
38	US VDRL	11	LPC	Difco	.	.	WR	.	.	.	\N	\N	QC
37	US VDRL	10	HPC	Difco	.	.	R	.	.	.	\N	\N	QC
39	US VDRL	12	NC	Difco	.	.	NR	.	.	.	\N	\N	QC
61	US USR	1	QL	QN: 2	4	8	16	32	64	128	256	Final	RESULT
68	STREP	6	Factors	PFGE	\N	Catalase	Lact	\N	\N	\N	\N	\N	ANALYTE
67	STREP	5	Group	Latex	Latex	Kilian	Suc	\N	\N	\N	\N	\N	ANALYTE
66	STREP	4	Typing pool	PYR	Hipp	Satellites	Malt	\N	\N	\N	\N	\N	ANALYTE
65	STREP	3	Bile sol	A disc	Camp	X+V	Dex	\N	\N	\N	\N	\N	ANALYTE
64	STREP	2	P disc	GmSt	GmSt	GmSt	GmSt	\N	\N	\N	\N	\N	ANALYTE
63	STREP	1	Strep pneumo	Group A Strep	Group B Strep	H Influenzae	N. meningitidis	\N	\N	\N	\N	\N	ANALYTE
70	MICRO	3	Spores	Lactose	Sorbitol	Arginine	\N	\N	\N	\N	\N	\N	ANALYTE
69	MICRO	2	42	Glucose	Salicin	Lysine	\N	\N	\N	\N	\N	\N	ANALYTE
71	MICRO	1	Colony morphology	.	Gram morphology	.	\N	\N	\N	\N	\N	\N	ANALYTE
79	MICRO	11	MacConkey	Fructose	Motility	Pyruvate	\N	\N	\N	\N	\N	\N	ANALYTE
78	MICRO	10	Serology	Inulin	.	6.5% salt	\N	\N	\N	\N	\N	\N	ANALYTE
77	MICRO	9	Satellites	Cellibiose	Alk Phos	Bile Esculin	\N	\N	\N	\N	\N	\N	ANALYTE
76	MICRO	8	Kilian test	Arabinose	PZA	Esculin	\N	\N	\N	\N	\N	\N	ANALYTE
75	MICRO	7	X+V Req	Xylose	Starch	Cetrimide	\N	\N	\N	\N	\N	\N	ANALYTE
87	MICRO	19	Lecthinase	Ribose	Phenylalanine	.	\N	\N	\N	\N	\N	\N	ANALYTE
86	MICRO	18	Lipase	Rhamnose	Acetate	FREEZE	\N	\N	\N	\N	\N	\N	ANALYTE
85	MICRO	17	.	Raffinose	Citrate	PFGE	\N	\N	\N	\N	\N	\N	ANALYTE
84	MICRO	16	Optochin	MMP	MR         VP	LAP         PYR	\N	\N	\N	\N	\N	\N	ANALYTE
83	MICRO	15	Camp	Melibiose	Indol	Erythromycin	\N	\N	\N	\N	\N	\N	ANALYTE
82	MICRO	14	Bacitracin	Mannose	Nitite	Vancomycin	\N	\N	\N	\N	\N	\N	ANALYTE
81	MICRO	13	Catalase	Glycerol	Nitrate	Coagulase	\N	\N	\N	\N	\N	\N	ANALYTE
80	MICRO	12	Oxidase	Galactose	Urease	MGP	\N	\N	\N	\N	\N	\N	ANALYTE
91	STREP	10	\N	\N	\N	\N	Serology	\N	\N	\N	\N	\N	ANALYTE
90	STREP	9	\N	\N	\N	\N	TM	\N	\N	\N	\N	\N	ANALYTE
89	STREP	8	\N	\N	\N	Serology	Oxidase	\N	\N	\N	\N	\N	ANALYTE
88	STREP	7	\N	\N	\N	Oxidase	Catalase	\N	\N	\N	\N	\N	ANALYTE
94	US USR	7	Kahn's solution	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
1	TB	1	Micro Result	Culture Result	Report Date	\N	\N	\N	\N	\N	\N	\N	RESULT
2	GC	1	12 HOUR	24 HOUR	48 HOUR	\N	\N	\N	\N	\N	\N	\N	RESULT
9	US FTA	7	\N	\N	\N	\N	PBS	.	.	.	-	.	QC
10	US FTA	8	\N	\N	\N	\N	Sorbent	.	.	.	-	.	QC
8	US FTA	6	PBS	.	.	.	Nonspecific Control / Sorbent	.	.	.	-	.	QC
11	US FTA	1	    USR     Repeat Quant	   FTA      Current Run	    FTA     Previous Runs	   FTA         Final	  TPPA       Result	Comments	\N	\N	\N	\N	RESULT
26	US FTA	1	TEST	TESTing	\N	\N	\N	\N	\N	\N	\N	\N	ANALYTE
7	US FTA	5	.	.	.	.	Nonspecific Control/ PBS	.	.	.	>2+	.	QC
6	US FTA	4	FITCconjugate Working Dilution:	.	.	.	Minimally Reactive Control	.	.	.	1+	.	QC
5	US FTA	3	Sorbent	.	.	.	Reactive Control / Sorbent	.	.	.	3-4+	.	QC
4	US FTA	2	T Palladium antigen	.	.	.	Reactive Control/PBS	.	.	.	4+	.	QC
3	US FTA	1	Reagent	Source	Lot	Expire Date	Reagent	Source	Lot	Expires	Expect	Actual	QC
25	F	23	KNO3	RT incubation	.	.	\N	\N	\N	\N	\N	\N	ANALYTE
24	F	22	dulcitol	chlamydospores	.	.	\N	\N	\N	\N	\N	\N	ANALYTE
23	F	21	melibiose	ascospores	NO3	.	\N	\N	\N	\N	\N	\N	ANALYTE
22	F	20	trehalose	pigment	gelatin	.	\N	\N	\N	\N	\N	\N	ANALYTE
21	F	19	xylose	germ tubes	urea	probe (histo)	\N	\N	\N	\N	\N	\N	ANALYTE
20	F	18	inositol	urea	T4	probe (blasto)	\N	\N	\N	\N	\N	\N	ANALYTE
19	F	17	raffinose	OTHER TESTS	T3	probe (cocci)	\N	\N	\N	\N	\N	\N	ANALYTE
18	F	16	cellobiose	galactose	T2	PROBE TESTS	\N	\N	\N	\N	\N	\N	ANALYTE
17	F	15	galactose	trehalose	T1	.	\N	\N	\N	\N	\N	\N	ANALYTE
16	F	14	lactose	lactose	37 degrees	lysozyme	\N	\N	\N	\N	\N	\N	ANALYTE
15	F	13	sucrose	sucrose	RT incubation	xanthine	\N	\N	\N	\N	\N	\N	ANALYTE
14	F	12	maltose	maltose	sabs without CH	tyrosine	\N	\N	\N	\N	\N	\N	ANALYTE
13	F	11	dextrose	dextrose	sabs with CH	casein	\N	\N	\N	\N	\N	\N	ANALYTE
12	F	10	ASSIMILATIONS	FERMENTATIONS	FILAMENTOUS	ACTINOMYCETES	\N	\N	\N	\N	\N	\N	ANALYTE
62	US VDRL	1	QL	QN:2	4	8	16	32	64	128	256	Final	RESULT
93	US USR	15	Titer	.	.	.	.	.	.	.	\N	\N	QC
96	US FTA	10	\N	\N	\N	\N	TPPA - control	.	.	.	-	.	QC
95	US FTA	9	\N	\N	\N	\N	TPPA + control	.	.	.	+	.	QC
49	US USR	11	CONTROLS	SOURCE	LOT	EXPIRE DATE	RESULTS Qualitative Expect	RESULTS Qualitative  Actual	RESULTS Quantitative Expect	RESULTS Quantitative Actual	\N	\N	QC
48	US USR	10	Rotation of Slides	178-182	__________	rotations/min	\N	\N	\N	\N	\N	\N	QC
47	US USR	9	Temp of Lab	23-29	__________	degrees C	\N	\N	\N	\N	\N	\N	QC
46	US USR	6	Sterile DI H20	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
45	US USR	8	USR working antigen	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
44	US USR	5	Phosphate Buffer	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
43	US USR	4	EDTA	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
42	US USR	3	Choline Chloride	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
41	US USR	2	VDRL Antigen Kit	Difco	.	.	\N	\N	\N	\N	\N	\N	QC
40	US USR	1	REAGENT	SOURCE	LOT	EXPIRE DATE	\N	\N	\N	\N	\N	\N	QC
52	US USR	14	NC	Difco	.	.	NR	.	.	.	\N	\N	QC
51	US USR	13	LPC	Difco	.	.	WR	.	.	.	\N	\N	QC
50	US USR	12	HPC	Difco	.	.	R	.	.	.	\N	\N	QC
55	HSV TYPING	3	Expiration Date:	________________	Negative Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
54	HSV TYPING	2	Lot:	________________	HSV2 Positive Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
53	HSV TYPING	1	HSV1 / HSV2 Typing Kit:	________________	HSV1 Positive Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
57	HSV TYPING	2	HSV-1 PC	.	.	.	.	.	.	.	\N	\N	RESULT
58	HSV TYPING	3	HSV-1 nc	.	.	.	.	.	.	.	\N	\N	RESULT
60	HSV TYPING	5	HSV-2 nc	.	.	.	.	.	.	.	\N	\N	RESULT
59	HSV TYPING	4	HSV-2 PC	.	.	.	.	.	.	.	\N	\N	RESULT
74	MICRO	6	Pigment	Mannitol	Casein	Gelatin	\N	\N	\N	\N	\N	\N	ANALYTE
73	MICRO	5	Hemolysis	Maltose	Trehalose	Litmus Milk	\N	\N	\N	\N	\N	\N	ANALYTE
72	MICRO	4	O2 Relation	Sucrose	Sorbose	Ornithine	\N	\N	\N	\N	\N	\N	ANALYTE
92	STREP	11	\N	\N	\N	\N	PFGE	\N	\N	\N	\N	\N	ANALYTE
35	US VDRL	8	Rotation of Slides	.	178 - 182	__________	rotation/min	\N	\N	\N	\N	\N	QC
34	US VDRL	7	Temp of Lab	.	23 - 29	__________	degrees C	\N	\N	\N	\N	\N	QC
36	US VDRL	9	CONTROLS	SOURCE	LOT	EXPIRE DATE	RESULT Qualitative Expect	RESULT Qualitative  Actual	RESULT Quantitative Expect	RESULT Quantitative Actual	\N	\N	QC
56	HSV TYPING	1	Specimen ID	Received Date	Source	Pass	HSV1	HSV2	Comments	Mailer	\N	\N	RESULT
27	VI	1	Comments	Results	Interpretation	\N	\N	\N	\N	\N	\N	\N	RESULT
32	US VDRL	5	VDRL working antigen	.	.	.	\N	\N	\N	\N	\N	\N	QC
31	US VDRL	4	10% Saline	.	.	.	\N	\N	\N	\N	\N	\N	QC
30	US VDRL	3	Kahn Saline 0.9%	.	.	.	\N	\N	\N	\N	\N	\N	QC
29	US VDRL	2	VDRL Antigen Kit	Difco	.	.	\N	\N	\N	\N	\N	\N	QC
28	US VDRL	1	REAGENT	SOURCE	LOT	EXPIRE DATE	\N	\N	\N	\N	\N	\N	QC
38	US VDRL	11	LPC	Difco	.	.	WR	.	.	.	\N	\N	QC
37	US VDRL	10	HPC	Difco	.	.	R	.	.	.	\N	\N	QC
39	US VDRL	12	NC	Difco	.	.	NR	.	.	.	\N	\N	QC
61	US USR	1	QL	QN: 2	4	8	16	32	64	128	256	Final	RESULT
68	STREP	6	Factors	PFGE	\N	Catalase	Lact	\N	\N	\N	\N	\N	ANALYTE
67	STREP	5	Group	Latex	Latex	Kilian	Suc	\N	\N	\N	\N	\N	ANALYTE
66	STREP	4	Typing pool	PYR	Hipp	Satellites	Malt	\N	\N	\N	\N	\N	ANALYTE
65	STREP	3	Bile sol	A disc	Camp	X+V	Dex	\N	\N	\N	\N	\N	ANALYTE
64	STREP	2	P disc	GmSt	GmSt	GmSt	GmSt	\N	\N	\N	\N	\N	ANALYTE
63	STREP	1	Strep pneumo	Group A Strep	Group B Strep	H Influenzae	N. meningitidis	\N	\N	\N	\N	\N	ANALYTE
70	MICRO	3	Spores	Lactose	Sorbitol	Arginine	\N	\N	\N	\N	\N	\N	ANALYTE
69	MICRO	2	42	Glucose	Salicin	Lysine	\N	\N	\N	\N	\N	\N	ANALYTE
71	MICRO	1	Colony morphology	.	Gram morphology	.	\N	\N	\N	\N	\N	\N	ANALYTE
79	MICRO	11	MacConkey	Fructose	Motility	Pyruvate	\N	\N	\N	\N	\N	\N	ANALYTE
78	MICRO	10	Serology	Inulin	.	6.5% salt	\N	\N	\N	\N	\N	\N	ANALYTE
77	MICRO	9	Satellites	Cellibiose	Alk Phos	Bile Esculin	\N	\N	\N	\N	\N	\N	ANALYTE
76	MICRO	8	Kilian test	Arabinose	PZA	Esculin	\N	\N	\N	\N	\N	\N	ANALYTE
75	MICRO	7	X+V Req	Xylose	Starch	Cetrimide	\N	\N	\N	\N	\N	\N	ANALYTE
87	MICRO	19	Lecthinase	Ribose	Phenylalanine	.	\N	\N	\N	\N	\N	\N	ANALYTE
86	MICRO	18	Lipase	Rhamnose	Acetate	FREEZE	\N	\N	\N	\N	\N	\N	ANALYTE
85	MICRO	17	.	Raffinose	Citrate	PFGE	\N	\N	\N	\N	\N	\N	ANALYTE
84	MICRO	16	Optochin	MMP	MR         VP	LAP         PYR	\N	\N	\N	\N	\N	\N	ANALYTE
83	MICRO	15	Camp	Melibiose	Indol	Erythromycin	\N	\N	\N	\N	\N	\N	ANALYTE
82	MICRO	14	Bacitracin	Mannose	Nitite	Vancomycin	\N	\N	\N	\N	\N	\N	ANALYTE
81	MICRO	13	Catalase	Glycerol	Nitrate	Coagulase	\N	\N	\N	\N	\N	\N	ANALYTE
80	MICRO	12	Oxidase	Galactose	Urease	MGP	\N	\N	\N	\N	\N	\N	ANALYTE
91	STREP	10	\N	\N	\N	\N	Serology	\N	\N	\N	\N	\N	ANALYTE
90	STREP	9	\N	\N	\N	\N	TM	\N	\N	\N	\N	\N	ANALYTE
89	STREP	8	\N	\N	\N	Serology	Oxidase	\N	\N	\N	\N	\N	ANALYTE
88	STREP	7	\N	\N	\N	Oxidase	Catalase	\N	\N	\N	\N	\N	ANALYTE
94	US USR	7	Kahn's solution	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
1	TB	1	Micro Result	Culture Result	Report Date	\N	\N	\N	\N	\N	\N	\N	RESULT
2	GC	1	12 HOUR	24 HOUR	48 HOUR	\N	\N	\N	\N	\N	\N	\N	RESULT
9	US FTA	7	\N	\N	\N	\N	PBS	.	.	.	-	.	QC
10	US FTA	8	\N	\N	\N	\N	Sorbent	.	.	.	-	.	QC
8	US FTA	6	PBS	.	.	.	Nonspecific Control / Sorbent	.	.	.	-	.	QC
11	US FTA	1	    USR     Repeat Quant	   FTA      Current Run	    FTA     Previous Runs	   FTA         Final	  TPPA       Result	Comments	\N	\N	\N	\N	RESULT
26	US FTA	1	TEST	TESTing	\N	\N	\N	\N	\N	\N	\N	\N	ANALYTE
7	US FTA	5	.	.	.	.	Nonspecific Control/ PBS	.	.	.	>2+	.	QC
6	US FTA	4	FITCconjugate Working Dilution:	.	.	.	Minimally Reactive Control	.	.	.	1+	.	QC
5	US FTA	3	Sorbent	.	.	.	Reactive Control / Sorbent	.	.	.	3-4+	.	QC
4	US FTA	2	T Palladium antigen	.	.	.	Reactive Control/PBS	.	.	.	4+	.	QC
3	US FTA	1	Reagent	Source	Lot	Expire Date	Reagent	Source	Lot	Expires	Expect	Actual	QC
25	F	23	KNO3	RT incubation	.	.	\N	\N	\N	\N	\N	\N	ANALYTE
24	F	22	dulcitol	chlamydospores	.	.	\N	\N	\N	\N	\N	\N	ANALYTE
23	F	21	melibiose	ascospores	NO3	.	\N	\N	\N	\N	\N	\N	ANALYTE
22	F	20	trehalose	pigment	gelatin	.	\N	\N	\N	\N	\N	\N	ANALYTE
21	F	19	xylose	germ tubes	urea	probe (histo)	\N	\N	\N	\N	\N	\N	ANALYTE
20	F	18	inositol	urea	T4	probe (blasto)	\N	\N	\N	\N	\N	\N	ANALYTE
19	F	17	raffinose	OTHER TESTS	T3	probe (cocci)	\N	\N	\N	\N	\N	\N	ANALYTE
18	F	16	cellobiose	galactose	T2	PROBE TESTS	\N	\N	\N	\N	\N	\N	ANALYTE
17	F	15	galactose	trehalose	T1	.	\N	\N	\N	\N	\N	\N	ANALYTE
16	F	14	lactose	lactose	37 degrees	lysozyme	\N	\N	\N	\N	\N	\N	ANALYTE
15	F	13	sucrose	sucrose	RT incubation	xanthine	\N	\N	\N	\N	\N	\N	ANALYTE
14	F	12	maltose	maltose	sabs without CH	tyrosine	\N	\N	\N	\N	\N	\N	ANALYTE
13	F	11	dextrose	dextrose	sabs with CH	casein	\N	\N	\N	\N	\N	\N	ANALYTE
12	F	10	ASSIMILATIONS	FERMENTATIONS	FILAMENTOUS	ACTINOMYCETES	\N	\N	\N	\N	\N	\N	ANALYTE
62	US VDRL	1	QL	QN:2	4	8	16	32	64	128	256	Final	RESULT
93	US USR	15	Titer	.	.	.	.	.	.	.	\N	\N	QC
96	US FTA	10	\N	\N	\N	\N	TPPA - control	.	.	.	-	.	QC
95	US FTA	9	\N	\N	\N	\N	TPPA + control	.	.	.	+	.	QC
49	US USR	11	CONTROLS	SOURCE	LOT	EXPIRE DATE	RESULTS Qualitative Expect	RESULTS Qualitative  Actual	RESULTS Quantitative Expect	RESULTS Quantitative Actual	\N	\N	QC
48	US USR	10	Rotation of Slides	178-182	__________	rotations/min	\N	\N	\N	\N	\N	\N	QC
47	US USR	9	Temp of Lab	23-29	__________	degrees C	\N	\N	\N	\N	\N	\N	QC
46	US USR	6	Sterile DI H20	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
45	US USR	8	USR working antigen	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
44	US USR	5	Phosphate Buffer	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
43	US USR	4	EDTA	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
42	US USR	3	Choline Chloride	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
41	US USR	2	VDRL Antigen Kit	Difco	.	.	\N	\N	\N	\N	\N	\N	QC
40	US USR	1	REAGENT	SOURCE	LOT	EXPIRE DATE	\N	\N	\N	\N	\N	\N	QC
52	US USR	14	NC	Difco	.	.	NR	.	.	.	\N	\N	QC
51	US USR	13	LPC	Difco	.	.	WR	.	.	.	\N	\N	QC
50	US USR	12	HPC	Difco	.	.	R	.	.	.	\N	\N	QC
55	HSV TYPING	3	Expiration Date:	________________	Negative Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
54	HSV TYPING	2	Lot:	________________	HSV2 Positive Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
53	HSV TYPING	1	HSV1 / HSV2 Typing Kit:	________________	HSV1 Positive Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
57	HSV TYPING	2	HSV-1 PC	.	.	.	.	.	.	.	\N	\N	RESULT
58	HSV TYPING	3	HSV-1 nc	.	.	.	.	.	.	.	\N	\N	RESULT
60	HSV TYPING	5	HSV-2 nc	.	.	.	.	.	.	.	\N	\N	RESULT
59	HSV TYPING	4	HSV-2 PC	.	.	.	.	.	.	.	\N	\N	RESULT
74	MICRO	6	Pigment	Mannitol	Casein	Gelatin	\N	\N	\N	\N	\N	\N	ANALYTE
73	MICRO	5	Hemolysis	Maltose	Trehalose	Litmus Milk	\N	\N	\N	\N	\N	\N	ANALYTE
72	MICRO	4	O2 Relation	Sucrose	Sorbose	Ornithine	\N	\N	\N	\N	\N	\N	ANALYTE
92	STREP	11	\N	\N	\N	\N	PFGE	\N	\N	\N	\N	\N	ANALYTE
35	US VDRL	8	Rotation of Slides	.	178 - 182	__________	rotation/min	\N	\N	\N	\N	\N	QC
34	US VDRL	7	Temp of Lab	.	23 - 29	__________	degrees C	\N	\N	\N	\N	\N	QC
36	US VDRL	9	CONTROLS	SOURCE	LOT	EXPIRE DATE	RESULT Qualitative Expect	RESULT Qualitative  Actual	RESULT Quantitative Expect	RESULT Quantitative Actual	\N	\N	QC
56	HSV TYPING	1	Specimen ID	Received Date	Source	Pass	HSV1	HSV2	Comments	Mailer	\N	\N	RESULT
27	VI	1	Comments	Results	Interpretation	\N	\N	\N	\N	\N	\N	\N	RESULT
32	US VDRL	5	VDRL working antigen	.	.	.	\N	\N	\N	\N	\N	\N	QC
31	US VDRL	4	10% Saline	.	.	.	\N	\N	\N	\N	\N	\N	QC
30	US VDRL	3	Kahn Saline 0.9%	.	.	.	\N	\N	\N	\N	\N	\N	QC
29	US VDRL	2	VDRL Antigen Kit	Difco	.	.	\N	\N	\N	\N	\N	\N	QC
28	US VDRL	1	REAGENT	SOURCE	LOT	EXPIRE DATE	\N	\N	\N	\N	\N	\N	QC
38	US VDRL	11	LPC	Difco	.	.	WR	.	.	.	\N	\N	QC
37	US VDRL	10	HPC	Difco	.	.	R	.	.	.	\N	\N	QC
39	US VDRL	12	NC	Difco	.	.	NR	.	.	.	\N	\N	QC
61	US USR	1	QL	QN: 2	4	8	16	32	64	128	256	Final	RESULT
68	STREP	6	Factors	PFGE	\N	Catalase	Lact	\N	\N	\N	\N	\N	ANALYTE
67	STREP	5	Group	Latex	Latex	Kilian	Suc	\N	\N	\N	\N	\N	ANALYTE
66	STREP	4	Typing pool	PYR	Hipp	Satellites	Malt	\N	\N	\N	\N	\N	ANALYTE
65	STREP	3	Bile sol	A disc	Camp	X+V	Dex	\N	\N	\N	\N	\N	ANALYTE
64	STREP	2	P disc	GmSt	GmSt	GmSt	GmSt	\N	\N	\N	\N	\N	ANALYTE
63	STREP	1	Strep pneumo	Group A Strep	Group B Strep	H Influenzae	N. meningitidis	\N	\N	\N	\N	\N	ANALYTE
70	MICRO	3	Spores	Lactose	Sorbitol	Arginine	\N	\N	\N	\N	\N	\N	ANALYTE
69	MICRO	2	42	Glucose	Salicin	Lysine	\N	\N	\N	\N	\N	\N	ANALYTE
71	MICRO	1	Colony morphology	.	Gram morphology	.	\N	\N	\N	\N	\N	\N	ANALYTE
79	MICRO	11	MacConkey	Fructose	Motility	Pyruvate	\N	\N	\N	\N	\N	\N	ANALYTE
78	MICRO	10	Serology	Inulin	.	6.5% salt	\N	\N	\N	\N	\N	\N	ANALYTE
77	MICRO	9	Satellites	Cellibiose	Alk Phos	Bile Esculin	\N	\N	\N	\N	\N	\N	ANALYTE
76	MICRO	8	Kilian test	Arabinose	PZA	Esculin	\N	\N	\N	\N	\N	\N	ANALYTE
75	MICRO	7	X+V Req	Xylose	Starch	Cetrimide	\N	\N	\N	\N	\N	\N	ANALYTE
87	MICRO	19	Lecthinase	Ribose	Phenylalanine	.	\N	\N	\N	\N	\N	\N	ANALYTE
86	MICRO	18	Lipase	Rhamnose	Acetate	FREEZE	\N	\N	\N	\N	\N	\N	ANALYTE
85	MICRO	17	.	Raffinose	Citrate	PFGE	\N	\N	\N	\N	\N	\N	ANALYTE
84	MICRO	16	Optochin	MMP	MR         VP	LAP         PYR	\N	\N	\N	\N	\N	\N	ANALYTE
83	MICRO	15	Camp	Melibiose	Indol	Erythromycin	\N	\N	\N	\N	\N	\N	ANALYTE
82	MICRO	14	Bacitracin	Mannose	Nitite	Vancomycin	\N	\N	\N	\N	\N	\N	ANALYTE
81	MICRO	13	Catalase	Glycerol	Nitrate	Coagulase	\N	\N	\N	\N	\N	\N	ANALYTE
80	MICRO	12	Oxidase	Galactose	Urease	MGP	\N	\N	\N	\N	\N	\N	ANALYTE
91	STREP	10	\N	\N	\N	\N	Serology	\N	\N	\N	\N	\N	ANALYTE
90	STREP	9	\N	\N	\N	\N	TM	\N	\N	\N	\N	\N	ANALYTE
89	STREP	8	\N	\N	\N	Serology	Oxidase	\N	\N	\N	\N	\N	ANALYTE
88	STREP	7	\N	\N	\N	Oxidase	Catalase	\N	\N	\N	\N	\N	ANALYTE
94	US USR	7	Kahn's solution	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
1	TB	1	Micro Result	Culture Result	Report Date	\N	\N	\N	\N	\N	\N	\N	RESULT
2	GC	1	12 HOUR	24 HOUR	48 HOUR	\N	\N	\N	\N	\N	\N	\N	RESULT
9	US FTA	7	\N	\N	\N	\N	PBS	.	.	.	-	.	QC
10	US FTA	8	\N	\N	\N	\N	Sorbent	.	.	.	-	.	QC
8	US FTA	6	PBS	.	.	.	Nonspecific Control / Sorbent	.	.	.	-	.	QC
11	US FTA	1	    USR     Repeat Quant	   FTA      Current Run	    FTA     Previous Runs	   FTA         Final	  TPPA       Result	Comments	\N	\N	\N	\N	RESULT
26	US FTA	1	TEST	TESTing	\N	\N	\N	\N	\N	\N	\N	\N	ANALYTE
7	US FTA	5	.	.	.	.	Nonspecific Control/ PBS	.	.	.	>2+	.	QC
6	US FTA	4	FITCconjugate Working Dilution:	.	.	.	Minimally Reactive Control	.	.	.	1+	.	QC
5	US FTA	3	Sorbent	.	.	.	Reactive Control / Sorbent	.	.	.	3-4+	.	QC
4	US FTA	2	T Palladium antigen	.	.	.	Reactive Control/PBS	.	.	.	4+	.	QC
3	US FTA	1	Reagent	Source	Lot	Expire Date	Reagent	Source	Lot	Expires	Expect	Actual	QC
25	F	23	KNO3	RT incubation	.	.	\N	\N	\N	\N	\N	\N	ANALYTE
24	F	22	dulcitol	chlamydospores	.	.	\N	\N	\N	\N	\N	\N	ANALYTE
23	F	21	melibiose	ascospores	NO3	.	\N	\N	\N	\N	\N	\N	ANALYTE
22	F	20	trehalose	pigment	gelatin	.	\N	\N	\N	\N	\N	\N	ANALYTE
21	F	19	xylose	germ tubes	urea	probe (histo)	\N	\N	\N	\N	\N	\N	ANALYTE
20	F	18	inositol	urea	T4	probe (blasto)	\N	\N	\N	\N	\N	\N	ANALYTE
19	F	17	raffinose	OTHER TESTS	T3	probe (cocci)	\N	\N	\N	\N	\N	\N	ANALYTE
18	F	16	cellobiose	galactose	T2	PROBE TESTS	\N	\N	\N	\N	\N	\N	ANALYTE
17	F	15	galactose	trehalose	T1	.	\N	\N	\N	\N	\N	\N	ANALYTE
16	F	14	lactose	lactose	37 degrees	lysozyme	\N	\N	\N	\N	\N	\N	ANALYTE
15	F	13	sucrose	sucrose	RT incubation	xanthine	\N	\N	\N	\N	\N	\N	ANALYTE
14	F	12	maltose	maltose	sabs without CH	tyrosine	\N	\N	\N	\N	\N	\N	ANALYTE
13	F	11	dextrose	dextrose	sabs with CH	casein	\N	\N	\N	\N	\N	\N	ANALYTE
12	F	10	ASSIMILATIONS	FERMENTATIONS	FILAMENTOUS	ACTINOMYCETES	\N	\N	\N	\N	\N	\N	ANALYTE
62	US VDRL	1	QL	QN:2	4	8	16	32	64	128	256	Final	RESULT
93	US USR	15	Titer	.	.	.	.	.	.	.	\N	\N	QC
96	US FTA	10	\N	\N	\N	\N	TPPA - control	.	.	.	-	.	QC
95	US FTA	9	\N	\N	\N	\N	TPPA + control	.	.	.	+	.	QC
49	US USR	11	CONTROLS	SOURCE	LOT	EXPIRE DATE	RESULTS Qualitative Expect	RESULTS Qualitative  Actual	RESULTS Quantitative Expect	RESULTS Quantitative Actual	\N	\N	QC
48	US USR	10	Rotation of Slides	178-182	__________	rotations/min	\N	\N	\N	\N	\N	\N	QC
47	US USR	9	Temp of Lab	23-29	__________	degrees C	\N	\N	\N	\N	\N	\N	QC
46	US USR	6	Sterile DI H20	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
45	US USR	8	USR working antigen	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
44	US USR	5	Phosphate Buffer	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
43	US USR	4	EDTA	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
42	US USR	3	Choline Chloride	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
41	US USR	2	VDRL Antigen Kit	Difco	.	.	\N	\N	\N	\N	\N	\N	QC
40	US USR	1	REAGENT	SOURCE	LOT	EXPIRE DATE	\N	\N	\N	\N	\N	\N	QC
52	US USR	14	NC	Difco	.	.	NR	.	.	.	\N	\N	QC
51	US USR	13	LPC	Difco	.	.	WR	.	.	.	\N	\N	QC
50	US USR	12	HPC	Difco	.	.	R	.	.	.	\N	\N	QC
55	HSV TYPING	3	Expiration Date:	________________	Negative Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
54	HSV TYPING	2	Lot:	________________	HSV2 Positive Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
53	HSV TYPING	1	HSV1 / HSV2 Typing Kit:	________________	HSV1 Positive Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
57	HSV TYPING	2	HSV-1 PC	.	.	.	.	.	.	.	\N	\N	RESULT
58	HSV TYPING	3	HSV-1 nc	.	.	.	.	.	.	.	\N	\N	RESULT
60	HSV TYPING	5	HSV-2 nc	.	.	.	.	.	.	.	\N	\N	RESULT
59	HSV TYPING	4	HSV-2 PC	.	.	.	.	.	.	.	\N	\N	RESULT
74	MICRO	6	Pigment	Mannitol	Casein	Gelatin	\N	\N	\N	\N	\N	\N	ANALYTE
73	MICRO	5	Hemolysis	Maltose	Trehalose	Litmus Milk	\N	\N	\N	\N	\N	\N	ANALYTE
72	MICRO	4	O2 Relation	Sucrose	Sorbose	Ornithine	\N	\N	\N	\N	\N	\N	ANALYTE
92	STREP	11	\N	\N	\N	\N	PFGE	\N	\N	\N	\N	\N	ANALYTE
35	US VDRL	8	Rotation of Slides	.	178 - 182	__________	rotation/min	\N	\N	\N	\N	\N	QC
34	US VDRL	7	Temp of Lab	.	23 - 29	__________	degrees C	\N	\N	\N	\N	\N	QC
36	US VDRL	9	CONTROLS	SOURCE	LOT	EXPIRE DATE	RESULT Qualitative Expect	RESULT Qualitative  Actual	RESULT Quantitative Expect	RESULT Quantitative Actual	\N	\N	QC
56	HSV TYPING	1	Specimen ID	Received Date	Source	Pass	HSV1	HSV2	Comments	Mailer	\N	\N	RESULT
27	VI	1	Comments	Results	Interpretation	\N	\N	\N	\N	\N	\N	\N	RESULT
32	US VDRL	5	VDRL working antigen	.	.	.	\N	\N	\N	\N	\N	\N	QC
31	US VDRL	4	10% Saline	.	.	.	\N	\N	\N	\N	\N	\N	QC
30	US VDRL	3	Kahn Saline 0.9%	.	.	.	\N	\N	\N	\N	\N	\N	QC
29	US VDRL	2	VDRL Antigen Kit	Difco	.	.	\N	\N	\N	\N	\N	\N	QC
28	US VDRL	1	REAGENT	SOURCE	LOT	EXPIRE DATE	\N	\N	\N	\N	\N	\N	QC
38	US VDRL	11	LPC	Difco	.	.	WR	.	.	.	\N	\N	QC
37	US VDRL	10	HPC	Difco	.	.	R	.	.	.	\N	\N	QC
39	US VDRL	12	NC	Difco	.	.	NR	.	.	.	\N	\N	QC
61	US USR	1	QL	QN: 2	4	8	16	32	64	128	256	Final	RESULT
68	STREP	6	Factors	PFGE	\N	Catalase	Lact	\N	\N	\N	\N	\N	ANALYTE
67	STREP	5	Group	Latex	Latex	Kilian	Suc	\N	\N	\N	\N	\N	ANALYTE
66	STREP	4	Typing pool	PYR	Hipp	Satellites	Malt	\N	\N	\N	\N	\N	ANALYTE
65	STREP	3	Bile sol	A disc	Camp	X+V	Dex	\N	\N	\N	\N	\N	ANALYTE
64	STREP	2	P disc	GmSt	GmSt	GmSt	GmSt	\N	\N	\N	\N	\N	ANALYTE
63	STREP	1	Strep pneumo	Group A Strep	Group B Strep	H Influenzae	N. meningitidis	\N	\N	\N	\N	\N	ANALYTE
70	MICRO	3	Spores	Lactose	Sorbitol	Arginine	\N	\N	\N	\N	\N	\N	ANALYTE
69	MICRO	2	42	Glucose	Salicin	Lysine	\N	\N	\N	\N	\N	\N	ANALYTE
71	MICRO	1	Colony morphology	.	Gram morphology	.	\N	\N	\N	\N	\N	\N	ANALYTE
79	MICRO	11	MacConkey	Fructose	Motility	Pyruvate	\N	\N	\N	\N	\N	\N	ANALYTE
78	MICRO	10	Serology	Inulin	.	6.5% salt	\N	\N	\N	\N	\N	\N	ANALYTE
77	MICRO	9	Satellites	Cellibiose	Alk Phos	Bile Esculin	\N	\N	\N	\N	\N	\N	ANALYTE
76	MICRO	8	Kilian test	Arabinose	PZA	Esculin	\N	\N	\N	\N	\N	\N	ANALYTE
75	MICRO	7	X+V Req	Xylose	Starch	Cetrimide	\N	\N	\N	\N	\N	\N	ANALYTE
87	MICRO	19	Lecthinase	Ribose	Phenylalanine	.	\N	\N	\N	\N	\N	\N	ANALYTE
86	MICRO	18	Lipase	Rhamnose	Acetate	FREEZE	\N	\N	\N	\N	\N	\N	ANALYTE
85	MICRO	17	.	Raffinose	Citrate	PFGE	\N	\N	\N	\N	\N	\N	ANALYTE
84	MICRO	16	Optochin	MMP	MR         VP	LAP         PYR	\N	\N	\N	\N	\N	\N	ANALYTE
83	MICRO	15	Camp	Melibiose	Indol	Erythromycin	\N	\N	\N	\N	\N	\N	ANALYTE
82	MICRO	14	Bacitracin	Mannose	Nitite	Vancomycin	\N	\N	\N	\N	\N	\N	ANALYTE
81	MICRO	13	Catalase	Glycerol	Nitrate	Coagulase	\N	\N	\N	\N	\N	\N	ANALYTE
80	MICRO	12	Oxidase	Galactose	Urease	MGP	\N	\N	\N	\N	\N	\N	ANALYTE
91	STREP	10	\N	\N	\N	\N	Serology	\N	\N	\N	\N	\N	ANALYTE
90	STREP	9	\N	\N	\N	\N	TM	\N	\N	\N	\N	\N	ANALYTE
89	STREP	8	\N	\N	\N	Serology	Oxidase	\N	\N	\N	\N	\N	ANALYTE
88	STREP	7	\N	\N	\N	Oxidase	Catalase	\N	\N	\N	\N	\N	ANALYTE
94	US USR	7	Kahn's solution	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
1	TB	1	Micro Result	Culture Result	Report Date	\N	\N	\N	\N	\N	\N	\N	RESULT
2	GC	1	12 HOUR	24 HOUR	48 HOUR	\N	\N	\N	\N	\N	\N	\N	RESULT
9	US FTA	7	\N	\N	\N	\N	PBS	.	.	.	-	.	QC
10	US FTA	8	\N	\N	\N	\N	Sorbent	.	.	.	-	.	QC
8	US FTA	6	PBS	.	.	.	Nonspecific Control / Sorbent	.	.	.	-	.	QC
11	US FTA	1	    USR     Repeat Quant	   FTA      Current Run	    FTA     Previous Runs	   FTA         Final	  TPPA       Result	Comments	\N	\N	\N	\N	RESULT
26	US FTA	1	TEST	TESTing	\N	\N	\N	\N	\N	\N	\N	\N	ANALYTE
7	US FTA	5	.	.	.	.	Nonspecific Control/ PBS	.	.	.	>2+	.	QC
6	US FTA	4	FITCconjugate Working Dilution:	.	.	.	Minimally Reactive Control	.	.	.	1+	.	QC
5	US FTA	3	Sorbent	.	.	.	Reactive Control / Sorbent	.	.	.	3-4+	.	QC
4	US FTA	2	T Palladium antigen	.	.	.	Reactive Control/PBS	.	.	.	4+	.	QC
3	US FTA	1	Reagent	Source	Lot	Expire Date	Reagent	Source	Lot	Expires	Expect	Actual	QC
25	F	23	KNO3	RT incubation	.	.	\N	\N	\N	\N	\N	\N	ANALYTE
24	F	22	dulcitol	chlamydospores	.	.	\N	\N	\N	\N	\N	\N	ANALYTE
23	F	21	melibiose	ascospores	NO3	.	\N	\N	\N	\N	\N	\N	ANALYTE
22	F	20	trehalose	pigment	gelatin	.	\N	\N	\N	\N	\N	\N	ANALYTE
21	F	19	xylose	germ tubes	urea	probe (histo)	\N	\N	\N	\N	\N	\N	ANALYTE
20	F	18	inositol	urea	T4	probe (blasto)	\N	\N	\N	\N	\N	\N	ANALYTE
19	F	17	raffinose	OTHER TESTS	T3	probe (cocci)	\N	\N	\N	\N	\N	\N	ANALYTE
18	F	16	cellobiose	galactose	T2	PROBE TESTS	\N	\N	\N	\N	\N	\N	ANALYTE
17	F	15	galactose	trehalose	T1	.	\N	\N	\N	\N	\N	\N	ANALYTE
16	F	14	lactose	lactose	37 degrees	lysozyme	\N	\N	\N	\N	\N	\N	ANALYTE
15	F	13	sucrose	sucrose	RT incubation	xanthine	\N	\N	\N	\N	\N	\N	ANALYTE
14	F	12	maltose	maltose	sabs without CH	tyrosine	\N	\N	\N	\N	\N	\N	ANALYTE
13	F	11	dextrose	dextrose	sabs with CH	casein	\N	\N	\N	\N	\N	\N	ANALYTE
12	F	10	ASSIMILATIONS	FERMENTATIONS	FILAMENTOUS	ACTINOMYCETES	\N	\N	\N	\N	\N	\N	ANALYTE
62	US VDRL	1	QL	QN:2	4	8	16	32	64	128	256	Final	RESULT
93	US USR	15	Titer	.	.	.	.	.	.	.	\N	\N	QC
96	US FTA	10	\N	\N	\N	\N	TPPA - control	.	.	.	-	.	QC
95	US FTA	9	\N	\N	\N	\N	TPPA + control	.	.	.	+	.	QC
49	US USR	11	CONTROLS	SOURCE	LOT	EXPIRE DATE	RESULTS Qualitative Expect	RESULTS Qualitative  Actual	RESULTS Quantitative Expect	RESULTS Quantitative Actual	\N	\N	QC
48	US USR	10	Rotation of Slides	178-182	__________	rotations/min	\N	\N	\N	\N	\N	\N	QC
47	US USR	9	Temp of Lab	23-29	__________	degrees C	\N	\N	\N	\N	\N	\N	QC
46	US USR	6	Sterile DI H20	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
45	US USR	8	USR working antigen	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
44	US USR	5	Phosphate Buffer	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
43	US USR	4	EDTA	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
42	US USR	3	Choline Chloride	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
41	US USR	2	VDRL Antigen Kit	Difco	.	.	\N	\N	\N	\N	\N	\N	QC
40	US USR	1	REAGENT	SOURCE	LOT	EXPIRE DATE	\N	\N	\N	\N	\N	\N	QC
52	US USR	14	NC	Difco	.	.	NR	.	.	.	\N	\N	QC
51	US USR	13	LPC	Difco	.	.	WR	.	.	.	\N	\N	QC
50	US USR	12	HPC	Difco	.	.	R	.	.	.	\N	\N	QC
55	HSV TYPING	3	Expiration Date:	________________	Negative Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
54	HSV TYPING	2	Lot:	________________	HSV2 Positive Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
53	HSV TYPING	1	HSV1 / HSV2 Typing Kit:	________________	HSV1 Positive Cells:	Lot _____________	\N	\N	\N	\N	\N	\N	QC
57	HSV TYPING	2	HSV-1 PC	.	.	.	.	.	.	.	\N	\N	RESULT
58	HSV TYPING	3	HSV-1 nc	.	.	.	.	.	.	.	\N	\N	RESULT
60	HSV TYPING	5	HSV-2 nc	.	.	.	.	.	.	.	\N	\N	RESULT
59	HSV TYPING	4	HSV-2 PC	.	.	.	.	.	.	.	\N	\N	RESULT
74	MICRO	6	Pigment	Mannitol	Casein	Gelatin	\N	\N	\N	\N	\N	\N	ANALYTE
73	MICRO	5	Hemolysis	Maltose	Trehalose	Litmus Milk	\N	\N	\N	\N	\N	\N	ANALYTE
72	MICRO	4	O2 Relation	Sucrose	Sorbose	Ornithine	\N	\N	\N	\N	\N	\N	ANALYTE
92	STREP	11	\N	\N	\N	\N	PFGE	\N	\N	\N	\N	\N	ANALYTE
35	US VDRL	8	Rotation of Slides	.	178 - 182	__________	rotation/min	\N	\N	\N	\N	\N	QC
34	US VDRL	7	Temp of Lab	.	23 - 29	__________	degrees C	\N	\N	\N	\N	\N	QC
36	US VDRL	9	CONTROLS	SOURCE	LOT	EXPIRE DATE	RESULT Qualitative Expect	RESULT Qualitative  Actual	RESULT Quantitative Expect	RESULT Quantitative Actual	\N	\N	QC
56	HSV TYPING	1	Specimen ID	Received Date	Source	Pass	HSV1	HSV2	Comments	Mailer	\N	\N	RESULT
27	VI	1	Comments	Results	Interpretation	\N	\N	\N	\N	\N	\N	\N	RESULT
32	US VDRL	5	VDRL working antigen	.	.	.	\N	\N	\N	\N	\N	\N	QC
31	US VDRL	4	10% Saline	.	.	.	\N	\N	\N	\N	\N	\N	QC
30	US VDRL	3	Kahn Saline 0.9%	.	.	.	\N	\N	\N	\N	\N	\N	QC
29	US VDRL	2	VDRL Antigen Kit	Difco	.	.	\N	\N	\N	\N	\N	\N	QC
28	US VDRL	1	REAGENT	SOURCE	LOT	EXPIRE DATE	\N	\N	\N	\N	\N	\N	QC
38	US VDRL	11	LPC	Difco	.	.	WR	.	.	.	\N	\N	QC
37	US VDRL	10	HPC	Difco	.	.	R	.	.	.	\N	\N	QC
39	US VDRL	12	NC	Difco	.	.	NR	.	.	.	\N	\N	QC
61	US USR	1	QL	QN: 2	4	8	16	32	64	128	256	Final	RESULT
68	STREP	6	Factors	PFGE	\N	Catalase	Lact	\N	\N	\N	\N	\N	ANALYTE
67	STREP	5	Group	Latex	Latex	Kilian	Suc	\N	\N	\N	\N	\N	ANALYTE
66	STREP	4	Typing pool	PYR	Hipp	Satellites	Malt	\N	\N	\N	\N	\N	ANALYTE
65	STREP	3	Bile sol	A disc	Camp	X+V	Dex	\N	\N	\N	\N	\N	ANALYTE
64	STREP	2	P disc	GmSt	GmSt	GmSt	GmSt	\N	\N	\N	\N	\N	ANALYTE
63	STREP	1	Strep pneumo	Group A Strep	Group B Strep	H Influenzae	N. meningitidis	\N	\N	\N	\N	\N	ANALYTE
70	MICRO	3	Spores	Lactose	Sorbitol	Arginine	\N	\N	\N	\N	\N	\N	ANALYTE
69	MICRO	2	42	Glucose	Salicin	Lysine	\N	\N	\N	\N	\N	\N	ANALYTE
71	MICRO	1	Colony morphology	.	Gram morphology	.	\N	\N	\N	\N	\N	\N	ANALYTE
79	MICRO	11	MacConkey	Fructose	Motility	Pyruvate	\N	\N	\N	\N	\N	\N	ANALYTE
78	MICRO	10	Serology	Inulin	.	6.5% salt	\N	\N	\N	\N	\N	\N	ANALYTE
77	MICRO	9	Satellites	Cellibiose	Alk Phos	Bile Esculin	\N	\N	\N	\N	\N	\N	ANALYTE
76	MICRO	8	Kilian test	Arabinose	PZA	Esculin	\N	\N	\N	\N	\N	\N	ANALYTE
75	MICRO	7	X+V Req	Xylose	Starch	Cetrimide	\N	\N	\N	\N	\N	\N	ANALYTE
87	MICRO	19	Lecthinase	Ribose	Phenylalanine	.	\N	\N	\N	\N	\N	\N	ANALYTE
86	MICRO	18	Lipase	Rhamnose	Acetate	FREEZE	\N	\N	\N	\N	\N	\N	ANALYTE
85	MICRO	17	.	Raffinose	Citrate	PFGE	\N	\N	\N	\N	\N	\N	ANALYTE
84	MICRO	16	Optochin	MMP	MR         VP	LAP         PYR	\N	\N	\N	\N	\N	\N	ANALYTE
83	MICRO	15	Camp	Melibiose	Indol	Erythromycin	\N	\N	\N	\N	\N	\N	ANALYTE
82	MICRO	14	Bacitracin	Mannose	Nitite	Vancomycin	\N	\N	\N	\N	\N	\N	ANALYTE
81	MICRO	13	Catalase	Glycerol	Nitrate	Coagulase	\N	\N	\N	\N	\N	\N	ANALYTE
80	MICRO	12	Oxidase	Galactose	Urease	MGP	\N	\N	\N	\N	\N	\N	ANALYTE
91	STREP	10	\N	\N	\N	\N	Serology	\N	\N	\N	\N	\N	ANALYTE
90	STREP	9	\N	\N	\N	\N	TM	\N	\N	\N	\N	\N	ANALYTE
89	STREP	8	\N	\N	\N	Serology	Oxidase	\N	\N	\N	\N	\N	ANALYTE
88	STREP	7	\N	\N	\N	Oxidase	Catalase	\N	\N	\N	\N	\N	ANALYTE
94	US USR	7	Kahn's solution	MDH	.	.	\N	\N	\N	\N	\N	\N	QC
\.


--
-- Data for Name: worksheet_item; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY worksheet_item (id, "position", worksheet_id) FROM stdin;
\.


--
-- Data for Name: worksheet_qc; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY worksheet_qc (id, sort_order, wq_type, value, worksheet_analysis_id, qc_analyte_id) FROM stdin;
\.


--
-- Data for Name: worksheets; Type: TABLE DATA; Schema: clinlims; Owner: clinlims
--

COPY worksheets (id, sys_user_id, test_id, created, status, number_format) FROM stdin;
\.


--
-- Name: zip_code_seq; Type: SEQUENCE SET; Schema: clinlims; Owner: clinlims
--

SELECT pg_catalog.setval('zip_code_seq', 1, false);


--
-- Name: address_part_part_name_key; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY address_part
    ADD CONSTRAINT address_part_part_name_key UNIQUE (part_name);


--
-- Name: address_part_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY address_part
    ADD CONSTRAINT address_part_pk PRIMARY KEY (id);


--
-- Name: analysis_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY analysis
    ADD CONSTRAINT analysis_pk PRIMARY KEY (id);


--
-- Name: analyte_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY analyte
    ADD CONSTRAINT analyte_pk PRIMARY KEY (id);


--
-- Name: analyzer_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY analyzer
    ADD CONSTRAINT analyzer_pk PRIMARY KEY (id);


--
-- Name: analyzer_result_status_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY analyzer_result_status
    ADD CONSTRAINT analyzer_result_status_pk PRIMARY KEY (id);


--
-- Name: analyzer_test_map_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY analyzer_test_map
    ADD CONSTRAINT analyzer_test_map_pk PRIMARY KEY (analyzer_id, analyzer_test_name);


--
-- Name: anauser_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY analysis_users
    ADD CONSTRAINT anauser_pk PRIMARY KEY (id);


--
-- Name: ani_samp_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample_animal
    ADD CONSTRAINT ani_samp_pk PRIMARY KEY (id);


--
-- Name: anqaev_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY analysis_qaevent
    ADD CONSTRAINT anqaev_pk PRIMARY KEY (id);


--
-- Name: anstore_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY analysis_storages
    ADD CONSTRAINT anstore_pk PRIMARY KEY (id);


--
-- Name: attachment_item_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY attachment_item
    ADD CONSTRAINT attachment_item_pk PRIMARY KEY (id);


--
-- Name: attachment_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY attachment
    ADD CONSTRAINT attachment_pk PRIMARY KEY (id);


--
-- Name: auxdata_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY aux_data
    ADD CONSTRAINT auxdata_pk PRIMARY KEY (id);


--
-- Name: auxfld_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY aux_field
    ADD CONSTRAINT auxfld_pk PRIMARY KEY (id);


--
-- Name: auxfldval_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY aux_field_values
    ADD CONSTRAINT auxfldval_pk PRIMARY KEY (id);


--
-- Name: code_element_type_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY code_element_type
    ADD CONSTRAINT code_element_type_pk PRIMARY KEY (id);


--
-- Name: code_element_xref_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY code_element_xref
    ADD CONSTRAINT code_element_xref_pk PRIMARY KEY (id);


--
-- Name: comm_anim_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY animal_common_name
    ADD CONSTRAINT comm_anim_pk PRIMARY KEY (id);


--
-- Name: cron_scheduler_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY quartz_cron_scheduler
    ADD CONSTRAINT cron_scheduler_pk PRIMARY KEY (id);


--
-- Name: ct_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY contact_type
    ADD CONSTRAINT ct_pk PRIMARY KEY (id);


--
-- Name: demog_hist_type_type_name_u; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY observation_history_type
    ADD CONSTRAINT demog_hist_type_type_name_u UNIQUE (type_name);


--
-- Name: demographic_history_type_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY observation_history_type
    ADD CONSTRAINT demographic_history_type_pk PRIMARY KEY (id);


--
-- Name: demographics_history_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY observation_history
    ADD CONSTRAINT demographics_history_pk PRIMARY KEY (id);


--
-- Name: dict_cat_desc_u; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY dictionary_category
    ADD CONSTRAINT dict_cat_desc_u UNIQUE (description);


--
-- Name: dict_cat_local_abbrev_u; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY dictionary_category
    ADD CONSTRAINT dict_cat_local_abbrev_u UNIQUE (local_abbrev);


--
-- Name: dict_dict_cat_id_dict_entry_u; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY dictionary
    ADD CONSTRAINT dict_dict_cat_id_dict_entry_u UNIQUE (dictionary_category_id, dict_entry);


--
-- Name: dict_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY dictionary
    ADD CONSTRAINT dict_pk PRIMARY KEY (id);


--
-- Name: dictionary_category_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY dictionary_category
    ADD CONSTRAINT dictionary_category_pk PRIMARY KEY (id);


--
-- Name: dist_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY district
    ADD CONSTRAINT dist_pk PRIMARY KEY (id);


--
-- Name: env_samp_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample_environmental
    ADD CONSTRAINT env_samp_pk PRIMARY KEY (id);


--
-- Name: ethnic_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY ethnicity
    ADD CONSTRAINT ethnic_pk PRIMARY KEY (id);


--
-- Name: gender_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY gender
    ADD CONSTRAINT gender_pk PRIMARY KEY (id);


--
-- Name: hist_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY history
    ADD CONSTRAINT hist_pk PRIMARY KEY (id);


--
-- Name: hl7_encoding_type_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY test_code_type
    ADD CONSTRAINT hl7_encoding_type_pk PRIMARY KEY (id);


--
-- Name: hum_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample_human
    ADD CONSTRAINT hum_pk PRIMARY KEY (id);


--
-- Name: ia_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY instrument_analyte
    ADD CONSTRAINT ia_pk PRIMARY KEY (id);


--
-- Name: id; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY analyzer_results
    ADD CONSTRAINT id PRIMARY KEY (id);


--
-- Name: identity_type_uk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY patient_identity_type
    ADD CONSTRAINT identity_type_uk UNIQUE (identity_type);


--
-- Name: il_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY instrument_log
    ADD CONSTRAINT il_pk PRIMARY KEY (id);


--
-- Name: import_status_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY import_status
    ADD CONSTRAINT import_status_pk PRIMARY KEY (id);


--
-- Name: import_status_saved_file_name_key; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY import_status
    ADD CONSTRAINT import_status_saved_file_name_key UNIQUE (saved_file_name);


--
-- Name: instru_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY instrument
    ADD CONSTRAINT instru_pk PRIMARY KEY (id);


--
-- Name: inv_recpt_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY inventory_receipt
    ADD CONSTRAINT inv_recpt_pk PRIMARY KEY (id);


--
-- Name: invcomp_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY inventory_component
    ADD CONSTRAINT invcomp_pk PRIMARY KEY (id);


--
-- Name: invitem_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY inventory_item
    ADD CONSTRAINT invitem_pk PRIMARY KEY (id);


--
-- Name: invloc_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY inventory_location
    ADD CONSTRAINT invloc_pk PRIMARY KEY (id);


--
-- Name: lab_order_item_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY lab_order_item
    ADD CONSTRAINT lab_order_item_pk PRIMARY KEY (id);


--
-- Name: lab_order_type_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY lab_order_type
    ADD CONSTRAINT lab_order_type_pk PRIMARY KEY (id);


--
-- Name: label_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY label
    ADD CONSTRAINT label_pk PRIMARY KEY (id);


--
-- Name: login_user_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY login_user
    ADD CONSTRAINT login_user_pk PRIMARY KEY (login_name);


--
-- Name: ma_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY method_analyte
    ADD CONSTRAINT ma_pk PRIMARY KEY (id);


--
-- Name: menu_element_id_key; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT menu_element_id_key UNIQUE (element_id);


--
-- Name: message_org_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY message_org
    ADD CONSTRAINT message_org_pk PRIMARY KEY (id);


--
-- Name: method_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY method
    ADD CONSTRAINT method_pk PRIMARY KEY (id);


--
-- Name: methres_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY method_result
    ADD CONSTRAINT methres_pk PRIMARY KEY (id);


--
-- Name: mls_lab_tp_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY mls_lab_type
    ADD CONSTRAINT mls_lab_tp_pk PRIMARY KEY (id);


--
-- Name: newborn_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample_newborn
    ADD CONSTRAINT newborn_pk PRIMARY KEY (id);


--
-- Name: note_id; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY note
    ADD CONSTRAINT note_id PRIMARY KEY (id);


--
-- Name: oct_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY occupation
    ADD CONSTRAINT oct_pk PRIMARY KEY (id);


--
-- Name: or_properties_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY or_properties
    ADD CONSTRAINT or_properties_pkey PRIMARY KEY (property_id);


--
-- Name: or_properties_property_key_key; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY or_properties
    ADD CONSTRAINT or_properties_property_key_key UNIQUE (property_key);


--
-- Name: or_tags_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY or_tags
    ADD CONSTRAINT or_tags_pkey PRIMARY KEY (tag_id);


--
-- Name: ord_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT ord_pk PRIMARY KEY (id);


--
-- Name: orditem_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT orditem_pk PRIMARY KEY (id);


--
-- Name: org_contact_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY organization_contact
    ADD CONSTRAINT org_contact_pk PRIMARY KEY (id);


--
-- Name: org_hl7_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY org_hl7_encoding_type
    ADD CONSTRAINT org_hl7_pk PRIMARY KEY (organization_id, encoding_type_id);


--
-- Name: org_mlt_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY org_mls_lab_type
    ADD CONSTRAINT org_mlt_pk PRIMARY KEY (org_mlt_id);


--
-- Name: org_org_type_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY organization_organization_type
    ADD CONSTRAINT org_org_type_pk PRIMARY KEY (org_id, org_type_id);


--
-- Name: org_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY organization
    ADD CONSTRAINT org_pk PRIMARY KEY (id);


--
-- Name: org_type_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY organization_type
    ADD CONSTRAINT org_type_pk PRIMARY KEY (id);


--
-- Name: organization_address_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY organization_address
    ADD CONSTRAINT organization_address_pk PRIMARY KEY (organization_id, address_part_id);


--
-- Name: pac_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY package_1
    ADD CONSTRAINT pac_pk PRIMARY KEY (id);


--
-- Name: pan_it_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY panel_item
    ADD CONSTRAINT pan_it_pk PRIMARY KEY (id);


--
-- Name: panel_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY panel
    ADD CONSTRAINT panel_pk PRIMARY KEY (id);


--
-- Name: pat_ident_type_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY patient_identity_type
    ADD CONSTRAINT pat_ident_type_pk PRIMARY KEY (id);


--
-- Name: pat_identity_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY patient_identity
    ADD CONSTRAINT pat_identity_pk PRIMARY KEY (id);


--
-- Name: pat_occupation_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY patient_occupation
    ADD CONSTRAINT pat_occupation_pk PRIMARY KEY (id);


--
-- Name: pat_pat_type_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY patient_patient_type
    ADD CONSTRAINT pat_pat_type_pk PRIMARY KEY (id);


--
-- Name: pat_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY patient
    ADD CONSTRAINT pat_pk PRIMARY KEY (id);


--
-- Name: pat_type_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY patient_type
    ADD CONSTRAINT pat_type_pk PRIMARY KEY (id);


--
-- Name: pay_type_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY payment_type
    ADD CONSTRAINT pay_type_pk PRIMARY KEY (id);


--
-- Name: person_address_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT person_address_pk PRIMARY KEY (person_id, address_part_id);


--
-- Name: person_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY person
    ADD CONSTRAINT person_pk PRIMARY KEY (id);


--
-- Name: pk_chunking_history; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY chunking_history
    ADD CONSTRAINT pk_chunking_history PRIMARY KEY (id);


--
-- Name: pk_databasechangelog; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY databasechangelog
    ADD CONSTRAINT pk_databasechangelog PRIMARY KEY (id, author, filename);


--
-- Name: pk_databasechangeloglock; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY databasechangeloglock
    ADD CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id);


--
-- Name: pk_document_track; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY document_track
    ADD CONSTRAINT pk_document_track PRIMARY KEY (id);


--
-- Name: pk_document_type; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY document_type
    ADD CONSTRAINT pk_document_type PRIMARY KEY (id);


--
-- Name: pk_event_records; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY event_records
    ADD CONSTRAINT pk_event_records PRIMARY KEY (id);


--
-- Name: pk_event_records_offset_marker; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY event_records_offset_marker
    ADD CONSTRAINT pk_event_records_offset_marker PRIMARY KEY (id);


--
-- Name: pk_event_records_queue; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY event_records_queue
    ADD CONSTRAINT pk_event_records_queue PRIMARY KEY (id);


--
-- Name: pk_external_reference; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY external_reference
    ADD CONSTRAINT pk_external_reference PRIMARY KEY (id);


--
-- Name: pk_failed_event_retry_log; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY failed_event_retry_log
    ADD CONSTRAINT pk_failed_event_retry_log PRIMARY KEY (id);


--
-- Name: pk_failed_events; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY failed_events
    ADD CONSTRAINT pk_failed_events PRIMARY KEY (id);


--
-- Name: pk_markers; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY markers
    ADD CONSTRAINT pk_markers PRIMARY KEY (id);


--
-- Name: pk_menu; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT pk_menu PRIMARY KEY (id);


--
-- Name: pk_qa_observation; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qa_observation
    ADD CONSTRAINT pk_qa_observation PRIMARY KEY (id);


--
-- Name: pk_qa_observation_type; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qa_observation_type
    ADD CONSTRAINT pk_qa_observation_type PRIMARY KEY (id);


--
-- Name: pk_sample_source; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample_source
    ADD CONSTRAINT pk_sample_source PRIMARY KEY (id);


--
-- Name: pr_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY patient_relations
    ADD CONSTRAINT pr_pk PRIMARY KEY (id);


--
-- Name: progs_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY program
    ADD CONSTRAINT progs_pk PRIMARY KEY (id);


--
-- Name: proj_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY project
    ADD CONSTRAINT proj_pk PRIMARY KEY (id);


--
-- Name: project_org_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY project_organization
    ADD CONSTRAINT project_org_pk PRIMARY KEY (project_id, org_id);


--
-- Name: projparam_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY project_parameter
    ADD CONSTRAINT projparam_pk PRIMARY KEY (id);


--
-- Name: provider_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY provider
    ADD CONSTRAINT provider_pk PRIMARY KEY (id);


--
-- Name: qa_event_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qa_event
    ADD CONSTRAINT qa_event_pk PRIMARY KEY (id);


--
-- Name: qc_analyt_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qc_analytes
    ADD CONSTRAINT qc_analyt_pk PRIMARY KEY (id);


--
-- Name: qc_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qc
    ADD CONSTRAINT qc_pk PRIMARY KEY (id);


--
-- Name: qrtz_blob_triggers_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qrtz_blob_triggers
    ADD CONSTRAINT qrtz_blob_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);


--
-- Name: qrtz_calendars_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qrtz_calendars
    ADD CONSTRAINT qrtz_calendars_pkey PRIMARY KEY (calendar_name);


--
-- Name: qrtz_cron_triggers_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qrtz_cron_triggers
    ADD CONSTRAINT qrtz_cron_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);


--
-- Name: qrtz_fired_triggers_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qrtz_fired_triggers
    ADD CONSTRAINT qrtz_fired_triggers_pkey PRIMARY KEY (entry_id);


--
-- Name: qrtz_job_details_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qrtz_job_details
    ADD CONSTRAINT qrtz_job_details_pkey PRIMARY KEY (job_name, job_group);


--
-- Name: qrtz_job_listeners_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qrtz_job_listeners
    ADD CONSTRAINT qrtz_job_listeners_pkey PRIMARY KEY (job_name, job_group, job_listener);


--
-- Name: qrtz_locks_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qrtz_locks
    ADD CONSTRAINT qrtz_locks_pkey PRIMARY KEY (lock_name);


--
-- Name: qrtz_paused_trigger_grps_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qrtz_paused_trigger_grps
    ADD CONSTRAINT qrtz_paused_trigger_grps_pkey PRIMARY KEY (trigger_group);


--
-- Name: qrtz_scheduler_state_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qrtz_scheduler_state
    ADD CONSTRAINT qrtz_scheduler_state_pkey PRIMARY KEY (instance_name);


--
-- Name: qrtz_simple_triggers_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qrtz_simple_triggers
    ADD CONSTRAINT qrtz_simple_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);


--
-- Name: qrtz_trigger_listeners_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qrtz_trigger_listeners
    ADD CONSTRAINT qrtz_trigger_listeners_pkey PRIMARY KEY (trigger_name, trigger_group, trigger_listener);


--
-- Name: qrtz_triggers_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY qrtz_triggers
    ADD CONSTRAINT qrtz_triggers_pkey PRIMARY KEY (trigger_name, trigger_group);


--
-- Name: race_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY race
    ADD CONSTRAINT race_pk PRIMARY KEY (id);


--
-- Name: receiver_code_element_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY receiver_code_element
    ADD CONSTRAINT receiver_code_element_pk PRIMARY KEY (id);


--
-- Name: referral_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY referral
    ADD CONSTRAINT referral_pk PRIMARY KEY (id);


--
-- Name: referral_reason_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY referral_reason
    ADD CONSTRAINT referral_reason_pk PRIMARY KEY (id);


--
-- Name: referral_result_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY referral_result
    ADD CONSTRAINT referral_result_pk PRIMARY KEY (id);


--
-- Name: referral_type_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY referral_type
    ADD CONSTRAINT referral_type_pk PRIMARY KEY (id);


--
-- Name: region_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY region
    ADD CONSTRAINT region_pk PRIMARY KEY (id);


--
-- Name: report_external_import_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY report_external_import
    ADD CONSTRAINT report_external_import_pk PRIMARY KEY (id);


--
-- Name: report_queue_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY report_external_export
    ADD CONSTRAINT report_queue_pk PRIMARY KEY (id);


--
-- Name: report_queue_type_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY report_queue_type
    ADD CONSTRAINT report_queue_type_pk PRIMARY KEY (id);


--
-- Name: requester_type_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY requester_type
    ADD CONSTRAINT requester_type_pk PRIMARY KEY (id);


--
-- Name: result_inventory_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY result_inventory
    ADD CONSTRAINT result_inventory_pk PRIMARY KEY (id);


--
-- Name: result_limits_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY result_limits
    ADD CONSTRAINT result_limits_pk PRIMARY KEY (id);


--
-- Name: result_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY result
    ADD CONSTRAINT result_pk PRIMARY KEY (id);


--
-- Name: result_signature_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY result_signature
    ADD CONSTRAINT result_signature_pk PRIMARY KEY (id);


--
-- Name: rt_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY reference_tables
    ADD CONSTRAINT rt_pk PRIMARY KEY (id);


--
-- Name: samp_org_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample_organization
    ADD CONSTRAINT samp_org_pk PRIMARY KEY (id);


--
-- Name: samp_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT samp_pk PRIMARY KEY (id);


--
-- Name: sampitem_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample_item
    ADD CONSTRAINT sampitem_pk PRIMARY KEY (id);


--
-- Name: sample_human_samp_id_u; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample_human
    ADD CONSTRAINT sample_human_samp_id_u UNIQUE (samp_id);


--
-- Name: sample_pdf_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample_pdf
    ADD CONSTRAINT sample_pdf_pk PRIMARY KEY (id);


--
-- Name: sample_projects_pk_i; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample_projects
    ADD CONSTRAINT sample_projects_pk_i PRIMARY KEY (id);


--
-- Name: sample_qaevent_action_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample_qaevent_action
    ADD CONSTRAINT sample_qaevent_action_pkey PRIMARY KEY (id);


--
-- Name: sample_qaevent_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample_qaevent
    ADD CONSTRAINT sample_qaevent_pkey PRIMARY KEY (id);


--
-- Name: sample_requester_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample_requester
    ADD CONSTRAINT sample_requester_pk PRIMARY KEY (sample_id, requester_id, requester_type_id);


--
-- Name: sample_source_name_key; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample_source
    ADD CONSTRAINT sample_source_name_key UNIQUE (name);


--
-- Name: sampledom_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sample_domain
    ADD CONSTRAINT sampledom_pk PRIMARY KEY (id);


--
-- Name: sampletype_panel_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sampletype_panel
    ADD CONSTRAINT sampletype_panel_pkey PRIMARY KEY (id);


--
-- Name: sampletype_test_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY sampletype_test
    ADD CONSTRAINT sampletype_test_pkey PRIMARY KEY (id);


--
-- Name: sci_name_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY animal_scientific_name
    ADD CONSTRAINT sci_name_pk PRIMARY KEY (id);


--
-- Name: scr_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY state_code
    ADD CONSTRAINT scr_pk PRIMARY KEY (id);


--
-- Name: scrip_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY scriptlet
    ADD CONSTRAINT scrip_pk PRIMARY KEY (id);


--
-- Name: site_info_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY site_information
    ADD CONSTRAINT site_info_pk PRIMARY KEY (id);


--
-- Name: site_information_domain_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY site_information_domain
    ADD CONSTRAINT site_information_domain_pk PRIMARY KEY (id);


--
-- Name: source_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY source_of_sample
    ADD CONSTRAINT source_pk PRIMARY KEY (id);


--
-- Name: storage_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY storage_location
    ADD CONSTRAINT storage_pk PRIMARY KEY (id);


--
-- Name: su_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY storage_unit
    ADD CONSTRAINT su_pk PRIMARY KEY (id);


--
-- Name: sys_c003998; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY action
    ADD CONSTRAINT sys_c003998 PRIMARY KEY (id);


--
-- Name: sys_c003999; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY action
    ADD CONSTRAINT sys_c003999 UNIQUE (code);


--
-- Name: sys_c004009; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY analysis_qaevent_action
    ADD CONSTRAINT sys_c004009 PRIMARY KEY (id);


--
-- Name: sys_c004307; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY status_of_sample
    ADD CONSTRAINT sys_c004307 PRIMARY KEY (id);


--
-- Name: sys_mod_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY system_module
    ADD CONSTRAINT sys_mod_pk PRIMARY KEY (id);


--
-- Name: sys_role_mo_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY system_role_module
    ADD CONSTRAINT sys_role_mo_pk PRIMARY KEY (id);


--
-- Name: sys_use_mo_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY system_user_module
    ADD CONSTRAINT sys_use_mo_pk PRIMARY KEY (id);


--
-- Name: sys_use_se_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY system_user_section
    ADD CONSTRAINT sys_use_se_pk PRIMARY KEY (id);


--
-- Name: sys_user_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY system_user
    ADD CONSTRAINT sys_user_pk PRIMARY KEY (id);


--
-- Name: sys_usr_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY system_user_role
    ADD CONSTRAINT sys_usr_pk PRIMARY KEY (system_user_id, role_id);


--
-- Name: system_role_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY system_role
    ADD CONSTRAINT system_role_pkey PRIMARY KEY (id);


--
-- Name: test_analyte_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY test_analyte
    ADD CONSTRAINT test_analyte_pk PRIMARY KEY (id);


--
-- Name: test_hl7_code_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY test_code
    ADD CONSTRAINT test_hl7_code_pk PRIMARY KEY (test_id, code_type_id);


--
-- Name: test_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY test
    ADD CONSTRAINT test_pk PRIMARY KEY (id);


--
-- Name: test_reflx_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY test_reflex
    ADD CONSTRAINT test_reflx_pk PRIMARY KEY (id);


--
-- Name: test_sect_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY test_section
    ADD CONSTRAINT test_sect_pk PRIMARY KEY (id);


--
-- Name: testfrmt_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY test_formats
    ADD CONSTRAINT testfrmt_pk PRIMARY KEY (id);


--
-- Name: tst_rslt_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY test_result
    ADD CONSTRAINT tst_rslt_pk PRIMARY KEY (id);


--
-- Name: tsttrlr_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY test_trailer
    ADD CONSTRAINT tsttrlr_pk PRIMARY KEY (id);


--
-- Name: tw_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY test_worksheets
    ADD CONSTRAINT tw_pk PRIMARY KEY (id);


--
-- Name: twi_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY test_worksheet_item
    ADD CONSTRAINT twi_pk PRIMARY KEY (id);


--
-- Name: type_of_test_result_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY type_of_test_result
    ADD CONSTRAINT type_of_test_result_pk PRIMARY KEY (id);


--
-- Name: typeosamp_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY type_of_sample
    ADD CONSTRAINT typeosamp_pk PRIMARY KEY (id);


--
-- Name: typofprovider_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY type_of_provider
    ADD CONSTRAINT typofprovider_pk PRIMARY KEY (id);


--
-- Name: unique_ids; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY external_reference
    ADD CONSTRAINT unique_ids UNIQUE (item_id, type);


--
-- Name: unique_uuid_constraint; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY patient
    ADD CONSTRAINT unique_uuid_constraint UNIQUE (uuid);


--
-- Name: uom_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY unit_of_measure
    ADD CONSTRAINT uom_pk PRIMARY KEY (id);


--
-- Name: user_alert_map_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY user_alert_map
    ADD CONSTRAINT user_alert_map_pkey PRIMARY KEY (user_id, map_id);


--
-- Name: user_group_map_pkey; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY user_group_map
    ADD CONSTRAINT user_group_map_pkey PRIMARY KEY (user_id, map_id);


--
-- Name: workst_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY worksheets
    ADD CONSTRAINT workst_pk PRIMARY KEY (id);


--
-- Name: wq_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY worksheet_qc
    ADD CONSTRAINT wq_pk PRIMARY KEY (id);


--
-- Name: wrkst_anls_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY worksheet_analysis
    ADD CONSTRAINT wrkst_anls_pk PRIMARY KEY (id);


--
-- Name: wrkst_anlt_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY worksheet_analyte
    ADD CONSTRAINT wrkst_anlt_pk PRIMARY KEY (id);


--
-- Name: wrkst_item_pk; Type: CONSTRAINT; Schema: clinlims; Owner: clinlims; Tablespace: 
--

ALTER TABLE ONLY worksheet_item
    ADD CONSTRAINT wrkst_item_pk PRIMARY KEY (id);


--
-- Name: accnum_uk; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE UNIQUE INDEX accnum_uk ON sample USING btree (accession_number);


--
-- Name: ad_afield_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX ad_afield_fk_i ON aux_data USING btree (aux_field_id);


--
-- Name: af_analyte_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX af_analyte_fk_i ON aux_field USING btree (analyte_id);


--
-- Name: af_script_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX af_script_fk_i ON aux_field USING btree (scriptlet_id);


--
-- Name: afv_afield_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX afv_afield_fk_i ON aux_field_values USING btree (aux_field_id);


--
-- Name: analysis_lastupdated_idx; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX analysis_lastupdated_idx ON analysis USING btree (lastupdated);


--
-- Name: analysis_sampitem_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX analysis_sampitem_fk_i ON analysis USING btree (sampitem_id);


--
-- Name: analysis_test_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX analysis_test_fk_i ON analysis USING btree (test_id);


--
-- Name: analysis_test_sect_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX analysis_test_sect_fk_i ON analysis USING btree (test_sect_id);


--
-- Name: analyte_analyte_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX analyte_analyte_fk_i ON analyte USING btree (analyte_id);


--
-- Name: ani_samp_comm_anim_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX ani_samp_comm_anim_fk_i ON sample_animal USING btree (comm_anim_id);


--
-- Name: ani_samp_samp_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX ani_samp_samp_fk_i ON sample_animal USING btree (samp_id);


--
-- Name: ani_samp_sci_name_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX ani_samp_sci_name_fk_i ON sample_animal USING btree (sci_name_id);


--
-- Name: anqaev_anal_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX anqaev_anal_fk_i ON analysis_qaevent USING btree (analysis_id);


--
-- Name: anqaev_qa_event_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX anqaev_qa_event_fk_i ON analysis_qaevent USING btree (qa_event_id);


--
-- Name: anst_anal_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX anst_anal_fk_i ON analysis_storages USING btree (analysis_id);


--
-- Name: anstore_storage_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX anstore_storage_fk_i ON analysis_storages USING btree (storage_id);


--
-- Name: anus_anal_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX anus_anal_fk_i ON analysis_users USING btree (analysis_id);


--
-- Name: anus_sysuser_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX anus_sysuser_fk_i ON analysis_users USING btree (system_user_id);


--
-- Name: attachmtitem_attachmt_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX attachmtitem_attachmt_fk_i ON attachment_item USING btree (attachment_id);


--
-- Name: env_samp_samp_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX env_samp_samp_fk_i ON sample_environmental USING btree (samp_id);


--
-- Name: event_records_category_idx; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX event_records_category_idx ON event_records USING btree (category);


--
-- Name: hist_sys_user_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX hist_sys_user_fk_i ON history USING btree (sys_user_id);


--
-- Name: hist_table_row_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX hist_table_row_i ON history USING btree (reference_id, reference_table);


--
-- Name: hum_pat_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX hum_pat_fk_i ON sample_human USING btree (patient_id);


--
-- Name: hum_provider_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX hum_provider_fk_i ON sample_human USING btree (provider_id);


--
-- Name: hum_samp_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX hum_samp_fk_i ON sample_human USING btree (samp_id);


--
-- Name: ia_analyte_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX ia_analyte_fk_i ON instrument_analyte USING btree (analyte_id);


--
-- Name: ia_instru_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX ia_instru_fk_i ON instrument_analyte USING btree (instru_id);


--
-- Name: ia_method_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX ia_method_fk_i ON instrument_analyte USING btree (method_id);


--
-- Name: il_instru_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX il_instru_fk_i ON instrument_log USING btree (instru_id);


--
-- Name: il_inv_item_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX il_inv_item_fk_i ON inventory_location USING btree (inv_item_id);


--
-- Name: instru_scrip_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX instru_scrip_fk_i ON instrument USING btree (scrip_id);


--
-- Name: inv_recpt_invitem_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX inv_recpt_invitem_fk_i ON inventory_receipt USING btree (invitem_id);


--
-- Name: invcomp_invitem_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX invcomp_invitem_fk_i ON inventory_component USING btree (invitem_id);


--
-- Name: invcomp_matcomp_fk_ii; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX invcomp_matcomp_fk_ii ON inventory_component USING btree (material_component_id);


--
-- Name: invitem_invname_uk; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE UNIQUE INDEX invitem_invname_uk ON inventory_item USING btree (name);


--
-- Name: invitem_uom_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX invitem_uom_fk_i ON inventory_item USING btree (uom_id);


--
-- Name: invloc_storage_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX invloc_storage_fk_i ON inventory_location USING btree (storage_id);


--
-- Name: invrec_org_fk_ii; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX invrec_org_fk_ii ON inventory_receipt USING btree (org_id);


--
-- Name: label_script_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX label_script_fk_i ON label USING btree (scriptlet_id);


--
-- Name: ma_analyte_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX ma_analyte_fk_i ON method_analyte USING btree (analyte_id);


--
-- Name: ma_method_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX ma_method_fk_i ON method_analyte USING btree (method_id);


--
-- Name: methres_method_fk_iii; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX methres_method_fk_iii ON method_result USING btree (method_id);


--
-- Name: methres_scrip_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX methres_scrip_fk_i ON method_result USING btree (scrip_id);


--
-- Name: mls_lab_tp_org_mlt_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX mls_lab_tp_org_mlt_fk_i ON mls_lab_type USING btree (org_mlt_org_mlt_id);


--
-- Name: note_sys_user_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX note_sys_user_fk_i ON note USING btree (sys_user_id);


--
-- Name: obs_history_sample_idx; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX obs_history_sample_idx ON observation_history USING btree (sample_id);


--
-- Name: ord_org_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX ord_org_fk_i ON orders USING btree (org_id);


--
-- Name: ord_sys_user_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX ord_sys_user_fk_i ON orders USING btree (sys_user_id);


--
-- Name: orditem_inv_loc_fk_iii; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX orditem_inv_loc_fk_iii ON order_item USING btree (inv_loc_id);


--
-- Name: orditem_ord_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX orditem_ord_fk_i ON order_item USING btree (ord_id);


--
-- Name: org_org_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX org_org_fk_i ON organization USING btree (org_id);


--
-- Name: org_org_mlt_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX org_org_mlt_fk_i ON organization USING btree (org_mlt_org_mlt_id);


--
-- Name: pan_it_panel_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX pan_it_panel_fk_i ON panel_item USING btree (panel_id);


--
-- Name: pat_person_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX pat_person_fk_i ON patient USING btree (person_id);


--
-- Name: patient_identity_patient_id_idx; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX patient_identity_patient_id_idx ON patient_identity USING btree (patient_id);


--
-- Name: pr_pat_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX pr_pat_fk_i ON patient_relations USING btree (pat_id);


--
-- Name: pr_pat_source_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX pr_pat_source_fk_i ON patient_relations USING btree (pat_id_source);


--
-- Name: proj_sys_user_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX proj_sys_user_fk_i ON project USING btree (sys_user_id);


--
-- Name: project_script_fk_iii; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX project_script_fk_iii ON project USING btree (scriptlet_id);


--
-- Name: projectparam_proj_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX projectparam_proj_fk_i ON project_parameter USING btree (project_id);


--
-- Name: provider_person_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX provider_person_fk_i ON provider USING btree (person_id);


--
-- Name: qaev_test_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX qaev_test_fk_i ON qa_event USING btree (test_id);


--
-- Name: qc_sys_user_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX qc_sys_user_fk_i ON qc USING btree (sys_user_id);


--
-- Name: qc_uom_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX qc_uom_fk_i ON qc USING btree (uom_id);


--
-- Name: qcanlyt_analyte_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX qcanlyt_analyte_fk_i ON qc_analytes USING btree (analyte_id);


--
-- Name: report_import_date; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX report_import_date ON report_external_import USING btree (event_date);


--
-- Name: report_queue_date; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX report_queue_date ON report_external_export USING btree (event_date);


--
-- Name: result_analysis_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX result_analysis_fk_i ON result USING btree (analysis_id);


--
-- Name: result_analyte_fk_iii; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX result_analyte_fk_iii ON result USING btree (analyte_id);


--
-- Name: result_testresult_fk_1; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX result_testresult_fk_1 ON result USING btree (test_result_id);


--
-- Name: samp_org_org_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX samp_org_org_fk_i ON sample_organization USING btree (org_id);


--
-- Name: samp_org_samp_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX samp_org_samp_fk_i ON sample_organization USING btree (samp_id);


--
-- Name: samp_package_1_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX samp_package_1_fk_i ON sample USING btree (package_id);


--
-- Name: samp_sys_user_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX samp_sys_user_fk_i ON sample USING btree (sys_user_id);


--
-- Name: sampitem_samp_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX sampitem_samp_fk_i ON sample_item USING btree (samp_id);


--
-- Name: sampitem_samp_item_uk_uk; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE UNIQUE INDEX sampitem_samp_item_uk_uk ON sample_item USING btree (id, sort_order);


--
-- Name: sampitem_sampitem_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX sampitem_sampitem_fk_i ON sample_item USING btree (sampitem_id);


--
-- Name: sampitem_source_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX sampitem_source_fk_i ON sample_item USING btree (source_id);


--
-- Name: sampitem_typeosamp_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX sampitem_typeosamp_fk_i ON sample_item USING btree (typeosamp_id);


--
-- Name: sampitem_uom_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX sampitem_uom_fk_i ON sample_item USING btree (uom_id);


--
-- Name: sample_lastupdated_idx; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX sample_lastupdated_idx ON sample USING btree (lastupdated);


--
-- Name: sample_projects_pk; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE UNIQUE INDEX sample_projects_pk ON sample_projects USING btree (id);


--
-- Name: sampledom_dom_uk_uk; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE UNIQUE INDEX sampledom_dom_uk_uk ON sample_domain USING btree (domain);


--
-- Name: sci_name_comm_anim_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX sci_name_comm_anim_fk_i ON animal_scientific_name USING btree (comm_anim_id);


--
-- Name: source_dom_desc_uk_uk; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE UNIQUE INDEX source_dom_desc_uk_uk ON source_of_sample USING btree (description, domain);


--
-- Name: sp_proj_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX sp_proj_fk_i ON sample_projects USING btree (proj_id);


--
-- Name: sp_samp_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX sp_samp_fk_i ON sample_projects USING btree (samp_id);


--
-- Name: storloc_parent_storloc_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX storloc_parent_storloc_fk_i ON storage_location USING btree (parent_storageloc_id);


--
-- Name: storloc_storunit_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX storloc_storunit_fk_i ON storage_location USING btree (storage_unit_id);


--
-- Name: sysrolemodule_sysmodule_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX sysrolemodule_sysmodule_fk_i ON system_role_module USING btree (system_module_id);


--
-- Name: sysrolemodule_sysuser_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX sysrolemodule_sysuser_fk_i ON system_role_module USING btree (system_role_id);


--
-- Name: sysusermodule_sysmodule_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX sysusermodule_sysmodule_fk_i ON system_user_module USING btree (system_module_id);


--
-- Name: sysusermodule_sysuser_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX sysusermodule_sysuser_fk_i ON system_user_module USING btree (system_user_id);


--
-- Name: sysusersect_sysuser_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX sysusersect_sysuser_fk_i ON system_user_section USING btree (system_user_id);


--
-- Name: sysusersect_testsect_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX sysusersect_testsect_fk_i ON system_user_section USING btree (test_section_id);


--
-- Name: test_desc_uk; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE UNIQUE INDEX test_desc_uk ON test USING btree (description);


--
-- Name: test_label_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX test_label_fk_i ON test USING btree (label_id);


--
-- Name: test_method_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX test_method_fk_i ON test USING btree (method_id);


--
-- Name: test_reflx_tst_rslt_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX test_reflx_tst_rslt_fk_i ON test_reflex USING btree (tst_rslt_id);


--
-- Name: test_scriptlet_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX test_scriptlet_fk_i ON test USING btree (scriptlet_id);


--
-- Name: test_sect_org_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX test_sect_org_fk_i ON test_section USING btree (org_id);


--
-- Name: test_testformat_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX test_testformat_fk_i ON test USING btree (test_format_id);


--
-- Name: test_testsect_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX test_testsect_fk_i ON test USING btree (test_section_id);


--
-- Name: test_testtrailer_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX test_testtrailer_fk_i ON test USING btree (test_trailer_id);


--
-- Name: test_uom_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX test_uom_fk_i ON test USING btree (uom_id);


--
-- Name: testalyt_analyte_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX testalyt_analyte_fk_i ON test_analyte USING btree (analyte_id);


--
-- Name: testalyt_test_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX testalyt_test_fk_i ON test_analyte USING btree (test_id);


--
-- Name: testreflex_addtest_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX testreflex_addtest_fk_i ON test_reflex USING btree (add_test_id);


--
-- Name: testreflex_test_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX testreflex_test_fk_i ON test_reflex USING btree (test_id);


--
-- Name: testreflex_testanalyt_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX testreflex_testanalyt_fk_i ON test_reflex USING btree (test_analyte_id);


--
-- Name: testresult_scriptlet_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX testresult_scriptlet_fk_i ON test_result USING btree (scriptlet_id);


--
-- Name: tst_rslt_test_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX tst_rslt_test_fk_i ON test_result USING btree (test_id);


--
-- Name: tw_test_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX tw_test_fk_i ON test_worksheets USING btree (test_id);


--
-- Name: twi_qc_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX twi_qc_fk_i ON test_worksheet_item USING btree (qc_id);


--
-- Name: twi_tw_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX twi_tw_fk_i ON test_worksheet_item USING btree (tw_id);


--
-- Name: typeosamp_dom_desc_uk_uk; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE UNIQUE INDEX typeosamp_dom_desc_uk_uk ON type_of_sample USING btree (description, domain);


--
-- Name: typofprov_desc_uk_uk; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE UNIQUE INDEX typofprov_desc_uk_uk ON type_of_provider USING btree (description);


--
-- Name: wkshtanalysis_wkshtitem_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX wkshtanalysis_wkshtitem_fk_i ON worksheet_analysis USING btree (worksheet_item_id);


--
-- Name: wkshtanalyte_result_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX wkshtanalyte_result_fk_i ON worksheet_analyte USING btree (result_id);


--
-- Name: wkshtitem_wksht_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX wkshtitem_wksht_fk_i ON worksheet_item USING btree (worksheet_id);


--
-- Name: wkshtqc_qcanalyte_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX wkshtqc_qcanalyte_fk_i ON worksheet_qc USING btree (qc_analyte_id);


--
-- Name: wkshtqc_wkshtanalysis_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX wkshtqc_wkshtanalysis_fk_i ON worksheet_qc USING btree (worksheet_analysis_id);


--
-- Name: workst_sys_user_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX workst_sys_user_fk_i ON worksheets USING btree (sys_user_id);


--
-- Name: workst_test_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX workst_test_fk_i ON worksheets USING btree (test_id);


--
-- Name: wrkst_anlt_wrkst_anls_fk_i; Type: INDEX; Schema: clinlims; Owner: clinlims; Tablespace: 
--

CREATE INDEX wrkst_anlt_wrkst_anls_fk_i ON worksheet_analyte USING btree (wrkst_anls_id);


--
-- Name: ad_afield_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY aux_data
    ADD CONSTRAINT ad_afield_fk FOREIGN KEY (aux_field_id) REFERENCES aux_field(id) MATCH FULL;


--
-- Name: af_analyte_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY aux_field
    ADD CONSTRAINT af_analyte_fk FOREIGN KEY (analyte_id) REFERENCES analyte(id) MATCH FULL;


--
-- Name: af_script_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY aux_field
    ADD CONSTRAINT af_script_fk FOREIGN KEY (scriptlet_id) REFERENCES scriptlet(id) MATCH FULL;


--
-- Name: afv_afield_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY aux_field_values
    ADD CONSTRAINT afv_afield_fk FOREIGN KEY (aux_field_id) REFERENCES aux_field(id) MATCH FULL;


--
-- Name: analysis_panel_FK; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analysis
    ADD CONSTRAINT "analysis_panel_FK" FOREIGN KEY (panel_id) REFERENCES panel(id) ON DELETE SET NULL;


--
-- Name: analysis_parent_analysis_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analysis
    ADD CONSTRAINT analysis_parent_analysis_fk FOREIGN KEY (parent_analysis_id) REFERENCES analysis(id) MATCH FULL;


--
-- Name: analysis_parent_result_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analysis
    ADD CONSTRAINT analysis_parent_result_fk FOREIGN KEY (parent_result_id) REFERENCES result(id) MATCH FULL;


--
-- Name: analysis_sampitem_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analysis
    ADD CONSTRAINT analysis_sampitem_fk FOREIGN KEY (sampitem_id) REFERENCES sample_item(id) MATCH FULL;


--
-- Name: analysis_status_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analysis
    ADD CONSTRAINT analysis_status_fk FOREIGN KEY (status_id) REFERENCES status_of_sample(id);


--
-- Name: analysis_test_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analysis
    ADD CONSTRAINT analysis_test_fk FOREIGN KEY (test_id) REFERENCES test(id) MATCH FULL;


--
-- Name: analysis_test_sect_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analysis
    ADD CONSTRAINT analysis_test_sect_fk FOREIGN KEY (test_sect_id) REFERENCES test_section(id) MATCH FULL;


--
-- Name: analyte_analyte_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analyte
    ADD CONSTRAINT analyte_analyte_fk FOREIGN KEY (analyte_id) REFERENCES analyte(id) MATCH FULL;


--
-- Name: analyzer_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analyzer_results
    ADD CONSTRAINT analyzer_fk FOREIGN KEY (analyzer_id) REFERENCES analyzer(id);


--
-- Name: analyzer_results_test_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analyzer_results
    ADD CONSTRAINT analyzer_results_test_fk FOREIGN KEY (test_id) REFERENCES test(id);


--
-- Name: analyzer_test_map_analyzer_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analyzer_test_map
    ADD CONSTRAINT analyzer_test_map_analyzer_fk FOREIGN KEY (analyzer_id) REFERENCES analyzer(id);


--
-- Name: analyzer_test_map_test_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analyzer_test_map
    ADD CONSTRAINT analyzer_test_map_test_fk FOREIGN KEY (test_id) REFERENCES test(id);


--
-- Name: ani_samp_comm_anim_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_animal
    ADD CONSTRAINT ani_samp_comm_anim_fk FOREIGN KEY (comm_anim_id) REFERENCES animal_common_name(id) MATCH FULL;


--
-- Name: ani_samp_samp_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_animal
    ADD CONSTRAINT ani_samp_samp_fk FOREIGN KEY (samp_id) REFERENCES sample(id) MATCH FULL;


--
-- Name: ani_samp_sci_name_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_animal
    ADD CONSTRAINT ani_samp_sci_name_fk FOREIGN KEY (sci_name_id) REFERENCES animal_scientific_name(id) MATCH FULL;


--
-- Name: anqaev_anal_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analysis_qaevent
    ADD CONSTRAINT anqaev_anal_fk FOREIGN KEY (analysis_id) REFERENCES analysis(id) MATCH FULL;


--
-- Name: anqaev_qa_event_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analysis_qaevent
    ADD CONSTRAINT anqaev_qa_event_fk FOREIGN KEY (qa_event_id) REFERENCES qa_event(id) MATCH FULL;


--
-- Name: anst_anal_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analysis_storages
    ADD CONSTRAINT anst_anal_fk FOREIGN KEY (analysis_id) REFERENCES analysis(id) MATCH FULL;


--
-- Name: anstore_storage_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analysis_storages
    ADD CONSTRAINT anstore_storage_fk FOREIGN KEY (storage_id) REFERENCES storage_location(id) MATCH FULL;


--
-- Name: anus_anal_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analysis_users
    ADD CONSTRAINT anus_anal_fk FOREIGN KEY (analysis_id) REFERENCES analysis(id) MATCH FULL;


--
-- Name: anus_sysuser_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analysis_users
    ADD CONSTRAINT anus_sysuser_fk FOREIGN KEY (system_user_id) REFERENCES system_user(id) MATCH FULL;


--
-- Name: attachmtitem_attachmt_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY attachment_item
    ADD CONSTRAINT attachmtitem_attachmt_fk FOREIGN KEY (attachment_id) REFERENCES attachment(id) MATCH FULL;


--
-- Name: cd_elmt_xref_cd_elmt_type_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY code_element_xref
    ADD CONSTRAINT cd_elmt_xref_cd_elmt_type_fk FOREIGN KEY (code_element_type_id) REFERENCES code_element_type(id) MATCH FULL;


--
-- Name: cd_elmt_xref_message_org_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY code_element_xref
    ADD CONSTRAINT cd_elmt_xref_message_org_fk FOREIGN KEY (message_org_id) REFERENCES message_org(id) MATCH FULL;


--
-- Name: cd_elmt_xref_rcvr_cd_elmt_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY code_element_xref
    ADD CONSTRAINT cd_elmt_xref_rcvr_cd_elmt_fk FOREIGN KEY (receiver_code_element_id) REFERENCES receiver_code_element(id) MATCH FULL;


--
-- Name: demographics_history_type_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY observation_history
    ADD CONSTRAINT demographics_history_type_fk FOREIGN KEY (observation_history_type_id) REFERENCES observation_history_type(id);


--
-- Name: dictionary_dict_cat_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY dictionary
    ADD CONSTRAINT dictionary_dict_cat_fk FOREIGN KEY (dictionary_category_id) REFERENCES dictionary_category(id) MATCH FULL;


--
-- Name: env_samp_samp_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_environmental
    ADD CONSTRAINT env_samp_samp_fk FOREIGN KEY (samp_id) REFERENCES sample(id) MATCH FULL;


--
-- Name: fk_doc_parent_id; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY document_track
    ADD CONSTRAINT fk_doc_parent_id FOREIGN KEY (parent_id) REFERENCES document_track(id);


--
-- Name: fk_doc_type; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY document_track
    ADD CONSTRAINT fk_doc_type FOREIGN KEY (document_type_id) REFERENCES document_type(id);


--
-- Name: fk_sample_sample_source; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT fk_sample_sample_source FOREIGN KEY (sample_source_id) REFERENCES sample_source(id) ON UPDATE RESTRICT;


--
-- Name: fk_sibling_reflex; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_reflex
    ADD CONSTRAINT fk_sibling_reflex FOREIGN KEY (sibling_reflex) REFERENCES test_reflex(id) ON DELETE CASCADE;


--
-- Name: fk_table_id; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY document_track
    ADD CONSTRAINT fk_table_id FOREIGN KEY (table_id) REFERENCES reference_tables(id);


--
-- Name: history_sysuer_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY history
    ADD CONSTRAINT history_sysuer_fk FOREIGN KEY (sys_user_id) REFERENCES system_user(id) MATCH FULL;


--
-- Name: ia_analyte_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY instrument_analyte
    ADD CONSTRAINT ia_analyte_fk FOREIGN KEY (analyte_id) REFERENCES analyte(id) MATCH FULL;


--
-- Name: ia_instru_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY instrument_analyte
    ADD CONSTRAINT ia_instru_fk FOREIGN KEY (instru_id) REFERENCES instrument(id) MATCH FULL;


--
-- Name: ia_method_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY instrument_analyte
    ADD CONSTRAINT ia_method_fk FOREIGN KEY (method_id) REFERENCES method(id) MATCH FULL;


--
-- Name: identity_type_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY patient_identity
    ADD CONSTRAINT identity_type_fk FOREIGN KEY (identity_type_id) REFERENCES patient_identity_type(id);


--
-- Name: il_instru_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY instrument_log
    ADD CONSTRAINT il_instru_fk FOREIGN KEY (instru_id) REFERENCES instrument(id) MATCH FULL;


--
-- Name: il_inv_item_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY inventory_location
    ADD CONSTRAINT il_inv_item_fk FOREIGN KEY (inv_item_id) REFERENCES inventory_item(id) MATCH FULL;


--
-- Name: inv_recpt_invitem_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY inventory_receipt
    ADD CONSTRAINT inv_recpt_invitem_fk FOREIGN KEY (invitem_id) REFERENCES inventory_item(id) MATCH FULL;


--
-- Name: invcomp_invitem_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY inventory_component
    ADD CONSTRAINT invcomp_invitem_fk FOREIGN KEY (invitem_id) REFERENCES inventory_item(id) MATCH FULL;


--
-- Name: invcomp_matcomp_fk_iii; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY inventory_component
    ADD CONSTRAINT invcomp_matcomp_fk_iii FOREIGN KEY (material_component_id) REFERENCES inventory_item(id) MATCH FULL;


--
-- Name: inventory__location_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY result_inventory
    ADD CONSTRAINT inventory__location_fk FOREIGN KEY (inventory_location_id) REFERENCES inventory_location(id);


--
-- Name: invitem_uom_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY inventory_item
    ADD CONSTRAINT invitem_uom_fk FOREIGN KEY (uom_id) REFERENCES unit_of_measure(id) MATCH FULL;


--
-- Name: invloc_storage_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY inventory_location
    ADD CONSTRAINT invloc_storage_fk FOREIGN KEY (storage_id) REFERENCES storage_location(id) MATCH FULL;


--
-- Name: invrec_org_fk_iii; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY inventory_receipt
    ADD CONSTRAINT invrec_org_fk_iii FOREIGN KEY (org_id) REFERENCES organization(id) MATCH FULL;


--
-- Name: lab_order_item_table_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY lab_order_item
    ADD CONSTRAINT lab_order_item_table_fk FOREIGN KEY (table_ref) REFERENCES reference_tables(id);


--
-- Name: lab_order_item_type_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY lab_order_item
    ADD CONSTRAINT lab_order_item_type_fk FOREIGN KEY (lab_order_type_id) REFERENCES lab_order_type(id);


--
-- Name: label_script_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY label
    ADD CONSTRAINT label_script_fk FOREIGN KEY (scriptlet_id) REFERENCES scriptlet(id) MATCH FULL;


--
-- Name: ma_analyte_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY method_analyte
    ADD CONSTRAINT ma_analyte_fk FOREIGN KEY (analyte_id) REFERENCES analyte(id) MATCH FULL;


--
-- Name: ma_method_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY method_analyte
    ADD CONSTRAINT ma_method_fk FOREIGN KEY (method_id) REFERENCES method(id) MATCH FULL;


--
-- Name: menu_parent_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY menu
    ADD CONSTRAINT menu_parent_fk FOREIGN KEY (parent_id) REFERENCES menu(id);


--
-- Name: methres_method_fk_ii; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY method_result
    ADD CONSTRAINT methres_method_fk_ii FOREIGN KEY (method_id) REFERENCES method(id) MATCH FULL;


--
-- Name: methres_scrip_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY method_result
    ADD CONSTRAINT methres_scrip_fk FOREIGN KEY (scrip_id) REFERENCES scriptlet(id) MATCH FULL;


--
-- Name: mls_lab_tp_org_mlt_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY mls_lab_type
    ADD CONSTRAINT mls_lab_tp_org_mlt_fk FOREIGN KEY (org_mlt_org_mlt_id) REFERENCES org_mls_lab_type(org_mlt_id) MATCH FULL;


--
-- Name: note_sys_user_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY note
    ADD CONSTRAINT note_sys_user_fk FOREIGN KEY (sys_user_id) REFERENCES system_user(id) MATCH FULL;


--
-- Name: ord_org_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT ord_org_fk FOREIGN KEY (org_id) REFERENCES organization(id) MATCH FULL;


--
-- Name: ord_sys_user_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY orders
    ADD CONSTRAINT ord_sys_user_fk FOREIGN KEY (sys_user_id) REFERENCES system_user(id) MATCH FULL;


--
-- Name: orditem_inv_loc_fk_ii; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT orditem_inv_loc_fk_ii FOREIGN KEY (inv_loc_id) REFERENCES inventory_location(id) MATCH FULL;


--
-- Name: orditem_ord_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY order_item
    ADD CONSTRAINT orditem_ord_fk FOREIGN KEY (ord_id) REFERENCES orders(id) MATCH FULL;


--
-- Name: org_contact_org_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY organization_contact
    ADD CONSTRAINT org_contact_org_fk FOREIGN KEY (organization_id) REFERENCES organization(id);


--
-- Name: org_contact_person_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY organization_contact
    ADD CONSTRAINT org_contact_person_fk FOREIGN KEY (person_id) REFERENCES person(id);


--
-- Name: org_hl7_encoding_id_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY org_hl7_encoding_type
    ADD CONSTRAINT org_hl7_encoding_id_fk FOREIGN KEY (encoding_type_id) REFERENCES test_code_type(id);


--
-- Name: org_hl7_org_id_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY org_hl7_encoding_type
    ADD CONSTRAINT org_hl7_org_id_fk FOREIGN KEY (organization_id) REFERENCES organization(id);


--
-- Name: org_org_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY organization
    ADD CONSTRAINT org_org_fk FOREIGN KEY (org_id) REFERENCES organization(id) MATCH FULL;


--
-- Name: org_org_mlt_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY organization
    ADD CONSTRAINT org_org_mlt_fk FOREIGN KEY (org_mlt_org_mlt_id) REFERENCES org_mls_lab_type(org_mlt_id) MATCH FULL;


--
-- Name: organization_address_address_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY organization_address
    ADD CONSTRAINT organization_address_address_fk FOREIGN KEY (address_part_id) REFERENCES address_part(id);


--
-- Name: organization_address_organization_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY organization_address
    ADD CONSTRAINT organization_address_organization_fk FOREIGN KEY (organization_id) REFERENCES organization(id);


--
-- Name: organization_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY project_organization
    ADD CONSTRAINT organization_fk FOREIGN KEY (org_id) REFERENCES organization(id);


--
-- Name: organization_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY organization_organization_type
    ADD CONSTRAINT organization_fk FOREIGN KEY (org_id) REFERENCES organization(id) ON DELETE CASCADE;


--
-- Name: organization_type_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY organization_organization_type
    ADD CONSTRAINT organization_type_fk FOREIGN KEY (org_type_id) REFERENCES organization_type(id);


--
-- Name: pan_it_panel_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY panel_item
    ADD CONSTRAINT pan_it_panel_fk FOREIGN KEY (panel_id) REFERENCES panel(id) MATCH FULL;


--
-- Name: parent_test_sec_test_sect_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_section
    ADD CONSTRAINT parent_test_sec_test_sect_fk FOREIGN KEY (parent_test_section) REFERENCES test_section(id) MATCH FULL;


--
-- Name: pat_id_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY patient_occupation
    ADD CONSTRAINT pat_id_fk FOREIGN KEY (patient_id) REFERENCES patient(id);


--
-- Name: pat_person_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY patient
    ADD CONSTRAINT pat_person_fk FOREIGN KEY (person_id) REFERENCES person(id) MATCH FULL;


--
-- Name: patient_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY patient_identity
    ADD CONSTRAINT patient_fk FOREIGN KEY (patient_id) REFERENCES patient(id);


--
-- Name: patient_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY patient_patient_type
    ADD CONSTRAINT patient_fk FOREIGN KEY (patient_id) REFERENCES patient(id);


--
-- Name: patient_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY observation_history
    ADD CONSTRAINT patient_fk FOREIGN KEY (patient_id) REFERENCES patient(id);


--
-- Name: patient_type_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY patient_patient_type
    ADD CONSTRAINT patient_type_fk FOREIGN KEY (patient_type_id) REFERENCES patient_type(id);


--
-- Name: person_address_address_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT person_address_address_fk FOREIGN KEY (address_part_id) REFERENCES address_part(id);


--
-- Name: person_address_person_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY person_address
    ADD CONSTRAINT person_address_person_fk FOREIGN KEY (person_id) REFERENCES person(id);


--
-- Name: pr_pat_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY patient_relations
    ADD CONSTRAINT pr_pat_fk FOREIGN KEY (pat_id) REFERENCES patient(id) MATCH FULL;


--
-- Name: pr_pat_source_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY patient_relations
    ADD CONSTRAINT pr_pat_source_fk FOREIGN KEY (pat_id_source) REFERENCES patient(id) MATCH FULL;


--
-- Name: project_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY project_organization
    ADD CONSTRAINT project_fk FOREIGN KEY (project_id) REFERENCES project(id);


--
-- Name: project_script_fk_ii; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_script_fk_ii FOREIGN KEY (scriptlet_id) REFERENCES scriptlet(id) MATCH FULL;


--
-- Name: project_sysuer_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY project
    ADD CONSTRAINT project_sysuer_fk FOREIGN KEY (sys_user_id) REFERENCES system_user(id) MATCH FULL;


--
-- Name: projectparam_proj_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY project_parameter
    ADD CONSTRAINT projectparam_proj_fk FOREIGN KEY (project_id) REFERENCES project(id) MATCH FULL;


--
-- Name: prov_person_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY provider
    ADD CONSTRAINT prov_person_fk FOREIGN KEY (person_id) REFERENCES person(id) MATCH FULL;


--
-- Name: qa_observation_type_k; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY qa_observation
    ADD CONSTRAINT qa_observation_type_k FOREIGN KEY (qa_observation_type_id) REFERENCES qa_observation_type(id);


--
-- Name: qaev_test_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY qa_event
    ADD CONSTRAINT qaev_test_fk FOREIGN KEY (test_id) REFERENCES test(id) MATCH FULL;


--
-- Name: qc_sys_user_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY qc
    ADD CONSTRAINT qc_sys_user_fk FOREIGN KEY (sys_user_id) REFERENCES system_user(id) MATCH FULL;


--
-- Name: qc_uom_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY qc
    ADD CONSTRAINT qc_uom_fk FOREIGN KEY (uom_id) REFERENCES unit_of_measure(id) MATCH FULL;


--
-- Name: qcanlyt_analyte_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY qc_analytes
    ADD CONSTRAINT qcanlyt_analyte_fk FOREIGN KEY (analyte_id) REFERENCES analyte(id) MATCH FULL;


--
-- Name: qrtz_blob_triggers_trigger_name_fkey; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY qrtz_blob_triggers
    ADD CONSTRAINT qrtz_blob_triggers_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES qrtz_triggers(trigger_name, trigger_group);


--
-- Name: qrtz_cron_triggers_trigger_name_fkey; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY qrtz_cron_triggers
    ADD CONSTRAINT qrtz_cron_triggers_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES qrtz_triggers(trigger_name, trigger_group);


--
-- Name: qrtz_job_listeners_job_name_fkey; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY qrtz_job_listeners
    ADD CONSTRAINT qrtz_job_listeners_job_name_fkey FOREIGN KEY (job_name, job_group) REFERENCES qrtz_job_details(job_name, job_group);


--
-- Name: qrtz_simple_triggers_trigger_name_fkey; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY qrtz_simple_triggers
    ADD CONSTRAINT qrtz_simple_triggers_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES qrtz_triggers(trigger_name, trigger_group);


--
-- Name: qrtz_trigger_listeners_trigger_name_fkey; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY qrtz_trigger_listeners
    ADD CONSTRAINT qrtz_trigger_listeners_trigger_name_fkey FOREIGN KEY (trigger_name, trigger_group) REFERENCES qrtz_triggers(trigger_name, trigger_group);


--
-- Name: qrtz_triggers_job_name_fkey; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY qrtz_triggers
    ADD CONSTRAINT qrtz_triggers_job_name_fkey FOREIGN KEY (job_name, job_group) REFERENCES qrtz_job_details(job_name, job_group);


--
-- Name: receiver_code_code_element_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY receiver_code_element
    ADD CONSTRAINT receiver_code_code_element_fk FOREIGN KEY (code_element_type_id) REFERENCES code_element_type(id) MATCH FULL;


--
-- Name: receiver_code_message_org_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY receiver_code_element
    ADD CONSTRAINT receiver_code_message_org_fk FOREIGN KEY (message_org_id) REFERENCES message_org(id) MATCH FULL;


--
-- Name: referral_analysis_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY referral
    ADD CONSTRAINT referral_analysis_fk FOREIGN KEY (analysis_id) REFERENCES analysis(id);


--
-- Name: referral_organization_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY referral
    ADD CONSTRAINT referral_organization_fk FOREIGN KEY (organization_id) REFERENCES organization(id) ON DELETE CASCADE;


--
-- Name: referral_reason_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY referral
    ADD CONSTRAINT referral_reason_fk FOREIGN KEY (referral_reason_id) REFERENCES referral_reason(id);


--
-- Name: referral_result_referral_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY referral_result
    ADD CONSTRAINT referral_result_referral_fk FOREIGN KEY (referral_id) REFERENCES referral(id) ON DELETE CASCADE;


--
-- Name: referral_result_result; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY referral_result
    ADD CONSTRAINT referral_result_result FOREIGN KEY (result_id) REFERENCES result(id);


--
-- Name: referral_result_test_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY referral_result
    ADD CONSTRAINT referral_result_test_fk FOREIGN KEY (test_id) REFERENCES test(id);


--
-- Name: referral_type_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY referral
    ADD CONSTRAINT referral_type_fk FOREIGN KEY (referral_type_id) REFERENCES referral_type(id);


--
-- Name: report_queue_type_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY report_external_export
    ADD CONSTRAINT report_queue_type_fk FOREIGN KEY (type) REFERENCES report_queue_type(id);


--
-- Name: requester_type_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_requester
    ADD CONSTRAINT requester_type_fk FOREIGN KEY (requester_type_id) REFERENCES requester_type(id);


--
-- Name: result_analysis_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY result
    ADD CONSTRAINT result_analysis_fk FOREIGN KEY (analysis_id) REFERENCES analysis(id) MATCH FULL;


--
-- Name: result_analyte_fk_ii; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY result
    ADD CONSTRAINT result_analyte_fk_ii FOREIGN KEY (analyte_id) REFERENCES analyte(id) MATCH FULL;


--
-- Name: result_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY result_inventory
    ADD CONSTRAINT result_fk FOREIGN KEY (result_id) REFERENCES result(id);


--
-- Name: result_id_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY result_signature
    ADD CONSTRAINT result_id_fk FOREIGN KEY (result_id) REFERENCES result(id);


--
-- Name: result_parent_id_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY result
    ADD CONSTRAINT result_parent_id_fk FOREIGN KEY (parent_id) REFERENCES result(id) ON DELETE CASCADE;


--
-- Name: result_testresult_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY result
    ADD CONSTRAINT result_testresult_fk FOREIGN KEY (test_result_id) REFERENCES test_result(id) MATCH FULL;


--
-- Name: role_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY system_user_role
    ADD CONSTRAINT role_fk FOREIGN KEY (role_id) REFERENCES system_role(id) ON DELETE CASCADE;


--
-- Name: role_parent_role_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY system_role
    ADD CONSTRAINT role_parent_role_fk FOREIGN KEY (grouping_parent) REFERENCES system_role(id);


--
-- Name: samp_org_org_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_organization
    ADD CONSTRAINT samp_org_org_fk FOREIGN KEY (org_id) REFERENCES organization(id) MATCH FULL;


--
-- Name: samp_org_samp_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_organization
    ADD CONSTRAINT samp_org_samp_fk FOREIGN KEY (samp_id) REFERENCES sample(id) MATCH FULL;


--
-- Name: samphuman_patient_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_human
    ADD CONSTRAINT samphuman_patient_fk FOREIGN KEY (patient_id) REFERENCES patient(id) MATCH FULL;


--
-- Name: samphuman_provider_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_human
    ADD CONSTRAINT samphuman_provider_fk FOREIGN KEY (provider_id) REFERENCES provider(id) MATCH FULL;


--
-- Name: samphuman_sample_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_human
    ADD CONSTRAINT samphuman_sample_fk FOREIGN KEY (samp_id) REFERENCES sample(id) MATCH FULL;


--
-- Name: sampitem_sampitem_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_item
    ADD CONSTRAINT sampitem_sampitem_fk FOREIGN KEY (sampitem_id) REFERENCES sample_item(id) MATCH FULL;


--
-- Name: sampitem_sample_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_item
    ADD CONSTRAINT sampitem_sample_fk FOREIGN KEY (samp_id) REFERENCES sample(id) MATCH FULL;


--
-- Name: sampitem_sourceosamp_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_item
    ADD CONSTRAINT sampitem_sourceosamp_fk FOREIGN KEY (source_id) REFERENCES source_of_sample(id) MATCH FULL;


--
-- Name: sampitem_typeosamp_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_item
    ADD CONSTRAINT sampitem_typeosamp_fk FOREIGN KEY (typeosamp_id) REFERENCES type_of_sample(id) MATCH FULL;


--
-- Name: sampitem_uom_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_item
    ADD CONSTRAINT sampitem_uom_fk FOREIGN KEY (uom_id) REFERENCES unit_of_measure(id) MATCH FULL;


--
-- Name: sample_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY observation_history
    ADD CONSTRAINT sample_fk FOREIGN KEY (sample_id) REFERENCES sample(id);


--
-- Name: sample_package_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_package_fk FOREIGN KEY (package_id) REFERENCES package_1(id) MATCH FULL;


--
-- Name: sample_qaevent_sampleitem_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_qaevent
    ADD CONSTRAINT sample_qaevent_sampleitem_fk FOREIGN KEY (sampleitem_id) REFERENCES sample_item(id);


--
-- Name: sample_status_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_status_fk FOREIGN KEY (status_id) REFERENCES status_of_sample(id);


--
-- Name: sample_sysuser_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample
    ADD CONSTRAINT sample_sysuser_fk FOREIGN KEY (sys_user_id) REFERENCES system_user(id) MATCH FULL;


--
-- Name: sampletype_panel_panel_id_fkey; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sampletype_panel
    ADD CONSTRAINT sampletype_panel_panel_id_fkey FOREIGN KEY (panel_id) REFERENCES panel(id);


--
-- Name: sampletype_panel_sample_type_id_fkey; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sampletype_panel
    ADD CONSTRAINT sampletype_panel_sample_type_id_fkey FOREIGN KEY (sample_type_id) REFERENCES type_of_sample(id);


--
-- Name: sampletype_test_sample_type_id_fkey; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sampletype_test
    ADD CONSTRAINT sampletype_test_sample_type_id_fkey FOREIGN KEY (sample_type_id) REFERENCES type_of_sample(id);


--
-- Name: sampletype_test_test_id_fkey; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sampletype_test
    ADD CONSTRAINT sampletype_test_test_id_fkey FOREIGN KEY (test_id) REFERENCES test(id);


--
-- Name: sampnewborn_sample_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_newborn
    ADD CONSTRAINT sampnewborn_sample_fk FOREIGN KEY (id) REFERENCES sample_human(id);


--
-- Name: sampproj_project_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_projects
    ADD CONSTRAINT sampproj_project_fk FOREIGN KEY (proj_id) REFERENCES project(id) MATCH FULL;


--
-- Name: sampproj_sample_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY sample_projects
    ADD CONSTRAINT sampproj_sample_fk FOREIGN KEY (samp_id) REFERENCES sample(id) MATCH FULL;


--
-- Name: sci_name_comm_anim_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY animal_scientific_name
    ADD CONSTRAINT sci_name_comm_anim_fk FOREIGN KEY (comm_anim_id) REFERENCES animal_common_name(id) MATCH FULL;


--
-- Name: status_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY analyzer_results
    ADD CONSTRAINT status_fk FOREIGN KEY (status_id) REFERENCES analyzer_result_status(id);


--
-- Name: storloc_parent_storloc_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY storage_location
    ADD CONSTRAINT storloc_parent_storloc_fk FOREIGN KEY (parent_storageloc_id) REFERENCES storage_location(id) MATCH FULL;


--
-- Name: storloc_storunit_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY storage_location
    ADD CONSTRAINT storloc_storunit_fk FOREIGN KEY (storage_unit_id) REFERENCES storage_unit(id) MATCH FULL;


--
-- Name: sysrolemodule_sysmodule_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY system_role_module
    ADD CONSTRAINT sysrolemodule_sysmodule_fk FOREIGN KEY (system_module_id) REFERENCES system_module(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: sysrolemodule_sysrole_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY system_role_module
    ADD CONSTRAINT sysrolemodule_sysrole_fk FOREIGN KEY (system_role_id) REFERENCES system_role(id) MATCH FULL ON DELETE CASCADE;


--
-- Name: system_user_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY system_user_role
    ADD CONSTRAINT system_user_fk FOREIGN KEY (system_user_id) REFERENCES system_user(id) ON DELETE CASCADE;


--
-- Name: system_user_id_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY result_signature
    ADD CONSTRAINT system_user_id_fk FOREIGN KEY (system_user_id) REFERENCES system_user(id);


--
-- Name: sysusermodule_sysmodule_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY system_user_module
    ADD CONSTRAINT sysusermodule_sysmodule_fk FOREIGN KEY (system_module_id) REFERENCES system_module(id) MATCH FULL;


--
-- Name: sysusermodule_sysuser_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY system_user_module
    ADD CONSTRAINT sysusermodule_sysuser_fk FOREIGN KEY (system_user_id) REFERENCES system_user(id) MATCH FULL;


--
-- Name: sysusersect_sysuser_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY system_user_section
    ADD CONSTRAINT sysusersect_sysuser_fk FOREIGN KEY (system_user_id) REFERENCES system_user(id) MATCH FULL;


--
-- Name: sysusersect_testsect_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY system_user_section
    ADD CONSTRAINT sysusersect_testsect_fk FOREIGN KEY (test_section_id) REFERENCES test_section(id) MATCH FULL;


--
-- Name: test_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY result_limits
    ADD CONSTRAINT test_fk FOREIGN KEY (test_id) REFERENCES test(id);


--
-- Name: test_hl7_encoding_id_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_code
    ADD CONSTRAINT test_hl7_encoding_id_fk FOREIGN KEY (code_type_id) REFERENCES test_code_type(id);


--
-- Name: test_hl7_test_id_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_code
    ADD CONSTRAINT test_hl7_test_id_fk FOREIGN KEY (test_id) REFERENCES test(id);


--
-- Name: test_label_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test
    ADD CONSTRAINT test_label_fk FOREIGN KEY (label_id) REFERENCES label(id) MATCH FULL;


--
-- Name: test_method_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test
    ADD CONSTRAINT test_method_fk FOREIGN KEY (method_id) REFERENCES method(id) MATCH FULL;


--
-- Name: test_reflex_scriptlet_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_reflex
    ADD CONSTRAINT test_reflex_scriptlet_fk FOREIGN KEY (scriptlet_id) REFERENCES scriptlet(id);


--
-- Name: test_result_type_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY result_limits
    ADD CONSTRAINT test_result_type_fk FOREIGN KEY (test_result_type_id) REFERENCES type_of_test_result(id);


--
-- Name: test_scriptlet_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test
    ADD CONSTRAINT test_scriptlet_fk FOREIGN KEY (scriptlet_id) REFERENCES scriptlet(id) MATCH FULL;


--
-- Name: test_sect_org_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_section
    ADD CONSTRAINT test_sect_org_fk FOREIGN KEY (org_id) REFERENCES organization(id) MATCH FULL;


--
-- Name: test_testformat_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test
    ADD CONSTRAINT test_testformat_fk FOREIGN KEY (test_format_id) REFERENCES test_formats(id) MATCH FULL;


--
-- Name: test_testsect_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test
    ADD CONSTRAINT test_testsect_fk FOREIGN KEY (test_section_id) REFERENCES test_section(id) MATCH FULL;


--
-- Name: test_testtrailer_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test
    ADD CONSTRAINT test_testtrailer_fk FOREIGN KEY (test_trailer_id) REFERENCES test_trailer(id) MATCH FULL;


--
-- Name: test_uom_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test
    ADD CONSTRAINT test_uom_fk FOREIGN KEY (uom_id) REFERENCES unit_of_measure(id) MATCH FULL;


--
-- Name: testalyt_analyte_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_analyte
    ADD CONSTRAINT testalyt_analyte_fk FOREIGN KEY (analyte_id) REFERENCES analyte(id) MATCH FULL;


--
-- Name: testalyt_test_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_analyte
    ADD CONSTRAINT testalyt_test_fk FOREIGN KEY (test_id) REFERENCES test(id) MATCH FULL;


--
-- Name: testreflex_addtest_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_reflex
    ADD CONSTRAINT testreflex_addtest_fk FOREIGN KEY (add_test_id) REFERENCES test(id) MATCH FULL;


--
-- Name: testreflex_test_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_reflex
    ADD CONSTRAINT testreflex_test_fk FOREIGN KEY (test_id) REFERENCES test(id) MATCH FULL;


--
-- Name: testreflex_testanalyt_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_reflex
    ADD CONSTRAINT testreflex_testanalyt_fk FOREIGN KEY (test_analyte_id) REFERENCES test_analyte(id) MATCH FULL;


--
-- Name: testreflex_tstrslt_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_reflex
    ADD CONSTRAINT testreflex_tstrslt_fk FOREIGN KEY (tst_rslt_id) REFERENCES test_result(id) MATCH FULL;


--
-- Name: testresult_scriptlet_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_result
    ADD CONSTRAINT testresult_scriptlet_fk FOREIGN KEY (scriptlet_id) REFERENCES scriptlet(id) MATCH FULL;


--
-- Name: testresult_test_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_result
    ADD CONSTRAINT testresult_test_fk FOREIGN KEY (test_id) REFERENCES test(id) MATCH FULL;


--
-- Name: tw_test_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_worksheets
    ADD CONSTRAINT tw_test_fk FOREIGN KEY (test_id) REFERENCES test(id) MATCH FULL;


--
-- Name: twi_qc_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_worksheet_item
    ADD CONSTRAINT twi_qc_fk FOREIGN KEY (qc_id) REFERENCES qc(id) MATCH FULL;


--
-- Name: twi_tw_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY test_worksheet_item
    ADD CONSTRAINT twi_tw_fk FOREIGN KEY (tw_id) REFERENCES test_worksheets(id) MATCH FULL;


--
-- Name: wkshtanalysis_wkshtitem_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY worksheet_analysis
    ADD CONSTRAINT wkshtanalysis_wkshtitem_fk FOREIGN KEY (worksheet_item_id) REFERENCES worksheet_item(id) MATCH FULL;


--
-- Name: wkshtanalyte_result_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY worksheet_analyte
    ADD CONSTRAINT wkshtanalyte_result_fk FOREIGN KEY (result_id) REFERENCES result(id) MATCH FULL;


--
-- Name: wkshtitem_wksht_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY worksheet_item
    ADD CONSTRAINT wkshtitem_wksht_fk FOREIGN KEY (worksheet_id) REFERENCES worksheets(id) MATCH FULL;


--
-- Name: wkshtqc_qcanalyte_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY worksheet_qc
    ADD CONSTRAINT wkshtqc_qcanalyte_fk FOREIGN KEY (qc_analyte_id) REFERENCES qc_analytes(id) MATCH FULL;


--
-- Name: wkshtqc_wkshtanalysis_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY worksheet_qc
    ADD CONSTRAINT wkshtqc_wkshtanalysis_fk FOREIGN KEY (worksheet_analysis_id) REFERENCES worksheet_analysis(id) MATCH FULL;


--
-- Name: workst_sys_user_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY worksheets
    ADD CONSTRAINT workst_sys_user_fk FOREIGN KEY (sys_user_id) REFERENCES system_user(id) MATCH FULL;


--
-- Name: workst_test_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY worksheets
    ADD CONSTRAINT workst_test_fk FOREIGN KEY (test_id) REFERENCES test(id) MATCH FULL;


--
-- Name: wrkst_anlt_wrkst_anls_fk; Type: FK CONSTRAINT; Schema: clinlims; Owner: clinlims
--

ALTER TABLE ONLY worksheet_analyte
    ADD CONSTRAINT wrkst_anlt_wrkst_anls_fk FOREIGN KEY (wrkst_anls_id) REFERENCES worksheet_analysis(id) MATCH FULL;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

