//
//  Tool.m
//  InfoProvider
//
//  Created by zhengzeqin on 14-8-13.
//  Copyright (c) 2014年 zzq. All rights reserved.
//

#import "Tool.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <AVFoundation/AVFoundation.h>

@implementation Tool
static const NSInteger TLMI_IMA_KB = 300;

+ (UIButton *)barBtnItemWithTitle:(NSString *)title withImage:(UIImage *)image{
    
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [barButton setFrame:CGRectMake(0, 0, 30, 30)];
    if(image){
        [barButton setImage:image forState:UIControlStateNormal];
    }else{
        [barButton setTitle:title forState:UIControlStateNormal];
        barButton.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        [barButton setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
    }
    return barButton;
    
}

+ (NSString *)fullPathAtCache:(NSString *)fileName{
    NSError *error;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (YES != [fm fileExistsAtPath:path]) {
        if (YES != [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"create dir path=%@, error=%@", path, error);
        }
    }
    return [path stringByAppendingPathComponent:fileName];
}

+ (NSString *)saveImageToLocalWithImageData:(NSData *)imageData andPath:(NSString *)path{
    
    if(!path || path.length<=0){
        //给path一个默认值
        path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    }
    NSString *date = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYMMddhhmmSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *imageNameHeader = [NSString stringWithFormat:@"/IMGR_%i", arc4random()%10000];
    NSString *imageNameComm = [imageNameHeader stringByAppendingString:date];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg", [path stringByAppendingString:imageNameComm]];
    [imageData writeToFile:imageName atomically:YES];
    return imageName;
    
}

//带下划线字符串
+ (NSMutableAttributedString*)underLineAttributeStringWithText:(NSString *)text{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    return content;
}
+ (NSMutableAttributedString*)underLineAttributeStringWithText:(NSString *)text color:(UIColor *)color fontSize:(NSInteger)size{
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    [content addAttribute:NSForegroundColorAttributeName value:color range:contentRange];
    [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:contentRange];
    return content;
    
}

+ (NSMutableAttributedString*)attributeStringWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange contentRange = {0,[content length]};
    [content addAttribute:NSForegroundColorAttributeName value:color range:contentRange];
    [content addAttribute:NSFontAttributeName value:font range:contentRange];
    return content;
}

+ (NSMutableAttributedString *)attLineStrWithText:(NSString *)str color:(UIColor *)color fontSize:(NSInteger)size{
    NSUInteger length = [str length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:color range:NSMakeRange(0, length)];
    [attri addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, length)];
    return attri;
}

//设置label横线
+ (void)setLineStr:(NSString *)str label:(UILabel *)label color:(UIColor *)color{
    NSUInteger length = [str length];
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
    [attri addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, length)];
    [attri addAttribute:NSStrikethroughColorAttributeName value:color range:NSMakeRange(0, length)];
    [label setAttributedText:attri];
}

+ (NSAttributedString *)attStr:(NSString *)str colorStrArr:(NSArray *)strArr color:(UIColor *)color fontSize:(NSInteger )size{
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:str];
    [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:size] range:NSMakeRange(0, str.length)];
    for (NSString *dealStr in strArr) {
        NSRange range = [str rangeOfString:dealStr];
        [content addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    return content;
}

+ (void)setZanBtnStateWithTitle:(NSString *)title button:(UIButton *)zanBtn andTotalWidth:(float)width{
    
    [zanBtn setTitle:title forState:UIControlStateNormal];
    int count = title.length;
    float totalWidth = 35 + 5*count;
    [zanBtn setFrame:CGRectMake(width-totalWidth-10, zanBtn.frame.origin.y, totalWidth, zanBtn.frame.size.height)];
    [zanBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 3, 3, totalWidth-20)];
    [zanBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
    
}

+ (NSInteger)currentTextViewNum:(UIView *)textView{
    if([textView isKindOfClass:[UITextView class]]){
        UITextView *textV = (UITextView *)textView;
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textV markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textV positionFromPosition:selectedRange.start offset:0];
            UITextPosition *position_end = [textV positionFromPosition:selectedRange.end offset:0];
            NSInteger i = [textV offsetFromPosition:position toPosition:position_end];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                return textV.text.length;
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                return textV.text.length - i;
            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else{
            return textV.text.length;
        }
        
    }else{
        UITextView *textF = (UITextView *)textView;
        
        NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
        if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
            UITextRange *selectedRange = [textF markedTextRange];
            //获取高亮部分
            UITextPosition *position = [textF positionFromPosition:selectedRange.start offset:0];
            UITextPosition *position_end = [textF positionFromPosition:selectedRange.end offset:0];
            NSInteger i = [textF offsetFromPosition:position toPosition:position_end];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position) {
                return textF.text.length;
            }
            // 有高亮选择的字符串，则暂不对文字进行统计和限制
            else{
                return textF.text.length - i;
            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else{
            return textF.text.length;
        }
        
    }
    
}

