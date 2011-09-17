//
//  Twitter.m
//  ImaKaeru
//
//  Created by 村上 卓弥 on 11/09/17.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "Twitter.h"
#import "TwitterSecret.h"
#import "Config.h"

@interface Twitter ()
+ (NSData *)request:(NSURL *)url method:(NSString *)method body:(NSData *)body oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret;
@end

@implementation Twitter

+ (void)authenticate:(NSString *)username password:(NSString *)password
{
    // xAuth
    NSData *xauth_response = [Twitter request:[NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"]
                                       method:@"POST"
                                         body:[[NSString stringWithFormat:@"x_auth_username=%@&x_auth_password=%@&x_auth_mode=client_auth",
                                                username, password] dataUsingEncoding:NSUTF8StringEncoding]
                                  oauth_token:@""
                           oauth_token_secret:@""];
    NSDictionary *dict = [NSURL ab_parseURLQueryString:[[NSString alloc] initWithData:xauth_response encoding:NSUTF8StringEncoding]];
    
    NSString *oauth_token = [dict objectForKey:@"oauth_token"];
    NSString *oauth_token_secret = [dict objectForKey:@"oauth_token_secret"];
    
    // save oauth token
}

/*
+ (void)tweet:(NSString *)status
{
    // xAuthで得たtokenを利用してTweet
    NSData *tweet_response = [Hoge request:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"]
                                    method:@"POST"
                                      body:[[NSString stringWithFormat:@"status=%@", status] dataUsingEncoding:NSUTF8StringEncoding]
                               oauth_token:oauth_token
                        oauth_token_secret:oauth_token_secret];
    NSLog(@"response: %@", [[[NSString alloc] initWithData:tweet_response encoding:NSUTF8StringEncoding] autorelease]);
}
*/

+ (NSData *)request:(NSURL *)url method:(NSString *)method body:(NSData *)body oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret
{
    NSString *header = OAuthorizationHeader(url, method, body, CONSUMER_KEY, CONSUMER_SECRET, oauth_token, oauth_token_secret);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    [request setValue:header forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:body];
    NSURLResponse *response = nil;
    NSError       *error    = nil;
    return [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
}
@end
