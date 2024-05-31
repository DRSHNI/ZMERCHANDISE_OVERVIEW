CLASS zcl_po_tracking_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: tt_external_data TYPE STANDARD TABLE OF ZCE_PurchaseOrderItemsERP.

    METHODS get_purchase_volume_ovp IMPORTING io_request  TYPE REF TO if_rap_query_request
                                              io_response TYPE REF TO if_rap_query_response
                                    RAISING   cx_rap_query_prov_not_impl
                                              cx_rap_query_provider .

    METHODS get_vendor_purchase_ovp IMPORTING io_request  TYPE REF TO if_rap_query_request
                                              io_response TYPE REF TO if_rap_query_response
                                    RAISING   cx_rap_query_prov_not_impl
                                              cx_rap_query_provider .

    METHODS get_topstyles_ovp IMPORTING io_request  TYPE REF TO if_rap_query_request
                                        io_response TYPE REF TO if_rap_query_response
                              RAISING   cx_rap_query_prov_not_impl
                                        cx_rap_query_provider .

    METHODS get_topcallouts_ovp IMPORTING io_request  TYPE REF TO if_rap_query_request
                                          io_response TYPE REF TO if_rap_query_response
                                RAISING   cx_rap_query_prov_not_impl
                                          cx_rap_query_provider .

    TYPES: BEGIN OF ty_range_option,
             sign   TYPE c LENGTH 1,
             option TYPE c LENGTH 2,
             low    TYPE string,
             high   TYPE string,
           END OF ty_range_option,
           "! Ranges-table-compatible format (see ABAP Keyword Documentation for "TYPES - RANGE OF")
           tt_range_option TYPE STANDARD TABLE OF ty_range_option WITH EMPTY KEY.

    METHODS get_navigation_output IMPORTING iv_property_name    TYPE string
                                            it_filter_condition TYPE tt_range_option
                                            io_request          TYPE REF TO if_rap_query_request
                                            io_response         TYPE REF TO if_rap_query_response.

ENDCLASS.



CLASS ZCL_PO_TRACKING_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*    data lt_po_tracking TYPE STANDARD TABLE OF zpo_tracking WITH EMPTY KEY.
*
*    lt_po_tracking = VALUE #( ( po_number = '1234' color_code = '19PO' otr_program = 'OTR_PGM1'  ) ).
*
*    INSERT ZPO_TRACKING FROM TABLE @LT_PO_TRACKING.
*
*    COMMIT WORK AND WAIT.

*    DELETE FROM zpo_comment.
*   COMMIT WORK AND WAIT.

