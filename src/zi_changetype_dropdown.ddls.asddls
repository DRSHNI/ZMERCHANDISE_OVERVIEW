@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Change type Drop Down'
@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZI_CHANGETYPE_DROPDOWN
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZOTR_CALLOUT_VH' )
{
      @UI.hidden: true
  key domain_name,
      @UI.hidden: true
  key value_position,
      @UI.hidden: true
  key language,
      @ObjectModel.text.element: [ 'text' ]
      value_low,
      @Semantics.text: true
      text
}
