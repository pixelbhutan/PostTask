//
//  WebServiceMethods.h
//  LittleBhutan
//
//  Created by gkreddy on 10/11/13.
//  Copyright (c) 2013 LittleBhutan. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface WebServiceMethods : NSObject
{
    NSURLConnection *asyncConnection;
    NSMutableData *responseData;
    NSURLResponse *urlResponse;
}
@property(nonatomic, retain) id target;
@property(nonatomic, assign) SEL action;

- (void) formURLRequestAndGetResponseData : (NSString *)urlString;
-(void)formPostRequestAndGetResponseData :(NSString *)urlString withDetailsDictionary :(NSMutableDictionary *)detailsDictionary;

@end
