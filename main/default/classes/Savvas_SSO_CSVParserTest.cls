@isTest
public class Savvas_SSO_CSVParserTest {
    @isTest
    static void doParseTest1() {
        Blob file = Blob.valueOf('\"value1\",\"value2\"\r\n\"value3\",\"value4\"\r\n');
        List<List<String>> result = Savvas_SSO_CSVParser.doParse(file);
        System.assertEquals(2, result.size());
    }
    
    @isTest
    static void doParseTest2() { 
        Blob file = Blob.valueOf('value1,value2,value3,value4');
        List<List<String>> result = Savvas_SSO_CSVParser.doParse(file);
        System.assertEquals(1, result.size());
    }    
    
    @isTest
    static void testCSVValueEquals() {
        Savvas_SSO_CSVParser.CSVValue value1 = new Savvas_SSO_CSVParser.CSVValue('value', true, Savvas_SSO_CSVParser.ParserCOMMA);
        Savvas_SSO_CSVParser.CSVValue value2 = new Savvas_SSO_CSVParser.CSVValue('value', true, Savvas_SSO_CSVParser.ParserCOMMA);
        value1.assertEquals(value2);
        System.assert(value1.equals(value2));
    }
}