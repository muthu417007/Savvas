/*
Apex Class:scc_csvDownloaderTest
Author: CTS (Sanika)
Created Date: 2024-08-29
Reason:
Modified Date: 2024-10-18
*/
@isTest
public class scc_csvDownloaderTest {
    
    /**
     * Description: Tests the basic functionality of generateCSVContent method with multiple records
     * @param: none
     * @return: void
     */
    @isTest
    static void testGenerateCSVContent() {
        // Prepare test data
        List<Map<String, Object>> records = new List<Map<String, Object>>();
        Map<String, Object> record1 = new Map<String, Object>{
            'Name' => 'John Doe',
            'Email' => 'john@example.com',
            'Phone' => '1234567890'
        };
        Map<String, Object> record2 = new Map<String, Object>{
            'Name' => 'Jane Smith',
            'Email' => 'jane@example.com',
            'Phone' => '0987654321'
        };
        records.add(record1);
        records.add(record2);
        
        List<Map<String, Object>> columns = new List<Map<String, Object>>();
        columns.add(new Map<String, Object>{'label' => 'Name', 'fieldName' => 'Name'});
        columns.add(new Map<String, Object>{'label' => 'Email', 'fieldName' => 'Email'});
        columns.add(new Map<String, Object>{'label' => 'Phone', 'fieldName' => 'Phone'});
        
        // Call the method
        Test.startTest();
        String base64Content = scc_csvDownloader.generateCSVContent(records, columns);
        Test.stopTest();
        
        // Decode the base64 content
        String csvContent = EncodingUtil.base64Decode(base64Content).toString();
        
        // Assert the results
        System.assert(csvContent.startsWith('"Name","Email","Phone"'), 'CSV should start with the correct headers');
        System.assert(csvContent.contains('"John Doe","john@example.com","1234567890"'), 'CSV should contain the first record');
        System.assert(csvContent.contains('"Jane Smith","jane@example.com","0987654321"'), 'CSV should contain the second record');
    }
    
    /**
     * Description: Tests the generateCSVContent method's handling of null values
     * @param: none
     * @return: void
     */
    @isTest
    static void testGenerateCSVContentWithNullValues() {
        List<Map<String, Object>> records = new List<Map<String, Object>>();
        Map<String, Object> record = new Map<String, Object>{
            'Name' => 'Test User',
            'Email' => null,
            'Phone' => '1234567890'
        };
        records.add(record);
        
        List<Map<String, Object>> columns = new List<Map<String, Object>>();
        columns.add(new Map<String, Object>{'label' => 'Name', 'fieldName' => 'Name'});
        columns.add(new Map<String, Object>{'label' => 'Email', 'fieldName' => 'Email'});
        columns.add(new Map<String, Object>{'label' => 'Phone', 'fieldName' => 'Phone'});
        
        Test.startTest();
        String base64Content = scc_csvDownloader.generateCSVContent(records, columns);
        Test.stopTest();
        
        String csvContent = EncodingUtil.base64Decode(base64Content).toString();
        System.assert(csvContent.contains('"Test User","","1234567890"'), 'CSV should handle null values correctly');
    }
    
    /**
     * Description: Tests the generateCSVContent method's handling of quotes within data
     * @param: none
     * @return: void
     */
    @isTest
    static void testGenerateCSVContentWithQuotesInData() {
        List<Map<String, Object>> records = new List<Map<String, Object>>();
        Map<String, Object> record = new Map<String, Object>{
            'Name' => 'John "Nickname" Doe',
            'Description' => 'This is a "quoted" description'
        };
        records.add(record);
        
        List<Map<String, Object>> columns = new List<Map<String, Object>>();
        columns.add(new Map<String, Object>{'label' => 'Name', 'fieldName' => 'Name'});
        columns.add(new Map<String, Object>{'label' => 'Description', 'fieldName' => 'Description'});
        
        Test.startTest();
        String base64Content = scc_csvDownloader.generateCSVContent(records, columns);
        Test.stopTest();
        
        String csvContent = EncodingUtil.base64Decode(base64Content).toString();
        System.assert(csvContent.contains('"John ""Nickname"" Doe"'), 'CSV should properly escape quotes in data');
        System.assert(csvContent.contains('"This is a ""quoted"" description"'), 'CSV should properly escape quotes in data');
    }
    
    /**
     * Description: Tests the generateCSVContent method's behavior when no data is provided
     * @param: none
     * @return: void
     */
    @isTest
    static void testGenerateCSVContentWithNoData() {
        List<Map<String, Object>> records = new List<Map<String, Object>>();
        List<Map<String, Object>> columns = new List<Map<String, Object>>();
        columns.add(new Map<String, Object>{'label' => 'Name', 'fieldName' => 'Name'});
        
        Test.startTest();
        String base64Content = scc_csvDownloader.generateCSVContent(records, columns);
        Test.stopTest();
        
        String csvContent = EncodingUtil.base64Decode(base64Content).toString();
        System.assert(csvContent.equals('"Name"\n'), 'CSV should only contain headers when no data is provided');
    }
}