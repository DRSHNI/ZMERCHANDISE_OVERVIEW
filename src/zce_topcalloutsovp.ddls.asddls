@EndUserText.label: 'Merchandise Top Callouts Overview'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_PO_TRACKING_DATA'
define custom entity ZCE_TopCalloutsOvp
{
 @Consumption.semanticObject: 'PurchaseOrder'
      @UI.identification: [{ type: #FOR_INTENT_BASED_NAVIGATION,
                       semanticObjectAction: 'TrackReport'}]

      @UI        : {
            selectionField: [{ position: 10 }],
            lineItem      : [{ position: 10 }]
         }
      @EndUserText.label: 'Top Callouts'
  key TopCallout : abap.string;
      @UI        : {
          selectionField: [{ position: 20 }],
          lineItem      : [{ position: 20 }]
       }
      @EndUserText.label: 'No. of Styles'
      Styles     : abap.int4;
      @UI        : {
      selectionField: [{ position: 30 }],
      lineItem   :    [{ position: 30 }]
      }
      @EndUserText.label: 'Status'
      Status     : abap.char( 20 );

}
