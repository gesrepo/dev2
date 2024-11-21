/**
* Mock class to mimic the response of wrike APIs used in SFDC
*
* @author  Rahul Sinha
* @version 1.0
* @since   09-19-2019
*/

@isTest
global class MockForGT_WrikeApiMethods implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();
        //get the method being called for
        string calledEndpoint=req.getEndpoint();
        
        // Create a fake response based on the method
           if(calledEndpoint.containsIgnoreCase('/api/v4/spaces')){
                res.setBody('{"kind": "spaces","data":[{"id": "IEABRDPJI4AQOJ3V","title": "Public","avatarUrl": "https://storage.www.wrike.com/avatars/00/10/spaceicon_Circle_ffe8e8e8_80_v1.png","accessType": "Public","archived": false},{id": "IEABRDPJI4AQOJ3W","title": "TestSpace","avatarUrl": "https://www.wrike.com/static/spaceicons/1/1-1f3e0.png","accessType": "Public","archived": false}]}');
           }
           if(calledEndpoint.containsIgnoreCase('/api/v4/spaces/IEABRDPJI4AQOJ3W/folders'))  {
                GT_WrikeFolderSearchRespObj mockResponse= new GT_WrikeFolderSearchRespObj();
                mockResponse.kind='folderTree';
                mockResponse.data=new List<GT_WrikeFolderSearchRespObj.Data>();
                GT_WrikeFolderSearchRespObj.Data folder1=new GT_WrikeFolderSearchRespObj.Data();
                folder1.id='111111';
                folder1.title='2018';
                mockResponse.data.add(folder1);
               res.setBody(json.serialize(mockResponse));
           }
           if(calledEndpoint.containsIgnoreCase('/api/v4/folders/IEABRDPJI4AQOJ3W/folders')) {
               GT_WrikeFolderCreateRespObj  mockNewFolder=new GT_WrikeFolderCreateRespObj();
                mockNewFolder.kind='folders';
                mockNewFolder.Data= new List<GT_WrikeFolderCreateRespObj.Data>();
                GT_WrikeFolderCreateRespObj.Data folder2= new GT_WrikeFolderCreateRespObj.Data();
                folder2.id='222222';
                folder2.title='2019';   
                mockNewFolder.Data.add(folder2);
               res.setBody(json.serialize(mockNewFolder));
           }
           if(calledEndpoint.containsIgnoreCase('/api/v4/folders/222222/folders')) {
                GT_WrikeFolderCreateRespObj  mockNewFolder=new GT_WrikeFolderCreateRespObj();
                mockNewFolder.kind='folders';
                mockNewFolder.Data= new List<GT_WrikeFolderCreateRespObj.Data>();
                GT_WrikeFolderCreateRespObj.Data folder2= new GT_WrikeFolderCreateRespObj.Data();
                folder2.id='666666';
                folder2.title='TEST01RHL';  
                mockNewFolder.Data.add(folder2);
               res.setBody(json.serialize(mockNewFolder));
           }
           if(calledEndpoint.containsIgnoreCase('/api/v4/copy_folder/IEABRDPJI4AQOJ3I')){
                GT_WrikeFolderCreateRespObj  mockCopiedFolder=new GT_WrikeFolderCreateRespObj();
                mockCopiedFolder.kind='folders';
                mockCopiedFolder.Data= new List<GT_WrikeFolderCreateRespObj.Data>();
                GT_WrikeFolderCreateRespObj.Data folder3= new GT_WrikeFolderCreateRespObj.Data();
                folder3.id='333333';
                folder3.title='Test Copy Project';
                mockCopiedFolder.data.add(folder3);             
                res.setBody(json.serialize(mockCopiedFolder));
           }
           if(calledEndpoint.containsIgnoreCase('/api/v4/folders/333333/tasks'))  {
                        String json2 = '{'+
        '   \"kind\": \"tasks\",'+
        '   \"data\":'+
        '   ['+
        '       {'+
        '           \"id\": \"444444\",'+
        '           \"accountId\": \"IEABRDPJ\",'+
        '           \"title\": \"SHOW CLOSE\",'+
        '           \"description\": \"\",'+
        '           \"briefDescription\": \"\",'+
        '           \"parentIds\":'+
        '           ['+
        '               \"IEABRDPJI4AQOJ3J\"'+
        '           ],'+
        '           \"superParentIds\":'+
        '           ['+
        '           ],'+
        '           \"sharedIds\":'+
        '           ['+
        '               \"KUGEYQ5H\"'+
        '           ],'+
        '           \"responsibleIds\":'+
        '           ['+
        '           ],'+
        '           \"status\": \"Active\",'+
        '           \"importance\": \"Normal\",'+
        '           \"createdDate\": \"2019-07-31T15:40:45Z\",'+
        '           \"updatedDate\": \"2019-07-31T15:40:54Z\",'+
        '           \"dates\":'+
        '           {'+
        '               \"type\": \"Planned\",'+
        '               \"duration\": 2880,'+
        '               \"start\": \"2019-07-29T09:00:00\",'+
        '               \"due\": \"2019-08-05T17:00:00\"'+
        '           },'+
        '           \"scope\": \"WsTask\",'+
        '           \"authorIds\":'+
        '           ['+
        '               \"KUGEYQ5H\"'+
        '           ],'+
        '           \"customStatusId\": \"IEABRDPJJMAAAAAA\",'+
        '           \"hasAttachments\": false,'+
        '           \"attachmentCount\": 0,'+
        '           \"permalink\": \"https://www.wrike.com/open.htm?id=17246063\",'+
        '           \"priority\": \"029378008000000000005c00\",'+
        '           \"superTaskIds\":'+
        '           ['+
        '           ],'+
        '           \"subTaskIds\":'+
        '           ['+
        '               \"IEABRDPJKQAQOJ3R\"'+
        '           ],'+
        '           \"dependencyIds\":'+
        '           ['+
        '               \"IEABRDPJIUAQOJ3PKMAQOJ3R\",'+
        '               \"IEABRDPJIUAQOJ3TKMAQOJ3P\"'+
        '           ],'+
        '           \"metadata\":'+
        '           ['+
        '               {'+
        '                   \"key\": \"testMetaKey\",'+
        '                   \"value\": \"testMetaValue\"'+
        '               }'+
        '           ],'+
        '           \"customFields\":'+
        '           ['+
        '               {'+
        '                   \"id\": \"IEABRDPJJUAAMVQM\",'+
        '                   \"value\": \"testValue\"'+
        '               },'+
        '               {'+
        '                   \"id\": \"IEABRDPJJUAAMVQN\",'+
        '                   \"value\": \"testValue\"'+
        '               }'+
        '           ]'+
        '       },'+
        '       {'+
        '           \"id\": \"IEABRDPJKQAQOJ3R\",'+
        '           \"accountId\": \"IEABRDPJ\",'+
        '           \"title\": \"Test task\",'+
        '           \"description\": \"Test task description\",'+
        '           \"briefDescription\": \"Test task description\",'+
        '           \"parentIds\":'+
        '           ['+
        '               \"IEABRDPJI4AQOJ3I\",'+
        '               \"IEABRDPJI4AQOJ3K\"'+
        '           ],'+
        '           \"superParentIds\":'+
        '           ['+
        '               \"IEABRDPJI4AQOJ3J\"'+
        '           ],'+
        '           \"sharedIds\":'+
        '           ['+
        '               \"KUGEYQ5H\"'+
        '           ],'+
        '           \"responsibleIds\":'+
        '           ['+
        '               \"KUGEYQ5H\"'+
        '           ],'+
        '           \"status\": \"Active\",'+
        '           \"importance\": \"High\",'+
        '           \"createdDate\": \"2019-07-31T15:40:46Z\",'+
        '           \"updatedDate\": \"2019-07-31T15:40:54Z\",'+
        '           \"dates\":'+
        '           {'+
        '               \"type\": \"Planned\",'+
        '               \"duration\": 2880,'+
        '               \"start\": \"2019-07-29T09:00:00\",'+
        '               \"due\": \"2019-08-05T17:00:00\"'+
        '           },'+
        '           \"scope\": \"WsTask\",'+
        '           \"authorIds\":'+
        '           ['+
        '               \"KUGEYQ5H\"'+
        '           ],'+
        '           \"customStatusId\": \"IEABRDPJJMAAAAAA\",'+
        '           \"hasAttachments\": false,'+
        '           \"attachmentCount\": 0,'+
        '           \"permalink\": \"https://www.wrike.com/open.htm?id=17246065\",'+
        '           \"priority\": \"029378008000000000005e00\",'+
        '           \"superTaskIds\":'+
        '           ['+
        '               \"IEABRDPJKQAQOJ3P\"'+
        '           ],'+
        '           \"subTaskIds\":'+
        '           ['+
        '               \"IEABRDPJKQAQOJ3T\"'+
        '           ],'+
        '           \"dependencyIds\":'+
        '           ['+
        '               \"IEABRDPJIUAQOJ3PKMAQOJ3R\"'+
        '           ],'+
        '           \"metadata\":'+
        '           ['+
        '               {'+
        '                   \"key\": \"testMetaKey\",'+
        '                   \"value\": \"testMetaValue\"'+
        '               }'+
        '           ],'+
        '           \"customFields\":'+
        '           ['+
        '               {'+
        '                   \"id\": \"IEABRDPJJUAAMVQM\",'+
        '                   \"value\": \"testValue\"'+
        '               }'+
        '           ]'+
        '       }'+
        '   ]'+
        '}';
        GT_WrikeTaskQueryResponse mockTaskQueryResp = GT_WrikeTaskQueryResponse.parse(json2);
               res.setBody(json.serialize(mockTaskQueryResp));
           }
           if(calledEndpoint.containsIgnoreCase('/api/v4/tasks/444444'))  {
                        String json2 = '{'+
        '   \"kind\": \"tasks\",'+
        '   \"data\":'+
        '   ['+
        '       {'+
        '           \"id\": \"444444\",'+
        '           \"accountId\": \"IEABRDPJ\",'+
        '           \"title\": \"SHOW CLOSE\",'+
        '           \"description\": \"\",'+
        '           \"briefDescription\": \"\",'+
        '           \"parentIds\":'+
        '           ['+
        '               \"IEABRDPJI4AQOJ3J\"'+
        '           ],'+
        '           \"superParentIds\":'+
        '           ['+
        '           ],'+
        '           \"sharedIds\":'+
        '           ['+
        '               \"KUGEYQ5H\"'+
        '           ],'+
        '           \"responsibleIds\":'+
        '           ['+
        '           ],'+
        '           \"status\": \"Active\",'+
        '           \"importance\": \"Normal\",'+
        '           \"createdDate\": \"2019-07-31T15:40:45Z\",'+
        '           \"updatedDate\": \"2019-07-31T15:40:54Z\",'+
        '           \"dates\":'+
        '           {'+
        '               \"type\": \"Planned\",'+
        '               \"duration\": 2880,'+
        '               \"start\": \"2019-07-29T09:00:00\",'+
        '               \"due\": \"2019-08-05T17:00:00\"'+
        '           },'+
        '           \"scope\": \"WsTask\",'+
        '           \"authorIds\":'+
        '           ['+
        '               \"KUGEYQ5H\"'+
        '           ],'+
        '           \"customStatusId\": \"IEABRDPJJMAAAAAA\",'+
        '           \"hasAttachments\": false,'+
        '           \"attachmentCount\": 0,'+
        '           \"permalink\": \"https://www.wrike.com/open.htm?id=17246063\",'+
        '           \"priority\": \"029378008000000000005c00\",'+
        '           \"superTaskIds\":'+
        '           ['+
        '           ],'+
        '           \"subTaskIds\":'+
        '           ['+
        '               \"IEABRDPJKQAQOJ3R\"'+
        '           ],'+
        '           \"dependencyIds\":'+
        '           ['+
        '               \"IEABRDPJIUAQOJ3PKMAQOJ3R\",'+
        '               \"IEABRDPJIUAQOJ3TKMAQOJ3P\"'+
        '           ],'+
        '           \"metadata\":'+
        '           ['+
        '               {'+
        '                   \"key\": \"testMetaKey\",'+
        '                   \"value\": \"testMetaValue\"'+
        '               }'+
        '           ],'+
        '           \"customFields\":'+
        '           ['+
        '               {'+
        '                   \"id\": \"IEABRDPJJUAAMVQM\",'+
        '                   \"value\": \"testValue\"'+
        '               },'+
        '               {'+
        '                   \"id\": \"IEABRDPJJUAAMVQN\",'+
        '                   \"value\": \"testValue\"'+
        '               }'+
        '           ]'+
        '       },'+
        '       {'+
        '           \"id\": \"IEABRDPJKQAQOJ3R\",'+
        '           \"accountId\": \"IEABRDPJ\",'+
        '           \"title\": \"Test task\",'+
        '           \"description\": \"Test task description\",'+
        '           \"briefDescription\": \"Test task description\",'+
        '           \"parentIds\":'+
        '           ['+
        '               \"IEABRDPJI4AQOJ3I\",'+
        '               \"IEABRDPJI4AQOJ3K\"'+
        '           ],'+
        '           \"superParentIds\":'+
        '           ['+
        '               \"IEABRDPJI4AQOJ3J\"'+
        '           ],'+
        '           \"sharedIds\":'+
        '           ['+
        '               \"KUGEYQ5H\"'+
        '           ],'+
        '           \"responsibleIds\":'+
        '           ['+
        '               \"KUGEYQ5H\"'+
        '           ],'+
        '           \"status\": \"Active\",'+
        '           \"importance\": \"High\",'+
        '           \"createdDate\": \"2019-07-31T15:40:46Z\",'+
        '           \"updatedDate\": \"2019-07-31T15:40:54Z\",'+
        '           \"dates\":'+
        '           {'+
        '               \"type\": \"Planned\",'+
        '               \"duration\": 2880,'+
        '               \"start\": \"2019-07-29T09:00:00\",'+
        '               \"due\": \"2019-08-05T17:00:00\"'+
        '           },'+
        '           \"scope\": \"WsTask\",'+
        '           \"authorIds\":'+
        '           ['+
        '               \"KUGEYQ5H\"'+
        '           ],'+
        '           \"customStatusId\": \"IEABRDPJJMAAAAAA\",'+
        '           \"hasAttachments\": false,'+
        '           \"attachmentCount\": 0,'+
        '           \"permalink\": \"https://www.wrike.com/open.htm?id=17246065\",'+
        '           \"priority\": \"029378008000000000005e00\",'+
        '           \"superTaskIds\":'+
        '           ['+
        '               \"IEABRDPJKQAQOJ3P\"'+
        '           ],'+
        '           \"subTaskIds\":'+
        '           ['+
        '               \"IEABRDPJKQAQOJ3T\"'+
        '           ],'+
        '           \"dependencyIds\":'+
        '           ['+
        '               \"IEABRDPJIUAQOJ3PKMAQOJ3R\"'+
        '           ],'+
        '           \"metadata\":'+
        '           ['+
        '               {'+
        '                   \"key\": \"testMetaKey\",'+
        '                   \"value\": \"testMetaValue\"'+
        '               }'+
        '           ],'+
        '           \"customFields\":'+
        '           ['+
        '               {'+
        '                   \"id\": \"IEABRDPJJUAAMVQM\",'+
        '                   \"value\": \"testValue\"'+
        '               }'+
        '           ]'+
        '       }'+
        '   ]'+
        '}';
        GT_WrikeTaskQueryResponse mockTaskQueryResp = GT_WrikeTaskQueryResponse.parse(json2);
               res.setBody(json.serialize(mockTaskQueryResp));
           }
        res.setHeader('Content-Type', 'application/json');
        res.setStatusCode(200);
        
        return res;
    }
}