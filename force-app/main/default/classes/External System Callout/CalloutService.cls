/** 
 * @author Diego
 * @date 31/06/24
 * 
 * @descritption Infrastructure service to standardize callouts to external systems
 * @group Infra 
 * 
 * @see ICalloutRequestFactory
 */
@SuppressWarnings('PMD')
public without sharing virtual class CalloutService 
{
    /** 
     * @description Private empty constructor. For construction purposes, use "doCallout"
     */
    private CalloutService() {}

    /** 
     * @description Makes the callout
     */
    public static Response doCallout(HttpRequest req)
    {
        Response resp;

        try
        {
            HttpResponse res = new Http().send(req);
            Map<String, Object> resBody = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            
            resp = new Response(res.getStatusCode(), resBody, '');
        } 
        catch (Exception e)
        {
            resp = new Response(500, null, e.getMessage() + '|' + e.getStackTraceString());
        }
        finally
        {
            insert new CalloutResponseLog__c(
                RequestBody__c=getString(req),
                StatusCode__c=resp.statusCode,
                Description__c=(resp.body != null ? JSON.serialize(resp.body) : ''),
                Error__c=resp.error
            );
        }

        return resp;
    }

    /** 
     * @description Formats System.HttpRequest in a string describe version
     */
    @TestVisible
    private static String getString(HttpRequest req)
    {
        return (''
            +'Endpoint: '+req.getEndpoint()+'\n'
            +'Method: '+req.getMethod()+'\n'
            +'Body: '+req.getBody()+'\n'
        );
    }

    /** 
     * @description Data model of the response from callouts
     */
    public class Response
    {
        public Integer statusCode {get;set;}
        public Map<String, Object> body {get;set;}
        public String error {get;set;}

        public Response(Integer statusCode, Map<String, Object> body, String error)
        {
            this.statusCode = statusCode;
            this.body = body;
            this.error = error;
        }
    }

    /** 
     * @description Interface of factory used to construct requests
     */
    public static ICalloutRequestFactory requestFactory 
    {
        get
        {
            if (requestFactory == null) { requestFactory = new CalloutRequestFactory(); }
            return requestFactory;
        }
        set;
    }
}