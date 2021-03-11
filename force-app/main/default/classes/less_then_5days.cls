public class less_then_5days implements Schedulable {
    public void execute(SchedulableContext ctx) {
        List<Training__c> trainigs  = [
            SELECT Start_Date__c, Participants__c, Location__c, Trainer__c 
            FROM Training__c 
            WHERE Days_to_start__c = 5
        ];
        
        List<Participant__c> participants = [
            SELECT Contact__c, Name, Training__c
            FROM Participant__c
            WHERE Training__c in :trainigs
        ];
        
        EmailTempateParticipantsController templateController = new EmailTempateParticipantsController();
        for(Training__c t : trainigs) {
            List<Participant__c> participantsTemp = new List<Participant__c>();

            //find participants for this training
            for(Participant__c p : participants) {
                if(p.Training__c == t.Id) {
                    participantsTemp.add(p);
                }
            }

            // send to location
            if(t.Location__r != null && t.Location__r.Email__c != null) {
                templateController.sendEmail(t.Location__r.Email__c, participantsTemp); 
            }

            //send to restaurant
            if(t.Restaurant__c != null && t.Restaurant__r.Email__c != null) {
                templateController.sendEmail(t.Restaurant__r.Email__c, participantsTemp);
            }

            //send to trainer
            if(t.Trainer__c != null && t.Trainer__r.Email != null) {
                templateController.sendEmail(t.Trainer__r.Email, participantsTemp);
            }
        }
    }
}