public class EmailDaysUntilStart5 implements Schedulable {
    public void execute(SchedulableContext ctx) {
        List<Training__c> trainigs  = [
            SELECT Trainer__r.Email, Restaurant__r.Email__c, Location__r.Email__c, Location__c, Trainer__c, Restaurant__c,
            (SELECT id, Contact__c, Name, Training__c FROM Participants__r)
            FROM Training__c 
            WHERE Days_to_start__c = 5
        ];
        
        List<Messaging.SingleEmailMessage> finalEmails = new List<Messaging.SingleEmailMessage> ();
        for(Training__c t : trainigs) {
            List<String> emails = new List<String>();

            if(t.Location__c != null && t.Location__r.Email__c != null) {
                emails.add(t.Location__r.Email__c);
            }

            if(t.Restaurant__c != null && t.Restaurant__r.Email__c != null) {
                emails.add(t.Restaurant__r.Email__c);
            }

            if(t.Trainer__c != null && t.Trainer__r.Email != null) {
                emails.add(t.Trainer__r.Email);
            }

            //sendEmailWithAttachment(emails, t.Participants__r);
            
            List<Id> ids = new List<Id>();
            for(Participant__c p : t.Participants__r) {
                ids.add(p.Contact__c);
            }

            List<Contact> contacts = [
                SELECT id, Name
                FROM Contact
                WHERE id in:ids
            ];

            List<String> names = new List<String>();
            for(Contact c : contacts) {
                names.add(c.Name);
            }


            String subject = 'Paticipants list to your training';
            String body = 'This is testing for Send emails with attachment from your apex class in Salesforce';

            // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

            // Create the email attachment    
            PageReference pageRef = Page.DemoSendEmailWithAttachment;
            String pdfContent = String.join(names, ', ');
            Blob b = Blob.toPDF(pdfContent);

            // Create the email attachment
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('attachment.pdf');
            efa.setBody(b);

            // Set the paramaters to the email object
            email.setSubject( subject );
            
            // Here I am accessing current user email id to whom we are sending email
            email.setToAddresses( emails );
            email.setPlainTextBody( body );
            
            // Attach file using setFileAttachments function
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

            finalEmails.add(email);
        }
        
        Messaging.SendEmailResult [] r = Messaging.sendEmail(finalEmails);   
    }

    /*
    public void sendEmailWithAttachment(List<String> emails, List<Participant__c> participants) {
        Messaging.SingleEmailMessage finalEmails = new List<Messaging.SingleEmailMessage> ();

        for() {
            List<Id> ids = new List<Id>();
            for(Participant__c p : participants) {
                ids.add(p.Contact__c);
            }

            List<Contact> contacts = [
                SELECT id, Name
                FROM Contact
                WHERE id in:ids
            ];

            List<String> names = new List<String>();
            for(Contact c : contacts) {
                names.add(c.Name);
            }


            String subject = 'Paticipants list to your training';
            String body = 'This is testing for Send emails with attachment from your apex class in Salesforce';

            // Define the email
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

            // Create the email attachment    
            PageReference pageRef = Page.DemoSendEmailWithAttachment;
            String pdfContent = String.join(names, ', ');
            Blob b = Blob.toPDF(pdfContent);

            // Create the email attachment
            Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
            efa.setFileName('attachment.pdf');
            efa.setBody(b);

            // Set the paramaters to the email object
            email.setSubject( subject );
            
            // Here I am accessing current user email id to whom we are sending email
            email.setToAddresses( emails );
            email.setPlainTextBody( body );
            
            // Attach file using setFileAttachments function
            email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

            }

        // Sends the email
    }
    */
}