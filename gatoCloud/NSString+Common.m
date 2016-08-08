//
//  NSString+QYPPCommon.m
//  paopao_ios
//
//  Created by z on 15/9/27.
//  Copyright © 2015年 ___multiMedia___. All rights reserved.
//

#import "NSString+Common.h"
@implementation NSString (QYPPCommon)

- (CGFloat)caluFitHeightWithWidth:(CGFloat)width font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGSize retSize = [self boundingRectWithSize:CGSizeMake(width, 0.0)
                                            options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                         attributes:attribute
                                            context:nil].size;
    return retSize.height;
}

- (CGFloat)caluFitWidthWithHeight:(CGFloat)height font:(UIFont *)font
{
    NSDictionary *attribute = @{NSFontAttributeName:font};
    
    CGSize retSize = [self boundingRectWithSize:CGSizeMake(0.0, height)
                                        options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                     attributes:attribute
                                        context:nil].size;
    return retSize.width;
}

//过滤回车和换行
- (NSString *)trimText
{
    if (self.length < 1)
    {
        return @"";
    }
    
    NSString *regexPattern = @"[\n]+";
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexPattern
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSString *result = [regex stringByReplacingMatchesInString:self
                                                       options:0
                                                         range:NSMakeRange(0, self.length)
                                                  withTemplate:[NSString stringWithFormat:@"\n\n"]];
    return result;
}



+(NSString *)signWithParameters:(NSDictionary *)dictParameters
{
    NSString *sign = @"";
    NSMutableArray *arrayKeyAndValues = [NSMutableArray new];
    for (NSString *key in dictParameters.allKeys) {
        [arrayKeyAndValues addObject:[NSString stringWithFormat:@"%@=%@",key,[dictParameters objectForKey:key]]];
    }
    
    NSArray *arraySortedKey = [arrayKeyAndValues sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2];
    }];
    NSMutableString *stringUnSign = [NSMutableString stringWithCapacity:0];
    for (int i = 0; i < [arraySortedKey count]; i++) {
        [stringUnSign appendFormat:@"%@|",arraySortedKey[i]];
    }
    [stringUnSign appendString:@"dd636d1lwjfed7"];
    sign = [NSString md5:stringUnSign];
    return sign;
}
- (NSString *)largeAvatarWithURL
{
    NSString *newURL = self;
    NSRange range = [self rangeOfString:@"_\\d{2,3}_\\d{2,3}\\.[a-zA-Z]{3,4}$" options:NSRegularExpressionSearch];
    if(range.location != NSNotFound){
        NSString *rangeStr = [self substringWithRange:range];
        NSArray *strArr = [rangeStr componentsSeparatedByString:@"."];
        NSString *newStr = [@"_640_640." stringByAppendingString:strArr[1]];
        newURL = [self stringByReplacingOccurrencesOfString:rangeStr withString:newStr];
    }
    return newURL;
}
+ (NSString*)UUID
{
    CFUUIDRef    uuidObj = CFUUIDCreate(nil);//create a new UUID
    //get the string representation of the UUID
    NSString    *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    return uuidStr;
    
}

- (BOOL)hasString
{
    if([self isEqualToString:@""] || self == nil) {
        return NO;
    }
    else
        return YES;
}

- (BOOL)isEmptyString
{
    if([self isEqualToString:@""] || self == nil) {
        return YES;
    }
    else
        return NO;
}

- (NSString *)stringByAppendingNumber:(NSNumber *)number;
{
    return [self stringByAppendingString:[number stringValue]];
}

+ (NSString *)stringWithTwoNumbers:(NSNumber *)number1 andNumber:(NSNumber *)number2;
{
    return [NSString stringWithFormat:@"%d/%d",[number1 integerValue],[number2 integerValue]];
}

@end
