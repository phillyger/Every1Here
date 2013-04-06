//
//  AFNParseDotComCommunicatorTests.m
//  Anseo
//
//  Created by Ger O'Sullivan on 2/5/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "AFNParseDotComCommunicatorTests.h"
#import "InspectableParseDotComCommunicator.h"
#import "NonNetworkedParseDotComCommunicator.h"
#import "AFParseDotComAPIClient.h"
#import "FakeURLResponse.h"
#import "MockParseDotComManager.h"
#import "OCMock.h"
#import "MemberBuilder.h"
#import "EventBuilder.h"
#import "TestSemaphor.h"
#import "User.h"
#import "Event.h"


@implementation AFNParseDotComCommunicatorTests
{
    // 1
    NSArray *_members;
    NSArray *_events;
    NSDictionary *_pastEventJson;
    NSDictionary *_membersJson;
    NSString *_jsonStringPastEvents;
    NSString *_jsonStringMembers;
    MemberBuilder *memberBuilder;
    EventBuilder *eventBuilder;
    
    InspectableParseDotComCommunicator *communicator;
    NonNetworkedParseDotComCommunicator *nnCommunicator;
    MockParseDotComManager *manager;
    FakeURLResponse *fourOhFourResponse;
    NSData *receivedData;
    NSMutableString *baseURLString;
    


}

-(void)setUp {

    
    
    communicator = [[InspectableParseDotComCommunicator alloc] init];
    nnCommunicator = [[NonNetworkedParseDotComCommunicator alloc] init];
    manager = [[MockParseDotComManager alloc] init];
    //nnCommunicator.delegate = manager;
    fourOhFourResponse = [[FakeURLResponse alloc] initWithStatusCode: 404];
    receivedData = [@"Result" dataUsingEncoding: NSUTF8StringEncoding];
    baseURLString = (NSMutableString *)[[[AFParseDotComAPIClient sharedClient] baseURL] absoluteString];
    
    
    
     memberBuilder = [[MemberBuilder alloc] init];
     eventBuilder = [[EventBuilder alloc] init];
    
    NSURL *dataServiceURLEvent = [[NSBundle bundleForClass:self.class] URLForResource:@"parseDotComEvents" withExtension:@"json"];
    NSData *sampleDataEvent = [NSData dataWithContentsOfURL:dataServiceURLEvent];
    
    NSURL *dataServiceURLMembers = [[NSBundle bundleForClass:self.class] URLForResource:@"parseDotComMembers" withExtension:@"json"];
    NSData *sampleDataMembers = [NSData dataWithContentsOfURL:dataServiceURLMembers];
    
    _jsonStringPastEvents = [[NSString alloc] initWithData:sampleDataEvent encoding:NSUTF8StringEncoding];
    _jsonStringMembers = [[NSString alloc] initWithData:sampleDataMembers encoding:NSUTF8StringEncoding];
    
    NSError *error;

    id jsonEvent = [NSJSONSerialization JSONObjectWithData:sampleDataEvent options:kNilOptions
                                                error:&error];
    
    id jsonMembers = [NSJSONSerialization JSONObjectWithData:sampleDataMembers options:kNilOptions
                                                     error:&error];
    
    
    STAssertNotNil(jsonEvent, @"invalid test data");
    STAssertNotNil(jsonMembers, @"invalid test data");

    _pastEventJson = jsonEvent;
    _membersJson = jsonMembers;
}

-(void)tearDown {
    _pastEventJson = nil;
    _membersJson = nil;
    _jsonStringPastEvents = nil;
    _jsonStringMembers = nil;
    eventBuilder = nil;
    memberBuilder = nil;
    
}


