   CLASS ltc_helper DEFINITION FOR TESTING CREATE PRIVATE.
     PUBLIC SECTION.
       CLASS-DATA:
         mo_client_proxy      TYPE REF TO /iwbep/if_cp_client_proxy,
         cds_test_environment TYPE REF TO if_cds_test_environment,
         sql_test_environment TYPE REF TO if_osql_test_environment,

         comments_mock_data   TYPE STANDARD TABLE OF zpo_comment WITH EMPTY KEY,

         begin_date           TYPE /dmo/begin_date,
         end_date             TYPE /dmo/end_date.

       CLASS-METHODS:
         helper_class_setup RAISING cx_static_check,
         helper_class_teardown,
         helper_setup,
         helper_teardown.
   ENDCLASS.

   CLASS ltc_helper IMPLEMENTATION.
     METHOD helper_class_setup.

       " create client proxy
       mo_client_proxy = cl_web_odata_client_factory=>create_v2_local_proxy(
                                               VALUE #( service_id      = 'ZUI_PO_ERP_TRACKING_O2'
                                                        service_version = '0001' ) ).

       " create the test doubles for the underlying CDS entities
       cds_test_environment = cl_cds_test_environment=>create_for_multiple_cds(
                         i_for_entities = VALUE #(
                           ( i_for_entity = 'ZI_PurchaseOrderComment'  i_select_base_dependencies = abap_true ) ) ).

       " create the test doubles for referenced and additional used tables.
       "sql_test_environment = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( 'ZPO_COMMENT' ) ) ).

       " prepare test data
       GET TIME STAMP FIELD DATA(lv_current_time_stamp).
       comments_mock_data   = VALUE #( ( po_number = '5100000521'
                                         color_code = '2D7I'
                                         created_on = lv_current_time_stamp
                                         created_by = cl_abap_context_info=>get_user_technical_name( )
                                         comments = 'Comment2' ) ).



     ENDMETHOD.

     METHOD helper_class_teardown.
       " remove test doubles
       cds_test_environment->destroy(  ).
       "sql_test_environment->destroy(  ).
     ENDMETHOD.

     METHOD helper_setup.
       " clear test doubles
       "sql_test_environment->clear_doubles(  ).
       cds_test_environment->clear_doubles(  ).
       " insert test data into test doubles
       cds_test_environment->insert_test_data( comments_mock_data ).
     ENDMETHOD.

     METHOD helper_teardown.
       " clean up any involved entity
       ROLLBACK ENTITIES.
     ENDMETHOD.
   ENDCLASS.

   "!@testing SRVB:ZUI_PO_ERP_TRACKING_O2
   CLASS ltc_CREATE DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
     PRIVATE SECTION.
       CLASS-METHODS:
         class_setup RAISING cx_static_check,
         class_teardown.

       METHODS:
         setup,
         teardown,
         create FOR TESTING RAISING cx_static_check.

   ENDCLASS.


   CLASS ltc_CREATE IMPLEMENTATION.
     METHOD class_setup.
       ltc_helper=>helper_class_setup( ).
     ENDMETHOD.

     METHOD class_teardown.
       ltc_helper=>helper_class_teardown( ).
     ENDMETHOD.

     METHOD setup.
       ltc_helper=>helper_setup( ).
     ENDMETHOD.

     METHOD teardown.
       ltc_helper=>helper_teardown( ).
     ENDMETHOD.

     METHOD create.

       " prepare business data, i.e. the travel instance test data
       DATA(ls_comment) = ltc_helper=>comments_mock_data[ 1 ].
       DATA(ls_business_data) = VALUE ZI_PurchaseOrderComment(
              PurchasingDoc     = ls_comment-po_number
              ColorCode = ls_comment-color_code
              CreatedOn = ls_comment-created_on
              CreatedBy = ls_comment-created_by
              Comments = ls_comment-comments
               ).

       " create a request for the create operation
       DATA(lo_request) = ltc_helper=>mo_client_proxy->create_resource_for_entity_set( 'Comment' )->create_request_for_create( ).

       " set the business data for the created entity
       lo_request->set_business_data( ls_business_data ).

       " execute the request
       DATA(lo_response) = lo_request->execute( ).

       cl_abap_unit_assert=>assert_not_initial( lo_response ).

       DATA ls_response_data TYPE ZI_PurchaseOrderComment.
       lo_response->get_business_data( IMPORTING es_business_data = ls_response_data ).

