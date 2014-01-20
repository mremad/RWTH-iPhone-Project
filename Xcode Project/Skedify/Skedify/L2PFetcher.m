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
    courseRooms = 5,
    courseDates = 6
};

typedef enum _requestState requestState;

@interface L2PFetcher ()
{
    bool parseData;
    NSMutableArray* IDs;
    NSMutableArray* dates;
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
        IDs = [NSMutableArray new];
        dates = [NSMutableArray new];
    }
    return self;
}

-(void)getDatesForL2PCourse:(NSString*) courseID
{
    self.state = courseDates;
    
    // NOTE: See list of available endpoints in rwth_aachen_app_guideline_v04.pdf
    NSString *url =
    @"https://www2.elearning.rwth-aachen.de/L2PWebservices/L2PPublicDomainService.asmx";
    
    
    // NOTE: Open the URL of the endpoint in a web browser for the list of available
    //       actions and HTTP request and response examples.
    NSString *action = @"http://cil.rwth-aachen.de/l2p/services/GetAppointments";
    
    
    NSString *bodyString =
    [NSString stringWithFormat:
     @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\
     <soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
     <soap:Body>\
     <GetAppointments xmlns=\"http://cil.rwth-aachen.de/l2p/services\"> \
     <userToken>%@</userToken> \
     <courseId>%@</courseId> \
     </GetAppointments> \
     </soap:Body> \
     </soap:Envelope>",
     self.accessToken, courseID];
    
    NSMutableURLRequest *courseInfoRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [courseInfoRequest addValue:@"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [courseInfoRequest addValue:[NSString stringWithFormat:@"%i", bodyString.length] forHTTPHeaderField:@"Content-Length"];
    [courseInfoRequest addValue:action forHTTPHeaderField:@"SOAPAction"];
    [courseInfoRequest setHTTPMethod:@"POST"];
    [courseInfoRequest setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.urlConnection = [[NSURLConnection alloc] initWithRequest:courseInfoRequest delegate:self startImmediately:YES];
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

#pragma mark NSURLConnectionDataDelegate

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (parseData)
    {
        self.xmlParser = [[NSXMLParser alloc] initWithData:data];
        [self.xmlParser setDelegate:self];
        [self.xmlParser setShouldProcessNamespaces:YES];
        [self.xmlParser parse];
        
        
        //NSLog(@"response: %@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
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
    
    // For each element Appointment, get the attributes that contain course's starting and ending times.
    if (self.state == courseDates && [elementName isEqualToString:@"Appointment"] )
    {
        //NSLog(@"Attributes: %@", attributeDict);
        NSDictionary* dateDict = @{@"start": attributeDict[@"start"],
                                   @"end": attributeDict[@"end"]
                                   };
        
        //[dates addObject:dateDict];
        NSLog(@"dates: %@", dateDict);
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (self.state == courseRooms && [self.elementNameFromXMLParser isEqualToString:@"ID"])
    {
        [IDs addObject:string];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    //NSLog(@"IDs: %@", IDs);
    
    if (self.state == courseRooms)
    {
        for (NSString* courseID in IDs)
        {
            [self getDatesForL2PCourse:courseID];
        }
        
        [IDs removeAllObjects];
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
