//
//  NSDate+Addition.m
//  iCollege
//
//  Created by Yuhui Zhang on 5/23/10.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Addition.h"

#define TIMESTAMP_DATA_FORMAT @"MM-dd HH:mm"

@implementation NSDate (Addition)

+ (NSString*)stringFromTimeInterval:(NSTimeInterval)theInterval {

    int seconds, minutes, hours, days, interval;
    interval = (int) theInterval;
    if (interval < 0) interval = -1 * interval;
    
    if (interval < 1) return @"";
    
    
    interval = [[NSDate date] timeIntervalSince1970] - interval;
    
    seconds = minutes = hours = days = 0;
    
    if (interval >= 0) {
        seconds =  interval % 60;
    }
    if (interval >= 60) {
        minutes = (interval / 60) % 60;
    }
    if (interval >= 3600) {
        hours = (interval / 3600);
    }
    if (interval >= 86400) {
        days = interval / 86400;
    }
    
    if (days > 0) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:TIMESTAMP_DATA_FORMAT];
        NSDate *dateObject = [NSDate dateWithTimeIntervalSince1970:theInterval];
        NSString *dateString = [dateFormatter stringFromDate:dateObject];
        return dateString;
    }
    else if (hours > 0) {
        return (hours == 1) ? NSLocalizedString(@"1小时前", nil) : [NSString stringWithFormat: NSLocalizedString(@"%d小时前", nil), hours];
    } 
    else if (minutes > 0) {
        return (minutes == 1) ? NSLocalizedString(@"1分钟前", nil) : [NSString stringWithFormat: NSLocalizedString(@"%d分钟前", nil), minutes];
    } 
    else {
         return (seconds == 1) ? NSLocalizedString(@"1秒钟前", nil) : [NSString stringWithFormat: NSLocalizedString(@"%d秒钟前", nil), seconds];
    }
}


+ (NSString*)stringFromTimeIntervalSinceReferenceDate:(NSTimeInterval)theInterval {
    NSCalendar* currentCalendar = [NSCalendar currentCalendar];
    NSCalendarUnit units = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSWeekCalendarUnit | NSWeekdayCalendarUnit;
    NSDateComponents* now = [currentCalendar components: units fromDate: [NSDate date]];
    NSDateComponents* then = [currentCalendar components: units fromDate: [NSDate dateWithTimeIntervalSinceReferenceDate: theInterval]];
    
    NSTimeInterval timeIntervalSinceNow = [[NSDate dateWithTimeIntervalSinceReferenceDate: theInterval] timeIntervalSinceNow];
    
    int nowDay = now.week * 7 + now.weekday;
    int thenDay = then.week * 7 + then.weekday;
    
    if (nowDay == thenDay) {
        return [self stringFromTimeInterval: timeIntervalSinceNow];
    }
    
    if (nowDay - 1 == thenDay) {
        return NSLocalizedString(@"Yesterday", nil);
    }
    
    if (nowDay - 7 < thenDay) {
        switch (then.weekday) {
            case 0:
                return NSLocalizedString(@"Sunday", nil);
            case 1:
                return NSLocalizedString(@"Monday", nil);
            case 2:
                return NSLocalizedString(@"Tuesday", nil);
            case 3: 
                return NSLocalizedString(@"Wednesday", nil);
            case 4: 
                return NSLocalizedString(@"Thursday", nil);
            case 5: 
                return NSLocalizedString(@"Friday", nil);
            case 6: 
                return NSLocalizedString(@"Saturday", nil);
        }
    }

    return [self stringFromTimeInterval: timeIntervalSinceNow];
}

- (BOOL)isSameDayAs:(NSDate*)otherDate {
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:otherDate];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
}

@end
