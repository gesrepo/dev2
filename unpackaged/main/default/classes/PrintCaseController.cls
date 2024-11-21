public with sharing class PrintCaseController {
	
	private Case thisCase;
	private User thisUser;
	
	public PrintCaseController(ApexPages.StandardController stdController){
		this.thisCase = (Case)stdController.getRecord();
		thisUser = [SELECT Id, email FROM User WHERE Id=: system.Userinfo.getUserId()];	
	}
	
	public pageReference emailPDF(){
		PageReference pagePdf = Page.PrintCase;
		pagePDF.getParameters().put('id', thisCase.Id);
		Blob pdfPageBlob = pagePdf.getContentAsPDF();
		
	    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		String[] toAddresses = new String[] {thisUser.Email};
		String cNumber = [SELECT CaseNumber FROM Case WHERE Id =: thisCase.Id].CaseNumber;
		mail.setToAddresses(toAddresses);
		mail.setSubject('Print Attachment for Case#: ' + cNumber);
		mail.setHtmlBody('Please find attached a PDF document for Case#: ' + cNumber);
    	Messaging.EmailFileAttachment[] efaList = new  List<Messaging.EmailFileAttachment>();
	    	Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
	    	efa.setContentType('application/pdf');
			efa.setFileName('Case: ' + cNumber);
	    	efa.setBody(pdfPageBlob);
	    	efaList.add(efa);
	    mail.setFileAttachments(efaList);
		if (!Test.isRunningTest()) {
			Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
		}
		pageReference pr = new pageReference('/'+thisCase.Id);
		return pr;
	}
	
	public pageReference returnToCase(){
		pageReference pr = new pageReference('/'+thisCase.Id);
		return pr;
	}
}