@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Callout Drop Down'
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_CALLOUT_DROPDOWN
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name:'ZCALLOUT_VH' )
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
