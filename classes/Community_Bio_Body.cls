/****
@Description: Controller Class to pull Bio from Static resources for concerned Person
@Implemented as a part of Community Pages Build for Savvas Central Community
@Author: Prabhat Kanuri (Cognizant)
****/

public class Community_Bio_Body {
@auraEnabled
public static String getBioBody(String staticResourceName) {
  return [SELECT Body FROM StaticResource  WHERE  Name = :staticResourceName].body.toString();
}
}