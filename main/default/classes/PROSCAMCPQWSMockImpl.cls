@isTest
//------------------------------------------------------------------------------------//
//                 Unitary Test Methods for CPQQuotePanel_VFCtrl                      //
//------------------------------------------------------------------------------------//
global class PROSCAMCPQWSMockImpl implements WebServiceMock {
    global void doInvoke
      (
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType
      ) {
        if(request instanceof PROSCAMCPQWS.unlockQuoteRequest_element) {
          PROSCAMCPQWS.unlockQuoteResponse_element response_x = new PROSCAMCPQWS.unlockQuoteResponse_element();
          response_x.unlockedOk = true;
          response_x.message = '';
          response_x.statusAction = 'OK';
          response.put('response_x', response_x);
       }
       else if(request instanceof PROSCAMCPQWS.isQuoteLockedRequest_element) {
          PROSCAMCPQWS.isQuoteLockedResponse_element response_x = new PROSCAMCPQWS.isQuoteLockedResponse_element();
          response_x.isLocked = true;
          response_x.messageAction = '';
          response_x.statusAction = 'OK';
          response_x.user_x = 'test@cameleon-software.com';
          response.put('response_x', response_x);
       }
       else if(request instanceof PROSCAMCPQWS.runUIRequest_element) {
          PROSCAMCPQWS.runUIRequest_element request_x = (PROSCAMCPQWS.runUIRequest_element)request;
          PROSCAMCPQWS.runUIResponse_element response_x = new PROSCAMCPQWS.runUIResponse_element();
          String xmlSession = request_x.xmlSession;
          DOM.Document doc = new DOM.Document();
          String cartModel = null;
          String cpqErr = 'CPQ call has failed ';
          try{
            doc.load(xmlSession);    

            DOM.XMLNode rootNode = doc.getRootElement();
            for (Dom.XMLNode nodeLevel1 : rootNode.getChildElements())
            {
                if (nodeLevel1.getNodeType() == DOM.XMLNodeType.ELEMENT)
                {
                    if (nodeLevel1.getName()=='cartSessionSettings')
                    {
                       for (Dom.XMLNode nodeLevel2 : nodeLevel1.getChildElements())
                       {
                          if (nodeLevel2.getNodeType() == DOM.XMLNodeType.ELEMENT && nodeLevel2.getName()=='modelName')
                          {
                              cartModel = nodeLevel2.getText();
                          }
                       }
                    }
                }
            }
          } catch(Exception e){cpqErr=cpqErr+e.getMessage();}
          if(cartModel!=null && cartModel.equals('EXCEPTION')) {
             throw new CameleonCPQ.CPQRequestFormatter.CPQRequestException('This exception has been raised by a test method for code coverage purposes');
          }
          else if(cartModel!=null && cartModel.equals('FAILURE')) {
             response_x.messageAction= cpqErr;
             response_x.statusAction = 'ERROR';
             response_x.url = '';
          }
          else {
             response_x.messageAction = '';
             response_x.statusAction = 'OK';
             response_x.url = 'https://cpq.mycameleon.com/cart/initWS.do?settingsId=12345';
          }
          response.put('response_x', response_x);
       }
       else if(request instanceof PROSCAMCPQWS.getQuoteRequest_element) {
          PROSCAMCPQWS.getQuoteRequest_element request_x = (PROSCAMCPQWS.getQuoteRequest_element)request;
          PROSCAMCPQWS.getQuoteResponse_element response_x = new PROSCAMCPQWS.getQuoteResponse_element();
          response_x.messageAction = '';
          response_x.statusAction = 'OK';
          String cartXML;
          if(request_x.quoteKey.release==1) {
             cartXML = '<cart domain="-" id="CLM" release="1" type="C"><modelPK id="Default" release="1"/><fields></fields><totalCells><TotalPrice1>926.98</TotalPrice1><Tax>0</Tax><TCTotTax>0</TCTotTax><TotalPrice2>926.98</TotalPrice2><TCDiscount>0</TCDiscount><CommPctPrice1></CommPctPrice1><CommPctPrice2></CommPctPrice2><TotalComm1>0</TotalComm1><TotalComm2>0</TotalComm2></totalCells><cartLines><cartLine id="1" type="CT7" subline="no" service="CAT" parent="0" seqNum="0" datecreate="20151028 153228" dateupdate="20151028 153228"><ItemQty>1</ItemQty><UnitPrice>99</UnitPrice><TotalPrice>99</TotalPrice><ItemDescr>Brother - MFC-7340 Black-and-White All-in-One Laser Printer</ItemDescr><isSynced>true</isSynced></cartLine><cartLine id="2" type="CT7" subline="no" service="CAT" parent="0" seqNum="1" datecreate="20151028 153234" dateupdate="20151028 153234"><ItemQty>1</ItemQty><UnitPrice>399.99</UnitPrice><TotalPrice>399.99</TotalPrice><ItemDescr>Dell Inspiron I560-2133NBK Desktop &amp; 20&quot; LCD Monitor Package</ItemDescr><isSynced></isSynced></cartLine><cartLine id="3" type="CT7" subline="no" service="CAT" parent="0" seqNum="2" datecreate="20151028 153240" dateupdate="20151028 153240"><ItemQty>1</ItemQty><UnitPrice>279.99</UnitPrice><TotalPrice>279.99</TotalPrice><ItemDescr>Asus EeePC 1001PX 10 inch netbook</ItemDescr><isSynced>true</isSynced></cartLine><cartLine id="4" type="CT7" subline="no" service="CAT" parent="0" seqNum="3" datecreate="20151028 153507" dateupdate="20151028 153507"><ItemQty>1</ItemQty><UnitPrice>69</UnitPrice><TotalPrice>69</TotalPrice><ItemDescr>HP - Network-Ready Black-and-White All-in-One Laser Printer</ItemDescr><isSynced>true</isSynced></cartLine><cartLine id="5" type="CT7" subline="no" service="CAT" parent="0" seqNum="4" datecreate="20151028 153509" dateupdate="20151028 153509"><ItemQty>1</ItemQty><UnitPrice>79</UnitPrice><TotalPrice>79</TotalPrice><ItemDescr>Brother - MFC-J270w Wireless All-In-One Printer</ItemDescr><isSynced></isSynced></cartLine></cartLines><cartAdjustments></cartAdjustments></cart>';
          }
          else if(request_x.quoteKey.release==2) {
             cartXML = '<cart domain="-" id="CLM" release="2" type="C"><modelPK id="Default" release="1"/><fields></fields><totalCells><TotalPrice1>1926.98</TotalPrice1><Tax>0</Tax><TCTotTax>0</TCTotTax><TotalPrice2>1926.98</TotalPrice2><TCDiscount>0</TCDiscount><CommPctPrice1></CommPctPrice1><CommPctPrice2></CommPctPrice2><TotalComm1>0</TotalComm1><TotalComm2>0</TotalComm2></totalCells><cartLines><cartLine id="1" type="CT7" subline="no" service="CAT" parent="0" seqNum="0" datecreate="20151028 153228" dateupdate="20151028 153228"><ItemQty>1</ItemQty><UnitPrice>199</UnitPrice><TotalPrice>199</TotalPrice><ItemDescr>Brother - MFC-7340 Black-and-White All-in-One Laser Printer</ItemDescr><isSynced>true</isSynced></cartLine><cartLine id="2" type="CT7" subline="no" service="CAT" parent="0" seqNum="1" datecreate="20151028 153234" dateupdate="20151028 153234"><ItemQty>1</ItemQty><UnitPrice>1399.99</UnitPrice><TotalPrice>1399.99</TotalPrice><ItemDescr>Dell Inspiron I560-2133NBK Desktop &amp; 20&quot; LCD Monitor Package</ItemDescr><isSynced></isSynced></cartLine><cartLine id="3" type="CT7" subline="no" service="CAT" parent="0" seqNum="2" datecreate="20151028 153240" dateupdate="20151028 153240"><ItemQty>1</ItemQty><UnitPrice>1279.99</UnitPrice><TotalPrice>1279.99</TotalPrice><ItemDescr>Asus EeePC 1001PX 10 inch netbook</ItemDescr><isSynced>true</isSynced></cartLine><cartLine id="4" type="CT7" subline="no" service="CAT" parent="0" seqNum="3" datecreate="20151028 153507" dateupdate="20151028 153507"><ItemQty>1</ItemQty><UnitPrice>169</UnitPrice><TotalPrice>169</TotalPrice><ItemDescr>HP - Network-Ready Black-and-White All-in-One Laser Printer</ItemDescr><isSynced>true</isSynced></cartLine><cartLine id="5" type="CT7" subline="no" service="CAT" parent="0" seqNum="4" datecreate="20151028 153509" dateupdate="20151028 153509"><ItemQty>1</ItemQty><UnitPrice>179</UnitPrice><TotalPrice>179</TotalPrice><ItemDescr>Brother - MFC-J270w Wireless All-In-One Printer</ItemDescr><isSynced></isSynced></cartLine></cartLines><cartAdjustments></cartAdjustments></cart>';
          }
          response_x.xmlCart = EncodingUtil.base64Encode(Blob.valueOf(cartXML));
          response.put('response_x', response_x);
       }
       else if(request instanceof PROSCAMCPQWS.getQuoteListRequest_element) {
          PROSCAMCPQWS.getQuoteListResponse_element response_x = new PROSCAMCPQWS.getQuoteListResponse_element();
          response_x.messageAction = '';
          response_x.statusAction = 'OK';
          PROSCAMCPQWS.QueryResultSetType resultSet = new PROSCAMCPQWS.QueryResultSetType();
          resultSet.count = 1;
          PROSCAMCPQWS.QueryRecordType rec = new PROSCAMCPQWS.QueryRecordType();
          rec.fieldValues = new String[] {'FIELD1_VALUE','FIELD2_VALUE','FIELD3_VALUE'};
          resultSet.records = new PROSCAMCPQWS.QueryRecordType[]{rec};
          response_x.results = resultSet;
          response.put('response_x', response_x);
       }
       else if(request instanceof PROSCAMCPQWS.getQuoteReleasesListRequest_element) {
          PROSCAMCPQWS.getQuoteReleasesListResponse_element response_x = new PROSCAMCPQWS.getQuoteReleasesListResponse_element();
          response_x.messageAction = '';
          response_x.statusAction = 'OK';
          response_x.xmlReleasesList = '<releasesList cartDomainId="-" cartId="PCH" modelName="Default_FORCE" modelRelease="1" includeMetaData="yes" language="US"><fields><field id="ParameterTab.QuoteDescription">Quote Description</field><field id="CartInfoTab.HQQuotedAmount"></field><field id="ChangeAndControlTab.CurrentStatus">Current Status</field></fields><release number="1"><field id="ParameterTab.QuoteDescription" value="null"/><field id="CartInfoTab.HQQuotedAmount" value=""/><field id="ChangeAndControlTab.CurrentStatus" value="Draft:Draft"/></release></releasesList>';
          response.put('response_x', response_x);
       }
       else {
          response.put('response_x', 'UNMATCHED RESPONSE OBJECT');
       }
    }
}