+ (void)limitTextFieldWord:(UITextField *)obj length:(NSInteger)legnth{
    NSString *toBeString = obj.text;
    NSArray * currentar = [UITextInputMode activeInputModes];
    UITextInputMode * current = [currentar firstObject];
    
    if ([current.primaryLanguage isEqualToString:@"zh-Hans"]) { //
        UITextRange *selectedRange = [obj markedTextRange];
        
        UITextPosition *position = [obj positionFromPosition:selectedRange.start offset:0];
        
        if (!position) {
            if (toBeString.length > legnth) {
                obj.text = [toBeString substringToIndex:legnth];
            }
        }
        
    }
    
    else{
        if (toBeString.length > legnth) {
            obj.text = [toBeString substringToIndex:legnth];
            
        }
    }
    
}

+ (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text limNum:(NSInteger)limNum label:(UILabel *)label{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < limNum) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = limNum - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            if (label) {
                label.text = [NSString stringWithFormat:@"%d/%ld",0,(long)limNum];
            }
        }
        return NO;
    }

}

+ (void)textViewDidChange:(UITextView *)textView limNum:(NSInteger)limNum label:(UILabel *)label{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > limNum)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:limNum];
        
        [textView setText:s];
    }
    
    //不让显示负数
    if (label) {
        label.text = [NSString stringWithFormat:@"%ld/%ld",limNum- MAX(0,limNum - existTextNum),(long)limNum];
    }
}

+ (NSString *)truncateWhiteSpaces:(NSString *)str{
    NSCharacterSet *ns = [NSCharacterSet characterSetWithCharactersInString:@"\t\n "];
    str = [str stringByTrimmingCharactersInSet:ns];
    return str?str:@"";
}

+ (BOOL)isNumText:(NSString *)str{
    NSString *regex = @"(/^[0-9]*$/)";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if(isMatch){
        return YES;
    }else{
        return NO;
    }
    
}

+ (BOOL)isLetterText:(NSString *)str{
    NSString *regex = @"[A-Za-z]+";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isPureInt:(NSString*)string{
    
    NSScanner *scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
    
}

+ (BOOL)isContainEnglishLetter:(NSString *)string{
    
    if([string rangeOfCharacterFromSet:[NSCharacterSet letterCharacterSet]].location != NSNotFound) {
        return YES;
    }
    return NO;
    
}

+ (BOOL)isContainNum:(NSString *)string{
    
    if([string rangeOfCharacterFromSet:[NSCharacterSet decimalDigitCharacterSet]].location != NSNotFound) {
        return YES;
    }
    return NO;
    
}

+ (UIImage *)snapshotScreenfromView:(UIView *)theView{
    
    UIGraphicsBeginImageContextWithOptions(theView.bounds.size, YES, 2.0f);//rootWebView是要截图的view
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [theView.layer renderInContext:context];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();//获取截图给UIImage对象viewImage
    
    UIGraphicsEndImageContext();
    return viewImage;
    
}

+ (UIColor *)randomColor{
    
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

+ (NSData *)toJSONData:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] >0 && error == nil){
        return jsonData;
    }else{
        return nil;
    }
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

+ (UIImage *)defaultImage {
	static UIImage *defaultImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 24.f), NO, 0.0f);
		
		[[UIColor blackColor] setFill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 6, 20, 1.8)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 12, 20, 1.8)] fill];
		[[UIBezierPath bezierPathWithRect:CGRectMake(0, 18, 20, 1.8)] fill];
		
		defaultImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
        
	});
    return defaultImage;
}

+ (UIImage *)defaultEditImage{
    static UIImage *defaultEditImage = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		UIGraphicsBeginImageContextWithOptions(CGSizeMake(30.f, 22.f), NO, 0.0f);
		
		[[UIColor whiteColor] setFill];
        
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(25, 3, 4, 4)] fill];
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(25, 10, 4, 4)] fill];
		[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(25, 17, 4, 4)] fill];
		
		defaultEditImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
        
	});
    return defaultEditImage;
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color{
    
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


+ (NSString *)toJSONStr:(id)theData{
    
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if ([jsonData length] > 0 && error == nil){
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }else{
        return nil;
    }

}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    NSError *parseError = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
}
//@"yyyy-MM-dd HH:mm:ss"
+ (NSString *)currentTimeWithFormatterStr:(NSString *)formatterStr{
    return [self timeWithFormatterStr:formatterStr timeDate:[NSDate date]];
}
+ (NSString *)timeWithFormatterStr:(NSString *)formatterStr timeDate:(NSDate *)date{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormat setDateFormat:formatterStr];//设定时间格式
    return [dateFormat stringFromDate:date];

}