*    "inserting record for ZPO_USER_VENDOR table
    DATA lt_user_info TYPE STANDARD TABLE OF zpo_user_vendor WITH EMPTY KEY.
    DATA ls_user_info TYPE zpo_user_vendor.

    DELETE FROM zpo_user_vendor.
    COMMIT WORK AND WAIT.

    lt_user_info = VALUE #( ( users = 'CB9980000001' vendor_no = '36009994' image_url = 'https://raw.githubusercontent.com/DRSHNI/SmartMerchandise/main/vs&co%20logo_.jpg' )
                            ( users = 'CB9980000030' vendor_no = '36009994' image_url = 'https://raw.githubusercontent.com/DRSHNI/SmartMerchandise/main/bogart.png' )
                            ( users = 'CB9980000050' vendor_no = '36010884' image_url = 'https://raw.githubusercontent.com/DRSHNI/SmartMerchandise/main/cute%20pic.jpg' )
                            ( users = 'CB9980000031' vendor_no = '36010884' image_url = 'https://raw.githubusercontent.com/DRSHNI/SmartMerchandise/main/boy_pic.jpeg' ) ).


    INSERT zpo_user_vendor FROM TABLE @lt_user_info.
    COMMIT WORK AND WAIT.

  ENDMETHOD.


  METHOD if_rap_query_provider~select.

    DATA:
      lt_business_data TYPE TABLE OF z_otr_purchaseordersitems_erp=>tys_header,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA:
      lo_filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
      lo_filter_node_1    TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_2    TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node.

    DATA lt_purchasing_doc TYPE RANGE OF zpo_number.
    DATA lt_factory_vendor TYPE RANGE OF zotr_factory_vendor.
    DATA business_data_external TYPE TABLE OF ZCE_PurchaseOrderItemsERP.
    DATA ls_data_external TYPE ZCE_PurchaseOrderItemsERP.
    DATA lv_internal_property TYPE /iwbep/if_cp_runtime_types=>ty_property_path.

    DATA(top)     = CONV i( io_request->get_paging( )->get_page_size( ) ).
    DATA(skip)    = CONV i( io_request->get_paging( )->get_offset( ) ).



    DATA(entity_id) = io_request->get_entity_id( ).

    CASE entity_id.
      WHEN 'ZCE_PURCHASEORDERITEMSERP'.
      WHEN 'ZCE_PURCHASEVOLUMEOVP'.
        me->get_purchase_volume_ovp( EXPORTING io_request = io_request
                                               io_response = io_response ).

        RETURN.
      WHEN 'ZCE_PURCHASEOVERVIEWFILTEROVP'.
        DATA lt_filter TYPE TABLE OF ZCE_PurchaseOverviewFilterOVP.
        io_response->set_total_number_of_records( 0 ).
        io_response->set_data( lt_filter ).

      WHEN 'ZCE_PURCHASEVIEWBYVENDOR'.
        me->get_vendor_purchase_ovp( EXPORTING io_request = io_request
                                               io_response = io_response ).

        RETURN.

      WHEN 'ZCE_SEASONTOPSTYLESOVP'.
        me->get_topstyles_ovp( EXPORTING io_request = io_request
                                         io_response = io_response ).

        RETURN.

      WHEN 'ZCE_TOPCALLOUTSOVP'.
        me->get_topcallouts_ovp( EXPORTING io_request = io_request
                                         io_response = io_response ).

        RETURN.

    ENDCASE.

    TRY.

        DATA(filter_condition) = io_request->get_filter( )->get_as_ranges( ).

        READ TABLE filter_condition INTO DATA(lwa_condition) WITH KEY name = 'FACTORYVENDOR'.
        IF sy-subrc EQ 0.
          me->get_navigation_output( EXPORTING iv_property_name   = 'FACTORY_VENDOR'
                                               it_filter_condition = lwa_condition-range
                                               io_request = io_request
                                               io_response = io_response ).
          RETURN.
        ENDIF.

        READ TABLE filter_condition INTO DATA(lwa_filter) WITH KEY name = 'CATEGORY'.
        IF sy-subrc EQ 0.
          me->get_navigation_output( EXPORTING iv_property_name = 'CATEGORY'
                                               it_filter_condition = lwa_filter-range
                                               io_request = io_request
                                               io_response = io_response ).
          RETURN.
        ENDIF.

        " Create http client
        DATA(http_destination) = cl_http_destination_provider=>create_by_cloud_destination(
                                   i_name                  = 'DF1' " 'RETAIL_QA_FE'
                                   i_authn_mode            = if_a4c_cp_service=>service_specific
                                 ).

        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( http_destination ).

        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'Z_OTR_PURCHASEORDERSITEMS_ERP'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/sap/opu/odata/sap/YTEST_SMART_MERCHENDISE_SRV/' ).

        ASSERT lo_http_client IS BOUND.

        " Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'HEADER_SET' )->create_request_for_read( ).

        " Create the filter tree
        lo_filter_factory = lo_request->create_filter_factory( ).
        IF filter_condition IS NOT INITIAL.
          LOOP AT filter_Condition ASSIGNING FIELD-SYMBOL(<filter>).
            CLEAR lv_internal_property.
            CASE <filter>-name.
              WHEN 'COLORCODE'.
                lv_internal_property = 'COLOR_CODE'.
              WHEN 'PURCHASINGDOC'.
                lv_internal_property = 'PURCHASING_DOC'.
              WHEN 'SEASONCODE'.
                lv_internal_property = 'SEASON_CODE' .
              WHEN 'BRAND'.
                lv_internal_property = 'BRAND' .
            ENDCASE.
            lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = lv_internal_property
                                                                    it_range             =  <filter>-range ).
            IF lo_filter_node_root IS INITIAL.
              lo_filter_node_root = lo_filter_node_1.
            ELSE.
              lo_filter_node_root =  lo_filter_node_root->and( lo_filter_node_1 ).
            ENDIF.
          ENDLOOP.
        ENDIF.

        "get factory vendor from zpo_user_vendor table
        DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

        SELECT SINGLE vendor_no
        FROM zpo_user_vendor
        WHERE users EQ @lv_user
        INTO @DATA(lwa_vendor).

        CLEAR lt_factory_vendor.
        lt_factory_vendor = VALUE #(  ( sign = 'I' option = 'EQ' low = lwa_vendor ) ).
        lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'FACTORY_VENDOR'
                                                                it_range             =  lt_factory_vendor ).
        IF lo_filter_node_root IS INITIAL.
          lo_filter_node_root = lo_filter_node_1.
        ELSE.
          lo_filter_node_root =  lo_filter_node_root->and( lo_filter_node_1 ).
        ENDIF.

        lo_request->set_filter( lo_filter_node_root ).
