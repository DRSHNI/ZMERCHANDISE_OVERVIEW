@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Tracking BO'
define root view entity ZI_PurchaseOrderTracking
  as select from zpo_tracking as PurchaseOrderBTP
  association [1..1] to ZCE_PurchaseOrderItemsERP as _PurchaseOrderERP on  $projection.PoNumber  = _PurchaseOrderERP.PurchasingDoc
                                                                       and $projection.ColorCode = _PurchaseOrderERP.ColorCode
  //composition of target_data_source_name as _association_name
{
  key po_number           as PoNumber,
  key color_code          as ColorCode,
      otr_program         as OtrProgram,
      factory_vendor      as FactoryVendor,
      req_shipmode        as ReqShipmode,
      req_ndc_date        as ReqNdcDate,
      proposed_mod        as ProposedMod,
      proposed_ndc        as ProposedNdc,
      call_out            as CallOut,
      vendor_comment      as VendorComment,
      pm_pp_comment       as PmPpComment,
      regional_comment    as RegionalComment,
      change_type1        as ChangeType1,
      change_type2        as ChangeType2,
      change_type3        as ChangeType3,
      region              as Region,
      cost_option         as CostOption,
      priority_list       as PriorityList,
      actual_inhouse_date as ActualInhouseDate,
      planned_cut_date    as PlannedCutDate,
      actual_cut_date     as ActualCutDate,
      plan_prod_date      as PlanProdDate,
      days_complete       as DaysComplete,
      plan_daily_op       as PlanDailyOp,
      actual_daily_op     as ActualDailyOp,
      china_submit_date   as ChinaSubmitDate,
      x_fty_date          as XFtyDate,
      uom                 as Uom,
      shippable_qty       as ShippableQty,
      sewing_com_qty      as SewingCompleteQty,
      sewing_bal_qty      as SewingBalQty,
      _PurchaseOrderERP
      //  _association_name // Make association public
}
