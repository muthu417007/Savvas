/* 
*****Class: ExcelSubsExtension1*****
Version: 2
Description: 
 1. It queries for records with Predicate as Quota, Forecast and UBE.
 2. It finds total value of records with each Quota, forecast, UBE as Predicate value.
 3. It also updates the data updated on Excel Substitue records on the Excel Substitue Form.
*****Add further changes to this class below as and when needed*****
Date||  Line No. ||  Changed By  ||   Change     

     

*/



public  with sharing class ExcelSubsExtension1
{
    public ExcelSubstitute__c Exsub;
    public List<ExcelSubstitute__c> Excelsub{get;set;}
    public List<ExcelSubstitute__c> Excelsub1{get;set;}
    public List<ExcelSubstitute__c> Excelsub2{get;set;}
    public Integer I{get;set;}
    public Integer J{get;set;}
    public Integer K {get;set;}
    
    
    //Constructor class
    public ExcelSubsExtension1(ApexPages.StandardController stdcontroller) 
    {
      ExcelSubstitute__c Exsub = new ExcelSubstitute__c();
      this.Exsub= (ExcelSubstitute__c)stdController.getRecord();
     }
    
    //Quering the Excel substitute records with predicate value as Quota
    public List<ExcelSubstitute__c> getQuoterecords()
    {      
         Excelsub = new List<ExcelSubstitute__c>();
         Excelsub = [Select Node1__c, Node2__c, Predicate__c,Id FROM ExcelSubstitute__c Where Predicate__c = 'Quota' ORDER BY
                        Node1__c ASC];
                        system.debug(Excelsub);
         
        return Excelsub;         
    }
  

    //Quering the Excel substitute records with predicate value as Forecast
        public List<ExcelSubstitute__c> getForecastrecords()
    {
       Excelsub1 = new List<ExcelSubstitute__c> ();
        Excelsub1 = [Select Node1__c, Node2__c, Predicate__c, Id FROM ExcelSubstitute__c Where Predicate__c = 'Forecast' ORDER BY
Node1__c ASC];
        return Excelsub1;
        
    }
       
     //Quering the Excel substitute records with predicate value as Untracked Business Expected
        public List<ExcelSubstitute__c> getUBErecords()
    {
        Excelsub2 = new List<ExcelSubstitute__c>();
        Excelsub2 = [Select Node1__c, Node2__c, Predicate__c, Id FROM ExcelSubstitute__c Where Predicate__c = 'Untracked Business Expected' ORDER BY
Node1__c ASC];
        return Excelsub2;
        
    }
    
    //Calculating Total Value of records with Predicate as Quota using Aggregate Results and converting the results to integer
    
    public Integer getTotalQuoteValue(){
    
     list<AggregateResult> TotalQuotaAmt = new list<AggregateResult>();
     TotalQuotaAmt =  [SELECT SUM(Node2__c) totalquota FROM ExcelSubstitute__c Where Predicate__c = 'Quota'];
     
     if(TotalQuotaAmt != null)
     {
       I = 0;
       //converting aggregate results to Integer
       I = Integer.valueOf(TotalQuotaAmt[0].get('totalquota'));
       
      }
     return I;
    }
    
    //Calculating Total Value of records with Predicate as Forecast using Aggregate Results and converting the results to integer
    
    public Integer getTotalforecastValue()
    {
        list<AggregateResult> TotalForecastAmt = new list<AggregateResult>();
        TotalForecastAmt =  [SELECT SUM(Node2__c) totalforecast FROM ExcelSubstitute__c Where Predicate__c = 'Forecast'];
        
        if(TotalForecastAmt != null)
         {  
           J = 0;
           //converting aggregate results to Integer
           J = Integer.valueOf(TotalForecastAmt[0].get('totalforecast'));
          }
           
        return J;
        
    }
    
    //Calculating Total Value of records with Predicate as UBE using Aggregate Results and converting the results to integer
    
    public Integer getTotalubeValue()
    {
        list<AggregateResult> TotalUBEAmt = new list<AggregateResult>();
        TotalUBEAmt =  [SELECT SUM(Node2__c) totalube FROM ExcelSubstitute__c Where Predicate__c = 'Untracked Business Expected'];
       
       If(TotalUBEAmt != null)
       {
        //converting aggregate results to Integer
        K = 0;
        K = Integer.valueOf(TotalUBEAmt[0].get('totalube'));
        
        }
        return K;
        
    }
   
                                           
    //Code to save the updated records on VF page
   public PageReference save(){
    
         update Excelsub;
         update Excelsub1;
         update Excelsub2;
         return null;
        }
 
}