//
//  LECourseParser.m
//  leiapp
//
//  Created by Yuhui Zhang on 9/5/15.
//  Copyright (c) 2015 Yuhui Zhang. All rights reserved.
//

#import "LECourseParser.h"
#import "LECourseLesson.h"
#import "LECourseLessonSection.h"
#import "LECourseLessonOptionTestItem.h"
#import "LECourseLessonStatementTestItem.h"
#import "LECourseLessonPPTItem.h"
#import "LECourseLessonImageItem.h"
#import "LECourseLessonVideoItem.h"
#import "LECourseLessonThinkTextItem.h"
#import "LECourseLessonLEIAudioItem.h"
#import "LECourseLessonLEIVideoItem.h"
#import "LECourseLessonLEIPracticeItem.h"
#import "LECourseLessonLEIPracticeQuestion.h"
#import "LECourseLessonLEIPlainImageItem.h"
#import "LECourseLessonLEIRolePlayItem.h"
#import "LECourseLessonLEIRolePlayDialog.h"
#import "LECourseLessonLEIAudioTextItem.h"
#import "LECourseLessonLEIAudioText.h"
#import "LECourseLessonLEIAudioResponseItem.h"
#import "LECourseLessonLEIAudioResponse.h"
#import "LECourseGlossary.h"
#import "LECourseTestSection.h"
#import "LECourseTestSectionOptionItem.h"
#import "LECourseLessonPlainTextItem.h"
#import "LECourseLessonDidYouKnowTextItem.h"
#import "LECourseLessonExampleTextItem.h"
#import "LECourseLessonRememberTextItem.h"
#import "LECourseLessonImportantTextItem.h"
#import "LECourseLessonLEIPlainTextItem.h"
#import "LECourseLessonLEIReadingItem.h"
#import <UIKit/UIScreen.h>

#define kCourseMenuParser @"kCourseMenuParser"
#define kCourseGlossaryParser @"kCourseGlossaryParser"
#define kCourseTestParser @"kCourseTestParser"
#define kCourseContentParser @"kCourseContentParser"

@interface LECourseParser () <NSXMLParserDelegate>

@property (strong, nonatomic) LECourse* course;
@property (strong, nonatomic) LECourseDetail* courseDetail;
@property (strong, nonatomic) LECourseLesson* currentLesson;

@property (strong, nonatomic) NSMutableArray* elementsArray;
@property (strong, nonatomic) NSMutableString* elementCharacters;
@property (strong, nonatomic) NSString* currentParser;
@property (strong, nonatomic) NSString* currentLessonPath;
@property (assign, nonatomic) BOOL isGlossaryElement;
@property (strong, nonatomic) NSMutableString* elementGlossary;
@property (strong, nonatomic) NSMutableString* elementTranscriptCharacters;


- (NSString*)clearnMediaPath:(NSString*)mediaPath;
- (NSString*)cleanCharacters:(NSString*)character;

@end


#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale >= 2.0))

@implementation LECourseParser


- (void)parseCourseDetail:(LECourse*)course rootPath: (NSString*)rootPath detail:(LECourseDetail**)detail error:(NSString**)error {
    @try {
        NSString* menuFile = [rootPath stringByAppendingPathComponent:@"menu.xml"];
        NSFileHandle *menuFileHandler = [NSFileHandle fileHandleForReadingAtPath:menuFile];
        NSData *menuFileData = [menuFileHandler readDataToEndOfFile];
        [menuFileHandler closeFile];
        if ([menuFileData length] == 0) {
            @throw [NSException exceptionWithName:@"zipError" reason:@"" userInfo:nil];
        }
        
        NSXMLParser *menuFileParser = [[NSXMLParser alloc] initWithData:menuFileData];
        [menuFileParser setDelegate:self];
        self.course = course;
        self.courseDetail = [[LECourseDetail alloc] init];
        self.elementsArray = [[NSMutableArray alloc] init];
        self.currentParser = kCourseMenuParser;
        [menuFileParser parse];
        
        if(IS_RETINA){
            self.courseDetail.cover = [rootPath stringByAppendingPathComponent:@"android_cover_hd.png"];
        }else{
            self.courseDetail.cover = [rootPath stringByAppendingPathComponent:@"android_cover.png"];
        }
        
        NSString* glossaryFile = [rootPath stringByAppendingPathComponent:@"glossary.xml"];
        NSFileHandle *glossaryFileHandler = [NSFileHandle fileHandleForReadingAtPath:glossaryFile];
        NSData *glossaryFileData = [glossaryFileHandler readDataToEndOfFile];
        [glossaryFileHandler closeFile];
        
        NSXMLParser *glossaryFileParser = [[NSXMLParser alloc] initWithData:glossaryFileData];
        [glossaryFileParser setDelegate:self];
        
        [self.elementsArray removeAllObjects];
        self.currentParser = kCourseGlossaryParser;
        [glossaryFileParser parse];
        
        
        NSString* testFile = [rootPath stringByAppendingPathComponent:@"test.xml"];
        NSFileHandle *testFileHandler = [NSFileHandle fileHandleForReadingAtPath:testFile];
        NSData *testFileData = [testFileHandler readDataToEndOfFile];
        [testFileHandler closeFile];
        
        NSXMLParser *testFileParser = [[NSXMLParser alloc] initWithData:testFileData];
        [testFileParser setDelegate:self];
        
        [self.elementsArray removeAllObjects];
//        self.currentParser = kCourseTestParser;
//        [testFileParser parse];
        
        int lessonIndex = 1;
        BOOL hasLessonFile = YES;
        while(hasLessonFile){
            NSString* lessonContentFile = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"lesson-%02d/content.xml", lessonIndex]];
            NSFileHandle *lessonContentFileHandler = [NSFileHandle fileHandleForReadingAtPath:lessonContentFile];
            if (lessonContentFileHandler != nil){
                NSData *lessonContentFileData = [lessonContentFileHandler readDataToEndOfFile];
                [lessonContentFileHandler closeFile];
                
                NSXMLParser *lessonContentFileParser = [[NSXMLParser alloc] initWithData:lessonContentFileData];
                [lessonContentFileParser setDelegate:self];
                
                [self.elementsArray removeAllObjects];
                self.currentLesson = [self.courseDetail.lessons objectAtIndex:lessonIndex-1];
                self.currentParser = kCourseContentParser;
                self.isGlossaryElement = NO;
                self.currentLessonPath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"lesson-%02d", lessonIndex]];
                [lessonContentFileParser parse];
                
                self.currentLesson.records = [NSIndexSet indexSet];
                
                lessonIndex += 1;
            }else{
                hasLessonFile = NO;
            }
        }
        
        *detail = self.courseDetail;
    }@catch (NSException* e) {
        //NSLog(@"%@", e.description);
        //NSLog(@"Invalid parsing for %@ %@", self.courseDetail.title, course.link);
        *error = e.description;
    }
}

