
define reportHeader="<font size=+3 color=darkgreen><b>Select Optimizer Statistics for CBO</b></font><hr>FCH)Eric.zhong (E-MAIL=>eric.zhong@cn.fujitsu.com PHONE=>18620888670)<p>"


set termout       off
set echo          off
set feedback      off
set verify        off
set heading       on
set wrap          on
set trimspool     on
set serveroutput  on
set escape        on
set pagesize 50000
set long     2000000000
set numw 16
col error format a30
alter session set nls_date_format='yyyy-mm-dd hh24:mi:ss';
set markup html on spool on preformat off entmap on -
head ' -
  <title>Select Optimizer Statistics for CBO</title> -
  <style type="text/css"> -
    body              {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} -
    p                 {font:10pt Arial,Helvetica,sans-serif; color:black; background:White;} -
    table,tr,td       {font:10pt Arial,Helvetica,sans-serif; color:Black; background:#FFFFCC; padding:0px 0px 0px 0px; margin:0px 0px 0px 0px;border-collapse:collapse;border:1px solid #000;} -
    th                {font:bold 10pt Arial,Helvetica,sans-serif; color:White; background:#0066cc; padding:0px 0px 0px 0px;} -
    h1                {font:bold 12pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:#0066cc; border-bottom:1px solid #cccc99; margin-top:0pt; margin-bottom:0pt; padding:0px 0px 0px 0px;} -
    h2                {font:bold 10pt Arial,Helvetica,Geneva,sans-serif; color:#336699; background-color:White; margin-top:4pt; margin-bottom:0pt;} -
	  a                 {font:10pt Arial,Helvetica,sans-serif; color:#663300; margin-top:0pt; margin-bottom:0pt; vertical-align:top;} -
  </style>' -
body   'BGCOLOR="#C0C0C0"' -
table  'WIDTH="98%" BORDER="1"' 

column uservar new_value Table_Owner noprint
select user uservar from dual;


undefine table_name
undefine owner
prompt

define owner="&1"
define table_name="&2"

define fileName=TableAndIndex_Info
COLUMN spool_time NEW_VALUE _spool_time NOPRINT
SELECT TO_CHAR(SYSDATE,'YYYYMMDD') spool_time FROM dual;

spool &FileName._&table_name._&_spool_time..html
set markup html on entmap off
prompt &reportHeader

SET MARKUP HTML ON


column TABLE_NAME heading "Table|Name" format a15
column PARTITION_NAME heading "Partition|Name" format a15
column SUBPARTITION_NAME heading "SubPartition|Name" format a15
column NUM_ROWS heading "Number|of Rows" format 9,999,999,990
column BLOCKS heading "Blocks" format 999,990
column EMPTY_BLOCKS heading "Empty|Blocks" format 999,999,990

column AVG_SPACE heading "Average|Space" format 9,990
column CHAIN_CNT heading "Chain|Count" format 999,990
column AVG_ROW_LEN heading "Average|Row Len" format 9,990
column COLUMN_NAME  heading "Column|Name" format a25
column NULLABLE heading Null|able format a4
column NUM_DISTINCT heading "Distinct|Values" format 999,999,990
column NUM_NULLS heading "Number|Nulls" format 9,999,990
column NUM_BUCKETS heading "Number|Buckets" format 99,990
column HISTOGRAM heading "Histogram" format a16
column DENSITY heading "Density" format 90.99999
column INDEX_NAME heading "Index|Name" format a20
column UNIQUENESS heading "Unique" format a9
column BLEV heading "B-Tree|Level" format 90
column LEAF_BLOCKS heading "Leaf|Blks" format 9900
column DISTINCT_KEYS heading "Distinct|Keys" format 9,999,999,990
column AVG_LEAF_BLOCKS_PER_KEY heading "Average|Leaf Blocks|Per Key" format 99,990
column AVG_DATA_BLOCKS_PER_KEY heading "Average|Data Blocks|Per Key" format 99,990
column CLUSTERING_FACTOR heading "Cluster|Factor" format 999,999,990
column COLUMN_POSITION heading "Col|Pos" format 990
column col heading "Column|Details" format a30
column COLUMN_LENGTH heading "Col|Len" format 9,990
column GLOBAL_STATS heading "Global|Stats" format a6
column USER_STATS heading "User|Stats" format a6
column SAMPLE_SIZE heading "Sample|Size" format 9,999,999,990
column to_char(t.last_analyzed,'MM-DD-YYYY') heading "Date|MM-DD-YYYY" format a10
column COLUMN_EXPRESSION heading "Column|Name" format a35

prompt
prompt ***********
prompt Table Level
prompt ***********
prompt
select 
    TABLE_NAME,
    NUM_ROWS,
    BLOCKS,
    EMPTY_BLOCKS,
    AVG_SPACE,
    CHAIN_CNT,
    AVG_ROW_LEN,
    GLOBAL_STATS,
    USER_STATS,
    SAMPLE_SIZE,
    to_char(t.last_analyzed,'MM-DD-YYYY')
from dba_tables t
where 
    owner = upper(nvl('&&Owner',user))
and table_name = upper('&&Table_name')
/
select
    t.COLUMN_NAME,
    decode(t.DATA_TYPE,
           'NUMBER',t.DATA_TYPE||'('||
           decode(t.DATA_PRECISION,
                  null,t.DATA_LENGTH||')',
                  t.DATA_PRECISION||','||t.DATA_SCALE||')'),
                  'DATE',t.DATA_TYPE,
                  'LONG',t.DATA_TYPE,
                  'LONG RAW',t.DATA_TYPE,
                  'ROWID',t.DATA_TYPE,
                  'MLSLABEL',t.DATA_TYPE,
                  t.DATA_TYPE||'('||t.DATA_LENGTH||')') ||' '||
    decode(t.nullable,
              'N','NOT NULL',
              'n','NOT NULL',
              NULL) col,
    t.HISTOGRAM,
    t.NUM_DISTINCT,
    t.DENSITY,
    t.NUM_BUCKETS,
    t.NUM_NULLS,
    t.GLOBAL_STATS,
    t.USER_STATS,
    t.SAMPLE_SIZE,
    to_char(t.last_analyzed,'MM-DD-YYYY')
from dba_tab_columns t 
where 
	  t.table_name = upper('&&Table_name')
and t.owner = upper(nvl('&&Owner',user))
/


prompt
prompt ***********
prompt Index Level
prompt ***********
prompt
select 
    INDEX_NAME,
    UNIQUENESS,
    BLEVEL BLev,
    LEAF_BLOCKS,
    DISTINCT_KEYS,
    NUM_ROWS,
    AVG_LEAF_BLOCKS_PER_KEY,
    AVG_DATA_BLOCKS_PER_KEY,
    CLUSTERING_FACTOR,
    GLOBAL_STATS,
    USER_STATS,
    SAMPLE_SIZE,
    to_char(t.last_analyzed,'MM-DD-YYYY')
from 
    dba_indexes t
where 
    table_name = upper('&Table_name')
and table_owner = upper(nvl('&&Owner',user))
/


break on index_name
select
    i.INDEX_NAME,
    i.COLUMN_NAME,
    i.COLUMN_POSITION,
    decode(t.DATA_TYPE,
           'NUMBER',t.DATA_TYPE||'('||
           decode(t.DATA_PRECISION,
                  null,t.DATA_LENGTH||')',
                  t.DATA_PRECISION||','||t.DATA_SCALE||')'),
                  'DATE',t.DATA_TYPE,
                  'LONG',t.DATA_TYPE,
                  'LONG RAW',t.DATA_TYPE,
                  'ROWID',t.DATA_TYPE,
                  'MLSLABEL',t.DATA_TYPE,
                  t.DATA_TYPE||'('||t.DATA_LENGTH||')') ||' '||
           decode(t.nullable,
                  'N','NOT NULL',
                  'n','NOT NULL',
                  NULL) col
from 
    dba_ind_columns i,
    dba_tab_columns t
where 
    i.table_name = upper('&&Table_name')
and t.OWNER = upper(nvl('&&Owner',user))
and i.table_owner = t.owner
and i.table_name = t.table_name
and i.column_name = t.column_name
order by index_name,column_position
/


SELECT T.INDEX_NAME,
       T.COLUMN_EXPRESSION,
       T.COLUMN_POSITION
  FROM DBA_IND_EXPRESSIONS T
 WHERE T.TABLE_NAME = upper('&&Table_name');

prompt
prompt ***************
prompt Partition Level
prompt ***************

select
    PARTITION_NAME,
    NUM_ROWS,
    BLOCKS,
    EMPTY_BLOCKS,
    AVG_SPACE,
    CHAIN_CNT,
    AVG_ROW_LEN,
    GLOBAL_STATS,
    USER_STATS,
    SAMPLE_SIZE,
    to_char(t.last_analyzed,'MM-DD-YYYY')
from 
    dba_tab_partitions t
where 
    table_owner = upper(nvl('&&Owner',user))
and table_name = upper('&&Table_name')
order by partition_position
/


break on partition_name
select
    PARTITION_NAME,
    COLUMN_NAME,
    NUM_DISTINCT,
    DENSITY,
    NUM_BUCKETS,
    NUM_NULLS,
    GLOBAL_STATS,
    USER_STATS,
    SAMPLE_SIZE,
    to_char(t.last_analyzed,'MM-DD-YYYY')
from 
    dba_PART_COL_STATISTICS t
where 
    table_name = upper('&&Table_name')
and owner = upper(nvl('&&Owner',user))
/

break on partition_name
select 
    t.INDEX_NAME,
    t.PARTITION_NAME,
    t.BLEVEL BLev,
    t.LEAF_BLOCKS,
    t.DISTINCT_KEYS,
    t.NUM_ROWS,
    t.AVG_LEAF_BLOCKS_PER_KEY,
    t.AVG_DATA_BLOCKS_PER_KEY,
    t.CLUSTERING_FACTOR,
    t.GLOBAL_STATS,
    t.USER_STATS,
    t.SAMPLE_SIZE,
    to_char(t.last_analyzed,'MM-DD-YYYY')
from 
    dba_ind_partitions t, 
    dba_indexes i
where 
    i.table_name = upper('&&Table_name')
and i.table_owner = upper(nvl('&&Owner',user))
and i.owner = t.index_owner
and i.index_name=t.index_name
/


prompt
prompt ***************
prompt SubPartition Level
prompt ***************

select 
    PARTITION_NAME,
    SUBPARTITION_NAME,
    NUM_ROWS,
    BLOCKS,
    EMPTY_BLOCKS,
    AVG_SPACE,
    CHAIN_CNT,
    AVG_ROW_LEN,
    GLOBAL_STATS,
    USER_STATS,
    SAMPLE_SIZE,
    to_char(t.last_analyzed,'MM-DD-YYYY')
from 
    dba_tab_subpartitions t
where 
    table_owner = upper(nvl('&&Owner',user))
and table_name = upper('&&Table_name')
order by SUBPARTITION_POSITION
/
break on partition_name
select 
    p.PARTITION_NAME,
    t.SUBPARTITION_NAME,
    t.COLUMN_NAME,
    t.NUM_DISTINCT,
    t.DENSITY,
    t.NUM_BUCKETS,
    t.NUM_NULLS,
    t.GLOBAL_STATS,
    t.USER_STATS,
    t.SAMPLE_SIZE,
    to_char(t.last_analyzed,'MM-DD-YYYY')
from 
    dba_SUBPART_COL_STATISTICS t, 
    dba_tab_subpartitions p
where 
    t.table_name = upper('&&Table_name')
and t.owner = upper(nvl('&&Owner',user))
and t.subpartition_name = p.subpartition_name
and t.owner = p.table_owner
and t.table_name=p.table_name
/

break on partition_name
select 
    t.INDEX_NAME,
    t.PARTITION_NAME,
    t.SUBPARTITION_NAME,
    t.BLEVEL BLev,
    t.LEAF_BLOCKS,
    t.DISTINCT_KEYS,
    t.NUM_ROWS,
    t.AVG_LEAF_BLOCKS_PER_KEY,
    t.AVG_DATA_BLOCKS_PER_KEY,
    t.CLUSTERING_FACTOR,
    t.GLOBAL_STATS,
    t.USER_STATS,
    t.SAMPLE_SIZE,
    to_char(t.last_analyzed,'MM-DD-YYYY')
from 
    dba_ind_subpartitions t, 
    dba_indexes i
where 
    i.table_name = upper('&&Table_name')
and i.table_owner = upper(nvl('&&Owner',user))
and i.owner = t.index_owner
and i.index_name=t.index_name
/

prompt
prompt ***************
prompt Table DDL
prompt ***************
set linesize 300 
set long 100000  
set pagesize 0   
select dbms_metadata.get_ddl('TABLE',upper('&&Table_name'),upper(nvl('&&Owner',user))) from dual;

spool off

set escape        off
SET MARKUP HTML OFF