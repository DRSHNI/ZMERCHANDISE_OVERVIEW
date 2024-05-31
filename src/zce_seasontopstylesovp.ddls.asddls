@EndUserText.label: 'Merchandise Top Styles Overview'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_PO_TRACKING_DATA'
define custom entity ZCE_SeasonTopStylesOvp
{
      @Consumption.semanticObject: 'PurchaseOrder'
      @UI.identification: [{ type: #FOR_INTENT_BASED_NAVIGATION,
                       semanticObjectAction: 'TrackReport'}]

      @UI               : {
            selectionField: [{ position: 10 }],
            lineItem    : [{ position: 10 }]
         }
      @EndUserText.label: 'Factory Vendor Name'
      @ObjectModel.text.element: [ 'FactoryVendorName' ]
      @UI.textArrangement: #TEXT_ONLY
  key FactoryVendorName : abap.char( 35 );

      @UI.hidden        : true
      @UI               : {
            selectionField: [{ position: 20 }],
            lineItem    : [{ position: 20 }]
         }
      @EndUserText.label: 'Season'
  key Season            : abap.char( 10 );


      @UI               : {
          selectionField: [{ position: 30 }],
          lineItem      : [{ position: 30 }]
       }
      @EndUserText.label: 'No. of Callouts'
      call_out          : abap.int4;
      @UI               : {
      selectionField    : [{ position: 40 }],
       lineItem         : [{ position: 40}]

      //      lineItem      :    [{ position: 40, criticality: 'Criticality'}]
      }
      @EndUserText.label: 'Risk Status'
      RiskStatus        : abap.char( 20 );

      @UI               : {
      selectionField    : [{ position: 50 }],
      lineItem          : [{ position: 50 }]
      }
      @EndUserText.label: 'Vendor'
      FactoryVendor     : abap.char( 10 );

}
