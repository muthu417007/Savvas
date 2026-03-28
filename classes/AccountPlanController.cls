/**
* ─────────────────────────────────────────────────────────────────────────────────────────────────┐
* Apex Class that queries and saves account plan.
* Roll-over for new year: Approx: line 71, line 195 change month number in if(System.Today().month()<=4
* Apex Class that queries and saves account plan.
* Account plan outputs each discipline and N number of years record so using a wrapper class
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @author         Romer Pasag     <Romer.Pasag@pearson.com>
* @modifiedBy     Romer Pasag     <Romer.Pasag@pearson.com>
* @maintainedBy   Romer Pasag     <Romer.Pasag@pearson.com>
* @version        1.4
* @created        2018-05-01
* @modified       2018-08-17
* @modified       2018-09-11
* @modified       2019-05-24      charles.teague@pearson.com
* ──────────────────────────────────────────────────────────────────────────────────────────────────
* @changes
* v1.0            Romer.Pasag@pearson.com
* v1.1            Romer.Pasag@pearson.com
*                 Added user manager to list of user's with Edit Permission
* v1.2            Romer.Pasag@pearson.com
*                 Added the create opportunity redirect passing the account Id
* v1.3            Romer.Pasag@pearson.com
*                 added year 3 purchase potential rating
* v1.4            Romer.Pasag@pearson.com
*                 Create new permission set to give user access to edit all account plan
* v1.54           charles.teague@pearson.com
*                 line 59 and 178, changed if(System.Today().month()<5) to if(System.Today().month()<=5)  
*                 added accPlanStatusAndNotes to get and set fields on Account object; 
*                 added currentYearPlanComplete boolean for checkbox field output
*                 added Math Intervention and Literacy Intervention;
*                 edited VF page to display new fields
* ─────────────────────────────────────────────────────────────────────────────────────────────────┘
*/

public class AccountPlanController {
    // List of wrapper account plans
    public list<apWrapper> AccountPlans;
    // list of Account Plans
    public list<Account_Planning__c> accPlanList;
    // Map of the discipline/Grade Band with each wrapper account plans
    public map<String,apWrapper> apWrapMap;
    // ID of the account
    public ID accId;
    // Account Record - original, used for field set
    public Account accRecord{get;set;}
    
    // Account record used to hold editable fields on the Account that relate to the Account Plan.
    public Account accPlanStatusAndNotes{get;set;}
    
    // List of strings used to store the most recent purchase Year
    public List<string> yearPickList;
    // Boolean that identifies if the current user is account owner or part of account team
    public boolean canEdit{get;set;}
    // Integer that identifies what current school year the account plan is for
    public Integer schoolYear{get;set;}
    // Boolean to hold status of the Account object flag field
    public boolean currentYearPlanComplete{get;set;}
    
