@isTest
private class ExternalInforma_Test {

	@isTest
	private static void test1() {
		Test.setMock(HttpCalloutMock.class, new InformaMockImpl());

		ExternalInforma ei = new ExternalInforma('TESTUS2017', 'Q0JvNzFPUEM1Zi96cmp2VEVUamtwZmlvNlBWSGFrUHRXTDd0U3RJT2FEND01', 'https://geukmeexhibitors.azure-api.net/exhibitorlisting/basic/catalogue/', '60cef13928c64d43b91485922feb9d06');

		System.assertEquals('60cef13928c64d43b91485922feb9d06', ei.subsKey);
		System.assertEquals('https://geukmeexhibitors.azure-api.net/exhibitorlisting/basic/catalogue/TESTUS2017/Q0JvNzFPUEM1Zi96cmp2VEVUamtwZmlvNlBWSGFrUHRXTDd0U3RJT2FEND01', ei.eUrl);

		DateTime myDT = Datetime.now().addHours(-2);
		String myDate = myDT.format('yyyy-MM-dd\'T\'HH:mm:ss.SSSXXX');

		String body = ei.getRespose();
		String jsonStr = '{'+
		'\"username\":\"amado3bungs\",'+
		'\"password\":\"VKW1G3\",'+
		'\"last_modified_date\":\"' + myDate +'\",'+
		'\"standnumber\":\"HHGG1\",'+
		'\"standtype\":\"Space Only\",'+
		'\"standsize\":\"21.00\",'+
		'\"status\":\"Active\",'+
		'\"exhibitorguid\":\"0c03401a-de43-4124-8d1d-4739b0c6ba31\",'+
		'\"companyname\":\"Lakas Amads\",'+
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


        System.assert(body.contains(jsonStr.substringAfter(':{')));
	}
}