- (NSString*)clearnMediaPath:(NSString*)mediaPath{
    NSString* mediaPathPrcessed = [NSString stringWithString:mediaPath];
    NSRange range = [mediaPathPrcessed rangeOfString:@"video\\"];
    if (range.location != NSNotFound){
        range.location = range.location + range.length;
        range.length = [mediaPathPrcessed length] - range.location;
        mediaPathPrcessed = [mediaPathPrcessed substringWithRange:range];
    } else {
        range = [mediaPathPrcessed rangeOfString:@"image\\"];
        if (range.location != NSNotFound){
            range.location = range.location + range.length;
            range.length = [mediaPathPrcessed length] - range.location;
            mediaPathPrcessed = [mediaPathPrcessed substringWithRange:range];
        }
    }
    return [mediaPathPrcessed stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

- (NSString*)cleanCharacters:(NSString*)characters{
    NSMutableString* theCharacters = [[NSMutableString alloc] initWithString:characters];
    while ([theCharacters hasSuffix:@"\n"]||[theCharacters hasSuffix:@"\t"]||[theCharacters hasPrefix:@"\n"]||[theCharacters hasPrefix:@"\t"]){
        while ([theCharacters hasSuffix:@"\t"]){
            [theCharacters deleteCharactersInRange:NSMakeRange([theCharacters length] - 1, 1)];
        }
        while ([theCharacters hasSuffix:@"\n"]){
            [theCharacters deleteCharactersInRange:NSMakeRange([theCharacters length] - 1, 1)];
        }
        while ([theCharacters hasPrefix:@"\t"]){
            [theCharacters deleteCharactersInRange:NSMakeRange(0, 1)];
        }
        while ([theCharacters hasPrefix:@"\n"]){
            [theCharacters deleteCharactersInRange:NSMakeRange(0, 1)];
        }
    }
    
    //    NSRange range = [theCharacters rangeOfString:@"／"];
    //    if (range.location != NSNotFound){
    //        [theCharacters deleteCharactersInRange:range];
    //    }
    //    if ([theCharacters rangeOfString:@"Coffee"].location != NSNotFound) {
    //        NSLog(theCharacters);
    //    }
    NSString* str = [theCharacters stringByReplacingOccurrencesOfString:@"([\n|\r])([ |\t]+)" withString:@"\n"];
    //    return [theCharacters autorelease];
    return str;
}

#pragma mark NSXMLParserDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser{
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
    
}

- (void)parser:(NSXMLParser *)parser foundNotationDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID{
}

- (void)parser:(NSXMLParser *)parser foundUnparsedEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID notationName:(NSString *)notationName{
}

- (void)parser:(NSXMLParser *)parser foundAttributeDeclarationWithName:(NSString *)attributeName forElement:(NSString *)elementName type:(NSString *)type defaultValue:(NSString *)defaultValue{
}

- (void)parser:(NSXMLParser *)parser foundElementDeclarationWithName:(NSString *)elementName model:(NSString *)model{
}

- (void)parser:(NSXMLParser *)parser foundInternalEntityDeclarationWithName:(NSString *)name value:(NSString *)value{
    
}

- (void)parser:(NSXMLParser *)parser foundExternalEntityDeclarationWithName:(NSString *)name publicID:(NSString *)publicID systemID:(NSString *)systemID{
    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
    if ([self.currentParser isEqualToString:kCourseContentParser]){
        if ([elementName isEqualToString:@"glossary"]){
            self.isGlossaryElement = YES;
            self.elementGlossary = [[NSMutableString alloc] init];
            return;
        }
        if (self.elementTranscriptCharacters) {
            [self.elementTranscriptCharacters appendString:@"<b>"];
        }
    }
    
    [self.elementsArray addObject:elementName];
    
    self.elementCharacters = [[NSMutableString alloc] init];
    
    NSString* currentElementName = [self.elementsArray lastObject];
    NSString* parentElementName = ([self.elementsArray count] > 1)?[self.elementsArray objectAtIndex:[self.elementsArray count] - 2]:nil;
    if ([self.currentParser isEqualToString:kCourseContentParser]){
        //NSLog(@"%@   %@", currentElementName, parentElementName);
        if ([parentElementName isEqualToString:@"items"] &&
            [currentElementName isEqualToString:@"item"]){
            NSString* type = [attributeDict objectForKey:@"type"];
            NSString* title = [attributeDict objectForKey:@"title"];
            NSString* audio = [attributeDict objectForKey:@"audio"];
            NSString* scoID = [attributeDict objectForKey:@"scoID"];
            self.course.mPageCount = [NSNumber numberWithInt:[self.course.mPageCount intValue]+1];
            self.currentLesson.mPageCount = [NSNumber numberWithInt:[self.currentLesson.mPageCount intValue]+1];
            
            LECourseLessonSection* lessonSection = [[LECourseLessonSection alloc] init];
            lessonSection.title = title;
            lessonSection.scoID = scoID;
            if (audio != nil){
                lessonSection.audio = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/audio/%@", audio]];
            }
            lessonSection.index = (self.currentLesson.sections == nil)?0:(int)[self.currentLesson.sections count];
            if ([type isEqualToString:@"B"] ||
                [type isEqualToString:@"C"]){
                if (lessonSection.items == nil){
                    LECourseLessonOptionTestItem * lessonSectionItem = [[LECourseLessonOptionTestItem alloc] init];
                    lessonSectionItem.index = 0;
                    lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
                }else{
                    LECourseLessonOptionTestItem * lessonSectionItem = [[LECourseLessonOptionTestItem alloc] init];
                    NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                    lessonSectionItem.index = [lessonSectionItems count];
                    [lessonSectionItems addObject:lessonSectionItem];
                    lessonSection.items = lessonSectionItems;
                }
            }else if ([type isEqualToString:@"D"]){
                if (lessonSection.items == nil){
                    LECourseLessonStatementTestItem * lessonSectionItem = [[LECourseLessonStatementTestItem alloc] init];
                    lessonSectionItem.index = 0;
                    lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
                }else{
                    LECourseLessonStatementTestItem * lessonSectionItem = [[LECourseLessonStatementTestItem alloc] init];
                    NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                    lessonSectionItem.index = [lessonSection.items count];
                    [lessonSectionItems addObject:lessonSectionItem];
                    lessonSection.items = lessonSectionItems;
                }
            }else if ([type isEqualToString:@"E"]){
                NSString* video = [attributeDict objectForKey:@"url"];
                NSString* image = [attributeDict objectForKey:@"ppt"];
                NSString* next = [attributeDict objectForKey:@"auto_next"];
                
                video = [self clearnMediaPath:video];
                image = [self clearnMediaPath:image];
                
                if (lessonSection.items == nil){
                    LECourseLessonPPTItem * lessonPPTItem = [[LECourseLessonPPTItem alloc] init];
                    lessonPPTItem.video = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/video/%@", video]];
                    lessonPPTItem.image = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/image/%@", image]];
                    lessonPPTItem.next = [next isEqualToString:@"true"]?YES:NO;
                    lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonPPTItem];
                    lessonPPTItem.index = 0;
                }else{
                    LECourseLessonPPTItem * lessonPPTItem = [[LECourseLessonPPTItem alloc] init];
                    lessonPPTItem.video = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/video/%@", video]];
                    lessonPPTItem.image = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/image/%@", image]];
                    lessonPPTItem.next = [next isEqualToString:@"true"]?YES:NO;
                    NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                    lessonPPTItem.index = [lessonSection.items count];
                    [lessonSectionItems addObject:lessonPPTItem];
                    lessonSection.items = lessonSectionItems;
                }
            }
            NSMutableArray<LECourseLessonSection>* lessonSections = [NSMutableArray<LECourseLessonSection> arrayWithArray:self.currentLesson.sections];
            [lessonSections addObject:lessonSection];
            self.currentLesson.sections = lessonSections;
        }else if ([parentElementName isEqualToString:@"item"] &&
                  [currentElementName isEqualToString:@"para_image"]){
            NSString* url = [attributeDict objectForKey:@"url"];
            url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if (url != nil && [url isEqualToString:@""] == NO){
                url = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/image/%@", url]];
                LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                if (lessonSection.items == nil){
                    LECourseLessonImageItem * lessonSectionItem = [[LECourseLessonImageItem alloc] init];
                    lessonSectionItem.image = url;
                    lessonSectionItem.index = 0;
                    lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
                }else{
                    LECourseLessonImageItem * lessonSectionItem = [[LECourseLessonImageItem alloc] init];
                    lessonSectionItem.image = url;
                    NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                    lessonSectionItem.index = [lessonSection.items count];
                    [lessonSectionItems addObject:lessonSectionItem];
                    lessonSection.items = lessonSectionItems;
                }
            }else{
                NSLog(@"Error when parsing image");
            }
        }else if ([parentElementName isEqualToString:@"item"] &&
                  [currentElementName isEqualToString:@"para_video"]){
            NSString* url = [attributeDict objectForKey:@"url"];
            NSString* conver = [attributeDict objectForKey:@"icon"];
            url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            if(url == nil || conver == nil){
                
                return;
            }
            if (url != nil && [url isEqualToString:@""] == NO){
                url = [self clearnMediaPath:url];
                if([conver isEqualToString:@""] == NO){
                    conver = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/video/%@", conver]];
                }
                url = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/video/%@", url]];
                LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                if (lessonSection.items == nil){
                    LECourseLessonVideoItem * lessonSectionItem = [[LECourseLessonVideoItem alloc] init];
                    lessonSectionItem.video = url;
                    lessonSectionItem.index = 0;
                    lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
                }else{
                    LECourseLessonVideoItem * lessonSectionItem = [[LECourseLessonVideoItem alloc] init];
                    lessonSectionItem.video = url;
                    NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                    lessonSectionItem.index = [lessonSection.items count];
                    [lessonSectionItems addObject:lessonSectionItem];
                    lessonSection.items = lessonSectionItems;
                }
            }else{
                NSLog(@"Error when parsing video");
            }
        }else if ([parentElementName isEqualToString:@"item"] &&
                  [currentElementName isEqualToString:@"thinkaboutit"]){
            LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
            if (lessonSection.items == nil){
                LECourseLessonThinkTextItem * lessonSectionItem = [[LECourseLessonThinkTextItem alloc] init];
                lessonSectionItem.index = 0;
                lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
                [((NSMutableArray*)lessonSection.items) addObject:lessonSectionItem];
            }else{
                LECourseLessonThinkTextItem * lessonSectionItem = [[LECourseLessonThinkTextItem alloc] init];
                NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                lessonSectionItem.index = [lessonSection.items count];
                [lessonSectionItems addObject:lessonSectionItem];
                lessonSection.items = lessonSectionItems;
            }
        }else if([parentElementName isEqualToString:@"item"] &&
                 [currentElementName isEqualToString:@"f_audio"]){
            LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count]-1];
            LECourseLessonLEIAudioItem* lessonSectionItem = [[LECourseLessonLEIAudioItem alloc] init];
            if(lessonSection.items == nil){
                lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
                lessonSection.index = 0;
            }else{
                lessonSectionItem.index = [lessonSection.items count];
                NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                [lessonSectionItems addObject:lessonSectionItem];
                lessonSection.items = lessonSectionItems;
            }
        }else if([parentElementName isEqualToString:@"item"] &&
                 [currentElementName isEqualToString:@"f_video"]){
            LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count]-1];
            LECourseLessonLEIVideoItem* lessonSectionItem = [[LECourseLessonLEIVideoItem alloc] init];
            if(lessonSection.items == nil){
                //初始化数组，并添加lessonSectionItem
                //创建具有一个元素的数组
                lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
                lessonSection.index = 0;
            }else{
                lessonSectionItem.index = [lessonSection.items count];
                NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                [lessonSectionItems addObject:lessonSectionItem];
                lessonSection.items = lessonSectionItems;
            }
        }else if([parentElementName isEqualToString:@"item"] &&
                 [currentElementName isEqualToString:@"practice"]){
            LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count]-1];
            LECourseLessonLEIPracticeItem* lessonSectionItem = [[LECourseLessonLEIPracticeItem alloc] init];
            if(lessonSection.items == nil){
                lessonSection.index = 0;
                lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
            }else{
                lessonSectionItem.index = [lessonSection.items count];
                NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                [lessonSectionItems addObject:lessonSectionItem];
                lessonSection.items = lessonSectionItems;
            }
            lessonSection.hasPractice = YES;
        }else if([parentElementName isEqualToString:@"practice"] &&
                 [currentElementName isEqualToString:@"exer"]){
            LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count]-1];
            LECourseLessonLEIPracticeItem* lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count] - 1];
            LECourseLessonLEIPracticeQuestion* practiceQuestion = [[LECourseLessonLEIPracticeQuestion alloc] init];
            if(lessonSectionItem.questions == nil){
                practiceQuestion.index = 0;
                lessonSectionItem.questions = [NSArray<LECourseLessonLEIPracticeQuestion> arrayWithObject:practiceQuestion];
            }else{
                practiceQuestion.index = (int)[lessonSectionItem.questions count];
                NSMutableArray<LECourseLessonLEIPracticeQuestion>* questions = [NSMutableArray<LECourseLessonLEIPracticeQuestion> arrayWithArray:lessonSectionItem.questions];
                [questions addObject:practiceQuestion];
                lessonSectionItem.questions = questions;
            }
        }else if([parentElementName isEqualToString:@"exer"] &&
                 [currentElementName isEqualToString:@"option"]){
            NSString* image = [attributeDict objectForKey:@"imagefile"];
            NSString* audio = [attributeDict objectForKey:@"audiofile"];
            if([image length] > 0){
                image = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/image/%@", image]];
            }
            if([audio length] > 0){
                audio = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/audio/%@", audio]];
            }
            LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
            LECourseLessonLEIPracticeItem* lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count] - 1];
            NSUInteger index = [lessonSectionItem.questions count] - 1;
            LECourseLessonLEIPracticeQuestion* practiceQuestion = [lessonSectionItem.questions objectAtIndex:index];
            if(practiceQuestion.images == nil){
                practiceQuestion.images = [NSArray arrayWithObject:image];
            }else{
                NSMutableArray* images = [NSMutableArray arrayWithArray:practiceQuestion.images];
                [images addObject:image];
                practiceQuestion.images = images;
            }
            
            if (practiceQuestion.audios == nil) {
                practiceQuestion.audios = [NSArray arrayWithObject:audio];
            }else{
                NSMutableArray* audios = [NSMutableArray arrayWithArray:practiceQuestion.audios];
                [audios addObject:audio];
                practiceQuestion.audios = audios;
            }
            
        }else if([parentElementName isEqualToString:@"item"] &&
                 [currentElementName isEqualToString:@"f_image"]){
            NSString* url = [attributeDict objectForKey:@"url"];
            if ([url isEqualToString:@""] == NO) {
                url = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/image/%@", url]];
                LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                LECourseLessonLEIPlainImageItem* lessonSectionItem = [[LECourseLessonLEIPlainImageItem alloc] init];
                lessonSectionItem.image = url;
                if (lessonSection.items == nil) {
                    lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
                    lessonSectionItem.index = 0;
                }else{
                    lessonSectionItem.index = [lessonSection.items count];
                    NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                    [lessonSectionItems addObject:lessonSectionItem];
                    lessonSection.items = lessonSectionItems;
                }
            }else{
                NSLog(@"Error when parsing image");
            }
        }else if([parentElementName isEqualToString:@"item"] &&
                 [currentElementName isEqualToString:@"roleplay"]){
            LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count]-1];
            LECourseLessonLEIRolePlayItem* lessonSectionItem = [[LECourseLessonLEIRolePlayItem alloc] init];
            
            if (lessonSection.items == nil) {
                lessonSectionItem.index = 0;
                lessonSection.items = [NSMutableArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
            }else{
                NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                lessonSectionItem.index = [lessonSectionItems count];
                [lessonSectionItems addObject:lessonSectionItem];
                lessonSection.items = lessonSectionItems;
            }
            
            NSString* cover = [attributeDict objectForKey:@"starterImage"];
            NSString* video = [attributeDict objectForKey:@"fullVideofile"];
            NSString* speaker1Name = [attributeDict objectForKey:@"speaker1Name"];
            NSString* speaker2Name = [attributeDict objectForKey:@"speaker2Name"];
            NSString* speaker1Image = [[attributeDict objectForKey:@"speaker1Picture"] lowercaseString];
            NSString* speaker2Image = [[attributeDict objectForKey:@"speaker2Picture"] lowercaseString];
            
            speaker1Image = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/image/%@", speaker1Image]];
            speaker2Image = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/image/%@", speaker2Image]];
            
            cover = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/image/%@", cover]];
            video = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/video/%@", video]];
            
            lessonSectionItem.cover = cover;
            lessonSectionItem.video = video;
            
            NSMutableArray* speakerNames = [[NSMutableArray alloc] init];
            [speakerNames addObject:speaker1Name];
            [speakerNames addObject:speaker2Name];
            lessonSectionItem.speakerNames = speakerNames;
            
            NSMutableArray* speakerImages = [[NSMutableArray alloc] init];
            [speakerImages addObject:speaker1Image];
            [speakerImages addObject:speaker2Image];
            lessonSectionItem.speakerImages = speakerImages;
        }else if([parentElementName isEqualToString:@"roleplay"] &&
                 [currentElementName isEqualToString:@"dialog"]){
            LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
            LECourseLessonLEIRolePlayItem* lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count] - 1];
            LECourseLessonLEIRolePlayDialog* dialog = [[LECourseLessonLEIRolePlayDialog alloc] init];
            if (lessonSectionItem.speakerDialogs == nil) {
                lessonSectionItem.speakerDialogs = [NSMutableArray<LECourseLessonLEIRolePlayDialog> arrayWithObject:dialog];
            }else{
                NSMutableArray<LECourseLessonLEIRolePlayDialog>* dialogs = [NSMutableArray<LECourseLessonLEIRolePlayDialog> arrayWithArray:lessonSectionItem.speakerDialogs];
                [dialogs addObject:dialog];
                lessonSectionItem.speakerDialogs = dialogs;
            }
        }else if([parentElementName isEqualToString:@"item"] &&
                 [currentElementName isEqualToString:@"audiotext"]){
            LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
            LECourseLessonLEIAudioTextItem* lessonSectionItem = [[LECourseLessonLEIAudioTextItem alloc] init];
            if (lessonSection.items == nil) {
                lessonSectionItem.index = 0;
                lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
            }else{
                NSMutableArray<LECourseLessonSectionItem>* items = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                lessonSectionItem.index = [items count];
                [items addObject:lessonSectionItem];
                lessonSection.items = items;
            }
        }else if([parentElementName isEqualToString:@"audiotext"] &&
                 [currentElementName isEqualToString:@"subaudiotext"]){
            LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
            LECourseLessonLEIAudioTextItem* lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count] - 1];
            LECourseLessonLEIAudioText* lessonLeiAudioText = [[LECourseLessonLEIAudioText alloc] init];
            if (lessonSectionItem.audioTexts == nil) {
                lessonSectionItem.audioTexts = [NSArray<LECourseLessonLEIAudioText> arrayWithObject:lessonLeiAudioText];
            }else{
                NSMutableArray<LECourseLessonLEIAudioText>* audioTexts = [NSMutableArray<LECourseLessonLEIAudioText> arrayWithArray:lessonSectionItem.audioTexts];
                [audioTexts addObject:lessonLeiAudioText];
                lessonSectionItem.audioTexts = audioTexts;
            }
            
            NSString* audio = [attributeDict objectForKey:@"audiofile"];
            audio = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/audio/%@", audio]];
            lessonLeiAudioText.audio = audio;
            if (self.elementTranscriptCharacters) {
                [self.elementTranscriptCharacters setString:@""];
            }else{
                self.elementTranscriptCharacters = [[NSMutableString alloc] init];
            }
        }else if([parentElementName isEqualToString:@"item"] &&
                 [currentElementName isEqualToString:@"audresp"]){
            LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
            LECourseLessonLEIAudioResponseItem* lessonSectionItem = [[LECourseLessonLEIAudioResponseItem alloc] init];
            NSString* minutimes = [attributeDict objectForKey:@"minutimes"];
            if (minutimes) {
                lessonSection.recordCount = [minutimes intValue];
                lessonSectionItem.total = [minutimes intValue];
            }else{
                lessonSectionItem.total = 1;
            }
            if (lessonSection.items == nil) {
                lessonSectionItem.index = 0;
                lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
            }else{
                NSMutableArray<LECourseLessonSectionItem>* items = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                lessonSectionItem.index = [items count];
                [items addObject:lessonSectionItem];
                lessonSection.items = items;
            }
            lessonSection.hasPractice = YES;
        }else if([parentElementName isEqualToString:@"audresp"] &&
                 [currentElementName isEqualToString:@"audioresponse"]){
            LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
            LECourseLessonLEIAudioResponseItem* lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count] - 1];
            LECourseLessonLEIAudioResponse* response = [[LECourseLessonLEIAudioResponse alloc] init];
            
            if (lessonSectionItem.responses == nil) {
                lessonSectionItem.responses = [NSArray<LECourseLessonLEIAudioResponse> arrayWithObject:response];
            }else{
                NSMutableArray<LECourseLessonLEIAudioResponse>* responses = [NSMutableArray<LECourseLessonLEIAudioResponse> arrayWithArray:lessonSectionItem.responses];
                [responses addObject:response];
                lessonSectionItem.responses = responses;
            }
            
            NSString* playback = [attributeDict objectForKey:@"playback"];
            response.playback = playback;
        }else if([parentElementName isEqualToString:@"item"] &&
                 [currentElementName isEqualToString:@"reading"]){
            if (self.elementTranscriptCharacters) {
                [self.elementTranscriptCharacters setString:@""];
            }else{
                self.elementTranscriptCharacters = [[NSMutableString alloc] init];
            }
        }else if(parentElementName && ([parentElementName isEqualToString:@"f_video"] ||
                                       [parentElementName isEqualToString:@"f_audio"] ||
                                       [parentElementName isEqualToString:@"dialog"])
                 && [currentElementName isEqualToString:@"transcript"]){
            if (self.elementTranscriptCharacters) {
                [self.elementTranscriptCharacters setString:@""];
            }else{
                self.elementTranscriptCharacters = [[NSMutableString alloc] init];
            }
        }else if(parentElementName && [parentElementName isEqualToString:@"item"]
                 && [currentElementName isEqualToString:@"f_text"]){
            if (self.elementTranscriptCharacters) {
                [self.elementTranscriptCharacters setString:@""];
            }else{
                self.elementTranscriptCharacters = [[NSMutableString alloc] init];
            }
        }else if ([parentElementName isEqualToString:@"item"] &&
                  [currentElementName isEqualToString:@"statement"]){
            LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
            LECourseLessonStatementTestItem * lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count]-1];
            NSString* answerString = [attributeDict objectForKey:@"answer"];
            NSNumber* answerNumber = [NSNumber numberWithInt:([answerString isEqualToString:@"true"])?1:0];
            if (lessonSectionItem.answers == nil){
                lessonSectionItem.answers = [NSArray arrayWithObject:answerNumber];
            }else{
                NSMutableArray* answers = [NSMutableArray arrayWithArray:lessonSectionItem.answers];
                [answers addObject:answerNumber];
                lessonSectionItem.answers = answers;
            }
        }
    }else if ([self.currentParser isEqualToString:kCourseGlossaryParser]){
        if ([currentElementName isEqualToString:@"glossary"]){
            if (self.courseDetail.glossaries == nil){
                LECourseGlossary* glossary = [[LECourseGlossary alloc] init];
                NSMutableArray<LECourseGlossary>* glossaries = [NSMutableArray<LECourseGlossary> arrayWithObject:glossary];
                self.courseDetail.glossaries = glossaries;
            }else{
                NSMutableArray<LECourseGlossary>* glossaries = [NSMutableArray<LECourseGlossary> arrayWithArray:self.courseDetail.glossaries];
                LECourseGlossary* glossary = [[LECourseGlossary alloc] init];
                [glossaries addObject:glossary];
                self.courseDetail.glossaries = glossaries;
            }
        }
    }if ([self.currentParser isEqualToString:kCourseTestParser]){
        if ([parentElementName isEqualToString:@"items"] &&
            [currentElementName isEqualToString:@"item"]){
            
            if (self.courseDetail.tests == nil){
                LECourseTestSection* testSection = [[LECourseTestSection alloc] init];
                testSection.title = @"课程测试";
                testSection.index = 0;
                self.courseDetail.tests = [NSArray<LECourseTestSection> arrayWithObject:testSection];
                LECourseTestSectionOptionItem* testOptionItem = [[LECourseTestSectionOptionItem alloc] init];
                testSection.items = [NSArray arrayWithObject:testOptionItem];
            }else{
                LECourseTestSection* testSection = [[LECourseTestSection alloc] init];
                testSection.title = @"课程测试";
                testSection.index = [self.courseDetail.tests count];
                NSMutableArray<LECourseTestSection>* testSections = [NSMutableArray<LECourseTestSection> arrayWithArray:self.courseDetail.tests];
                [testSections addObject:testSection];
                self.courseDetail.tests = testSections;
                LECourseTestSectionOptionItem* testOptionItem = [[LECourseTestSectionOptionItem alloc] init];
                testSection.items = [NSArray arrayWithObject:testOptionItem];
            }
        }else if (parentElementName && [parentElementName isEqualToString:@"item"] &&
                  [currentElementName isEqualToString:@"option"]){
            NSString* image = [attributeDict objectForKey:@"imagefile"];
            NSString* audio = [attributeDict objectForKey:@"audiofile"];
            if (image) {
                image = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/image/%@", image]];
            }
            if (audio) {
                audio = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/audio/%@", audio]];
            }
            
            if (image && audio) {
                LECourseTestSection* testSection = [self.courseDetail.tests objectAtIndex:[self.courseDetail.tests count] - 1];
                LECourseTestSectionOptionItem* testOptionItem = [testSection.items objectAtIndex:[testSection.items count] - 1];
                if (testOptionItem.images) {
                    NSMutableArray* images = [NSMutableArray arrayWithArray:testOptionItem.images];
                    [images addObject:image];
                    testOptionItem.images = images;
                }else{
                    testOptionItem.images = [NSArray arrayWithObject:image];
                }
                if (testOptionItem.audios) {
                    NSMutableArray* audios = [NSMutableArray arrayWithArray:testOptionItem.audios];
                    [audios addObject:audios];
                    testOptionItem.audios = audios;
                }else{
                    testOptionItem.audios = [NSArray arrayWithObject:audio];
                }
            }
        }
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    if ([self.currentParser isEqualToString:kCourseContentParser]){
        if ([elementName isEqualToString:@"glossary"]){
            self.isGlossaryElement = NO;
            if ([self.elementGlossary length] > 0){
                [self.elementCharacters appendString:@"u"];
                [self.elementCharacters appendString:self.elementGlossary];
                [self.elementCharacters appendString:@"u"];
                
                if (self.elementTranscriptCharacters) {
                    [self.elementTranscriptCharacters appendString:@"u"];
                    [self.elementTranscriptCharacters appendString:self.elementGlossary];
                    [self.elementTranscriptCharacters appendString:@"u"];
                }
            }
            self.elementGlossary = nil;
            
            return;
        }
        if (self.elementTranscriptCharacters) {
            if (![elementName isEqualToString:@"transcript"] &&
                ![elementName isEqualToString:@"subaudiotext"] &&
                ![elementName isEqualToString:@"reading"] &&
                ![elementName isEqualToString:@"f_text"]) {
                [self.elementTranscriptCharacters appendString:@"</b>"];
            }
        }
    }
    if ([self.elementCharacters length] > 0){
        
        NSString* currentElementName = [self.elementsArray lastObject];
        NSString* parentElementName = ([self.elementsArray count] > 1)?[self.elementsArray objectAtIndex:[self.elementsArray count] - 2]:nil;
        //Debug(@"%@ %@", currentElementName, self.elementCharacters);
        if ([self.currentParser isEqualToString:kCourseMenuParser]){
            if ([parentElementName isEqualToString:@"course"]){
                if([currentElementName isEqualToString:@"title"]) {
                    self.courseDetail.title = [NSString stringWithString:self.elementCharacters];
                }else if([currentElementName isEqualToString:@"type"]) {
                    self.courseDetail.type = [NSString stringWithString:self.elementCharacters];
                }else if([currentElementName isEqualToString:@"credit"]) {
                    self.courseDetail.credit = [self.elementCharacters floatValue];
                }else if([currentElementName isEqualToString:@"validity"]) {
                    self.courseDetail.validity = [self.elementCharacters intValue];
                }else if([currentElementName isEqualToString:@"mintime"]) {
                    self.courseDetail.mintime = [self.elementCharacters intValue];
                }else if([currentElementName isEqualToString:@"minratio"]) {
                    self.courseDetail.minratio = [self.elementCharacters intValue];
                }else if([currentElementName isEqualToString:@"passmark"]) {
                    self.courseDetail.passmark = [self.elementCharacters intValue];
                }else if([currentElementName isEqualToString:@"intro"]) {
                    self.courseDetail.introduction = [NSString stringWithString:self.elementCharacters];;
                }else if([currentElementName isEqualToString:@"lo"]) {
                    self.courseDetail.objective = [NSString stringWithString:self.elementCharacters];;
                }
            }else if ([parentElementName isEqualToString:@"item"] && [self.elementsArray count] == 5){
                if([currentElementName isEqualToString:@"title"]) {
                    NSUInteger lessonIndex = (self.courseDetail.lessons == nil)?0:[self.courseDetail.lessons count];
                    LECourseLesson* lesson = [[LECourseLesson alloc] init];
                    lesson.identifier = [NSString stringWithFormat:@"%d", self.course.identifier];
                    lesson.title = [NSString stringWithString:self.elementCharacters];
                    lesson.index = (int)lessonIndex;
                    if (self.courseDetail.lessons == nil){
                        NSMutableArray<LECourseLesson>* lessons = [NSMutableArray<LECourseLesson> arrayWithObject:lesson];
                        self.courseDetail.lessons = lessons;
                    }else{
                        NSMutableArray<LECourseLesson>* lessons = [NSMutableArray<LECourseLesson> arrayWithArray:self.courseDetail.lessons];
                        [lessons addObject:lesson];
                        self.courseDetail.lessons = lessons;
                    }
                }
            }
        }else if ([self.currentParser isEqualToString:kCourseContentParser]) {
            if ([parentElementName isEqualToString:@"item"]){
                if([currentElementName isEqualToString:@"para_text"]) {
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    if (lessonSection.items == nil){
                        LECourseLessonPlainTextItem * lessonSectionItem = [[LECourseLessonPlainTextItem alloc] init];
                        lessonSectionItem.text = self.elementCharacters;
                        lessonSectionItem.index = 0;
                        lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
                    }else{
                        LECourseLessonPlainTextItem * lessonSectionItem = [[LECourseLessonPlainTextItem alloc] init];
                        lessonSectionItem.text = self.elementCharacters;
                        NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                        lessonSectionItem.index = [lessonSectionItems count];
                        [lessonSectionItems addObject:lessonSectionItem];
                        lessonSection.items = lessonSectionItems;
                    }
                }else if([currentElementName isEqualToString:@"para_li"]) {
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    NSArray* components = [self.elementCharacters componentsSeparatedByString:@"•"];
                    NSMutableArray* list = [[NSMutableArray alloc] init];
                    for (NSString* component in components){
                        NSString* listString = [self cleanCharacters:component];
                        listString = [listString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                        if ([listString isEqualToString:@""] == NO){
                            //[list addObject:[NSString stringWithFormat:@"• %@", listString]];
                            [list addObject:listString];
                        }
                    }
                    if (lessonSection.items == nil){
                        LECourseLessonPlainTextItem * lessonPlainTextItem = [[LECourseLessonPlainTextItem alloc] init];
                        lessonPlainTextItem.text = @"";
                        lessonPlainTextItem.index = 0;
                        lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonPlainTextItem];
                    }else{
                        LECourseLessonSectionItem* lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count]-1];
                        if (lessonSectionItem.type != LECourseLessonSectionItemTypePlainText){
                            LECourseLessonPlainTextItem * lessonPlainTextItem = [[LECourseLessonPlainTextItem alloc] init];
                            lessonPlainTextItem.text = @"";
                            NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                            lessonPlainTextItem.index = [lessonSectionItems count];
                            [lessonSectionItems addObject:lessonPlainTextItem];
                            lessonSection.items = lessonSectionItems;
                        }
                    }
                    LECourseLessonPlainTextItem * lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count]-1];
                    lessonSectionItem.list = list;
                }else if([currentElementName isEqualToString:@"diduknow"]) {
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    if (lessonSection.items == nil){
                        LECourseLessonDidYouKnowTextItem * lessonSectionItem = [[LECourseLessonDidYouKnowTextItem alloc] init];
                        lessonSectionItem.text = self.elementCharacters;
                        lessonSectionItem.index = 0;
                        lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
                    }else{
                        LECourseLessonDidYouKnowTextItem * lessonSectionItem = [[LECourseLessonDidYouKnowTextItem alloc] init];
                        lessonSectionItem.text = self.elementCharacters;
                        NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                        lessonSectionItem.index = [lessonSectionItems count];
                        [lessonSectionItems addObject:lessonSectionItem];
                        lessonSection.items = lessonSectionItems;
                    }
                }else if([currentElementName isEqualToString:@"example"]) {
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    if (lessonSection.items == nil){
                        LECourseLessonExampleTextItem * lessonSectionItem = [[LECourseLessonExampleTextItem alloc] init];
                        lessonSectionItem.text = self.elementCharacters;
                        lessonSectionItem.index = 0;
                        lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
                    }else{
                        LECourseLessonExampleTextItem * lessonSectionItem = [[LECourseLessonExampleTextItem alloc] init];
                        lessonSectionItem.text = self.elementCharacters;
                        NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                        lessonSectionItem.index = [lessonSectionItems count];
                        [lessonSectionItems addObject:lessonSectionItem];
                        lessonSection.items = lessonSectionItems;
                    }
                }else if([currentElementName isEqualToString:@"remember"]) {
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    if (lessonSection.items == nil){
                        LECourseLessonRememberTextItem * lessonRememberTextItem = [[LECourseLessonRememberTextItem alloc] init];
                        lessonRememberTextItem.text = self.elementCharacters;
                        lessonRememberTextItem.index = 0;
                        lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonRememberTextItem];
                    }else{
                        LECourseLessonRememberTextItem * lessonRememberTextItem = [[LECourseLessonRememberTextItem alloc] init];
                        lessonRememberTextItem.text = self.elementCharacters;
                        NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                        lessonRememberTextItem.index = [lessonSectionItems count];
                        [lessonSectionItems addObject:lessonRememberTextItem];
                        lessonSection.items = lessonSectionItems;
                    }
                }else if([currentElementName isEqualToString:@"important"]) {
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    if (lessonSection.items == nil){
                        LECourseLessonImportantTextItem * lessonImportantTextItem = [[LECourseLessonImportantTextItem alloc] init];
                        lessonImportantTextItem.text = self.elementCharacters;
                        lessonImportantTextItem.index = 0;
                        lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonImportantTextItem];
                    }else{
                        LECourseLessonImportantTextItem * lessonImportantTextItem = [[LECourseLessonImportantTextItem alloc] init];
                        lessonImportantTextItem.text = self.elementCharacters;
                        NSMutableArray<LECourseLessonSectionItem>* lessonSectionItems = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                        lessonImportantTextItem.index = [lessonSectionItems count];
                        [lessonSectionItems addObject:lessonImportantTextItem];
                        lessonSection.items = lessonSectionItems;
                    }
                }else if([currentElementName isEqualToString:@"question"]) {
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    LECourseLessonOptionTestItem * lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count]-1];
                    lessonSectionItem.question = self.elementCharacters;
                }else if([currentElementName isEqualToString:@"option"]) {
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    LECourseLessonOptionTestItem * lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count]-1];
                    if (lessonSectionItem.options == nil){
                        lessonSectionItem.options = [NSArray arrayWithObject:self.elementCharacters];
                    }else{
                        NSMutableArray* options = [NSMutableArray arrayWithArray:lessonSectionItem.options];
                        [options addObject:self.elementCharacters];
                        lessonSectionItem.options = options;
                    }
                }else if([currentElementName isEqualToString:@"answer"]) {
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    LECourseLessonOptionTestItem * lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count]-1];
                    lessonSectionItem.answers = [self.elementCharacters componentsSeparatedByString:@","];
                }else if([currentElementName isEqualToString:@"feedback"]) {
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    LECourseLessonOptionTestItem * lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count]-1];
                    lessonSectionItem.feedback = self.elementCharacters;
                }
                
                //<note>判断下列描述是否正确。</note>
                //<statement answer="true">风险上升通常会伴随回报的增加。</statement>
                
                else if([currentElementName isEqualToString:@"note"]) {
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    LECourseLessonStatementTestItem * lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count]-1];
                    lessonSectionItem.note = self.elementCharacters;
                }else if([currentElementName isEqualToString:@"statement"]) {
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    LECourseLessonStatementTestItem * lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count]-1];
                    if (lessonSectionItem.statements == nil){
                        lessonSectionItem.statements = [NSArray arrayWithObject:self.elementCharacters];
                    }else{
                        NSMutableArray* statements = [NSMutableArray arrayWithArray:lessonSectionItem.statements];
                        [statements addObject:self.elementCharacters];
                        lessonSectionItem.statements = statements;
                    }
                }else if ([currentElementName isEqualToString:@"f_text"]){
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    LECourseLessonLEIPlainTextItem* lessonSectionItem = [[LECourseLessonLEIPlainTextItem alloc] init];
                    lessonSectionItem.text = self.elementTranscriptCharacters;
                    if (lessonSection.items) {
                        NSMutableArray<LECourseLessonSectionItem>* items = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                        lessonSectionItem.index = [items count];
                        [items addObject:lessonSectionItem];
                        lessonSection.items = items;
                    }else{
                        lessonSectionItem.index = 0;
                        lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
                    }
                    self.elementTranscriptCharacters = nil;
                }else if ([currentElementName isEqualToString:@"reading"]){
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    LECourseLessonLEIReadingItem* lessonSectionItem = [[LECourseLessonLEIReadingItem alloc] init];
                    lessonSectionItem.text = [self cleanCharacters:self.elementTranscriptCharacters];
                    //                    elementTranscriptCharacters;
                    if (lessonSection.items) {
                        NSMutableArray<LECourseLessonSectionItem>* items = [NSMutableArray<LECourseLessonSectionItem> arrayWithArray:lessonSection.items];
                        lessonSectionItem.index = [items count];
                        [items addObject:lessonSectionItem];
                        lessonSection.items = items;
                    }else{
                        lessonSectionItem.index = 0;
                        lessonSection.items = [NSArray<LECourseLessonSectionItem> arrayWithObject:lessonSectionItem];
                    }
                    self.elementTranscriptCharacters = nil;
                }
            }else if ([parentElementName isEqualToString:@"thinkaboutit"]){
                if([currentElementName isEqualToString:@"title"] ||
                   [currentElementName isEqualToString:@"question"]) {
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    LECourseLessonThinkTextItem * lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count]-1];
                    lessonSectionItem.text = self.elementCharacters;
                }else if([currentElementName isEqualToString:@"answer"]) {
                    LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                    LECourseLessonThinkTextItem * lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count]-1];
                    lessonSectionItem.answer = self.elementCharacters;
                }
            }else if([parentElementName isEqualToString:@"f_audio"]){
                LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                LECourseLessonLEIAudioItem* lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count] - 1];
                if ([currentElementName isEqualToString:@"direction"]) {
                    lessonSectionItem.direction = self.elementCharacters;
                }else if ([currentElementName isEqualToString:@"audiopost"]){
                    NSString* cover = self.elementCharacters;
                    cover = [self clearnMediaPath:cover];
                    cover = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/image/%@", cover]];
                    lessonSectionItem.cover = cover;
                }else if ([currentElementName isEqualToString:@"audiofile"]){
                    NSString* audio = self.elementCharacters;
                    audio = [self clearnMediaPath:audio];
                    audio = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/audio/%@", audio]];
                    lessonSectionItem.audio = audio;
                }else if ([self.currentLessonPath isEqualToString:@"transcript"]){
                    NSString* transcript = [self cleanCharacters:self.elementTranscriptCharacters];
                    lessonSectionItem.transcript = transcript;
                    self.elementTranscriptCharacters = nil;
                }
            }else if ([parentElementName isEqualToString:@"f_video"]){
                LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                LECourseLessonLEIVideoItem* lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count] - 1];
                if ([currentElementName isEqualToString:@"direction"]) {
                    lessonSectionItem.direction = self.elementCharacters;
                }else if ([currentElementName isEqualToString:@"videopost"]){
                    NSString* cover = self.elementCharacters;
                    cover = [self clearnMediaPath:cover];
                    cover = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/image/%@", cover]];
                    lessonSectionItem.cover = cover;
                }else if([currentElementName isEqualToString:@"videofile"]){
                    NSString* video = self.elementCharacters;
                    video = [self clearnMediaPath:video];
                    video = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/video/%@", video]];
                    lessonSectionItem.video = video;
                }else if ([currentElementName isEqualToString:@"transcript"]){
                    NSString* trancript = [self cleanCharacters:self.elementTranscriptCharacters];
                    lessonSectionItem.transcript = trancript;
                    self.elementTranscriptCharacters = nil;
                }
            }else if ([parentElementName isEqualToString:@"exer"]){
                LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                LECourseLessonLEIPracticeItem* lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count] - 1];
                NSUInteger index = [lessonSectionItem.questions count] - 1;
                LECourseLessonLEIPracticeQuestion* question = [lessonSectionItem.questions objectAtIndex:index];
                if([currentElementName isEqualToString:@"question"]) {
                    question.question = self.elementCharacters;
                }else if([currentElementName isEqualToString:@"option"]) {
                    if (question.options == nil){
                        question.options = [NSArray arrayWithObject:self.elementCharacters];
                    }else{
                        NSMutableArray* options = [NSMutableArray arrayWithArray:question.options];
                        [options addObject:self.elementCharacters];
                        question.options = options;
                    }
                }else if([currentElementName isEqualToString:@"answer"]) {
                    question.answers = [self.elementCharacters componentsSeparatedByString:@","];
                }
            }else if ([parentElementName isEqualToString:@"practice"] &&
                      [currentElementName isEqualToString:@"exer"]){
                LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                LECourseLessonLEIPracticeItem* lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count] - 1];
                NSUInteger index = [lessonSectionItem.questions count] - 1;
                LECourseLessonLEIPracticeQuestion* question = [lessonSectionItem.questions objectAtIndex:index];
                //                NSMutableArray* options = [NSMutableArray arrayWithArray:question.options]; //question.options;
                NSMutableArray* images = [NSMutableArray arrayWithArray:question.images]; //question.images;
                if (question.options == nil && images) {
                    NSMutableArray* options = [[NSMutableArray alloc] init];
                    for (int i = 0; i < [images count]; i++) {
                        [options addObject:@""];
                    }
                    question.options = options;
                }
            }else if ([parentElementName isEqualToString:@"dialog"]){
                LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                LECourseLessonLEIRolePlayItem* lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count] - 1];
                NSUInteger index = [lessonSectionItem.speakerDialogs count] - 1;
                LECourseLessonLEIRolePlayDialog* dialog = [lessonSectionItem.speakerDialogs objectAtIndex:index];
                if ([currentElementName isEqualToString:@"speakernum"]) {
                    dialog.speaker = [self.elementCharacters intValue] - 1;
                }else if ([currentElementName isEqualToString:@"videofile"]){
                    NSString* video = self.elementCharacters;
                    video = [self clearnMediaPath:video];
                    video = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/video/%@", video]];
                    dialog.video = video;
                }else if ([currentElementName isEqualToString:@"transcript"]){
                    NSString* transcript = [self cleanCharacters:self.elementTranscriptCharacters];
                    dialog.transcript = transcript;
                    self.elementTranscriptCharacters = nil;
                }else if ([currentElementName isEqualToString:@"noblanks"] ||
                          [currentElementName isEqualToString:@"withblanks"]){
                    NSMutableArray* helpscripts = [NSMutableArray arrayWithArray:dialog.helpscripts];
                    if (helpscripts) {
                        [helpscripts addObject:self.elementCharacters];
                        dialog.helpscripts = helpscripts;
                    }else{
                        dialog.helpscripts = [NSArray arrayWithObject:self.elementCharacters];
                    }
                }else if ([currentElementName isEqualToString:@"seconds"]){
                    dialog.duration = [self.elementCharacters intValue] - 1;
                }
            }else if ([parentElementName isEqualToString:@"audiotext"] &&
                      [currentElementName isEqualToString:@"subaudiotext"]){
                LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                LECourseLessonLEIAudioTextItem* lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count] - 1];
                LECourseLessonLEIAudioText* audioText = [lessonSectionItem.audioTexts objectAtIndex:[lessonSectionItem.audioTexts count] - 1];
                NSString* transcript = [self cleanCharacters:self.elementTranscriptCharacters];
                audioText.text = transcript;
                self.elementTranscriptCharacters = nil;
            }else if ([parentElementName isEqualToString:@"audioresponse"]){
                LECourseLessonSection* lessonSection = [self.currentLesson.sections objectAtIndex:[self.currentLesson.sections count] - 1];
                LECourseLessonLEIAudioResponseItem* lessonSectionItem = [lessonSection.items objectAtIndex:[lessonSection.items count] - 1];
                LECourseLessonLEIAudioResponse* response = [lessonSectionItem.responses objectAtIndex:[lessonSectionItem.responses count] - 1];
                response.total = lessonSectionItem.total;
                response.count = 0;
                response.score = 0;
                if ([currentElementName isEqualToString:@"direction"]) {
                    response.text = self.elementCharacters;
                }else if ([currentElementName isEqualToString:@"audiofile"]){
                    NSString* audio = self.elementCharacters;
                    audio = [self clearnMediaPath:audio];
                    audio = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/audio/%@", audio]];
                    response.audio = audio;
                }else if ([currentElementName isEqualToString:@"model"]){
                    NSString* model = self.elementCharacters;
                    model = [self clearnMediaPath:model];
                    model = [self.currentLessonPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/audio/%@", model]];
                    response.model = model;
                }else if([currentElementName isEqualToString:@"prototype"]){
                    if (self.elementCharacters) {
                        self.elementCharacters = [NSMutableString stringWithString:[self.elementCharacters stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                    }
                    response.prototype = self.elementCharacters;
                }else if([currentElementName isEqualToString:@"type"]){
                    int type = 2;
                    if (self.elementCharacters) {
                        type = self.elementCharacters.intValue;
                    }
                    response.type = [NSNumber numberWithInt:type];
                }
            }
        }else if ([self.currentParser isEqualToString:kCourseGlossaryParser]){
            if ([currentElementName isEqualToString:@"word"]){
                LECourseGlossary* glossary = [self.courseDetail.glossaries objectAtIndex:[self.courseDetail.glossaries count] - 1];
                glossary.name = self.elementCharacters;
            }else if ([currentElementName isEqualToString:@"meaning"]){
                LECourseGlossary* glossary = [self.courseDetail.glossaries objectAtIndex:[self.courseDetail.glossaries count] - 1];
                glossary.content = self.elementCharacters;
            }
        }else if ([self.currentParser isEqualToString:kCourseTestParser]) {
            if ([parentElementName isEqualToString:@"item"]){
                if([currentElementName isEqualToString:@"question"]) {
                    LECourseTestSection* testSection = [self.courseDetail.tests objectAtIndex:[self.courseDetail.tests count] - 1];
                    LECourseTestSectionOptionItem * testOptionItem = [testSection.items objectAtIndex:[testSection.items count]-1];
                    testOptionItem.question = self.elementCharacters;
                }else if([currentElementName isEqualToString:@"option"]) {
                    LECourseTestSection* testSection = [self.courseDetail.tests objectAtIndex:[self.courseDetail.tests count] - 1];
                    LECourseTestSectionOptionItem * testOptionItem = [testSection.items objectAtIndex:[testSection.items count]-1];
                    if (testOptionItem.options == nil){
                        testOptionItem.options = [NSArray arrayWithObject:self.elementCharacters];
                    }else{
                        NSMutableArray* options = [NSMutableArray arrayWithArray:testOptionItem.options];
                        [options addObject:self.elementCharacters];
                        testOptionItem.options = options;
                    }
                }else if([currentElementName isEqualToString:@"answer"]) {
                    LECourseTestSection* testSection = [self.courseDetail.tests objectAtIndex:[self.courseDetail.tests count] - 1];
                    LECourseTestSectionOptionItem * testOptionItem = [testSection.items objectAtIndex:[testSection.items count]-1];
                    testOptionItem.answers = [self.elementCharacters componentsSeparatedByString:@","];
                }else if([currentElementName isEqualToString:@"feedback"]) {
                    LECourseTestSection* testSection = [self.courseDetail.tests objectAtIndex:[self.courseDetail.tests count] - 1];
                    LECourseTestSectionOptionItem * testOptionItem = [testSection.items objectAtIndex:[testSection.items count]-1];
                    testOptionItem.feedback = self.elementCharacters;
                }
            }
        }
    }
    
    [self.elementsArray removeLastObject];
}

