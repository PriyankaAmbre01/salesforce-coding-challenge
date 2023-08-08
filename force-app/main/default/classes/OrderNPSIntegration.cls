/* Description: This class is responsible fot initiating NPS service callout. 
 */
public without sharing class OrderNPSIntegration {
    
    //Method invoked by flow.
    @InvocableMethod(label='NPS Callout' description='Sends Order data to NPS')
    public static void nPSCallout(List<Order> lstOrders){
        System.debug('lstOrders---'+lstOrders.size());
        Database.executeBatch(new BatchSendOrderData(lstOrders), 30);
    }
}