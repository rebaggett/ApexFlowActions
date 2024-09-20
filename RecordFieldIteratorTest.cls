@isTest
public class RecordFieldIteratorTest {
    static testMethod void testRecordFieldIteratorMethods(){
        
        Profile p = [SELECT Id FROM Profile WHERE Name='Service']; 
        User u = new User(Alias = 'serviceUser999', 
                            Email='serviceuser999@testorg.com', 
                            EmailEncodingKey='UTF-8', 
                            LastName='Testing', 
                            LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', 
                            ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', 
                            UserName='serviceuser4387549387589435@testorg.com.tyrr');

        System.runAs(u){ // to ensure the user is aligned to the expected test results

            
            Test.startTest();
                // Test on Account Record
                RecordFieldIterator.FieldIteratorRequest request = new RecordFieldIterator.FieldIteratorRequest();
                List<Account> requests = new List<Account>();
                request.record = new Account(Name = 'Test Account',
                    Status__c = 'Active',
                    Tier__c = 'Growth',
                    ParentId = '',
                    Key_Agency__c = true );
                request.keyPhrase = '';
                requests[0] = request;

                // Test that returns non-null response and test Growth Key Phrase (Picklist)
                requests[0].keyPhrase = 'Growth'
                List<RecordFieldIterator.FieldIteratorResponse> responses = RecordFieldIterator.execute ( new List<RecordFieldIterator.FieldIteratorRequest>{request});
                System.Assert.isNotNull(responses[0], 'Returned Null value for QA Record');
                Map<String, String> expected = new Map<String,String>('Tier', 'Growth');
                System.Assert.areEqual(expected, responses[0]);

            Test.stopTest();
        }
    }
}