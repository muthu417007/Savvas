/********************************************************************** 
Name: RPASAPPriceCheckUtility
Purpose: W-013141 - Utility class to generate SAP sample request and parse response.
History: 
VERSION AUTHOR DATE       DETAIL   DESCRIPITOPN
1.0     CTS    29/06/2023 INITIAL  DEVELOPMENT
***********************************************************************/
public class RPASAPPriceCheckUtility {
    
    /*************************************************************************** 
* Description: Generates request XML for SAP integration to get pricing.
***************************************************************************/
    public static String getRequestXML(list<OrderLineItem__c> olisToSendToSAP, Order__c order)
    {
        try{
            String strG = 'G';
            Boolean isHeaderAdded = false;
            String xsi = Label.SAP_Price_Check_XSI;
            String xsd = Label.SAP_Price_Check_XSD;
            list<Element> itemChildElements = new list<Element>();
            list<Element> detailChildElements = new list<Element>();
            list<Element> headerChildElements = new list<Element>();
            list<Element> rootChildElements = new list<Element>();
            list<Namespaces> rootNameSpaces = new list<Namespaces>();
            
            //Add Header values
            Element headerChild = assignValueToElement('BillToAccountNumber', getTendigitSAPAccNumber(order.RPA_Bill_to_SAP_Account__c), null, null, null);
            headerChildElements.add(headerChild);
            headerChild = assignValueToElement('ShipToAccountNumber', getTendigitSAPAccNumber(order.RPA_Ship_to_SAP_Account__c), null, null, null);
            headerChildElements.add(headerChild);
            headerChild = assignValueToElement('SalesOrganization', strG, null, null, null);
            headerChildElements.add(headerChild);
            headerChild = assignValueToElement('RequestID', order.Id+'_'+math.random()+'_'+'SF', null, null, null);
            headerChildElements.add(headerChild);
            headerChild = assignValueToElement('PricingDate', DateTime.now().format('yyyyMMdd'), null, null, null);
            headerChildElements.add(headerChild);
            //Add Detail values
            Element itemChild;
            Element detailChild;
            for(OrderLineItem__c oli : olisToSendToSAP)
            {
                itemChildElements = new list<Element>();
                //adding children of Item tag
                itemChild = assignValueToElement('ISBN', oli.Ordered_Item__c, null, null, null);
                itemChildElements.add(itemChild);
                //if(oli.ItemQuantity__c == null)
                    //itemChild = assignValueToElement('Quantity', String.valueOf(Integer.valueOf(oli.Free_Item_Quantity__c)), null, null, null);
                //else
                itemChild = assignValueToElement('Quantity', String.valueOf(1), null, null, null);
                itemChildElements.add(itemChild);
                itemChild = assignValueToElement('Price', String.valueOf(oli.Price__c), null, null, null);
                itemChildElements.add(itemChild);
                itemChild = assignValueToElement('System', strG, null, null, null);
                itemChildElements.add(itemChild);
                
                //adding children of Detail tag
                detailChild =assignValueToElement('Item', null, null, null, itemChildElements);
                detailChildElements.add(detailChild);
            }
            Element rootHeader = assignValueToElement('Header', null, null, null, headerChildElements);
            rootChildElements.add(rootHeader);
            Element rootChild1 = assignValueToElement('Detail', null, null, null, detailChildElements);
            rootChildElements.add(rootChild1);
            
            Namespaces ns = assignNamespaces('xsi', xsi, null);
            rootNameSpaces.add(ns);
            ns = assignNamespaces('xsd', xsd, null);
            rootNameSpaces.add(ns);
            
            Element rootElement = assignValueToElement('RequestPricingData', null, rootNameSpaces, null, rootChildElements);
            String strxml = generateXML('RequestPricingData', new Map<String, Object>{'RequestPricingData' => rootElement});
            return strxml;
        }
        catch(Exception e)
        {
            System.debug('The following exception has occurred: ' + e.getMessage() + ' l.no--'+ e.getLineNumber());
            return null;
        }
    }
    
    /*************************************************************************** 
* Description: Creates a each node of XML
***************************************************************************/
    private static Element assignValueToElement(String key, String value, list<Namespaces> nameSpaces, list<Attributes> attributes, list<Object> childElements)
    {
        Element objElem = new Element();
        objElem.key = key;
        objElem.value = value;
        objElem.lstNamespaces = nameSpaces;
        objElem.lstAttributes = attributes;
        objElem.lstChildElements = childElements;
        return objElem;
    }
    
