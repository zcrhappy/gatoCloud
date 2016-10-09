
#import "PCCircleViewConst.h"

@implementation PCCircleViewConst

+ (void)saveGesture:(NSString *)gesture Key:(NSString *)key
{
    if(!key)
        return;
    [[NSUserDefaults standardUserDefaults] setObject:gesture forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getGestureWithKey:(NSString *)key
{
    if(!key)
        return nil;
    return [[NSUserDefaults standardUserDefaults] objectForKey:key];
}

+ (NSString *)firstKey
{
    if([GTUserUtils sharedInstance].userModel.userId)
        return [[GTUserUtils sharedInstance].userModel.userId stringByAppendingString:gestureOneSaveKey];
    else
        return gestureOneSaveKey;//未登录时候
}

+ (NSString *)finalKey
{
    if([GTUserUtils sharedInstance].userModel.userId)
        return [[GTUserUtils sharedInstance].userModel.userId stringByAppendingString:gestureFinalSaveKey];
    else
        return gestureFinalSaveKey;
}

@end