- (void)testCreatingMemberDataFromParseDotComCommunicator {
    // 1
    id mockParseDotComCommunicator = [OCMockObject mockForClass:[ParseDotComCommunicator class]];
    //
    // using OCMock to mock our WowApiClient object
    //
    // 2
    [[[mockParseDotComCommunicator stub] andDo:^(NSInvocation *invocation) {
        // how the success block is defined from our client
        // this is how we return data to caller from stubbed method
        // 3
        void (^successBlock)(NSDictionary *objectNotation);
        //
        // gets the success block from the call to our stub method
        // The hidden arguments self (of type id) and _cmd (of type SEL) are at indices 0 and 1;
        // method-specific arguments begin at index 2.
        // 4
        [invocation getArgument:&successBlock atIndex:4];
        // first create sample guild from file vs network call
        // 5
        NSDictionary *testData = _membersJson;
        
        // 6
        successBlock(testData); }]
     // 7
     // the actual method we are stubb'ing, accepting any args
     downloadMembersForGroupName:[OCMArg any] errorHandler:[OCMArg any] successHandler:[OCMArg any]];
    // String used to wait for block to complete
    // 8
    NSString *semaphoreKey = @"membersLoaded";
    
    // now call the stubbed out client, by calling the real method //
    [mockParseDotComCommunicator downloadMembersForGroupName:@"Panorama Toastmasters"
                                                   errorHandler:^(NSError *error) {
                                                       [[TestSemaphor sharedInstance] lift:semaphoreKey];
                                                   }
                                                 successHandler:^(NSDictionary *objectNotation) {
                                                     
                                                     // this will allow the test to continue by lifting the semaphore key
                                                     // and satisfying the running loop that is waiting on it to lift
                                                    
                                                     _members = [memberBuilder membersFromJSON:objectNotation error:nil];
                                                     
                                                     
                                                     [[TestSemaphor sharedInstance] lift:semaphoreKey];
                                                 } ];



    [[TestSemaphor sharedInstance] waitForKey:semaphoreKey];
    

    
    
    STAssertNotNil(_members, @"");
    STAssertTrue([_members count] == [[_membersJson valueForKey:@"results"] count], nil);
    STAssertEqualObjects(((User *)_members[0]).firstName, @"Ibn", nil);
    STAssertEqualObjects(((User *)_members[0]).lastName, @"Abdul Khaaliq", nil);
    
    //
}

- (void)testCreatingEventDataFromParseDotComCommunicator {
    // 1
    id mockParseDotComCommunicator = [OCMockObject mockForClass:[ParseDotComCommunicator class]];
    //
    // using OCMock to mock our WowApiClient object
    //
    // 2
    [[[mockParseDotComCommunicator stub] andDo:^(NSInvocation *invocation) {
        // how the success block is defined from our client
        // this is how we return data to caller from stubbed method
        // 3
        void (^successBlock)(NSDictionary *objectNotation);
        //
        // gets the success block from the call to our stub method
        // The hidden arguments self (of type id) and _cmd (of type SEL) are at indices 0 and 1;
        // method-specific arguments begin at index 2.
        // 4
        [invocation getArgument:&successBlock atIndex:4];
        // first create sample guild from file vs network call
        // 5
        NSDictionary *testData = _pastEventJson;
        
        // 6
        successBlock(testData); }]
     // 7
     // the actual method we are stubb'ing, accepting any args
     downloadPastEventsForGroupName:[OCMArg any] errorHandler:[OCMArg any] successHandler:[OCMArg any]];
    // String used to wait for block to complete
    // 8
    NSString *semaphoreKey = @"eventsLoaded";
    
    // now call the stubbed out client, by calling the real method //
    

    [mockParseDotComCommunicator downloadPastEventsForGroupName:@"Panorama Toastmasters"
                                                 errorHandler:^(NSError *error) {
                                                     [[TestSemaphor sharedInstance] lift:semaphoreKey];
                                                 }
                                               successHandler:^(NSDictionary *objectNotation) {
                                                   
                                                   // this will allow the test to continue by lifting the semaphore key
                                                   // and satisfying the running loop that is waiting on it to lift
                                                  
                                                   _events = [eventBuilder eventsFromJSON:objectNotation error:nil];
                                                   
                                                   [[TestSemaphor sharedInstance] lift:semaphoreKey];
                                               } ];
    
    [[TestSemaphor sharedInstance] waitForKey:semaphoreKey];

    STAssertNotNil(_events, @"");
    STAssertTrue([_events count] == [[_pastEventJson valueForKey:@"results"] count], nil);
    STAssertEqualObjects(((Event *)_events[0]).name, @"Regular Meeting (3rd Wednesday of Month)", nil);
    
    
}


- (void)testFetchingExistingEventsUsingParseApi {
    [communicator downloadPastEventsForGroupName:@"Panorama Toastmasters" errorHandler:nil successHandler:nil];
    NSString *fullUrlPath = [baseURLString stringByAppendingString:[communicator URLPathToFetch]];
    STAssertEqualObjects(fullUrlPath, @"https://api.parse.com/1/classes/Event", @"Use the  query API to find members with a particular group name");
}


