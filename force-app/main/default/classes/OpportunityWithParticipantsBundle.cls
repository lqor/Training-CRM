public with sharing class OpportunityWithParticipantsBundle {
    @AuraEnabled
    public List<Participant__c> participants;

    @AuraEnabled
    public Opportunity opp;

    public OpportunityWithParticipantsBundle(List<Participant__c> participants, Opportunity opp) {
        this.participants = participants;
        this.opp = opp;
    }
}