public with sharing class LiveAgentController {
    
    public String lang {get;set;}
    public Map<String, String> params {get;set;}
    
    public LiveAgentController(){
        params = apexpages.currentpage().getParameters();
        string endpoint = apexpages.currentpage().getParameters().get('endpoint');
        if(endpoint.indexOf('language=') > -1){
            lang = endpoint.subString(endpoint.indexOf('language=') + 9, endpoint.indexOf('#deployment_id'));
        }
        if(lang == null){
            lang = 'en_US';
        }
    }

}