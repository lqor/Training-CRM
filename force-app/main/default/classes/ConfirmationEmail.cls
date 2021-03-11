public with sharing class ConfirmationEmail implements Schedulable {
    public void execute(SchedulableContext ctx) {
        List<Training__c> trainigs  = [
            SELECT Trainer__r.Email, Restaurant__r.Email__c, Location__r.Email__c, Location__c, Trainer__c, Restaurant__c,
            (SELECT id, Contact__c, Contact__r.Email, Name, Training__c FROM Participants__r)
            FROM Training__c 
            WHERE Days_to_start__c = 2
        ];
        
        sendEmailToTrainings(trainigs);
    }

    public void sendEmailToTrainings(List<Training__c> trainigs) {
        List<Messaging.SingleEmailMessage> finalEmails = new List<Messaging.SingleEmailMessage> ();
        for(Training__c t : trainigs) {
            for(Participant__c p : t.Participants__r) {
                Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

                message.setTargetObjectId(p.Contact__c); 
                message.setSenderDisplayName('Company Support'); 
                message.setReplyTo('no-reply@company.com');
                message.setUseSignature(false); 
                message.setBccSender(false); 
                message.setSaveAsActivity(true); 

                EmailTemplate emailTemplate = [
                    SELECT Id,Subject,Description,HtmlValue,DeveloperName,Body 
                    FROM EmailTemplate 
                    WHERE name = 'Confirmation email' limit 1
                ];

                System.debug('Email template: ' + emailTemplate.Id);

                message.setTemplateID(emailTemplate.Id); 
                message.setWhatId(p.Id); //This is important for the merge fields in template to work
                message.toAddresses = new String[] { p.Contact__r.Email};

                finalEmails.add(message);
            }
        }

        Messaging.SendEmailResult [] r = Messaging.sendEmail(finalEmails);
    }

    // Just for testing
    public void sendEmailByid(Id trainigId) {
        List<Training__c> trainigs  = [
            SELECT Trainer__r.Email, Restaurant__r.Email__c, Location__r.Email__c, Location__c, Trainer__c, Restaurant__c
            FROM Training__c 
            WHERE Id =: trainigId limit 1
        ];

        System.debug('In sendEmailByid');
        
        sendEmailToTrainings(trainigs);
    }
}