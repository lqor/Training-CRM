public with sharing class EmailTempateParticipantsController {
    List<Participant__c> participants;

    public EmailTempateParticipantsController() {
        List<Participant__c> participants = new List<Participant__c>();

        List<Training__c> trainigs  = [
            SELECT Trainer__r.Email, Restaurant__r.Email__c, Location__r.Email__c, Location__c, Trainer__c, Restaurant__c,
            (SELECT id, Contact__c, Name, Training__c FROM Participants__r)
            FROM Training__c 
            WHERE Days_to_start__c = 5
        ];
        
        for(Training__c t : trainigs) {
            System.debug(t.Participants__r);
            participants = t.Participants__r;
        }

        this.participants = participants;
    }

    public void sendEmail(List<String> emails, List<Participant__c> participants) {
        EmailTemplate emailTemplate = [
                SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body 
                FROM EmailTemplate 
                WHERE developerName = 'Participats_list_template' limit 1
            ];
        
        System.debug(this.participants);

        this.participants = participants;

        System.debug(participants);
        
        ID whatID = '0015I000006CAMIQA4';
        Contact cnt = [select id, Email from Contact where email != null limit 1];

        List<Messaging.SingleEmailMessage> msgList = new List<Messaging.SingleEmailMessage>();
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();

        msg.setTemplateID(emailTemplate.Id);
        msg.setWhatId(whatID);
        msg.setTargetObjectId(cnt.id);
        //msg.setToAddresses(emails);
        msg.setToAddresses(new List<String>{'igor.kudryk@gmail.com'});
        msgList.add(msg);

        Savepoint sp = Database.setSavepoint();
        Messaging.sendEmail(msgList);
        Database.rollback(sp);

        List<Messaging.SingleEmailMessage> msgListToBeSend = new List<Messaging.SingleEmailMessage>();
        for(Messaging.SingleEmailMessage email : msgList) {
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            emailToSend.setToAddresses(email.getToAddresses());
            emailToSend.setPlainTextBody(email.getPlainTextBody());
            emailToSend.setHTMLBody(email.getHTMLBody());
            emailToSend.setSubject(email.getSubject());
            emailToSend.setFileAttachments(email.getFileAttachments());
            msgListToBeSend.add(emailToSend);
        }

        System.debug(this.participants);

        Messaging.sendEmail(msgListToBeSend);
    }

    public List<Participant__c> getParticipants() {
        return this.participants;
    }

    public void setParticipants(List<Participant__c> participants) {
        this.participants = participants;
    }
}