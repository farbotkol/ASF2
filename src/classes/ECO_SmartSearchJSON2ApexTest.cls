@isTest
public class ECO_SmartSearchJSON2ApexTest {
	static testMethod void testParse() {
		String json = '{\"token\" : \"eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjE0MzM1MzMxODYsImlhdCI6MTQzMzQ0Njc4NiwidXNlcklkcyI6W3sicHJvdmlkZXIiOiJFbWFpbCBTZWN1cml0eSBQcm92aWRlciIsIm5hbWUiOiJzc2l2YWRhc2FuQGNlbnRlcnN0YW5jZS5jb20iLCJ0eXBlIjoiVXNlciJ9XX0.YRDcz028uIKXUTQXjyzZXSNa5tggLUChl83ibEpOwHQ\"}';
		ECO_SmartSearchJSON2Apex obj = ECO_SmartSearchJSON2Apex.parse(json);
		System.assert(obj != null);        
    }
}