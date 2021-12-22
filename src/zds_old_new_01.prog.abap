*&---------------------------------------------------------------------*
*& Report zds_old_new_01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_old_new_01.

**********************************************************************
* OLD
**********************************************************************
data itab type table of scarr.

select * from scarr
    into table itab.

data wa like line of itab.
read table itab with key carrid = 'LH' into wa.

data output type string.
concatenate 'Carrier:'
            wa-carrname into output separated by space.

cl_demo_output=>display( output ).


**********************************************************************
* NEW
**********************************************************************
select from scarr
    fields *
into table @data(itab2).

cl_demo_output=>display(
    |Carrier: { itab2[ carrid = 'LH' ]-carrname }| ).
