//
//  NonNetworkedParseDotComCommunicator.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/4/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "NonNetworkedParseDotComCommunicator.h"
#import "AsyncSenTestCase.h"
#import "AFHTTPRequestOperation.h"
#import "OHHTTPStubs.h"

@implementation NonNetworkedParseDotComCommunicator


//-(void)test_AFHTTPRequestOperation
//{
//    static const NSTimeInterval kResponseTime = 1.0;
//    NSData* expectedResponse = [NSStringFromSelector(_cmd) dataUsingEncoding:NSUTF8StringEncoding];
//    [OHHTTPStubs shouldStubRequestsPassingTest:^BOOL(NSURLRequest *request) {
//        return YES;
//    } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
//        return [OHHTTPStubsResponse responseWithData:expectedResponse statusCode:200 responseTime:kResponseTime headers:nil];
//    }];
//    
//    NSURLRequest* req = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.iana.org/domains/example/"]];
//    AFHTTPRequestOperation* op = [[[AFHTTPRequestOperation alloc] initWithRequest:req] autorelease];
//    __block id response = nil;
//    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        response = [[responseObject retain] autorelease];
//        [self notifyAsyncOperationDone];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        STFail(@"Unexpected network failure");
//        [self notifyAsyncOperationDone];
//    }];
//    [op start];
//    
//    [self waitForAsyncOperationWithTimeout:kResponseTime+0.5];
//    
//    STAssertEqualObjects(response, expectedResponse, @"Unexpected data received");
//}
//
//- (void)setReceivedData:(NSData *)data {
//    _data = [data mutableCopy];
//}
//
//- (NSData *)receivedData {
//    return [_data copy];
//}
//
//-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
//{
//    [_data setLength:0U];
//}
//
//-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
//{
//    [_data appendData:data];
//}
//
//-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
//{
//    _error = [error retain];
//    [self notifyAsyncOperationDone];
//}
//
//-(void)connectionDidFinishLoading:(NSURLConnection *)connection
//{
//    [self notifyAsyncOperationDone];
//}
//
@end
