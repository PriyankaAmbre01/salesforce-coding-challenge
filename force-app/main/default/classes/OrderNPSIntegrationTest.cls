//Test class for code coverage and verify the functionality.
@IsTest
public class OrderNPSIntegrationTest {
     @testsetup
    static void setup() {
        Account objAccount = new Account(Name = 'Test Account');
                insert objAccount;
        Contact objContact = new Contact(LastName = 'Test Con', Email = 'test@test.com');
        insert objContact;

        
        Id standardpricebookId = Test.getStandardPricebookId();
        

        //Product2
        List<Product2> lstProduct2 = new List<Product2>();
        Product2 objProd2 = new Product2(
            Name = 'Product X',
            ProductCode = 'Pro-X',
            isActive = true
        );
        lstProduct2.add(objProd2);
        
        Product2 objProd022 = new Product2(
            Name = 'Product 022',
            ProductCode = 'Pro-022',
            isActive = true
        );
        lstProduct2.add(objProd022);
        insert lstProduct2;
        
        //Pricebook2
        List<Pricebook2> lstPricebook2 = new List<Pricebook2>();
        Pricebook2 objPricebook2 = new Pricebook2(Name='testDIE');
        lstPricebook2.add(objPricebook2);
        
        Pricebook2 objPricebook022 = new Pricebook2(Name='test 022');
        lstPricebook2.add(objPricebook022);
        insert lstPricebook2;
        
        //PricebookEntry
        List<PricebookEntry> lstPricebookEntries = new List<PricebookEntry>();
         PricebookEntry objPricebookEntry = new PricebookEntry(
            Pricebook2Id = standardpricebookId,
            Product2Id = objProd2.Id,
            IsActive = true,
            UnitPrice = 100
        );
        lstPricebookEntries.add(objPricebookEntry);
        
         PricebookEntry objPricebookEntry022 = new PricebookEntry(
            Pricebook2Id = standardpricebookId,
            Product2Id = objProd022.Id,
            IsActive = true,
            UnitPrice = 100
        );
        lstPricebookEntries.add(objPricebookEntry022);
        insert lstPricebookEntries;
        
        //Opportunity
        opportunity objOpp = new opportunity(Name='testing 1236' ,  AccountId= objAccount.Id,StageName = 'Prospecting', 
                                           CloseDate = Date.today());
        insert objOpp;
        
      	//Order
        List<Order> lstOrders = new List<Order>();
        Order objOrder = new Order(Name = 'Test Order', 
                                   AccountId = objAccount.Id,
                                   EffectiveDate = Date.today(),
                                   Status = 'Draft',
                                   Opportunity = objOpp,
                                   Pricebook2Id = standardpricebookId,
                                   BillToContactId = objContact.Id);
        lstOrders.add(objOrder);
        Order objOrder02 = new Order(Name = 'Test Order 02', 
                                     AccountId = objAccount.Id,
                                     EffectiveDate = Date.today(),
                                     Status = 'Draft',
                                     Opportunity = objOpp,
                                     Pricebook2Id = standardpricebookId);
        lstOrders.add(objOrder02);
        insert lstOrders;
        
        //OrderItems
        List<OrderItem> lstOrderItems = new List<OrderItem>();
        OrderItem objIem = new OrderItem(OrderId = objOrder.Id,
                                         Product2Id = objProd2.Id,
                                         Quantity = 1,
                                         PricebookEntryId = objPricebookEntry.Id,
                                         UnitPrice = 108
                                        );
        lstOrderItems.add(objIem);
        
        
        
        OrderItem objIem02 = new OrderItem(OrderId = objOrder02.Id,
                                           Product2Id = objProd022.Id,
                                           Quantity = 1,
                                           PricebookEntryId = objPricebookEntry022.Id,
                                           UnitPrice = 108
                                          );
        lstOrderItems.add(objIem02);
        insert lstOrderItems;
    }
    
    //verifies the Success functionality.
    @IsTest
    static void OrderFulfilledtest() {
        Test.setMock(HttpCalloutMock.class, new MockHttpNPSServiceResponse());
        List<Order> lstOrders = [SELECT Id, Status FROM Order WHERE BillToContactId = null];
        lstOrders[0].Status = 'Fulfilled';
        Test.startTest();
        update lstOrders;
        Test.stopTest();

        List<Order> lstOrderResult = [SELECT Id, NPS_Service_Result__c FROM Order WHERE Id =:lstOrders[0].Id];
        System.assertEquals('Success', lstOrderResult[0].NPS_Service_Result__c);
        System.debug('lstOrderResult---'+lstOrderResult);
    }
    
    //verifies the error functionality.
    /* @IsTest
    static void OrderFulfilledFailedtest() {
        Test.setMock(HttpCalloutMock.class, new MockHttpNPSServiceResponse());
        List<Order> lstOrders = [SELECT Id, Status FROM Order WHERE BillToContact.Name = 'Test Con'];
        lstOrders[0].Status = 'Fulfilled';
        Test.startTest();
        update lstOrders;
        Test.stopTest();

        List<Order> lstOrderResult = [SELECT Id, NPS_Service_Result__c FROM Order WHERE Id =:lstOrders[0].Id];
        System.assertEquals('Fail', lstOrderResult[0].NPS_Service_Result__c);
        System.debug('lstOrderResult---'+lstOrderResult);
    }*/
}