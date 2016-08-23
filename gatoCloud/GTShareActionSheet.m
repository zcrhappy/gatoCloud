//
//  GTShareActionSheet.m
//  gatoCloud
//
//  Created by 曾超然 on 16/7/25.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "GTShareActionSheet.h"
#import "WXApi.h"
//根据屏幕宽计算缩放因子
#define WidthScaleFactor (([UIScreen mainScreen].bounds.size.width)/1080.0)
#define Height_Backgroud             (630.0*WidthScaleFactor)              //背景高度
#define Height_BackTop               (210.0*WidthScaleFactor)              //背景顶部高度
#define Height_CancelBack            (144.0*WidthScaleFactor)              //取消按钮高度
#define Height_Button                (120.0*WidthScaleFactor)              //背景高度
#define Font_Title                   (48*WidthScaleFactor)                 //标题字体
#define Font_Cancel                  (54*WidthScaleFactor)                 //取消字体
#define Font_Button                  (33*WidthScaleFactor)                 //按钮字体
#define Gap_BtnToView                (85.0*WidthScaleFactor)               //按钮间隙
#define Gap_BtnToBtn                 ((430.0/3.0)*WidthScaleFactor)        //按钮之间的间隙
#define Gap_BtnToLabel               (24*WidthScaleFactor)                 //按钮和label之间的间隙
#define Gap_BtnAnimation             (120*WidthScaleFactor)                 //动画之前的间隙

const CGFloat ANIMATE_DURATION   = 0.25;
static NSString* const Str_title         = @"分享到";
static NSString* const Str_cancel        = @"取消";
static NSString* const Color_label       = @"333333";
static NSString* const KeyShareType      = @"ShareType";
static NSString* const KeyVC             = @"parentVC";
static NSString* const KeyShareData      = @"ShareData";
static NSString* const Type_WeChat       = @"8";
static NSString* const Type_FriendCircle = @"7";
static NSString* const Type_Weibo        = @"4";
static NSString* const Share_Paopao      = @"泡泡";
static NSString* const Share_Wechat      = @"微信好友";
static NSString* const Share_Message     = @"短信";

@interface GTShareActionSheet()
{
    UIView*     backView;
    NSMutableArray*    btnArr;
    NSMutableArray*    labelArr;
    UIViewController*   parentVc;
    BOOL isInAnimation;
}

@end

@implementation GTShareActionSheet

-(instancetype)initWithShareDestination:(NSArray *)destination parentViewController:(UIViewController *)parentViewController
{
    if(self = [super init]) {
        parentVc = parentViewController;
        [parentViewController.view addSubview:self];
        
        btnArr = [NSMutableArray array];
        labelArr = [NSMutableArray array];
        isInAnimation = NO;
        [self initUI];
        [self makeUI];
    }
    return self;
}

- (void)initUI{
    //初始化背景视图，添加手势
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackground)];
    [self addGestureRecognizer:tapGesture];
    
}

- (void)makeUI{
    //backView
    backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , SCREEN_WIDTH, Height_Backgroud)];
    [self addSubview:backView];
    backView.backgroundColor = [UIColor colorWithRed:246./255. green:249./255. blue:244./255. alpha:0.93];
    
    //title
    UILabel* titleLbl = UILabel.new;
    titleLbl.textColor = [UIColor colorWithString:Color_label];
    titleLbl.font = [UIFont systemFontOfSize:Font_Title];
    titleLbl.text = Str_title;
    [backView addSubview:titleLbl];
    [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView);
        make.centerY.equalTo(backView.mas_top).offset(Height_BackTop/2.0);
    }];
    
    //line
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SINGLE_LINE_WIDTH)];
    line.backgroundColor = [UIColor colorWithString:@"e0e0e0"];
    [backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backView.mas_centerX);
        make.bottom.equalTo(backView.mas_bottom).offset(-Height_CancelBack);
        make.width.equalTo(@(line.frame.size.width));
        make.height.equalTo(@(line.frame.size.height));
    }];
    
    //按钮
    NSArray* labelStr;
    NSArray* iconStr;
    if ([WXApi isWXAppInstalled]) {
        labelStr = @[Share_Wechat, Share_Message];
        iconStr = @[@"Share_Wechat", @"Share_Message"];
    }else{
        labelStr = @[Share_Message];
        iconStr = @[@"Share_Message"];
    }
    
    for (int i = 0; i < [labelStr count]; i++) {
        UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(Gap_BtnToView + i*(Gap_BtnToBtn + Height_Button), Height_BackTop + Gap_BtnAnimation, Height_Button, Height_Button)];
        
        [btn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = i;
        [btnArr addObject:btn];
        [backView addSubview:btn];
        [btn setImage:[UIImage imageNamed:iconStr[i]] forState:UIControlStateNormal];
        btn.alpha = 0.0;
        [btn setTitle:labelStr[i] forState:UIControlStateNormal];
        btn.titleLabel.alpha = 0.0;
        
        UILabel* label = UILabel.new;
        [labelArr addObject:label];
        label.textColor = [UIColor colorWithString:Color_label];
        label.font = [UIFont systemFontOfSize:Font_Button];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = labelStr[i];
        [backView addSubview:label];
        label.frame = CGRectMake(0, 0, 5*Font_Button, Font_Button);
        label.centerX = btn.centerX;
        label.top = Height_BackTop + Height_Button + Gap_BtnToLabel + Gap_BtnAnimation;
        
        label.alpha = 0.0;
        
    }
    
    //cancel button
    UIButton* cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_CancelBack)];
    cancelButton.backgroundColor = [UIColor whiteColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:Font_Cancel];
    [cancelButton setTitleColor:[UIColor colorWithString:Color_label] forState:UIControlStateNormal];
    
    [cancelButton setTitle:Str_cancel forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    
    [backView addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(backView.mas_top).offset(Height_Backgroud);
        make.centerX.equalTo(backView.mas_centerX);
        make.width.equalTo(@(cancelButton.width));
        make.height.equalTo(@(cancelButton.height));
    }];
    
}