+ (NSDate *)timeWithFormatterStr:(NSString *)formatterStr timeStr:(NSString *)dateStr{
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];//en_US
    [dateFormat setDateFormat:formatterStr];
    NSDate *date = [dateFormat dateFromString:dateStr];
    return date;

}
+ (NSDateComponents *)currentDateComponents
{
    return [self dateComponentsWithDate:[NSDate date]];
}
+ (NSDateComponents *)dateComponentsWithDate:(NSDate *)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    unsigned flags = NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSWeekdayCalendarUnit|
    NSDayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit |
    NSWeekdayOrdinalCalendarUnit;
    NSDateComponents *todayComponents = [calendar components:flags fromDate:date];
    return todayComponents;
}

+ (NSString *)weekDayOfDate:(NSDate *)date languageType:(WeekDayLanguageType)type{
    
    NSArray *weekdayArrE = @[@"SUN",@"MON",@"TUS",@"WED",@"THU",@"FRI",@"STA"];
    NSArray *weekdayArrC = @[@"週日",@"週壹",@"週貳",@"週叁",@"週肆",@"週伍",@"週陸"];
    NSDateComponents *dateCom = [Tool dateComponentsWithDate:date];
    if (type == WeekDayChinese) {
        return weekdayArrC[dateCom.weekday-1];
    }else{
        return weekdayArrE[dateCom.weekday-1];
    }
    
}

+ (NSDate *)dateOfHowManyDay:(NSInteger)dayNum{

    return [NSDate dateWithTimeIntervalSinceNow:dayNum*(24*60*60)];
    
}

+ (NSDate *)dateOfHowManyMonth:(NSInteger)monthNum{
    
    return [self dateOfHowManyMonth:monthNum date:[NSDate date]];
}

+ (NSDate *)dateOfHowManyMonth:(NSInteger)monthNum date:(NSDate *)date{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:monthNum];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}
+ (NSArray *)theWeekDaysFormatterStr:(NSString *)formatterStr{
    
    NSMutableArray *theWeekDayArr = [NSMutableArray array];
    for (NSDate *date in [self theWeekDaysDate]) {
        NSString *timeDate = [self timeWithFormatterStr:formatterStr timeDate:date];
        [theWeekDayArr addObject:timeDate];
    }
    return theWeekDayArr;
}

+ (NSArray *)theWeekDaysDate{
    
    NSMutableArray *theWeekDayArr = [NSMutableArray array];
    NSDateComponents *dateCom = [self currentDateComponents];
    NSInteger dayWeek = dateCom.weekday;
    for (NSInteger i = 0; i <= 8 - dayWeek; i++) {
        NSDate *date = [self dateOfHowManyDay:i];
        [theWeekDayArr addObject:date];
    }
    return theWeekDayArr;
}

+ (NSArray *)dateWeekDaysDate{

    NSMutableArray *theWeekDayArr = [NSMutableArray array];
    NSDateComponents *dateCom = [self currentDateComponents];
    NSInteger dayWeek = dateCom.weekday;
    for (NSInteger i = 0; i <= 8 - dayWeek; i++) {
        NSDate *date = [self dateOfHowManyDay:i];
        [theWeekDayArr addObject:date];
    }
    return theWeekDayArr;
}

+ (NSDate *)dateMonthBegin{
    return [self dateIsMonthBegin:YES];
}

+ (NSDate *)dateMonthEnd{
    return [self dateIsMonthBegin:NO];
}

+ (NSDate *)dateIsMonthBegin:(BOOL)isBegin{
    NSDate *newDate = [NSDate date];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return nil;
    }
    if (isBegin) {
        return beginDate;
    }
    return endDate;
}
+ (NSInteger)numOfMonthDay{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSRange range = [calendar rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:[NSDate date]];
    NSUInteger numberOfDaysInMonth = range.length;
    return numberOfDaysInMonth;
}

