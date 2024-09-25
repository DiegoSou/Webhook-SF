/** 
 * @author Diego
 * @date 31/06/24
 * 
 * @descritption Factory contract to making callout request models
 * @group Infra 
 */
public interface ICalloutRequestFactory 
{
    HttpRequest createFromMetadata(String calloutMetadataName);
    HttpRequest createFromMetadata(String calloutMetadataName, Map<String, Object> reqBody);
}