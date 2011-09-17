//
//  MGTwitterXMLParser.h
//  MGTwitterEngine
//
//  Created by Matt Gemmell on 18/02/2008.
//  Copyright 2008 Instinctive Code.
//

#import "MGTwitterEngineGlobalHeader.h"

#import "MGTwitterParserDelegate.h"

@interface MGTwitterXMLParser : NSObject <NSXMLParserDelegate> {
    __unsafe_unretained id<MGTwitterParserDelegate> delegate; // weak ref
    NSString *identifier;
    MGTwitterRequestType requestType;
    MGTwitterResponseType responseType;
    NSData *xml;
    NSMutableArray *parsedObjects;
    NSXMLParser *parser;
    __unsafe_unretained NSMutableDictionary *currentNode;
    NSString *lastOpenedElement;
}

+ (id)parserWithXML:(NSData *)theXML delegate:(id<MGTwitterParserDelegate>)theDelegate 
connectionIdentifier:(NSString *)identifier requestType:(MGTwitterRequestType)reqType 
       responseType:(MGTwitterResponseType)respType;
- (id)initWithXML:(NSData *)theXML delegate:(id<MGTwitterParserDelegate>)theDelegate 
connectionIdentifier:(NSString *)identifier requestType:(MGTwitterRequestType)reqType 
     responseType:(MGTwitterResponseType)respType;

- (NSString *)lastOpenedElement;
- (void)setLastOpenedElement:(NSString *)value;

- (void)addSource;

@end