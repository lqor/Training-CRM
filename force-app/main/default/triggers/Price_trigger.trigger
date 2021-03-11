trigger Price_trigger on Training__c (before insert, before update) {
    Set<Id> productsFromTrainings = new Set<Id>();
    // product id ---> PricebookEntry
    List<PricebookEntry> pricebookEntries
        = [ select Product2Id, UnitPrice
            from PricebookEntry
            where Product2Id in :productsFromTrainings and UseStandardPrice=true];

    for(Training__c t : Trigger.New) {
        if(t.Product__c != null) {
            productsFromTrainings.add(t.Product__c);
        }
    }
    
    Map<Id, PricebookEntry> productEntryMap = new Map<Id, PricebookEntry>();
    for(PricebookEntry pbe : pricebookEntries) {
        productEntryMap.put(pbe.Product2Id, pbe);
    }

    for(Training__c t : Trigger.New) {
        if(t.Product__c != null && productEntryMap.get(t.Product__c) != null && productEntryMap.get(t.Product__c).UnitPrice != null) {
            t.List_Price__c = productEntryMap.get(t.Product__c).UnitPrice;
        }
    }
}