**********************************************************************
*        lo_filter_factory = lo_request->create_filter_factory( ).
*
*        lt_purchasing_doc = VALUE #( ( sign = 'I' option = 'EQ' low = '5100000521' ) ).
*        lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'PURCHASING_DOC'
*                                                                it_range             =  lt_purchasing_doc ).
*
*        lo_filter_node_root = lo_filter_node_1.
*        lo_request->set_filter( lo_filter_node_root ).
**********************************************************************
        IF top GT 0.
          lo_request->set_top( top ).
        ENDIF.
        IF skip GT 0.
          lo_request->set_skip( skip ).
        ENDIF.


        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).
        "out->write( lt_business_data ).

        SELECT * FROM zpo_tracking
        FOR ALL ENTRIES IN @lt_business_data
        WHERE po_number = @lt_business_data-purchasing_doc
        AND      color_code = @lt_business_data-color_code
        INTO TABLE @DATA(lt_business_data_btp).

        LOOP AT lt_business_data ASSIGNING FIELD-SYMBOL(<business_data>).

          ls_data_external-Brand = <business_data>-brand.
          ls_data_external-BuyStrategy = <business_data>-buy_strategy.
          ls_data_external-Category = <business_data>-category.
          ls_data_external-ColorCode = <business_data>-color_code.
          ls_data_external-CompanyCode = <business_data>-company_code.
          ls_data_external-FactoryVendor = <business_data>-factory_vendor.
          CONVERT TIME STAMP <business_data>-floorset_date TIME ZONE 'UTC' INTO DATE ls_data_external-FloorsetDate.
          ls_data_external-OrderReason = <business_data>-order_reason.
          ls_data_external-PlmId = <business_data>-plm_id.
          ls_data_external-PurchasingDoc = <business_data>-purchasing_doc.
          ls_data_external-SeasonCode = <business_data>-season_code.
          ls_data_external-order_qty = <business_data>-order_quantity.
          ls_data_external-image_url = <business_data>-image_url.
          ls_data_external-FactoryVendorName = <business_data>-factory_vendor_name.
          ls_data_external-Variant = <business_data>-variant.

          READ TABLE lt_business_data_btp ASSIGNING FIELD-SYMBOL(<business_data_btp>)
          WITH KEY po_number = <business_data>-purchasing_doc
                   color_code = <business_data>-color_code.
          IF sy-subrc EQ 0.
            ls_data_external-actual_cut_date = <business_data_btp>-actual_cut_date.
            ls_data_external-actual_daily_op = <business_data_btp>-actual_daily_op.
            ls_data_external-actual_inhouse_date = <business_data_btp>-actual_inhouse_date.
            ls_data_external-call_out = <business_data_btp>-call_out.
            ls_data_external-change_type1 = <business_data_btp>-change_type1.
            ls_data_external-change_type2 = <business_data_btp>-change_type2.
            ls_data_external-change_type3 = <business_data_btp>-change_type3.
            ls_data_external-china_submit_date = <business_data_btp>-china_submit_date.
            ls_data_external-cost_option = <business_data_btp>-cost_option.
            ls_data_external-days_complete = <business_data_btp>-days_complete.
            ls_data_external-otr_program = <business_data_btp>-otr_program.
            ls_data_external-plan_daily_op = <business_data_btp>-plan_daily_op.
            ls_data_external-plan_prod_date = <business_data_btp>-plan_prod_date.
            ls_data_external-planned_cut_date = <business_data_btp>-planned_cut_date.
            ls_data_external-pm_pp_comment = <business_data_btp>-pm_pp_comment.
            ls_data_external-priority_list = <business_data_btp>-priority_list.
            ls_data_external-proposed_mod = <business_data_btp>-proposed_mod.
            ls_data_External-proposed_ndc = <business_data_btp>-proposed_ndc.
            ls_data_External-region = <business_data_btp>-region.
            ls_data_External-regional_comment = <business_data_btp>-regional_comment.
            ls_data_external-req_ndc_date = <business_data_btp>-req_ndc_date.
            ls_data_external-req_shipmode = <business_data_btp>-req_shipmode.
            ls_data_external-vendor_comment = <business_data_btp>-vendor_comment.
            ls_data_external-x_fty_date = <business_data_btp>-x_fty_date.
            ls_data_external-shippable_qty = <business_data_btp>-shippable_qty.
            ls_data_external-sewing_bal_qty = <business_data_btp>-sewing_bal_qty.
            ls_data_external-sewing_com_qty = <business_data_btp>-sewing_com_qty.
          ENDIF.

          APPEND ls_data_External TO business_data_external.
        ENDLOOP.


        io_response->set_total_number_of_records( lines( business_data_external ) ).
        io_response->set_data( business_data_external ).

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        RAISE SHORTDUMP lx_web_http_client_error.


    ENDTRY.
  ENDMETHOD.


  METHOD get_purchase_volume_ovp.

    DATA: lt_ovp_data     TYPE TABLE OF z_otr_purchaseordersitems_erp=>tys_header.

    TYPES:
      BEGIN OF ty_output,
        category TYPE ZCE_PurchaseVolumeOVP-Category,
        quantity TYPE ZCE_PurchaseVolumeOVP-Quantity,
        uom      TYPE ZCE_PurchaseVolumeOVP-Uom,
      END OF ty_output.
    DATA lt_output TYPE STANDARD TABLE OF ty_output WITH EMPTY KEY.

    lt_ovp_data = VALUE #( ( category = 'SWIMWEAR-INTIMATE APPAREL' color_code = '2CFA' factory_vendor = '36009994' purchasing_doc = '5100155712' factory_vendor_name = 'BOGART/ BOGART LINGERIE (GZ) YWT BR' order_quantity = '220.68'  uom = 'BX' )
                           ( category = 'SWIMWEAR-INTIMATE APPAREL' color_code = '34R8' factory_vendor = '36009994' purchasing_doc = '5100155801' factory_vendor_name = 'BOGART/ BOGART LINGERIE (GZ) YWT BR' order_quantity = '50.22'   uom = 'BX' )
                           ( category = 'BRAS-INTIMATE APPAREL'     color_code = '2D7I' factory_vendor = '36010884' purchasing_doc = '5100155809' factory_vendor_name = 'BOGART/ SUN HING SHING FASHION'      order_quantity = '350.15'  uom = 'EA' )
                           ( category = 'BRAS-INTIMATE APPAREL'     color_code = '2D7I' factory_vendor = '36010884' purchasing_doc = '5100155810' factory_vendor_name = 'BOGART/ SUN HING SHING FASHION'      order_quantity = '180.85'  uom = 'EA' )
                           ( category = 'BRAS-INTIMATE APPAREL'     color_code = '2D7I' factory_vendor = '36010884' purchasing_doc = '5100155527' factory_vendor_name = 'BOGART/ SUN HING SHING FASHION'      order_quantity = '1500'    uom = 'EA' )
                           ( category = 'PANTIES-INTIMATE APPAREL'  color_code = '1Y08' factory_vendor = '36007074' purchasing_doc = '5100156220' factory_vendor_name = 'BOGART/ BOGART LINGERIE (GZ) LTD'    order_quantity = '240.40'  uom = 'BAG' )
                           ( category = 'PANTIES-INTIMATE APPAREL'  color_code = '1Y08' factory_vendor = '36007074' purchasing_doc = '5100156219' factory_vendor_name = 'BOGART/ BOGART LINGERIE (GZ) LTD'    order_quantity = '400.60'  uom = 'BAG' )
                            ).

    DATA(lt_fields) = io_request->get_aggregation(  )->get_aggregated_elements(  ).
    LOOP AT lt_ovp_data ASSIGNING FIELD-SYMBOL(<lfs_ovp_data>).

      READ TABLE lt_output ASSIGNING FIELD-SYMBOL(<lfs_output>)
      WITH KEY category = <lfs_ovp_data>-category.
      IF sy-subrc = 0.
        <lfs_output>-quantity = <lfs_output>-quantity + <lfs_ovp_data>-order_quantity.
      ELSE.
        APPEND VALUE #( category = <lfs_ovp_data>-category quantity = <lfs_ovp_data>-order_quantity uom = <lfs_ovp_data>-uom ) TO lt_output.
      ENDIF.
    ENDLOOP.

    io_response->set_data( lt_output ).

    io_response->set_total_number_of_records( lines( lt_output ) ).

  ENDMETHOD.


  METHOD get_vendor_purchase_ovp.

    DATA: lt_vendor_data  TYPE TABLE OF z_otr_purchaseordersitems_erp=>tys_header.

    TYPES:
      BEGIN OF ty_vndr_output,
        FactoryVendor     TYPE ZCE_PurchaseVolumeOVP-FactoryVendor,
        FactoryVendorName TYPE ZCE_PurchaseVolumeOVP-FactoryVendorName,
        quantity          TYPE ZCE_PurchaseVolumeOVP-Quantity,
      END OF ty_vndr_output.
    DATA lt_vndr_output TYPE STANDARD TABLE OF ty_vndr_output WITH EMPTY KEY.

    lt_vendor_data = VALUE #( ( purchasing_doc = '5100155709' color_code = '2D7I' factory_vendor = '36009994' factory_vendor_name = 'BOGART/ BOGART LINGERIE (GZ) YWT BR' order_quantity = '121.3' )
                              ( purchasing_doc = '5100155710' color_code = '2D7I' factory_vendor = '36009994' factory_vendor_name = 'BOGART/ BOGART LINGERIE (GZ) YWT BR' order_quantity = '618' )
                              ( purchasing_doc = '5100155711' color_code = '2D7I' factory_vendor = '36009994' factory_vendor_name = 'BOGART/ BOGART LINGERIE (GZ) YWT BR' order_quantity = '3006.2' )
                              ( purchasing_doc = '5100155712' color_code = '2CFA' factory_vendor = '36010884' factory_vendor_name = 'BOGART/ SUN HING SHING FASHION' order_quantity = '460.7' )
                              ( purchasing_doc = '5100155801' color_code = '2CFA' factory_vendor = '36010884' factory_vendor_name = 'BOGART/ SUN HING SHING FASHION' order_quantity = '544.5' )
                              ( purchasing_doc = '5100155802' color_code = '1Y08' factory_vendor = '36010884' factory_vendor_name = 'BOGART/ SUN HING SHING FASHION' order_quantity = '869.4' )
                              ( purchasing_doc = '5100156109' color_code = '1Y08' factory_vendor = '36007074' factory_vendor_name = 'BOGART/ BOGART LINGERIE (GZ) LTD' order_quantity = '903.6' )
                              ( purchasing_doc = '5100156119' color_code = '1Y08' factory_vendor = '36007074' factory_vendor_name = 'BOGART/ BOGART LINGERIE (GZ) LTD' order_quantity = '718.46' )  ).

    DATA(lt_fields) = io_request->get_aggregation(  )->get_aggregated_elements(  ).
    LOOP AT lt_vendor_data ASSIGNING FIELD-SYMBOL(<lfs_data>).

      READ TABLE lt_vndr_output ASSIGNING FIELD-SYMBOL(<lfs_output>)
          WITH KEY FactoryVendor = <lfs_data>-factory_vendor.
      IF sy-subrc EQ 0.
        <lfs_output>-quantity = <lfs_output>-quantity + <lfs_data>-order_quantity.
      ELSE.
        APPEND VALUE #( FactoryVendor = <lfs_data>-factory_vendor FactoryVendorName = <lfs_data>-factory_vendor_name quantity = <lfs_data>-order_quantity ) TO lt_vndr_output.
      ENDIF.

    ENDLOOP.

    io_response->set_data( lt_vndr_output ).

    io_response->set_total_number_of_records( lines( lt_vndr_output ) ).

  ENDMETHOD.


  METHOD get_topstyles_ovp .

    DATA: lt_topstyles TYPE STANDARD TABLE OF ZCE_SeasonTopStylesOvp,
          ls_style     TYPE ZCE_SeasonTopStylesOvp.

    DATA lv_count TYPE i.
    DATA:
      lt_business_data TYPE TABLE OF z_otr_purchaseordersitems_erp=>tys_header,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA:
      lo_filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
      lo_filter_node_1    TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_2    TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node.

    DATA lt_purchasing_doc TYPE RANGE OF zpo_number.
    DATA lt_factory_vendor TYPE RANGE OF zotr_factory_vendor.
    DATA business_data_external TYPE TABLE OF ZCE_PurchaseOrderItemsERP.
    DATA ls_data_external TYPE ZCE_PurchaseOrderItemsERP.
    DATA lv_internal_property TYPE /iwbep/if_cp_runtime_types=>ty_property_path.

    DATA(top)     = CONV i( io_request->get_paging( )->get_page_size( ) ).
    DATA(skip)    = CONV i( io_request->get_paging( )->get_offset( ) ).

    DATA(lv_user) = cl_abap_context_info=>get_user_technical_name( ).

    SELECT SINGLE vendor_no
    FROM zpo_user_vendor
    WHERE users EQ @lv_user
    INTO @DATA(lwa_vendor).

    "# of callouts
    SELECT *
    FROM zpo_tracking
    WHERE call_out = 'Y'
    INTO TABLE @DATA(lt_no_callout).

    "get PO
    LOOP AT lt_no_callout INTO DATA(lwa_callout).
      APPEND VALUE #( sign = 'I' option = 'EQ'  low = lwa_callout-po_number ) TO lt_purchasing_doc.
    ENDLOOP.

    TRY.

        "pass po to get records from on-premise
        " Create http client
        DATA(http_destination) = cl_http_destination_provider=>create_by_cloud_destination(
                                   i_name                  = 'DF1' " 'RETAIL_QA_FE'
                                   i_authn_mode            = if_a4c_cp_service=>service_specific
                                 ).

        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( http_destination ).

        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'Z_OTR_PURCHASEORDERSITEMS_ERP'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/sap/opu/odata/sap/YTEST_SMART_MERCHENDISE_SRV/' ).

        ASSERT lo_http_client IS BOUND.

        " Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'HEADER_SET' )->create_request_for_read( ).

