//
//  PathsClicked.h
//  LeiTeacherClient
//
//  Created by Rambo on 15/7/9.
//  Copyright (c) 2015年 U-Learning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PathsClicked : NSObject
@property (nonatomic , strong)NSString * courseID;
@property (nonatomic , strong)NSString * classID;
@property (nonatomic , strong)NSString * lessonIndex;
@property (nonatomic , strong)NSString * year;
+(id)getPath:(PathsClicked *)paths;
-(id)initWithDictionary:(NSMutableDictionary *)dictionary;
@end
