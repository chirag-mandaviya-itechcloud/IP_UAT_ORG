public class TH_Contact extends BaseTriggerHandler{
    public static List<Contact> newContactList;
    public static List<Contact> oldContactList;
    public static Map<ID, Contact> newContactMap;
    public static Map<ID, Contact> oldContactMap;
    
    public TH_Contact()
    {
        oldContactList = (List<Contact>)Trigger.old;
        newContactList = (List<Contact>)Trigger.new;
        newContactMap = (Map<Id, Contact>)Trigger.newMap;
        oldContactMap = (Map<Id, Contact>)Trigger.oldMap;
    }
    
    protected override void beforeInsert() { 
        if(Trigger_PAD.canRun('TH_ContactBeforeInsert')){ 
            proccesRecordBeforeContact();
        } 
    }
    protected override void AfterInsert() { 
        if(Trigger_PAD.canRun('TH_ContactAfterInsert')){} 
    }
    protected override void AfterUpdate() { 
        if(Trigger_PAD.canRun('TH_ContactAfterUpdate')){} 
    }
    protected override void beforeUpdate() { 
        if(Trigger_PAD.canRun('TH_ContactBeforeUpdate')){ 
            proccesRecordBeforeContact();
        }
    }
    
    public static void proccesRecordBeforeContact(){
        checkContactStatus();
        checkRelatedAccount();
    }
    
    public static void checkContactStatus(){
        If(!newContactList.isEmpty()){
            For(Contact contact : newContactList){
                if(Trigger.isInsert || oldContactMap.get(contact.Id).Contact_Status__c != contact.Contact_Status__c){
                    If(contact.Contact_Status__c == 'Active') {
                        contact.Inactive__c = false;
                    }
                    else {
                        contact.Inactive__c = true;
                    }
                }
            }
        }
    }
    
    public static void checkRelatedAccount(){
        Map<String, String> ContactIdWiseAccount = new Map<String, String>();
        
        for(Contact Con : newContactList){
            if(Con.AccountId != null ){
                ContactIdWiseAccount.put(Con.Id, Con.AccountId);
            }
        }
        
        // Retrieving Acccounts 
        //Map<Id, Account> AccountIdWiseAccount = DAL_Account.getAllAccountMapById(ContactIdWiseAccount.values());
        Map<Id, Account> AccountIdWiseAccount = DAL_Account.getAllAccountMapByIdList(ContactIdWiseAccount.values());

        
        for(Contact Con : newContactList){
            // Logic for InActive Account
            if(ContactIdWiseAccount.containsKey(Con.Id)){
                if(AccountIdWiseAccount.containsKey(ContactIdWiseAccount.get(Con.Id))){
                    if(AccountIdWiseAccount.get(ContactIdWiseAccount.get(Con.Id)).Inactive__c == TRUE){
                        // throwing error added account is Inactive
                        Con.addError('You can not add Inactive Account on Contact');
                    }
                }
            }
        }
    }
}