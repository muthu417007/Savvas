/**************************************************************************************** 
* @Class Name  - scc_checkAccessCodeMockResponse
* @description - This class will create fake response
* @Created By  - CTS-Sameer Pujari
* @Created On - 2024-05-16 
* ***************************************************************************************/ 
@isTest
public class scc_checkAccessCodeMockResponse implements HttpCalloutMock{
    /**
*  Description: This method will create fake response  
*  @name: respond
*  @param: HTTPRequest
*  @return: HTTPResponse
*/
    public HTTPResponse respond(HTTPRequest req) {
        String xmlstring = '';
        DOM.Document doc = new DOM.Document();
        HttpResponse res = new HttpResponse();
        if(req.getEndpoint().contains('WSEMMC-JAHID-OVARY-CLXIX-SPEIR-PRISE')){
            
            res.setHeader('Content-Type', 'application/xml');
            String xmlResponse  = '<?xml version="1.0" encoding="UTF-8"?>' +
                '<AccessCodeServiceResponse>' +
                '<status>Found</status>' +
                '<errorCode>0</errorCode>' +
                '<AccessCodeDetails>' +
                '<Accesscode>WSEMMC-JAHID-OVARY-CLXIX-SPEIR-PRISE</Accesscode>' +
                '<AccesscodeTypeId>149335</AccesscodeTypeId>' +
                '<AccesscodeBatchId>8197247</AccesscodeBatchId>' +
                '<CashedIn>Y</CashedIn>' +
                '<CashedInDate>2024-01-26Z</CashedInDate>' +
                '<ValidFromDate>2023-07-31T00:00:00Z</ValidFromDate>' +
                '<ExpirationDate>2027-12-31T00:00:00Z</ExpirationDate>' +
                '<PoReqd>N</PoReqd>' +
                '<NumCashins>1</NumCashins>' +
                '<NumTimesCashedIn>1</NumTimesCashedIn>' +
                '<CreationDate>2023-07-31T16:33:48Z</CreationDate>' +
                '</AccessCodeDetails>' +
                '</AccessCodeServiceResponse>';              
            
            //System.assertEquals('https://ris.pearsoncmg.com/ac/services/getDetails?accesscode=SSSRCC-CLXII-BERNE-STUBS-LAPIS-ESEBO', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            res.setBody(xmlResponse);
            res.setStatusCode(200);             
        } else if(req.getEndpoint().contains('SSSRCC-CINHK-NATCH-PAMPA-GIBBY-DICES')){
            
            res.setHeader('Content-Type', 'application/xml');
            String xmlResponse  = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<AccessCodeServiceResponse>' +
                '<status>Found</status>' +
                '<errorCode>0</errorCode>' +
                    '<AccessCodeDetails>' +
                        '<Accesscode>SSSRCC-CINHK-NATCH-PAMPA-GIBBY-DICES</Accesscode>' +
                        '<AccesscodeTypeId>1510148</AccesscodeTypeId>' +
                        '<AccesscodeBatchId>8550959</AccesscodeBatchId>' +
                        '<CashedIn>Y</CashedIn>' +
                        '<CashedInDate>2023-11-15T00:00:00Z</CashedInDate>' +
                        '<ValidFromDate>2023-07-31T00:00:00Z</ValidFromDate>' +
                        '<ExpirationDate>2005-01-01T00:00:00Z</ExpirationDate>' +
                        '<PoReqd>N</PoReqd>' +
                        '<NumCashins>1</NumCashins>' +
                        '<NumTimesCashedIn>0</NumTimesCashedIn>' +
                        '<CreationDate>2023-07-31T16:33:48Z</CreationDate>' +
                    '</AccessCodeDetails>' +
            '</AccessCodeServiceResponse>';
            
            //System.assertEquals('https://ris.pearsoncmg.com/ac/services/getDetails?accesscode=SSSRCC-CLXII-BERNE-STUBS-LAPIS-ESEBO', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            res.setBody(xmlResponse);
            res.setStatusCode(200);             
        } else if(req.getEndpoint().contains('WSEMMC-JEDDA-OVARY-CLXIX-AFOOT-HEARD')){
            
            res.setHeader('Content-Type', 'application/xml');
            String xmlResponse  = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<AccessCodeServiceResponse>' +
                '<status>Found</status>' +
                '<errorCode>0</errorCode>' +
                    '<AccessCodeDetails>' +
                        '<Accesscode>WSEMMC-JEDDA-OVARY-CLXIX-AFOOT-HEARD</Accesscode>' +
                        '<AccesscodeTypeId>1510148</AccesscodeTypeId>' +
                        '<AccesscodeBatchId>8550959</AccesscodeBatchId>' +
                        '<CashedIn>Y</CashedIn>' +
                        '<CashedInDate>2023-11-15T00:00:00Z</CashedInDate>' +
                        '<ValidFromDate>2023-07-31T00:00:00Z</ValidFromDate>' +
                        '<ExpirationDate>2005-01-01T00:00:00Z</ExpirationDate>' +
                        '<PoReqd>N</PoReqd>' +
                        '<NumCashins>1</NumCashins>' +
                        '<NumTimesCashedIn>0</NumTimesCashedIn>' +
                        '<CreationDate>2023-07-31T16:33:48Z</CreationDate>' +
                    '</AccessCodeDetails>' +
            '</AccessCodeServiceResponse>';
            
            //System.assertEquals('https://ris.pearsoncmg.com/ac/services/getDetails?accesscode=SSSRCC-CLXII-BERNE-STUBS-LAPIS-ESEBO', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            res.setBody(xmlResponse);
            res.setStatusCode(200);             
        }else if(req.getEndpoint().contains('WSEMMC-JAHID-OVARY-CLXIX-SPEIR-PRISA')){
            
            res.setHeader('Content-Type', 'application/xml');
            String xmlResponse  = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<AccessCodeServiceResponse>' +
                '<status>Found</status>' +
                '<errorCode>0</errorCode>' +
                    '<AccessCodeDetails>' +
                        '<Accesscode>WSEMMC-JAHID-OVARY-CLXIX-SPEIR-PRISA</Accesscode>' +
                        '<AccesscodeTypeId>1510148</AccesscodeTypeId>' +
                        '<AccesscodeBatchId>8550959</AccesscodeBatchId>' +
                        '<CashedIn>Y</CashedIn>' +
                        '<CashedInDate>2023-11-15T00:00:00Z</CashedInDate>' +
                        '<ValidFromDate>2023-07-31T00:00:00Z</ValidFromDate>' +
                        '<ExpirationDate>2005-01-01T00:00:00Z</ExpirationDate>' +
                        '<PoReqd>N</PoReqd>' +
                        '<NumCashins>1</NumCashins>' +
                        '<NumTimesCashedIn>0</NumTimesCashedIn>' +
                        '<CreationDate>2023-07-31T16:33:48Z</CreationDate>' +
                    '</AccessCodeDetails>' +
            '</AccessCodeServiceResponse>';
            
            //System.assertEquals('https://ris.pearsoncmg.com/ac/services/getDetails?accesscode=WSEMMC-JAHID-OVARY-CLXIX-SPEIR-PRISA', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            res.setBody(xmlResponse);
            res.setStatusCode(200);             
        }else if(req.getEndpoint().contains('WSEMMC-JAHID-OVARY-CLXIX-SPEIR-PRISB')){
            
            res.setHeader('Content-Type', 'application/xml');
            String xmlResponse  = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<AccessCodeServiceResponse>' +
                '<status>Found</status>' +
                '<errorCode>0</errorCode>' +
                    '<AccessCodeDetails>' +
                        '<Accesscode>WSEMMC-JAHID-OVARY-CLXIX-SPEIR-PRISB</Accesscode>' +
                        '<AccesscodeTypeId>1510148</AccesscodeTypeId>' +
                        '<AccesscodeBatchId>8550959</AccesscodeBatchId>' +
                        '<CashedIn>Y</CashedIn>' +
                        '<CashedInDate>2023-11-15T00:00:00Z</CashedInDate>' +
                        '<ValidFromDate>2023-07-31T00:00:00Z</ValidFromDate>' +
                        '<ExpirationDate>2029-11-16T00:00:00Z</ExpirationDate>' +
                        '<PoReqd>N</PoReqd>' +
                        '<NumCashins>4</NumCashins>' +
                        '<NumTimesCashedIn>0</NumTimesCashedIn>' +
                        '<CreationDate>2023-07-31T16:33:48Z</CreationDate>' +
                    '</AccessCodeDetails>' +
            '</AccessCodeServiceResponse>';
            
            //System.assertEquals('https://ris.pearsoncmg.com/ac/services/getDetails?accesscode=WSEMMC-JAHID-OVARY-CLXIX-SPEIR-PRISB', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            res.setBody(xmlResponse);
            res.setStatusCode(200);             
        } else if(req.getEndpoint().contains('cashedInDateexpirationDateasnull')){
            
            res.setHeader('Content-Type', 'application/xml');
            String xmlResponse  = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<AccessCodeServiceResponse>' +
                '<status>Found</status>' +
                '<errorCode>0</errorCode>' +
                    '<AccessCodeDetails>' +
                        '<Accesscode>cashedInDateexpirationDateasnull</Accesscode>' +
                        '<AccesscodeTypeId>1510148</AccesscodeTypeId>' +
                        '<AccesscodeBatchId>8550959</AccesscodeBatchId>' +
                        '<CashedIn>Y</CashedIn>' +
                        '<CashedInDate></CashedInDate>' +
                        '<ValidFromDate>2023-07-31T00:00:00Z</ValidFromDate>' +
                        '<ExpirationDate></ExpirationDate>' +
                        '<PoReqd>N</PoReqd>' +
                        '<NumCashins>4</NumCashins>' +
                        '<NumTimesCashedIn>0</NumTimesCashedIn>' +
                        '<CreationDate>2023-07-31T16:33:48Z</CreationDate>' +
                    '</AccessCodeDetails>' +
            '</AccessCodeServiceResponse>';
            
            //System.assertEquals('https://ris.pearsoncmg.com/ac/services/getDetails?accesscode=cashedInDateexpirationDateasnull', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            res.setBody(xmlResponse);
            res.setStatusCode(200);             
        } else if(req.getEndpoint().contains('invalidAccessCode')){
            
            res.setHeader('Content-Type', 'application/xml');
            String xmlResponse  = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<AccessCodeServiceResponse>' +
            '<status>Not found</status>' +
            '<errorCode>4</errorCode>'+
			 '</AccessCodeServiceResponse>';            
            //System.assertEquals('https://ris.pearsoncmg.com/ac/services/getDetails?accesscode=SSSRCC-CLXII-BERNE-STUBS-LAPIS-ESEBO', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            res.setBody(xmlResponse);
            res.setStatusCode(200);             
        }  else if(req.getEndpoint().contains('statuscode300')){
            
            res.setHeader('Content-Type', 'application/xml');
            String xmlResponse  = '<?xml version="1.0" encoding="UTF-8"?>' +
            '<AccessCodeServiceResponse>' +
            '<status>Not found</status>' +
            '<errorCode>4</errorCode>'+
			 '</AccessCodeServiceResponse>';            
            //System.assertEquals('https://ris.pearsoncmg.com/ac/services/getDetails?accesscode=statuscode300', req.getEndpoint());
            System.assertEquals('GET', req.getMethod());
            res.setBody(xmlResponse);
            res.setStatusCode(300);             
        }            
        return res;	        

    }
    
}