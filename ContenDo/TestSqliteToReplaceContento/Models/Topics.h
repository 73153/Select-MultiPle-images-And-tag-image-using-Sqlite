//
//  Topics.h
//  TestSqliteToReplaceContento
//
//  Created by aadil on 09/03/16.
//  Copyright © 2016 73153. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Meta.h"
@interface Topics : NSObject
@property Meta *meta;
@property NSMutableString *topicId,*uuid,*clientId, *topicname;
@property NSMutableArray *channelId;
@end
