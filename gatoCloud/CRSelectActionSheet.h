//
//  CRSelectActionSheet.h
//  gatoCloud
//
//  Created by 曾超然 on 16/8/25.
//  Copyright © 2016年 Gato. All rights reserved.
//

#import "CRBaseActionSheet.h"

typedef void(^actionSheetButtonClick)( NSString *selectionTitle);

@interface CRSelectActionSheet : CRBaseActionSheet

+ (instancetype)actionSheetWithTitle:(NSString *)title selectionArr:(NSArray *)array buttonClicked:(actionSheetButtonClick)buttonClick;




@end