+ (NSInteger)getWeekOfFirstDayOfYear:(NSInteger)year withMonth:(NSInteger)month{
    
    NSString *firstWeekDayMonth = [[NSString alloc] initWithFormat:@"%ld",(long)year];
    firstWeekDayMonth = [firstWeekDayMonth stringByAppendingString:[[NSString alloc]initWithFormat:@"%s","-"]];
    firstWeekDayMonth = [firstWeekDayMonth stringByAppendingString:[[NSString alloc]initWithFormat:@"%ld",(long)month]];
    firstWeekDayMonth = [firstWeekDayMonth stringByAppendingString:[[NSString alloc]initWithFormat:@"%s","-"]];
    firstWeekDayMonth = [firstWeekDayMonth stringByAppendingString:[[NSString alloc]initWithFormat:@"%d",1]];
    NSDate *weekOfFirstDayOfMonth = [self timeWithFormatterStr:@"yyyy-MM-dd" timeStr:firstWeekDayMonth];
    
    //    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //    NSDateComponents *newCom = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday fromDate:weekOfFirstDayOfMonth];
    NSDateComponents *newCom = [self dateComponentsWithDate:weekOfFirstDayOfMonth];
    
    return  [newCom weekday] - 1;
    
}
//返回一个月有多少天
+ (NSInteger)getDaysOfYear:(NSInteger)year withMonth:(NSInteger)month{
    
    NSInteger days = 0;
    //1,3,5,7,8,10,12
    NSArray *bigMoth = [[NSArray alloc] initWithObjects:@"1",@"3",@"5",@"7",@"8",@"10",@"12", nil];
    //4,6,9,11
    NSArray *milMoth = [[NSArray alloc] initWithObjects:@"4",@"6",@"9",@"11", nil];
    
    if ([bigMoth containsObject:[[NSString alloc] initWithFormat:@"%ld",(long)month]]) {
        days = 31;
    }else if([milMoth containsObject:[[NSString alloc] initWithFormat:@"%ld",(long)month]]){
        days = 30;
    }else{
        if ([self isLoopYear:year]) {
            days = 29;
        }else
            days = 28;
    }
    return days;
}
//判断是否是闰年
+ (BOOL)isLoopYear:(NSInteger)year{
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
        return true;
    }else
        return NO;
}

+ (NSInteger)daysHowManyMonth:(NSInteger)month{
//    NSDate *startDate = [NSDate date];
//    NSDate *endDate = [self dateOfHowManyMonth:month];
//    //得到相差秒数
//    NSTimeInterval time=[endDate timeIntervalSinceDate:startDate];
//    
//    NSInteger days = ((int)time)/(3600*24);
//    return days;
   return [self daysBetweenDate:[NSDate date] andDate:[self dateOfHowManyMonth:month]];
}

+ (NSInteger)daysBetweenDate:(NSDate *)beginDate andDate:(NSDate *)endDate{
    //得到相差秒数
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    NSInteger days = ((int)time)/(3600*24);
    return days;
}

+ (NSInteger)monthsBetweenDate:(NSDate *)beginDate andDate:(NSDate *)endDate{
    NSInteger months;
    NSDateComponents *beginCom = [self dateComponentsWithDate:beginDate];
    NSDateComponents *endCom = [self dateComponentsWithDate:endDate];
    if (endCom.year > beginCom.year) {
        months = (endCom.year - beginCom.year)*12 + endCom.month - beginCom.month;
    }else{
        months = endCom.month - beginCom.month;
    }
    return months;
}

+ (BOOL)dateIsSeries:(NSArray *)dateArr{
//    DLog(@"dateIsSeries = %d",dateArr.count);
    dateArr = [self arrSort:dateArr];
    NSInteger k = 0;
    NSInteger count = dateArr.count;
    for (int i = 0; i < count; i++) {
        NSDate *obj = dateArr[i];
//        DLog(@"obj = %@",obj);
        NSDate *tomDay = [self dateTomorrow:obj];
        if (i == count - 1) {
            break;
        }
        for (int j = i+1; j < count; j++) {
            NSDate *date = dateArr[j];
            if ([date isEqual:obj]) {
                continue;
            }
//            DLog(@"date = %@ ,tomDay = %@",date,tomDay);
            if ([self isEqualToDateIgnoringTime:tomDay secondDate:date]) {
                k++;
                break;
            }
        }
    }
    if (k == count-1) {
        return YES;
    }else{
        return NO;
    }
}
//从小到大排序
+ (NSArray *)arrSort:(NSArray *)arr{
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSComparisonResult result = [obj1 compare:obj2];
        return result;
    }];
    return arr;
}

