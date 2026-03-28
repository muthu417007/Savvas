@isTest(SeeAllData=true)
public class TestRedirectWithVariablesController {
    static testMethod void myUnitTest() {
        RedirectWithVariablesController controller = new RedirectWithVariablesController();
        ApexPages.currentPage().getParameters().put('object', 'Opportunity');
        ApexPages.currentPage().getParameters().put('allowRTS','true');
        PageReference pageRef = controller.redirectUser();
    }
}