global class CPQParser {
     private static final String ELEM_CART = 'cart';
     private static final String ELEM_CART_FIELDS = 'fields';
     private static final String ELEM_CART_LINE = 'cartLine';
     private static final String ELEM_CART_TOTAL_CELLS = 'totalCells';
     private static final String ELEM_CART_DOC = 'cartDocument';

     private static final String ATTRIB_LINE_ID = 'id';
     private static final String ATTRIB_LINE_NUM = 'seqNum';
     private static final String ATTRIB_LINE_TYPE = 'type';
     private static final String ATTRIB_LINE_PARENT = 'parent';
     private static final String ATTRIB_LINE_SUBLINE = 'subline';
     
     private static final String ELEM_DOC_ID = 'id';
     private static final String ELEM_DOC_NAME = 'name';
     private static final String ELEM_DOC_DESCR = 'descr';
     private static final String ELEM_DOC_URL = 'url';

     public Quote quo = null;
     
     public CPQParser(Blob quoteXML) {
         try{
             final XmlStreamReader reader = new XmlStreamReader(quoteXML.toString());
             quo = parseQuote(reader);
         }catch(Exception e){
            System.debug(Logginglevel.ERROR,e);
            throw e;
         }
     }

     public Quote getQuote(){
        return this.quo;
     }

    //-------------------------------------------------------------------//
    //                          PARSE QUOTE XML                          //
    //-------------------------------------------------------------------//

    // Create inner classes Quote, QuoteLine & QuoteDocument for processing
    global class Quote
    {
        private String id;
        private String domain;
        private String release;
        
        private Map<String,String> fields = new Map<String, String>();
        private List<QuoteLine> quoteLines = new List<QuoteLine>();
        private List<QuoteDocument> quoteDocuments = new List<QuoteDocument>();

        global String getId() {return id;}
        global String getDomain() {return domain;}
        global String getRelease() {return release;}        
        global Map<String,String> getFields() {return fields;}
        global Map<String,String> getFieldsWithoutTab() {
            Map<String,String> flds = new Map<String,String>();
            for (String fld : fields.keySet()) {
               final String[] f = fld.split('\\.');
               flds.put((f.size()>0?f[f.size()-1]:fld),fields.get(fld));
            }
            return flds;
        }
        global String getField(String fieldName) {return fields.get(fieldName);}
        global List<QuoteLine> getLines(Integer level) {
            List<QuoteLine> res = new List<QuoteLine>();
            List<QuoteLine> aql = getAllLines();
            for (QuoteLine line : aql)
                 if (line.level==level) res.add(line);
            return res;
        }
        global List<QuoteLine> getLines(String type) {
            List<QuoteLine> res = new List<QuoteLine>();
            List<QuoteLine> aql = getAllLines();
            for (QuoteLine line : aql)
                 if (line.lineType.equals(type)) res.add(line);
            return res;
        }
        global List<QuoteLine> getAllLines() {
            List<QuoteLine> res = new List<QuoteLine>();
            for (QuoteLine line : quoteLines)
                 res.addAll(line.getAllLines(new List<QuoteLine>{line}));
            return res;
        }
    }

    global class QuoteLine
    {
        private String  id;
        private String  lineType;
        private String  seqNum;
        private String  parent;
        private Boolean IsSubline;
        private Integer level;

        private List<QuoteLine> quoteLines = new List<QuoteLine>();
        private Map<String,String> columns = new Map<String, String>();
        
        global String getId() {return id;}
        global String getLineType() {return lineType;}
        global String getSeqNum() {return seqNum;}
        global Boolean getIsSubline() {return IsSubline;}
        global Boolean hasSublines() {return (this.quoteLines.size()>0);}
        global Integer getLevel() {return level;}
        global List<QuoteLine> getSublines() {return quoteLines;}
        global List<QuoteLine> getAllLines(List<QuoteLine> lines) {
            List<QuoteLine> res = new List<QuoteLine>();
            for (QuoteLine line : lines) {
              res.add(line);
              if (line.hasSublines()) {
                  List<QuoteLine> sublines = getAllLines(line.getSublines());
                  for (QuoteLine subline : sublines)
                    res.add(subline);
              }
            }
            return res;
        }
        global Map<String,String> getColumns() {return columns;}
        global String getColumnValue(String colName) {return columns.get(colName);}
    }

    global class QuoteDocument
    {
        private String id;
        private String name;
        private String url;
    }

    // Parse Quote
    private static Quote parseQuote(XmlStreamReader reader)
    {
        Quote quo = new Quote();
        Integer level = 0;
        String val;
        
        while(reader.hasNext())
        {
            if (reader.getEventType() == XmlTag.START_ELEMENT)
            {
                val = '';
                if (reader.getLocalName()==ELEM_CART)
                {
                    quo.domain = reader.getAttributeValue(null, 'domain');
                    quo.id = reader.getAttributeValue(null, 'id');
                    quo.release = reader.getAttributeValue(null, 'release');
                }
                else if (reader.getLocalName()==ELEM_CART_FIELDS)
                    parseQuoteFieldsAndTotals(reader,quo);
                else if (reader.getLocalName()==ELEM_CART_LINE)
                {
                    QuoteLine quoteLine = parseQuoteLine(reader,quo,level);
                    quo.quoteLines.add(quoteLine);
                }
                else if (reader.getLocalName()==ELEM_CART_TOTAL_CELLS)
                    parseQuoteFieldsAndTotals(reader,quo);
                else if (reader.getLocalName()==ELEM_CART_DOC)
                {
                    QuoteDocument quoteDocument = parseQuoteDoc(reader,quo);
                    quo.quoteDocuments.add(quoteDocument);
                }
            }
            else if (reader.getEventType()==XmlTag.END_ELEMENT && reader.getLocalName()==ELEM_CART_LINE)
                break;
            reader.next();
        }
        return quo;
    }

    // Parse Quote Line
    private static QuoteLine parseQuoteLine(XmlStreamReader reader, Quote quote, Integer level)
    {
        QuoteLine quoteLine = new QuoteLine();
        quoteLine.id = reader.getAttributeValue(null, ATTRIB_LINE_ID);
        quoteLine.lineType= reader.getAttributeValue(null, ATTRIB_LINE_TYPE);
        quoteLine.seqNum = reader.getAttributeValue(null, ATTRIB_LINE_NUM);
        quoteLine.parent = reader.getAttributeValue(null, ATTRIB_LINE_PARENT);
        quoteLine.IsSubline = (reader.getAttributeValue(null, ATTRIB_LINE_SUBLINE)!=null && reader.getAttributeValue(null, ATTRIB_LINE_SUBLINE).equals('yes'))?true:false;
        quoteLine.level = level;
        
        System.debug(Logginglevel.INFO,'Parsing line :'+quoteLine.id+' - type ='+quoteLine.lineType+' - seqNum=' +quoteLine.seqNum+ ' - subline :'+quoteLine.IsSubline+ ' - level :'+quoteLine.level);

        String elt;
        String val;

        while(reader.hasNext())
        {
            if (reader.getEventType()==XmlTag.START_ELEMENT)
            {
                 val='';
                 if (reader.getLocalName()==ELEM_CART_LINE)
                 {
                    String lid = reader.getAttributeValue(null, ATTRIB_LINE_ID);
                    if (lid!=null && lid!=quoteLine.id) {
                        QuoteLine quoteSubLine = parseQuoteLine(reader,quote,level+1);
                        quoteLine.quoteLines.add(quoteSubLine);
                    }
                 }
                 else
                    elt = reader.getLocalName();
            }
            else if (reader.getEventType()==XmlTag.CHARACTERS)
                val += (reader.getText().trim().length()>0 ? reader.getText() : '');
            else if (reader.getEventType()==XmlTag.END_ELEMENT && reader.getLocalName()==ELEM_CART_LINE)
                break;
            else if (reader.getEventType()==XmlTag.END_ELEMENT && reader.getLocalName()==elt)
                quoteLine.columns.put(elt, val);
            reader.next();
        }
        return quoteLine;
    }

    // Parse Quote Fields & Total Cells
    private static void parseQuoteFieldsAndTotals(XmlStreamReader reader, Quote quote)
    {
        String elt;
        String val;

        while(reader.hasNext())
        {
            if (reader.getEventType()==XmlTag.START_ELEMENT)
            {
                val = '';
                elt = reader.getLocalName();
            }
            else if (reader.getEventType()==XmlTag.CHARACTERS)
                val += (reader.getText().trim().length()>0 ? reader.getText() : '');
            else if (reader.getEventType()==XmlTag.END_ELEMENT && (reader.getLocalName()==ELEM_CART_TOTAL_CELLS || reader.getLocalName()==ELEM_CART_FIELDS))
                break;
            else if (reader.getEventType()==XmlTag.END_ELEMENT && reader.getLocalName()==elt)
                quote.fields.put(elt, val);
            reader.next();
        }
    }

    // Parse Quote Documents
    private static QuoteDocument parseQuoteDoc(XmlStreamReader reader, Quote cart)
    {
        QuoteDocument quoteDocument = new QuoteDocument();
        String elt;
        String val;

        while(reader.hasNext())
        {
            if (reader.getEventType()==XmlTag.START_ELEMENT)
            {
                val = '';
                elt = reader.getLocalName();
            }
            else if (reader.getEventType()==XmlTag.CHARACTERS)
            {
                val += (reader.getText().trim().length()>0 ? reader.getText() : '');
            }
            else if (reader.getEventType()==XmlTag.END_ELEMENT && reader.getLocalName()==ELEM_CART_DOC)
                break;
            else if (reader.getEventType()==XmlTag.END_ELEMENT)
            {
                if (elt==ELEM_DOC_ID && reader.getLocalName()==elt) quoteDocument.id= val;
                else if (elt==ELEM_DOC_NAME && reader.getLocalName()==elt) quoteDocument.name= val;
                else if (elt==ELEM_DOC_URL && reader.getLocalName()==elt) quoteDocument.url= val;
            }
            reader.next();
        }
        return quoteDocument;
    }

    //------------------------------------------------------------------------------------//
    //                              Unitary Test Methods                                  //
    //------------------------------------------------------------------------------------//

    // Positive test
    private static testMethod void runTest()
    {
        String cartXML = '<cartSessionResults><cart domain="00DA0000000KzQe" id="a01A000000BWGsl" release="1" type="C"><modelPK id="CPQModel_2011" release="1"/><createInfo userID="005A0000000fv5g" groupID="System Administrator" userName="Development Administrator" date="20111215 170118"/><updateInfo userID="005A0000000fv5g" groupID="System Administrator" userName="Development Administrator" date="20111215 170554"/><ownerInfo userID="005A0000000fv5g" groupID="System Administrator" userName="Development Administrator" date="20111215 170118"/><activeInfo active="on" date="20111215 170118"/><statusInfo status="Draft" date="20111215 170118"/><fields><ParameterTab.DomainId>00DA0000000KzQe</ParameterTab.DomainId><ParameterTab.ReleaseNumber>1</ParameterTab.ReleaseNumber><ParameterTab.QuoteId>a01A000000BWGsl</ParameterTab.QuoteId><ParameterTab.CustomerId/><ParameterTab.Language>US</ParameterTab.Language><ParameterTab.Currency>USD</ParameterTab.Currency><ParameterTab.QuoteDescription>Force.com QUOTE</ParameterTab.QuoteDescription><ParameterTab.ApplicationDate>20111231 000000</ParameterTab.ApplicationDate><ParameterTab.PriceList>GEN</ParameterTab.PriceList><AddressTab.SoldTo.CustomerId/><AddressTab.SoldTo.CustomerName/><AddressTab.BillTo.CustomerId/><AddressTab.BillTo.CustomerName/><AddressTab.BillTo.Address1>5215 Old Orchard Rd.</AddressTab.BillTo.Address1><AddressTab.BillTo.City>Skokie</AddressTab.BillTo.City><AddressTab.BillTo.ZipCode>60077</AddressTab.BillTo.ZipCode><AddressTab.BillTo.State>Illinois</AddressTab.BillTo.State><AddressTab.BillTo.Country>USA</AddressTab.BillTo.Country><AddressTab.ShipTo.CustomerId/><AddressTab.ShipTo.CustomerName/><AddressTab.ShipTo.Address1>5215 Old Orchard Rd.</AddressTab.ShipTo.Address1><AddressTab.ShipTo.City>Skokie</AddressTab.ShipTo.City><AddressTab.ShipTo.ZipCode>60077</AddressTab.ShipTo.ZipCode><AddressTab.ShipTo.State>Illinois</AddressTab.ShipTo.State><AddressTab.ShipTo.Country>USA</AddressTab.ShipTo.Country><CartInfoTab.HQQuotedAmount>96748.51</CartInfoTab.HQQuotedAmount><CartInfoTab.ContractStartDate>20100101 000000</CartInfoTab.ContractStartDate><CartInfoTab.ContractDuration>12</CartInfoTab.ContractDuration><CartInfoTab.Expires>20111231 000000</CartInfoTab.Expires><CartInfoTab.ActiveRelease>1</CartInfoTab.ActiveRelease><CartInfoTab.Name>Force.com QUOTE</CartInfoTab.Name><OrderInfoTab.OrderId/><OrderInfoTab.PaymentNum/><ChangeAndControlTab.CurrentActiveRelease>1</ChangeAndControlTab.CurrentActiveRelease><ChangeAndControlTab.DateActiveRelease>20111215 170118</ChangeAndControlTab.DateActiveRelease><ChangeAndControlTab.CurrentStatus>Draft</ChangeAndControlTab.CurrentStatus><ChangeAndControlTab.DateStatus>20111215 170118</ChangeAndControlTab.DateStatus><ChangeAndControlTab.CurrentOwnerId>005A0000000fv5g</ChangeAndControlTab.CurrentOwnerId><ChangeAndControlTab.CurrentOwnerName>Development Administrator</ChangeAndControlTab.CurrentOwnerName><ChangeAndControlTab.CurrentOwnerGroup>System Administrator</ChangeAndControlTab.CurrentOwnerGroup><ChangeAndControlTab.DateOwner>20111215 170118</ChangeAndControlTab.DateOwner><ChangeAndControlTab.UserCreateId>005A0000000fv5g</ChangeAndControlTab.UserCreateId><ChangeAndControlTab.UserCreateName>Development Administrator</ChangeAndControlTab.UserCreateName><ChangeAndControlTab.UserCreateGroup>System Administrator</ChangeAndControlTab.UserCreateGroup><ChangeAndControlTab.CreateDate>20111215 170118</ChangeAndControlTab.CreateDate><ChangeAndControlTab.LastUserUpdateId>005A0000000fv5g</ChangeAndControlTab.LastUserUpdateId><ChangeAndControlTab.LastUserUpdateName>Development Administrator</ChangeAndControlTab.LastUserUpdateName><ChangeAndControlTab.LastUserUpdateGroup>System Administrator</ChangeAndControlTab.LastUserUpdateGroup><ChangeAndControlTab.LastUpdateDate>20111215 170554</ChangeAndControlTab.LastUpdateDate></fields><totalCells><TCTotOTPrice>28860</TCTotOTPrice><TCTotOTDiscount>0</TCTotOTDiscount><TCTotMRDiscount>0</TCTotMRDiscount><TCTot1YDiscount>5731.25</TCTot1YDiscount><TCTotMRPrice>6134.98</TCTotMRPrice><TotalPrice1>28860</TotalPrice1><TotalPrice2>6134.98</TotalPrice2><TCTot1YRevenue>96748.51</TCTot1YRevenue><CommPctPrice1>0.05</CommPctPrice1><CommPctPrice2>0.0289</CommPctPrice2><TotalComm1>1443</TotalComm1><TotalComm2>3191.42</TotalComm2></totalCells><cartLines><cartLine id="1" type="CP7" subline="no" service="CONF_DEMO" parent="0" seqNum="0"><SyncID/><ItemSheet/><ContractStartDate/><ContractDuration/><ItemQty>1</ItemQty><OTPrice>28140</OTPrice><OTDiscPct>0</OTDiscPct><TotOTRevenue>28140</TotOTRevenue><MRPrice>4585</MRPrice><MRDiscPct>0</MRDiscPct><TotMRRevenue>4585</TotMRRevenue><MR1YFree>1.25</MR1YFree><Refunding>0</Refunding><Tot1YRevenue>77428.75</Tot1YRevenue><Tot1YDiscount>5731.25</Tot1YDiscount><MaxOTDiscPct>0.22</MaxOTDiscPct><MaxMRDiscPct>0.185</MaxMRDiscPct><Min1YRevenue>40000</Min1YRevenue><TotOTPrice>28140</TotOTPrice><TotMRPrice>4585</TotMRPrice><ItemID>CPE.wksHiTech/CP/cpCloudHosting.gp.wksHiTech/SBL/RootLine</ItemID><ItemDescr>Hosting Offer: from 03/15/2012 - duration  12 months - Datacenter in Chicago</ItemDescr><cartLines><cartLine id="2" type="CP7" subline="yes" service="CONF_DEMO" parent="1" seqNum="1"><SyncID/><ItemSheet/><ContractStartDate/><ContractDuration/><ItemQty>1</ItemQty><OTPrice>28140</OTPrice><OTDiscPct>0</OTDiscPct><TotOTRevenue>0</TotOTRevenue><MRPrice>4585</MRPrice><MRDiscPct>0</MRDiscPct><TotMRRevenue>0</TotMRRevenue><MR1YFree>0</MR1YFree><Refunding>0</Refunding><Tot1YRevenue>0</Tot1YRevenue><Tot1YDiscount>0</Tot1YDiscount><MaxOTDiscPct>0</MaxOTDiscPct><MaxMRDiscPct>0</MaxMRDiscPct><Min1YRevenue>0</Min1YRevenue><TotOTPrice>0</TotOTPrice><TotMRPrice>0</TotMRPrice><ItemID>package</ItemID><ItemDescr>Cloud hosting package Gold - bandwidth : 2 Mbit/s - Fast Ethernet - SAN capacity : SAN storage 512Gb</ItemDescr><cartLines><cartLine id="3" type="CP7" subline="yes" service="CONF_DEMO" parent="2" seqNum="2"><SyncID/><ItemSheet/><ContractStartDate/><ContractDuration/><ItemQty>1</ItemQty><OTPrice>8430</OTPrice><OTDiscPct>0</OTDiscPct><TotOTRevenue>0</TotOTRevenue><MRPrice>0</MRPrice><MRDiscPct>0</MRDiscPct><TotMRRevenue>0</TotMRRevenue><MR1YFree>0</MR1YFree><Refunding>0</Refunding><Tot1YRevenue>0</Tot1YRevenue><Tot1YDiscount>0</Tot1YDiscount><MaxOTDiscPct>0</MaxOTDiscPct><MaxMRDiscPct>0</MaxMRDiscPct><Min1YRevenue>0</Min1YRevenue><TotOTPrice>0</TotOTPrice><TotMRPrice>0</TotMRPrice><ItemID>server</ItemID><ItemDescr>Server # 1 (8 GB, Intel - 2 CPU bi core, Windows Server)</ItemDescr></cartLine><cartLine id="13" type="CP7" subline="yes" service="CONF_DEMO" parent="2" seqNum="3"><SyncID/><ItemSheet/><ContractStartDate/><ContractDuration/><ItemQty>1</ItemQty><OTPrice>8430</OTPrice><OTDiscPct>0</OTDiscPct><TotOTRevenue>0</TotOTRevenue><MRPrice>0</MRPrice><MRDiscPct>0</MRDiscPct><TotMRRevenue>0</TotMRRevenue><MR1YFree>0</MR1YFree><Refunding>0</Refunding><Tot1YRevenue>0</Tot1YRevenue><Tot1YDiscount>0</Tot1YDiscount><MaxOTDiscPct>0</MaxOTDiscPct><MaxMRDiscPct>0</MaxMRDiscPct><Min1YRevenue>0</Min1YRevenue><TotOTPrice>0</TotOTPrice><TotMRPrice>0</TotMRPrice><ItemID>server</ItemID><ItemDescr>Server # 2 (8 GB, VM : 2 VCPU, Linux Red Hat)</ItemDescr></cartLine><cartLine id="23" type="CP7" subline="yes" service="CONF_DEMO" parent="2" seqNum="4"><SyncID/><ItemSheet/><ContractStartDate/><ContractDuration/><ItemQty>1</ItemQty><OTPrice>8430</OTPrice><OTDiscPct>0</OTDiscPct><TotOTRevenue>0</TotOTRevenue><MRPrice>0</MRPrice><MRDiscPct>0</MRDiscPct><TotMRRevenue>0</TotMRRevenue><MR1YFree>0</MR1YFree><Refunding>0</Refunding><Tot1YRevenue>0</Tot1YRevenue><Tot1YDiscount>0</Tot1YDiscount><MaxOTDiscPct>0</MaxOTDiscPct><MaxMRDiscPct>0</MaxMRDiscPct><Min1YRevenue>0</Min1YRevenue><TotOTPrice>0</TotOTPrice><TotMRPrice>0</TotMRPrice><ItemID>server</ItemID><ItemDescr>Server # 3 (8 GB, VM : 2 VCPU, Linux Red Hat)</ItemDescr></cartLine></cartLines></cartLine><cartLine id="40" type="CP7" subline="yes" service="CONF_DEMO" parent="1" seqNum="2"><SyncID/><ItemSheet/><ContractStartDate/><ContractDuration/><ItemQty>1</ItemQty><OTPrice>0</OTPrice><OTDiscPct>0</OTDiscPct><TotOTRevenue>0</TotOTRevenue><MRPrice>0</MRPrice><MRDiscPct>0</MRDiscPct><TotMRRevenue>0</TotMRRevenue><MR1YFree>0</MR1YFree><Refunding>0</Refunding><Tot1YRevenue>0</Tot1YRevenue><Tot1YDiscount>0</Tot1YDiscount><MaxOTDiscPct>0</MaxOTDiscPct><MaxMRDiscPct>0</MaxMRDiscPct><Min1YRevenue>0</Min1YRevenue><TotOTPrice>0</TotOTPrice><TotMRPrice>0</TotMRPrice><ItemID>service</ItemID><ItemDescr>Optional Services</ItemDescr></cartLine></cartLines></cartLine><cartLine id="41" type="FO" subline="no" service="null" parent="0" seqNum="1"><SyncID/><ItemSheet>FOLDER</ItemSheet><ContractStartDate/><ContractDuration/><ItemQty>1</ItemQty><OTPrice>0</OTPrice><OTDiscPct>0</OTDiscPct><TotOTRevenue>720</TotOTRevenue><MRPrice>0</MRPrice><MRDiscPct>0</MRDiscPct><TotMRRevenue>1549.98</TotMRRevenue><MR1YFree>0</MR1YFree><Refunding>0</Refunding><Tot1YRevenue>19319.76</Tot1YRevenue><Tot1YDiscount>0</Tot1YDiscount><MaxOTDiscPct>0</MaxOTDiscPct><MaxMRDiscPct>0</MaxMRDiscPct><Min1YRevenue>0</Min1YRevenue><TotOTPrice>720</TotOTPrice><TotMRPrice>1549.98</TotMRPrice><ItemID/><ItemDescr/><cartLines><cartLine id="42" type="CT7" subline="no" service="CATALOG_DEMO" parent="41" seqNum="2"><SyncID/><ItemSheet/><ContractStartDate/><ContractDuration/><ItemQty>1</ItemQty><OTPrice>720</OTPrice><OTDiscPct>0</OTDiscPct><TotOTRevenue>720</TotOTRevenue><MRPrice>650</MRPrice><MRDiscPct>0</MRDiscPct><TotMRRevenue>650</TotMRRevenue><MR1YFree>0</MR1YFree><Refunding>0</Refunding><Tot1YRevenue>8520</Tot1YRevenue><Tot1YDiscount>0</Tot1YDiscount><MaxOTDiscPct>0</MaxOTDiscPct><MaxMRDiscPct>0</MaxMRDiscPct><Min1YRevenue>0</Min1YRevenue><TotOTPrice>720</TotOTPrice><TotMRPrice>650</TotMRPrice><ItemID>CPE.wksHiTech/SI/I15R-1197MRB</ItemID><ItemDescr>Dell - Inspiron Laptop / IntelÂ® Core? i3 Processor / 15.6&quot; Display</ItemDescr><cartLines><cartLine id="43" type="LNKCT" subline="yes" service="CATALOG_DEMO" parent="42" seqNum="3"><itemXML><cat:RelatedProductLink wks="wksHiTech" name="ESP 9250" cpe="CPE.wksHiTech/SI/ESP 9250" quantity="1.0" unit="" productLinkType="Breakdown" xmlns:cat="com.cameleon.business.xml.cameleonTree-7.2.0.0"/></itemXML><SyncID/><ItemSheet/><ContractStartDate/><ContractDuration/><ItemQty>1</ItemQty><OTPrice>0</OTPrice><OTDiscPct>0</OTDiscPct><TotOTRevenue>0</TotOTRevenue><MRPrice>0</MRPrice><MRDiscPct>0</MRDiscPct><TotMRRevenue>0</TotMRRevenue><MR1YFree>0</MR1YFree><Refunding>0</Refunding><Tot1YRevenue>0</Tot1YRevenue><Tot1YDiscount>0</Tot1YDiscount><MaxOTDiscPct>0</MaxOTDiscPct><MaxMRDiscPct>0</MaxMRDiscPct><Min1YRevenue>0</Min1YRevenue><TotOTPrice>0</TotOTPrice><TotMRPrice>0</TotMRPrice><ItemID/><ItemDescr/></cartLine></cartLines></cartLine><cartLine id="44" type="CT7" subline="no" service="CATALOG_DEMO" parent="41" seqNum="3"><SyncID/><ItemSheet/><ContractStartDate/><ContractDuration/><ItemQty>1</ItemQty><OTPrice/><OTDiscPct>0</OTDiscPct><TotOTRevenue>0</TotOTRevenue><MRPrice>399.99</MRPrice><MRDiscPct>0</MRDiscPct><TotMRRevenue>399.99</TotMRRevenue><MR1YFree>0</MR1YFree><Refunding>0</Refunding><Tot1YRevenue>4799.88</Tot1YRevenue><Tot1YDiscount>0</Tot1YDiscount><MaxOTDiscPct>0</MaxOTDiscPct><MaxMRDiscPct>0</MaxMRDiscPct><Min1YRevenue>0</Min1YRevenue><TotOTPrice>0</TotOTPrice><TotMRPrice>399.99</TotMRPrice><ItemID>CPE.wksHiTech/SI/I560-2133NBK</ItemID><ItemDescr>Dell Inspiron I560-2133NBK Desktop &amp; 20&quot; LCD Monitor Package</ItemDescr></cartLine><cartLine id="45" type="CT7" subline="no" service="CATALOG_DEMO" parent="41" seqNum="4"><SyncID/><ItemSheet/><ContractStartDate/><ContractDuration/><ItemQty>1</ItemQty><OTPrice/><OTDiscPct>0</OTDiscPct><TotOTRevenue>0</TotOTRevenue><MRPrice>499.99</MRPrice><MRDiscPct>0</MRDiscPct><TotMRRevenue>499.99</TotMRRevenue><MR1YFree>0</MR1YFree><Refunding>0</Refunding><Tot1YRevenue>5999.88</Tot1YRevenue><Tot1YDiscount>0</Tot1YDiscount><MaxOTDiscPct>0</MaxOTDiscPct><MaxMRDiscPct>0</MaxMRDiscPct><Min1YRevenue>0</Min1YRevenue><TotOTPrice>0</TotOTPrice><TotMRPrice>499.99</TotMRPrice><ItemID>CPE.wksHiTech/SI/MB292LL</ItemID><ItemDescr>AppleÂ® - iPad? with Wi-Fi - 16GB</ItemDescr></cartLine></cartLines></cartLine></cartLines><eventHistory/><cartAdjustments/></cart><cartDocuments><cartDocument><id>006A0000004jOs2IAE_20100521_133727.PDF</id><name>006A0000004jOs2IAE_20100521_133727.PDF</name><url>https://sfdc.mycameleon.com/cart/Resources/eReport/-_006A0000004jOs2IAE_1/006A0000004jOs2IAE_20100521_133727.PDF</url></cartDocument><cartDocument><id>006A0000004jOs2IAE_20100521_133736.PDF</id><name>006A0000004jOs2IAE_20100521_133736.PDF</name><url>https://sfdc.mycameleon.com/cart/Resources/eReport/-_006A0000004jOs2IAE_1/006A0000004jOs2IAE_20100521_133736.PDF</url></cartDocument></cartDocuments></cartSessionResults>';
        CPQParser parser = new CPQParser(Blob.valueOf(cartXML)); 
        CPQParser.Quote quote = parser.getQuote();
        String q_Id = quote.getId();
        String q_Dom = quote.getDomain();
        String q_Rel = quote.getRelease();     
        Map<String,String> flds = quote.getFields();
        Map<String,String> fldsWT = quote.getFieldsWithoutTab();
        String f = quote.getField('Name');
        List<QuoteLine> aql = quote.getAllLines();
        System.assertEquals(11,aql.size());
        List<QuoteLine> ql = quote.getLines(0);
        System.assertEquals(2,ql.size());
        ql = quote.getLines(1);
        System.assertEquals(5,ql.size());
        ql = quote.getLines('CT7');
        System.assertEquals(3,ql.size());
        ql = quote.getLines('CP7');
        System.assertEquals(6,ql.size());
        
        String ql_Id = aql[0].getId();
        String ql_Type = aql[0].getLineType();
        String ql_Num = aql[0].getSeqNum();
        Boolean ql_FlagSL = aql[0].getIsSubline();
        Integer ql_Level = aql[0].getLevel();
    }
}