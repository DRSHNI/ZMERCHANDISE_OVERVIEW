"! <p class="shorttext synchronized" lang="en">Consumption model for client proxy - generated</p>
"! This class has been generated based on the metadata with namespace
"! <em>YTEST_SMART_MERCHENDISE_SRV</em>
CLASS z_otr_purchaseordersitems_erp DEFINITION
  PUBLIC
  INHERITING FROM /iwbep/cl_v4_abs_pm_model_prov
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      "! <p class="shorttext synchronized" lang="en">Header</p>
      BEGIN OF tys_header,
        "! FactoryVendorName
        factory_vendor_name   TYPE c LENGTH 35,
        "! FloorsetDate
        floorset_date         TYPE timestampl,
        "! Brand
        brand                 TYPE c LENGTH 40,
        "! OrderQuantity
        order_quantity        TYPE c LENGTH 13,
        "! Category
        category              TYPE c LENGTH 40,
        "! Site
        site                  TYPE c LENGTH 4,
        "! CompanyCode
        company_code          TYPE c LENGTH 4,
        "! Uom
        uom                   TYPE c LENGTH 3,
        "! PurchasingGrp
        purchasing_grp        TYPE c LENGTH 3,
        "! <em>Key property</em> PurchasingDoc
        purchasing_doc        TYPE c LENGTH 10,
        "! GenericStyle
        generic_style         TYPE c LENGTH 18,
        "! ImageUrl
        image_url             TYPE c LENGTH 255,
        "! Variant
        variant               TYPE c LENGTH 18,
        "! PlmId
        plm_id                TYPE c LENGTH 50,
        "! <em>Key property</em> ColorCode
        color_code            TYPE c LENGTH 4,
        "! SizeDimention1
        size_dimention_1      TYPE c LENGTH 5,
        "! SizeDimention2
        size_dimention_2      TYPE c LENGTH 5,
        "! FactoryVendor
        factory_vendor        TYPE c LENGTH 10,
        "! PlannedDeliveryDate
        planned_delivery_date TYPE timestampl,
        "! PoItem
        po_item               TYPE c LENGTH 5,
        "! OrderReason
        order_reason          TYPE c LENGTH 30,
        "! DeltionIndication
        deltion_indication    TYPE c LENGTH 1,
        "! SeasonCode
        season_code           TYPE c LENGTH 18,
        "! BuyStrategy
        buy_strategy          TYPE c LENGTH 10,
        "! NetWeight
        net_weight            TYPE c LENGTH 13,
        "! GrossWeight
        gross_weight          TYPE c LENGTH 13,
        "! Volume
        volume                TYPE c LENGTH 13,
      END OF tys_header,
      "! <p class="shorttext synchronized" lang="en">List of Header</p>
      tyt_header TYPE STANDARD TABLE OF tys_header WITH DEFAULT KEY.


    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Internal Names of the entity sets</p>
      BEGIN OF gcs_entity_set,
        "! HeaderSet
        "! <br/> Collection of type 'Header'
        header_set TYPE /iwbep/if_cp_runtime_types=>ty_entity_set_name VALUE 'HEADER_SET',
      END OF gcs_entity_set .

    CONSTANTS:
      "! <p class="shorttext synchronized" lang="en">Internal names for entity types</p>
      BEGIN OF gcs_entity_type,
         "! Dummy field - Structure must not be empty
         dummy TYPE int1 VALUE 0,
      END OF gcs_entity_type.


    METHODS /iwbep/if_v4_mp_basic_pm~define REDEFINITION.


  PRIVATE SECTION.

    "! <p class="shorttext synchronized" lang="en">Model</p>
    DATA mo_model TYPE REF TO /iwbep/if_v4_pm_model.


    "! <p class="shorttext synchronized" lang="en">Define Header</p>
    "! @raising /iwbep/cx_gateway | <p class="shorttext synchronized" lang="en">Gateway Exception</p>
    METHODS def_header RAISING /iwbep/cx_gateway.

ENDCLASS.



