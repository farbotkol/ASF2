public class ECO_SmartSearchJSON2Apex {
    public String token;
    
    public static ECO_SmartSearchJSON2Apex parse(String json) {
        return (ECO_SmartSearchJSON2Apex) System.JSON.deserialize(json, ECO_SmartSearchJSON2Apex.class);
    }
}