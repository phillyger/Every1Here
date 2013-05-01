//
//  NonNetworkedParseDotComCommunicator.h
//  E1H
//
//  Created by Ger O'Sullivan on 2/4/13.
//  Copyright (c) 2013 Brilliant Age. All rights reserved.
//

#import "ParseDotComCommunicator.h"


@interface NonNetworkedParseDotComCommunicator : ParseDotComCommunicator {
    NSMutableData* _data;
    NSError* _error;
}
//@property (copy) NSData *receivedData;


@end
