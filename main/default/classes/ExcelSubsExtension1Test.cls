@isTest

public class ExcelSubsExtension1Test
{
    @isTest 
    static void ExcelSubsExtension1Test()
    
    {   
        List<ExcelSubstitute__c> Exsublist = new List<ExcelSubstitute__c>();
        ExcelSubstitute__c ExSub = new ExcelSubstitute__c();
        ExSub.Node1__c = 'Liberty';
        ExSub.Node2__c = 100;
        ExSub.Predicate__c = 'Quota';
        Exsublist.add(ExSub);
                
        ExcelSubstitute__c ExSub1 = new ExcelSubstitute__c();
        ExSub1.Node1__c = 'Liberty';
        ExSub1.Node2__c = 200;
        ExSub1.Predicate__c = 'Forecast';
        Exsublist.add(ExSub1);
        
        ExcelSubstitute__c ExSub2 = new ExcelSubstitute__c();
        ExSub2.Node1__c = 'Liberty';
        ExSub2.Node2__c = 300;
        ExSub2.Predicate__c = 'Untracked Business Expected';
        Exsublist.add(ExSub2);
        
        insert Exsublist;
        
        List<ExcelSubstitute__c> Quota = [Select Node1__c, Node2__c, Predicate__c FROM ExcelSubstitute__c Where Predicate__c = 'Quota'];
        List<ExcelSubstitute__c> Forecast = [Select Node1__c, Node2__c, Predicate__c FROM ExcelSubstitute__c Where Predicate__c = 'Forecast'];
        List<ExcelSubstitute__c> UBE = [Select Node1__c, Node2__c, Predicate__c FROM ExcelSubstitute__c Where Predicate__c = 'Untracked Business Expected'];
                        

        PageReference pageRef = new pagereference('/apex/ExcelSubstituteForm');
        Test.setCurrentPageReference(pageRef);
        //ExcelSubstitute__c ExSu = new ExcelSubstitute__c();
        Test.startTest();      
        ApexPages.StandardController sc = new  ApexPages.StandardController(ExSub);   
        ExcelSubsExtension1 a = new ExcelSubsExtension1(sc);
        a.getQuoterecords();
        a.getForecastrecords();
        a.getUBErecords();
        System.assertEquals(1, Quota.size(), 'Matching');
        System.assertEquals(1, Forecast.size(), 'Matching');
        System.assertEquals(1, UBE.size(), 'Matching');
        a.save();
        a.getTotalQuoteValue();
        a.getTotalforecastValue();
        a.getTotalubeValue();
        /*List<ExcelSubstitute__c> ExSutest = ExcelSubstitute__c.getQuoterecords();
        ExSutest.getQuoterecords();
        System.assertEquals(ExSutest, ExSub, 'Matching');
        List<ExcelSubstitute__c> ExSutest1 = ExcelSubstitute__c.getForecastrecords();
        System.assertEquals(ExSutest1, ExSub1, 'Matching');     
        List<ExcelSubstitute__c> ExSutest2 = ExcelSubstitute__c.getUBErecords();           
        System.assertEquals(ExSutest2, ExSub2, 'Matching');*/
        
        //PageReference Quota = new PageReference(a.getQuoterecords());
        Test.stopTest();
        
    }
}