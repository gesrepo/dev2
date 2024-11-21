trigger TrgBeforeInsertUpdateShippingAddress on Shipping_Address__c (before insert, before update) {

	if (Trigger.isBefore)
	{		
		for (Shipping_Address__c address : Trigger.New)
		{
			String Name = '';
			
			if (address.Address_1__c != null)
			{
				String Address1 = address.Address_1__c;
				Address1 = (Address1.length() > 20 ? Address1.substring(0,20) : Address1);
				
				Name = Address1.toUpperCase();
			}
			
			if (address.City__c != null)
				Name = (Name == null || Name == '' ?  address.City__c.toUpperCase() : Name + ', ' + address.City__c.toUpperCase());
			
			if (address.State__c != null)	
				Name = (Name == null || Name == '' ?  address.State__c.toUpperCase() : Name + ', ' + address.State__c.toUpperCase());
							
			if (address.Country__c != null)
				Name = (Name == null || Name == '' ?  address.Country__c.toUpperCase() : Name + ', ' + address.Country__c.toUpperCase());
			
			address.Name = Name;
			
			address.Address_1__c = address.Address_1__c.toUpperCase();
			
			if (address.Address_2__c != null)
				address.Address_2__c = address.Address_2__c.toUpperCase();
			
			if (address.Address_3__c != null)
				address.Address_3__c = address.Address_3__c.toUpperCase();
			
			if (address.Address_4__c != null)
				address.Address_4__c = address.Address_4__c.toUpperCase();
			
			if (address.City__c != null)
				address.City__c = address.City__c.toUpperCase();
			
			if (address.State__c != null)
				address.State__c = address.State__c.toUpperCase();
			
			if (address.Postal_Code__c != null)			
				address.Postal_Code__c = address.Postal_Code__c.toUpperCase();
		}
	}
}