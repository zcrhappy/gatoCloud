
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
    return [[GTUserUtils sharedInstance].userModel.userId stringByAppendingString:gestureOneSaveKey];
}

+ (NSString *)finalKey
{
    return [[GTUserUtils sharedInstance].userModel.userId stringByAppendingString:gestureFinalSaveKey];
}

@end
