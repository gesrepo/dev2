global class InformaMockImpl implements HttpCalloutMock { 

	global HTTPResponse respond(HTTPRequest req) {

		DateTime myDT = Datetime.now().addHours(-2);
		String myDate = myDT.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');

		String jsonStr = '{'+
		'\"username\":\"amado3bungs\",'+
		'\"password\":\"VKW1G3\",'+
		'\"last_modified_date\":\"'+myDate+'\",'+
		'\"standnumber\":\"HHGG1\",'+
		'\"standtype\":\"Space Only\",'+
		'\"standsize\":\"21.00\",'+
		'\"status\":\"Active\",'+
		'\"exhibitorguid\":\"0c03401a-de43-4124-8d1d-4739b0c6ba31\",'+
		'\"companyname\":\"Lakas Amads Arab Authority For Agricultural Investment and Development\",'+
		'\"nameboard\":null,'+
		'\"mainexhibitor\":\"\",'+
		'\"catalogue\":null,'+
		'\"products\":null,'+
		'\"signatory\":{	\"title\":\"Ms.\",'+
		'				\"firstname\":\"Amado\",'+
		'				\"lastname\":\"Tuloybungot\",'+
		'				\"address1\":\"Address1\",'+
		'				\"address2\":\"Address2\",'+
		'				\"city\":null,'+
		'				\"state\":null,'+
		'				\"pobox\":null,'+
		'				\"postal\":null,'+
		'				\"country\":\"Philippines\",'+
		'				\"phone\":\"2-3-2-312\",'+
		'				\"mobile\":\"32-32-12331\",'+
		'				\"fax\":\"\",'+
		'				\"email\":\"amads@amado.com\",'+
		'				\"website\":null'+
		'			},'+
		'\"manuals_contact\":{	\"title\":null,'+
		'					\"firstname\":null,'+
		'					\"lastname\":null,'+
		'					\"address1\":null,'+
		'					\"address2\":null,'+
		'					\"city\":null,'+
		'					\"state\":null,'+
		'					\"pobox\":null,'+
		'					\"postal\":null,'+
		'					\"country\":null,'+
		'					\"phone\":null,'+
		'					\"mobile\":null,'+
		'					\"fax\":null,'+
		'					\"email\":null,'+
		'					\"website\":null'+
		'			}'+
		'}';

		// Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonStr);
        res.setStatusCode(200);
        return res;
	}

	global static String resp() {
		DateTime myDT = Datetime.now().addHours(-2);
		String myDate = myDT.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');

		String jsonStr = '[{'+
		'\"username\":\"amado3bungs\",'+
		'\"password\":\"VKW1G3\",'+
		'\"last_modified_date\":\"' + myDate +'\",'+
		'\"standnumber\":\"HHGG1\",'+
		'\"standtype\":\"Space Only\",'+
		'\"standsize\":\"21.00\",'+
		'\"status\":\"Active\",'+
		'\"exhibitorguid\":\"0c03401a-de43-4124-8d1d-4739b0c6ba31\",'+
		'\"companyname\":\"Lakas Amads Arab Authority For Agricultural Investment and Development\",'+
		'\"nameboard\":null,'+
		'\"mainexhibitor\":\"\",'+
		'\"catalogue\":null,'+
		'\"products\":null,'+
		'\"signatory\":{	\"title\":\"Ms.\",'+
		'				\"firstname\":\"Amado\",'+
		'				\"lastname\":\"Tuloybungot\",'+
		'				\"address1\":\"Address1\",'+
		'				\"address2\":\"Address2\",'+
		'				\"city\":null,'+
		'				\"state\":null,'+
		'				\"pobox\":null,'+
		'				\"postal\":null,'+
		'				\"country\":\"Philippines\",'+
		'				\"phone\":\"2-3-2-312\",'+
		'				\"mobile\":\"32-32-12331\",'+
		'				\"fax\":\"\",'+
		'				\"email\":\"amads@amado.com\",'+
		'				\"website\":null'+
		'			},'+
		'\"manuals_contact\":{	\"title\":null,'+
		'					\"firstname\":null,'+
		'					\"lastname\":null,'+
		'					\"address1\":null,'+
		'					\"address2\":null,'+
		'					\"city\":null,'+
		'					\"state\":null,'+
		'					\"pobox\":null,'+
		'					\"postal\":null,'+
		'					\"country\":null,'+
		'					\"phone\":null,'+
		'					\"mobile\":null,'+
		'					\"fax\":null,'+
		'					\"email\":null,'+
		'					\"website\":null'+
		'			}'+
		'}]';

		// Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(jsonStr);
        res.setStatusCode(200);
		 
		 System.debug(res.getBody());
		 return res.getBody();
	}

}