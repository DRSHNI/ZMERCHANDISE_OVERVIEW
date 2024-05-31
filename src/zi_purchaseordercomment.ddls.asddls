@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PO Comment'
define view entity ZI_PurchaseOrderComment
  as select from zpo_comment
  association        to parent ZCE_PurchaseOrderItemsERP as _Header    on  $projection.PurchasingDoc = _Header.PurchasingDoc
                                                                       and $projection.ColorCode     = _Header.ColorCode
  association [1..1] to ZI_PurchaseOrderTrackingUser     as _UserImage on  $projection.CreatedBy = _UserImage.Users

  association [1..1] to I_User                           as _User      on  $projection.CreatedBy = _User.UserID
{
  key        po_number             as PurchasingDoc,
  key        color_code            as ColorCode,
  key        created_on            as CreatedOn,
             comments              as Comments,
             @ObjectModel.text.element: [ 'CreatedByName' ]
             created_by            as CreatedBy,
             @Semantics.text: true
             _User.UserDescription as CreatedByName,
             _UserImage.ImageUrl   as ImageUrl,
             //_Header.ImageURL as ProductImage,
             _Header,
             _UserImage,
             _User
             //_header : redirected to parent ZC_SuperSessionChoice
}
