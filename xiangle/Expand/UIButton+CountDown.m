//
//  UIButton+CountDown.m
//  xiangle
//
//  Created by wei cui on 2020/9/20.
//  Copyright © 2020 wei cui. All rights reserved.
//

#import "UIButton+CountDown.h"
static NSString *tempText;
@implementation UIButton (CountDown)
- (void)startCountDownTime:(int)time withCountDownBlock:(void(^)(void))countDownBlock{
    
    [self initButtonData];
    
    [self startTime:time];
    
    if (countDownBlock) {
        countDownBlock();
    }
}

- (void)initButtonData{
    
    tempText = [NSString stringWithFormat:@"%@",self.titleLabel.text];
    
}

- (void)startTime:(int)time{
    
    __block int timeout = time;
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0);
    
    dispatch_source_set_event_handler(_timer, ^{
        
        //倒计时结束
        if(timeout <= 0){
            
            dispatch_source_cancel(_timer);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self setTitle:tempText forState:UIControlStateNormal];
                [self setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                self.userInteractionEnabled = YES;
                
            });
            
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *text = [NSString stringWithFormat:@"重新获取（%02d）",timeout];
                [self setTitle:text forState:UIControlStateNormal];
                [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                self.userInteractionEnabled = NO;
                
            });
            
            timeout --;
            
        }
        
    });
    
    dispatch_resume(_timer);
    
}
@end
