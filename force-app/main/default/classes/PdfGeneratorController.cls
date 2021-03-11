public with sharing class PdfGeneratorController {
    public Training__c t {get;set;}
    public Participant__c p {get;set;}

    public List<Participant__c> participants {get;set;}
    public String currentRecordId {get;set;}
    public Integer participantsNumber {get;set;}

    public PdfGeneratorController(ApexPages.StandardController stdController) {
        this.currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');

        this.t = [
            SELECT Name, Location__c, Start_Date__c, End_Date__c, Training_Course__r.Name, 
                   Training_Course__r.Description__c, Location__r.Address__c, Trainer__r.Name
            FROM Training__c
            WHERE Id =: currentRecordId limit 1
        ];

        this.participants = [
            SELECT Name, GPA__c, Training__c, Contact__r.Name
            FROM Participant__c
            WHERE Training__c =: t.Id
        ];

        this.participantsNumber = participants.size();

        System.debug('Participants in contructor: ' + this.participants);
        System.debug('Training in contructor: ' + this.t);
        System.debug('First Participant in contructor: ' + this.p);
    }

    @AuraEnabled
    public static void saveAll(Id trainingId){
        System.debug('saveAll trainingId: ' + trainingId);

        List<Participant__c> participants = [
            SELECT Name, GPA__c, Training__c, Contact__r.Name
            FROM Participant__c
            WHERE Training__c =: trainingId
        ];

        System.debug('Parts: ' + participants);

        List<Attachment> attachs = new List<Attachment> ();

        for(Participant__c p : participants) {
            PageReference pdfPage = Page.PDFGeneratorParticipantTemplate;
            pdfPage.getParameters().put('id', String.valueOf(p.Id));
            
            Blob pdfContent = pdfPage.getContentAsPDF();
            
            Attachment attach= new Attachment();
            attach.ParentId = p.Id;
            attach.Name = 'Certificate';
            attach.Body = pdfContent;
            attach.contentType = 'application/pdf';

            attachs.add(attach);
        }

        insert attachs;
    }

    public String[] getStrings() {
        List<String> temp = new List<String>();

        for(Participant__c p : participants) {
            PageReference pdfPage = Page.PDFGeneratorParticipantTemplate;
            pdfPage.getParameters().put('p.GPA__c', String.valueOf(p.GPA__c));
            String pdfContent = pdfPage.getContent().toString();

            temp.add(pdfContent);
        }

        return temp;
    }

    public void saveAllPdf() {
        System.debug('Entered saveAllPdf');

        for(Participant__c p : this.participants) {
            this.p = p;
            System.debug('id === ' + p.Id);
            attachPdfToParticipant(p.Id);
        }
    }

    public void attachPdfToParticipant(Id participantId) {
        try {
            System.debug('Entered attachPdfToParticipant');

            PageReference pdfPage = Page.PDFGeneratorParticipantTemplate;
            pdfPage.getParameters().put('id', String.valueOf(this.p.Id));
            
            Blob pdfContent = pdfPage.getContentAsPDF();
            
            Attachment attach1= new Attachment();
            attach1.ParentId = currentRecordId;
            attach1.Name = 'Test Attachment for PDF';
            attach1.Body = pdfContent;
            attach1.contentType = 'application/pdf';

            insert attach1;
            System.debug('Inserted');
        } catch (Exception e) {
            System.debug(e);
        }
    }
}