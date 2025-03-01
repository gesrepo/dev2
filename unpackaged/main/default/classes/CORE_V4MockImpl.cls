//Generated by FuseIT WSDL2Apex (http://www.fuseit.com/Solutions/SFDC-Explorer/Help-WSDL-Parser.aspx)

@isTest
public class CORE_V4MockImpl implements WebServiceMock {
    public void doInvoke(
            Object stub,
            Object request,
            Map<String, Object> response,
            String endpoint,
            String soapAction,
            String requestName,
            String responseNS,
            String responseName,
            String responseType) {
       
        System.debug(LoggingLevel.INFO, 'CORE_V4MockImpl.doInvoke() - ' +
            '\n request: ' + request +
            '\n response: ' + response +
            '\n endpoint: ' + endpoint +
            '\n soapAction: ' + soapAction +
            '\n requestName: ' + requestName +
            '\n responseNS: ' + responseNS +
            '\n responseName: ' + responseName +
            '\n responseType: ' + responseType);

        if(request instanceOf CORE_V4.GetShowOrgProducts_element) {
            response.put( 'response_x', new CORE_V4.GetShowOrgProductsResponse_element());
        }
        else if(request instanceOf CORE_V4.SearchProducts_element) {
            response.put( 'response_x', new CORE_V4.SearchProductsResponse_element());
        }
        else if(request instanceOf CORE_V4.GetShowOrgDiscounts_element) {
           response.put( 'response_x', new CORE_V4.GetShowOrgDiscountsResponse_element());
        }
        else if(request instanceOf CORE_V4.SearchProductGroups_element) {
           response.put( 'response_x', new CORE_V4.SearchProductGroupsResponse_element());
        }
        else if(request instanceOf CORE_V4.UpdateProductStockLevel_element) {
           response.put( 'response_x', new CORE_V4.UpdateProductStockLevelResponse_element());
        }
        else if(request instanceOf CORE_V4.GetShowProduct_element) {
           response.put( 'response_x', new CORE_V4.GetShowProductResponse_element());
        }
        else if(request instanceOf CORE_V4.GetShowProductGroups_element) {
           response.put( 'response_x', new CORE_V4.GetShowProductGroupsResponse_element());
        }
        else if(request instanceOf CORE_V4.GetShowOrgSpecialProducts_element) {
           response.put( 'response_x', new CORE_V4.GetShowOrgSpecialProductsResponse_element());
        }
        else if(request instanceOf CORE_V4.DeactivateShowOrgSpecialProduct_element) {
           response.put( 'response_x', new CORE_V4.DeactivateShowOrgSpecialProductResponse_element());
        }        
    }
}