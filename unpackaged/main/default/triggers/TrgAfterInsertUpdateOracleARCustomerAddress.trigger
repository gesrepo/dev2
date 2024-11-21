trigger TrgAfterInsertUpdateOracleARCustomerAddress on Oracle_AR_Customer_Address__c (after insert, after update) {
	
	Set<Id> SoOracleAddressIds = new Set<Id>();
	Map<Id, Oracle_AR_Customer_Address__c> MoOracleAddressToId = new Map<Id, Oracle_AR_Customer_Address__c>();
	
	for (Oracle_AR_Customer_Address__c oracleAddress : Trigger.New)
	{
		SoOracleAddressIds.add(oracleAddress.Id);
		MoOracleAddressToId.put(oracleAddress.Id, oracleAddress);
	}
	
	/* START UPDATE */
	
	List<Shipping_Address__c> LoShippingAddresses = [Select Id, Oracle_AR_Customer_Address__c From Shipping_Address__c Where Oracle_AR_Customer_Address__c In : SoOracleAddressIds];
	
	Set<Id> SoExistingShipAddrOracleIds = new Set<Id>();
	
	if (LoShippingAddresses != null)
	{
		for (Shipping_Address__c shippingAddress : LoShippingAddresses)
		{
			SoExistingShipAddrOracleIds.add(shippingAddress.Oracle_AR_Customer_Address__c);
			
			Oracle_AR_Customer_Address__c oracleAddress = MoOracleAddressToId.get(shippingAddress.Oracle_AR_Customer_Address__c);
			shippingAddress.Address_1__c = oracleAddress.AR_CUST_SITE_ADDRESS1__c;
			shippingAddress.Address_2__c = oracleAddress.AR_CUST_SITE_ADDRESS2__c;
			shippingAddress.Address_3__c = oracleAddress.AR_CUST_SITE_ADDRESS3__c;
			shippingAddress.Address_4__c = oracleAddress.AR_CUST_SITE_ADDRESS4__c;
			shippingAddress.City__c = oracleAddress.AR_CUST_SITE_CITY__c;
			shippingAddress.State__c = oracleAddress.AR_CUST_SITE_STATE__c;
			shippingAddress.Country__c = oracleAddress.AR_CUST_SITE_COUNTRY__c;
			shippingAddress.Postal_Code__c = oracleAddress.AR_CUST_SITE_POSTAL_CODE__c;
		}
		
		if (LoShippingAddresses.size() > 0)
		{
			Integer UpdateCount = 0;
			
			List<Shipping_Address__c> LoShippingAddressesUpdate =  new List<Shipping_Address__c>();
			
			for(Shipping_Address__c addr : LoShippingAddresses)
			{
				LoShippingAddressesUpdate.add(addr);
				UpdateCount++;
				
				if (UpdateCount == 200)
				{
					Database.Update(LoShippingAddressesUpdate, false);
					LoShippingAddressesUpdate.clear();
					UpdateCount = 0;
				}
			}
			
			if (UpdateCount > 0)
			{
				Database.Update(LoShippingAddressesUpdate, false);
				LoShippingAddressesUpdate.clear();
				UpdateCount = 0;				
			}
		}
		
		/* END UPDATE */
		
		/* START INSERT */
		Set<Id> SoOracleAddressIdsForInsert = new Set<Id>();
		
		if (LoShippingAddresses != null && LoShippingAddresses.size() > 0)
		{
			for (Id oracleAddrId :SoOracleAddressIds)
			{
				if (!SoExistingShipAddrOracleIds.contains(oracleAddrId))
					SoOracleAddressIdsForInsert.add(oracleAddrId);
			}
		}
		else
			SoOracleAddressIdsForInsert = SoOracleAddressIds;
		
		LoShippingAddresses.clear();
		
		for(Id oracleAddrId : SoOracleAddressIdsForInsert)
		{
			Oracle_AR_Customer_Address__c oracleAddress = MoOracleAddressToId.get(oracleAddrId);
			
			Shipping_Address__c shippingAddress = new Shipping_Address__c();
			String Name = '';
			
			if (oracleAddress.AR_CUST_SITE_ADDRESS1__c != null)
			{
				String Address1 = oracleAddress.AR_CUST_SITE_ADDRESS1__c;
				Address1 = (Address1.length() > 20 ? Address1.substring(0,20) : Address1);
				
				Name = Address1;
			}
			
			if (oracleAddress.AR_CUST_SITE_CITY__c != null)
				Name = (Name == null || Name == '' ?  oracleAddress.AR_CUST_SITE_CITY__c : Name + ', ' + oracleAddress.AR_CUST_SITE_CITY__c);
			
			if (oracleAddress.AR_CUST_SITE_STATE__c != null)	
				Name = (Name == null || Name == '' ?  oracleAddress.AR_CUST_SITE_STATE__c : Name + ', ' + oracleAddress.AR_CUST_SITE_STATE__c);
							
			if (oracleAddress.AR_CUST_SITE_COUNTRY__c != null)
				Name = (Name == null || Name == '' ?  oracleAddress.AR_CUST_SITE_COUNTRY__c : Name + ', ' + oracleAddress.AR_CUST_SITE_COUNTRY__c);
			
			shippingAddress.Name = Name;
			shippingAddress.Oracle_AR_Customer_Address__c = oracleAddress.Id;
			shippingAddress.Account__c = oracleAddress.Account__c;
			shippingAddress.Address_1__c = oracleAddress.AR_CUST_SITE_ADDRESS1__c;
			shippingAddress.Address_2__c = oracleAddress.AR_CUST_SITE_ADDRESS2__c;
			shippingAddress.Address_3__c = oracleAddress.AR_CUST_SITE_ADDRESS3__c;
			shippingAddress.Address_4__c = oracleAddress.AR_CUST_SITE_ADDRESS4__c;
			shippingAddress.City__c = oracleAddress.AR_CUST_SITE_CITY__c;
			shippingAddress.State__c = oracleAddress.AR_CUST_SITE_STATE__c;
			shippingAddress.Country__c = oracleAddress.AR_CUST_SITE_COUNTRY__c;
			shippingAddress.Postal_Code__c = oracleAddress.AR_CUST_SITE_POSTAL_CODE__c;
			
			LoShippingAddresses.add(shippingAddress);
		}
		
		if (LoShippingAddresses.size() > 0)
		{
			Integer InsertCount = 0;
			
			List<Shipping_Address__c> LoShippingAddressesInsert =  new List<Shipping_Address__c>();
			
			for(Shipping_Address__c addr : LoShippingAddresses)
			{
				LoShippingAddressesInsert.add(addr);
				InsertCount++;
				
				if (InsertCount == 200)
				{
					Database.Insert(LoShippingAddressesInsert, false);
					LoShippingAddressesInsert.clear();
					InsertCount = 0;
				}
			}
			
			if (InsertCount > 0)
			{
				Database.Insert(LoShippingAddressesInsert, false);
				LoShippingAddressesInsert.clear();
				InsertCount = 0;				
			}
		}		
		/* END INSERT */
	}
	
}