/* Description: This Batch class is responsible for NPS Service callout.  
 */
public class BatchSendOrderData implements Database.batchable<sObject>, Database.Stateful, Database.AllowsCallouts{ 
    public List<Order> lstOrders = new List<Order>();
    public BatchSendOrderData(List<Order> lstOrdertoSend){
        lstOrders.addAll(lstOrdertoSend);
    }
    
    public List<Order> start(Database.BatchableContext info){ 
        return lstOrders; 
    }     
    public void execute(Database.BatchableContext info, List<Order> scope){
        npsOrderCallout(scope);
    }     
    public void finish(Database.BatchableContext info){     
    } 
    
    //Method responsible for sending Order data to NPS service.
    //called through batch, Can be called from future method for less records.
    public static void npsOrderCallout(List<Order> lstOrders){
        List<Id> lstOrderIds = new List<Id>();
        for(Order objOrder :lstOrders){
            lstOrderIds.add(objOrder.Id);
        }
        
        List<Order> lstRetrievedOrders = [SELECT Id, 
                                          OrderNumber,
                                          BillToContactId,
                                          BillToContact.Email 
                                          FROM Order 
                                          WHERE Id IN: lstOrderIds];
        
        List<Map<String, string>> lstOrderMaps = new List<Map<String, string>>();
        for(Order objOrder: lstRetrievedOrders){
            Map<String, string> mapOrder = new Map<String, string>();
            mapOrder.put('sfId', objOrder.Id);
            mapOrder.put('orderNumber', objOrder.OrderNumber);
            if(String.isNotBlank(objOrder.BillToContactId) && String.isNotBlank(objOrder.BillToContact.Email)){
                mapOrder.put('customerEmail', objOrder.BillToContact.Email);
            }
            lstOrderMaps.add(mapOrder);
        }
        Http objhttp = new Http();
        
        HttpRequest objReq = new HttpRequest();
        objReq.setEndpoint('callout:NPS_Callout'+'/orders');
        objReq.setMethod('POST');
        objReq.setBody(JSON.serialize(lstOrderMaps));
        
        
        try {
            HTTPResponse objResponse = objhttp.send(objReq);
            if(objResponse.getStatusCode() == 201 || objResponse.getStatusCode() == 200){
                System.debug('Response Body---'+objResponse.getBody());
                handleResult(lstRetrievedOrders, null , 'Success');   
            }else{
                handleResult(lstRetrievedOrders, objResponse.getBody(), 'Fail');   
            }
        } catch (Exception objExc) {
            handleResult(lstRetrievedOrders, objExc.getMessage(), 'Fail');
        }
    }
    
    //Method responsible for updating Order records with the results.
    public static void handleResult(List<Order> lstOrders, String errorMsg, String result){
        for(Order objOrder: lstOrders){
            objOrder.NPS_Service_Result__c = result;
            objOrder.NPS_Service_Excption__c = errorMsg;
        }
        Database.SaveResult[] srList = Database.update(lstOrders, false);   
    }
}