**********************************************************************
        lo_filter_factory = lo_request->create_filter_factory( ).

*        lt_purchasing_doc = VALUE #( ( sign = 'I' option = 'EQ' low = '5100000521' ) ).
        lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'PURCHASING_DOC'
                                                                it_range             =  lt_purchasing_doc ).

        lo_filter_node_root = lo_filter_node_1.
        lo_request->set_filter( lo_filter_node_root ).
**********************************************************************
        IF top GT 0.
          lo_request->set_top( top ).
        ENDIF.
        IF skip GT 0.
          lo_request->set_skip( skip ).
        ENDIF.


        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        RAISE SHORTDUMP lx_web_http_client_error.

    ENDTRY.

    LOOP AT lt_no_callout ASSIGNING FIELD-SYMBOL(<lfs_callout>).

      READ TABLE lt_business_data ASSIGNING FIELD-SYMBOL(<lfs_data>) WITH KEY purchasing_doc = <lfs_callout>-po_number
                                                                              color_code = <lfs_callout>-color_code.

      IF sy-subrc EQ 0.

        READ TABLE lt_topstyles ASSIGNING FIELD-SYMBOL(<lfs_style>)
        WITH KEY FactoryVendor = <lfs_data>-factory_vendor.
        IF sy-subrc EQ 0.

          <lfs_style>-Call_out = <lfs_style>-Call_out + 1.
        ELSE.

          APPEND VALUE #( FactoryVendor = <lfs_data>-factory_vendor
          FactoryVendorName = <lfs_data>-factory_vendor_name
