//
//  GTMacroFunctionHeader.h
//  gatoCloud
//
//  Created by 曾超然 on 16/7/9.
//  Copyright © 2016年 Gato. All rights reserved.
//

#ifndef GTMacroFunctionHeader_h
#define GTMacroFunctionHeader_h

#define macroCreateTableCell( tableCellType, tableView, cellIdentifier )\
^(void)\
{\
tableCellType *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];\
if ( nil == tableCell )\
{\
tableCell = [[[tableCellType class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];\
}\
\
return tableCell;\
}()


#define macroCreateTableCellReset( tableCellType, tableView, cellIdentifier )\
^(void)\
{\
tableCellType *tableCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];\
if ( nil == tableCell )\
{\
tableCell = [[[tableCellType class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];\
}\
else\
{\
[tableCell resetCell];\
}\
\
return tableCell;\
}()


#define macroCreateView( viewFrame, viewBackgroundColor )\
^(void)\
{\
UIView *view = [[UIView alloc] initWithFrame:viewFrame];\
view.backgroundColor = viewBackgroundColor;\
\
return view;\
}()


#define macroCreateButton( buttonFrame, buttonBackgroundColor )\
^(void)\
{\
UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];\
button.backgroundColor = buttonBackgroundColor;\
\
return button;\
}()


#define macroSetButtonTextAttribute( button, buttonFontSize, buttonNormalTextColor, buttonSelectTextColor, buttonDisableTextColor )\
^(void)\
{\
button.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];\
if( nil != buttonNormalTextColor )\
{\
[button setTitleColor:buttonNormalTextColor forState:UIControlStateNormal];\
}\
if( nil != buttonSelectTextColor )\
{\
[button setTitleColor:buttonSelectTextColor forState:UIControlStateSelected];\
}\
if( nil != buttonDisableTextColor )\
{\
[button setTitleColor:buttonDisableTextColor forState:UIControlStateDisabled];\
}\
}()


#define macroSetButtonImageAttribute( button, buttonNormalImage, buttonHighlightImage, buttonSelectImage, buttonDisableImage )\
^(void)\
{\
if( nil != buttonNormalImage )\
{\
[button setImage:buttonNormalImage forState:UIControlStateNormal];\
}\
if( nil != buttonHighlightImage )\
{\
[button setImage:buttonHighlightImage forState:UIControlStateHighlighted];\
}\
if( nil != buttonSelectImage )\
{\
[button setImage:buttonSelectImage forState:UIControlStateSelected];\
}\
if( nil != buttonDisableImage )\
{\
[button setImage:buttonDisableImage forState:UIControlStateDisabled];\
}\
}()


#define macroSetButtonImageStringAttribute( button, buttonNormalImageString, buttonHighlightImageString, buttonSelectImageString, buttonDisableImageString )\
^(void)\
{\
if( nil != buttonNormalImageString )\
{\
[button setImage:[UIImage imageNamed:buttonNormalImageString] forState:UIControlStateNormal];\
}\
if( nil != buttonHighlightImageString )\
{\
[button setImage:[UIImage imageNamed:buttonHighlightImageString] forState:UIControlStateHighlighted];\
}\
if( nil != buttonSelectImageString )\
{\
[button setImage:[UIImage imageNamed:buttonSelectImageString] forState:UIControlStateSelected];\
}\
if( nil != buttonDisableImageString )\
{\
[button setImage:[UIImage imageNamed:buttonDisableImageString] forState:UIControlStateDisabled];\
}\
}()


#define macroCreateLabel( labelFrame, labelBackgroundColor, labelFontSize, labelFontColor )\
^(void)\
{\
UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];\
label.backgroundColor = labelBackgroundColor;\
label.font = [UIFont systemFontOfSize:labelFontSize];\
label.textColor = labelFontColor;\
\
return label;\
}()


#define macroCreateBoldLabel( labelFrame, labelBackgroundColor, labelFontSize, labelFontColor )\
^(void)\
{\
UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];\
label.backgroundColor = labelBackgroundColor;\
label.font = [UIFont boldSystemFontOfSize:labelFontSize];\
label.textColor = labelFontColor;\
\
return label;\
}()


#define macroCreateRichLabel( richLabelFrame, richLabelBackgroundColor, richLabelFontSize, richLabelFontColor, richLabelLinkColor, richLabelLinkClickColor )\
^(void)\
{\
MLEmojiLabel *richLabel = [[MLEmojiLabel alloc] initWithFrame:richLabelFrame]; \
richLabel.backgroundColor = richLabelBackgroundColor; \
richLabel.font = [UIFont systemFontOfSize:richLabelFontSize]; \
richLabel.textColor = richLabelFontColor; \
richLabel.disableEmoji = NO; \
[richLabel setLinkAttribute:richLabelLinkColor clickedBackgroundColor:richLabelLinkClickColor showUnderline:NO]; \
\
return richLabel; \
}()


#define macroCreateBoldRichLabel( richLabelFrame, richLabelBackgroundColor, richLabelFontSize, richLabelFontColor, richLabelLinkColor, richLabelLinkClickColor )\
^(void)\
{\
MLEmojiLabel *richLabel = [[MLEmojiLabel alloc] initWithFrame:richLabelFrame]; \
richLabel.backgroundColor = richLabelBackgroundColor; \
richLabel.font = [UIFont boldSystemFontOfSize:richLabelFontSize]; \
richLabel.textColor = richLabelFontColor; \
richLabel.disableEmoji = NO; \
[richLabel setLinkAttribute:richLabelLinkColor clickedBackgroundColor:richLabelLinkClickColor showUnderline:NO]; \
\
return richLabel; \
}()


