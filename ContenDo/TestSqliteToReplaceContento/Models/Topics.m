//
//  Topics.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 09/03/16.
//  Copyright © 2016 73153. All rights reserved.
//

#import "Topics.h"

@implementation Topics
@synthesize topicname,topicId,uuid,clientId,meta,channelId;
-(instancetype)init
{
    self = [super init];
    if(self) {
        self.topicId=[[NSMutableString alloc] init];
        self.uuid=[[NSMutableString alloc] init];
        self.clientId=[[NSMutableString alloc] init];
        self.meta=[[Meta alloc] init];
        self.topicname=[[NSMutableString alloc] init];
        self.channelId=[[NSMutableArray alloc] init];
    }
    return self;
}
@end
