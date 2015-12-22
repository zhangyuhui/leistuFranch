//
//  PathsClicked.m
//  LeiTeacherClient
//
//  Created by Rambo on 15/7/9.
//  Copyright (c) 2015年 U-Learning. All rights reserved.
//

#import "PathsClicked.h"
static PathsClicked *Paths;
@implementation PathsClicked
-(id)init{
    self = [super init];
    if (self) {
        self.courseID = [[NSString alloc]init];
        self.classID = [[NSString alloc]init];
        self.lessonIndex = [[NSString alloc]init];
        self.year = [[NSString alloc]init];
    }
    return self;
}
-(id)initWithDictionary:(NSMutableDictionary *)dictionary
{
    self = [super init];
    if (self) {
        self.courseID = [dictionary objectForKey:@"courseID"];
        self.classID = [dictionary objectForKey:@"classID"];
        self.lessonIndex = [dictionary objectForKey:@"lessonIndex"];
        self.year = [dictionary objectForKey:@"year"];
    }
    return self;
}
+(id)getPath:(PathsClicked *)paths;
{
    if (!paths) {
        return Paths;
    }
    Paths = paths;
    return Paths;
}


@end