+ (NSDate *)dateTomorrow:(NSDate *)date{
    
    NSTimeInterval aTimeInterval = [date timeIntervalSinceReferenceDate] + 86400 * 1;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateYesterday:(NSDate *)date{
    NSTimeInterval aTimeInterval = [date timeIntervalSinceReferenceDate] + 86400 * -1;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

+ (NSDate *)dateOfHowManyDay:(NSInteger)dayNum byDate:(NSDate *)date{
    NSTimeInterval aTimeInterval = [date timeIntervalSinceReferenceDate] + 86400 * dayNum;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

//判断日历时间是相同
+ (BOOL)isEqualToDateIgnoringTime:(NSDate *)firstDate secondDate:(NSDate *)secondDate{

    NSDateComponents *components1 = [Tool dateComponentsWithDate:firstDate];
    NSDateComponents *components2 = [Tool dateComponentsWithDate:secondDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

//比较是否在该范围日期之内
+ (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

+ (NSInteger)distanceInDaysToDate:(NSDate *)beginDate andDate:(NSDate*)endDate{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    [gregorianCalendar rangeOfUnit:NSDayCalendarUnit startDate:&endDate interval:NULL forDate:endDate];
    [gregorianCalendar rangeOfUnit:NSDayCalendarUnit startDate:&beginDate interval:NULL forDate:beginDate];
    
    NSDateComponents *components = [gregorianCalendar components:NSDayCalendarUnit fromDate:beginDate toDate:endDate options:0];
    return components.day+1;
}

+ (BOOL)validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
    
}
//判断手机正则表达式
#define PHONE_REGEX_NAME @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,0-9]))\\d{8}$"
+ (BOOL)validateMobile:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE_M = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE_M];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

+ (BOOL)validateMobileHK:(NSString *)mobileNum{
    
    if ([mobileNum hasPrefix:@"9"]||[mobileNum hasPrefix:@"6"]||[mobileNum hasPrefix:@"2"]) {
        if (mobileNum.length == 8) {
            return YES;
        }
    }
    return NO;
}


+ (BOOL)stringContainsEmoji:(NSString *)string{
    
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     returnValue = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 returnValue = YES;
             }
             
         } else {
             // non surrogate
             if (0x2100 <= hs && hs <= 0x27ff) {
                 returnValue = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 returnValue = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 returnValue = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 returnValue = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                 returnValue = YES;
             }
         }
     }];
    
    return returnValue;
}

+ (NSString *)getIPAddress{
    
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}