*          season = <lfs_data>-season_code
          call_out = 1
          riskstatus = 'Low Risk' ) TO lt_topstyles.

        ENDIF.

      ENDIF.
    ENDLOOP.
*
    io_response->set_data(  lt_topstyles ).

    io_response->set_total_number_of_records( lines(  lt_topstyles ) ).


  ENDMETHOD.


  METHOD get_topcallouts_ovp.

    DATA lt_callout_data TYPE STANDARD TABLE OF ZCE_TopCalloutsOvp.

    "Get change Type category
    SELECT change_type1, change_type2, change_type3
    FROM zpo_tracking
    WHERE call_out = 'Y'
    INTO TABLE @DATA(lt_changetype).

    LOOP AT lt_changetype ASSIGNING FIELD-SYMBOL(<lfs_type>).

      IF <lfs_type>-change_type1 IS NOT INITIAL.

        READ TABLE lt_callout_data ASSIGNING FIELD-SYMBOL(<lfs_data>)
        WITH KEY topcallout = <lfs_type>-change_type1.
        IF sy-subrc NE 0.
          APPEND VALUE #( TopCallout = <lfs_type>-change_type1 Styles = '2' Status = 'Accepted' ) TO lt_callout_data.
        ENDIF.

      ENDIF.

      IF <lfs_type>-change_type2 IS NOT INITIAL.

        READ TABLE lt_callout_data ASSIGNING <lfs_data>
        WITH KEY topcallout = <lfs_type>-change_type2.
        IF sy-subrc NE 0.
          APPEND VALUE #( TopCallout = <lfs_type>-change_type2 Styles = '3' Status = 'Accepted' ) TO lt_callout_data.
        ENDIF.

      ENDIF.

      IF <lfs_type>-change_type3 IS NOT INITIAL.

        READ TABLE lt_callout_data ASSIGNING <lfs_data>
        WITH KEY topcallout = <lfs_type>-change_type3.
        IF sy-subrc NE 0.
          APPEND VALUE #( TopCallout = <lfs_type>-change_type3 Styles = '5' Status = 'Pending' ) TO lt_callout_data.
        ENDIF.

      ENDIF.

    ENDLOOP.


