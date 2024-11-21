@isTest
public class wwwViadComV2MockImpl implements WebServiceMock {
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

    System.debug(LoggingLevel.INFO, 'wwwViadComV2MockImpl .doInvoke() - ' +
      '\n request: ' + request +
      '\n response: ' + response +
      '\n endpoint: ' + endpoint +
      '\n soapAction: ' + soapAction +
      '\n requestName: ' + requestName +
      '\n responseNS: ' + responseNS +
      '\n responseName: ' + responseName +
      '\n responseType: ' + responseType);
      
    if(request instanceOf wwwViadComV2.GetOperationsZones_element) {
      response.put( 'response_x', new wwwViadComV2.GetOperationsZonesResponse_element());
    }   
    
          else if(request instanceOf wwwViadComV2.GetProjectByProjectNumber_element) {
              
              
              wwwViadComV2.BoothAreaDiscount boothDiscountObj = new wwwViadComV2.BoothAreaDiscount();
              boothDiscountObj.BoothAreaId = 1001;
              boothDiscountObj.DiscountId = 10;
              
              List<wwwViadComV2.BoothAreaDiscount> boothDiscountList = new List<wwwViadComV2.BoothAreaDiscount>();
              boothDiscountList.add(boothDiscountObj);
              
              wwwViadComV2.ArrayOfBoothAreaDiscount arrayBoothDiscount = new wwwViadComV2.ArrayOfBoothAreaDiscount();
              arrayBoothDiscount.BoothAreaDiscount = boothDiscountList;
              
              
              wwwViadComV2.BoothArea boothAreaObj = new wwwViadComV2.BoothArea();
              boothAreaObj.Area = 'Test_MISC_FURNITURE';
              boothAreaObj.BoothAreaId = 1001;
              boothAreaObj.CompletionDateTime = System.Today();
              boothAreaObj.Discounts = arrayBoothDiscount;
              boothAreaObj.Deleteable = false;
              boothAreaObj.Editable = true;
              boothAreaObj.GroupOrdersByCategory = true;
              boothAreaObj.GroupOrdersByParent = true;
              boothAreaObj.ShowToCustomer = false;
            
              wwwViadComV2.BoothArea boothAreaObj3 = new wwwViadComV2.BoothArea();
              boothAreaObj3.Area = 'Test03_MISC_FURNITURE';
              boothAreaObj3.BoothAreaId = 1002;
              boothAreaObj3.CompletionDateTime = System.Today();
              boothAreaObj3.Discounts = arrayBoothDiscount;
              boothAreaObj3.Deleteable = false;
              boothAreaObj3.Editable = true;
              boothAreaObj3.GroupOrdersByCategory = true;
              boothAreaObj3.GroupOrdersByParent = true;
              boothAreaObj3.ShowToCustomer = false;
              
              
              List<wwwViadComV2.BoothArea> boothAreaList = new List<wwwViadComV2.BoothArea>();
              boothAreaList.add(boothAreaObj);
             // boothAreaList.add(boothAreaObj2);
              boothAreaList.add(boothAreaObj3);
                          
              wwwViadComV2.ArrayOfBoothArea boothAreaArray =  new wwwViadComV2.ArrayOfBoothArea();
              boothAreaArray.BoothArea = boothAreaList;
             
                      
              wwwViadComV2.GetProjectByProjectNumberResponse_element result = new wwwViadComV2.GetProjectByProjectNumberResponse_element();
              result.GetProjectByProjectNumberResult= new wwwViadComV2.ShowProject();
              result.GetProjectByProjectNumberResult.showOccrProjectId = 1;
              result.GetProjectByProjectNumberResult.BoothAreas = boothAreaArray;
              response.put( 'response_x', result);
          }
          
    else if(request instanceOf wwwViadComV2.DeleteBoothArea_element) {
            wwwViadComV2.DeleteBoothAreaResponse_element result = new wwwViadComV2.DeleteBoothAreaResponse_element();
            result.DeleteBoothAreaResult= new wwwViadComV2.BoothArea();
            result.DeleteBoothAreaResult.BoothAreaId = 1;
      response.put( 'response_x', result);
    }
    
    else if(request instanceOf wwwViadComV2.DeleteBoothAreaDiscount_element) {
            wwwViadComV2.DeleteBoothAreaDiscountResponse_element result = new wwwViadComV2.DeleteBoothAreaDiscountResponse_element();
            result.DeleteBoothAreaDiscountResult= new wwwViadComV2.BoothAreaDiscount();
            result.DeleteBoothAreaDiscountResult.DiscountId = 1;
      response.put( 'response_x', result);
    }
    else if(request instanceOf wwwViadComV2.SubmitBoothArea_element) {
            wwwViadComV2.SubmitBoothAreaResponse_element result = new wwwViadComV2.SubmitBoothAreaResponse_element();
            result.SubmitBoothAreaResult = new wwwViadComV2.BoothArea();
            result.SubmitBoothAreaResult.Area = 'Test area';
      response.put( 'response_x', result);
    } 
    else if(request instanceOf wwwViadComV2.UpdateBoothArea_element) {
            wwwViadComV2.UpdateBoothAreaResponse_element result = new wwwViadComV2.UpdateBoothAreaResponse_element();
            result.UpdateBoothAreaResult = new wwwViadComV2.BoothArea();
            result.UpdateBoothAreaResult.Area = 'Test address';
      response.put( 'response_x', result);
    } 
    else if(request instanceOf wwwViadComV2.UpdateBoothAreaDiscount_element) {
            wwwViadComV2.UpdateBoothAreaDiscountResponse_element result = new wwwViadComV2.UpdateBoothAreaDiscountResponse_element();
            result.UpdateBoothAreaDiscountResult = new wwwViadComV2.BoothAreaDiscount();
            result.UpdateBoothAreaDiscountResult.BoothAreaId = 1;
      response.put( 'response_x', result);
    } 
     else if(request instanceOf wwwViadComV2.SubmitBoothAreaDiscount_element) {
            wwwViadComV2.SubmitBoothAreaDiscountResponse_element result = new wwwViadComV2.SubmitBoothAreaDiscountResponse_element();
            result.SubmitBoothAreaDiscountResult = new wwwViadComV2.BoothAreaDiscount();
            result.SubmitBoothAreaDiscountResult.BoothAreaId = 1;
          response.put( 'response_x', result);
    } 
     else if(request instanceOf CORE_V1.GetShowOrgProducts_element) {
            CORE_V1.GetShowOrgProductsResponse_element result = new CORE_V1.GetShowOrgProductsResponse_element();
            result.GetShowOrgProductsResult = new CORE_V1.ArrayOfShowOrgParentCategory ();
            result.GetShowOrgProductsResult.ShowOrgParentCategory = new List<CORE_V1.ShowOrgParentCategory>();
            
            CORE_V1.ShowOrgParentCategory product = new CORE_V1.ShowOrgParentCategory();
            product.Name ='Labor';
            
           
            result.GetShowOrgProductsResult.ShowOrgParentCategory.add(product); 

            response.put( 'response_x', result);
        }
    }
  
    }