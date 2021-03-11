public class DemoSendEmailWithAttachment {
    public void SendEmailWithAttachment() {
        String subject = 'Paticipants list to your training';
        String body = 'This is testing for Send emails with attachment from your apex class in Salesforce';

        // Define the email
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 

        // Create the email attachment    
        PageReference pageRef = Page.DemoSendEmailWithAttachment;
        String pdfContent = 'This is a test string';
        Blob b = Blob.toPDF(pdfContent);

        // Create the email attachment
        Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();
        efa.setFileName('attachment.pdf');
        efa.setBody(b);

        // Set the paramaters to the email object
        email.setSubject( subject );
        
        // Here I am accessing current user email id to whom we are sending email
        email.setToAddresses( new String[] {'igor.kudryk@gmail.com'} );
        email.setPlainTextBody( body );
        
        // Attach file using setFileAttachments function
        email.setFileAttachments(new Messaging.EmailFileAttachment[] {efa});

        // Sends the email
        Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});   
    }
}