- (void)doShowOrHideAnimation:(BOOL)isShow{
    if (isShow && parentVc) {   //开始show的动画之前要把backView放到正确位置
        CGRect frame = backView.frame;
        backView.frame = CGRectMake(frame.origin.x, parentVc.view.height, frame.size.width, frame.size.height);
    }
    
    CGRect frame = backView.frame;
    CGFloat realHeight = [self superview].height;
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        isInAnimation = YES;
        CGFloat posH = isShow ? realHeight - Height_Backgroud : realHeight;
        backView.frame = CGRectMake(frame.origin.x, posH, frame.size.width, frame.size.height);
    } completion:^(BOOL finished) {
        isInAnimation = NO;
        if (!isShow) {
            [self removeFromSuperview];
        }
    }];
    
    //按钮动画
    if (isShow) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (int i = 0; i < [btnArr count]; i++) {
                
                UIView* obj = [btnArr objectAtIndex:i];
                UIView* lbl = [labelArr objectAtIndex:i];
                obj.alpha = 0.0;
                lbl.alpha = 0.0;
                [UIView animateWithDuration:2*ANIMATE_DURATION delay:(i + 1)*(ANIMATE_DURATION/5) usingSpringWithDamping:0.2 initialSpringVelocity:3 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    CGRect frameBtn = obj.frame;
                    CGRect frameLbl = lbl.frame;
                    obj.alpha = 1.0;
                    lbl.alpha = 1.0;

                    obj.frame = CGRectMake(frameBtn.origin.x, frameBtn.origin.y - Gap_BtnAnimation, frameBtn.size.width, frameBtn.size.height);
                    lbl.frame = CGRectMake(frameLbl.origin.x, frameLbl.origin.y - Gap_BtnAnimation, frameLbl.size.width, frameLbl.size.height);
                } completion:^(BOOL finish){
                    if (i == [btnArr count] - 1) {
                        isInAnimation = NO;
                    }
                    
                }];
                
            }
        });
    }
}

- (void)show
{
    [self doShowOrHideAnimation:YES];
}

- (void)tappedBackground{
    [self hideView];
}

- (void)hideView{
    if (!isInAnimation){
        [self doShowOrHideAnimation:NO];
    }
}


- (void)shareBtnClick:(id)obj{
    UIButton* btn = (UIButton*)obj;
    NSString* btnTitle = [btn titleForState:UIControlStateNormal];
    if ([btnTitle isEqualToString:Share_Wechat]) { //分享到微信好友
        if(self.shareToWXFriend)
            self.shareToWXFriend();
//        NSMutableDictionary *shareDic = [QYPPCircleFeedMTLModel makeShareDictionaryWithFeedModel:feedModel];
//        [QIYIPaopaoShareActionSheet shareToPaopaoWithDict:shareDic ViewController:parentVc];
        [self hideView];
        return;
    }else if ([btnTitle isEqualToString:Share_Message]){//分享到短信
        
      }
//    
//    NSDictionary* usrInfo= [QIYIPaopaoShareActionSheet makeThirdPartyShareInfoByModel:model shareType:shareType ViewController:curVC];
//    [QIYIPaopaoShareActionSheet shareToThirdPartyDict:usrInfo];
    
    [self hideView];
}

- (void)cancelClick{
    [self hideView];
}










@end
