public with sharing class AddParticipantsController {
    @AuraEnabled
    public static OpportunityWithParticipantsBundle getParticipants(Id oppId) {
        Opportunity opp = [
            SELECT Training__c, Participants_quantity__c
            FROM Opportunity
            WHERE Id =: oppId limit 1
        ];

        Id trainingId = opp.Training__c;

        List<Participant__c> participants =  [
            SELECT Contact__c, Training__c, Opportunity_Name__c, Opportunity_Name__r.Id
            FROM Participant__c
            WHERE  Training__c =: trainingId and Contact__c != null
        ];

        OpportunityWithParticipantsBundle ret = new OpportunityWithParticipantsBundle(participants, opp);

        return ret;
    }

    @AuraEnabled
    public static void setParticipants(Id oppId, Id trainingId, List<String> contactsAsStrings) {
        List<Contact> contacts = [
            SELECT Id, AccountId
            FROM Contact
            WHERE Id in :contactsAsStrings
        ];

        Training__c training = [
            SELECT Id, Max_participants_quantity__c, Participants__c
            FROM Training__c
            WHERE id =: trainingId limit 1
        ];

        List<Participant__c> participants = [
            SELECT Id, Training__c, Contact__c
            FROM Participant__c
            WHERE Training__c =: trainingId
        ];

        List<Id> existingsContacts = new List<Id>();
        for(Participant__c p : participants) {
            existingsContacts.add(p.Contact__c);
        }

        if(existingsContacts.size() + training.Participants__c > training.Max_participants_quantity__c) {
            System.debug('throw error');
            System.debug(existingsContacts.size());
            System.debug(training.Participants__c );

            throw new AuraHandledException('To much participants, training is already full!');
        }

        List<Participant__c> toInsert = new List<Participant__c>();
        for(Contact c : contacts) {
            if(!existingsContacts.contains(c.Id)) {
                Participant__c p = new Participant__c(
                    Contact__c = c.Id, 
                    Training__c = trainingId,
                    Opportunity_Name__c = oppId
                    
                );

                p.RecordTypeId = Schema.SObjectType.Participant__c.getRecordTypeInfosByName()
                                       .get('Company Participant').getRecordTypeId();

                toInsert.add(p);
            } 
        }

        insert toInsert;
    }
}