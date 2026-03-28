public without sharing class CPQQuoteRefresher {

    @future(callout=true)
    public static void refresh(Id id, String releaseNumber, String action) {

       System.debug('--- Action: ' + action + ' ---');

       ApexClass[] apx = [SELECT ApiVersion FROM ApexClass c where c.Name like '%CPQRequestFormatter'];
       final String ApiVersion = (apx.size()>0?apx[0].ApiVersion.format():'39.0');
       final String wsURL = URL.getSalesforceBaseUrl().toExternalForm()+'/services/Soap/c/'+ApiVersion+'/';

       System.debug('WSURL: ' + wsURL);
       final String[] CPQResult = CameleonCPQ.CPQRequestFormatter.executeCPQAction(id, releaseNumber, 'openReleaseStateless', action, wsURL);
       if (!'0'.equals(CPQResult[0])) 
       {
           System.debug(Logginglevel.ERROR,'ERROR OCCURED WHILE CALLING CPQ :'+CPQResult[0]+' - CPQ ERROR ='+CPQResult[1]);
       }

       System.debug('Finishing Future Call to PROS: ' + CPQResult); 

   } 

    //This method exists to enqueue one or more future actions for cases where quotes releases are updated in bulk
    public static void synchronizeQuotes(List<CameleonCPQ__Quote__c> quotes) {

        System.debug('Starting Async Calls');

        for(CameleonCPQ__Quote__c quote: quotes){
            CPQQuoteRefresher.refresh(quote.Id, string.valueof(quote.CameleonCPQ__ActiveRelease__c), 'SynchronizeQuote');
        }

    }

}