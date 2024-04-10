public virtual class EC_Response {

	@AuraEnabled
	@TestVisible
	public Boolean success { get; private set; }

	@AuraEnabled
	@TestVisible
	public String message { get; private set; }

	@AuraEnabled
    @TestVisible
	public String error { get; private set; }
	
	@AuraEnabled
	public String sitePrex {get; private set;}

	@AuraEnabled
	// public string failure { get; private set;}
	public LoggingLevel failure { get; private set; }

	public EC_Response() {
		this.success = true;
		this.sitePrex = System.site.getPathPrefix();
	}

	public void setException(Exception e) {
		this.message = e.getMessage();
		this.error = e.getStackTraceString();
		this.success = false;
		// this.failure = SH_CommonUtil.log(LoggingLevel.ERROR, this.message, this.error).Id;
		this.failure = LoggingLevel.ERROR;
	}

	public void setSuccess(Boolean isSuccess) {
		this.success = isSuccess;
	}

	public void setMessage(String msg) {
		this.message = msg;
	}

	public class FailureException extends Exception {
	}
}