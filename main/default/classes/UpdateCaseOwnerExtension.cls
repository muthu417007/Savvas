public class UpdateCaseOwnerExtension {
    public Case theCase {
        get;
        set;
    }
    private ApexPages.StandardController controller;
    private Case origCase;
    public boolean sendEmail {
        get;
        set;
    }
    public boolean isOwnerModified {
        get {
            return (origCase.OwnerId != theCase.OwnerId);
        }
        set;
    }

    public UpdateCaseOwnerExtension(ApexPages.StandardController controller) {
        this.controller = controller;
        theCase = (Case) controller.getRecord();
        origCase = theCase.clone(true, false, false);
    }

    public PageReference updateCaseOwner() {
        if (isOwnerModified) {
            Database.DMLOptions dmo = new Database.DMLOptions(); 
            if (sendEmail) {
                dmo.emailHeader.triggerUserEmail = true;
            } else {
                dmo.emailHeader.triggerUserEmail = false;
            }
            Database.update(theCase, dmo);
            if(!test.isRunningTest()){
                controller.reset();
            }
            theCase = (Case)controller.getRecord();
            origCase = theCase.clone(true, false, false);
        }
        return null;
    }
}