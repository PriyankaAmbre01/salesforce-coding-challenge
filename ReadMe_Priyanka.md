Components:
Flow: 
    *Send Data to NPS On Order status changed to Fulfilled

Apex Classes:
    *OrderNPSIntegration
    *OrderNPSIntegrationTest
    *MockHttpNPSServiceResponse
    *BatchSendOrderData


Named Credentials:
    *NPS Callout

Custom Fields on Order object:
    *NPS Service Excption
    *NPS Service Result

NOTES:
    *OrderNPSIntegration: Apex class is created for Invocable method.
    *Batch class is executed from OrderNPSIntegration class.
    *Batch class is created for following:
    1.callout 
    2.Avoiding governor Limits like  CPU time, limit of callout exceptions in one transaction.
    3.To process records in chunks like in 30 records, as per the api.
    *To avoid dusplicate emails to customers, 'NPS Service Result' field is created so that once executed it should not trigger again.


    *limitations/possible problems:
    1. For one Order also record batch is triggered, which can be avoided by calling the callout method from a future method.
    2. If any error occurs in the integration, Admins have to check the errors on record. As it is executed asynchronously.
   

