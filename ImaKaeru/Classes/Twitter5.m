#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

// Twitter - iOS5

- (void)sendTwitter5
{
    if (mConfig.twitterAddress == nil || [mConfig.twitterAddress length] == 0) {
        // TODO: 宛先なし
        return;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSString *apiUrl;

    NSString *msg;
    if (mConfig.isUseDirectMessage) {
	// DirectMessage
	apiUrl = @"http://api.twitter.com/1/direct_messages/new.json";

	msg = [NSString stringWithFormat:@"%@ %@ http://iphone.tmurakam.org/ImaKaeru", mMessageToSend, _L(@"hash_tag")];
	[params setObject:msg forKey:@"text"];
	[params setObject:mMessageToSend forKey:@"user_id"];
    } else {
	// mention
	apiUrl = @"http://api.twitter.com/1/statuses/update.json";

	msg = [NSString stringWithFormat:@"@%@ %@ %@ http://iphone.tmurakam.org/ImaKaeru", mConfig.twitterAddress, mMessageToSend, _L(@"hash_tag")];
	[params setObject:msg forKey:@"text"];
    }

    ACAccountStore *store = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [store requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        if (!granted) {
	    // TBD : エラー
	    [self showError:_L(@"error_setup_twitter_account")];
	    return;
	}
	NSArray *accounts = [store accountsWithAccountType:accountType];
	if ([accounts count] <= 0) {
	    // TBD: エラー、アカウントなし
	    [self showError:_L(@"error_setup_twitter_account")];
	}
	
	ACAccount *account = [accounts objectAtIndex:0];

	[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

	// request 作成
	TWRequest *req = [[TWRequest alloc] initWithURL:[NSURL URLWithString:apiUrl]
					     parameters:params
					  requestMethod:TWRequestMethodPOST];
	[req setAccount:account];
	[req performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
		if ([urlReponse statusCode] == 200) {
		    [self performSelectorOnMainThread:@selector(tweetDone) withObject:nil waitUntilDone:NO];
		} else {
		    [self performSelectorOnMainThread:@selector(tweetFailed) withObject:nil waitUntilDone:NO];
		}
	    }];
	}];
}

- (void)tweetDone
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    if (mConfig.isUseEmail) {
        [self sendEmail];
    } else {
        [self showMessage:_L(@"tweet_completed") title:@"Twitter"];
    }

}

- (void)tweetFailed
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self showError:_L(@"tweet_failed")];
}

