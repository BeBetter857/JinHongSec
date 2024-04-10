trigger AccountTrigger on Account (before update) {
    List<Id> ids = new List<Id>();
    for(Account ac : Trigger.new){
        ids.add(ac.Id);
    }
    DupeSearcherBatch.callfuture(ids);
}

