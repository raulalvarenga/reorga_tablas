CREATE OR REPLACE PROCEDURE sys.reorga_part  (p_table_owner     in varchar2,
                                              p_table_name      in varchar2,
                                              p_partition_name  in varchar2,
                                              p_tablespace_name in varchar2) is
cursor indices_1 is
 select 'alter index '||index_owner||'.'||index_name ||' rebuild partition '||partition_name||' TABLESPACE '||tablespace_name  comando
   from dba_ind_partitions
  where status = 'UNUSABLE';

cursor indices_2 is
 select 'alter index '||owner||'.'||index_name ||' rebuild '||' TABLESPACE '||tablespace_name comando
   from dba_indexes
  where status = 'UNUSABLE';

xtablespace_origen varchar2(100);

begin
   select tablespace_name into xtablespace_origen 
     from dba_tab_partitions
    where table_owner=p_table_owner
      and table_name=p_table_name
      and partition_name=p_partition_name; 
    
    execute immediate 'alter table '||p_table_owner||'.'||p_table_name||' move partition '||p_partition_name||' tablespace '||p_tablespace_name;
    execute immediate 'alter table '||p_table_owner||'.'||p_table_name||' move partition '||p_partition_name||' tablespace '||xtablespace_origen;
    
    for f in indices_1 loop
        execute immediate f.comando;
    end loop;
    for f in indices_2 loop
        execute immediate f.comando;
    end loop;

    execute immediate 'ANALYZE TABLE '||p_table_owner||'.'||p_table_name||' partition'||'('||p_partition_name||')'||' COMPUTE STATISTICS';
end;
/
