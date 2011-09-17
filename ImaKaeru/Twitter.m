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

// following code is based on http://d.hatena.ne.jp/sugyan/20100819/1282156751

@interface Twitter ()
+ (NSData *)request:(NSURL *)url method:(NSString *)method body:(NSData *)body oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret;
@end

@implementation Twitter

+ (BOOL)authenticate:(NSString *)username password:(NSString *)password
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
    Config *config = [Config instance];
    config.twitterOAuthToken = oauth_token;
    config.twitterOAuthSecret = oauth_token_secret;
    [config save];
    
    return YES;
}

+ (BOOL)tweet:(NSString *)status
{
    Config *config = [Config instance];

    NSString *oauth_token = config.twitterOAuthToken;
    NSString *oauth_secret = config.twitterOAuthSecret;
    
    if (oauth_token == nil || oauth_secret) {
        return NO;
    }
    
    NSData *tweet_response = [Twitter request:[NSURL URLWithString:@"http://api.twitter.com/1/statuses/update.json"]
                                       method:@"POST"
                                         body:[[NSString stringWithFormat:@"status=%@", status] dataUsingEncoding:NSUTF8StringEncoding]
                                  oauth_token:oauth_token
                           oauth_token_secret:oauth_secret];
    NSLog(@"response: %@", [[NSString alloc] initWithData:tweet_response encoding:NSUTF8StringEncoding] );
    return YES;
}

+ (NSData *)request:(NSURL *)url method:(NSString *)method body:(NSData *)body oauth_token:(NSString *)oauth_token oauth_token_secret:(NSString *)oauth_token_secret
{
    NSString *header = OAuthorizationHeader(url, method, body, CONSUMER_KEY, CONSUMER_SECRET, oauth_token, oauth_token_secret);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:method];
    [request setValue:header forHTTPHeaderField:@"Authorization"];
    [request setHTTPBody:body];

    NSURLResponse *response = nil;
    NSError       *error    = nil;
    NSData *res = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    return res;
}
@end