    /****************************************************************************** 
* Description: Assigns namespaces for XML node
***************************************************************************/
    private static Namespaces assignNamespaces(String prefix, String namespace, list<Attributes> lstAttributesNS )
    {
        Namespaces objNS = new Namespaces();
        objNS.prefix = prefix;
        objNS.namespace = namespace;
        objNS.lstAttributesNS = lstAttributesNS;
        return objNS;
    }
    
    /****************************************************************************** 
* Description: Generic method that returns XML
***************************************************************************/
    private static String generateXML(String rootElement, Map<String, Object> xmlElements)
    {
        try{
            // Create the XML document
            DOM.Document doc = new DOM.Document();
            // Create the root element
            DOM.XMLNode rootNode = doc.createRootElement(rootElement, null, null);
            Element rootElem = (Element)xmlElements.get(rootElement);
            if(rootElem.lstNamespaces != null && !rootElem.lstNamespaces.isEmpty())
            {
                rootNode = setNameSpace(rootNode, rootElem.lstNamespaces);                
            }
            if(rootElem.lstAttributes != null && !rootElem.lstAttributes.isEmpty())
            {
                rootNode = setAttributes(rootNode, rootElem.lstAttributes);                
            }
            if(rootElem.lstChildElements!= null && !rootElem.lstChildElements.isEmpty())
            {
                for(Object obj : rootElem.lstChildElements)
                {
                    Element childElem = (Element)obj;
                    createChildElements(rootNode, new map<String, Object>{childElem.key => childElem});
                }
            }
            // Generate the XML string
            String xmlString = doc.toXmlString();
            system.debug('xml string generated---->'+xmlString);
            return xmlString;
        }
        catch(Exception ex)
        {
            System.debug('The following exception has occurred: ' + ex.getMessage() + ' l.no '+ex.getLineNumber());
            return null;
        }
    }
    
    /****************************************************************************** 
* Description: Create child nodes for parent node of XML
***************************************************************************/
    private static void createChildElements(DOM.XMLNode parentNode, Map<String, Object> elements) {
        try{
            for (String elementName : elements.keySet()) {
                Element childElement = (Element)elements.get(elementName);
                DOM.XMLNode childNode = parentNode.addChildElement(elementName, null, null);
                if(String.isNotBlank(childElement.value))
                {
                    childNode.addTextNode(String.valueOf(childElement.value));
                }
                if(childElement.lstNamespaces != null && !childElement.lstNamespaces.isEmpty())
                {
                    childNode = setNameSpace(childNode, childElement.lstNamespaces);                
                }
                if(childElement.lstAttributes != null && !childElement.lstAttributes.isEmpty())
                {
                    childNode = setAttributes(childNode, childElement.lstAttributes);                
                }
                
                if(childElement.lstChildElements != null && !childElement.lstChildElements.isEmpty())
                {
                    for(Object obj : childElement.lstChildElements)
                    {
                        Element nestedElement = (Element)obj;
                        createChildElements(childNode, new map<String, Object>{nestedElement.key => nestedElement});
                    }
                }
            }
        }
        catch(Exception ex)
        {
            System.debug('The following exception has occurred: ' + ex.getMessage());
        }
    }
    
