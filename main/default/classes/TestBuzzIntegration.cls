@isTest
public class TestBuzzIntegration {
      
    // Positive test method for the schuled job which queries Buzz for enrollment data
    static testMethod void executeScheduledJob(){
        String sch = '0 0 23 * * ?';
        Group integrationGroup = new Group();
        integrationGroup.Name = 'Integration Test';
        insert integrationGroup;
        GroupMember gm=new GroupMember(groupId=integrationGroup.Id,UserOrGroupId=UserInfo.getUserId());
        insert gm;
        Test.StartTest();
        BuzzGetEnrollmentSchedule buzzGetEnrollment=new BuzzGetEnrollmentSchedule();
        system.schedule('Test Buzz Get Enrollment Job',sch,buzzGetEnrollment);
        Test.stopTest();
    }
    
    // Negative test case for when the login URL is bad
    static testMethod void urlNotFound(){
        Group integrationGroup = new Group();
        integrationGroup.Name = 'Integration Test';
        insert integrationGroup;
 
        GroupMember gm=new GroupMember(groupId=integrationGroup.Id,UserOrGroupId=UserInfo.getUserId());
		//Prevent Mixed DML Operations
        System.runAs(new User(Id = Userinfo.getUserId())) {
       		insert gm;
      	}
        test.StartTest();
        BuzzLoginCallout callout=new BuzzLoginCallout();
        callout.testVariable='404';
        callout.basicAuthCallout();
        test.StopTest();
    }
    
    // Negative test case for invalid credential during login
    static testMethod void invalidCredential(){
        Group integrationGroup = new Group();
        integrationGroup.Name = 'ICOM Admin Test Group';
        insert integrationGroup;
 
        GroupMember gm=new GroupMember(groupId=integrationGroup.Id,UserOrGroupId=UserInfo.getUserId());
		//Prevent Mixed DML Operations
        System.runAs(new User(Id = Userinfo.getUserId())) {
       		insert gm;
      	}
        test.StartTest();
        BuzzLoginCallout callout=new BuzzLoginCallout();
        callout.testVariable='badcredential';
        callout.basicAuthCallout();
        test.StopTest();
    }
    
    // Negative test case for bad request get enrollment
    static testMethod void queryCapability(){
        Group integrationGroup = new Group();
        integrationGroup.Name = 'Integration Test';
        insert integrationGroup;
 
        GroupMember gm=new GroupMember(groupId=integrationGroup.Id,UserOrGroupId=UserInfo.getUserId());
		//Prevent Mixed DML Operations
        System.runAs(new User(Id = Userinfo.getUserId())) {
       		insert gm;
      	}
        test.StartTest();
        //BuzzGetEnrollmentCallout callout=new BuzzGetEnrollmentCallout();
        BuzzGetEnrollmentCallout.testVariable='badRequest';
        BuzzGetEnrollmentCallout.queryCapability();
        test.StopTest();
    }
    
    // Positive test class for updating enrollment
    @isTest(seeAllData=true)
    static void updateBuzzEnrollmentTest(){
        Id resourceId=[Select ID from KimbleOne__Resource__c where KimbleOne__Contact__c!=null and KimbleOne__User__c!=null limit 1].Id;
        Id capabilityTypeId=[Select ID from KimbleOne__CapabilityType__c limit 1].Id;
        Test.StartTest();
        KimbleOne__ResourceCapability__c resourceCapability=new KimbleOne__ResourceCapability__c(KimbleOne__CapabilityType__c=capabilityTypeId,
                                                                                                 KimbleOne__BooleanRating__c=true,
                                                                                                 KimbleOne__Resource__c=resourceId,
                                                                                                 Buzz_Enrollment_ID__c='TestId');
        insert resourceCapability;
        Test.stopTest();
    }
    
    // Negative test class for updating enrollment
    static testMethod void updateBuzzEnrollmentNegativeTest(){
        
        String JSONString = '{'+
            '  \"requests\":{'+
            '    \"enrollment\":[{'+
            '      \"enrollmentid\": \"6068\",'+
            '      \"entityid\": \"6065\",'+
            '      \"flags\": \"2097153\",'+
            '      \"status\": 1,'+
            '      \"startdate\": \"2008-04-21T18:30:00Z\",'+
            '      \"enddate\": \"2008-05-21T18:30:00Z\"'+
            '    }]'+
            '  }'+
            '}';
        Group integrationGroup = new Group();
        integrationGroup.Name = 'Integration Test';
        insert integrationGroup;
        GroupMember gm=new GroupMember(groupId=integrationGroup.Id,UserOrGroupId=UserInfo.getUserId());
        insert gm;
        Test.startTest();
        // instantiate a new instance of the Queueable class
        // The queueable class performs the update to Buzz
        BuzzQueueableCallout updateJob=new BuzzQueueableCallout(JSONString,'badRequest');
        // enqueue the job for processing
        ID jobID = System.enqueueJob(updateJob);
        Test.stopTest();
    }
}