//mock Test class to send Success and fail msgs.
@isTest
public class MockHttpNPSServiceResponse implements HttpCalloutMock { 
    public HTTPResponse respond(HTTPRequest req) {
        HttpResponse res = new HttpResponse();

        if(req.getBody().contains('test')){
            //Fail Response
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"Error":"BAD_PAYLOAD"}');
            res.setStatusCode(500);
        }else{
            //SuccessResponse
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"SUCCESS":"SUCCESS"}');
            res.setStatusCode(200);
        }
        return res;
    }
}