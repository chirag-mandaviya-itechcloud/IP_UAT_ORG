trigger ContactTrigger on Contact (before insert, before update) {
   // if(!System.isBatch() && !System.isFuture() && !System.isQueueable() && !System.isScheduled()){
        new TH_Contact().run();
   // }
}