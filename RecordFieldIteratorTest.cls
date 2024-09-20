@isTest
public class RecordFieldIteratorTest {
    @isTest
    static void testHappyPath(){

        Profile p = [SELECT Id FROM Profile WHERE Name='Service']; 
        User u = new User(Alias = 'TSU999', 
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
                // Initialize request and account, then assign the account to the request
                RecordFieldIterator.FieldIteratorRequest request = new RecordFieldIterator.FieldIteratorRequest();
                Account a= new Account(Name = 'Test Account',
                    Description = 'This is a test account',
                    Status__c = 'Active',
                    Tier__c = 'Growth',
                    ParentId = null,
                    Key_Agency__c = true );

                request.record = a;

                // Test expected results are returned (not null, correct size for responses, correct size for results, correct match)
                request.keyPhrase = 'Growth';
                List<RecordFieldIterator.FieldIteratorResponse> responses = RecordFieldIterator.execute ( new List<RecordFieldIterator.FieldIteratorRequest>{request});
                System.Assert.isNotNull(responses, 'Returned Null value');
                System.Assert.areEqual(1, responses.size(), 'Responses returned incorrect size');
                System.Assert.areEqual(1, responses[0].result.size(), 'Results returned incorrect size');
                String expected = 'Tier';
                System.Assert.areEqual(expected, responses[0].result[0]);

            Test.stopTest();
        }
    }
    
    @isTest
    static void testNullRecord(){

        // Creates Service User to ensure results aligned with expected usage
        Profile p = [SELECT Id FROM Profile WHERE Name='Service']; 
        User u = new User(Alias = 'TSU999', 
                            Email='serviceuser999@testorg.com', 
                            EmailEncodingKey='UTF-8', 
                            LastName='Testing', 
                            LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', 
                            ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', 
                            UserName='serviceuser4387549387589435@testorg.com.tyrr');        

        System.runAs(u){

            Test.startTest();

                // Initialize request with key phrase but no object
                RecordFieldIterator.FieldIteratorRequest request = new RecordFieldIterator.FieldIteratorRequest();
                request.keyPhrase = 'Test';

                // Attempts to execute Field Iterator main with null request.record and catches exception
                try{
                    List<RecordFieldIterator.FieldIteratorResponse> responses = RecordFieldIterator.execute ( new List<RecordFieldIterator.FieldIteratorRequest>{request});
                    System.Assert.fail('Expected RecordFieldIteratorException');
                } catch (RecordFieldIterator.RecordFieldIteratorException e){
                    // Expected exception
                }

            Test.stopTest();

        }
    }

    @isTest
    static void testBlankKeyPhrase(){

        // Creates Service User to ensure results aligned with expected usage
        Profile p = [SELECT Id FROM Profile WHERE Name='Service']; 
        User u = new User(Alias = 'TSU999', 
                            Email='serviceuser999@testorg.com', 
                            EmailEncodingKey='UTF-8', 
                            LastName='Testing', 
                            LanguageLocaleKey='en_US', 
                            LocaleSidKey='en_US', 
                            ProfileId = p.Id, 
                            TimeZoneSidKey='America/Los_Angeles', 
                            UserName='serviceuser4387549387589435@testorg.com.tyrr');        

        System.runAs(u){

            Test.startTest();

                // Initialize request with blank key phrase
                RecordFieldIterator.FieldIteratorRequest request = new RecordFieldIterator.FieldIteratorRequest();
                Account a= new Account(Name = 'Test Account',
                    Description = 'This is a test account',
                    Status__c = 'Active',
                    Tier__c = 'Growth',
                    ParentId = null,
                    Key_Agency__c = true );

                request.record = a;
                request.keyPhrase ='';

                // Starts test with blank key phrase
                List<RecordFieldIterator.FieldIteratorResponse> responses = RecordFieldIterator.execute ( new List<RecordFieldIterator.FieldIteratorRequest>{request});
                System.Assert.areEqual(0, responses[0].result.size());

                // Blank out Account Description
                a.Description ='';
                request.record = a;

                // Starts test with blank key phrase
                responses = RecordFieldIterator.execute ( new List<RecordFieldIterator.FieldIteratorRequest>{request});
                String expected = 'Agency Description';
                System.Assert.areEqual(expected, responses[0].result[0]);

            Test.stopTest();
        }
    }

    @isTest
    static void testContact(){

        Profile p = [SELECT Id FROM Profile WHERE Name='Service']; 
        User u = new User(Alias = 'TSU999', 
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
                // Initialize request and account, then assign the account to the request
                RecordFieldIterator.FieldIteratorRequest request = new RecordFieldIterator.FieldIteratorRequest();
                Account a = new Account(Name='Test Account');
                Contact c= new Contact(FirstName = 'Test',
                    LastName = 'Contact',
                    AccountId = a.Id,
                    Notes__c = 'Test',
                    Referral_Origination__c = 'Test' );

                request.record = c;
                request.keyPhrase = 'Test';

                // Test expected results are returned (not null, correct size for responses, correct size for results, correct match)
                List<RecordFieldIterator.FieldIteratorResponse> responses = RecordFieldIterator.execute ( new List<RecordFieldIterator.FieldIteratorRequest>{request});
                System.Assert.isNotNull(responses, 'Returned Null value');
                System.Assert.areEqual(1, responses.size(), 'Responses returned incorrect size');
                System.Assert.areEqual(3, responses[0].result.size(), 'Results returned incorrect size');

            Test.stopTest();
        }
    }
}
