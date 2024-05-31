CLASS lcl_aux DEFINITION
CREATE PRIVATE.
  PUBLIC SECTION.
    TYPES tt_po_tracking TYPE STANDARD TABLE OF zpo_tracking WITH EMPTY KEY.
    TYPES tt_po_comment TYPE STANDARD TABLE OF zpo_comment WITH EMPTY KEY.

    CLASS-METHODS get_instance RETURNING VALUE(result) TYPE REF TO lcl_aux.
    METHODS set_data IMPORTING it_po_tracking TYPE tt_po_tracking.
    METHODS get_data RETURNING VALUE(it_po_tracking) TYPE tt_po_tracking.
    METHODS set_comment IMPORTING it_po_comment TYPE tt_po_comment.
    METHODS get_comment RETURNING VALUE(it_po_comment) TYPE tt_po_comment.

  PRIVATE SECTION.
    CLASS-DATA mo_instance TYPE REF TO lcl_aux.
    DATA mt_po_tracking_upd TYPE tt_po_tracking.
    DATA mt_po_comment_upd TYPE tt_po_comment.
ENDCLASS.

CLASS lcl_aux IMPLEMENTATION.

  METHOD get_data.
    RETURN mt_po_tracking_upd.
  ENDMETHOD.

  METHOD get_comment.
    RETURN mt_po_comment_upd.
  ENDMETHOD.


  METHOD get_instance.
    IF mo_instance IS INITIAL.
      mo_instance = NEW lcl_aux(  ).
    ENDIF.
    result = mo_instance.
  ENDMETHOD.

  METHOD set_data.
    mt_po_tracking_upd = it_po_tracking.
  ENDMETHOD.

  METHOD set_comment.
    mt_po_comment_upd = it_po_comment.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_comments DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE Comments.

    METHODS read FOR READ
      IMPORTING keys FOR READ Comments RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ Comments\_Header FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_comments IMPLEMENTATION.

  METHOD create.

    DATA ls_po_comment TYPE zpo_comment.
    DATA lt_po_comment_upd TYPE STANDARD TABLE OF zpo_comment WITH EMPTY KEY.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      CLEAR ls_po_comment.

      ls_po_comment-po_number = <entity>-PurchasingDoc.
      ls_po_comment-color_code = <entity>-ColorCode.
      ls_po_comment-created_on = <entity>-CreatedOn.
      ls_po_comment-created_by = cl_abap_context_info=>get_user_technical_name( ).
      ls_po_comment-comments = <entity>-Comments.

      APPEND ls_po_comment TO lt_po_comment_upd.

    ENDLOOP.

    lcl_aux=>get_instance( )->set_comment( lt_po_comment_upd ).

  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD rba_Header.
  ENDMETHOD.

ENDCLASS.

*CLASS lcl_aux DEFINITION
*CREATE PRIVATE.
*PUBLIC SECTION.
*  TYPES tt_po_tracking TYPE STANDARD TABLE OF zpo_tracking WITH EMPTY KEY.
*  TYPES tt_po_comment TYPE STANDARD TABLE OF zpo_comment WITH EMPTY KEY.
*
*  CLASS-METHODS get_instance RETURNING VALUE(result) TYPE REF TO lcl_aux.
*  METHODS set_data IMPORTING it_po_tracking TYPE tt_po_tracking.
*  METHODS get_data RETURNING VALUE(it_po_tracking) TYPE tt_po_tracking.
*  METHODS set_comment IMPORTING it_po_comment TYPE tt_po_comment.
*  METHODS get_comment RETURNING VALUE(it_po_comment) TYPE tt_po_comment.
*
*PRIVATE SECTION.
*  CLASS-DATA mo_instance TYPE REF TO lcl_aux.
*  DATA mt_po_tracking_upd TYPE tt_po_tracking.
*  DATA mt_po_comment_upd TYPE tt_po_comment.
*ENDCLASS.
*
*CLASS lcl_aux IMPLEMENTATION.
*
*METHOD get_data.
*  RETURN mt_po_tracking_upd.
*ENDMETHOD.
*
*METHOD get_comment.
*  RETURN mt_po_comment_upd.
*ENDMETHOD.
*
*
*METHOD get_instance.
*  IF mo_instance IS INITIAL.
*    mo_instance = NEW lcl_aux(  ).
*  ENDIF.
*  result = mo_instance.
*ENDMETHOD.
*
*METHOD set_data.
*  mt_po_tracking_upd = it_po_tracking.
*ENDMETHOD.
*
*METHOD set_comment.
*  mt_po_comment_upd = it_po_comment.
*ENDMETHOD.
*
*ENDCLASS.

