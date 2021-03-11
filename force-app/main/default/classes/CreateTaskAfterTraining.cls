public with sharing class CreateTaskAfterTraining implements Schedulable {
    public void execute(SchedulableContext ctx) {
        Date today = Date.today();
        List<Training__c> trainigs  = [
            SELECT Trainer__r.Email, Start_Date__c, End_Date__c, Restaurant__r.Email__c, Location__r.Email__c, Location__c, Trainer__c, Restaurant__c,
            (SELECT id, Contact__c, Name, Training__c FROM Participants__r)
            FROM Training__c 
            WHERE End_Date__c = today
        ];

        System.debug(trainigs);

        List<Task> tasks = new List<Task>();
        for(Training__c t : trainigs) {
            Task tsk = new Task();

            tsk.Subject = 'Fill GPA (marks) and mark participants as Participated';
            
            tsk.WhoId = t.Trainer__r.Id;
            tsk.WhatId = t.Id;
            tsk.Status = 'New';
            tsk.Type = 'Fill_GPA';
            tsk.Description = 'Fill GPA (marks) and mark participants as Participated';

            tasks.add(tsk);
        }

        insert tasks;
    }

    @AuraEnabled(cacheable=true)
    public static List<Participant__c> getParticipants(Id trainingId) {
        List<Participant__c> ret = [
            SELECT GPA__c, Training__c, Contact__r.Name, Contact__c
            FROM Participant__c
            WHERE Training__c =:trainingId
        ];

        return ret;
    }

    @AuraEnabled(cacheable=true)
    public static List<Participant__c> getParticipantsByTaskId(Id taskId) {
        /*        
        Task task = [
            SELECT WhatId
            FROM Task
            WHERE id =:taskId limit 1
        ];

        List<Participant__c> ret = CreateTaskAfterTraining.getParticipants(task.WhatId);
        */
        return getParticipants(taskId);
    }
}