    /****************************************************************************** 
* Description: Parses response from OASIS
***************************************************************************/
    public static String parseXMLResponse(String strXML, map<String, OrderLineItem__c> mapISBNToOLIs)
    {
        try{
            ResponsePricingData objRPD = new ResponsePricingData();
            Header objHeader;
            Detail objDetail;
            list<Item> lstItem = new list<Item>();
            Dom.Document doc = new Dom.Document();  
            doc.load(strXML);  
            Dom.XMLNode rootElement = doc.getRootElement();  
            for ( Dom.XMLNode childElement : rootElement.getChildElements() ) {
                //root elements of each array
                system.debug(childElement.getName() + '-' + childElement.getText());
                if(childElement.getName() == 'Detail'){
                    objDetail = new Detail();
                    for (Dom.XMLNode detailElement : childElement.getChildElements()){
                        //childs elements of each array
                        if(detailElement.getName() == 'Item'){
                            Item objItem = new Item();
                            for (Dom.XMLNode detailElement1 : detailElement.getChildElements()){
                                //childs elements of each childs array
                                if(detailElement1.getName() == 'ISBN')
                                    objItem.ISBN = detailElement1.getText();
                                if(detailElement1.getName() == 'ContractPrice')
                                    objItem.ContractPrice = detailElement1.getText();
                                if(detailElement1.getName() == 'ShippingHandlingAmount')
                                    objItem.ShippingHandlingAmount = detailElement1.getText();
                                if(detailElement1.getName() == 'StatusCode')
                                    objItem.StatusCode = detailElement1.getText();
                                if(detailElement1.getName() == 'StatusDescription')
                                    objItem.StatusDescription = detailElement1.getText();
                            }
                            lstItem.add(objItem);
                        }
                    } 
                    objDetail.items = lstItem;
                }
                else if(childElement.getName() == 'Header'){
                    objHeader = new Header();
                    for (Dom.XMLNode detailElement : childElement.getChildElements()){
                        system.debug(detailElement.getName() + '-' + detailElement.getText());
                        if(detailElement.getName() == 'RequestID')
                            objHeader.RequestID = detailElement.getText();
                        if(detailElement.getName() == 'MessageCode')
                            objHeader.MessageCode = detailElement.getText();
                        if(detailElement.getName() == 'MessageDescription')
                            objHeader.MessageDescription = detailElement.getText();
                    }
                }
            }  
            
            objRPD.hdr = objHeader;
            objRPD.dtl = objDetail;
            
            String statusMessage = updateOLIs(objRPD, mapISBNToOLIs);
            return statusMessage;
        }
        catch(Exception ex)
        {
            System.debug('The following exception has occurred: ' + ex.getMessage() + 'l.no.---'+ex.getLineNumber());
            return ex.getMessage();
        }
    }
    
    /****************************************************************************** 
* Description: Updates SAP Pricing on Order Line Items from the response returned from OASIS
***************************************************************************/
    private static String updateOLIs(ResponsePricingData rpd, map<String, OrderLineItem__c> mapISBNToOLI )
    {
        try {
            system.debug('rpd---->'+rpd);
            String responseMessage = '';
            list<OrderLineItem__c> lstOLIsToUpdate = new list<OrderLineItem__c>();
            map<String, list<String>> mapErrormsgToISBNs = new map<String, list<String>>();
            if(rpd.hdr.MessageCode == '0'){
                if(rpd.dtl.items.isEmpty() || rpd.dtl.items == null){
                    responseMessage = 'No response from OASIS';
                    return responseMessage;
                }
                for(Item itm : rpd.dtl.items){
                    if(itm.StatusCode == '24' || itm.StatusCode == '28'){
                        List<String> lstISBNs = new List<String>();
                        String ISBN1;
                        String ISBN2;
                        if(itm.ISBN!= null)
                        lstISBNs = itm.ISBN.split(':');
                        if(lstISBNs.size() > 1){
                            ISBN1 = lstISBNs[0];
                            ISBN2 = lstISBNs[1];
                        }
                        if(mapISBNToOLI.containsKey(ISBN1)){
                            OrderLineItem__c obj = mapISBNToOLI.get(ISBN1);
                            obj.SAP_Pricing__c = Decimal.valueOf(itm.ContractPrice);
                            lstOLIsToUpdate.add(obj);
                        }
                        else if(mapISBNToOLI.containsKey(ISBN2)){
                            OrderLineItem__c obj = mapISBNToOLI.get(ISBN2);
                            obj.SAP_Pricing__c = Decimal.valueOf(itm.ContractPrice);
                            lstOLIsToUpdate.add(obj);
                        }
                        else {
                            String temp = 'ISBNs does not belong to Order';
                            if(mapErrormsgToISBNs.containsKey(temp))
                                mapErrormsgToISBNs.get(temp).add(itm.ISBN);
                            else
                                mapErrormsgToISBNs.put(temp, new List<String>{itm.ISBN});
                        }
                    }
                    else {
                        if(mapErrormsgToISBNs.containsKey(itm.StatusDescription))
                            mapErrormsgToISBNs.get(itm.StatusDescription).add(itm.ISBN);
                        else
                            mapErrormsgToISBNs.put(itm.StatusDescription, new List<String>{itm.ISBN});
                    }
                }
                
                if(!lstOLIsToUpdate.isEmpty()){
                    Database.update(lstOLIsToUpdate, false);
                    responseMessage = rpd.hdr.MessageDescription;
                }
                
                if(!mapErrormsgToISBNs.isEmpty()){
                    responseMessage = '';
                    for(String msg : mapErrormsgToISBNs.keyset()){
                        responseMessage += msg;
                        responseMessage += ' for - ';
                        for(String isbn : mapErrormsgToISBNs.get(msg)){
                            responseMessage += isbn;
                            responseMessage += ',';
                        }
                        responseMessage += ' ';
                    }
                    responseMessage = responseMessage.trim();
                }
            }
            else{
                for(Item itm : rpd.dtl.items){
                    if(mapErrormsgToISBNs.containsKey(itm.StatusCode))
                        mapErrormsgToISBNs.get(itm.StatusCode).add(itm.StatusDescription);
                    else
                        mapErrormsgToISBNs.put(itm.StatusCode, new List<String>{itm.StatusDescription});
                }
                responseMessage = rpd.hdr.MessageDescription+'.';
                if(!mapErrormsgToISBNs.isEmpty()){
                    for(String code : mapErrormsgToISBNs.keyset()){
                        responseMessage += ' ';
                        for(String msg : mapErrormsgToISBNs.get(code)){
                            responseMessage += msg+'.';
                        }
                    }
                    responseMessage = responseMessage.trim();
                }
            }
            if(String.isNotBlank(responseMessage))
            	return responseMessage.removeEnd(',');
            else
                return responseMessage;
        }
        catch(DmlException e){
            System.debug('The following exception has occurred: ' + e.getMessage());
            return e.getMessage();
        }
    }
    
