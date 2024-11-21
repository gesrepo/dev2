global class LogisticsCommon {
	
    public static Integer GetWeight(Quote__c qte, String mode)
    {
    	Double TotWeight = 0;
    	
        //If Weight Override is specified, use that. Otherwise, check if
        //Dim Weight is greater than Crated Weight. If so, use Dim Weight
        //otherwise use Crated Weight
        if (qte.Weight_Override__c == null || qte.Weight_Override__c <= 0)
        {
        	if (mode.toUpperCase() == 'AIR')
        	{
	        	if (qte.Dim_Weight__c != null && qte.Crated_Weight__c != null)
	        	{
	        		if (qte.Dim_Weight__c > qte.Crated_Weight__c)
	        		{
	        			TotWeight = qte.Dim_Weight__c;
	        		}
	        		else
	        		{
	        			TotWeight = qte.Crated_Weight__c;
	        		}
	        	}
	        	else if (qte.Dim_Weight__c == null && qte.Crated_Weight__c != null)
	        		TotWeight = qte.Crated_Weight__c.intValue();
	        	else if (qte.Crated_Weight__c == null && qte.Dim_Weight__c != null)
	        		TotWeight = qte.Dim_Weight__c.intValue();	        	
        	}
        	else
        	{
        		if (qte.Crated_Weight__c != null)
        			TotWeight = qte.Crated_Weight__c;
        	}
        }
        else
        {
        	TotWeight = qte.Weight_Override__c.intValue();
        }
        
        return Math.Round(TotWeight); 	
    }
    
    public static String getFirst5OfExhibitorName(Quote__c qte)
    {
    	String ExhibitorName = '';
    	
        if (qte.Account_Id__c != null)
        {
        	if (qte.Account_Id__r.Name != null && qte.Account_Id__r.Name.length() > 5)
        		ExhibitorName = qte.Account_Id__r.Name.substring(0,5);
        	else
        		ExhibitorName = qte.Account_Id__r.Name;
        }
            
		return ExhibitorName;
    }
    
    public static String getMMDDYYDate(date d)
    {
    	String PickupDate = '';
    	
        if (d != null)
        { 
        	String Month = (d.month() <= 9 ? '0'+ String.valueOf(d.month()) : String.valueOf(d.month()));
        	String Day = (d.day() <= 9 ? '0'+ String.valueOf(d.day()) : String.valueOf(d.day()));
        	String Year = (String.valueOf(d.year())).substring(2,4);
        	
        	PickupDate = Month + Day + Year;
        } 
        
        return PickupDate;   	
    }
    
    public static String getCertificateName(string customSettingName) {
    	
    	String CertName = '';
    	
    	GES_Logistics_Certificate_Name__c CertCustSetting = [Select Certificate_Name__c From GES_Logistics_Certificate_Name__c Where Active__c = true And Name = :customSettingName];
    	
    	CertName = CertCustSetting.Certificate_Name__c;
    	
    	return CertName;
    }

}