//
//  Tool.h
//  InfoProvider
//
//  Created by zhengzeqin on 14-8-13.
//  Copyright (c) 2014年 zzq. All rights reserved.
//



// 到此一游 // 到此一游// 到此一游// 到此一游// 到此一游// 到此一游// 到此一游

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tool : NSObject
typedef enum : NSUInteger {
    NSArrayFileType = 0,
    NSDictionaryFileType
} WirtefileType;

typedef enum : NSUInteger {
    WeekDayEnglish = 0,
    WeekDayChinese
} WeekDayLanguageType;

+ (NSString *)toJSONStr:(id)theData;
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;
+ (NSData *)toJSONData:(id)theData;
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;
+ (UIButton *)barBtnItemWithTitle:(NSString *)title withImage:(UIImage *)image;
+ (NSString *)fullPathAtCache:(NSString *)fileName;
+ (NSString *)saveImageToLocalWithImageData:(NSData *)imageData andPath:(NSString *)path;
+ (NSMutableAttributedString*)underLineAttributeStringWithText:(NSString *)text;
+ (NSMutableAttributedString*)underLineAttributeStringWithText:(NSString *)text color:(UIColor *)color fontSize:(NSInteger)size;

+ (NSMutableAttributedString*)attributeStringWithText:(NSString *)text color:(UIColor *)color font:(UIFont *)font;
+ (NSMutableAttributedString *)attLineStrWithText:(NSString *)str color:(UIColor *)color fontSize:(NSInteger)size;
+ (NSAttributedString *)attStr:(NSString *)str colorStrArr:(NSArray *)strArr color:(UIColor *)color fontSize:(NSInteger )size;
+ (NSInteger)currentTextViewNum:(UIView *)textView;
+ (void)limitTextFieldWord:(UITextField *)obj length:(NSInteger)legnth;
+ (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text limNum:(NSInteger)limNum label:(UILabel *)label;
+ (void)textViewDidChange:(UITextView *)textView limNum:(NSInteger)limNum label:(UILabel *)label;
+ (void)setZanBtnStateWithTitle:(NSString *)title button:(UIButton *)zanBtn andTotalWidth:(float)width;
+ (UIImage *)snapshotScreenfromView:(UIView *)theView;
+ (UIColor *)randomColor;
+ (UIColor *)colorWithHexString:(NSString *)color;
+ (BOOL)isNumText:(NSString *)str;
+ (BOOL)isPureInt:(NSString*)string;
+ (BOOL)isLetterText:(NSString *)str;
+ (BOOL)isContainEnglishLetter:(NSString *)string;
+ (BOOL)isContainNum:(NSString *)string;
+ (NSString *)truncateWhiteSpaces:(NSString *)str;

+ (UIImage *)defaultImage;
+ (UIImage *)defaultEditImage;

//当前时间格式化成指定字符串
+ (NSString *)currentTimeWithFormatterStr:(NSString *)formatterStr;
//指定时间格式化成指定字符串
+ (NSString *)timeWithFormatterStr:(NSString *)formatterStr timeDate:(NSDate *)date;
//指定的时间字符串按指定的格式化转成时间
+ (NSDate *)timeWithFormatterStr:(NSString *)formatterStr timeStr:(NSString *)dateStr;
//获取日期组件
+ (NSDateComponents *)currentDateComponents;
+ (NSDateComponents *)dateComponentsWithDate:(NSDate *)date;
//星期几
+ (NSString *)weekDayOfDate:(NSDate *)date languageType:(WeekDayLanguageType)type;
//第几天的日期(正数为第几天后，负数为第几天前日期)
+ (NSDate *)dateOfHowManyDay:(NSInteger)dayNum;
//莫个日期后的第几天后日期
+ (NSDate *)dateOfHowManyDay:(NSInteger)dayNum byDate:(NSDate *)date;
//第几月的日期(正数为第几月后，负数为第几月前日期)
+ (NSDate *)dateOfHowManyMonth:(NSInteger)monthNum;
//莫个日期  第几月的日期(正数为第几月后，负数为第几月前日期)
+ (NSDate *)dateOfHowManyMonth:(NSInteger)monthNum date:(NSDate *)date;
//获取这天到周末的所有星期日期，假如是周日则获取下周的星期日期，返回NSString的数据数组
+ (NSArray *)theWeekDaysFormatterStr:(NSString *)formatterStr;
//同上，返回NSDate的数据数组
+ (NSArray *)theWeekDaysDate;
//获取当月的第一天
+ (NSDate *)dateMonthBegin;
//获取当月的最后一天
+ (NSDate *)dateMonthEnd;
//当月多少天
+ (NSInteger)numOfMonthDay;
//获得某年某月的第一天是星期几
+ (NSInteger)getWeekOfFirstDayOfYear:(NSInteger)year withMonth:(NSInteger)month;
//返回某年某月有多少天
+ (NSInteger)getDaysOfYear:(NSInteger)year withMonth:(NSInteger)month;
//判断是否是闰年
+ (BOOL)isLoopYear:(NSInteger)year;
//多少月内多少天
+ (NSInteger)daysHowManyMonth:(NSInteger)month;
//间隔天数
+ (NSInteger)daysBetweenDate:(NSDate *)beginDate andDate:(NSDate *)endDate;
//相隔多少月
+ (NSInteger)monthsBetweenDate:(NSDate *)beginDate andDate:(NSDate *)endDate;
//判断该数组日期是否连续
+ (BOOL)dateIsSeries:(NSArray *)dateArr;
+ (NSInteger)distanceInDaysToDate:(NSDate *)beginDate andDate:(NSDate*)endDate;
+ (NSString *)compareCurrentTime:(id)compareDate;
+ (NSString *)timeDescripeWithDeltaTime:(id)timeDelta;
+ (NSString *)holidayYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;
+ (BOOL)validateEmail:(NSString *)email;
+ (BOOL)validateMobile:(NSString *)mobileNum;
+ (BOOL)validateMobileHK:(NSString *)mobileNum;
+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (BOOL)isAuthCamera;
+ (NSString *)getIPAddress;

+ (UIImage *)dealImage:(UIImage *)oriImg width:(CGFloat)width cQuality:(CGFloat)quality;
+ (NSArray *)dealImageArr:(NSArray *)oriImgs width:(CGFloat)width cQuality:(CGFloat)quality;
+ (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;
+ (NSInteger)imageLength:(UIImage *)image;
+ (float)heightForLabelWithStr:(NSString *)str width:(float)width fontSize:(float)fontSize;
+ (float)widthForLabelWithStr:(NSString *)str height:(float)height fontSize:(float)fontSize;
+ (NSString *)filterString:(NSString *)str;
+ (UIImage *)imageWithColor:(UIColor *)color;

+ (NSString *)subStrForCell:(NSString *)str;



+ (void)save:(NSString *)service data:(id)data;
+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service;
+ (id)loadKeyChainValueWithKey:(NSString *)key;

+ (NSInteger)numIsChinese :(NSString *)str;
+ (NSInteger)numIsEnglish :(NSString *)str;
+ (BOOL)ifReptationnWithStr:(NSString *)str;
+ (NSString *)phoneNumWithStr:(NSString *)phoneStr;
+ (UIButton *)rightBarBtnItemWithTitle:(NSString *)title withImage:(UIImage *)image;
+ (UIButton *)leftBarBtnItemWithTitle:(NSString *)title withImage:(UIImage *)image;

+ (void)writeFileToPathName:(NSString *)fileName andFile:(id)file;
+ (id)getFileFromPathName:(NSString *)fileName withType:(WirtefileType)type;
+ (id)classForID:(id)object;

//获取手机号码去掉中间横线
+ (NSString *)getPhoneStr:(NSString *)phoneStr;
//拨打电话
+ (void)callPhone:(NSString *)phoneNum;
+ (NSString*)chineseTopinyin:(NSString*)chineseString;
//将日期-替换成.
+ (NSString *)strDateFormatStrD:(NSString *)date;
+ (NSString *)strDateFormatStrDW:(NSString *)date;
+ (NSString *)deviceID;
//排序从大到小
+ (NSArray *)arrSort:(NSArray *)arr;
+ (void)setLineStr:(NSString *)str label:(UILabel *)label color:(UIColor *)color;
//保留两位小数点
+ (NSString *)moneyKTP:(id)num;
+ (NSString *)money:(NSString *)num;
+ (NSString *)numThousand:(NSString *)num;
//中文的字数
//判断字符串为6～12位“字符”
+ (NSInteger)isValidateName:(NSString *)name;
@end

/** @name Utility Functions */
#pragma mark - Utility Functions
/**
 * Translate a value in a source interval to a destination interval
 * @param sourceValue					The source value to translate
 * @param sourceIntervalMinimum			The minimum value in the source interval
 * @param sourceIntervalMaximum			The maximum value in the source interval
 * @param destinationIntervalMinimum	The minimum value in the destination interval
 * @param destinationIntervalMaximum	The maximum value in the destination interval
 * @return	The value in the destination interval
 *
 * This function uses the linear function method, a.k.a. resolves the y=ax+b equation where y is a destination value and x a source value
 * Formulas :	a = (dMax - dMin) / (sMax - sMin)
 *				b = dMax - a*sMax = dMin - a*sMin
 */
float translateValueFromSourceIntervalToDestinationInterval(float sourceValue, float sourceIntervalMinimum, float sourceIntervalMaximum, float destinationIntervalMinimum, float destinationIntervalMaximum);
/**
 * Returns the smallest angle between three points, one of them clearly indicated as the "junction point" or "center point".
 * @param centerPoint	The "center point" or "junction point"
 * @param p1			The first point, member of the [centerPoint p1] segment
 * @param p2			The second point, member of the [centerPoint p2] segment
 * @return				The angle between those two segments
 
 * This function uses the properties of the triangle and arctan (atan2f) function to calculate the angle.
 */
CGFloat angleBetweenThreePoints(CGPoint centerPoint, CGPoint p1, CGPoint p2);