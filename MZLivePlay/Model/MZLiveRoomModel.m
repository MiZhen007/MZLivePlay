//
//  MZLiveRoomModel.m
//  XuanYan
//
//  Created by mz on 2018/5/18.
//  Copyright © 2018年 mizhen. All rights reserved.
//

#import "MZLiveRoomModel.h"

@implementation MZLiveRoomModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"courseid"]) {
        _courseID=value;
    }
    if ([key isEqualToString:@"id"]) {
        _playID=value;
    }
    if ([key isEqualToString:@"subject"]) {
        _lessonSubject=value;
    }
    if ([key isEqualToString:@"attendeeJoinUrl"]) {
        _audienceJoinUrl=value;
    }
    if ([key isEqualToString:@"attendeetoken"]) {
        _audienceJoinToken=value;
    }
    if ([key isEqualToString:@"number"]) {
        _playNumber=value;
    }
    if ([key isEqualToString:@"lrnote"]) {
        _liveDescription=value;
    }
    if ([key isEqualToString:@"status"]) {
        _roomStatus=[(NSNumber *)value intValue] ;
    }
    if ([key isEqualToString:@"starttime"]) {
        _startTime=value;
    }
    if ([key isEqualToString:@"clpicappurl"]) {
        _thumbUrl=value;
    }
    if ([key isEqualToString:@"speakerInfo"]) {
        _contentIntro=value;
    }
    if ([key isEqualToString:@"memname"]) {
        _expert=value;
    }
}
//通过未定义的key取值时，不重写此方法就会崩溃
-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
}


@end
