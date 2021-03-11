public with sharing class PDFGeneratorParticipantController { 
    public Participant__c p {get;set;}
    public Training__c t {get;set;}

    public Participant__c participant {get;set;}
    public Integer participantsNumber {get;set;}

    public PDFGeneratorParticipantController() {
        String currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');

        this.p = [
            SELECT Name, GPA__c, Training__c, Contact__r.Name
            FROM Participant__c
            WHERE id =: currentRecordId
        ];

        this.t = [
            SELECT Name, Location__c, Start_Date__c, End_Date__c, Training_Course__r.Name, 
                   Training_Course__r.Description__c, Location__r.Address__c, Trainer__r.Name
            FROM Training__c
            WHERE Id =: p.Training__c limit 1
        ];

        this.participantsNumber = 1;
        this.participant = p;

    }
}