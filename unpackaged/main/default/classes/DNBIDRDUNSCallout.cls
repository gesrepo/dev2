public class DNBIDRDUNSCallout 
{
    //Auth callout
    public static AuthorizationResponse getAuthToken()
    {
        list<Auth_Token__c> tokens = [SELECT Id, Name, Auth_Token__c, LastModifiedDate
                                      FROM Auth_Token__c 
                                      WHERE Name = 'DNBIDR'];
        
        AuthorizationResponse authResp = new AuthorizationResponse();
        if(!tokens.isEmpty())
        {
            if(tokens[0].LastModifiedDate.addSeconds(85000) > system.now())
            {
                //Token not expired
                authResp.access_token = tokens[0].Auth_Token__c;
                authResp.mode = 'REUSE';
                return authResp;
            }
            else
            {
                authResp = getToken();
                
                if(authResp.isError){
                    return authResp;
                }
                
                authResp.mode = 'UPDATE';
                return authResp;
            }
        }
        else
        {
            authResp = getToken();
            
            if(authResp.isError){
                return authResp;
            }
            authResp.mode = 'INSERT';
            return authResp;
        }
    }
    private static AuthorizationResponse getToken()
    {
        String username = Client_API_Settings__c.getValues('DNB_IDR_API').Client_API_Key__c;
        String password = Client_API_Settings__c.getValues('DNB_IDR_API').Client_API_Secret__c;
        
        Http http = new Http();    
        HttpRequest authRequest = new HttpRequest();        
        Blob headerValue = Blob.valueOf(userName + ':' + password);
        String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
        authRequest.setEndpoint('https://plus.dnb.com/v2/token');
        authRequest.setHeader('Authorization', authorizationHeader);
        authRequest.setHeader('Content-Type', 'application/json; charset=utf-8');
        authRequest.setMethod('POST');  
        authRequest.setTimeout(120000);
        authRequest.setBody('{ "grant_type" : "client_credentials" }');
        authRequest.setCompressed(true);
        
        HttpResponse authResponse = http.send(authRequest);
        system.debug('authResponse..!'+authResponse);  
        
        AuthorizationResponse authResp = new AuthorizationResponse();
        if(authResponse.getStatusCode() == 200)
        {
            AuthResponse ar = (AuthResponse)JSON.deserialize(authResponse.getBody(), AuthResponse.class);
            authResp.access_token = ar.access_token;
            authResp.expiresIn = ar.expiresIn;
        }
        else
        {
            AuthCalloutFailureResponse ar = (AuthCalloutFailureResponse)JSON.deserialize(authResponse.getBody(), AuthCalloutFailureResponse.class);
            system.debug('ar..!'+ar);
            
            authResp.isError = true;
            authResp.message = ar.error.errorMessage;
        }
        authResp.payload = JSON.serialize(authRequest.getBody());
        return authResp;
    }        
    
    //DUNS Callout
    public static DNBIDRDUNSCalloutResponse getDUNSResponse(CORE_EXHIBITOR__c coreExhibitor, String token)
    {
        String endPoint = 'https://plus.dnb.com/v1/match/cleanseMatch?';
        endPoint += 'name='+coreExhibitor.Company_Name__c;                //mandatory        
        endPoint += (coreExhibitor.Address1__c != 'NO ADDRESS' && coreExhibitor.Address1__c != null) ? '&streetAddressLine1='+ EncodingUtil.urlEncode(coreExhibitor.Address1__c, 'UTF-8') : '';
        endPoint += '&countryISOAlpha2Code='+coreExhibitor.Country__c;        //mandatory
        endPoint += (coreExhibitor.City__c != 'NO CITY' && coreExhibitor.City__c != null) ? '&addressLocality='+coreExhibitor.City__c : '';
        endPoint += (coreExhibitor.State__c != 'NO STATE' && coreExhibitor.State__c != null) ? '&addressRegion='+coreExhibitor.State__c : '';
        endPoint += (coreExhibitor.Postal_Code__c != 'NO ZIP' && coreExhibitor.Postal_Code__c != null) ? '&postalCode='+coreExhibitor.Postal_Code__c : '';
        endPoint += '&candidateMaximumQuantity=1&confidenceLowerLevelThresholdValue=8&isCleanseAndStandardizeInformationRequired=true';
        endPoint = endPoint.replace(' ', '+');        
        system.debug('endPoint..!'+endPoint);
        
        Http http = new Http();
        HttpRequest request = new HttpRequest();        
        request.setEndpoint(endPoint);
        request.setHeader('Authorization', 'Bearer '+token);
        request.setHeader('Content-Type', 'application/json; charset=utf-8');
        request.setMethod('GET');  
        request.setTimeout(120000);
        request.setCompressed(true);
        HttpResponse response = http.send(request);
        system.debug('request..!'+response);  
        
        DNBIDRDUNSCalloutResponse dResp = new DNBIDRDUNSCalloutResponse();
        system.debug('dr raw..!'+response.getBody());
        if(response.getStatusCode() == 200)
        {
            DunsResponse dr = (DunsResponse)JSON.deserialize(response.getBody(), DunsResponse.class);
            system.debug('dr..!'+dr);
            
            dResp.dunsNumber = dr.matchCandidates[0].organization.duns;
            dResp.confidenceCode = dr.matchCandidates[0].matchQualityInformation.confidenceCode;
            dResp.cleanseAndStandardizeInformation = dr.cleanseAndStandardizeInformation;
            return dResp;
        }
        else
        {
            DNBCalloutFailureResponse dr = (DNBCalloutFailureResponse)JSON.deserialize(response.getBody(), DNBCalloutFailureResponse.class);
            system.debug('dr..!'+dr);
            
            dResp.isError = true;
            dResp.message = dr.error.errorMessage;
            dResp.payload = JSON.serialize(request.getBody());
            return dResp;
        }
    }
    
    //Auth Wrappers
    public class AuthCalloutFailureResponse 
    {
        public TransactionDetail transactionDetail;
        public Error error;
    }
    public class Error 
    {
        public String errorMessage;
        public String errorCode;
    }
    
    public class TransactionDetail 
    {
        public String transactionID;
        public String transactionTimestamp;
        public String inLanguage;
        public string serviceVersion;
    }
    public class AuthorizationResponse
    {
        public Boolean isError;
        public string message;
        public string payload;
        public string access_token;
        public Integer expiresIn;
        public string mode;                //possible values are : REUSE, UPDATE, INSERT
        public AuthorizationResponse()
        {
            isError = false;
        }
    }
    public class AuthResponse
    {
        string access_token;
        Integer expiresIn;
    }
    
    //DUNS Wrappers
    public class DNBCalloutFailureResponse 
    {
        public TransactionDetail transactionDetail;
        public Error error;
    }
    
    public class DNBIDRDUNSCalloutResponse
    {
        public Boolean isError;
        public string message;
        public string payload;
        public string dunsNumber;
        public Integer confidenceCode;
        public CleanseAndStandardizeInformation cleanseAndStandardizeInformation;
        public DNBIDRDUNSCalloutResponse()
        {
            isError = false;
            cleanseAndStandardizeInformation = new CleanseAndStandardizeInformation();
        }
    }
    public class DUNSResponse 
    {
        public TransactionDetail transactionDetail;
        public InquiryDetail inquiryDetail;
        public Integer candidatesMatchedQuantity;
        public String matchDataCriteria;
        public List<MatchCandidates> matchCandidates;
        public CleanseAndStandardizeInformation cleanseAndStandardizeInformation;                
    }
    public class MatchCandidates 
    {
        public Integer displaySequence;
        public Organization organization;
        public MatchQualityInformation matchQualityInformation;
    }

    public class PrimaryAddress 
    {
        public AddressCountry addressCountry;
        public AddressLocality addressLocality;
        public WebsiteAddress addressRegion;
        public String postalCode;
        public String postalCodeExtension;
        public StreetAddress streetAddress;
    }

    public class Organization 
    {
        public String duns;
        public List<WebsiteAddress> websiteAddress;
        public DunsControlStatus dunsControlStatus;
        public String primaryName;
        public List<WebsiteAddress> tradeStyleNames;
        public List<WebsiteAddress> telephone;
        public PrimaryAddress primaryAddress;
        public MailingAddress mailingAddress;
        public List<RegistrationNumbers> registrationNumbers;
        public List<MostSeniorPrincipals> mostSeniorPrincipals;
        public Boolean isStandalone;
        public WebsiteAddress corporateLinkage;
    }
    public class Address 
    {
        public String countryISOAlpha2Code;
        public String addressLocality;
        public String addressRegion;
        public String postalCode;
        public StreetAddressLine streetAddressLine;
    }

    public class StreetAddressLine 
    {
        public String line1;
    }

    public class DunsControlStatus 
    {
        public OperatingStatus operatingStatus;
        public Boolean isMailUndeliverable;
    }

    public class AddressLocality 
    {
        public String name;
    }

    public class CleanseAndStandardizeInformation 
    {
        public String standardizedName;
        public StandardizedAddress standardizedAddress;
    }

    public class MailingAddress 
    {
        public AddressCountry addressCountry;
        public WebsiteAddress addressLocality;
        public WebsiteAddress addressRegion;
        public String postalCode;
        public String postalCodeExtension;
        public WebsiteAddress streetAddress;
    }

    public class AddressCountry 
    {
        public String isoAlpha2Code;
        public String name;
    }

    public class MostSeniorPrincipals 
    {
        public String fullName;
    }

    public class WebsiteAddress 
    {
    }

    public class MatchQualityInformation 
    {
        public Integer confidenceCode;
        public String matchGrade;
        public Integer matchGradeComponentsCount;
        public List<MatchGradeComponents> matchGradeComponents;
        public String matchDataProfile;
        public Integer matchDataProfileComponentsCount;
        public List<MatchDataProfileComponents> matchDataProfileComponents;
        public Double nameMatchScore;
    }

    public class OperatingStatus 
    {
        public String description;
        public Integer dnbCode;
    }

    public class StreetAddress 
    {
        public String line1;
        public String line2;
    }

    public class InquiryDetail 
    {
        public String name;
        public Address address;
        public Integer candidateMaximumQuantity;
        public Integer confidenceLowerLevelThresholdValue;
        public Boolean isCleanseAndStandardizeInformationRequired;
    }

    public class StandardizedAddress 
    {
        public AddressCountry addressCountry;
        public AddressLocality addressLocality;
        public AddressRegion addressRegion;
        public WebsiteAddress addressCounty;
        public String postalCode;
        public String postalCodeExtension;
        public StreetAddress streetAddress;
        public String deliveryPointValidationStatus;
        public String deliveryPointValidationCMRAValue;
        public Boolean isInexactAddress;
        public String addressType;
    }
    
    /*
    public class TransactionDetail 
    {
        public String transactionID;
        public String transactionTimestamp;
        public String inLanguage;
        public String serviceVersion;
    }    
    public class Error 
    {
        public String errorMessage;
        public String errorCode;
    }
    */
    public class MatchGradeComponents 
    {
        public String componentType;
        public String componentRating;
    }

    public class MatchDataProfileComponents 
    {
        public String componentType;
        public String componentValue;
    }

    public class AddressRegion 
    {
        public String name;
        public String abbreviatedName;
    }

    public class RegistrationNumbers 
    {
        public String registrationNumber;
        public String typeDescription;
        public Integer typeDnBCode;
    }
}