@EndUserText.label: 'Purchase Volume by Product Category'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_PO_TRACKING_DATA'
@UI.chart: [
{ 
  qualifier: 'ByProductCategory',
  title: 'Merchandise Volume By Product Category',
  chartType: #DONUT,
  dimensions:  ['Category'],
  measures:  ['Quantity'],
  dimensionAttributes: [{ dimension: 'Category', role: #CATEGORY  }],
  measureAttributes: [{ measure: 'Quantity', role: #AXIS_1, asDataPoint: true }]
 
 }]

define custom entity ZCE_PurchaseVolumeOVP
{

      @Consumption.semanticObject: 'PurchaseOrder'
      @UI.identification: [{ type: #FOR_INTENT_BASED_NAVIGATION,
                       semanticObjectAction: 'TrackReport'}]
      @EndUserText.label: 'Purchasing Document'
      @UI.lineItem: [{position: 10, label: 'Purchasing Document', qualifier: 'ByProductCategory'}]
  key PurchasingDoc     : abap.char( 10 );
      @EndUserText.label: 'Flex Color Code'
      @UI.lineItem: [{position: 20, label: 'Color Code', qualifier: 'ByProductCategory'}]
  key ColorCode         : abap.char( 4 );
      @EndUserText.label: 'Vendor'
      @ObjectModel.text.element: [ 'FactoryVendorName' ]
      @UI.textArrangement: #TEXT_ONLY
      @UI.lineItem: [{position: 30, label: 'Vendor', qualifier: 'ByProductCategory'}]
      FactoryVendor     : abap.char( 10 );
      @UI.hidden        : true
      FactoryVendorName : abap.char( 35 );
      @EndUserText.label: 'Category'
      @UI.lineItem: [{position: 40, label: 'Category', qualifier: 'ByProductCategory'}]
      Category          : abap.char(40);
      @Semantics.unitOfMeasure: true
      Uom               : abap.unit( 3 );
      @Semantics.quantity.unitOfMeasure: 'Uom'
      //@DefaultAggregation: #SUM
      @Aggregation.default: #SUM
     
       @UI.dataPoint:{
                visualization: #NUMBER,
                title: 'Quantity',
                criticalityCalculation:{
                improvementDirection: #TARGET,
                deviationRangeHighValue: 2000, // Just Playing around with some numbers here...
                toleranceRangeLowValue: 50 // Just Playing around with some numbers here...
              }
         }
      @UI.lineItem: [{position: 50, label: 'Quantity', qualifier: 'ByProductCategory', type: #AS_DATAPOINT}]
      Quantity          : abap.quan( 13, 2 );
      
}
