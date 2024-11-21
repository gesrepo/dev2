@isTest
global class DataDotComUpdateMock implements HttpCalloutMock {
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Create a fake response
        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(
            '[ {'+
                '"errorCode" : 0,'+
                '"errorMessage" : null,'+
                '"matchRecords" : [ {'+
                    '"entity" : {'+
                        '"attributes" : {'+
                            '"type" : "DatacloudCompany"'+
                        '},'+
                        '"Site" : "Headquarters",'+
                        '"Zip" : "94043-1351",'+
                        '"Ownership" : "Private",'+
                        '"Description" : "If you don\'t know what the term Google means, there\'s a leading Internet search engine you can use to find out. Taking its name from googol -- the mathematical term for the value represented by a one followed by 100 zeros -- Google offers targeted search results from billions of Web pages. Results are based on a proprietary algorithm; its technology for ranking Web pages is called PageRank. The firm generates revenue through ad sales. Advertisers deliver relevant ads targeted to search queries or Web content. The Google Network is a network of third-party customers that use Google\'s ad programs to deliver relevant ads to their own sites. In October 2015, Google formally became part -- and by far the biggest part -- of the Alphabet Inc. holding company.",'+
                        '"Website" : "www.google.com",'+
                        '"NumberOfEmployees" : 61814,'+
                        '"NaicsCode" : "517110",'+
                        '"Name" : "Google Inc.",'+
                        '"Industry" : "Telecommunications",'+
                        '"IsInactive" : false,'+
                        '"Phone" : "+1.650.253.0000",'+
                        '"TickerSymbol" : "",'+
                        '"Street" : "1600 Amphitheatre Pkwy",'+
                        '"CompanyId" : 5634951,'+
                        '"NaicsDesc" : "Wired Telecommunications Carriers",'+
                        '"City" : "Mountain View",'+
                        '"DunsNumber" : "060902413",'+
                        '"Sic" : "4813",'+
                        '"State" : "CA",'+
                        '"YearStarted" : "1998",'+
                        '"TradeStyle" : "Google",'+
                        '"Country" : "United States",'+
                        '"SicDesc" : "Telephone Communication, Except Radio",'+
                        '"Fax" : "",'+
                        '"AnnualRevenue" : 7.4989E10'+
                        '},'+
                    '"matchDiffs" : [ "Name" ]'+
                '} ]'+
            '} ]'
        );
        res.setStatusCode(200);
        return res;
    }
}