- (void)parser:(NSXMLParser *)parser didStartMappingPrefix:(NSString *)prefix toURI:(NSString *)namespaceURI{
    
}

- (void)parser:(NSXMLParser *)parser didEndMappingPrefix:(NSString *)prefix{
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //    NSString* theString = [self cleanCharacters:string];
    NSString* theString = string;
    //    theString = [theString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (!self.isGlossaryElement) {
        if (self.elementTranscriptCharacters) {
            [self.elementTranscriptCharacters appendString:theString];
        }
    }
    if ([theString length] > 0){
        if (self.isGlossaryElement == YES){
            [self.elementGlossary appendString:theString];
        }else{
            theString = [self cleanCharacters:string];
            [self.elementCharacters appendString:theString];
        }
    }
}

- (void)parser:(NSXMLParser *)parser foundIgnorableWhitespace:(NSString *)whitespaceString{
    
}

- (void)parser:(NSXMLParser *)parser foundProcessingInstructionWithTarget:(NSString *)target data:(NSString *)data{
    
}

- (void)parser:(NSXMLParser *)parser foundComment:(NSString *)comment{
    
}

- (void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock{
    
}

- (NSData *)parser:(NSXMLParser *)parser resolveExternalEntityName:(NSString *)name systemID:(NSString *)systemID{
    return nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validationError{
    
}


@end
