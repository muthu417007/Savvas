public class coco_myProfileController {

    public pageReference myProfile() {
        pageReference pr = new pageReference('/ui/setup/Setup?setupid=PersonalSetup');
 		pr.setRedirect(true);
        return pr;
    }
}