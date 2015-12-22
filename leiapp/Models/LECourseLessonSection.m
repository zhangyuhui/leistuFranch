//
//  LELessonSection.m
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseLessonSection.h"
#import "LECourseLessonNoteTextItem.h"
#import "LECourseLessonPlainTextItem.h"
#import "LECourseLessonThinkTextItem.h"
#import "LECourseLessonExampleTextItem.h"
#import "LECourseLessonDidYouKnowTextItem.h"
#import "LECourseLessonRememberTextItem.h"
#import "LECourseLessonImportantTextItem.h"
#import "LECourseLessonImageItem.h"
#import "LECourseLessonVideoItem.h"
#import "LECourseLessonPPTItem.h"
#import "LECourseLessonLEIPlainTextItem.h"
#import "LECourseLessonLEIPlainImageItem.h"
#import "LECourseLessonLEIAudioResponseItem.h"
#import "LECourseLessonLEIAudioItem.h"
#import "LECourseLessonLEIVideoItem.h"
#import "LECourseLessonLEIPracticeItem.h"
#import "LECourseLessonLEIRolePlayItem.h"
#import "LECourseLessonLEIAudioTextItem.h"
#import "LECourseLessonLEIReadingItem.h"
#import "LECourseLessonOptionTestItem.h"
#import "LECourseLessonStatementTestItem.h"

@interface LECourseLessonSection ()
+ (NSDictionary*)itemClassMap;
@end

@implementation LECourseLessonSection

+ (NSDictionary*)itemClassMap {
    static NSDictionary *sharedClassMap = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableDictionary* _sharedClassMap = [NSMutableDictionary new];
        
        void (^registerItemClass)(LECourseLessonSectionItemType, Class) = ^void(LECourseLessonSectionItemType type, Class klass) {
            [_sharedClassMap setObject:NSStringFromClass(klass) forKey:[NSNumber numberWithInt:type]];
        };
        
        registerItemClass(LECourseLessonSectionItemTypeNoteText, [LECourseLessonNoteTextItem class]);
        registerItemClass(LECourseLessonSectionItemTypePlainText, [LECourseLessonPlainTextItem class]);
        registerItemClass(LECourseLessonSectionItemTypeThinkText, [LECourseLessonThinkTextItem class]);
        registerItemClass(LECourseLessonSectionItemTypeExampleText, [LECourseLessonExampleTextItem class]);
        registerItemClass(LECourseLessonSectionItemTypeDidYouKnowText, [LECourseLessonDidYouKnowTextItem class]);
        registerItemClass(LECourseLessonSectionItemTypeRememberText, [LECourseLessonRememberTextItem class]);
        registerItemClass(LECourseLessonSectionItemTypeImportantText, [LECourseLessonImportantTextItem class]);
        registerItemClass(LECourseLessonSectionItemTypeImage, [LECourseLessonImageItem class]);
        registerItemClass(LECourseLessonSectionItemTypeVideo, [LECourseLessonVideoItem class]);
        registerItemClass(LECourseLessonSectionItemTypePPT, [LECourseLessonPPTItem class]);
        
        registerItemClass(LECourseLessonSectionItemTypeLEIPlainText, [LECourseLessonLEIPlainTextItem class]);
        registerItemClass(LECourseLessonSectionItemTypeLEIPlainImage, [LECourseLessonLEIPlainImageItem class]);
        registerItemClass(LECourseLessonSectionItemTypeLEIAudioResponse, [LECourseLessonLEIAudioResponseItem class]);
        registerItemClass(LECourseLessonSectionItemTypeLEIAudio, [LECourseLessonLEIAudioItem class]);
        registerItemClass(LECourseLessonSectionItemTypeLEIVideo, [LECourseLessonLEIVideoItem class]);
        registerItemClass(LECourseLessonSectionItemTypeLEIPractice, [LECourseLessonLEIPracticeItem class]);
        registerItemClass(LECourseLessonSectionItemTypeLEIRolePlay, [LECourseLessonLEIRolePlayItem class]);
        registerItemClass(LECourseLessonSectionItemTypeLEIAudioText, [LECourseLessonLEIAudioTextItem class]);
        registerItemClass(LECourseLessonSectionItemTypeLEIReading, [LECourseLessonLEIReadingItem class]);
        
        registerItemClass(LECourseLessonSectionItemTypeOptionTest, [LECourseLessonOptionTestItem class]);
        registerItemClass(LECourseLessonSectionItemTypeStatementTest, [LECourseLessonStatementTestItem class]);
        
        sharedClassMap = _sharedClassMap;
    });
    return sharedClassMap;
}

- (id)initWithDictionary:(NSDictionary*)dict error:(NSError**)err {
    self = [super initWithDictionary:dict error:err];
    if (self) {
        NSArray* itemsArray = [dict objectForKey:@"items"];
        NSDictionary* itemClassMap = [LECourseLessonSection itemClassMap];
        NSMutableArray<LECourseLessonSectionItem>* items = [NSMutableArray<LECourseLessonSectionItem> new];
        for (NSDictionary* dict in itemsArray) {
            NSNumber* type = [dict objectForKey:@"type"];
            NSString* name = [itemClassMap objectForKey:type];
            Class klass = NSClassFromString(name);
            NSError* error;
            LECourseLessonSectionItem* item = [[klass alloc] initWithDictionary:dict error:&error];
            if (item) {
                [items addObject:item];
            }
        }
        self.items = items;
    }
    return self;
}
@end