*       " assert the description from the response
*       cl_abap_unit_assert=>assert_equals( msg = 'description from response'    act = ls_response_data-description   exp = ls_business_data-description ).
*       " assert that the overall travel status has been set to 'open' from the response
*       cl_abap_unit_assert=>assert_equals( msg = 'overall status from response' act = ls_response_data-OverallStatus exp = 'O'  ).
*
*       " read the created travel entity
*       READ ENTITIES OF ZRAP400_C_Travel_####
*         ENTITY Travel
*           FIELDS ( description OverallStatus )
*             WITH VALUE #( ( TravelID = ls_response_data-TravelID ) )
*           RESULT DATA(lt_read_travel)
*           FAILED DATA(failed)
*           REPORTED DATA(reported).
*
*       " assert data retrieved via READ ENTITIES
*       cl_abap_unit_assert=>assert_initial( msg = 'travel from read' act = failed ).
*       cl_abap_unit_assert=>assert_equals( msg = 'description from read'    act = lt_read_travel[ 1 ]-description   exp = ls_business_data-description ).
*       " assert that the initial value of overall travel status has been set to 'open'
*       cl_abap_unit_assert=>assert_equals( msg = 'overall status from read' act = lt_read_travel[ 1 ]-OverallStatus exp = 'O'  ).
*
*       " assert data also from database
*       SELECT * FROM zrap400_trav#### WHERE travel_id = @ls_response_data-TravelID
*         INTO TABLE @DATA(lt_travel).
*       cl_abap_unit_assert=>assert_not_initial( msg = 'travel from db'    act = lt_travel ).
*       cl_abap_unit_assert=>assert_equals( msg = 'description from db'    act = lt_travel[ 1 ]-description    exp = ls_business_data-description ).
*       cl_abap_unit_assert=>assert_equals( msg = 'overall status from db' act = lt_travel[ 1 ]-overall_status exp = 'O'  ).

     ENDMETHOD.
   ENDCLASS.


