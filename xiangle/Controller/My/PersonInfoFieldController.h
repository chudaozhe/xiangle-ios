//
//  PersonInfoFieldController.h
//  xiangle
//
//  Created by wei cui on 2020/9/25.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
//协议
@protocol PersonInfoFieldControllerDelegate <NSObject>

@optional
-(void)onControllerResult:(NSString *)value code:(NSInteger)code;

@end
@interface PersonInfoFieldController : UIViewController

@property (assign, nonatomic) NSInteger code;
/** 备注 */
@property (strong, nonatomic) NSString *nickname;
/** 备注 */
@property (strong, nonatomic) NSString *quotes;

@property (nonatomic, weak) id delegate;
@end

NS_ASSUME_NONNULL_END