*    lt_callout_data = VALUE #( ( TopCallout = 'Update Cost' Styles = '2' Status = 'Accepted' )
*                               ( TopCallout = 'Update NDC - Change OMOD' Styles = '5' Status = 'Accepted' ) ).
**                               ( TopCallout = 'Update Qty' Styles = '3' Status = 'Pending' )
**                               ( TopCallout = 'Update Cost' Styles = '1' Status = 'Not Accepted' ) ).

    io_response->set_data( lt_callout_data ).

    io_response->set_total_number_of_records( lines( lt_callout_data ) ).

  ENDMETHOD.


  METHOD get_navigation_output.

    DATA:
      lt_business_data TYPE TABLE OF z_otr_purchaseordersitems_erp=>tys_header,
      lo_http_client   TYPE REF TO if_web_http_client,
      lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
      lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
      lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.

    DATA:
      lo_filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
      lo_filter_node_1    TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_2    TYPE REF TO /iwbep/if_cp_filter_node,
      lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node.

    DATA lt_purchasing_doc TYPE RANGE OF zpo_number.
    DATA lt_factory_vendor TYPE RANGE OF zotr_factory_vendor.
    DATA business_data_external TYPE TABLE OF ZCE_PurchaseOrderItemsERP.
    DATA ls_data_external TYPE ZCE_PurchaseOrderItemsERP.
    DATA lv_internal_property TYPE /iwbep/if_cp_runtime_types=>ty_property_path.

    DATA(top)     = CONV i( io_request->get_paging( )->get_page_size( ) ).
    DATA(skip)    = CONV i( io_request->get_paging( )->get_offset( ) ).


    TRY.

        "pass po to get records from on-premise
        " Create http client
        DATA(http_destination) = cl_http_destination_provider=>create_by_cloud_destination(
                                   i_name                  = 'DF1' " 'RETAIL_QA_FE'
                                   i_authn_mode            = if_a4c_cp_service=>service_specific
                                 ).

        lo_http_client = cl_web_http_client_manager=>create_by_http_destination( http_destination ).

        lo_client_proxy = /iwbep/cl_cp_factory_remote=>create_v2_remote_proxy(
          EXPORTING
             is_proxy_model_key       = VALUE #( repository_id       = 'DEFAULT'
                                                 proxy_model_id      = 'Z_OTR_PURCHASEORDERSITEMS_ERP'
                                                 proxy_model_version = '0001' )
            io_http_client             = lo_http_client
            iv_relative_service_root   = '/sap/opu/odata/sap/YTEST_SMART_MERCHENDISE_SRV/' ).

        ASSERT lo_http_client IS BOUND.

        " Navigate to the resource and create a request for the read operation
        lo_request = lo_client_proxy->create_resource_for_entity_set( 'HEADER_SET' )->create_request_for_read( ).

