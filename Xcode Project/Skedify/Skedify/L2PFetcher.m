//
//  L2PFetcher.m
//  Skedify
//
//  Created by Yigit Gunay on 1/19/14.
//  Copyright (c) 2014 SkedifyGroup. All rights reserved.
//

#import "L2PFetcher.h"

#define iPhoneCourseID "13ws-22433"
#define oneDocumentID "2"

enum _requestState {
    notSet = -1,
    wikiPage = 0,
    discussion = 1,
    announcement = 2,
    pdf = 3,
    documents = 4,
    courseRooms = 5
};

typedef enum _requestState requestState;

@interface L2PFetcher ()
{
    bool parseData;
}

@property(retain) NSURLConnection   *urlConnection;

@property(retain) NSXMLParser   *xmlParser;

@property(retain) NSString  *elementNameFromXMLParser;

@property(assign) requestState  state;

@end

@implementation L2PFetcher

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.accessToken = nil;
        self.elementNameFromXMLParser = nil;
        self.state = notSet;
    }
    return self;
}

-(void)getL2PCourseRooms
{
    self.state = courseRooms;
    
    // NOTE: See list of available endpoints in rwth_aachen_app_guideline_v04.pdf
    NSString *url =
    @"https://www2.elearning.rwth-aachen.de/L2PWebservices/L2PFoyerService.asmx";
    
    
    // NOTE: Open the URL of the endpoint in a web browser for the list of available
    //       actions and HTTP request and response examples.
    NSString *action = @"http://cil.rwth-aachen.de/l2p/services/GetCourseRooms";
    
    
    NSString *bodyString =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
     <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
     <soap:Body>\
     <GetCourseRooms xmlns=\"http://cil.rwth-aachen.de/l2p/services\">\
     <userToken>%@</userToken>\
     </GetCourseRooms>\
     </soap:Body>\
     </soap:Envelope>",
     self.accessToken];
    
    NSMutableURLRequest *courseInfoRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [courseInfoRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [courseInfoRequest addValue:[NSString stringWithFormat:@"%i", bodyString.length] forHTTPHeaderField:@"Content-Length"];
    [courseInfoRequest addValue:action forHTTPHeaderField:@"SOAPAction"];
    [courseInfoRequest setHTTPMethod:@"POST"];
    [courseInfoRequest setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:courseInfoRequest delegate:self startImmediately:YES];
}

-(void)getWikiPages
{
    self.state = wikiPage;
    
    NSString *url = @"https://www2.elearning.rwth-aachen.de/L2PWebservices/L2PSharedDomainService.asmx";
    NSString *bodyString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\"><soap:Body><GetWikiPages xmlns=\"http://cil.rwth-aachen.de/l2p/services\"><userToken>%@</userToken><courseId>%s</courseId></GetWikiPages></soap:Body></soap:Envelope>", self.accessToken, iPhoneCourseID];
    
    NSMutableURLRequest *wikiPageRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [wikiPageRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [wikiPageRequest addValue:[NSString stringWithFormat:@"%i", bodyString.length] forHTTPHeaderField:@"Content-Length"];
    [wikiPageRequest addValue:@"http://cil.rwth-aachen.de/l2p/services/GetWikiPages" forHTTPHeaderField:@"SOAPAction"];
    [wikiPageRequest setHTTPMethod:@"POST"];
    [wikiPageRequest setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:wikiPageRequest delegate:self startImmediately:YES];
}

-(void)getDiscussions
{
    self.state = discussion;
    
    NSString *url = @"https://www2.elearning.rwth-aachen.de/L2PWebservices/L2PSharedDomainService.asmx";
    NSString *bodyString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\"><soap12:Body><GetThreads xmlns=\"http://cil.rwth-aachen.de/l2p/services\"><userToken>%@</userToken>                      <courseId>%s</courseId></GetThreads></soap12:Body></soap12:Envelope>", self.accessToken, iPhoneCourseID];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:[NSString stringWithFormat:@"%i", bodyString.length] forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
}

-(void)getDocuments
{
    self.state = documents;
    
    NSString *url = @"https://www2.elearning.rwth-aachen.de/L2PWebservices/L2PLearningMaterialService.asmx";
    NSString *bodyString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\"><soap12:Body><GetDocumentsOverview xmlns=\"http://cil.rwth-aachen.de/l2p/services\"><userToken>%@</userToken><courseId>%s</courseId></GetDocumentsOverview></soap12:Body></soap12:Envelope>", self.accessToken, iPhoneCourseID];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:[NSString stringWithFormat:@"%i", bodyString.length] forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
}