+ (UIImage *)dealImage:(UIImage *)oriImg width:(CGFloat)width cQuality:(CGFloat)quality{
    if (width == 0) {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    if (quality == 0) {
        quality = 0.1;
    }
    NSData *imageData;
    UIImage *imageNew;
    NSInteger imageLength = [self imageLength:oriImg];
    if (imageLength > TLMI_IMA_KB) {
        imageData = UIImageJPEGRepresentation(oriImg, quality);
        imageNew = [UIImage imageWithData:imageData];
    }else{
        imageNew = oriImg;
    }
    CGSize size = imageNew.size;
    if (size.width > width) {
        imageNew = [self imageWithImage:imageNew scaledToSize:CGSizeMake(width /size.height*size.width, width)];
    }
    
    return imageNew;
}

+ (NSArray *)dealImageArr:(NSArray *)oriImgs width:(CGFloat)width cQuality:(CGFloat)quality{
    if (width == 0) {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    if (quality == 0) {
        quality = 0.1;
    }
    NSMutableArray *imgs = [NSMutableArray array];
    [oriImgs enumerateObjectsUsingBlock:^(UIImage *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [imgs addObject:[self dealImage:obj width:width cQuality:quality]];
    }];
    return imgs;
}

//对图片尺寸进行压缩--
+ (UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
//返回多少K大小的图片
+ (NSInteger)imageLength:(UIImage *)image{
    NSData *data;
    if (UIImagePNGRepresentation(image) == nil) {
        data = UIImageJPEGRepresentation(image, 1.0);
    } else {
        data = UIImagePNGRepresentation(image);
    }
    return data.length/1024;
}

+ (NSString *)compareCurrentTime:(id)compareDate{
    
    if([compareDate isKindOfClass:[NSString class]]){
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        compareDate =[dateFormat dateFromString:(NSString *)compareDate];
    }
    
    NSTimeInterval timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if(timeInterval < 60){
        result = [NSString stringWithFormat:@"%d秒前",(int)timeInterval];
    }else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
    
}

+ (NSString *)timeDescripeWithDeltaTime:(id)timeDelta{
    
    NSString *result;
    float timeInterval = [timeDelta floatValue];
    long temp = 0;
    if(timeInterval < 60){
        result = [NSString stringWithFormat:@"%d秒前",(int)timeInterval];
    }else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
    
}

#pragma mark - 返回节假日

+ (NSString *)holidayYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day{
    
    NSString *solarYear = [self lunarForSolarYear:year month:month day:day];
    NSArray *solarYear_arr= [solarYear componentsSeparatedByString:@"-"];
    //农历节日
    if([solarYear_arr[0]isEqualToString:@"正"] &&
       [solarYear_arr[1]isEqualToString:@"初一"]){
        //正月初一：春节
        return  @"春节";
    }else if([solarYear_arr[0]isEqualToString:@"正"] &&
             [solarYear_arr[1]isEqualToString:@"十五"]){
        //正月十五：元宵节
        return @"元宵";
    }else if([solarYear_arr[0]isEqualToString:@"五"] &&
             [solarYear_arr[1]isEqualToString:@"初五"]){
        //五月初五：端午节
        return @"端午";
    }else if([solarYear_arr[0]isEqualToString:@"七"] &&
             [solarYear_arr[1]isEqualToString:@"初七"]){
        //七月初七：七夕情人节
        return @"七夕";
    }else if([solarYear_arr[0]isEqualToString:@"八"] &&
             [solarYear_arr[1]isEqualToString:@"十五"]){
        //八月十五：中秋节
        return @"中秋";
    }else if([solarYear_arr[0]isEqualToString:@"九"] &&
             [solarYear_arr[1]isEqualToString:@"初九"]){
        //九月初九：重阳节、中国老年节（义务助老活动日）
        return @"重阳";
    }else if([solarYear_arr[0]isEqualToString:@"腊"] &&
             [solarYear_arr[1]isEqualToString:@"初八"]){
        //腊月初八：腊八节
        return @"腊八";
    }else if([solarYear_arr[0]isEqualToString:@"腊"] &&
             [solarYear_arr[1]isEqualToString:@"二十四"]){
        //腊月二十四 小年
        return @"小年";
    }else if([solarYear_arr[0]isEqualToString:@"腊"] &&
             [solarYear_arr[1]isEqualToString:@"三十"]){
        //腊月三十（小月二十九）：除夕
        return @"除夕";
    }
    //公历节日
    if (month == 1 && day == 1){
        return @"元旦";
    }else if (month == 2 && day == 14){
        return  @"情人节";
    }else if (month == 3 && day == 8){
        return  @"妇女节";
    }else if (month == 5 && day == 1){
        return  @"劳动节";
    }else if (month == 6 && day == 1){
        return @"儿童节";
    }else if (month == 8 && day == 1){
        return @"建军节";
    }else if (month == 9 && day == 10){
        return @"教师节";
    }else if (month == 10 && day == 1){
        return @"国庆节";
    }
    return nil;
}

+ (NSString *)lunarForSolarYear:(int)wCurYear month:(int)wCurMonth day:(int)wCurDay{
    
    //农历日期名
    NSArray *cDayName =  [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                          @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                          @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    //农历月份名
    NSArray *cMonName =  [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
    
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static int nTheDate,nIsEnd,m,k,n,i,nBit;
    
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1)
    {
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
    
    
    //生成农历月
    NSString *szNongliMonth;
    if (wCurMonth < 1){
        szNongliMonth = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
    }else{
        szNongliMonth = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    
    //生成农历日
    NSString *szNongliDay = [cDayName objectAtIndex:wCurDay];
    
    //合并
    NSString *lunarDate = [NSString stringWithFormat:@"%@-%@",szNongliMonth,szNongliDay];
    
    return lunarDate;
}



+ (float)heightForLabelWithStr:(NSString *)str width:(float)width fontSize:(float)fontSize{
    str = [self filterString:str];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 0) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    return size.height;
    
}

+ (float)widthForLabelWithStr:(NSString *)str height:(float)height fontSize:(float)fontSize{
    
    str = [self filterString:str];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(0, height) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading | NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
    return size.width;
    
}
//过滤非法字符
+ (NSString *)filterString:(NSString *)str{
    NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"‍"];
    str = [[str componentsSeparatedByCharactersInSet: doNotWant]componentsJoinedByString: @""];
    return str;
}

+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

#define MAX_STR_COUNT 45

+ (NSString *)subStrForCell:(NSString *)str{
    
    if(str.length<MAX_STR_COUNT){
        return str;
    }
    
    if(str.length>=MAX_STR_COUNT){
        return [NSString stringWithFormat:@"%@...", [str substringToIndex:MAX_STR_COUNT]];
    }
    
    return nil;
}

+ (BOOL)isAuthCamera{
    
    BOOL isCameraValid = YES;
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus != AVAuthorizationStatusAuthorized)
    {
        isCameraValid = NO;
    }
    
    return isCameraValid;
    
}


+ (void)save:(NSString *)service data:(id)data{
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((__bridge CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(__bridge id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL);
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service{
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (__bridge id)kSecClassGenericPassword,(__bridge id)kSecClass,
            service, (__bridge id)kSecAttrService,
            service, (__bridge id)kSecAttrAccount,
            (__bridge id)kSecAttrAccessibleAfterFirstUnlock,(__bridge id)kSecAttrAccessible,
            nil];
}

+ (id)loadKeyChainValueWithKey:(NSString *)service{
    
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
    
}

/** @name Utility Functions */
#pragma mark - Utility Functions
float translateValueFromSourceIntervalToDestinationInterval(float sourceValue, float sourceIntervalMinimum, float sourceIntervalMaximum, float destinationIntervalMinimum, float destinationIntervalMaximum) {
	float a, b, destinationValue;
	
	a = (destinationIntervalMaximum - destinationIntervalMinimum) / (sourceIntervalMaximum - sourceIntervalMinimum);
	b = destinationIntervalMaximum - a*sourceIntervalMaximum;
	
	destinationValue = a*sourceValue + b;
	
	return destinationValue;
}

CGFloat angleBetweenThreePoints(CGPoint centerPoint, CGPoint p1, CGPoint p2) {
	CGPoint v1 = CGPointMake(p1.x - centerPoint.x, p1.y - centerPoint.y);
	CGPoint v2 = CGPointMake(p2.x - centerPoint.x, p2.y - centerPoint.y);
	
	CGFloat angle = atan2f(v2.x*v1.y - v1.x*v2.y, v1.x*v2.x + v1.y*v2.y);
	
	return angle;
}

+ (NSInteger)numIsChinese :(NSString *)str{
    //去除左右空格
    str = [str stringByTrimmingCharactersInSet:
           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSUInteger length = [str length];
    NSUInteger num = 0;
    for (NSUInteger i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [str substringWithRange:range];
        const char    *cString = [subString UTF8String];
        if (strlen(cString) == 3)
        {
            num++;
        }
    }
    return num;
}
+ (NSInteger)numIsEnglish :(NSString *)str{
    //去除左右空格
    str = [str stringByTrimmingCharactersInSet:
           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    int length = (int)[str length];
    int num = 0;
    for (int i=0; i<length; ++i)
    {
        NSRange range = NSMakeRange(i, 1);
        NSString *subString = [str substringWithRange:range];
        const char    *cString = [subString UTF8String];
        if (strlen(cString) == 1)
        {
            num++;
        }
    
    }
    return num;
    
}

+ (BOOL)ifReptationnWithStr:(NSString *)str{

    NSInteger repeatTime=-1;
    NSString *unit,*unitSec,*unitThird,*unitFourth;
    for (NSInteger i = 0; i < str.length; i++) {
        if(repeatTime==4){
            break;
        }
        int unitLength = 2;
        for(int j =0;j < str.length-(i+1);j++){
            if(unitLength*2>(str.length-i) || unitLength*3>(str.length-i)|| unitLength*4>(str.length-i)){
                break;
            }
            unit = [str substringWithRange:NSMakeRange(i, unitLength)];
            unitSec = [str substringWithRange:NSMakeRange(unitLength+i, unitLength)];
            unitThird = [str substringWithRange:NSMakeRange(unitLength*2+i,  unitLength)];
            unitFourth = [str substringWithRange:NSMakeRange(unitLength*3+i,  unitLength)];
            if([unit isEqualToString:unitSec] && [unit isEqualToString:unitThird] && [unit isEqualToString:unitFourth]){
                repeatTime=4;
                break;
            }
            unitLength=unitLength+1;
        }
    }
    if (repeatTime == 4) {
        return YES;
    }else{
        return NO;
    }
    
}

//手机号码中间4位用*代替
+ (NSString *)phoneNumWithStr:(NSString *)phoneStr{
    
    NSMutableString *str = [NSMutableString stringWithString:phoneStr];
    [str replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return str;
}


+ (UIButton *)rightBarBtnItemWithTitle:(NSString *)title withImage:(UIImage *)image{
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightbutton setFrame:CGRectMake(0, 0, 40, 30)];
    if(image){
        [rightbutton setImage:image forState:UIControlStateNormal];
    }else{
        [rightbutton setTitle:title forState:UIControlStateNormal];
        rightbutton.titleLabel.font = [UIFont boldSystemFontOfSize: 16.0];
        [rightbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    }
    return rightbutton;
    
}

+ (UIButton *)leftBarBtnItemWithTitle:(NSString *)title withImage:(UIImage *)image{
    
    UIButton *leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftbutton setFrame:CGRectMake(0, 0, 40, 30)];
    if(image){
        [leftbutton setImage:image forState:UIControlStateNormal];
    }else{
        [leftbutton setTitle:title forState:UIControlStateNormal];
        leftbutton.titleLabel.font = [UIFont boldSystemFontOfSize: 16.0];
        [leftbutton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
    }
    return leftbutton;
    
}
+ (void)writeFileToPathName:(NSString *)fileName andFile:(id)file {

    NSString *path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject] stringByAppendingPathComponent:fileName];
    // 先删除已经存在的文件
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    [defaultManager removeItemAtPath:path error:nil];
    [file writeToFile:path atomically:YES];
}
+ (id)getFileFromPathName:(NSString *)fileName withType:(WirtefileType)type{
    
    NSString *path=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES)lastObject] stringByAppendingPathComponent:fileName];
    if (type == NSArrayFileType) {
        return [NSArray arrayWithContentsOfFile:path];
    }else if (type == NSDictionaryFileType){
        return [NSDictionary dictionaryWithContentsOfFile:path];
        
    }
    return nil;
}
+ (id)classForID:(id)object{
    return [object class];
}

+ (NSString *)getPhoneStr:(NSString *)phoneStr{
    
    NSMutableString *str = [NSMutableString stringWithString:phoneStr];
    [str replaceOccurrencesOfString:@"-" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, str.length)];
    return str;
}
+ (void)callPhone:(NSString *)phoneNum{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNum]]];
}

