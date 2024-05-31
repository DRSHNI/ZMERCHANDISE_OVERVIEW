@EndUserText.label: 'Purchase Order Tracking by Vendor'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_PurchaseOrderTracking
  provider contract transactional_query
  as projection on ZI_PurchaseOrderTracking
{
  key PoNumber,
  key ColorCode,
      OtrProgram,
      FactoryVendor,
      ReqShipmode,
      ReqNdcDate,
      ProposedMod,
      ProposedNdc,
      CallOut,
      VendorComment,
      PmPpComment,
      RegionalComment,
      ChangeType1,
      ChangeType2,
      ChangeType3,
      Region,
      CostOption,
      PriorityList,
      ActualInhouseDate,
      PlannedCutDate,
      ActualCutDate,
      PlanProdDate,
      DaysComplete,
      PlanDailyOp,
      ActualDailyOp,
      ChinaSubmitDate,
      XFtyDate,
      Uom,
      ShippableQty,
      SewingCompleteQty,
      SewingBalQty
      
//      _PurchaseOrderERP.PurchasingDoc,
//      _PurchaseOrderERP.ColorCode as ColorCode1
}
