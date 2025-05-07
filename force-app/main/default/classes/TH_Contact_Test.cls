@isTest
public class TH_Contact_Test {
    
    public static User admin_User;
    public static Integer count =1;
    public static string SYSTEM_ADMINISTRATOR_PROFILE ='System Administrator';
    public static List<Contact> ContactList = new List<Contact>();
    public static List<Account> acc = new List<Account>();
    
    @isTest
    public static void testMethod1()
    {
        
        admin_User = TestDataFactory.createUser(true,'User',SYSTEM_ADMINISTRATOR_PROFILE);
        insert admin_User;
        System.runAs(admin_User)
        {
            Map<String,Object>  Accountobj = new Map<String,Object>();
            Accountobj.put('Name','NewAcco');
            Accountobj.put('Distributor__c',True);
            Accountobj.put('Account_Email__c','test@gmail.com');
            for(Integer i = 0 ; i <count; i++)
            {
                acc.add((Account) TestDataFactory.operationOnObjectRec('insert', 'Account', Accountobj));
            }
            
            Map<String,Object>  Contactobj = new Map<String,Object>();
            Contactobj.put('LastName','test');
            Contactobj.put('AccountId',acc[0].Id);
            Contactobj.put('Contact_Status__c','Active');
            for(Integer i = 0 ; i <count; i++)
            {
                ContactList.add((Contact) TestDataFactory.operationOnObjectRec('insert', 'Contact', Contactobj));
            }
            Contact con = [SELECT Id,Inactive__c FROM Contact LIMIT 1];
           // system.assertEquals(false, con.Inactive__c);
        }
    }     
    
    @isTest
    public static void testMethod2()
    {
        
        admin_User = TestDataFactory.createUser(true,'User',SYSTEM_ADMINISTRATOR_PROFILE);
        insert admin_User;
        System.runAs(admin_User)
        {
            Map<String,Object>  Accountobj = new Map<String,Object>();
            Accountobj.put('Name','NewAcco');
            Accountobj.put('Distributor__c',True);
            Accountobj.put('Account_Email__c','test@gmail.com');
            for(Integer i = 0 ; i <count; i++)
            {
                acc.add((Account) TestDataFactory.operationOnObjectRec('insert', 'Account', Accountobj));
            }
            
            Map<String,Object>  Contactobj = new Map<String,Object>();
            Contactobj.put('LastName','test');
            Contactobj.put('AccountId',acc[0].Id);
            Contactobj.put('Contact_Status__c','Other');
            for(Integer i = 0 ; i <count; i++)
            {
                ContactList.add((Contact) TestDataFactory.operationOnObjectRec('insert', 'Contact', Contactobj));
            }
            
            Contact con = [SELECT Id,Inactive__c FROM Contact LIMIT 1];
          //  system.assertEquals(true, con.Inactive__c);
        }
    }    
}