    //Constructor
    public AccountPlanController(){
        // Initialize lists and maps        
        apWrapMap=new map<String,apWrapper>();
        AccountPlans=new list<apWrapper>();
        accPlanList=new list<Account_Planning__c>();
        yearPickList=new list<String>();
        canEdit=false;
        
        // If the current month is less than May, the starting year is from previous year
        // If the current month is greater than May, the starting year is for next year
        if(System.Today().month()<=3){
            schoolYear=System.Today().year()-1;
        }else{
            schoolYear=System.Today().year();
        }
        // Get's the account ID which is passed to the page
        accId=ApexPages.currentPage().getParameters().get('id');
        list<Id> userIdList=new list<Id>();
        // If Account ID is null, system gives an error.
        // If account id is present, it queries the account fields identified on the field set
        if(accId==null){
            ApexPages.addMessage(new Apexpages.Message(ApexPages.Severity.ERROR,'Missing Account ID.  Wont be able to Save changes'));
        }else{
            String query='SELECT ';
            for(Schema.FieldSetMember f : this.getFields()) {
                query += f.getFieldPath() + ', ';
            }
            query += 'Id,ownerId FROM Account where Id=: accId';
            accRecord = (Account)Database.query(query);
            
            // get the status and notes fields from the Account:
            query = 'select Id, Current_Year_Account_Plan_Complete__c, Account_Plan_Notes__c from Account where Id = :accId';
            accPlanStatusAndNotes = (Account)Database.query(query);
            currentYearPlanComplete = accPlanStatusAndNotes.Current_Year_Account_Plan_Complete__c;
            
            // Add the account owner,owner Manager and account team on list that has edit permission on
            userIdList.add(accRecord.OwnerId);
            
            // Query and Add the account owner's manager to list of user's that can edit account plan
            ID mgrId=[Select managerId from user where Id=:accRecord.OwnerId].managerId;
            
            if(mgrId!=null){
                userIdList.add(mgrId);
            }
            
            For(accountteammember u:[Select UserId from accountteammember where accountId=:accId]){
                userIdList.add(u.UserId);
            }
            
            //Give all user's with the manage all account plan permission set access to all account plans
            For(permissionsetassignment ps:[select permissionset.Name, permissionset.label, assigneeId from permissionsetassignment where permissionset.label = 'Manage all Account Plans']){
                userIdList.add(ps.assigneeId);
            }
            
            For(ID uId:userIdList){
                if(uId==UserInfo.getUserId()){
                    canEdit=True;
                }
            }
            
        }
        //Calls method that gets the picklist values for the Line Of Business/Grade band field
        lobValues();      
    }   
    
    // Return's the account fields
    public List<Schema.FieldSetMember> getFields() {
        return SObjectType.Account.FieldSets.AccountPlanDetail.getFields();
    }
    
    // Class that populate the apWrapMap map with account plan wrapper records based on discipline/grade level
    public void lobValues(){
        
        // Queries the line of business picklist field with possible values
        Schema.DescribeFieldResult fieldResult = Account_Planning__c.Discipline_and_Grade_Band__c.getDescribe();
        List<Schema.PicklistEntry> ple=fieldResult.getPicklistValues();
        
        List<String> gradeLevel=new List<String>();
        for( Schema.PicklistEntry pickListVal : ple){
            gradeLevel.add(pickListVal.getLabel());
        }            
        for(String gl:gradeLevel){
            apWrapper apWrap=new apWrapper(gl);
            apWrapMap.put(gl,apWrap);         
        }
    }
    
    // Queries the Rating picklist field for possible values and returns those as picklist values to the page
    public List<SelectOption> getStatus(){
        List<SelectOption> statusOptions = new List<SelectOption>();
        
        Schema.DescribeFieldResult fieldResult =Account_Planning__c.Rating__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        
        for( Schema.PicklistEntry f : ple){
            statusOptions.add(new SelectOption(f.getLabel(), f.getValue()));
        }       
        return statusOptions;
    }
    
    // Create picklist values for the most Recent purchase Year
    public List<SelectOption> getMostRecentPurchaseYear(){
        List<SelectOption> yearOptions = new List<SelectOption>();
        Set<String> yearPickListSet=new Set<String>();
        Integer cy=schoolYear;
        String yearString;
        
        // Populate the year with the previous 15 years
        cy=schoolYear;
        yearString=string.valueOf(cy);
        YearPickList.add(yearString);
        For(Integer i=14;i>0;i--){
            cy=schoolYear-i;
            yearString=string.valueOf(cy);
            YearPickList.add(yearString);
        }
        YearPicklist.sort();
        
        for(Integer n=YearPickList.size()-1;n>=0;n--){
            yearPickListSet.add(YearPickList.get(n));
        }
        yearOptions.add(new SelectOption('',''));
        for(String y:YearPickListSet){
            yearOptions.add(new SelectOption(y,y));           
        }
        
        return yearOptions;
    }
    
