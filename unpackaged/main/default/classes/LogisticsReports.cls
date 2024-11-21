global class LogisticsReports {
    
    global static Blob InboundLogisticsReport {get; set;}
    global static Blob OutboundLogisticsReport {get; set;}
    global static LogisticsQuoteReportService.BasicHttpEndpoint_ILogisticsReport LogisticsReport {get; set; }
    global static LogisticsQuoteReportService.ExternalQuote ExQuote {get; set; }
    global static LogisticsQuoteReportService.ArrayOfExternalQuoteLine ArrExQuoteLines { get; set; }
    global static Quote__c q {get; set; }
    global static Freight_Item__c[] arrFI {get; set; }
    global static boolean InReportRequiredFieldsSpecified {get; set; }
    global static boolean OutReportRequiredFieldsSpecified {get; set; }
    global static boolean isLightningView = false;
    
    global class CalloutException extends Exception {        
    }
    
    //SFDC-278 - Conversion Create Logistics Report Button - Sajid - 05/27/24
    @AuraEnabled
    public static void CreateLogisticsReportLightning(id quoteId){
        isLightningView = true;
        CreateLogisticsReport(quoteId);
    }
    
    WebService static void CreateLogisticsReport(id QuoteId)
    {      
        String ErrorMessage = ''; Initialize(quoteId);
        
        try
        {                           
            if (InReportRequiredFieldsSpecified)
            {
                if (CreateInboundReportPreInvoke(quoteId, q, arrFI, LogisticsReport))
                { InboundLogisticsReport = CreateInboundReport(LogisticsReport, ExQuote); }
            }
            //else
            //  ErrorMessage = 'Minimum fields required for creating BOL report for Inbound Shipment not provided.';
            
                
            if (OutReportRequiredFieldsSpecified)
            {
                if (CreateOutboundReportPreInvoke(quoteId, q, arrFI, LogisticsReport))
                { OutboundLogisticsReport = CreateOutboundReport(LogisticsReport, ExQuote); }           
            }
            //else
            //  ErrorMessage = (ErrorMessage != '' ? ErrorMessage + '\n' + 'Minimum fields required for creating BOL report for Outbound Shipment not provided.' : 'Minimum fields required for creating BOL report for Outbound Shipment not provided.');
            if(!isLightningView){
                SaveInboundLogisticsReport(quoteId, InboundLogisticsReport); 
                SaveOutboundLogisticsReport(quoteId, OutboundLogisticsReport);
            }else{
                SaveInboundLogisticsReportAsFile(quoteId, InboundLogisticsReport);
                SaveOutboundLogisticsReportAsFile(quoteId, OutboundLogisticsReport);
            }

        }
        finally
        {
            q = null; arrFI = null; InboundLogisticsReport = null; OutboundLogisticsReport = null; LogisticsReport = null; ExQuote = null; ArrExQuoteLines = null;
        }       
    }  
    
    public static void Initialize(Id quoteId)
    {
        q = LogisticsQuoteObjectMapper.getQuote(quoteId);       
        arrFI = LogisticsQuoteObjectMapper.getFreightItems(quoteId); 
        
        LogisticsReport = new LogisticsQuoteReportService.BasicHttpEndpoint_ILogisticsReport();
        
        InReportRequiredFieldsSpecified = q.Origination_State__c != null && q.Origination_State__c != '' && 
                q.Destination_State__c != null && q.Destination_State__c != '' &&
                q.Pickup_Date__c != null && q.Delivery_Date__c != null &&
                q.Shipment_Type__c != null && q.Shipment_Type__c != '';
                
        OutReportRequiredFieldsSpecified = q.OB_Origination_State__c != null && q.OB_Origination_State__c != '' && 
                q.OB_Destination_State__c != null && q.OB_Destination_State__c != '' &&
                q.OB_Pickup_Date__c != null && q.OB_Delivery_Date__c != null &&
                q.OB_Shipment_Type__c != null && q.OB_Shipment_Type__c != '';
    }
    
    public static boolean CreateInboundReportPreInvoke(id quoteId, Quote__c qte, Freight_Item__c[] fItems, LogisticsQuoteReportService.BasicHttpEndpoint_ILogisticsReport reportProxy)
    {
        boolean RetVal = true;
        
        ExQuote = new LogisticsQuoteReportService.ExternalQuote();
        ArrExQuoteLines = new LogisticsQuoteReportService.ArrayOfExternalQuoteLine();
                
        RetVal = LogisticsQuoteObjectMapper.mapInboundQuoteToExternalQuote(qte, fItems, ExQuote, ArrExQuoteLines);
        
        String ShipmentType = '';
        
        if (qte.Shipment_Type__c != null && qte.Shipment_Type__c != '')
        {
        	if (qte.Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION')
        		ShipmentType = 'Air';
        	else
        		ShipmentType = 'Ground';
        }
        
        ExQuote.TotalWeight = LogisticsCommon.GetWeight(qte, ShipmentType);
        
        reportProxy.timeout_x = 60000;
        reportProxy.clientCertName_x = LogisticsCommon.getCertificateName('GES_Logistics_Reports'); //'GES';
        //reportProxy.clientCert_x = LogisticsQuoteObjectMapper.certificate;
        //reportProxy.clientCertPasswd_x = LogisticsQuoteObjectMapper.password;
        
        return RetVal;
    } 
    
    public static Blob CreateInboundReport(LogisticsQuoteReportService.BasicHttpEndpoint_ILogisticsReport reportProxy, LogisticsQuoteReportService.ExternalQuote externalQuote)
    {
        return EncodingUtil.base64Decode(reportProxy.Get(externalQuote));
    }
    
    public static void SaveInboundLogisticsReport(Id quoteId, Blob report)
    {
        if(report != null)
        {  
            String QuoteNumber = '';
            
            if (q.Name != null && q.Name != '')
            	QuoteNumber = String.valueOf(long.valueOf(q.Name));
			
            String ExhibitorName = LogisticsCommon.getFirst5OfExhibitorName(q);
            String PickupDate = LogisticsCommon.getMMDDYYDate(q.Pickup_Date__c);
            
            String NameFormat = QuoteNumber + ' ' + ExhibitorName + ' ' + PickupDate + ' v';
            
            integer Version = 0;

            Attachment[] existingAttachments = [Select Id, Name, CreatedDate From Attachment Where ParentID = :quoteId And Name Like :NameFormat + '%.xlsx' Order By CreatedDate Desc];
            
            try
            {
                for(Attachment existingAttachment : existingAttachments)
                {
                    integer verStartPos = existingAttachment.Name.lastIndexOf(' ');
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
			
            string inboundReportName = NameFormat + (Version + 1)+ '.xlsx';
            
            Attachment attach = new Attachment();
            
            try
            {  
                attach.Body= report;
                attach.Name= inboundReportName ;
                //attach.ContentType= 'application/vnd.ms-excel'; // For .xls
                attach.ContentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'; 
                attach.ParentID = quoteId;  
    
                insert(attach);
            }
            finally
            {
                attach = null;
            }

        }       
    }    
    
    public static boolean CreateOutboundReportPreInvoke(id quoteId, Quote__c qte, Freight_Item__c[] fItems, LogisticsQuoteReportService.BasicHttpEndpoint_ILogisticsReport reportProxy)
    {
        boolean RetVal = true;
        
        ExQuote = new LogisticsQuoteReportService.ExternalQuote();
        ArrExQuoteLines = new LogisticsQuoteReportService.ArrayOfExternalQuoteLine();
                
        RetVal = LogisticsQuoteObjectMapper.mapOutboundQuoteToExternalQuote(qte, fItems, ExQuote, ArrExQuoteLines);
                
        String ShipmentType = '';
        
        if (qte.OB_Shipment_Type__c != null && qte.OB_Shipment_Type__c != '')
        {
        	if (qte.OB_Shipment_Type__c.toUpperCase() == 'AIR TRANSPORTATION')
        		ShipmentType = 'Air';
        	else
        		ShipmentType = 'Ground';
        }
        
        ExQuote.TotalWeight = LogisticsCommon.GetWeight(qte, ShipmentType);
        
        reportProxy.timeout_x = 60000;
        reportProxy.clientCertName_x = LogisticsCommon.getCertificateName('GES_Logistics_Reports'); //'GES';
        //reportProxy.clientCert_x = LogisticsQuoteObjectMapper.certificate;
        //reportProxy.clientCertPasswd_x = LogisticsQuoteObjectMapper.password;
        
        return RetVal;
    } 

    public static Blob CreateOutboundReport(LogisticsQuoteReportService.BasicHttpEndpoint_ILogisticsReport reportProxy, LogisticsQuoteReportService.ExternalQuote externalQuote)
    {
        return EncodingUtil.base64Decode(reportProxy.Get(externalQuote));
    }
    
    public static void SaveOutboundLogisticsReport(Id quoteId, Blob report)
    {
        if(report != null)
        {  
            String QuoteNumber = '';
            
            if (q.Name != null && q.Name != '')
            	QuoteNumber = String.valueOf(long.valueOf(q.Name));
            
            String ExhibitorName = LogisticsCommon.getFirst5OfExhibitorName(q);
            String PickupDate = LogisticsCommon.getMMDDYYDate(q.OB_Pickup_Date__c);
                        
            string NameFormat = QuoteNumber + 'A ' + ExhibitorName + ' ' + PickupDate + ' v';
                    	
            integer Version = 0;

            Attachment[] existingAttachments = [Select Id, Name, CreatedDate From Attachment Where ParentID = :quoteId And Name Like :NameFormat + '%.xlsx' Order By CreatedDate Desc];
            
            try
            {
                for(Attachment existingAttachment : existingAttachments)
                {
                    integer verStartPos = existingAttachment.Name.lastIndexOf(' ');
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
            
            string OutboundReportName = NameFormat + (Version + 1)+ '.xlsx';
            
            Attachment attach=new Attachment();
            
            try
            {
                attach.Body= report ;
                attach.Name= OutboundReportName ;
                //attach.ContentType= 'application/vnd.ms-excel'; //For .xls
                attach.ContentType = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
                attach.ParentID = quoteId;  
    
                insert(attach);
            }
            finally
            {
                attach = null;
            }
        } 
    }
    
    public static void SaveInboundLogisticsReportAsFile(Id quoteId, Blob report){
        if(report != null){  
            String QuoteNumber = '';
            
            if (q.Name != null && q.Name != ''){
                QuoteNumber = String.valueOf(long.valueOf(q.Name));
            }
			
            String ExhibitorName = LogisticsCommon.getFirst5OfExhibitorName(q);
            String PickupDate = LogisticsCommon.getMMDDYYDate(q.Pickup_Date__c);
            
            String NameFormat = QuoteNumber + ' ' + ExhibitorName + ' ' + PickupDate + ' v';
            String inboundReportName = getFileVersion(quoteId,NameFormat);
            insertFileRecord(quoteId,inboundReportName,report);
        }       
    }
    
    public static void SaveOutboundLogisticsReportAsFile(Id quoteId, Blob report){
        if(report != null){
            String QuoteNumber = '';
            if (q.Name != null && q.Name != ''){
                QuoteNumber = String.valueOf(long.valueOf(q.Name));
            }
            
            String ExhibitorName = LogisticsCommon.getFirst5OfExhibitorName(q);
            String PickupDate = LogisticsCommon.getMMDDYYDate(q.OB_Pickup_Date__c);
            
            string NameFormat = QuoteNumber + 'A ' + ExhibitorName + ' ' + PickupDate + ' v';
            String outboundReportName = getFileVersion(quoteId,NameFormat);
            insertFileRecord(quoteId,outboundReportName,report);
        } 
    }
    
    public static String getFileVersion(Id quoteId, String NameFormat){
        integer version = 0;
        Set<String> listCDIds = new Set<String>();
        for(ContentDocumentLink cdl : [select id, ContentDocumentId, linkedentityid from ContentDocumentLink where linkedEntityId =: quoteId]){
            listCDIds.add(cdl.ContentDocumentId);
        }
        if(listCDIds != null && listCDIds.size() > 0){
            for(ContentVersion cv : [select id, Title, PathOnClient, FileExtension, FileType, ContentDocumentId from ContentVersion where ContentDocumentId IN: listCDIds AND Title Like :NameFormat + '%.xlsx' Order By CreatedDate Desc]) {
                integer verStartPos = cv.Title.lastIndexOf(' ');
                integer verEndPos = cv.Title.lastIndexOf('.');
                if (verStartPos > -1 && verEndPos > -1){
                    version = Integer.valueOf(cv.Title.subString(verStartPos+2,verEndPos));
                }
                break;
            }
        }
        string reportName = NameFormat + (version + 1) + '.xlsx';
        return reportName;
    }

    public static void insertFileRecord(Id quoteId, String reportName, Blob report){
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S';
        conVer.PathOnClient = reportName;
        conVer.Title = reportName;
        conVer.VersionData = report;
        insert conVer;
        
        // First get the content document Id from ContentVersion
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        
        //Create ContentDocumentLink
        ContentDocumentLink cDe = new ContentDocumentLink();
        cDe.ContentDocumentId = conDoc;
        cDe.LinkedEntityId = quoteId;
        cDe.ShareType = 'I';
        cDe.Visibility = 'AllUsers';
        insert cDe;
    }
}