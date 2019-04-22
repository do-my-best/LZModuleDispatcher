//
//  LZModuleDispatcher.h
//  LZModuleDispatcher
//
//  Created by 刘著 on 2019/4/11.
//  Copyright © 2019 刘著. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZModuleDispatcher : NSObject

+ (instancetype)protocolDispatcher:(Protocol*)protocol moduleList:(NSArray *)moduleList;

@end

NS_ASSUME_NONNULL_END
