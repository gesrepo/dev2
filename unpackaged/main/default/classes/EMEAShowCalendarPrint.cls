public with sharing class EMEAShowCalendarPrint {

	public List<OpportunityWrapper> show {get;set;}
	public string searchQuery {get;set;}
	public string monthValue {get;set;}
	public string monthLabel {get;set;} 

	public EMEAShowCalendarPrint(ApexPages.StandardSetController controller){
		monthValue = 'THIS_MONTH';
		if (ApexPages.currentPage().getParameters().containsKey('v')) {
			monthValue = ApexPages.currentPage().getParameters().get('v');
			monthLabel = ApexPages.currentPage().getParameters().get('l');
		}
		search();
	}

	public void search(){
		string searchQuery=  'SELECT Event_Manager__c, Event_Manager__r.Name, Sop_Event_ID__c, Show_Name__c, Show_Name__r.Name, Name, Id, Facility__c, AccountId, Show_Open_Date__c, Show_Close_Date__c, Sales_Person__c, GES_Move_In__c, GES_Move_Out_Date_1__c, Sales_Person__r.Name, Facility__r.Name, Account.Name, (SELECT ProductCode__c, Product2.Name FROM OpportunityLineItems) FROM Opportunity';
		searchQuery += ' WHERE RecordType_Name__c = \'EMEA - Exhibition\'' ;
		searchQuery += ' AND Show_Open_Date__c = ' + monthValue;
		searchQuery += ' AND StageName = \'Won\'';
		searchQuery += ' ORDER BY Show_Open_Date__c';
		searchQuery += ' LIMIT 1000';
		string.escapeSingleQuotes(searchQuery);
		List<Opportunity> showTemp = Database.query(searchQuery);
		show = new List<OpportunityWrapper>();
		for (Opportunity o : showTemp) {
			show.add(new OpportunityWrapper(o));
		}
	}

	public void clear() {
		show.clear();
	}
	
	public string RenderedExcel {
		get { 
			string ret =  '';
		
			ret += 'Sop Event ID,';
			ret += 'Show Name,';
			ret += 'Opportunity Name,';
			ret += 'Venue,';
			ret += 'Account,';
			ret += 'Show Open,';
			ret += 'Show Close,';
			ret += 'Sales Manager,';
			ret += 'GES Move In,';
			ret += 'GES Move Out,';
			ret += 'Event Manager';
			ret += 'Products\n';

			for (OpportunityWrapper s : show) {
				ret += '"' + (s.opp.Sop_Event_ID__c == null ? '' : '' + s.opp.Sop_Event_ID__c).replace('"', '\'') + '",';
				ret += '"' + (s.opp.Show_Name__r.Name == null ? '' : s.opp.Show_Name__r.Name).replace('"', '\'') + '",';
				ret += '"' + (s.opp.Name == null ? '' : s.opp.Name).replace('"', '\'') + '",';
				ret += '"' + (s.opp.Facility__r.Name == null ? '' : s.opp.Facility__r.Name).replace('"', '\'') + '",';
				ret += '"' + (s.opp.Account.Name == null ? '' : s.opp.Account.Name).replace('"', '\'') + '",';
				ret += '"' + (s.opp.Show_Open_Date__c == null ? '' : '' + s.opp.Show_Open_Date__c).replace('"', '\'') + '",';
				ret += '"' + (s.opp.Show_Close_Date__c == null ? '' : '' + s.opp.Show_Close_Date__c).replace('"', '\'') + '",';
				ret += '"' + (s.opp.Sales_Person__r.Name == null ? '' : s.opp.Sales_Person__r.Name).replace('"', '\'') + '",';
				ret += '"' + (s.opp.GES_Move_In__c == null ? '' : '' + s.opp.GES_Move_In__c).replace('"', '\'') + '",';
				ret += '"' + (s.opp.GES_Move_Out_Date_1__c == null ? '' : '' + s.opp.GES_Move_Out_Date_1__c).replace('"', '\'') + '",';
				ret += '"' + (s.opp.Event_Manager__r.Name == null ? '' : '' + s.opp.Event_Manager__r.Name).replace('"', '\'') + '",';
				ret += '"' + (s.products == null ? '' : s.products).replace('"', '\'') + '"\n';
			}
		
			return ret;	
		}
	}
	
	public class OpportunityWrapper {
		
		public Opportunity opp { get; set; }
		
		public string products {
			get {
				string prods = '';
				for (OpportunityLineItem oli : opp.OpportunityLineItems) {
					if (prods != '')
						prods += ', ';
					prods += oli.Product2.Name;
				}
				return prods;
			}
		}
		
		public OpportunityWrapper(Opportunity o) {
			opp = o;
		}
		
	}
	
}