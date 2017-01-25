//
//  Meta.m
//  TestSqliteToReplaceContento
//
//  Created by aadil on 07/11/15.
//  Copyright © 2015 73153. All rights reserved.
//

#import "Meta.h"

@implementation Meta
@synthesize createdAt,isActive,isValidated,lastUpdated,updatedAt,category,author,tags,userTypeId;
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.createdAt forKey:@"createdAt"];
    [encoder encodeObject:[NSString stringWithFormat:@"%d", self.isActive ] forKey:@"isActive"];
    [encoder encodeObject:[NSString stringWithFormat:@"%d", self.isValidated ] forKey:@"isValidated"];
    [encoder encodeObject:self.lastUpdated forKey:@"lastUpdated"];
    [encoder encodeObject:self.updatedAt forKey:@"updatedAt"];
    [encoder encodeObject:self.category forKey:@"category"];
    [encoder encodeObject:self.author forKey:@"author"];
    [encoder encodeObject:self.tags forKey:@"tags"];
    [encoder encodeObject:self.tags forKey:@"tags"];
    [encoder encodeObject:self.userTypeId forKey:@"userTypeId"];


}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.createdAt = [decoder decodeObjectForKey:@"createdAt"];
        self.isActive = [decoder decodeObjectForKey:@"isActive"];
        self.isValidated = [decoder decodeObjectForKey:@"isValidated"];
        self.lastUpdated = [decoder decodeObjectForKey:@"lastUpdated"];
        self.updatedAt = [decoder decodeObjectForKey:@"updatedAt"];
        self.category = [decoder decodeObjectForKey:@"category"];
        self.author = [decoder decodeObjectForKey:@"author"];
        self.tags = [decoder decodeObjectForKey:@"tags"];
        self.userTypeId = [decoder decodeObjectForKey:@"userTypeId"];
    }
    return self;
}
+ (void)saveCustomObject:(Meta *)object key:(NSString *)key {
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:key];
    [defaults synchronize];
    
}

+ (Meta *)loadCustomObjectWithKey:(NSString *)key {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject = [defaults objectForKey:key];
    Meta *object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return object;
}
-(instancetype)init
{
    self = [super init];
    if(self) {
        self.createdAt=[[NSMutableString alloc]init];
        self.lastUpdated=[[NSMutableString alloc]init];
        self.updatedAt=[[NSMutableString alloc]init];
        self.userTypeId=[[NSMutableString alloc]init];
        self.isValidated=false;
        self.isActive=false;
    }
    return self;
}
@end
