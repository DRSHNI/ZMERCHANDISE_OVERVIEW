@EndUserText.label: 'Merchandise Purchase Overview Filter'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_PO_TRACKING_DATA'
define custom entity ZCE_PurchaseOverviewFilterOVP
{
       @UI                 : {
            selectionField: [{ position: 10 }]}
      @EndUserText.label: 'Factory Vendor'
  key FactoryVendor : abap.char( 10 );
 
}