CLASS Z_OTR_PURCHASEORDERSITEMS_ERP IMPLEMENTATION.


  METHOD /iwbep/if_v4_mp_basic_pm~define.

    mo_model = io_model.
    mo_model->set_schema_namespace( 'YTEST_SMART_MERCHENDISE_SRV' ).

    def_header( ).

  ENDMETHOD.


  METHOD def_header.

    DATA:
      lo_complex_property    TYPE REF TO /iwbep/if_v4_pm_cplx_prop,
      lo_entity_type         TYPE REF TO /iwbep/if_v4_pm_entity_type,
      lo_entity_set          TYPE REF TO /iwbep/if_v4_pm_entity_set,
      lo_navigation_property TYPE REF TO /iwbep/if_v4_pm_nav_prop,
      lo_primitive_property  TYPE REF TO /iwbep/if_v4_pm_prim_prop.


    lo_entity_type = mo_model->create_entity_type_by_struct(
                                    iv_entity_type_name       = 'HEADER'
                                    is_structure              = VALUE tys_header( )
                                    iv_do_gen_prim_props         = abap_true
                                    iv_do_gen_prim_prop_colls    = abap_true
                                    iv_do_add_conv_to_prim_props = abap_true ).

    lo_entity_type->set_edm_name( 'Header' ) ##NO_TEXT.


    lo_entity_set = lo_entity_type->create_entity_set( 'HEADER_SET' ).
    lo_entity_set->set_edm_name( 'HeaderSet' ) ##NO_TEXT.


    lo_primitive_property = lo_entity_type->get_primitive_property( 'FACTORY_VENDOR_NAME' ).
    lo_primitive_property->set_edm_name( 'FactoryVendorName' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 35 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FLOORSET_DATE' ).
    lo_primitive_property->set_edm_name( 'FloorsetDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 7 ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BRAND' ).
    lo_primitive_property->set_edm_name( 'Brand' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ORDER_QUANTITY' ).
    lo_primitive_property->set_edm_name( 'OrderQuantity' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 13 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'CATEGORY' ).
    lo_primitive_property->set_edm_name( 'Category' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 40 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SITE' ).
    lo_primitive_property->set_edm_name( 'Site' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COMPANY_CODE' ).
    lo_primitive_property->set_edm_name( 'CompanyCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'UOM' ).
    lo_primitive_property->set_edm_name( 'Uom' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PURCHASING_GRP' ).
    lo_primitive_property->set_edm_name( 'PurchasingGrp' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 3 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PURCHASING_DOC' ).
    lo_primitive_property->set_edm_name( 'PurchasingDoc' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'GENERIC_STYLE' ).
    lo_primitive_property->set_edm_name( 'GenericStyle' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 18 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'IMAGE_URL' ).
    lo_primitive_property->set_edm_name( 'ImageUrl' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 255 ).
    lo_primitive_property->set_scale_floating( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'VARIANT' ).
    lo_primitive_property->set_edm_name( 'Variant' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 18 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLM_ID' ).
    lo_primitive_property->set_edm_name( 'PlmId' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 50 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'COLOR_CODE' ).
    lo_primitive_property->set_edm_name( 'ColorCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 4 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_key( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SIZE_DIMENTION_1' ).
    lo_primitive_property->set_edm_name( 'SizeDimention1' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 5 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SIZE_DIMENTION_2' ).
    lo_primitive_property->set_edm_name( 'SizeDimention2' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 5 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'FACTORY_VENDOR' ).
    lo_primitive_property->set_edm_name( 'FactoryVendor' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PLANNED_DELIVERY_DATE' ).
    lo_primitive_property->set_edm_name( 'PlannedDeliveryDate' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'DateTimeOffset' ) ##NO_TEXT.
    lo_primitive_property->set_precision( 7 ).
    lo_primitive_property->set_is_nullable( ).
    lo_primitive_property->set_edm_type_v2( 'DateTime' ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'PO_ITEM' ).
    lo_primitive_property->set_edm_name( 'PoItem' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 5 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'ORDER_REASON' ).
    lo_primitive_property->set_edm_name( 'OrderReason' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 30 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'DELTION_INDICATION' ).
    lo_primitive_property->set_edm_name( 'DeltionIndication' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 1 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'SEASON_CODE' ).
    lo_primitive_property->set_edm_name( 'SeasonCode' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 18 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'BUY_STRATEGY' ).
    lo_primitive_property->set_edm_name( 'BuyStrategy' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 10 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'NET_WEIGHT' ).
    lo_primitive_property->set_edm_name( 'NetWeight' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 13 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'GROSS_WEIGHT' ).
    lo_primitive_property->set_edm_name( 'GrossWeight' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 13 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

    lo_primitive_property = lo_entity_type->get_primitive_property( 'VOLUME' ).
    lo_primitive_property->set_edm_name( 'Volume' ) ##NO_TEXT.
    lo_primitive_property->set_edm_type( 'String' ) ##NO_TEXT.
    lo_primitive_property->set_max_length( 13 ).
    lo_primitive_property->set_scale_floating( ).
    lo_primitive_property->set_is_nullable( ).

  ENDMETHOD.
ENDCLASS.
