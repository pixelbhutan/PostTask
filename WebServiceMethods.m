//
//  WebServicesMethods.m
//  LittleBhutan
//
//  Created by gkreddy on 10/11/13.
//  Copyright (c) 2013 LittleBhutan. All rights reserved.
//


#import "WebServiceMethods.h"


@implementation WebServiceMethods

@synthesize target;
@synthesize action;

- (id)init {
	
	self = [super init];
	responseData = nil;
	return self;
}

// Forming the url request and establishing an asynchronous request

- (void) formURLRequestAndGetResponseData : (NSString *)urlString{
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:	NSURLRequestReloadIgnoringCacheData		//NSURLRequestReloadIgnoringLocalCacheData
													   timeoutInterval:30];
    
    asyncConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}

-(void)formPostRequestAndGetResponseData :(NSString *)urlString withDetailsDictionary :(NSMutableDictionary *)detailsDictionary{
    NSLog(@"url is %@",urlString);
    
    NSURL *queriesURL = [NSURL URLWithString:urlString];
    NSString *boundary = @"---------------------------10102754414578508781458777923";
    
    NSMutableURLRequest *postRequest = [NSMutableURLRequest requestWithURL:queriesURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
    
    NSMutableData *body = [[NSMutableData alloc] init];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [postRequest setValue:contentType forHTTPHeaderField:@"Content-type"];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    /**
     *	Adding objects to Request
     */
    
    for (NSString *key in [detailsDictionary allKeys]) {
        
        if([key isEqualToString:@"image"]){
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"testing.png\"\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[@"Content-Type: image/png\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:UIImageJPEGRepresentation([detailsDictionary objectForKey:key], 1.0)];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        else{
            
            [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";\r\n",key] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n%@",[detailsDictionary objectForKey:key]] dataUsingEncoding:NSUTF8StringEncoding]];
            [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
        }
        
    }
    
    [postRequest setHTTPMethod:@"POST"];
    [postRequest setHTTPBody:body];
    
    if ([detailsDictionary objectForKey:@"isSychronous"] && [[detailsDictionary objectForKey:@"isSychronous"] isEqualToString:@"YES"]) {
        
        NSURLResponse *response = nil;
        NSError *error = nil;
        NSData *data = [NSURLConnection sendSynchronousRequest:postRequest returningResponse:&response error:&error];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSStringEncoding responseEncoding = NSUTF8StringEncoding;
        
        if ([urlResponse textEncodingName]) {
            CFStringEncoding cfStringEncoding = CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)[urlResponse textEncodingName]);
            if (cfStringEncoding != kCFStringEncodingInvalidId) {
                responseEncoding = CFStringConvertEncodingToNSStringEncoding(cfStringEncoding);
            }
        }
        
        //        NSString *dataString = [[NSString alloc] initWithData:data encoding:responseEncoding];
        
        //    NSLog(@"data string %@",dataString);
        
        NSError *e = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
        
        //        dataString = nil;
        responseData = nil;
        urlResponse = nil;
        
        @try{
            if(self.target != nil && self.action  && [self.target respondsToSelector:self.action]) {
                
                [self.target performSelector:self.action withObject:jsonObject];
                
            }
        }
        @catch (NSException *exception) {
            NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
            
        }
        
    }
    else{
        
        //        [NSURLConnection sendAsynchronousRequest:postRequest queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        //
        //
        //            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        //            NSStringEncoding responseEncoding = NSUTF8StringEncoding;
        //
        //            if ([urlResponse textEncodingName]) {
        //                CFStringEncoding cfStringEncoding = CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)[response textEncodingName]);
        //                if (cfStringEncoding != kCFStringEncodingInvalidId) {
        //                    responseEncoding = CFStringConvertEncodingToNSStringEncoding(cfStringEncoding);
        //                }
        //            }
        //
        //            NSString *dataString = [[NSString alloc] initWithData:data encoding:responseEncoding];
        //
        //            NSLog(@"data string %@",dataString);
        //
        //            NSError *e = nil;
        //            id jsonObject = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
        //            dataString = nil;
        //
        //            @try{
        //                if(self.target != nil && self.action  && [self.target respondsToSelector:self.action]) {
        //
        //                    [self.target performSelector:self.action withObject:jsonObject];
        //
        //                }
        //            }
        //            @catch (NSException *exception) {
        //                NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
        //
        //            }
        //
        //        }];
        
        asyncConnection = [[NSURLConnection alloc] initWithRequest:postRequest delegate:self];
        
    }
    
}
#pragma mark - NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	
	@try{
		if(self.target != nil && self.action  && [self.target respondsToSelector:self.action]) {
            //            NSLog(@"error is %@",[error localizedDescription]);
			[self.target performSelector:self.action withObject:[error localizedDescription]];
		}
	}
	@catch (NSException *exception) {
        //		NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
	}
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	urlResponse = [response copy];
	responseData = [[NSMutableData alloc] init];
	
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
	
	
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectRespons{
	return request;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
	NSStringEncoding responseEncoding = NSASCIIStringEncoding;
	
	if ([urlResponse textEncodingName]) {
		CFStringEncoding cfStringEncoding = CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef)[urlResponse textEncodingName]);
		if (cfStringEncoding != kCFStringEncodingInvalidId) {
			responseEncoding = CFStringConvertEncodingToNSStringEncoding(cfStringEncoding);
		}
	}
	
	NSString *dataString = [[NSString alloc] initWithData:responseData encoding:responseEncoding];
    
	if(dataString == nil){
		dataString = nil;
		
		dataString = [[NSString alloc]initWithString:[NSString stringWithCString:[responseData bytes] encoding:responseEncoding]];
	}
    
    NSError *e = nil;

    
    id jsonObject = [NSJSONSerialization JSONObjectWithData: responseData options: NSJSONReadingMutableContainers error: &e];

	
	//SBJSON *jsonParser = [SBJSON new];
	//id jsonObject = [jsonParser objectWithString:dataString error:NULL];
	dataString = nil;
	responseData = nil;
	urlResponse = nil;
    
    
    
	@try{
		if(self.target != nil && self.action  && [self.target respondsToSelector:self.action]) {
            
            [self.target performSelector:self.action withObject:jsonObject];
            
		}
	}
	@catch (NSException *exception) {
		NSLog(@"main: Caught %@: %@", [exception name], [exception reason]);
		
	}
	
}




@end
