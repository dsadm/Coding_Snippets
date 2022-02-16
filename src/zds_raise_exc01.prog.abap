*&---------------------------------------------------------------------*
*& Report zds_raise_exc01
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_raise_exc01.

*try.
*    raise exception type zcx_pl01_selection_not_allowed
*      message id 'ZPL01'
*      type 'E'
*      number '013'.
**      with space.
*
*  catch zcx_pl01_selection_not_allowed into data(e).
*       message e->get_text( ) type 'E'.
*endtry.
try.
    raise exception type cx_demo_dyn_t100
      message id 'SABAPDEMOS'
      type 'I'
      number '888'
      with 'Message'.
  catch cx_demo_dyn_t100 into data(oref).
  message oref->get_text( ) type 'E'.
*    cl_demo_output=>display( oref->get_text( ) &&
*                             `, ` && oref->msgty ).
endtry.
