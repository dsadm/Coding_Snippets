*&---------------------------------------------------------------------*
*& Report zds_ce_filter
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_ce_filter.

select from scarr
   fields *
   order by primary key
into table @data(carriers).

data filter type sorted table of scarr-carrid
                 with unique key table_line.

filter = value #( ( 'AA ' ) ( 'LH ' ) ( 'UA ' ) ).
data(extract) = filter #(
    carriers in filter where carrid = table_line ).

cl_demo_output=>display( extract ).
