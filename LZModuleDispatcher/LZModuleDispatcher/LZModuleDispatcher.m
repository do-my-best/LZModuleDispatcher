//
//  LZModuleDispatcher.m
//  LZModuleDispatcher
//
//  Created by 刘著 on 2019/4/11.
//  Copyright © 2019 刘著. All rights reserved.
//

#import "LZModuleDispatcher.h"
#import <objc/runtime.h>

@interface LZModuleDispatcher()

@property (nonatomic, copy) NSArray *moduleList;

@property (nonatomic, strong) Protocol * protocol;

@end

@implementation LZModuleDispatcher

+ (instancetype)protocolDispatcher:(Protocol*)protocol moduleList:(NSArray *)moduleList{
    
    LZModuleDispatcher *dispatcher = nil;
    BOOL isConfirm = [self confirmsProtocolFormDispatcher:moduleList protocol:protocol ];
    
    if (isConfirm) {
        dispatcher = [[LZModuleDispatcher alloc] init];
        dispatcher.moduleList = moduleList;
        dispatcher.protocol = protocol;
    }
    return dispatcher;
}


+ (BOOL)confirmsProtocolFormDispatcher:(NSArray *)moduleList protocol:(Protocol*)protocol
{
    
    for (id object in moduleList) {
        if ([object conformsToProtocol:protocol]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark  private


- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    SEL selector = [anInvocation selector];
    
    
    BOOL someoneResponded = NO;
    for (id object in self.moduleList) {
        if (
            [object conformsToProtocol:self.protocol]&&
            [object respondsToSelector:selector]) {
            
            someoneResponded = YES;
            // When called every time, send a message to target
            [anInvocation invokeWithTarget:object
             ];
        }
    }

    
    // If a mandatory method has not been implemented by any attached object, this would provoke a crash
    if (!someoneResponded) {
        [super forwardInvocation:anInvocation];
    }
}




- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature * theMethodSignature;
    
    struct objc_method_description methodDescription = protocol_getMethodDescription(self.protocol, selector, YES, YES);
;
    
    if (methodDescription.name == NULL) {
        return nil;
    }
    
    theMethodSignature = [NSMethodSignature signatureWithObjCTypes:methodDescription.types];
    
    return theMethodSignature;
}

- (BOOL)_checkIfAttachedObjectsRespondToSelector:(SEL)selector formDispatcher:(NSArray *)moduleList 
{
    
    for (id object in moduleList) {
        if ([object respondsToSelector:selector]) {
            return YES;
        }
    }
    
    return NO;
}

@end
