*&---------------------------------------------------------------------*
*& Report zds_alv_refresh
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
report zds_alv_refresh.

data: gv_screen_status type string value 'INIT'.
data: gv_carrid   type spfli-carrid.
data: gv_connid type spfli-connid.
data: o_alv type ref to cl_gui_alv_grid.
data: it_spfli type standard table of spfli with default key.
**********************************************************************
*
* leeres Dynpro als Dummy für ALV-Grid
*
**********************************************************************
selection-screen begin of screen 2000.
selection-screen end of screen 2000.
**********************************************************************
*
* SELECTION-SCREEN
*
**********************************************************************
select-options: so_carr for gv_carrid.
select-options: so_conn for gv_connid.
**********************************************************************
*
* Eventhandler
*
**********************************************************************
class lcl_events definition.

  public section.

    class-methods:
      on_toolbar for event toolbar of cl_gui_alv_grid
        importing
          e_object
          e_interactive
          sender.

    class-methods:
      on_user_command for event user_command of cl_gui_alv_grid
        importing
          e_ucomm
          sender.

    class-methods:
      on_data_changed for event data_changed of cl_gui_alv_grid
        importing
          er_data_changed
          sender.
endclass.

class lcl_events implementation.

  method on_data_changed.
* geänderte Zellen durchgehen
    loop at er_data_changed->mt_good_cells assigning field-symbol(<c>).
      if <c> is assigned.
* Zeile x aus der iTab it_spfli rausholen und daraus die Zelle anhand des Spaltennamens (Feldnamens) holen
        assign component <c>-fieldname of structure it_spfli[ <c>-row_id ] to field-symbol(<f>).

        if <f> is assigned.
* Änderungswert in die Zelle der iTab (it_spfli) rückschreiben
          <f> = <c>-value.
        endif.
      endif.

    endloop.

* DB Update
    field-symbols: <tab> type table.
    field-symbols: <row> type spfli.

    assign er_data_changed->mp_mod_rows->* to <tab>.

    loop at <tab> assigning <row>.
* DB Update hier
    endloop.

  endmethod.

  method on_user_command.
* wenn BTN_REFRESH geklickt
    if e_ucomm = 'BTN_REFRESH'.
      if o_alv is bound.
        select * from spfli into table @it_spfli
          where carrid in @so_carr
            and connid in @so_conn.

        sender->refresh_table_display( is_stable = value lvc_s_stbl( row = abap_true
                                                                     col = abap_true )
                                       i_soft_refresh = abap_false ).
      endif.
    endif.
  endmethod.

  method on_toolbar.
* alle Buttons entfernen, bis auf folgende:
    delete e_object->mt_toolbar where
        function ne cl_gui_alv_grid=>mc_fc_refresh          " Refresh
    and function ne cl_gui_alv_grid=>mc_mb_export           " Excel
    and function ne cl_gui_alv_grid=>mc_fc_current_variant. " Layout

    loop at e_object->mt_toolbar assigning field-symbol(<fs_button>) where ( function = cl_gui_alv_grid=>mc_fc_refresh ).
* neues USER-Command setzen, damit bei Button-Klick on_user_command getriggert wird
      <fs_button>-function = 'BTN_REFRESH'.
    endloop.

  endmethod.
endclass.
**********************************************************************
*
* INITIALIZATION
*
**********************************************************************
initialization.

* Vorbelegungen für Selektionsbild
  so_carr[] = value #( ( sign = 'I' option = 'EQ' low = 'LH' ) ).

**********************************************************************
*
* AT SELECTION-SCREEN OUTPUT
*
**********************************************************************
at selection-screen output.

* Wenn vorher das Selektionsbild 1000 angezeigt wurde
  if gv_screen_status = 'IN_SELECTION'.
* Daten holen
    select * from spfli into table @it_spfli
       where carrid in @so_carr
         and connid in @so_conn.
* ALV-Gitter anzeigen
    o_alv = new #( i_parent      = cl_gui_container=>default_screen
                   i_appl_events = abap_true ).

* Eventhandler registrieren
    set handler lcl_events=>on_toolbar for o_alv.
    set handler lcl_events=>on_data_changed for o_alv.
    set handler lcl_events=>on_user_command for o_alv.

* Ereignisse registrieren
    o_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_enter ).
    o_alv->register_edit_event( i_event_id = cl_gui_alv_grid=>mc_evt_modified ).

* ALV-Grid selektionsbereit setzen
    o_alv->set_ready_for_input( i_ready_for_input = 1 ).

* Layout des ALV setzen
    data(lv_layout) = value lvc_s_layo( zebra      = abap_true
                                        cwidth_opt = 'A'
                                        grid_title = 'Flugverbindungen' ).

* Feldkatalog automatisch durch SALV erstellen lassen
    data: o_salv type ref to cl_salv_table.

    cl_salv_table=>factory( importing
                              r_salv_table = o_salv
                            changing
                              t_table      = it_spfli ).

    data(it_fcat) = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns      = o_salv->get_columns( )
                                                                       r_aggregations = o_salv->get_aggregations( ) ).

* im Feldkatalog alle Zellen der Spalte "CITYFROM" des ALV-Grids auf
* editierbar stellen, die restlichen Zellen sind nicht editierbar
    loop at it_fcat assigning field-symbol(<fcat>).
      case <fcat>-fieldname.
        when 'CITYFROM'.
          <fcat>-edit = abap_true.
        when others.
          <fcat>-edit = abap_false.
      endcase.
    endloop.

* ALV anzeigen
    o_alv->set_table_for_first_display( exporting
                                          i_bypassing_buffer = abap_false
                                          i_save             = 'A'
                                          is_layout          = lv_layout
                                        changing
                                          it_fieldcatalog    = it_fcat
                                          it_outtab          = it_spfli ).

* Drucktastenleiste: Button "Ausführen (F8)" entfernen
    data: it_exclude_btn type standard table of rsexfcode with default key.
    it_exclude_btn = value #( ( fcode = 'ONLI' ) ).

    call function 'RS_SET_SELSCREEN_STATUS'
      exporting
        p_status  = '%_00' " akt. Standard-PF-Status des Dypro 2000
      tables
        p_exclude = it_exclude_btn.

* leere SAP-Toolbar ausblenden
    cl_abap_list_layout=>suppress_toolbar( ).

* Focus auf ALV setzen
    cl_gui_alv_grid=>set_focus( control = o_alv ).

* Flag für Screen-Status auf ALV-Anzeige setzen
    gv_screen_status = 'IN_ALV'.
  endif.
**********************************************************************
*
* START-OF-SELECTION
*
**********************************************************************
start-of-selection.

* Wir befinden uns im Anzeigebereich des Selektionsbildes
  gv_screen_status = 'IN_SELECTION'.

* Trick: leeren Dummy-Screen 2000 anzeigen und intern für das ALV-Grid in
* AT SELECTION-SCREEN OUTPUT als cl_gui_container=>default_screen nutzen
  call selection-screen 2000.
