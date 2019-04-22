//
//  ViewController.m
//  LZModuleDispatcher
//
//  Created by 刘著 on 2019/4/11.
//  Copyright © 2019 刘著. All rights reserved.
//

#import "ViewController.h"
#import "LZModuleDispatcher.h"
#import "LZModuleDispatcherProtocol.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *array = [self loadModulesFromPlistFile];
    id<LZModuleDispatcherProtocol> dispatch = (id<LZModuleDispatcherProtocol>)[LZModuleDispatcher protocolDispatcher:@protocol(LZModuleDispatcherProtocol) moduleList:array];
    
    [dispatch viewDidLoad];
}

- (NSArray *)loadModulesFromPlistFile
{
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"module_list" ofType:@"plist"];

    NSArray<NSString *> *moduleNames = [NSArray arrayWithContentsOfFile:plistPath];

    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:2];
    
    for (NSString* class in moduleNames) {
        if (![class isKindOfClass:[NSString class]])
            continue;
        NSObject *obj = [NSClassFromString(class) new];
        if (obj) {
            [arrM addObject:obj];
        }
    }
    return [arrM copy];
}



@end