+ (NSString*)chineseTopinyin:(NSString*)chineseString
{
    
    
    NSString *resultString = @"";
    chineseString = [NSMutableString stringWithString:chineseString];
    //需要先转化成带声调的拼音，才能转化成不带音调的。所以进行了两步。
    if (CFStringTransform((__bridge CFMutableStringRef)chineseString, 0, kCFStringTransformMandarinLatin, NO))
    {
        
    }
    
    if (CFStringTransform((__bridge CFMutableStringRef)chineseString, 0, kCFStringTransformStripCombiningMarks, NO))
    {
        NSArray *resultStringArray = [chineseString componentsSeparatedByString:@" "];
        
        for (NSString *string in resultStringArray) {
            
            resultString  = [resultString stringByAppendingString:string];
        }
    }

    
    return resultString ;
    
}

+ (NSString *)strDateFormatStrD:(NSString *)date{
    NSMutableString *str = [NSMutableString stringWithString:date];
    [str replaceOccurrencesOfString:@"-" withString:@"." options:1 range:NSMakeRange(0, str.length)];
    return str;
}

+ (NSString *)strDateFormatStrDW:(NSString *)date{
//    DLog(@"date = %@",date);
    if (!date.length) {
        return @"";
    }
    NSArray *strArr = [date componentsSeparatedByString:@" "];
    NSMutableString *str = [NSMutableString stringWithString:[strArr firstObject]];
    // ------ ' - '  用 ' . ' 代替
    //[str replaceOccurrencesOfString:@"-" withString:@"." options:1 range:NSMakeRange(0, str.length)];
    return str;
}

