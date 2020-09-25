//
//  SNLocalizationSystem.h
//  
//
//  Created by SNde on 2017/3/15.
//
//

#import <Foundation/Foundation.h>


#define SNLocalizeWithComment(key, comment) \
[SNLocalizationSystem localizedStringForKey:(key) value:(comment)]

#define SNLocalizeString(key) \
[SNLocalizationSystem localizedStringForKey:(key) value:(nil)]

#define SNLocalizeForTableName(key, interfaceName) \
[SNLocalizationSystem localizedStringForKey:(key) table:(interfaceName)]

#define SNLocalizeSetLanguage(language) \
[SNLocalizationSystem setLanguage:language]

#define SNLocalizeGetLanguage \
[SNLocalizationSystem getLanguage]


static NSString* SNLocalizationSystemLanguageDidChange = @"SNLocalizationSystemLanguageDidChange";

@interface SNLocalizationSystem : NSObject
@property (strong,nonatomic,readonly) NSBundle* bundle;

+ (NSString*)getLanguage;
+ (void)setLanguage:(NSString*)language;

+ (NSString*)localizedStringForKey:(NSString *)key value:(NSString *)comment;
+ (NSString*)localizedStringForKey:(NSString *)key table:(NSString *)tableName;
+ (NSString*)localizedStringForKey:(NSString *)key value:(NSString *)comment table:(NSString *)tableName;


@end
