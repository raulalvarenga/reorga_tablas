CREATE OR REPLACE PROCEDURE sys.reorga_tabla  (p_table_owner     in varchar2,
                                               p_table_name      in varchar2,
                                               p_tablespace_name in varchar2) is
cursor indices is
 select 'alter index '||owner||'.'||index_name ||' rebuild '||' TABLESPACE '||tablespace_name comando
   from dba_indexes
  where status = 'UNUSABLE'
    and table_name=p_table_name;

xtablespace_origen varchar2(100);

begin
   select tablespace_name into xtablespace_origen 
     from dba_tables
    where owner=p_table_owner
      and table_name=p_table_name;
    
    execute immediate 'alter table '||p_table_owner||'.'||p_table_name||' move tablespace '||p_tablespace_name;
    execute immediate 'alter table '||p_table_owner||'.'||p_table_name||' move tablespace '||xtablespace_origen;
    
    for f in indices loop
        execute immediate f.comando;
    end loop;

    execute immediate 'ANALYZE TABLE '||p_table_owner||'.'||p_table_name||' COMPUTE STATISTICS';
    execute immediate 'begin DBMS_STATS.DELETE_TABLE_STATS('''||p_table_owner||''','''||p_table_name||'''); end;';
    execute immediate 'begin DBMS_STATS.gather_table_stats('''||p_table_owner||''','''||p_table_name||'''); end;';
	
end;
/