    // Return's the wrapper account plan records
    public List<apWrapper> getAccPlans(){
        
        if(AccountPlans.size()==0){
            Date currentYear;
            if(System.Today().month()<=3){
                currentYear=Date.newInstance(System.Today().year(),1,1);
            }else{
                currentYear=Date.newInstance(System.Today().year()+1,1,1);
            }
            
            accPlanList=new list<Account_Planning__c>([Select ID, Name,Year__c,Discipline_and_Grade_Band__c,Company_Account__c,Rating__c,LobAndYear__c,Most_Recent_Purchase__c,Revenue_Potential__c,Product_Name__c from Account_Planning__c where Account__c=:accId and Account_Plan_Date__c>=:currentYear and Account_Plan_Date__c<=:currentYear.addYears(2)]);
            Integer year;
            
            // If there are existing account plan records
            if(accPlanList.size()>0){
                //Populate grid if there line of business for the year has the rating field populated
                for(Account_Planning__c ap:accPlanList){
                    apWrapper ApWrapAcc=apWrapMap.get(ap.Discipline_and_Grade_Band__c);
                    year=integer.valueOf(ap.Year__c);
                    if(apWrapAcc!=null){
                        apWrapMap.remove(ap.Discipline_and_Grade_Band__c);
                        if(year==schoolYear+1){
                            apWrapAcc.year1Rating=ap.Rating__c;
                            apWrapAcc.accPurchasingPattern.Most_Recent_Purchase__c=ap.Most_Recent_Purchase__c;
                            apWrapAcc.accPurchasingPattern.Revenue_Potential__c=ap.Revenue_Potential__c;
                            apWrapAcc.accPurchasingPattern.Company_Account__c=ap.Company_Account__c;
                            apWrapAcc.accPurchasingPattern.Product_Name__c=ap.Product_Name__c;
                            if(ap.Most_Recent_Purchase__c!=null){
                                yearPickList.add(ap.Most_Recent_Purchase__c);
                            }
                        }
                        if(year==schoolYear+2){
                            apWrapAcc.year2Rating=ap.Rating__c;
                        }
                        if(year==schoolYear+3){
                            apWrapAcc.year3Rating=ap.Rating__c;
                        }
                        apWrapMap.put(ap.Discipline_and_Grade_Band__c,apWrapAcc);
                    }
                }   
            }
            
            //Sort the list based on the discipline/grade band
            List<String> orderingList=new List<String>();
            orderingList.addAll(apWrapMap.keyset());
            orderingList.sort();
            
            for(integer i=0;i<orderingList.size();i++){
                AccountPlans.add(apWrapMap.get(orderingList[i]));         
            }          
        }
        return AccountPlans;
    }
    
