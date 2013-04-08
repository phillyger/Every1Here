//
//  EventBuilder.m
//  Every1Here
//
//  Created by Ger O'Sullivan on 1/18/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "EventBuilder.h"
#import "GroupBuilder.h"
#import "VenueBuilder.h"
#import "Event.h"
#import "Group.h"
#import "Venue.h"


@implementation EventBuilder

//- (NSArray *)eventsFromJSON:(NSString *)objectNotation error:(NSError *__autoreleasing *)error
//{
//    NSParameterAssert(objectNotation != nil);
//    NSData *unicodeNotation = [objectNotation dataUsingEncoding: NSUTF8StringEncoding];
//    NSError *localError = nil;
//    id jsonObject = [NSJSONSerialization JSONObjectWithData: unicodeNotation options: 0 error: &localError];
//    NSDictionary *parsedObject = (id)jsonObject;
//    if (parsedObject == nil) {
//        if (error != NULL) {
//            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity: 1];
//            if (localError != nil) {
//                [userInfo setObject: localError forKey: NSUnderlyingErrorKey];
//            }
//            *error = [NSError errorWithDomain:EventBuilderErrorDomain code: EventBuilderInvalidJSONError userInfo: userInfo];
//        }
//        return nil;
//    }
//    NSArray *events = [parsedObject objectForKey: @"results"];
//    if (events == nil) {
//        if (error != NULL) {
//            *error = [NSError errorWithDomain:EventBuilderErrorDomain code: EventBuilderMissingDataError userInfo:nil];
//        }
//        return nil;
//    }
//    NSMutableArray *results = [NSMutableArray arrayWithCapacity: [events count]];
//    for (NSDictionary *parsedEvent in events) {
////        [parsedEvent enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
////            NSLog(@"The object at key %@ is %@",key,obj);
////        }];
//        
//        Event *thisEvent = [[Event alloc] init];
//        thisEvent.eventId = parsedEvent[@"id"];
//        thisEvent.name = parsedEvent[@"name"];
//        thisEvent.time = [parsedEvent[@"time"] doubleValue];
//        thisEvent.utc_offset = [NSNumber numberWithInteger:[parsedEvent[@"utc_offset"] integerValue]];
//        thisEvent.yes_rsvp_count = [NSNumber numberWithInteger:[parsedEvent[@"yes_rsvp_count"] integerValue]];
//        thisEvent.maybe_rsvp_count = [NSNumber numberWithInteger:[parsedEvent[@"maybe_rsvp_count"] integerValue]];
//        thisEvent.headcount = [NSNumber numberWithInteger:[parsedEvent[@"headcount"] integerValue]];
//        
//        thisEvent.duration = [NSNumber numberWithInteger:[parsedEvent[@"duration"] integerValue]];
//        thisEvent.status = parsedEvent[@"status"];
//        
//        // Build group object
//        NSDictionary *groupValues = parsedEvent[@"group"];
//        if (groupValues != nil)
//            thisEvent.group = [GroupBuilder groupFromDictionary: groupValues];
//        
//        // Build venue
//        NSDictionary *venueValues = parsedEvent[@"venue"];
//        if (venueValues != nil)
//            thisEvent.venue = [VenueBuilder venueFromDictionary: venueValues];
//        
//        if (thisEvent.time > 0) {
//            thisEvent.startDateTime = [NSDate dateWithTimeIntervalSince1970: ((thisEvent.time + [thisEvent.utc_offset doubleValue])/1000)];
//            if (thisEvent.duration != nil) {
//                thisEvent.endDateTime = [NSDate dateWithTimeIntervalSince1970: ((((thisEvent.time + [thisEvent.utc_offset doubleValue])+([thisEvent.duration doubleValue]))/1000))];
//            }
//        }
//
//        [results addObject: thisEvent];
//    }
//    return [results copy];
//}


- (NSArray *)eventsFromJSON:(NSDictionary *)objectNotation error:(NSError *__autoreleasing *)error
{
    NSParameterAssert(objectNotation != nil);
//    NSData *unicodeNotation = [objectNotation dataUsingEncoding: NSUTF8StringEncoding];
    NSError *localError = nil;
//    id jsonObject = [NSJSONSerialization JSONObjectWithData: unicodeNotation options: 0 error: &localError];
    NSDictionary *parsedObject = objectNotation;
    if (parsedObject == nil) {
        if (error != NULL) {
            NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity: 1];
            if (localError != nil) {
                [userInfo setObject: localError forKey: NSUnderlyingErrorKey];
            }
            *error = [NSError errorWithDomain:EventBuilderErrorDomain code: EventBuilderInvalidJSONError userInfo: userInfo];
        }
        return nil;
    }
    NSArray *events = [parsedObject objectForKey: @"results"];
    if (events == nil) {
        if (error != NULL) {
            *error = [NSError errorWithDomain:EventBuilderErrorDomain code: EventBuilderMissingDataError userInfo:nil];
        }
        return nil;
    }
    NSMutableArray *results = [NSMutableArray arrayWithCapacity: [events count]];
    for (NSDictionary *parsedEvent in events) {
//        [parsedEvent enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
//            NSLog(@"The object at key %@ is %@",key,obj);
//        }];
        Event *thisEvent = [[Event alloc] init];
        thisEvent.objectId = parsedEvent[@"objectId"]; 
        thisEvent.eventId = parsedEvent[@"eventId"];
        thisEvent.name = parsedEvent[@"name"];
        thisEvent.time = [parsedEvent[@"time"] doubleValue];
        thisEvent.utc_offset = [NSNumber numberWithInteger:[parsedEvent[@"utc_offset"] integerValue]];
        thisEvent.yes_rsvp_count = [NSNumber numberWithInteger:[parsedEvent[@"yes_rsvp_count"] integerValue]];
        thisEvent.maybe_rsvp_count = [NSNumber numberWithInteger:[parsedEvent[@"maybe_rsvp_count"] integerValue]];
        thisEvent.headcount = [NSNumber numberWithInteger:[parsedEvent[@"headcount"] integerValue]];
        
        // Meetup.com set duration field to NULL once date has transpired. Need to catch this issue.
        if (parsedEvent[@"duration"]!=[NSNull null]) thisEvent.duration = [NSNumber numberWithInteger:[parsedEvent[@"duration"] integerValue]];
        thisEvent.status = parsedEvent[@"status"];
        
        // Build group object
        NSDictionary *groupValues = parsedEvent[@"group"];
        if (groupValues != nil) {
            thisEvent.group = [GroupBuilder groupFromDictionary: groupValues];
        } else {
            thisEvent.group = [[Group alloc] initWithName:@"Panorama Toastmasters"];
        }
        
        // Build venue
        NSDictionary *venueValues = parsedEvent[@"venue"];
        if (venueValues != nil) {
            thisEvent.venue = [VenueBuilder venueFromDictionary: venueValues];
        } else {
            thisEvent.venue = [[Venue alloc] init];
        }
        
        if (thisEvent.time > 0) {
            thisEvent.startDateTime = [NSDate dateWithTimeIntervalSince1970: ((thisEvent.time + [thisEvent.utc_offset doubleValue])/1000)];
            if (thisEvent.duration != nil) {
                thisEvent.endDateTime = [NSDate dateWithTimeIntervalSince1970: ((((thisEvent.time + [thisEvent.utc_offset doubleValue])+([thisEvent.duration doubleValue]))/1000))];
            }
        }
        
        [results addObject: thisEvent];
    }
    return [results copy];
}

@end

NSString *EventBuilderErrorDomain = @"EventBuilderErrorDomain";

