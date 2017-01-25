//
//  Authors.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 16/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "Authors.h"

@implementation Authors
@synthesize name,blurb,company,uuid;
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:[NSString stringWithFormat:@"%@", self.blurb ] forKey:@"blurb"];
    [encoder encodeObject:[NSString stringWithFormat:@"%@", self.company ] forKey:@"company"];
    [encoder encodeObject:self.uuid forKey:@"uuid"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.name = [decoder decodeObjectForKey:@"name"];
        self.blurb = [decoder decodeObjectForKey:@"blurb"];
        self.company = [decoder decodeObjectForKey:@"company"];
        self.uuid = [decoder decodeObjectForKey:@"uuid"];
    }
    return self;
}
+ (void)saveCustomObject:(Authors *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

+ (Authors *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    Authors *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}
-(instancetype)init{
    self = [super init];
    if(self) {
        self.name=[[NSMutableString alloc] init];
        self.blurb=[[NSMutableString alloc] init];
        self.company=[[NSMutableString alloc] init];
        self.uuid=[[NSMutableString alloc] init];
    }
    return self;
}
@end