    // Saves the changes on the account plans
    public Pagereference save(){
        Map<String,Account_Planning__c> accPlanMap= new map<string,Account_Planning__c>();
        list<Account_Planning__c> accPlanToInsert=new list<Account_Planning__c>();
        list<Account_Planning__c> accPlanToUpdate=new list<Account_Planning__c>();
        for(Account_Planning__c ap:accPlanList){
            String lobYear=ap.Discipline_and_Grade_Band__c+ap.Year__c;
            accPlanMap.put(lobYear,ap);
        }
        list<Discipline_and_Grade_Band__mdt> dgbList=[Select ID,DeveloperName,MasterLabel,Price__c,grade_level__c from Discipline_and_Grade_Band__mdt];
        Map<String, Discipline_and_Grade_Band__mdt> cmdMap = new map<String,Discipline_and_Grade_Band__mdt>();
        for(Discipline_and_Grade_Band__mdt d:dgbList){
            cmdMap.put(d.MasterLabel,d);
        }
        if(accId!=null){
            
            for(apWrapper ap:AccountPlans){
                Account_Planning__c newAccPlan = new Account_Planning__c();
                
                //Next Year Plan
                boolean year1RecUpdated=false;
                String nextYear=string.valueof(schoolYear+1);
                newAccPlan=accPlanMap.get(ap.discipline+nextYear);
                if(newAccPlan==null){
                    newAccPlan=new Account_Planning__c(Account__c=accId,Discipline_and_Grade_Band__c=ap.discipline,
                                                       Year__c=nextYear,Rating__c=ap.year1Rating,Product_Name__c=ap.accPurchasingPattern.Product_Name__c,
                                                       Most_Recent_Purchase__c=ap.accPurchasingPattern.Most_Recent_Purchase__c,
                                                       Company_Account__c=ap.accPurchasingPattern.Company_Account__c);
                    if(accRecord.Top_Level_Enrollment__c>0 && newAccPlan.Rating__c!='Unknown' && newAccPlan.Rating__c!='No Adoption'){
                        Discipline_and_Grade_Band__mdt mdtRecord=cmdMap.get(ap.discipline);
                        if(mdtRecord!=null){
                            newAccPlan.Revenue_Potential__c=((accRecord.Top_Level_Enrollment__c/13)*mdtRecord.Grade_Level__c)*mdtRecord.Price__c;
                        }
                    }else{
                        newAccPlan.Revenue_Potential__c=null;
                    }
                    accPlanToInsert.add(newAccPlan);
                }else if(newAccPlan!=null && (newAccPlan.Rating__c!=ap.year1Rating ||newAccPlan.Most_Recent_Purchase__c!=ap.accPurchasingPattern.Most_Recent_Purchase__c||newAccPlan.Revenue_Potential__c!=ap.accPurchasingPattern.Revenue_Potential__c||newAccPlan.Product_Name__c!=ap.accPurchasingPattern.Product_Name__c||newAccPlan.Company_Account__c!=ap.accPurchasingPattern.Company_Account__c)){
                    if(newAccPlan.Rating__c!=ap.year1Rating){
                        newAccPlan.Rating__c=ap.year1Rating;
                        if(accRecord.Top_Level_Enrollment__c>0 && newAccPlan.Rating__c!='Unknown' && newAccPlan.Rating__c!='No Adoption'){
                            Discipline_and_Grade_Band__mdt mdtRecord=cmdMap.get(ap.discipline);
                            if(mdtRecord!=null){
                                newAccPlan.Revenue_Potential__c=((accRecord.Top_Level_Enrollment__c/13)*mdtRecord.Grade_Level__c)*mdtRecord.Price__c;
                            }
                        }else{
                            newAccPlan.Revenue_Potential__c=null;
                        }
                        year1RecUpdated=true;
                    }
                    if(newAccPlan.Most_Recent_Purchase__c!=ap.accPurchasingPattern.Most_Recent_Purchase__c){
                        newAccPlan.Most_Recent_Purchase__c=ap.accPurchasingPattern.Most_Recent_Purchase__c;
                        year1RecUpdated=true;
                    }
                    if(newAccPlan.Product_Name__c!=ap.accPurchasingPattern.Product_Name__c){
                        newAccPlan.Product_Name__c=ap.accPurchasingPattern.Product_Name__c;
                        year1RecUpdated=true;
                    }
                    if(newAccPlan.Company_Account__c!=ap.accPurchasingPattern.Company_Account__c){
                        newAccPlan.Company_Account__c=ap.accPurchasingPattern.Company_Account__c;
                        year1RecUpdated=true;
                    }
                    if(year1RecUpdated==true){
                        accPlanToUpdate.add(newAccPlan);
                    }
                }
                
                //2 Year Plan
                boolean year2RecUpdated=false;
                String secondYear=string.valueof(schoolYear+2);
                newAccPlan=accPlanMap.get(ap.discipline+secondYear);
                if(newAccPlan==null){
                    newAccPlan=new Account_Planning__c(Account__c=accId,Discipline_and_Grade_Band__c=ap.discipline,
                                                       Year__c=secondYear,Rating__c=ap.year2Rating,Product_Name__c=ap.accPurchasingPattern.Product_Name__c,
                                                       Most_Recent_Purchase__c=ap.accPurchasingPattern.Most_Recent_Purchase__c,
                                                       Company_Account__c=ap.accPurchasingPattern.Company_Account__c);
                    if(accRecord.Top_Level_Enrollment__c>0 && newAccPlan.Rating__c!='Unknown' && newAccPlan.Rating__c!='No Adoption'){
                        Discipline_and_Grade_Band__mdt mdtRecord=cmdMap.get(ap.discipline);
                        if(mdtRecord!=null){
                            newAccPlan.Revenue_Potential__c=((accRecord.Top_Level_Enrollment__c/13)*mdtRecord.Grade_Level__c)*mdtRecord.Price__c;
                        }
                    }else{
                        newAccPlan.Revenue_Potential__c=null;
                    }
                    accPlanToInsert.add(newAccPlan);
                }else if(newAccPlan!=null && (newAccPlan.Rating__c!=ap.year2Rating||newAccPlan.Most_Recent_Purchase__c!=ap.accPurchasingPattern.Most_Recent_Purchase__c||newAccPlan.Revenue_Potential__c!=ap.accPurchasingPattern.Revenue_Potential__c||newAccPlan.Product_Name__c!=ap.accPurchasingPattern.Product_Name__c||newAccPlan.Company_Account__c!=ap.accPurchasingPattern.Company_Account__c)){
                    if(newAccPlan.Rating__c!=ap.year2Rating){
                        newAccPlan.Rating__c=ap.year2Rating;
                        if(accRecord.Top_Level_Enrollment__c>0 && newAccPlan.Rating__c!='Unknown' && newAccPlan.Rating__c!='No Adoption'){
                            Discipline_and_Grade_Band__mdt mdtRecord=cmdMap.get(ap.discipline);
                            if(mdtRecord!=null){
                                newAccPlan.Revenue_Potential__c=((accRecord.Top_Level_Enrollment__c/13)*mdtRecord.Grade_Level__c)*mdtRecord.Price__c;
                            }
                        }else{
                            newAccPlan.Revenue_Potential__c=null;
                        }
                        year2RecUpdated=true;
                    }
                    if(newAccPlan.Most_Recent_Purchase__c!=ap.accPurchasingPattern.Most_Recent_Purchase__c){
                        newAccPlan.Most_Recent_Purchase__c=ap.accPurchasingPattern.Most_Recent_Purchase__c;
                        year2RecUpdated=true;
                    }
                    if(newAccPlan.Product_Name__c!=ap.accPurchasingPattern.Product_Name__c){
                        newAccPlan.Product_Name__c=ap.accPurchasingPattern.Product_Name__c;
                        year2RecUpdated=true;
                    }
                    if(newAccPlan.Company_Account__c!=ap.accPurchasingPattern.Company_Account__c){
                        newAccPlan.Company_Account__c=ap.accPurchasingPattern.Company_Account__c;
                        year2RecUpdated=true;
                    }
                    if(year2RecUpdated==true){
                        accPlanToUpdate.add(newAccPlan);
                    }
                }
                //3 Year Plan
                //Added 08/17/2018
                boolean year3RecUpdated=false;
                String thirdYear=string.valueof(schoolYear+3);
                newAccPlan=accPlanMap.get(ap.discipline+thirdYear);
                if(newAccPlan==null){
                    newAccPlan=new Account_Planning__c(Account__c=accId,Discipline_and_Grade_Band__c=ap.discipline,
                                                       Year__c=thirdYear,Rating__c=ap.year3Rating,Product_Name__c=ap.accPurchasingPattern.Product_Name__c,
                                                       Most_Recent_Purchase__c=ap.accPurchasingPattern.Most_Recent_Purchase__c,
                                                       Company_Account__c=ap.accPurchasingPattern.Company_Account__c);
                    if(accRecord.Top_Level_Enrollment__c>0 && newAccPlan.Rating__c!='Unknown' && newAccPlan.Rating__c!='No Adoption'){
                        Discipline_and_Grade_Band__mdt mdtRecord=cmdMap.get(ap.discipline);
                        if(mdtRecord!=null){
                            newAccPlan.Revenue_Potential__c=((accRecord.Top_Level_Enrollment__c/13)*mdtRecord.Grade_Level__c)*mdtRecord.Price__c;
                        }
                    }else{
                        newAccPlan.Revenue_Potential__c=null;
                    }
                    accPlanToInsert.add(newAccPlan);
                }else if(newAccPlan!=null && (newAccPlan.Rating__c!=ap.year3Rating||newAccPlan.Most_Recent_Purchase__c!=ap.accPurchasingPattern.Most_Recent_Purchase__c||newAccPlan.Revenue_Potential__c!=ap.accPurchasingPattern.Revenue_Potential__c||newAccPlan.Product_Name__c!=ap.accPurchasingPattern.Product_Name__c||newAccPlan.Company_Account__c!=ap.accPurchasingPattern.Company_Account__c)){
                    if(newAccPlan.Rating__c!=ap.year3Rating){
                        newAccPlan.Rating__c=ap.year3Rating;
                        if(accRecord.Top_Level_Enrollment__c>0 && newAccPlan.Rating__c!='Unknown' && newAccPlan.Rating__c!='No Adoption'){
                            Discipline_and_Grade_Band__mdt mdtRecord=cmdMap.get(ap.discipline);
                            if(mdtRecord!=null){
                                newAccPlan.Revenue_Potential__c=((accRecord.Top_Level_Enrollment__c/13)*mdtRecord.Grade_Level__c)*mdtRecord.Price__c;
                            }
                        }else{
                            newAccPlan.Revenue_Potential__c=null;
                        }
                        year3RecUpdated=true;
                    }
                    if(newAccPlan.Most_Recent_Purchase__c!=ap.accPurchasingPattern.Most_Recent_Purchase__c){
                        newAccPlan.Most_Recent_Purchase__c=ap.accPurchasingPattern.Most_Recent_Purchase__c;
                        year3RecUpdated=true;
                    }
                    if(newAccPlan.Product_Name__c!=ap.accPurchasingPattern.Product_Name__c){
                        newAccPlan.Product_Name__c=ap.accPurchasingPattern.Product_Name__c;
                        year3RecUpdated=true;
                    }
                    if(newAccPlan.Company_Account__c!=ap.accPurchasingPattern.Company_Account__c){
                        newAccPlan.Company_Account__c=ap.accPurchasingPattern.Company_Account__c;
                        year3RecUpdated=true;
                    }
                    if(year3RecUpdated==true){
                        accPlanToUpdate.add(newAccPlan);
                    }
                } 
            }       
        }
        
        // dumb-update Account Plan Status and Notes on the Account object; fix this to compare values later if it works:
        update accPlanStatusAndNotes;
        
        if(accPlanToInsert.size()>0)
            insert accPlanToInsert;
        if(accPlanToUpdate.size()>0)
            update accPlanToUpdate;
        AccountPlans.clear();
        getAccPlans();
        return null;
        
    }
    
    // Redirect's user to create opportunity
    // Added 06/17/2018
    public PageReference createOpp(){
        PageReference assignPage = new PageReference('/006/e?');
        assignPage.getParameters().put('opp4_lkid',accId);
        assignPage.setRedirect(true);
        return assignPage;
        
    }
    
    public class apWrapper {
        
        public String discipline{get;set;}
        public String year1Rating {get;set;}
        public String year2Rating{get;set;}
        public String year3Rating{get;set;}
        public Account_planning__c accPurchasingPattern{get;set;}
        
        public apWrapper(String disciplineGradeBand){
            discipline=disciplineGradeBand;
            year1Rating='Unknown';
            year2Rating='Unknown';
            year3Rating='Unknown';
            accPurchasingPattern=new Account_Planning__c();
            
        }
    }
    
}