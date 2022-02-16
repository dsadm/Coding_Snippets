*&---------------------------------------------------------------------*
*& Report zds_itab2xlxs01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_itab2xlxs01.

constants: gc_save_file_name type string value '10_iTabFieldCatalog.xlsx'.
include zdemo_excel_outputopt_incl.

start-of-selection.
  select from sflight
      fields *
      into table @data(flights)
      up to 100 rows.


  data(excel) = new zcl_excel( ).

  data(worksheet) = excel->get_active_worksheet( ).

  data(lt_field_catalog) = zcl_excel_common=>get_fieldcatalog( ip_table = flights ).

  data(table_settings) = value zexcel_s_table_settings(
                                  table_style       = zcl_excel_table=>builtinstyle_medium2
                                  show_row_stripes  = abap_true
                                  nofilters         = abap_true ).

  worksheet->bind_table( ip_table          = flights
                         is_table_settings = table_settings ).


  lcl_output=>output( excel ).
