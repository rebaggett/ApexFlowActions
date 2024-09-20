global class RecordFieldIterator {

    public class RecordFieldIteratorException extends Exception {}

    @InvocableMethod( label='Record Field Iterator'
        description='Iterates over all fields on a record, returning all fields whose value matches the Key Phrase'
        category='Uncategorized')
    public static List<FieldIteratorResponse> execute ( List<FieldIteratorRequest> requests){

        // Initiates a list of responses to send
        List<FieldIteratorResponse> responses = new List<FieldIteratorResponse>();

        // Loops through each record in the request
        for( FieldIteratorRequest request : requests ){

            // Checks for null records and throws and exception if null
            if( request.record == null ){
                throw new RecordFieldIteratorException('Records must not be null');
            }

            // Initiates single response to add to list
            FieldIteratorResponse response = new FieldIteratorResponse();

            // Invokes method converting the input record to a Map< [Field Labels], [Field Values] >
            Map<String, String> values = getLabelsAndValues(request.record);

            // Loops through each row in the <Labels: Values> map and if the value matches the key phrase, adds it to the results list
            for(String fieldLabel : values.keySet()){
                if( values.get(fieldLabel).equals(request.keyPhrase) ){
                    response.result.add(fieldLabel);
                }
            }
            // Adds the response to the list of responses to be returned
            responses.add(response);
        }
        return responses;
    }

    private static Map<String, String> getLabelsAndValues(SObject o){

        // Initiates three maps, the return map, the map of <Field API Names: Values>, and the map of <Field API Name: Field Labels>
        Map<String, String> fieldsMap = new Map<String, String>();
        Map<String, Object> apiMap = o.getPopulatedFieldsAsMap();
        Map<String, Schema.SObjectField> labelToApiMap = Schema.getGlobalDescribe().get( String.valueOf(o.getSObjectType() )).getDescribe().fields.getMap();
        
        // For each item in the API Map, get the field value matching the API name, then get the field label that matches.
        // Afterwards, store both in the fields Map where <Field Label: Field Value>
        for(String fieldApiName : apiMap.keySet()){

            if( fieldApiName <> null && fieldApiName <> '' && apiMap.get(fieldApiName) <> null){
                try{

                    Object fieldValue = apiMap.get(fieldApiName);
                    Schema.DescribeFieldResult fieldDescribe = labelToApiMap.get(fieldApiName).getDescribe();
                    String fieldLabel = fieldDescribe.getLabel();
        
                    fieldsMap.put(fieldLabel, String.valueOf(fieldValue));

                } catch (Exception.NullPointerException e) {
                    System.debug(e);
                }
            }
        }
        return fieldsMap;
    }

    public class FieldIteratorRequest {
        @InvocableVariable(label='Input Record' description='The record through which this class iterates over' required=true)
        public SObject record;

        @InvocableVariable(label='Key Phrase' description='The word or phrase to match against for all fields on the input record' required=true)
        public String keyPhrase;
    }

        
    public class FieldIteratorResponse{
        @InvocableVariable(label='Result' description='List of field names that match the Key Phrase')
        public List<String> result = new List<String>();
    }

}