*&---------------------------------------------------------------------*
*& Report zds_dynamic_structure
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_dynamic_structure.

class demo definition.
  public section.
    class-methods main.
endclass.

class demo implementation.
  method main.
    data: struct_type type ref to cl_abap_structdescr,
          dref        type ref to data,
          oref        type ref to cx_sy_struct_creation.

    data column1 type c length 30.
    data column2 type c length 30.

    field-symbols: <struc> type any,
                   <comp1> type any,
                   <comp2> type any.

    cl_demo_input=>add_field( changing field = column1 ).
    cl_demo_input=>add_field( changing field = column2 ).
    cl_demo_input=>request( ).

    column1 = to_upper( column1 ).
    column2 = to_upper( column2 ).

    try.
        struct_type = cl_abap_structdescr=>get(
          value #(
            ( name = column1 type = cl_abap_elemdescr=>get_c( 40 ) )
            ( name = column2 type = cl_abap_elemdescr=>get_i( )    )
                 )
                                               ).
        create data dref type handle struct_type.
      catch cx_sy_struct_creation into oref.
        cl_demo_output=>display( oref->get_text( ) ).
        return.
    endtry.

    assign dref->* to <struc>.
    assign component column1 of structure <struc> to <comp1>.
    <comp1> = 'Amount'.

    assign dref->* to <struc>.
    assign component column2 of structure <struc> to <comp2>.
    <comp2> = 11.

    cl_demo_output=>display( |{ column1 width = 32 } { <comp1> }\n| &
                             |{ column2 width = 32 } { <comp2> }| ).
  endmethod.
endclass.

start-of-selection.
  demo=>main( ).