#define macroCreateImage( imageFrame, imageBackgroundColor )\
^(void)\
{\
UIImageView *imageView = [[UIImageView alloc] initWithFrame:imageFrame];\
imageView.backgroundColor = imageBackgroundColor;\
\
return imageView;\
}()


#define macroCreateImageClickable( imageFrame, imageBackgroundColor )\
^(void)\
{\
QYPPImageView *imageView = [[QYPPImageView alloc] initWithFrame:imageFrame];\
imageView.backgroundColor = imageBackgroundColor;\
\
return imageView;\
}()


#define macroCreateScrollView( scrollViewFrame, scrollViewBackgroundColor )\
^(void)\
{\
UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:scrollViewFrame];\
scrollView.backgroundColor = scrollViewBackgroundColor;\
\
return scrollView;\
}()


#define macroCreateTextField( viewFrame, viewBackgroundColor )\
^(void)\
{\
UITextField *kTextField = [[UITextField alloc] initWithFrame:viewFrame];\
kTextField.backgroundColor = viewBackgroundColor;\
\
return kTextField;\
}()


#define macroCreateBadge( badgeFrame, badgeBackgroundColor, badgeColor )\
^(void)\
{\
QYPPCustomBadgeView *badgeView = [[QYPPCustomBadgeView alloc] initWithFrame:badgeFrame];\
badgeView.backgroundColor = badgeBackgroundColor;\
[badgeView setBadgeColor:badgeColor];\
\
return badgeView;\
}()


#define macroCreateTableView( tableFrame, tableBackgroundColor )\
^(void)\
{\
UITableView *tableView = [[UITableView alloc] initWithFrame:tableFrame];\
tableView.backgroundColor = tableBackgroundColor;\
\
return tableView;\
}()


#define macroCreateHorizontalTableView( tableFrame, tableBackgroundColor )\
^(void)\
{\
UITableView *tableView = [[UITableView alloc] init];\
tableView.backgroundColor = tableBackgroundColor;\
tableView.transform = CGAffineTransformMakeRotation(-M_PI / 2);\
tableView.frame = tableFrame;\
tableView.separatorStyle = NO;\
tableView.pagingEnabled = YES;\
tableView.bounces = NO;\
tableView.showsHorizontalScrollIndicator = NO;\
tableView.showsVerticalScrollIndicator = NO;\
\
return tableView;\
}()


#define macroCreateImageTitleBarButton( buttonFrame, buttonBackgroundColor, buttonTitle, buttonNormalTextColor, buttonHighLightTextColor, buttonNormalImage, buttonHighLightImage, buttonFontSize, buttonNameValue )\
^(void)\
{\
QYPPImgTitleBarButton *button = [[QYPPImgTitleBarButton alloc] initWithFrame:buttonFrame title:buttonTitle color:buttonNormalTextColor pressedColor:buttonHighLightTextColor icon:buttonNormalImage pressedIcon:buttonHighLightImage];\
button.backgroundColor = buttonBackgroundColor;\
button.titleLabel.font = [UIFont systemFontOfSize:buttonFontSize];\
button.buttonName = buttonNameValue;\
\
return button;\
}()


#define macroCreateWebView( webViewFrame, webViewBackgroundColor )\
^(void)\
{\
UIWebView *webView = [[UIWebView alloc] initWithFrame:webViewFrame];\
webView.backgroundColor = webViewBackgroundColor;\
webView.scalesPageToFit =YES;\
\
return webView;\
}()


#define macroCreateFeedbar( feedbarFrame, feedbarBackgroundColor, feedbarMode )\
^(void)\
{\
QYPPFeedbar *feedBar = [[QYPPFeedbar alloc] initWithFrame:feedbarFrame type:feedbarMode withFeedModel:nil];\
feedBar.backgroundColor = feedbarBackgroundColor;\
\
return feedBar;\
}()


#define macroCreateCircleInfoView( circleInfoFrame, circleInfoBackgroundColor )\
^(void)\
{\
QYPPCircleInfoView *circleInfo = [[QYPPCircleInfoView alloc] initWithFrame:circleInfoFrame];\
circleInfo.backgroundColor = circleInfoBackgroundColor;\
\
return circleInfo;\
}()


#define macroCreateCommentInputBar( inputBarFrame, inputBarBackgroundColor )\
^(void)\
{\
QYPPCommentInputBar *inputBar = [[QYPPCommentInputBar alloc] initWithFrame:inputBarFrame];\
inputBar.backgroundColor = inputBarBackgroundColor;\
\
return inputBar;\
}()

#define weakify(...) \\
autoreleasepool {} \\
metamacro_foreach_cxt(rac_weakify_,, __weak, __VA_ARGS__)

#define strongify(...) \\
try {} @finally {} \\
_Pragma("clang diagnostic push") \\
_Pragma("clang diagnostic ignored \\"-Wshadow\\"") \\
metamacro_foreach(rac_strongify_,, __VA_ARGS__) \\
_Pragma("clang diagnostic pop")

#endif /* GTMacroFunctionHeader_h */
