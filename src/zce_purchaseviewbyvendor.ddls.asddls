@EndUserText.label: 'Purchase Quantity by Vendor Category'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_PO_TRACKING_DATA'
@UI.chart: [
{ qualifier: 'ByProductVendor',
  title: 'Merchandise Volume By Vendor Category',
  chartType: #DONUT,
//  dimensionAttributes: [
// { dimension: 'Category', role: #CATEGORY  } ],
  measureAttributes: [{ measure: 'Quantity', role: #AXIS_1, asDataPoint: true }]
}]

define custom entity ZCE_PurchaseViewByVendor
{
      @EndUserText.label: 'Purchasing Document'
  key PurchasingDoc     : abap.char( 10 );
      @EndUserText.label: 'Flex Color Code'
  key ColorCode         : abap.char( 4 );
      @EndUserText.label: 'Vendor'
  key FactoryVendor     : abap.char( 10 );
      //      @UI.hidden        : true
      @EndUserText.label: 'Factory Vendor Name'
      @ObjectModel.text.element: [ 'FactoryVendorName' ]
      @UI.textArrangement: #TEXT_ONLY
      FactoryVendorName : abap.char( 35 );
      @Semantics.quantity.unitOfMeasure: 'Uom'
      @Aggregation.default: #SUM
      @UI.dataPoint.visualization: #NUMBER
      Quantity          : abap.quan( 13, 2 );
      @Semantics.unitOfMeasure: true
      Uom               : abap.unit( 3 );
}