**********************************************************************
        lo_filter_factory = lo_request->create_filter_factory( ).

*        lt_purchasing_doc = VALUE #( ( sign = 'I' option = 'EQ' low = '5100000521' ) ).
        lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = iv_property_name
                                                                it_range             =  it_filter_condition ).

        lo_filter_node_root = lo_filter_node_1.
        lo_request->set_filter( lo_filter_node_root ).
**********************************************************************
        IF top GT 0.
          lo_request->set_top( top ).
        ENDIF.
        IF skip GT 0.
          lo_request->set_skip( skip ).
        ENDIF.


        " Execute the request and retrieve the business data
        lo_response = lo_request->execute( ).
        lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).


        LOOP AT lt_business_data INTO DATA(lwa_data).
          APPEND VALUE #( sign = 'I' option = 'EQ' low = lwa_data-purchasing_doc ) TO lt_purchasing_doc.
        ENDLOOP.

        "pass po and color code get callout data

        SELECT *
        FROM zpo_tracking
        WHERE po_number IN @lt_purchasing_doc
        AND   call_out = 'Y'
        INTO TABLE @DATA(lt_business_data_btp).

        LOOP AT lt_business_data_btp ASSIGNING FIELD-SYMBOL(<business_data_btp>).
          ls_data_external-actual_cut_date = <business_data_btp>-actual_cut_date.
          ls_data_external-actual_daily_op = <business_data_btp>-actual_daily_op.
          ls_data_external-actual_inhouse_date = <business_data_btp>-actual_inhouse_date.
          ls_data_external-call_out = <business_data_btp>-call_out.
          ls_data_external-change_type1 = <business_data_btp>-change_type1.
          ls_data_external-change_type2 = <business_data_btp>-change_type2.
          ls_data_external-change_type3 = <business_data_btp>-change_type3.
          ls_data_external-china_submit_date = <business_data_btp>-china_submit_date.
          ls_data_external-cost_option = <business_data_btp>-cost_option.
          ls_data_external-days_complete = <business_data_btp>-days_complete.
          ls_data_external-otr_program = <business_data_btp>-otr_program.
          ls_data_external-plan_daily_op = <business_data_btp>-plan_daily_op.
          ls_data_external-plan_prod_date = <business_data_btp>-plan_prod_date.
          ls_data_external-planned_cut_date = <business_data_btp>-planned_cut_date.
          ls_data_external-pm_pp_comment = <business_data_btp>-pm_pp_comment.
          ls_data_external-priority_list = <business_data_btp>-priority_list.
          ls_data_external-proposed_mod = <business_data_btp>-proposed_mod.
          ls_data_External-proposed_ndc = <business_data_btp>-proposed_ndc.
          ls_data_External-region = <business_data_btp>-region.
          ls_data_External-regional_comment = <business_data_btp>-regional_comment.
          ls_data_external-req_ndc_date = <business_data_btp>-req_ndc_date.
          ls_data_external-req_shipmode = <business_data_btp>-req_shipmode.
          ls_data_external-vendor_comment = <business_data_btp>-vendor_comment.
          ls_data_external-x_fty_date = <business_data_btp>-x_fty_date.
          ls_data_external-shippable_qty = <business_data_btp>-shippable_qty.
          ls_data_external-sewing_bal_qty = <business_data_btp>-sewing_bal_qty.
          ls_data_external-sewing_com_qty = <business_data_btp>-sewing_com_qty.

          READ TABLE lt_business_data ASSIGNING FIELD-SYMBOL(<business_data>)
           WITH KEY purchasing_doc = <business_data_btp>-po_number
                    color_code = <business_data_btp>-color_code.
          IF sy-subrc EQ 0.
            ls_data_external-Brand = <business_data>-brand.
            ls_data_external-BuyStrategy = <business_data>-buy_strategy.
            ls_data_external-Category = <business_data>-category.
            ls_data_external-ColorCode = <business_data>-color_code.
            ls_data_external-CompanyCode = <business_data>-company_code.
            ls_data_external-FactoryVendor = <business_data>-factory_vendor.
            CONVERT TIME STAMP <business_data>-floorset_date TIME ZONE 'UTC' INTO DATE ls_data_external-FloorsetDate.
            ls_data_external-OrderReason = <business_data>-order_reason.
            ls_data_external-PlmId = <business_data>-plm_id.
            ls_data_external-PurchasingDoc = <business_data>-purchasing_doc.
            ls_data_external-SeasonCode = <business_data>-season_code.
            ls_data_external-order_qty = <business_data>-order_quantity.
            ls_data_external-image_url = <business_data>-image_url.
            ls_data_external-FactoryVendorName = <business_data>-factory_vendor_name.
            ls_data_external-Variant = <business_data>-variant.
          ENDIF.

          APPEND ls_data_External TO business_data_external.
        ENDLOOP.


        io_response->set_total_number_of_records( lines( business_data_external ) ).
        io_response->set_data( business_data_external ).

      CATCH /iwbep/cx_cp_remote INTO DATA(lx_remote).
        " Handle remote Exception
        " It contains details about the problems of your http(s) connection

      CATCH /iwbep/cx_gateway INTO DATA(lx_gateway).
        " Handle Exception

      CATCH cx_web_http_client_error INTO DATA(lx_web_http_client_error).
        " Handle Exception
        RAISE SHORTDUMP lx_web_http_client_error.

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