- (void)testFetchingExistingMembersUsingParseApi {
    [communicator downloadMembersForGroupName:@"Panorama Toastmasters" errorHandler:nil successHandler:nil];
    NSString *fullUrlPath = [baseURLString stringByAppendingString:[communicator URLPathToFetch]];
    STAssertEqualObjects(fullUrlPath, @"https://api.parse.com/1/classes/Member", @"Use the  query API to find members with a particular group name");
}

//- (void)testReceiving404ResponseToExistingEventsRequestPassesErrorToDelegate {
//    [nnCommunicator ];
//   [nnCommunicator connection:nil didReceiveResponse:(NSURLResponse *)fourOhFourResponse];
//   STAssertEquals([manager pastEventFailureErrorCode], 404, @"Fetch failure was passed through to delegate");
//}
//
//
//- (void)testNoErrorReceivedForExistingEventsOn200Status {
//    FakeURLResponse *twoHundredResponse = [[FakeURLResponse alloc] initWithStatusCode: 200];
//    [nnCommunicator downloadPastEventsForGroupName:@"Panorama Toastmasters" errorHandler:^(NSError * error){
//        [manager fetchingPastEventsFailedWithError:error];
//    }
//                                    successHandler:nil];
//    [nnCommunicator connection: nil didReceiveResponse: (NSURLResponse *)twoHundredResponse];
//    STAssertFalse([manager pastEventFailureErrorCode] == 200, @"No need for error on 200 response");
//}
//
//- (void)testConnectionFailingForExistingEventsDownloadPassesErrorToDelegate {
//    [nnCommunicator downloadPastEventsForGroupName:@"Panorama Toastmasters" errorHandler:^(NSError * error){
//        [manager fetchingPastEventsFailedWithError:error];
//    }
//                                    successHandler:nil];
//    NSError *error = [NSError errorWithDomain: @"Fake domain" code: 12345 userInfo: nil];
//    [nnCommunicator connection: nil didFailWithError: error];
//    STAssertEquals([manager pastEventFailureErrorCode], 12345, @"Failure to connect should get passed to the delegate");
//}
//
//- (void)testReceiving404ResponseToMembersRequestPassesErrorToDelegate {
//    [nnCommunicator downloadMembersWithGroupName:@"Panorama Toastmasters" errorHandler:^(NSError * error){
//        [manager fetchingMembersFailedWithError:error];
//    }
//                                    successHandler:nil];
//    [nnCommunicator connection:nil didReceiveResponse:(NSURLResponse *)fourOhFourResponse];
//    STAssertEquals([manager memberFailureErrorCode], 404, @"Fetch failure was passed through to delegate");
//}
//
//
//- (void)testNoErrorReceivedForMembersOn200Status {
//    FakeURLResponse *twoHundredResponse = [[FakeURLResponse alloc] initWithStatusCode: 200];
//    [nnCommunicator downloadMembersWithGroupName:@"Panorama Toastmasters" errorHandler:^(NSError * error){
//        [manager fetchingMembersFailedWithError:error];
//    }
//                                  successHandler:nil];
//    [nnCommunicator connection: nil didReceiveResponse: (NSURLResponse *)twoHundredResponse];
//    STAssertFalse([manager memberFailureErrorCode] == 200, @"No need for error on 200 response");
//}
//
//- (void)testConnectionFailingForMembersDownloadPassesErrorToDelegate {
//    [nnCommunicator downloadMembersWithGroupName:@"Panorama Toastmasters" errorHandler:^(NSError * error){
//        [manager fetchingMembersFailedWithError:error];
//    }
//                                  successHandler:nil];
//    NSError *error = [NSError errorWithDomain: @"Fake domain" code: 12345 userInfo: nil];
//    [nnCommunicator connection: nil didFailWithError: error];
//    STAssertEquals([manager memberFailureErrorCode], 12345, @"Failure to connect should get passed to the delegate");
//}
//
//
//- (void)testSuccessfulQuestionSearchPassesDataToDelegate {
//    [nnCommunicator downloadMembersWithGroupName:@"Panorama Toastmasters" errorHandler:^(NSError * error){
//        [manager fetchingMembersFailedWithError:error];
//    }
//                                  successHandler:nil];
//    [nnCommunicator setReceivedData: receivedData];
//    [nnCommunicator connectionDidFinishLoading: nil];
//    STAssertEqualObjects([manager membersString], @"Result", @"The delegate should have received data on success");
//}


@end
