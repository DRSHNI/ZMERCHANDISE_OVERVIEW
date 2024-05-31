@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Order Tracking App Users'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_PurchaseOrderTrackingUser
  as select from zpo_user_vendor
{
  key users     as Users,
      vendor_no as VendorNo,
      image_url as ImageUrl
}
