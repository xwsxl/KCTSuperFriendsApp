//
//  SSChatMessage.m
//  SSChatView
//
//  Created by soldoros on 2018/10/12.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "SSChatMessage.h"

@implementation SSChatMessage


//判断当前时间是否展示
-(void)showTimeWithLastShowTime:(long )lastTime currentTime:(long )currentTime{
    
    NSTimeInterval timeInterval = [NSTimer CompareTwoTime:lastTime time2:currentTime]/1000.0;
    
    if(timeInterval/60 >= 5){
        
        _showTime = YES;
    }else{
        _showTime = NO;
    }
}

//文本消息
-(void)setTextString:(NSString *)textString{
    _textString = textString;
    self.attTextString = [[SSChartEmotionImages ShareSSChartEmotionImages]emotionImgsWithString:textString];
}

//可变文本消息
-(void)setAttTextString:(NSMutableAttributedString *)attTextString{
    
    NSMutableParagraphStyle *paragraphString = [[NSMutableParagraphStyle alloc] init];
    [paragraphString setLineSpacing:SSChatTextLineSpacing];
    
    [attTextString addAttribute:NSParagraphStyleAttributeName value:paragraphString range:NSMakeRange(0, attTextString.length)];
    [attTextString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:SSChatTextFont] range:NSMakeRange(0, attTextString.length)];
    [attTextString addAttribute:NSForegroundColorAttributeName value:SSChatTextColor range:NSMakeRange(0, attTextString.length)];
    
    _attTextString = attTextString;
    
}


@end
