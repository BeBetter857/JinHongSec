public with sharing class MassDeleteTask implements Database.Batchable<sObject> {

    public String queryStr = 'SELECT Id FROM Task';
    public String whereStr = '';
    public Integer limitNum = 0;
    public Datetime taskStartCreatedTime;
    public Datetime taskEndCreatedTime;
    public String taskPriority = '';
    public String taskType = '';

    public MassDeleteTask(){

    }

    public MassDeleteTask(String queryStr, String whereStr, Integer limitNum){
       this.queryStr = queryStr;
       this.whereStr = whereStr;
       this.limitNum = limitNum;
    }

    public MassDeleteTask(Datetime taskStartCreatedTime, Datetime taskEndCreatedTime, String taskPriority, String taskType){
        System.debug(LoggingLevel.INFO, '*** taskStartCreatedTime : ' + taskStartCreatedTime);
        System.debug(LoggingLevel.INFO, '*** taskEndCreatedTime : ' + taskEndCreatedTime);
        this.taskStartCreatedTime = taskStartCreatedTime;
        this.taskEndCreatedTime = taskEndCreatedTime;
        this.taskPriority = taskPriority;
        this.taskType = taskType;
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        if(this.taskStartCreatedTime != null){
            this.whereStr += 'CreatedDate >= :taskStartCreatedTime ';
        }

        if(String.isNotBlank(this.whereStr)){
            if(this.taskEndCreatedTime != null){
                this.whereStr += ' AND CreatedDate <= :taskEndCreatedTime ';
            }
        }else{
            if(this.taskEndCreatedTime != null){
                this.whereStr += ' CreatedDate <= :taskEndCreatedTime ';
            }
        }

        if(String.isNotBlank(this.whereStr)){
            if(String.isNotBlank(taskPriority)){
                this.whereStr += ' AND Priority = :taskPriority ';
            }
        }else{
            if(String.isNotBlank(taskPriority)){
                this.whereStr += ' Priority = :taskPriority ';
            }
        }

        if(String.isNotBlank(this.whereStr)){
            if(String.isNotBlank(taskType)){
                this.whereStr += ' AND Type = :taskType ';
            }
        }else{
            if(String.isNotBlank(taskType)){
                this.whereStr += ' Type = :taskType ';
            }
        }

        String query = '';
        if(String.isNotBlank(this.whereStr)){
            query = this.queryStr + ' WHERE ' + this.whereStr;
        }else{
            query = this.queryStr;
        }

        System.debug(LoggingLevel.INFO, '*** query : ' + query);
        
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext bc, List<Task> tasks) {
        System.debug(LoggingLevel.INFO, '*** tasks : ' + tasks);
        
        // Database.UpsertResult[] drList = database.delete(tasks, false);
        // for(Database.UpsertResult dr : drList) {
        //     if (!dr.isSuccess()) {
        //         for (Database.Error err: dr.getErrors()) {
        //             System.debug(LoggingLevel.INFO, '*** err.getMessage() : ' + err.getMessage());
        //         }
        //     }
        // }
    }
    public void finish(Database.BatchableContext bc) {
        
    }
}