    /****************************************************************************** 
* Description: Sets attributes for XML node if any
***************************************************************************/
    private static DOM.XMLNode setAttributes(DOM.XMLNode xnode, list<Attributes> attributes)
    {
        for(Attributes atrb : attributes)
        {
            xnode.setAttribute(atrb.key, atrb.value);
        }
        return xnode;
    }
    
    /****************************************************************************** 
* Description: Sets NameSpace for XML node if any
***************************************************************************/
    private static DOM.XMLNode setNameSpace(DOM.XMLNode xnode, list<Namespaces> namespaces)
    {
        for(Namespaces ns : namespaces)
        {
            xnode.setNamespace(ns.prefix, ns.namespace);
            if(ns.lstAttributesNS != null && !ns.lstAttributesNS.isEmpty())
            {
                setAttributesNS(xnode, ns.namespace, ns.lstAttributesNS);
            }
        }
        return xnode;
    }
    
    /****************************************************************************** 
* Description: Sets attributes for NameSpace for XML node if any
***************************************************************************/
    private static DOM.XMLNode setAttributesNS(DOM.XMLNode xnode, String namespace, list<Attributes> attributesNS)
    {
        for(Attributes atrbns : attributesNS)
        {
            xnode.setAttributeNs(atrbns.key, atrbns.value, atrbns.keyNamespace, atrbns.valueNamespace);
        }
        
        return xnode;
    }
    
    /****************************************************************************** 
* Description: method to add precceding zeros to SAP Account numbers to make it a 10 digit number
***************************************************************************/
    private static String getTendigitSAPAccNumber(String sapAccNumber){
        if(sapAccNumber.length() < 10){
            Integer diff = 10 - sapAccNumber.length();
            String zeros = '0';
            for(Integer i = 0; i < diff; i++){
                zeros += '0';
            }
            sapAccNumber = zeros + sapAccNumber;
        }
        return sapAccNumber;
    }
    
    private class Element
    {
        String key;
        String value;
        list<Namespaces> lstNamespaces = new list<Namespaces>();
        list<Attributes> lstAttributes = new list<Attributes>();
        list<Object> lstChildElements = new list<Object>();
    }
    
    private class Namespaces
    {
        String prefix;
        String namespace;
        list<Attributes> lstAttributesNS = new list<Attributes>();
    }
    
    private class Attributes
    {
        String key;
        String value;
        String keyNamespace;
        String valueNamespace;
    }
    
    private class Item 
    {
        String ISBN;
        String ContractPrice;
        String ShippingHandlingAmount;
        String StatusCode;
        String StatusDescription;
    }
    
    private class Detail
    {
        list<Item> items;
    }
    
    private class Header
    {
        String RequestID;
        String MessageCode;
        String MessageDescription;
    }
    
    private class ResponsePricingData
    {
        Header hdr;
        Detail dtl;
    }
}