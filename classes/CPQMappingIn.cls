global with sharing class CPQMappingIn implements CameleonCPQ.CPQRequestFormatter.IMappingIN {
    global List<CameleonCPQ.CPQRequestFormatter.Tuple> getCPQCustomSettings(Id entityId) {
        System.debug(LoggingLevel.INFO, 'Going into CPQMappingIn');
        List<CameleonCPQ.CPQRequestFormatter.Tuple> sessionXmlElts = new List< CameleonCPQ.CPQRequestFormatter.Tuple>();
        //String billToState = CameleonCPQ__Quote__c.CameleonCPQ__BillingState__c;
        
        
        //Map<Id, CameleonCPQ__Quote__c> billToStateList = new Map<Id, CameleonCPQ__Quote__c>([SELECT Id, CameleonCPQ__BillingState__c FROM CameleonCPQ__Quote__c WHERE Id =: entityId]);
        CameleonCPQ__Quote__c quote = [SELECT Id, CPQ_Billing_State__c,CPQ_Future_Pricing_Date__c FROM CameleonCPQ__Quote__c WHERE Id =: entityId];
        String billToState = quote.CPQ_Billing_State__c;
        
        if(billToState != null){
            System.debug(LoggingLevel.INFO, 'State = ' + billToState);
            /* Getting the Discount Thresholds */
            /*Map<Id, Discount_Thresholds__c> Discount_Thresholds = new Map<Id, Discount_Thresholds__c>([SELECT Id,Adoption_State_Threshold__c,Open_Territory_Threshold__c,PMDB_Master_Program_Name__c FROM Discount_Thresholds__c]);*/
            
            Map<String, Discount_Thresholds__c> Discount_Thresholds = Discount_Thresholds__c.getAll();
            Map<String, CPQ_State_Info__c> CPQ_State_Infos = CPQ_State_Info__c.getAll();
            
            System.debug(LoggingLevel.INFO, 'size Discount_Thresholds = ' + Discount_Thresholds.size());
            System.debug(LoggingLevel.INFO, 'size CPQ_State_Infos  = ' + CPQ_State_Infos.size());
            
            
            CPQ_State_Info__c CPQ_State_Info;
            List<String> CPQ_State_Infos_Rows = new List<String>();
            CPQ_State_Infos_Rows.addAll(CPQ_State_Infos.keySet());
            for (String CPQ_State_Infos_Row : CPQ_State_Infos_Rows) {
                CPQ_State_Info__c CPQ_State_Info_Current = CPQ_State_Infos.get(CPQ_State_Infos_Row);
                if (CPQ_State_Info_Current.State_Code__c.equals(billToState)){
                    CPQ_State_Info = CPQ_State_Info_Current;
                    break;
                }
            }
            
            System.debug(LoggingLevel.INFO, 'CPQ_State_Info = ' + CPQ_State_Info);
            
            if (CPQ_State_Info != null){
                addThresholds(sessionXmlElts, Discount_Thresholds, CPQ_State_Info);
        
                addSHPercentageRate(sessionXmlElts, CPQ_State_Info);
            }

        }
        /* Checking the application date to be passed */
         if(quote.CPQ_Future_Pricing_Date__c != null)
         {
           Date currentDate = Date.today();
           System.debug(LoggingLevel.INFO, 'Pricing Date difference = ' +currentDate.daysBetween(quote.CPQ_Future_Pricing_Date__c) );
           Integer diffDays = currentDate.daysBetween(quote.CPQ_Future_Pricing_Date__c);
           if(diffDays < 1)
           {
              CameleonCPQ.CPQRequestFormatter.Tuple PricingDateElement = new CameleonCPQ.CPQRequestFormatter.Tuple('CPQ_Future_Price_Date', '');
              sessionXmlElts.add(PricingDateElement);
           }
           else
           {
              Datetime priceDateTime = datetime.newInstance(quote.CPQ_Future_Pricing_Date__c.year(),quote.CPQ_Future_Pricing_Date__c.month(),quote.CPQ_Future_Pricing_Date__c.day());
              String PriceDate = priceDateTime.format('yyyyMMdd HHmmss');
              CameleonCPQ.CPQRequestFormatter.Tuple PricingDateElement = new CameleonCPQ.CPQRequestFormatter.Tuple('CPQ_Future_Price_Date',PriceDate );
              sessionXmlElts.add(PricingDateElement);              
           }         
         }
        return sessionXmlElts;
    }
    
    /* Loop through all the Discount Thresholds and adds them to the sessionXml */
    private void addThresholds(List<CameleonCPQ.CPQRequestFormatter.Tuple> sessionXmlElts, Map<String, Discount_Thresholds__c> Discount_Thresholds, CPQ_State_Info__c CPQ_State_Info){
        System.debug(LoggingLevel.INFO, 'Adding Discount Thresholds');
        List<String> Discount_Thresholds_Rows = new List<String>();
        Discount_Thresholds_Rows.addAll(Discount_Thresholds.keySet());
        
        String tupleNamePrefix = 'CustomSettings.Discount_Thresholds';
        String tupleNamePrefixExpansion = 'CustomSettings.Expansion_Thresholds';
        
        Boolean isAdoptionState = CPQ_State_Info.Adoption_State__c;
        
        String thresholdStringResult = '';
        String thresholdExpansionStringResult = '';
        
        for (String Discount_Thresholds_Row : Discount_Thresholds_Rows) {
            Discount_Thresholds__c Discount_Threshold = Discount_Thresholds.get(Discount_Thresholds_Row);
            if (!thresholdStringResult.equals('')){
                thresholdStringResult += '*|';
            }
            if (!thresholdExpansionStringResult .equals('')){
                thresholdExpansionStringResult += '*|';
            }
            if (isAdoptionState){
                //ThresholdElement = new CameleonCPQ.CPQRequestFormatter.Tuple(tupleNamePrefix + 'ThresholdFor' + Discount_Threshold.PMDB_Master_Program_Name__c, Discount_Threshold.Adoption_State_Threshold__c.format());
                thresholdStringResult += Discount_Threshold.PMDB_Master_Program_Name__c + '~' + Discount_Threshold.Adoption_State_Threshold__c.format();
                thresholdExpansionStringResult += Discount_Threshold.PMDB_Master_Program_Name__c + '~' + Discount_Threshold.Expansion_Threshold__c.format();
            }
            else{
                //ThresholdElement = new CameleonCPQ.CPQRequestFormatter.Tuple(tupleNamePrefix + 'ThresholdFor' + Discount_Threshold.PMDB_Master_Program_Name__c, Discount_Threshold.Open_Territory_Threshold__c.format());
                thresholdStringResult += Discount_Threshold.PMDB_Master_Program_Name__c + '~' + Discount_Threshold.Open_Territory_Threshold__c.format();
                thresholdExpansionStringResult += Discount_Threshold.PMDB_Master_Program_Name__c + '~' + Discount_Threshold.Expansion_Threshold__c.format();
            }
        }
        CameleonCPQ.CPQRequestFormatter.Tuple ThresholdElement = new CameleonCPQ.CPQRequestFormatter.Tuple(tupleNamePrefix, thresholdStringResult);
        CameleonCPQ.CPQRequestFormatter.Tuple ThresholdElementExpansion = new CameleonCPQ.CPQRequestFormatter.Tuple(tupleNamePrefixExpansion, thresholdExpansionStringResult);

        sessionXmlElts.add(ThresholdElement);
        sessionXmlElts.add(ThresholdElementExpansion);
    }
    
    private void addSHPercentageRate(List<CameleonCPQ.CPQRequestFormatter.Tuple> sessionXmlElts, CPQ_State_Info__c CPQ_State_Info){
        System.debug(LoggingLevel.INFO, 'Adding Percentage Rate');
        String tupleNamePrefix = 'CustomSettings.';
        System.debug(LoggingLevel.INFO, 'CPQ_State_Info = ' + CPQ_State_Info);
        System.debug(LoggingLevel.INFO, 'CPQ_State_Info.S_H_Percentage_Rate__c.format() = ' + CPQ_State_Info.S_H_Percentage_Rate__c.format());
        
            CameleonCPQ.CPQRequestFormatter.Tuple PercentageRateElement = new CameleonCPQ.CPQRequestFormatter.Tuple(tupleNamePrefix + 'SHPercentageRate', CPQ_State_Info.S_H_Percentage_Rate__c.format());
            sessionXmlElts.add(PercentageRateElement);
    }
}