CLASS lhc_POItems DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR POItems RESULT result.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE POItems.

    METHODS read FOR READ
      IMPORTING keys FOR READ POItems RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK POItems.
    METHODS rba_Comments FOR READ
      IMPORTING keys_rba FOR READ POItems\_Comments FULL result_requested RESULT result LINK association_links.

*    METHODS cba_Comments FOR MODIFY
*      IMPORTING entities_cba FOR CREATE POItems\_Comments.

ENDCLASS.

CLASS lhc_POItems IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD update.
    DATA ls_po_tracking TYPE zpo_tracking.
    DATA lt_po_tracking TYPE SORTED TABLE OF zpo_tracking WITH UNIQUE KEY primary_key COMPONENTS po_number color_code.
    DATA lt_po_tracking_upd TYPE STANDARD TABLE OF zpo_tracking WITH EMPTY KEY.

    SELECT * FROM
    zpo_tracking
    FOR ALL ENTRIES IN @entities
    WHERE po_number = @entities-PurchasingDoc
      AND color_code = @entities-ColorCode
    INTO TABLE @lt_po_tracking.

    LOOP AT entities ASSIGNING FIELD-SYMBOL(<entity>).
      CLEAR ls_po_tracking.

      READ TABLE lt_po_tracking INTO ls_po_tracking
      WITH TABLE KEY primary_key
      COMPONENTS po_number = <entity>-PurchasingDoc
                 color_code = <entity>-ColorCode.

      IF sy-subrc NE 0.
        ls_po_tracking-po_number = <entity>-PurchasingDoc.
        ls_po_tracking-color_code = <entity>-ColorCode.
      ENDIF.

      IF <entity>-%control-actual_cut_date = if_abap_behv=>mk-on.
        ls_po_tracking-actual_cut_date = <entity>-actual_cut_date.
      ENDIF.

      IF <entity>-%control-actual_daily_op = if_abap_behv=>mk-on.
        ls_po_tracking-actual_daily_op = <entity>-actual_daily_op.
      ENDIF.

      IF <entity>-%control-actual_inhouse_date = if_abap_behv=>mk-on.
        ls_po_tracking-actual_inhouse_date = <entity>-actual_inhouse_date.
      ENDIF.

      IF <entity>-%control-call_out = if_abap_behv=>mk-on.
        ls_po_tracking-call_out = <entity>-call_out.
      ENDIF.

      IF <entity>-%control-FactoryVendor = if_abap_behv=>mk-off.
        ls_po_tracking-factory_vendor = <entity>-FactoryVendor.
      ENDIF.

      IF <entity>-%control-change_type1 = if_abap_behv=>mk-on.
        ls_po_tracking-change_type1 = <entity>-change_type1.
      ENDIF.

      IF <entity>-%control-change_type2 = if_abap_behv=>mk-on.
        ls_po_tracking-change_type2 = <entity>-change_type2.
      ENDIF.

      IF <entity>-%control-change_type3 = if_abap_behv=>mk-on.
        ls_po_tracking-change_type3 = <entity>-change_type3.
      ENDIF.

      IF <entity>-%control-china_submit_date = if_abap_behv=>mk-on.
        ls_po_tracking-china_submit_date = <entity>-china_submit_date.
      ENDIF.

      IF <entity>-%control-cost_option = if_abap_behv=>mk-on.
        ls_po_tracking-cost_option = <entity>-cost_option.
      ENDIF.

      IF <entity>-%control-days_complete = if_abap_behv=>mk-on.
        ls_po_tracking-days_complete = <entity>-days_complete.
      ENDIF.

      IF <entity>-%control-otr_program = if_abap_behv=>mk-on.
        ls_po_tracking-otr_program = <entity>-otr_program.
      ENDIF.

      IF <entity>-%control-plan_daily_op = if_abap_behv=>mk-on.
        ls_po_tracking-plan_daily_op = <entity>-plan_daily_op.
      ENDIF.

      IF <entity>-%control-plan_prod_date = if_abap_behv=>mk-on.
        ls_po_tracking-plan_prod_date = <entity>-plan_prod_date.
      ENDIF.

      IF <entity>-%control-planned_cut_date = if_abap_behv=>mk-on.
        ls_po_tracking-planned_cut_date = <entity>-planned_cut_date.
      ENDIF.

      IF <entity>-%control-pm_pp_comment = if_abap_behv=>mk-on.
        ls_po_tracking-pm_pp_comment = <entity>-pm_pp_comment.
      ENDIF.

      IF <entity>-%control-priority_list = if_abap_behv=>mk-on.
        ls_po_tracking-priority_list = <entity>-priority_list.
      ENDIF.

      IF <entity>-%control-proposed_mod = if_abap_behv=>mk-on.
        ls_po_tracking-proposed_mod = <entity>-proposed_mod.
      ENDIF.

      IF <entity>-%control-proposed_ndc = if_abap_behv=>mk-on.
        ls_po_tracking-proposed_ndc = <entity>-proposed_ndc.
      ENDIF.

      IF <entity>-%control-region = if_abap_behv=>mk-on.
        ls_po_tracking-region = <entity>-region.
      ENDIF.

      IF <entity>-%control-regional_comment = if_abap_behv=>mk-on.
        ls_po_tracking-regional_comment = <entity>-regional_comment.
      ENDIF.

      IF <entity>-%control-req_ndc_date = if_abap_behv=>mk-on.
        ls_po_tracking-req_ndc_date = <entity>-req_ndc_date.
      ENDIF.

      IF <entity>-%control-req_shipmode = if_abap_behv=>mk-on.
        ls_po_tracking-req_shipmode = <entity>-req_shipmode.
      ENDIF.

      IF <entity>-%control-vendor_comment = if_abap_behv=>mk-on.
        ls_po_tracking-vendor_comment = <entity>-vendor_comment.
      ENDIF.

      IF <entity>-%control-x_fty_date = if_abap_behv=>mk-on.
        ls_po_tracking-x_fty_date = <entity>-x_fty_date.
      ENDIF.

      IF <entity>-%control-sewing_bal_qty = if_abap_behv=>mk-on.
        ls_po_tracking-sewing_bal_qty = <entity>-sewing_bal_qty.
      ENDIF.

      IF <entity>-%control-sewing_com_qty = if_abap_behv=>mk-on.
        ls_po_tracking-sewing_com_qty = <entity>-sewing_com_qty.
      ENDIF.

      IF <entity>-%control-shippable_qty = if_abap_behv=>mk-on.
        ls_po_tracking-shippable_qty = <entity>-shippable_qty.
      ENDIF.

      IF <entity>-%control IS NOT INITIAL.
        APPEND ls_po_tracking TO lt_po_tracking_upd.
      ENDIF.
      CLEAR ls_po_tracking.
    ENDLOOP.

    "MODIFY zpo_tracking FROM TABLE @lt_po_tracking_upd.
    lcl_aux=>get_instance( )->set_data( lt_po_tracking_upd ).
*    lcl_aux=>get_instance( )->set_data( ls_po_tracking ).

  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Comments.
  ENDMETHOD.

*  METHOD cba_Comments.
*  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZCE_PURCHASEORDERITEMSERP DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZCE_PURCHASEORDERITEMSERP IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.

    DATA(lt_po_tracking_upd) = lcl_aux=>get_instance( )->get_data( ).
    DATA(lt_po_comment_upd) = lcl_aux=>get_instance( )->get_comment( ).

    IF lt_po_tracking_upd IS NOT INITIAL.
      MODIFY zpo_tracking FROM TABLE @lt_po_tracking_upd.
    ENDIF.

    IF lt_po_comment_upd IS NOT INITIAL.
      INSERT zpo_comment FROM TABLE @lt_po_comment_upd.
    ENDIF.

  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
