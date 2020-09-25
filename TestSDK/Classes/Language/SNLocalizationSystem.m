//
//  SNLocalizationSystem.m
//  
//
//  Created by SNde on 2017/3/15.
//
//

#import "SNLocalizationSystem.h"

@implementation SNLocalizationSystem

+(SNLocalizationSystem *)shareLocalSystem {
    static SNLocalizationSystem *onlyOne;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        onlyOne = [[SNLocalizationSystem alloc]init];
//        onlyOne->_bundle = [NSBundle mainBundle];
        [onlyOne setValue:[NSBundle mainBundle] forKey:@"bundle"];
    });
    return onlyOne;
}

+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)comment {
    SNLocalizationSystem *onlyOne = [SNLocalizationSystem shareLocalSystem];
    return [onlyOne.bundle localizedStringForKey:key value:comment table:nil];
}

+ (NSString *)localizedStringForKey:(NSString *)key table:(NSString *)tableName {
    SNLocalizationSystem *onlyOne = [SNLocalizationSystem shareLocalSystem];
    return [onlyOne.bundle localizedStringForKey:key value:nil table:tableName];
}

+ (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)comment table:(NSString *)tableName {
    SNLocalizationSystem *onlyOne = [SNLocalizationSystem shareLocalSystem];
    return [onlyOne.bundle localizedStringForKey:key value:comment table:tableName];
}

+ (void)setLanguage:(NSString*) language{
    SNLocalizationSystem *onlyOne = [SNLocalizationSystem shareLocalSystem];

    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    
    if (!path) {
        [onlyOne setValue:[NSBundle mainBundle] forKey:@"bundle"];

    } else {
        [onlyOne setValue:[NSBundle bundleWithPath:path] forKey:@"bundle"];
        [[NSUserDefaults standardUserDefaults] setObject:language forKey:@"AppLanguages"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    [[NSNotificationCenter defaultCenter]postNotificationName:SNLocalizationSystemLanguageDidChange object:nil];

}

+ (NSString*)getLanguage {
    NSString *preferredLang = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppLanguages"];
    return preferredLang;
}



@end
