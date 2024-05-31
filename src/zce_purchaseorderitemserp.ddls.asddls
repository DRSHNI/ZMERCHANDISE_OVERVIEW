@ObjectModel.query.implementedBy: 'ABAP:ZCL_PO_TRACKING_DATA'
@EndUserText.label: 'ERP Purchase Order Items'
@UI.headerInfo.typeName : 'Purchase Order'
@UI.headerInfo.title.value: 'PurchasingDoc'
@UI.headerInfo.description.value : 'ColorCode'
@UI.headerInfo.imageUrl: 'image_url'


define root custom entity ZCE_PurchaseOrderItemsERP
  //association [0..*] to zpo_comment as _comments
  //                          on $projection.PoNumber = _comments.po_number
  //                          and $projection.ColorCode = _comments.color_code
{

      @UI.facet           : [ { id:          'POItems',
                 purpose  :         #STANDARD,
                 type     :            #IDENTIFICATION_REFERENCE,
                 label    :           'Purchasing Document',
                 position :        10 } ]

      @UI                 : {
            selectionField: [{ position: 10 }],
            lineItem      : [{ position: 10 }]

         }
      @EndUserText.label  : 'Purchasing Document Number'
  key PurchasingDoc       : abap.char( 10 );
      @UI                 : {
            selectionField: [{ position: 20 }],
            lineItem      : [{ position: 20 }]

         }
      @EndUserText.label  : 'Flex Color Code'
  key ColorCode           : abap.char( 4 );

      @Semantics.imageUrl : true
      @UI.lineItem        : [{ position: 1 }]

      @EndUserText.label  : 'Image URL'
      image_url           : abap.char( 255 );

      @UI                 : {
                selectionField: [{ position: 35 }],
                lineItem  : [{ position: 35 }]

             }
      @EndUserText.label  : 'Factory Vendor Name'
      FactoryVendorName   : abap.char( 35 );


      @UI.lineItem        : [{ position:40 }]
      @UI.identification  : [{ position:40 }]
      @EndUserText.label  : 'Department Code'
      CompanyCode         : abap.char( 4 );

      @UI.lineItem        : [{ position:50 }]
      @UI.identification  : [{ position:50 }]
      @EndUserText.label  : 'Generic Article #'
      Variant             : abap.char( 18 );

      @UI.lineItem        : [{ position:60 }]
      @UI.identification  : [{ position:60 }]
      @EndUserText.label  : 'Flex/ Proto #'
      PlmId               : abap.char( 50 );

      @UI.lineItem        : [{ position:70 }]
      @UI.identification  : [{ position:70 }]
      @EndUserText.label  : 'Original Fty SAP #'
      FactoryVendor       : abap.char( 10 );

      @UI.hidden          : true
      @Semantics.unitOfMeasure: true
      uom                 : abap.unit( 3 );

      @UI.lineItem        : [{ position:80 }]
      @UI.identification  : [{ position:80 }]
      @EndUserText.label  : 'Order Qty'
      @Semantics.quantity.unitOfMeasure: 'uom'
      order_qty           : abap.quan( 13, 3 );

      @UI.lineItem        : [{ position:90 }]
      @UI.identification  : [{ position:90 }]
      @EndUserText.label  : 'ORC'
      OrderReason         : abap.char( 30 );

      @UI.lineItem        : [{ position:100 }]
      @UI.identification  : [{ position:100 }]
      @EndUserText.label  : 'Buy Strategy'
      BuyStrategy         : abap.char( 10 );


      @UI.selectionField  : [{ position:30 }]
      @UI.lineItem        : [{ position:110 }]
      @UI.identification  : [{ position:110 }]
      @EndUserText.label  : 'Season'
      SeasonCode          : abap.char( 18 );


      @UI.lineItem        : [{ position:120 }]
      @UI.identification  : [{ position:120 }]
      @EndUserText.label  : 'Shippable Quantity'
      @Semantics.quantity.unitOfMeasure: 'uom'
      shippable_qty       : abap.quan( 13, 3 );

      @UI.lineItem        : [{ position:130 }]
      @UI.identification  : [{ position:130 }]
      @EndUserText.label  : 'Requested Ship Mode'
      req_shipmode        : abap.char( 20 );

      @UI.lineItem        : [{ position:140 }]
      @UI.identification  : [{ position:140 }]
      @EndUserText.label  : 'Floorset'
      FloorsetDate        : abap.dats;

      @UI.lineItem        : [{ position:150 }]
      @UI.identification  : [{ position:150 }]
      @EndUserText.label  : 'Initial Brand Requested NDC'
      req_ndc_date        : abap.dats;

      @UI.lineItem        : [{ position:160 }]
      @UI.identification  : [{ position:160 }]
      @EndUserText.label  : 'Proposed MOD (GAC)'
      proposed_mod        : abap.dats;

      @UI.lineItem        : [{ position:170 }]
      @UI.identification  : [{ position:170 }]
      @EndUserText.label  : 'Proposed NDC'
      proposed_ndc        : abap.dats;

      @UI.lineItem        : [{ position:180 }]
      @UI.identification  : [{ position:180 }]
      @EndUserText.label  : 'Call Out (Y)'
      @Consumption.valueHelpDefinition: [{ entity:{name: 'ZI_CALLOUT_DROPDOWN', element: 'text' } }]
      call_out            : abap.char( 5 );

      @UI.lineItem        : [{ position:190 }]
      @UI.identification  : [{ position:190 }]
      @EndUserText.label  : 'Vendor Comments'
      vendor_comment      : abap.string;

      @UI.lineItem        : [{ position:200 }]
      @UI.identification  : [{ position:200 }]
      @EndUserText.label  : 'PM/PP Comments'
      pm_pp_comment       : abap.string;

      @UI.lineItem        : [{ position:210 }]
      @UI.identification  : [{ position:210 }]
      @EndUserText.label  : 'Regional Comments'
      regional_comment    : abap.string;

      @UI.lineItem        : [{ position:220 }]
      @UI.identification  : [{ position:220 }]
      @EndUserText.label  : 'Change Type 1'
      @Consumption.valueHelpDefinition: [{ entity:{name: 'ZI_CHANGETYPE_DROPDOWN', element: 'text' } }]
      change_type1        : abap.char( 30 );

      @UI.lineItem        : [{ position:230 }]
      @UI.identification  : [{ position:230 }]
      @EndUserText.label  : 'Change Type 2'
      @Consumption.valueHelpDefinition: [{ entity:{name: 'ZI_CHANGETYPE_DROPDOWN', element: 'text' } }]
      change_type2        : abap.char( 30 );

      @UI.lineItem        : [{ position:240 }]
      @UI.identification  : [{ position:240 }]
      @EndUserText.label  : 'Change Type 3'
      @Consumption.valueHelpDefinition: [{ entity:{name: 'ZI_CHANGETYPE_DROPDOWN', element: 'text' } }]
      change_type3        : abap.char( 30 );

      @UI.selectionField  : [{ position:40 }]
      @UI.lineItem        : [{ position:250 }]
      @UI.identification  : [{ position:250 }]
      @EndUserText.label  : 'Brand'
      Brand               : abap.char( 40 );

      @UI.lineItem        : [{ position:260 }]
      @UI.identification  : [{ position:260 }]
      @EndUserText.label  : 'Category'
      Category            : abap.char( 40 );

      @UI.lineItem        : [{ position:270 }]
      @UI.identification  : [{ position:270 }]
      @EndUserText.label  : 'Region'
      region              : abap.char( 5 );

      @UI.lineItem        : [{ position:280 }]
      @UI.identification  : [{ position:280 }]
      @EndUserText.label  : 'Cost Option'
      cost_option         : abap.char( 10 );

      @UI.lineItem        : [{ position:290 }]
      @UI.identification  : [{ position:290 }]
      @EndUserText.label  : 'Priority List'
      priority_list       : abap.char( 1 );

      @UI.lineItem        : [{ position:300 }]
      @UI.identification  : [{ position:300 }]
      @EndUserText.label  : 'Actual Yarn, Fabric & Trim In house Date'
      actual_inhouse_date : abap.dats;

      @UI.lineItem        : [{ position:310 }]
      @UI.identification  : [{ position:310 }]
      @EndUserText.label  : 'Planned Cut Date'
      planned_cut_date    : abap.dats;

      @UI.lineItem        : [{ position:320 }]
      @UI.identification  : [{ position:320 }]
      @EndUserText.label  : 'Actual Cut Date'
      actual_cut_date     : abap.dats;

      @UI.lineItem        : [{ position:330 }]
      @UI.identification  : [{ position:330 }]
      @EndUserText.label  : 'Planned Production Complete Date'
      plan_prod_date      : abap.dats;

      @UI.lineItem        : [{ position:340 }]
      @UI.identification  : [{ position:340 }]
      @EndUserText.label  : 'No of Days to Complete'
      days_complete       : abap.int4;

      @UI.lineItem        : [{ position:350 }]
      @UI.identification  : [{ position:350 }]
      @EndUserText.label  : 'Planned Daily Output (Ave)'
      plan_daily_op       : abap.int4;

      @UI.lineItem        : [{ position:360 }]
      @UI.identification  : [{ position:360 }]
      @EndUserText.label  : 'Actual Daily Output (Previous Day)'
      actual_daily_op     : abap.int4;

      @UI.lineItem        : [{ position:370 }]
      @UI.identification  : [{ position:370 }]
      @EndUserText.label  : 'Sewing Complete Qty'
      @Semantics.quantity.unitOfMeasure: 'uom'
      sewing_com_qty      : abap.quan( 13, 3 );

      @UI.lineItem        : [{ position:380 }]
      @UI.identification  : [{ position:380 }]
      @EndUserText.label  : 'Sewing Bal Qty'
      @Semantics.quantity.unitOfMeasure: 'uom'
      sewing_bal_qty      : abap.quan( 13, 3 );

      @UI.lineItem        : [{ position:390 }]
      @UI.identification  : [{ position:390 }]
      @EndUserText.label  : 'China GB Submit Date'
      china_submit_date   : abap.dats;

      @UI.lineItem        : [{ position:400 }]
      @UI.identification  : [{ position:400 }]
      @EndUserText.label  : 'X- fty Date'
      x_fty_date          : abap.dats;

      @UI.lineItem        : [{ position:410 }]
      @UI.identification  : [{ position:410 }]
      @EndUserText.label  : 'Program'
      otr_program         : abap.char( 30 );


      _comments           : composition [0..*] of ZI_PurchaseOrderComment;

}
