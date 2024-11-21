public with sharing class CCGESLinksListController {
    
    private static List<GES_Lookup__c> GESLinks;
    private static List<GES_Lookup__c> CarrierLinks;
    private static List<GES_Lookup__c> GESEmployeeLinks;
    
    public CCGESLinksListController() {
    }
    
    // Return a list of records 
    public List<GES_Lookup__c> getGESLinks() {
        
        if (GESLinks == null)
        {
            GESLinks = new List<GES_Lookup__c >();
            
            for(GES_Lookup__c l : GES_Lookup__c.getAll().values())
            {
                if (l.Type__c.toUpperCase() == 'GES_NSC_LINK')
                    GESLinks.add(l);
            }  
        }
        GESLinks.sort();  
        return GESLinks;
    }
    
    public List<GES_Lookup__c> getCarrierLinks() {
        
        if (CarrierLinks == null)
        {
            CarrierLinks = new List<GES_Lookup__c >();
            
            for(GES_Lookup__c l : GES_Lookup__c.getAll().values())
            {
                if (l.Type__c.toUpperCase() == 'LOGISTICS_CARRIER')
                    CarrierLinks.add(l);
            }  
        }
        CarrierLinks.sort();
        return CarrierLinks;
    }
    
    public List<GES_Lookup__c> getGESEmployeeLinks() {
        
        if (GESEmployeeLinks == null)
        {
            GESEmployeeLinks = new List<GES_Lookup__c >();
            
            for(GES_Lookup__c l : GES_Lookup__c.getAll().values())
            {
                if (l.Type__c.toUpperCase() == 'GES_NSC_EMP_LINK')
                    GESEmployeeLinks.add(l);
            }  
        }
        GESEmployeeLinks.sort();  
        return GESEmployeeLinks;
    }
    
}