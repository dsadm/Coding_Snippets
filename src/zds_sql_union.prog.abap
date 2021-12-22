*&---------------------------------------------------------------------*
*& Report zds_sql_union
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_sql_union.

select from scarr
    fields carrname,
           cast( '-' as char( 4 ) ) as connid,
           '-' as cityfrom,
           '-' as cityto
     where carrid = 'LH'
 union
select from spfli
    fields '-' as carrname,
           cast( connid as char( 4 ) ) as connid,
           cityfrom,
           cityto
     where carrid = 'LH'
     order by carrname descending, connid, cityfrom, cityto
into table @data(result).

cl_demo_output=>display( result ).
