global class RemindOpptyOwners implements Schedulable {
    global void execute(SchedulableContext ctx) {
        List<Training__c> trainigs = [select Start_Date__c, Participants__c, Location__c, Trainer__c from Training__c];
        
        for(Training__c t : trainigs ) {
            Integer days = (System.today()).daysBetween(Date.valueOf(t.Start_Date__c));

            if(days <= 5) {
                sendEmail(t);
            }
        }
    }
    
    private void sendEmail(Training__c t) {
        
    }
}