//
//  HttpWithObjectiveCViewController.m
//  HttpWithObjectiveC
//
//  Created by Toran Billups on 4/6/11.
//  Copyright 2011 N/A. All rights reserved.
//

#import "HttpWithObjectiveCViewController.h"
#import "DoHttpPostWithCookie.h"

@implementation HttpWithObjectiveCViewController
@synthesize responseData;
@synthesize cookies;

- (void)dealloc
{
    [cookies release];
    [responseData release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void) viewDidLoad
{
    responseData = [NSMutableData new];
    
    
    
//    NSURL *url = [NSURL URLWithString:@"https://www.wikipedia.org"];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
//    NSData *requestData = [@"name=testname&suggestion=testing123" dataUsingEncoding:NSUTF8StringEncoding];
    
//    [request setHTTPMethod:@"POST"];
//    [request setValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
//    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
   
    
    
    NSURL *url = [NSURL URLWithString:@"https://6195.playfabapi.com/Client/LoginWithCustomID?sdk=XPlatCppSdk-3.2.181220"];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url  cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSLog(@"step 0");
   // NSString *requestStr = [NSString stringWithFormat: @"{\"titleId\":\"6195\",\"developerSecretKey\":\"GI6SWSB39O56T7SG14XRQAO9AAB39HTR3B6T1AXZA7KQE4H54Z\",\"useEmail\":\"paul\@playfab.com\", \"characterName\":\"Ragnar\", \"extraHeaders\":{\"X-PlayFab-Internal\":\"gdpug53mok1yi1gz3ma3b6xooht688r641o5p4so8ipm5y6f8ok\"} }" ];
    
    NSString *requestStr = [NSString stringWithFormat: @"{\"titleId\":\"6195\", \"CreateAccount\":true, \"CustomId\":\"test_GSDK\",\"EncryptedRequest\":null,\"InfoRequestParameters\":null,\"PlayerSecret\":null}"];
                            
    NSLog(@"JSON = %@", requestStr);
    NSLog(@"step 1");
    
    NSData *requestData = [requestStr dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json;charset=utf8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"true" forHTTPHeaderField:@"X-ReportErrorAsSuccess"];
    [request setValue:@"XPlatCppSdk-3.2.181220" forHTTPHeaderField:@"X-PlatFabSDK"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    
    
    NSLog(@"step 2");
    
    [request setHTTPBody: requestData];
    
    [[NSURLConnection alloc] initWithRequest:request delegate:self];
    NSLog(@"step 3");
}

- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [responseData setLength:0];
}

- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void) connectionDidFinishLoading:(NSURLConnection *)connection {
    [connection release];
    
    NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"the html from this URL was %@", responseString);
    
    [responseString release];
    
    //hack - start the next request here :|
  //  DoHttpPostWithCookie* service = [[DoHttpPostWithCookie alloc] initWithViewController:self];
  //  [service startHttpRequestWithCookie:self.cookies];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"something very bad happened here");
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSHTTPURLResponse *)response {
    
    if (response != nil) { 
        NSArray* authToken = [NSHTTPCookie 
                              cookiesWithResponseHeaderFields:[response allHeaderFields] 
                              forURL:[NSURL URLWithString:@""]];
        
        if ([authToken count] > 0) {
            [self setCookies:authToken];
            NSLog(@"cookies property %@", self.cookies);
        }
    }
    
    return request;
}

- (void) returnHtmlFromPost:(NSString *)responseString
{
    //this is called from the new object we created when the "connectionDidFinishLoading" is complete
    NSLog(@"got this response back from the post with cookies %@", responseString);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
