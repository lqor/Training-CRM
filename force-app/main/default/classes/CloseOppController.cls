public with sharing class CloseOppController {
    @AuraEnabled
    public static Opportunity closeOppFromController(String status, Id oppId){
        Opportunity opp = [
            SELECT Id, Closed_with_action__c, StageName
            FROM Opportunity
            WHERE Id =: oppId limit 1
        ];

        if(status == 'won') {
            opp.Closed_with_action__c = true;
            opp.StageName = 'Closed Won';
        } else if(status == 'lost') {
            opp.Closed_with_action__c = true;
            opp.StageName = 'Closed Lost';
        } 

        update opp;
        return opp;
    }
}
