public with sharing class CCPageRedirect {
	
	public PageReference redirectToPage() {
		
		String sObjectType = ApexPages.currentPage().getParameters().get('Object');
		String RecordId = ApexPages.currentPage().getParameters().get('Id');
		String IsConsole = ApexPages.currentPage().getParameters().get('IsConsole');
		String RetUrl = ApexPages.currentPage().getParameters().get('RetUrl');
		String URL = null;
		
		if (sObjectType.toUpperCase() == 'ACCOUNT') {
			
			Account A = [Select Id, Name From Account Where Id = :RecordId];
			
			URL = '/500/e?cas4=' + EncodingUtil.urlEncode(A.Name, 'UTF-8') + 
				'&cas4_lkid=' + A.Id + '&00N40000002SoBd=Exhibitor';
				
			if (IsConsole.toUpperCase() == 'YES') {
				URL += '&isdtp=vw&retURL=%2F500%2Fo'; 
			} 
			else 
			{ 
				URL += '&retURL='+RetUrl; 
			}	
		}		
		else if (sObjectType.toUpperCase() == 'CONTACT') {
			
			Contact C = [Select Id, Name, Account.Id, Account.Name From Contact Where Id = :RecordId];
			
			URL = '/500/e?cas4=' + EncodingUtil.urlEncode(C.Account.Name, 'UTF-8') + 
				'&cas4_lkid=' + C.Account.Id + '&cas3=' + EncodingUtil.urlEncode(C.Name, 'UTF-8') + 
				'&cas3_lkid=' + C.Id + '&00N40000002SoBc=' + EncodingUtil.urlEncode(C.Account.Name, 'UTF-8') + 
				'&00N40000002SoBd=Exhibitor';
				
			if (IsConsole.toUpperCase() == 'YES') {
				URL += '&isdtp=vw&retURL=%2F500%2Fo'; 
			} 
			else 
			{ 
				URL += '&retURL='+RetUrl; 
			}	
		}
		else if (sObjectType.toUpperCase() == 'ORACLE_SHOW_BOOTH__C') {
		
			Oracle_Show_Booth__c B = [Select Id, Name, Show_Occurrence__c, Show_Occurrence__r.Name, Account__c, Account__r.Name From Oracle_Show_Booth__c Where Id = :RecordId];

			URL = '/500/e?cas4=' + EncodingUtil.urlEncode(B.Account__r.Name, 'UTF-8') +
				'&cas4_lkid=' + B.Account__c + '&CF00N40000002SoBY=' + EncodingUtil.urlEncode(B.Name, 'UTF-8') + 
				'&CF00N40000002SoBY_lkid=' + B.Id + '&CF00N40000002SoBx=' + EncodingUtil.urlEncode(B.Show_Occurrence__r.Name, 'UTF-8') + 
				'&CF00N40000002SoBx_lkid=' + B.Show_Occurrence__c + '&00N40000002SoBd=Exhibitor';
				
			if (IsConsole.toUpperCase() == 'YES') {
				URL += '&isdtp=vw&retURL=%2F500%2Fo'; 
			} 
			else 
			{ 
				URL += '&retURL='+RetUrl; 
			}			
		}
		else if (sObjectType.toUpperCase() == 'ORACLE_SHOW_BOOTH_CONTACT__C') {
		
			Oracle_Show_Booth_Contact__c BC = [Select Id, Oracle_Show_Booth__c, Contact__c, Contact__r.Name, Oracle_Show_Booth__r.Name, Oracle_Show_Booth__r.Account__r.Id, Oracle_Show_Booth__r.Account__r.Name, Oracle_Show_Booth__r.Show_Occurrence__r.Id, Oracle_Show_Booth__r.Show_Occurrence__r.Name From Oracle_Show_Booth_Contact__c Where Id = :RecordId];

			String AccountId = EncodingUtil.urlEncode(BC.Oracle_Show_Booth__r.Account__c, 'UTF-8'); 
			String AccountName = EncodingUtil.urlEncode(BC.Oracle_Show_Booth__r.Account__r.Name, 'UTF-8'); 
			String BoothId = EncodingUtil.urlEncode(BC.Oracle_Show_Booth__c, 'UTF-8'); 
			String BoothName = EncodingUtil.urlEncode(BC.Oracle_Show_Booth__r.Name, 'UTF-8');
			String OptyId = EncodingUtil.urlEncode(BC.Oracle_Show_Booth__r.Show_Occurrence__c, 'UTF-8');
			String OptyName = EncodingUtil.urlEncode(BC.Oracle_Show_Booth__r.Show_Occurrence__r.Name, 'UTF-8');

			URL = '/500/e?cas4=' + AccountName + '&cas4_lkid=' + AccountId + 
				'&CF00N40000002SoBY=' + BoothName + '&CF00N40000002SoBY_lkid=' + BoothId + 
				'&CF00N40000002SoBx=' + OptyName + '&CF00N40000002SoBx_lkid=' + OptyId + 
				'&00N40000002SoBd=Exhibitor'; 

			if (IsConsole.toUpperCase() == 'YES') {
				URL += '&isdtp=vw&retURL=%2F500%2Fo'; 
			} 
			else 
			{ 
				URL += '&retURL='+RetUrl; 
			}
			
		}		
		else if (sObjectType.toUpperCase() == 'OPPORTUNITY') {
			
			Opportunity O = [Select Id, Name, Show_Name__c, Show_Name__r.Name From Opportunity Where Id = :RecordId];
						
			URL = '/500/e?CF00N40000002SoBx=' + EncodingUtil.urlEncode(O.Name, 'UTF-8') + 
				'&CF00N40000002SoBx_lkid=' + O.Id;
			
			if (O.Show_Name__c != null && O.Show_Name__r != null)
			{
				URL += '&CF00N40000002SoBw=' + EncodingUtil.urlEncode(O.Show_Name__r.Name, 'UTF-8');
				URL += '&CF00N40000002SoBw_lkid=' + EncodingUtil.urlEncode(O.Show_Name__c, 'UTF-8');
			}
			
			URL += '&00N40000002SoBd=Exhibitor';
			
			if (IsConsole.toUpperCase() == 'YES') {			
				URL += '&isdtp=vw&retURL=%2F500%2Fo';
			} 
			else 
			{ 
				URL += '&retURL='+RetUrl; 
			}			
		}
		
		return  new PageReference(URL);
	}
}