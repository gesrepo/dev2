/**
 * Class: ExternalInforma.cls
 * Developer: Marian Iovi (marian.iovi@vertiba.com)
 * Created: December 12, 2016
 * Modified: December 13, 2016
 * Objective This class provides methods for getting infromation from Informa API and used in InformaBatchable.cls
 *
 *
 **/ 

public class ExternalInforma {

	public String eUrl {get;set;}
	public String subsKey {get;set;}

	public ExternalInforma(String eventCode, String token, String url, String subsKey){
		//verify if last char is a '/'
		if(url.substring(url.length()-1,url.length()) != '/'){
			url += '/';
		}
		url += eventCode + '/' + token;

		eUrl = url;
		this.subsKey = subsKey;
	}

	public String getRespose(){
		HttpRequest req = new HttpRequest();
		req.setEndpoint(eUrl);
		req.setMethod('GET');
		req.setTimeout(120000);

		req.setHeader('Ocp-Apim-Subscription-Key', subsKey);
  
		 Http http = new Http();
		 HTTPResponse res = http.send(req);
		 
		 System.debug(res.getBody());
		 return res.getBody();
	}

}