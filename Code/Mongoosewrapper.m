
//
//  MongooseWrapper.h
// Copyright (c) 2013 vivek
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import "Mongoosewrapper.h"
#include <ifaddrs.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <net/if.h>


#define DOCUMENTS_FOLDER NSHomeDirectory()

static MongooseWrapper *instance;
@interface MongooseWrapper ()
{
    NSMutableArray *urls;
}
@end


@implementation MongooseWrapper

@synthesize ctx;

+ (id)sharedInstance
{
    static BOOL initialized = NO;
	if (!initialized)
	{
		initialized = YES;
		
		instance = [[MongooseWrapper alloc] init];
	}

    return instance;
}


-(NSArray*) getIpAddress
{
    NSMutableArray *ipAddresses = [NSMutableArray array] ;
    
    struct ifaddrs *allInterfaces;
    
    // Get list of all interfaces on the local machine:
    if (getifaddrs(&allInterfaces) == 0) {
        struct ifaddrs *interface;
        
        // For each interface ...
        for (interface = allInterfaces; interface != NULL; interface = interface->ifa_next) {
            unsigned int flags = interface->ifa_flags;
            struct sockaddr *addr = interface->ifa_addr;
            
            // Check for running IPv4, IPv6 interfaces. Skip the loopback interface.
            if ((flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING)) {
                if (addr->sa_family == AF_INET) {
                    
                    // Convert interface address to a human readable string:
                    char host[NI_MAXHOST];
                    getnameinfo(addr, addr->sa_len, host, sizeof(host), NULL, 0, NI_NUMERICHOST);
                    
                    [ipAddresses addObject:[[NSString alloc] initWithUTF8String:host]];
                }
            }
        }
        
        freeifaddrs(allInterfaces);
    }

    return ipAddresses;

}




- (void)startHTTP:(NSString *)ports
{
       const char *options[] = {
         "document_root", [DOCUMENTS_FOLDER UTF8String],
         "listening_ports", [ports UTF8String],
         NULL
       };
    self.ctx =  mg_start(NULL, NULL
                         ,options);
    if(urls == Nil)
    {
        urls = [[NSMutableArray alloc]init];
        NSArray *suppliedPorts = [ports componentsSeparatedByString:@","];
        
        for (int i =0; i< [suppliedPorts count]; i++) {
            [urls addObject:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:%@",[[self getIpAddress]objectAtIndex:0],[suppliedPorts objectAtIndex:i]]]];
        }
    }
  NSLog(@"Mongoose Server is running on http://%@:%@",[[self getIpAddress]objectAtIndex:0],ports);
}

- (void)startMongoose:(NSString *)ports;
{
  [self startHTTP:ports];
}

- (void)stopMongoose
{
  mg_stop(ctx);
}

- (NSArray*)serverContactURL
{
    return urls;
}

@end
