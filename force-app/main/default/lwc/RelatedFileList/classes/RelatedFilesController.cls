public class RelatedFilesController {
     
    @AuraEnabled
    public static List<ContentDocument> getRelatedDocs(Id recordId){
        List<ContentDocument> cdList = new List<ContentDocument>();
        List<ContentDocumentLink> cdlList = [SELECT ContentDocumentId FROM ContentDocumentLink
                                             WHERE LinkedEntityId = :recordId];
        Set<Id> cdIds = new Set<Id>();
        for (ContentDocumentLink cdl : cdlList) {
            cdIds.add(cdl.ContentDocumentId); 
        }        
        cdList = [SELECT Id, Title, FileType, OwnerId, Owner.Name, CreatedDate,
                  CreatedById, CreatedBy.Name, ContentSize
                  FROM ContentDocument WHERE Id IN :cdIds];
        return cdList;
    }
     
    @AuraEnabled
    public static string getDocURL(Id docId){
        ContentVersion cv = [SELECT Id FROM ContentVersion WHERE ContentDocumentId = :docId AND IsLatest = true];
        String cvDownloadURL = URL.getSalesforceBaseUrl().toExternalForm() + '/sfc/servlet.shepherd/version/download/' + cv.Id;
        return cvDownloadURL;
    }
     
    @AuraEnabled
    public static void deleteDoc(Id docId){
        ContentDocument conDoc = new ContentDocument(Id = docId);
        delete conDoc;
    }
}