+ (NSString *)deviceID{
    NSMutableString *str = [NSMutableString stringWithString:[[[UIDevice currentDevice]identifierForVendor]UUIDString]];
    [str replaceOccurrencesOfString:@"-" withString:@"" options:1 range:NSMakeRange(0, str.length)];
    return str;
}

+ (NSString *)moneyKTP:(id)num{
    
    if ([num isKindOfClass:[NSString class]]) {
        NSString *value = (NSString *)num;
        return [NSString stringWithFormat:@"%.2f",value.floatValue];
    }else if([num isKindOfClass:[NSNumber class]]){
        NSNumber *value = (NSNumber *)num;
        return [NSString stringWithFormat:@"%.2f",value.floatValue];
    }
    return @"0";
}

+ (NSString *)money:(NSString *)num{
    NSString *outNumber;
    return  outNumber = [NSString stringWithFormat:@"%@",@(num.floatValue)];
}

+ (NSString *)numThousand:(NSString *)num{
    NSString *str;
    CGFloat count = num.floatValue;
    if (count >= 10000.0) {
        str = [NSString stringWithFormat:@"%.1fk",count/10000];
    }else{
        str = num;
    }
    return str;
}

//判断字符串为6～12位“字符”
+ (NSInteger)isValidateName:(NSString *)name{
    NSUInteger  character = 0;
    for(int i=0; i< [name length];i++){
        int a = [name characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff){ //判断是否为中文
            character +=2;
        }else{
            character +=1;
        }
    }
    
    if (character >4 && character <=6) {
        return 3;
    }else if(character >6){
        return 4;
    }else{
        return 2;
    }
}

@end