*   CLASS ltc_CREATE DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
*
*   PRIVATE SECTION.
*
*
*     METHODS: setup RAISING cx_static_check,
*       create FOR TESTING RAISING cx_static_check.
*
*   ENDCLASS.
*
*   CLASS ltc_CREATE IMPLEMENTATION.
*
*
*   METHOD create.
*     DATA:
*       ls_business_data TYPE ZI_PurchaseOrderComment,
*       lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
*       lo_request       TYPE REF TO /iwbep/if_cp_request_create,
*       lo_response      TYPE REF TO /iwbep/if_cp_response_create.
*
*
*     lo_client_proxy = /iwbep/cl_cp_factory_unit_tst=>create_v2_local_proxy(
*                     EXPORTING
*                       is_service_key     = VALUE #( service_id      = 'ZUI_PO_ERP_TRACKING_O2'
*
*                                                     service_version = '0001' )
*                        iv_do_write_traces = abap_true ).
*
*
** Prepare business data
*     ls_business_data = VALUE #(
*               purchasingdoc    = 'Purchasingdoc'
*               v_purchasingdoc  = 'VPurchasingdoc'
*               colorcode        = 'Colorcode'
*               v_colorcode      = 'VColorcode'
*               createdon        = 20170101123000
*               v_createdon      = 'VCreatedon'
*               comments         = 'Comments'
*               v_comments       = 'VComments'
*               createdby        = 'Createdby'
*               v_createdby      = 'VCreatedby' ).
*
*     " Navigate to the resource and create a request for the create operation
*     lo_request = lo_client_proxy->create_resource_for_entity_set( 'Comment' )->create_request_for_create( ).
*
*     " Set the business data for the created entity
*     lo_request->set_business_data( ls_business_data ).
*
*     " Execute the request
*     lo_response = lo_request->execute( ).
*
*     " Get the after image
**lo_response->get_business_data( IMPORTING es_business_data = ls_business_data ).
*
*     cl_abap_unit_assert=>fail( 'Implement your assertions' ).
*   ENDMETHOD.
*
*   ENDCLASS.
*
*   "!@testing SRVB:ZUI_PO_ERP_TRACKING_O2
*   CLASS ltc_READ_ENTITY DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
*
*   PRIVATE SECTION.
*
*
*     METHODS: setup RAISING cx_static_check,
*       read_entity FOR TESTING RAISING cx_static_check.
*
*   ENDCLASS.
*
*   CLASS ltc_READ_ENTITY IMPLEMENTATION.
*
*
*   METHOD read_entity.
*     DATA:
*       ls_entity_key    TYPE <structure_name>,
*       ls_business_data TYPE <structure_name>,
*       lo_resource      TYPE REF TO /iwbep/if_cp_resource_entity,
*       lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
*       lo_request       TYPE REF TO /iwbep/if_cp_request_read,
*       lo_response      TYPE REF TO /iwbep/if_cp_response_read.
*
*
*
*     lo_client_proxy = /iwbep/cl_cp_factory_unit_tst=>create_v2_local_proxy(
*                     EXPORTING
*                       is_service_key     = VALUE #( service_id      = 'ZUI_PO_ERP_TRACKING_O2'
*
*                                                     service_version = '0001' )
*                        iv_do_write_traces = abap_true ).
*
*
*     " Set entity key
*     ls_entity_key = VALUE #(
*               purchasingdoc  = 'Purchasingdoc'
*               colorcode      = 'Colorcode'
*               createdon      = 20170101123000 ).
*
*     " Navigate to the resource
*     lo_resource = lo_client_proxy->create_resource_for_entity_set( 'Comment' )->navigate_with_key( ls_entity_key ).
*
*     " Execute the request and retrieve the business data
*     lo_response = lo_resource->create_request_for_read( )->execute( ).
*     lo_response->get_business_data( IMPORTING es_business_data = ls_business_data ).
*
*     cl_abap_unit_assert=>fail( 'Implement your assertions' ).
*   ENDMETHOD.
*
*   ENDCLASS.
*
*   "!@testing SRVB:ZUI_PO_ERP_TRACKING_O2
*   CLASS ltc_READ_LIST DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
*
*   PRIVATE SECTION.
*
*
*     METHODS: setup RAISING cx_static_check,
*       read_list FOR TESTING RAISING cx_static_check.
*
*   ENDCLASS.
*
*   CLASS ltc_READ_LIST IMPLEMENTATION.
*
*
*   METHOD read_list.
*     DATA:
*       lt_business_data TYPE TABLE OF <structure_name>,
*       lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
*       lo_request       TYPE REF TO /iwbep/if_cp_request_read_list,
*       lo_response      TYPE REF TO /iwbep/if_cp_response_read_lst.
*
**DATA:
** lo_filter_factory   TYPE REF TO /iwbep/if_cp_filter_factory,
** lo_filter_node_1    TYPE REF TO /iwbep/if_cp_filter_node,
** lo_filter_node_2    TYPE REF TO /iwbep/if_cp_filter_node,
** lo_filter_node_root TYPE REF TO /iwbep/if_cp_filter_node,
** lt_range_PURCHASINGDOC TYPE RANGE OF zpo_number,
** lt_range_V_PURCHASINGDOC TYPE RANGE OF sadl_gw_value_crtl_property.
*
*
*
*     lo_client_proxy = /iwbep/cl_cp_factory_unit_tst=>create_v2_local_proxy(
*                     EXPORTING
*                       is_service_key     = VALUE #( service_id      = 'ZUI_PO_ERP_TRACKING_O2'
*
*                                                     service_version = '0001' )
*                        iv_do_write_traces = abap_true ).
*
*
*     " Navigate to the resource and create a request for the read operation
*     lo_request = lo_client_proxy->create_resource_for_entity_set( 'Comment' )->create_request_for_read( ).
*
*     " Create the filter tree
**lo_filter_factory = lo_request->create_filter_factory( ).
**
**lo_filter_node_1  = lo_filter_factory->create_by_range( iv_property_path     = 'PURCHASINGDOC'
**                                                        it_range             = lt_range_PURCHASINGDOC ).
**lo_filter_node_2  = lo_filter_factory->create_by_range( iv_property_path     = 'V_PURCHASINGDOC'
**                                                        it_range             = lt_range_V_PURCHASINGDOC ).
*
**lo_filter_node_root = lo_filter_node_1->and( lo_filter_node_2 ).
**lo_request->set_filter( lo_filter_node_root ).
*
*     lo_request->set_top( 50 )->set_skip( 0 ).
*
*     " Execute the request and retrieve the business data
*     lo_response = lo_request->execute( ).
*     lo_response->get_business_data( IMPORTING et_business_data = lt_business_data ).
*
*     cl_abap_unit_assert=>fail( 'Implement your assertions' ).
*   ENDMETHOD.
*
*   ENDCLASS.
*
*   "!@testing SRVB:ZUI_PO_ERP_TRACKING_O2
*   CLASS ltc_UPDATE DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
*
*   PRIVATE SECTION.
*
*
*     METHODS: setup RAISING cx_static_check,
*       update FOR TESTING RAISING cx_static_check.
*
*   ENDCLASS.
*
*   CLASS ltc_UPDATE IMPLEMENTATION.
*
*
*   METHOD update.
*     DATA:
*       ls_business_data TYPE <structure_name>,
*       ls_entity_key    TYPE <structure_name>,
*       lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
*       lo_resource      TYPE REF TO /iwbep/if_cp_resource_entity,
*       lo_request       TYPE REF TO /iwbep/if_cp_request_update,
*       lo_response      TYPE REF TO /iwbep/if_cp_response_update.
*
*
*
*     lo_client_proxy = /iwbep/cl_cp_factory_unit_tst=>create_v2_local_proxy(
*                     EXPORTING
*                       is_service_key     = VALUE #( service_id      = 'ZUI_PO_ERP_TRACKING_O2'
*
*                                                     service_version = '0001' )
*                        iv_do_write_traces = abap_true ).
*
*
*     " Set entity key
*     ls_entity_key = VALUE #(
*               purchasingdoc  = 'Purchasingdoc'
*               colorcode      = 'Colorcode'
*               createdon      = 20170101123000 ).
*
*     " Prepare the business data
*     ls_business_data = VALUE #(
*               purchasingdoc    = 'Purchasingdoc'
*               v_purchasingdoc  = 'VPurchasingdoc'
*               colorcode        = 'Colorcode'
*               v_colorcode      = 'VColorcode'
*               createdon        = 20170101123000
*               v_createdon      = 'VCreatedon'
*               comments         = 'Comments'
*               v_comments       = 'VComments'
*               createdby        = 'Createdby'
*               v_createdby      = 'VCreatedby' ).
*
*     " Navigate to the resource and create a request for the update operation
*     lo_resource = lo_client_proxy->create_resource_for_entity_set( 'Comment' )->navigate_with_key( ls_entity_key ).
*     lo_request = lo_resource->create_request_for_update( /iwbep/if_cp_request_update=>gcs_update_semantic-put ).
*
*
*     lo_request->set_business_data( ls_business_data ).
*
*     " Execute the request and retrieve the business data
*     lo_response = lo_request->execute( ).
*
*     " Get updated entity
**CLEAR ls_business_data.
**lo_response->get_business_data( importing es_business_data = ls_business_data ).
*     cl_abap_unit_assert=>fail( 'Implement your assertions' ).
*   ENDMETHOD.
*
*   ENDCLASS.
*
*   "!@testing SRVB:ZUI_PO_ERP_TRACKING_O2
*   CLASS ltc_DELETE_ENTITY DEFINITION FINAL FOR TESTING DURATION SHORT RISK LEVEL HARMLESS.
*
*   PRIVATE SECTION.
*
*
*     METHODS: setup RAISING cx_static_check,
*       delete_entity FOR TESTING RAISING cx_static_check.
*
*   ENDCLASS.
*
*   CLASS ltc_DELETE_ENTITY IMPLEMENTATION.
*
*
*   METHOD delete_entity.
*     DATA:
*       ls_entity_key    TYPE <structure_name>,
*       ls_business_data TYPE <structure_name>,
*       lo_resource      TYPE REF TO /iwbep/if_cp_resource_entity,
*       lo_client_proxy  TYPE REF TO /iwbep/if_cp_client_proxy,
*       lo_request       TYPE REF TO /iwbep/if_cp_request_delete.
*
*
*     lo_client_proxy = /iwbep/cl_cp_factory_unit_tst=>create_v2_local_proxy(
*                     EXPORTING
*                       is_service_key     = VALUE #( service_id      = 'ZUI_PO_ERP_TRACKING_O2'
*
*                                                     service_version = '0001' )
*                        iv_do_write_traces = abap_true ).
*
*
*     "Set entity key
*     ls_entity_key = VALUE #(
*               purchasingdoc  = 'Purchasingdoc'
*               colorcode      = 'Colorcode'
*               createdon      = 20170101123000 ).
*
*     "Navigate to the resource and create a request for the delete operation
*     lo_resource = lo_client_proxy->create_resource_for_entity_set( 'Comment' )->navigate_with_key( ls_entity_key ).
*     lo_request = lo_resource->create_request_for_delete( ).
*
*
*     " Execute the request
*     lo_request->execute( ).
*
*     cl_abap_unit_assert=>fail( 'Implement your assertions' ).
*   ENDMETHOD.
*
*   ENDCLASS.
