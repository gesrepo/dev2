global with sharing class LogisticsDLSReports {
	/*
	global static Blob InboundDLSReport {get; set;}
	global static Blob OutboundDLSReport {get; set;}
	global static LogisticsQuoteReportService.BasicHttpEndpoint_IDLSReport DLSReport {get; set; }
	global static LogisticsQuoteReportService.ExternalQuote ExQuote {get; set; }
	global static LogisticsQuoteReportService.ArrayOfExternalQuoteLine ArrExQuoteLines { get; set; }
	global static Quote__c q {get; set; }
	global static Freight_Item__c[] arrFI {get; set; }
	global static boolean InReportRequiredFieldsSpecified {get; set; }
	global static boolean OutReportRequiredFieldsSpecified {get; set; }
	
    global class CalloutException extends Exception {        
    }
    
    WebService static void CreateDLSReport(id quoteId)
    {      
        String ErrorMessage = ''; Initialize(quoteId);
        
      	try
      	{	        	        	
	        if (InReportRequiredFieldsSpecified)
	        {
	        	if (CreateInboundReportPreInvoke(quoteId, q, arrFI, DLSReport))
	        	{ InboundDLSReport = CreateInboundReport(DLSReport, ExQuote); }
	        }
			//else
			//	ErrorMessage = 'Minimum fields required for creating BOL report for Inbound Shipment not provided.';
			
				
	        if (OutReportRequiredFieldsSpecified)
			{
	        	if (CreateOutboundReportPreInvoke(quoteId, q, arrFI, DLSReport))
	        	{ OutboundDLSReport = CreateOutboundReport(DLSReport, ExQuote); }			
			}
	        //else
	        //	ErrorMessage = (ErrorMessage != '' ? ErrorMessage + '\n' + 'Minimum fields required for creating BOL report for Outbound Shipment not provided.' : 'Minimum fields required for creating BOL report for Outbound Shipment not provided.');
			
			SaveInboundDLSReport(quoteId, InboundDLSReport); SaveOutboundDLSReport(quoteId, OutboundDLSReport);	
			
      	}
      	finally
      	{
      		q = null; arrFI = null; InboundDLSReport = null; OutboundDLSReport = null; DLSReport = null; ExQuote = null; ArrExQuoteLines = null;
      	}       
    }  
    
    public static void Initialize(Id quoteId)
    {
    	q = LogisticsQuoteObjectMapper.getQuote(quoteId);		
        arrFI = LogisticsQuoteObjectMapper.getFreightItems(quoteId); 
        
        DLSReport = new LogisticsQuoteReportService.BasicHttpEndpoint_IDLSReport();
        
	    InReportRequiredFieldsSpecified = q.Origination_State__c != null && q.Origination_State__c != '' && 
	        	q.Destination_State__c != null && q.Destination_State__c != '' &&
	        	q.Pickup_Date__c != null && q.Delivery_Date__c != null &&
	        	q.Shipment_Type__c != null && q.Shipment_Type__c != '';
	        	
	    OutReportRequiredFieldsSpecified = q.OB_Origination_State__c != null && q.OB_Origination_State__c != '' && 
	        	q.OB_Destination_State__c != null && q.OB_Destination_State__c != '' &&
	        	q.OB_Pickup_Date__c != null && q.OB_Delivery_Date__c != null &&
	        	q.OB_Shipment_Type__c != null && q.OB_Shipment_Type__c != '';
    }
    
    public static boolean CreateInboundReportPreInvoke(id quoteId, Quote__c qte, Freight_Item__c[] fItems, LogisticsQuoteReportService.BasicHttpEndpoint_IDLSReport reportProxy)
    {
    	boolean RetVal = true;
    	
        ExQuote = new LogisticsQuoteReportService.ExternalQuote();
        ArrExQuoteLines = new LogisticsQuoteReportService.ArrayOfExternalQuoteLine();
                
        RetVal = LogisticsQuoteObjectMapper.mapInboundQuoteToExternalQuote(qte, fItems, ExQuote, ArrExQuoteLines);
                
        reportProxy.timeout_x = 60000;
        reportProxy.clientCertName_x = 'GES';
		//reportProxy.clientCert_x = LogisticsQuoteObjectMapper.certificate;
		//reportProxy.clientCertPasswd_x = LogisticsQuoteObjectMapper.password;
		
		return RetVal;
    } 
    
    public static Blob CreateInboundReport(LogisticsQuoteReportService.BasicHttpEndpoint_IDLSReport reportProxy, LogisticsQuoteReportService.ExternalQuote externalQuote)
    {
    	return EncodingUtil.base64Decode(reportProxy.Get(externalQuote));
    }
    
	public static void SaveInboundDLSReport(Id quoteId, Blob report)
	{
        if(report != null)
        {  
            integer Version = 0;

            Attachment[] existingAttachments = [Select Id, Name, CreatedDate From Attachment Where ParentID = :quoteId And Name Like :q.Name + '_DLS%_v%.xlsx' Order By CreatedDate Desc];
            
            try
            {
	            for(Attachment existingAttachment : existingAttachments)
	            {
	                integer verStartPos = existingAttachment.Name.lastIndexOf('_');
	                integer verEndPos = existingAttachment.Name.lastIndexOf('.');
	                
	                if (verStartPos > -1 && verEndPos > -1)
	                {
	                    Version = Integer.valueOf(existingAttachment.Name.subString(verStartPos+2,verEndPos));
	                }
	                break;
	            }
            }
            finally
            {
            	existingAttachments = null;
            }
            
            string inboundReportName = q.Name + '_DLS_Inbound_v' + (Version + 1)+ '.xlsx';
                        
            Attachment attach = new Attachment();
            
            try
            {  
	            attach.Body= report;
	            attach.Name= inboundReportName ;
	            attach.ContentType= 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';  
	            attach.ParentID = quoteId;  
	
	            insert(attach);
            }
            finally
            {
            	attach = null;
            }

        }		
	}    
    
    public static boolean CreateOutboundReportPreInvoke(id quoteId, Quote__c qte, Freight_Item__c[] fItems, LogisticsQuoteReportService.BasicHttpEndpoint_IDLSReport reportProxy)
    {
    	boolean RetVal = true;
    	
        ExQuote = new LogisticsQuoteReportService.ExternalQuote();
        ArrExQuoteLines = new LogisticsQuoteReportService.ArrayOfExternalQuoteLine();
                
        RetVal = LogisticsQuoteObjectMapper.mapOutboundQuoteToExternalQuote(qte, fItems, ExQuote, ArrExQuoteLines);
                
        reportProxy.timeout_x = 60000;
        reportProxy.clientCertName_x = 'GES';
		//reportProxy.clientCert_x = LogisticsQuoteObjectMapper.certificate;
		//reportProxy.clientCertPasswd_x = LogisticsQuoteObjectMapper.password;
		
		return RetVal;
    } 

    public static Blob CreateOutboundReport(LogisticsQuoteReportService.BasicHttpEndpoint_IDLSReport reportProxy, LogisticsQuoteReportService.ExternalQuote externalQuote)
    {
    	return EncodingUtil.base64Decode(reportProxy.Get(externalQuote));
    }
    
    public static void SaveOutboundDLSReport(Id quoteId, Blob report)
    {
        if(report != null)
        {  
            integer Version = 0;

            Attachment[] existingAttachments = [Select Id, Name, CreatedDate From Attachment Where ParentID = :quoteId And Name Like :q.Name + 'A_DLS%_v%.xlsx' Order By CreatedDate Desc];
            
            try
            {
	            for(Attachment existingAttachment : existingAttachments)
	            {
	                integer verStartPos = existingAttachment.Name.lastIndexOf('_');
	                integer verEndPos = existingAttachment.Name.lastIndexOf('.');
	                
	                if (verStartPos > -1 && verEndPos > -1)
	                {
	                    Version = Integer.valueOf(existingAttachment.Name.subString(verStartPos+2,verEndPos));
	                }
	                break;
	            }
            }
            finally
            {
            	existingAttachments = null;
            }
            
            string OutboundReportName = q.Name + 'A_DLS_Outbound_v' + (Version + 1)+ '.xlsx';
                        
            Attachment attach=new Attachment();
            
            try
            {
	            attach.Body= report ;
	            attach.Name= OutboundReportName ;
	            attach.ContentType= 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';  
	            attach.ParentID = quoteId;  
	
	            insert(attach);
            }
            finally
            {
            	attach = null;
            }
        } 
    }
    */
}