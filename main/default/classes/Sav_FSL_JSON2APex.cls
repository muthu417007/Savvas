/**
 * ClassName: Sav_FSL_JSON2APex
 *
 * Description: 
 * This class acts as a wrapper to store the JSON response from tooling API
 *
 * Author: CTS team
 * Created Date: 2 FEB 2024
 * Version: v1.0
 * Work no : W-013853
 */

public class Sav_FSL_JSON2APex {

	public Attributes attributes {get;set;} 
	public String Id {get;set;} 
	public String TableEnumOrId {get;set;} 
	public String DeveloperName {get;set;} 
	public String Description {get;set;} 
	public String Length {get;set;} 
	public String Precision {get;set;} 
	public String Scale {get;set;} 
	public String DefaultValue {get;set;} 
	public String RelationshipLabel {get;set;} 
	public String SummaryOperation {get;set;} 
	public String InlineHelpText {get;set;} 
	public String MaskType {get;set;} 
	public String MaskChar {get;set;} 
	public String NamespacePrefix {get;set;} 
	public Metadata Metadata {get;set;} 
	public String FullName {get;set;} 

	public Sav_FSL_JSON2APex(JSONParser parser) {
		while (parser.nextToken() != System.JSONToken.END_OBJECT) {
			if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
				String text = parser.getText();
				if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
					if (text == 'attributes') {
						attributes = new Attributes(parser);
					} else if (text == 'Id') {
						Id = parser.getText();
					} else if (text == 'TableEnumOrId') {
						TableEnumOrId = parser.getText();
					} else if (text == 'DeveloperName') {
						DeveloperName = parser.getText();
					} else if (text == 'Description') {
						Description = parser.getText();
					} else if (text == 'Length') {
						Length = parser.getText();
					} else if (text == 'Precision') {
						Precision = parser.getText();
					} else if (text == 'Scale') {
						Scale = parser.getText();
					} else if (text == 'DefaultValue') {
						DefaultValue = parser.getText();
					} else if (text == 'RelationshipLabel') {
						RelationshipLabel = parser.getText();
					} else if (text == 'SummaryOperation') {
						SummaryOperation = parser.getText();
					} else if (text == 'InlineHelpText') {
						InlineHelpText = parser.getText();
					} else if (text == 'MaskType') {
						MaskType = parser.getText();
					} else if (text == 'MaskChar') {
						MaskChar = parser.getText();
					} else if (text == 'NamespacePrefix') {
						NamespacePrefix = parser.getText();
					} else if (text == 'Metadata') {
						Metadata = new Metadata(parser);
					} else if (text == 'FullName') {
						FullName = parser.getText();
					} else {
						//system,debug(LoggingLevel.WARN, 'Sav_FSL_JSON2APex consuming unrecognized property: '+text);
						consumeObject(parser);
					}
				}
			}
		}
	}
	
	public class Attributes {
		public String type {get;set;} 
		public String url {get;set;} 

		public Attributes(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'type') {
							type = parser.getText();
						} else if (text == 'url') {
							url = parser.getText();
						} else {
							//system,debug(LoggingLevel.WARN, 'Attributes consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Metadata {
		public String caseSensitive {get;set;} 
		public String customDataType {get;set;} 
		public String defaultValue {get;set;} 
		public String deleteConstraint {get;set;} 
		public String deprecated {get;set;} 
		public String description {get;set;} 
		public String displayFormat {get;set;} 
		public String displayLocationInDecimal {get;set;} 
		public String escapeMarkup {get;set;} 
		public String externalDeveloperName {get;set;} 
		public Boolean externalId {get;set;} 
		public String formula {get;set;} 
		public String formulaTreatBlanksAs {get;set;} 
		public String inlineHelpText {get;set;} 
		public String isFilteringDisabled {get;set;} 
		public String isNameField {get;set;} 
		public String isSortingDisabled {get;set;} 
		public String label {get;set;} 
		public String length {get;set;} 
		public String maskChar {get;set;} 
		public String maskType {get;set;} 
		public Picklist picklist {get;set;} 
		public String populateExistingRows {get;set;} 
		public String precision {get;set;} 
		public String readOnlyProxy {get;set;} 
		public String referenceTargetField {get;set;} 
		public String referenceTo {get;set;} 
		public String relationshipLabel {get;set;} 
		public String relationshipName {get;set;} 
		public String relationshipOrder {get;set;} 
		public String reparentableMasterDetail {get;set;} 
		public Boolean required {get;set;} 
		public String restrictedAdminField {get;set;} 
		public String scale {get;set;} 
		public String startingNumber {get;set;} 
		public String stripMarkup {get;set;} 
		public String summarizedField {get;set;} 
		public String summaryFilterItems {get;set;} 
		public String summaryForeignKey {get;set;} 
		public String summaryOperation {get;set;} 
		public String trackFeedHistory {get;set;} 
		public Boolean trackHistory {get;set;} 
		public String type {get;set;} 
		public String unique {get;set;} 
		public String urls {get;set;} 
		public String visibleLines {get;set;} 
		public String writeRequiresMasterRead {get;set;} 

		public Metadata(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'caseSensitive') {
							caseSensitive = parser.getText();
						} else if (text == 'customDataType') {
							customDataType = parser.getText();
						} else if (text == 'defaultValue') {
							defaultValue = parser.getText();
						} else if (text == 'deleteConstraint') {
							deleteConstraint = parser.getText();
						} else if (text == 'deprecated') {
							deprecated = parser.getText();
						} else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'displayFormat') {
							displayFormat = parser.getText();
						} else if (text == 'displayLocationInDecimal') {
							displayLocationInDecimal = parser.getText();
						} else if (text == 'escapeMarkup') {
							escapeMarkup = parser.getText();
						} else if (text == 'externalDeveloperName') {
							externalDeveloperName = parser.getText();
						} else if (text == 'externalId') {
							externalId = parser.getBooleanValue();
						} else if (text == 'formula') {
							formula = parser.getText();
						} else if (text == 'formulaTreatBlanksAs') {
							formulaTreatBlanksAs = parser.getText();
						} else if (text == 'inlineHelpText') {
							inlineHelpText = parser.getText();
						} else if (text == 'isFilteringDisabled') {
							isFilteringDisabled = parser.getText();
						} else if (text == 'isNameField') {
							isNameField = parser.getText();
						} else if (text == 'isSortingDisabled') {
							isSortingDisabled = parser.getText();
						} else if (text == 'label') {
							label = parser.getText();
						} else if (text == 'length') {
							length = parser.getText();
						} else if (text == 'maskChar') {
							maskChar = parser.getText();
						} else if (text == 'maskType') {
							maskType = parser.getText();
						} else if (text == 'picklist') {
							picklist = new Picklist(parser);
						} else if (text == 'populateExistingRows') {
							populateExistingRows = parser.getText();
						} else if (text == 'precision') {
							precision = parser.getText();
						} else if (text == 'readOnlyProxy') {
							readOnlyProxy = parser.getText();
						} else if (text == 'referenceTargetField') {
							referenceTargetField = parser.getText();
						} else if (text == 'referenceTo') {
							referenceTo = parser.getText();
						} else if (text == 'relationshipLabel') {
							relationshipLabel = parser.getText();
						} else if (text == 'relationshipName') {
							relationshipName = parser.getText();
						} else if (text == 'relationshipOrder') {
							relationshipOrder = parser.getText();
						} else if (text == 'reparentableMasterDetail') {
							reparentableMasterDetail = parser.getText();
						} else if (text == 'required') {
							required = parser.getBooleanValue();
						} else if (text == 'restrictedAdminField') {
							restrictedAdminField = parser.getText();
						} else if (text == 'scale') {
							scale = parser.getText();
						} else if (text == 'startingNumber') {
							startingNumber = parser.getText();
						} else if (text == 'stripMarkup') {
							stripMarkup = parser.getText();
						} else if (text == 'summarizedField') {
							summarizedField = parser.getText();
						} else if (text == 'summaryFilterItems') {
							summaryFilterItems = parser.getText();
						} else if (text == 'summaryForeignKey') {
							summaryForeignKey = parser.getText();
						} else if (text == 'summaryOperation') {
							summaryOperation = parser.getText();
						} else if (text == 'trackFeedHistory') {
							trackFeedHistory = parser.getText();
						} else if (text == 'trackHistory') {
							trackHistory = parser.getBooleanValue();
						} else if (text == 'type') {
							type = parser.getText();
						} else if (text == 'unique') {
							unique = parser.getText();
						} else if (text == 'urls') {
							urls = parser.getText();
						} else if (text == 'visibleLines') {
							visibleLines = parser.getText();
						} else if (text == 'writeRequiresMasterRead') {
							writeRequiresMasterRead = parser.getText();
						} else {
							//system,debug(LoggingLevel.WARN, 'Metadata consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class PicklistValues {
		public String allowEmail {get;set;} 
		public String closed {get;set;} 
		public String color {get;set;} 
		public String controllingFieldValues {get;set;} 
		public String converted {get;set;} 
		public String cssExposed {get;set;} 
	//	public Boolean default_Z {get;set;} // in json: default
		public String description {get;set;} 
		public String forecastCategory {get;set;} 
		public String highPriority {get;set;} 
		public String probability {get;set;} 
		public String reverseRole {get;set;} 
		public String reviewed {get;set;} 
		public String urls {get;set;} 
		public String valueName {get;set;} 
		public String won {get;set;} 

		public PicklistValues(String name){
			valueName = name;
			won= null;
            urls= null;
            reviewed= null;
            reverseRole= null;
            probability= null;
            highPriority= null;
            forecastCategory= null;
            description= null;
         //   default_Z= false;
            cssExposed= null;
            converted= null;
            controllingFieldValues= null;
            color= null;
            closed= null;
            allowEmail= null;
		}

		public PicklistValues(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'allowEmail') {
							allowEmail = parser.getText();
						} else if (text == 'closed') {
							closed = parser.getText();
						} else if (text == 'color') {
							color = parser.getText();
						} else if (text == 'controllingFieldValues') {
							controllingFieldValues = parser.getText();
						} else if (text == 'converted') {
							converted = parser.getText();
						} else if (text == 'cssExposed') {
							cssExposed = parser.getText();
						} 
						//else if (text == 'default') {
						//	default_Z = parser.getBooleanValue();} 
							else if (text == 'description') {
							description = parser.getText();
						} else if (text == 'forecastCategory') {
							forecastCategory = parser.getText();
						} else if (text == 'highPriority') {
							highPriority = parser.getText();
						} else if (text == 'probability') {
							probability = parser.getText();
						} else if (text == 'reverseRole') {
							reverseRole = parser.getText();
						} else if (text == 'reviewed') {
							reviewed = parser.getText();
						} else if (text == 'urls') {
							urls = parser.getText();
						} else if (text == 'valueName') {
							valueName = parser.getText();
						} else if (text == 'won') {
							won = parser.getText();
						} else {
							//system,debug(LoggingLevel.WARN, 'PicklistValues consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	public class Picklist {
		public String controllingField {get;set;} 
		public List<PicklistValues> picklistValues {get;set;} 
		public Boolean restrictedPicklist {get;set;} 
		public Boolean sorted {get;set;} 

		public Picklist(JSONParser parser) {
			while (parser.nextToken() != System.JSONToken.END_OBJECT) {
				if (parser.getCurrentToken() == System.JSONToken.FIELD_NAME) {
					String text = parser.getText();
					if (parser.nextToken() != System.JSONToken.VALUE_NULL) {
						if (text == 'controllingField') {
							controllingField = parser.getText();
						} else if (text == 'picklistValues') {
							picklistValues = arrayOfPicklistValues(parser);
						} else if (text == 'restrictedPicklist') {
							restrictedPicklist = parser.getBooleanValue();
						} else if (text == 'sorted') {
							sorted = parser.getBooleanValue();
						} else {
							//system,debug(LoggingLevel.WARN, 'Picklist consuming unrecognized property: '+text);
							consumeObject(parser);
						}
					}
				}
			}
		}
	}
	
	
	public static Sav_FSL_JSON2APex parse(String json) {
		System.JSONParser parser = System.JSON.createParser(json);
		return new Sav_FSL_JSON2APex(parser);
	}
	
	public static void consumeObject(System.JSONParser parser) {
		Integer depth = 0;
		do {
			System.JSONToken curr = parser.getCurrentToken();
			if (curr == System.JSONToken.START_OBJECT || 
				curr == System.JSONToken.START_ARRAY) {
				depth++;
			} else if (curr == System.JSONToken.END_OBJECT ||
				curr == System.JSONToken.END_ARRAY) {
				depth--;
			}
		} while (depth > 0 && parser.nextToken() != null);
	}
	
    private static List<PicklistValues> arrayOfPicklistValues(System.JSONParser p) {
        List<PicklistValues> res = new List<PicklistValues>();
        if (p.getCurrentToken() == null) p.nextToken();
        while (p.nextToken() != System.JSONToken.END_ARRAY) {
            res.add(new PicklistValues(p));
        }
        return res;
    }

}