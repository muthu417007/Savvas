/**
 * ClassName: Sav_FSL_JSON2APex_Test
 *
 * Description: Test class to cover Sav_FSL_JSON2APex class.
 *
 * Methods:
 * testParse() : Returns void but creates test data to test cover the required class
 * 
 * Author: CTS team
 * Created Date: 2 FEB 2024
 * Version: v1.0
 * Work no : W-013853
 */

@IsTest
public class Sav_FSL_JSON2APex_Test {
	
	// This test method should give 100% coverage
	static testMethod void testParse() {
		String json = '{'+
		'  \"attributes\" : {'+
		'    \"type\" : \"CustomField\",'+
		'    \"url\" : \"/services/data/v28.0/tooling/sobjects/CustomField/00N5300000RXcCREA1\"'+
		'  },'+
		'  \"Id\" : \"00N5300000RXcCREA1\",'+
		'  \"TableEnumOrId\" : \"ServiceResource\",'+
		'  \"DeveloperName\" : \"Sav_FSL_Manager\",'+
		'  \"Description\" : \"test\",'+
		'  \"Length\" : \"test\",'+
		'  \"Precision\" : \"test\",'+
		'  \"Scale\" : \"test\",'+
		'  \"DefaultValue\" : \"test\",'+
		'  \"RelationshipLabel\" : \"test\",'+
		'  \"SummaryOperation\" : \"test\",'+
		'  \"InlineHelpText\" : \"test\",'+
		'  \"MaskType\" : \"test\",'+
		'  \"MaskChar\" : \"test\",'+
		'  \"NamespacePrefix\" : \"test\",'+
		'  \"Metadata\" : {'+
		'    \"caseSensitive\" : \"test\",'+
		'    \"customDataType\" : \"test\",'+
		'    \"defaultValue\" : \"test\",'+
		'    \"deleteConstraint\" : \"test\",'+
		'    \"deprecated\" : \"test\",'+
		'    \"description\" : \"test\",'+
		'    \"displayFormat\" : \"test\",'+
		'    \"displayLocationInDecimal\" : \"test\",'+
		'    \"escapeMarkup\" : \"test\",'+
		'    \"externalDeveloperName\" : \"test\",'+
		'    \"externalId\" : false,'+
		'    \"formula\" : \"test\",'+
		'    \"formulaTreatBlanksAs\" : \"test\",'+
		'    \"inlineHelpText\" : \"test\",'+
		'    \"isFilteringDisabled\" : \"test\",'+
		'    \"isNameField\" : \"test\",'+
		'    \"isSortingDisabled\" : \"test\",'+
		'    \"label\" : \"Manager\",'+
		'    \"length\" : \"test\",'+
		'    \"maskChar\" : \"test\",'+
		'    \"maskType\" : \"test\",'+
		'    \"picklist\" : {'+
		'      \"controllingField\" : \"test\",'+
		'      \"picklistValues\" : [ {'+
		'        \"allowEmail\" : \"test\",'+
		'        \"closed\" : \"test\",'+
		'        \"color\" : \"test\",'+
		'        \"controllingFieldValues\" : \"test\",'+
		'        \"converted\" : \"test\",'+
		'        \"cssExposed\" : \"test\",'+
		'        \"default\" : false,'+
		'        \"description\" : \"test\",'+
		'        \"forecastCategory\" : \"test\",'+
		'        \"highPriority\" : \"test\",'+
		'        \"probability\" : \"test\",'+
		'        \"reverseRole\" : \"test\",'+
		'        \"reviewed\" : \"test\",'+
		'        \"urls\" : \"test\",'+
		'        \"valueName\" : \"Allison Zimpfer\",'+
		'        \"won\" : null'+
		'      }, {'+
		'        \"allowEmail\" : \"test\",'+
		'        \"closed\" : \"test\",'+
		'        \"color\" : \"test\",'+
		'        \"controllingFieldValues\" : \"test\",'+
		'        \"converted\" : \"test\",'+
		'        \"cssExposed\" : \"test\",'+
		'        \"default\" : false,'+
		'        \"description\" : \"test\",'+
		'        \"forecastCategory\" : \"test\",'+
		'        \"highPriority\" : \"test\",'+
		'        \"probability\" : \"test\",'+
		'        \"reverseRole\" : \"test\",'+
		'        \"reviewed\" : \"test\",'+
		'        \"urls\" : \"test\",'+
		'        \"valueName\" : \"Amber J Kasic\",'+
		'        \"won\" : null'+
		'      } ],'+
		'      \"restrictedPicklist\" : true,'+
		'      \"sorted\" : false'+
		'    },'+
		'    \"populateExistingRows\" : \"test\",'+
		'    \"precision\" : \"test\",'+
		'    \"readOnlyProxy\" : \"test\",'+
		'    \"referenceTargetField\" : \"test\",'+
		'    \"referenceTo\" : \"test\",'+
		'    \"relationshipLabel\" : \"test\",'+
		'    \"relationshipName\" : \"test\",'+
		'    \"relationshipOrder\" : \"test\",'+
		'    \"reparentableMasterDetail\" : \"test\",'+
		'    \"required\" : false,'+
		'    \"restrictedAdminField\" : \"test\",'+
		'    \"scale\" : \"test\",'+
		'    \"startingNumber\" : \"test\",'+
		'    \"stripMarkup\" : \"test\",'+
		'    \"summarizedField\" : \"test\",'+
		'    \"summaryFilterItems\" : \"test\",'+
		'    \"summaryForeignKey\" : \"test\",'+
		'    \"summaryOperation\" : \"test\",'+
		'    \"trackFeedHistory\" : \"test\",'+
		'    \"trackHistory\" : false,'+
		'    \"type\" : \"Picklist\",'+
		'    \"unique\" : \"test\",'+
		'    \"urls\" : \"test\",'+
		'    \"visibleLines\" : \"test\",'+
		'    \"writeRequiresMasterRead\" : null'+
		'  },'+
		'  \"FullName\" : \"ServiceResource.Sav_FSL_Manager__c\"'+
		'}';
		Sav_FSL_JSON2Apex r = Sav_FSL_JSON2Apex.parse(json);
		System.assert(r != null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Sav_FSL_JSON2Apex objJSON2Apex = new Sav_FSL_JSON2Apex(System.JSON.createParser(json));
		System.assert(objJSON2Apex != null);
		System.assert(objJSON2Apex.attributes == null);
		System.assert(objJSON2Apex.Id == null);
		System.assert(objJSON2Apex.TableEnumOrId == null);
		System.assert(objJSON2Apex.DeveloperName == null);
		System.assert(objJSON2Apex.Description == null);
		System.assert(objJSON2Apex.Length == null);
		System.assert(objJSON2Apex.Precision == null);
		System.assert(objJSON2Apex.Scale == null);
		System.assert(objJSON2Apex.DefaultValue == null);
		System.assert(objJSON2Apex.RelationshipLabel == null);
		System.assert(objJSON2Apex.SummaryOperation == null);
		System.assert(objJSON2Apex.InlineHelpText == null);
		System.assert(objJSON2Apex.MaskType == null);
		System.assert(objJSON2Apex.MaskChar == null);
		System.assert(objJSON2Apex.NamespacePrefix == null);
		System.assert(objJSON2Apex.Metadata == null);
		System.assert(objJSON2Apex.FullName == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Sav_FSL_JSON2Apex.Attributes objAttributes = new Sav_FSL_JSON2Apex.Attributes(System.JSON.createParser(json));
		System.assert(objAttributes != null);
		System.assert(objAttributes.type == null);
		System.assert(objAttributes.url == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Sav_FSL_JSON2Apex.Metadata objMetadata = new Sav_FSL_JSON2Apex.Metadata(System.JSON.createParser(json));
		System.assert(objMetadata != null);
		System.assert(objMetadata.caseSensitive == null);
		System.assert(objMetadata.customDataType == null);
		System.assert(objMetadata.defaultValue == null);
		System.assert(objMetadata.deleteConstraint == null);
		System.assert(objMetadata.deprecated == null);
		System.assert(objMetadata.description == null);
		System.assert(objMetadata.displayFormat == null);
		System.assert(objMetadata.displayLocationInDecimal == null);
		System.assert(objMetadata.escapeMarkup == null);
		System.assert(objMetadata.externalDeveloperName == null);
		System.assert(objMetadata.externalId == null);
		System.assert(objMetadata.formula == null);
		System.assert(objMetadata.formulaTreatBlanksAs == null);
		System.assert(objMetadata.inlineHelpText == null);
		System.assert(objMetadata.isFilteringDisabled == null);
		System.assert(objMetadata.isNameField == null);
		System.assert(objMetadata.isSortingDisabled == null);
		System.assert(objMetadata.label == null);
		System.assert(objMetadata.length == null);
		System.assert(objMetadata.maskChar == null);
		System.assert(objMetadata.maskType == null);
		System.assert(objMetadata.picklist == null);
		System.assert(objMetadata.populateExistingRows == null);
		System.assert(objMetadata.precision == null);
		System.assert(objMetadata.readOnlyProxy == null);
		System.assert(objMetadata.referenceTargetField == null);
		System.assert(objMetadata.referenceTo == null);
		System.assert(objMetadata.relationshipLabel == null);
		System.assert(objMetadata.relationshipName == null);
		System.assert(objMetadata.relationshipOrder == null);
		System.assert(objMetadata.reparentableMasterDetail == null);
		System.assert(objMetadata.required == null);
		System.assert(objMetadata.restrictedAdminField == null);
		System.assert(objMetadata.scale == null);
		System.assert(objMetadata.startingNumber == null);
		System.assert(objMetadata.stripMarkup == null);
		System.assert(objMetadata.summarizedField == null);
		System.assert(objMetadata.summaryFilterItems == null);
		System.assert(objMetadata.summaryForeignKey == null);
		System.assert(objMetadata.summaryOperation == null);
		System.assert(objMetadata.trackFeedHistory == null);
		System.assert(objMetadata.trackHistory == null);
		System.assert(objMetadata.type == null);
		System.assert(objMetadata.unique == null);
		System.assert(objMetadata.urls == null);
		System.assert(objMetadata.visibleLines == null);
		System.assert(objMetadata.writeRequiresMasterRead == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Sav_FSL_JSON2Apex.PicklistValues objPicklistValues = new Sav_FSL_JSON2Apex.PicklistValues(System.JSON.createParser(json));
		System.assert(objPicklistValues != null);
		System.assert(objPicklistValues.allowEmail == null);
		System.assert(objPicklistValues.closed == null);
		System.assert(objPicklistValues.color == null);
		System.assert(objPicklistValues.controllingFieldValues == null);
		System.assert(objPicklistValues.converted == null);
		System.assert(objPicklistValues.cssExposed == null);
		//System.assert(objPicklistValues.default_Z == null);
		System.assert(objPicklistValues.description == null);
		System.assert(objPicklistValues.forecastCategory == null);
		System.assert(objPicklistValues.highPriority == null);
		System.assert(objPicklistValues.probability == null);
		System.assert(objPicklistValues.reverseRole == null);
		System.assert(objPicklistValues.reviewed == null);
		System.assert(objPicklistValues.urls == null);
		System.assert(objPicklistValues.valueName == null);
		System.assert(objPicklistValues.won == null);

		json = '{\"TestAMissingObject\": { \"TestAMissingArray\": [ { \"TestAMissingProperty\": \"Some Value\" } ] } }';
		Sav_FSL_JSON2Apex.Picklist objPicklist = new Sav_FSL_JSON2Apex.Picklist(System.JSON.createParser(json));
		System.assert(objPicklist != null);
		System.assert(objPicklist.controllingField == null);
		System.assert(objPicklist.picklistValues == null);
		System.assert(objPicklist.restrictedPicklist == null);
		System.assert(objPicklist.sorted == null);

		Sav_FSL_JSON2APex.PicklistValues pickListNew = new Sav_FSL_JSON2APex.PicklistValues('TestData');
		System.assert(pickListNew.valueName == 'TestData');
	}
}