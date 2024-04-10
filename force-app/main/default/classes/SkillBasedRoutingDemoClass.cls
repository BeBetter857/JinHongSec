public with sharing class SkillBasedRoutingDemoClass {
    @InvocableMethod(label='RoutingCasesToAgents' description='RoutingCasesToAgents')
    public static void routingCasesToAgents(List<RoutingCasesToAgentsRequest> requests){

        List<String> caseIds = new List<String>();
        String strEntity;
        for(RoutingCasesToAgentsRequest rctar : requests){
            caseIds.add(rctar.caseId);
            
        }
        strEntity = requests[0].strEntity;

        List<Case> casesInserted = [SELECT id,subject from Case where ID IN: caseIds];
        
        // Get channelId
        String channelId = getChannelId(strEntity);

        // Create PendingServiceRouting 
        List<PendingServiceRouting> psrList = createdPendingServiceRouting(casesInserted, channelId);

        List<String> matchingSkillIds = getMatchingSkill(casesInserted);
        // Add skills to the request for the case
        createdSkillRequirement(psrList, matchingSkillIds);
        
        // Push it to queue
        for(PendingServiceRouting psr : psrList){
            psr.IsReadyForRouting = true;
        }
        update psrList;
    }

    public static List<PendingServiceRouting> createdPendingServiceRouting(List<Case> casesInserted, String channelId){  
        List<PendingServiceRouting> psrList = new List<PendingServiceRouting>();
        Map<String,PendingServiceRouting> psrCaseIdMap = new Map<String,PendingServiceRouting>();
        for(Case caseRec : casesInserted){
            PendingServiceRouting psr = new PendingServiceRouting();
            psr.workItemId = caseRec.Id;
            psr.RoutingType = 'SkillsBased';
            psr.RoutingPriority = 1;
            psr.CapacityWeight = 1;
            psr.ServiceChannelId = channelId;
            psr.RoutingModel = 'MostAvailable';
            psr.IsReadyForRouting = false;
            psrList.add(psr);
        }
        insert psrList;
        return psrList;
    }
    
    public static List<String> getMatchingSkill(List<Case> casesInserted){  
        LIst<Skill> allSkillsInDB = [SELECT Id,MasterLabel FROM Skill];
        List<String> matchingSkillIds = new List<String>();

        for(Case caseRec : casesInserted){
            for(Skill skillRec: allSkillsInDB){
                if(caseRec.Subject.contains(skillRec.MasterLabel)){
                    matchingSkillIds.add(skillRec.Id);
                }
            }
        }
        return matchingSkillIds;
    }

    public static void createdSkillRequirement(List<PendingServiceRouting> psrList, List<String> matchingSkillIds){ 
        List<SkillRequirement> skillRequirementList = new List<SkillRequirement>();
        for(PendingServiceRouting psr : psrList){
            for(String matchingSkillId: matchingSkillIds){
                SkillRequirement skillRequ = new SkillRequirement();
                skillRequ.SkillId = matchingSkillId;
                skillRequ.RelatedRecordId = psr.id;
                skillRequ.SkillLevel = 5;
                skillRequirementList.add(skillRequ);
            }
        }
        insert skillRequirementList;
    }
   
    public static String getChannelId(String strEntity) {
        List<ServiceChannel> channelList = [SELECT Id FROM ServiceChannel WHERE RelatedEntity = :strEntity];
        return channelList[0]?.Id;
    }

    public class RoutingCasesToAgentsRequest {
        @InvocableVariable(required = true)
        public String caseId;

        @InvocableVariable(required = true)
        public String strEntity;
    }
    
}