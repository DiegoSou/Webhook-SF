/** 
 * @author Diego
 * @date 31/06/24
 * 
 * @descritption Factory that makes request models
 * @group Infra 
 */
public without sharing class CalloutRequestFactory implements ICalloutRequestFactory
{
    /** 
     * @description Create new http request from custom metadata type registry,
     * which brings more security and flexibility
     * @param calloutMetadataName The developer name of custom metadata type record used to configure this callout
     * @return HttpRequest with its basic fields (endpoint, method, body). 
     */
    public HttpRequest createFromMetadata(String calloutMetadataName)
    {
        return createFromMetadata(calloutMetadataName, null);   
    }

    /** 
     * @description Create new http request from custom metadata type registry,
     * which brings more security and flexibility
     * @param calloutMetadataName The developer name of custom metadata type record used to configure this callout
     * @param reqBody The request body of callout
     * @return HttpRequest with its basic fields (endpoint, method, body). 
     */
    public HttpRequest createFromMetadata(String calloutMetadataName, Map<String, Object> reqBody)
    {
        CalloutMetadata__mdt calloutMetadata = CalloutMetadata__mdt.getInstance(calloutMetadataName);

        HttpRequest req = new HttpRequest();
        req.setMethod(calloutMetadata.Method__c);
        req.setEndpoint(calloutMetadata.Endpoint__c);
        req.setTimeout(120000);

        if (reqBody != null)
        {
            req.setBody(JSON.serialize(reqBody));
        }

        return req;
    }
}