-(void)getPDFWithID:(NSString*)documentID
{
    self.state = pdf;
    
    NSString *url = @"https://www2.elearning.rwth-aachen.de/L2PWebservices/L2PLearningMaterialService.asmx";
    NSString *bodyString = [NSString stringWithFormat:@"<?xml version=\"1.0\" encoding=\"utf-8\"?><soap12:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap12=\"http://www.w3.org/2003/05/soap-envelope\"><soap12:Body><DownloadDocumentItem xmlns=\"http://cil.rwth-aachen.de/l2p/services\"><userToken>%@</userToken><courseId>%s</courseId><fileId>%@</fileId></DownloadDocumentItem></soap12:Body></soap12:Envelope>", self.accessToken, iPhoneCourseID, documentID];
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:[NSString stringWithFormat:@"%i", bodyString.length] forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self startImmediately:YES];
}

#pragma mark NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (parseData)
    {
        self.xmlParser = [[NSXMLParser alloc] initWithData:data];
        [self.xmlParser setDelegate:self];
        [self.xmlParser setShouldProcessNamespaces:YES];
        [self.xmlParser parse];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //NSLog(@"Recieved response: %@", response);
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int statusCode = [httpResponse statusCode];
    if (statusCode >= 300)
    {
        NSLog(@"Error\nHTTP status code: %i", statusCode);
        parseData = NO;
    }
    else
    {
        parseData = YES;
    }
}

#pragma mark NSXMLParserDelegate

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    self.elementNameFromXMLParser = elementName;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    string = [string stringByAppendingString:@"\n"];
    NSString *stringToAppend = nil;
    
    switch (self.state) {
        case wikiPage:
            if ([self.elementNameFromXMLParser isEqualToString:@"WikiInfo"]) {
                stringToAppend = @"\nWiki";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"Body"]) {
                stringToAppend = @"Body: ";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"ID"]) {
                stringToAppend = @"ID: ";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"Name"]) {
                stringToAppend = @"Name: ";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"ShowInSummary"]) {
                stringToAppend = @"ShowInSummary: ";
            }
            stringToAppend = [stringToAppend stringByAppendingString:string];
            break;
        case discussion:
            if ([self.elementNameFromXMLParser isEqualToString:@"ThreadInfo"]) {
                stringToAppend = @"\nThread";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"ID"]) {
                stringToAppend = @"ID: ";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"Title"]) {
                stringToAppend = @"Title: ";
            }
            stringToAppend = [stringToAppend stringByAppendingString:string];
            break;
        case announcement:
            //
            break;
        case courseRooms:
            if ([self.elementNameFromXMLParser isEqualToString:@"CourseType"]) {
                stringToAppend = @"\nCourseRoomInfo\nCourseType: ";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"FullUrl"]) {
                stringToAppend = @"FullUrl: ";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"ID"]) {
                stringToAppend = @"ID: ";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"MasterId"]) {
                stringToAppend = @"MasterId: ";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"Status"]) {
                stringToAppend = @"Status: ";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"Title"]) {
                stringToAppend = @"Title: ";
            }
            stringToAppend = [stringToAppend stringByAppendingString:string];
            break;
        case documents:
            if ([self.elementNameFromXMLParser isEqualToString:@"DocumentInfo"]) {
                stringToAppend = @"\nWiki";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"Id"]) {
                stringToAppend = @"ID: ";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"Name"]) {
                stringToAppend = @"Name: ";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"Url"]) {
                stringToAppend = @"Url: ";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"LastUpdated"]){
                stringToAppend = @"LastUpdated: ";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"FileType"]){
                stringToAppend = @"FileType: ";
            } else if ([self.elementNameFromXMLParser isEqualToString:@"FileSize"]){
                stringToAppend = @"FileSize: ";
            }
            stringToAppend = [stringToAppend stringByAppendingString:string];
            break;
        default:
            stringToAppend = @"unknown state";
            break;
    }
    
    if (stringToAppend != nil) {
        
        NSLog(@"Fetched data: %@", stringToAppend);
        
    }
}

-(void)parserDidStartDocument:(NSXMLParser *)parser
{

}

-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSLog(@"Error: %@", parseError);
}

@end
