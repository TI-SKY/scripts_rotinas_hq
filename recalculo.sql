set term !! ;
execute block
as
  declare variable stmt varchar(1000);
  declare variable idx_name varchar(255);
begin
  for select trim(rdb$index_name)
    from rdb$indices
    where rdb$system_flag = 0
  into :idx_name
  do 
    begin
      stmt = 'SET STATISTICS INDEX ' || idx_name || ';';
      execute statement stmt;
    end
end!!
commit!!
set term ; !!
