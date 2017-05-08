//
//  HeadView.m
//  CoreAnimation
//
//  Created by huangshan on 2017/5/5.
//  Copyright © 2017年 huangshan. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    
    id obj = [super actionForLayer:layer forKey:event];
    
    NSLog(@"%@~~~~~~~%@", event, obj);
    
    id s = nil;
    
    return nil;

}

@end
