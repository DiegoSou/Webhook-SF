/** 
 * @author Diego
 * @date 30/06/24
 * 
 * @description This class is used to send the information of the accounts to external system.
 * @group External System Client Management
 * 
 * @see CalloutService
 * @see CalloutRequestFactory
 */
public without sharing class ClientAccountERPController 
{
    /** 
     * @description get report of account records from external system
     * @return List<Account> list of accounts returned by report
     * 
     * @example
     * new ClientAccountERPController().getAccountReportFromERP();
     */
    public void getAccountReportFromERP()
    {
        CalloutService.Response res = CalloutService.doCallout(
            CalloutService.requestFactory.createFromMetadata('clientAccountsERPReport')
        );

        System.debug(JSON.serialize(res));
    }

    /** 
     * @description send account record to external system
     * @param accountRecord new triggered account that have the integration flag active
     * @return Map<String, Object> status code and description
     * 
     * @example
     * new ClientAccountERPController().sendAccountToERP(accountRecord);
     */
    public void sendAccountToERP(Account accountRecord)
    {
        CalloutService.Response res = CalloutService.doCallout(sendAccountToERPRequest(accountRecord));
    }

    /** 
     * @description Build the request model necessary in sendAccountToERP
     */
    @TestVisible
    private HttpRequest sendAccountToERPRequest(Account accountRecord)
    {
        Map<String, Object> reqBody = new Map<String, Object>
        {
            'name' => accountRecord.Name,
            'description' => accountRecord.Description,
            'salesforce_id' => accountRecord.Id
        };

        HttpRequest req = CalloutService.requestFactory.createFromMetadata('clientAccountsERPCreate', reqBody);
        req.setHeader('Content-Type', 'application/json');

        return req;
    }
}