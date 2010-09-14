//
//  HLSDownloader.m
//  nut
//
//  Created by Samuel DEFAGO on 04.06.10.
//  Copyright 2010 Hortis. All rights reserved.
//

#import "HLSDownloader.h"

#import "HLSRequester.h"
#import "HLSRuntimeChecks.h"

DEFINE_NOTIFICATION(HLSDownloaderAllRetrievedNotification);
DEFINE_NOTIFICATION(HLSDownloaderChunkRetrievedNotification);
DEFINE_NOTIFICATION(HLSDownloaderFailureNotification);

@interface HLSDownloader ()

@property (nonatomic, retain) HLSRequester *requester;

@end

@implementation HLSDownloader

#pragma mark Object creation and destruction

- (id)initWithURL:(NSURL *)url
{
    if (self = [super init]) {
        // Create a request object appropriate for downloading
        NSURLRequest *request = [NSURLRequest requestWithURL:url
                                                 cachePolicy:NSURLRequestUseProtocolCachePolicy
                                             timeoutInterval:60.f];
        self.requester = [[[HLSRequester alloc] initWithRequest:request] autorelease];
    }
    return self;
}

- (id)init
{
    FORBIDDEN_INHERITED_METHOD();
    return nil;
}

- (void)dealloc
{
    self.requester = nil;
    [super dealloc];
}

#pragma mark Accessors and mutators

@synthesize requester = m_requester;

- (void)setRequester:(HLSRequester *)requester
{
    // Check for self-assignment
    if (m_requester == requester) {
        return;
    }
    
    // Stop trapping notifications for previous download
    [[NotificationConverter sharedNotificationConverter] removeConversionsFromObject:m_requester];
    
    // Save new value
    [m_requester release];
    m_requester = [requester retain];
    
    // Trap & convert notifications    
    [[NotificationConverter sharedNotificationConverter] convertNotificationWithName:HLSRequesterAllRetrievedNotification 
                                                                        sentByObject:m_requester 
                                                            intoNotificationWithName:HLSDownloaderAllRetrievedNotification 
                                                                        sentByObject:self];
    [[NotificationConverter sharedNotificationConverter] convertNotificationWithName:HLSRequesterChunkRetrievedNotification 
                                                                        sentByObject:m_requester 
                                                            intoNotificationWithName:HLSDownloaderChunkRetrievedNotification 
                                                                        sentByObject:self];
    [[NotificationConverter sharedNotificationConverter] convertNotificationWithName:HLSRequesterFailureNotification 
                                                                        sentByObject:m_requester 
                                                            intoNotificationWithName:HLSDownloaderFailureNotification 
                                                                        sentByObject:self];
}

#pragma mark Forwarding methods

- (void)start
{
    [self.requester start];
}

- (NSData *)fetchData
{
    return [self.requester fetchData];
}

- (NSData *)fetchPartialData
{
    return [self.requester fetchPartialData];
}

- (NSNumber *)progress
{
    return [self.requester progress];
}

- (NSString *)tag
{
    return self.requester.tag;
}

- (void)setTag:(NSString *)tag
{
    self.requester.tag = tag;
}

@end
