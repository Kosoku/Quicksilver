//
//  NSDictionary+KSOBlockExtensions.m
//  Quicksilver
//
//  Created by William Towe on 3/8/17.
//  Copyright © 2017 Kosoku Interactive, LLC. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//  1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
//
//  2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "NSDictionary+KQSExtensions.h"
#import "NSArray+KQSExtensions.h"

@implementation NSDictionary (KQSExtensions)

- (void)KQS_each:(void(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        block(key,obj);
    }];
}
- (NSDictionary *)KQS_filter:(BOOL(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    NSMutableDictionary *retval = [[NSMutableDictionary alloc] init];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(key,obj)) {
            [retval setObject:obj forKey:key];
        }
    }];
    
    return [retval copy];
}
- (NSDictionary *)KQS_reject:(BOOL(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    NSMutableDictionary *retval = [[NSMutableDictionary alloc] init];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (!block(key,obj)) {
            [retval setObject:obj forKey:key];
        }
    }];
    
    return [retval copy];
}
- (nullable id)KQS_find:(BOOL(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    __block id retval = nil;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(key,obj)) {
            retval = obj;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (nullable NSDictionary *)KQS_findWithKey:(BOOL(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    __block NSDictionary *retval = nil;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(key,obj)) {
            retval = @{key: obj};
            *stop = YES;
        }
    }];
    
    return retval;
}
- (NSDictionary *)KQS_map:(id _Nullable(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    NSMutableDictionary *retval = [[NSMutableDictionary alloc] init];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [retval setObject:block(key,obj) ?: [NSNull null] forKey:key];
    }];
    
    return [retval copy];
}
- (nullable id)KQS_reduceWithStart:(nullable id)start block:(id _Nullable(^)(id _Nullable sum, id key, id value))block; {
    NSParameterAssert(block);
    
    __block id retval = start;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        retval = block(retval,key,obj);
    }];
    
    return retval;
}
- (CGFloat)KQS_reduceFloatWithStart:(CGFloat)start block:(CGFloat(^)(CGFloat sum, id key, id value))block; {
    return [[self KQS_reduceWithStart:@(start) block:^id _Nullable(NSNumber * _Nullable sum, id  _Nonnull key, id  _Nonnull value) {
        return @(block(sum.floatValue,key,value));
    }] floatValue];
}
- (NSInteger)KQS_reduceIntegerWithStart:(NSInteger)start block:(NSInteger(^)(NSInteger sum, id key, id value))block; {
    return [[self KQS_reduceWithStart:@(start) block:^id _Nullable(NSNumber * _Nullable sum, id  _Nonnull key, id  _Nonnull value) {
        return @(block(sum.integerValue,key,value));
    }] integerValue];
}
- (NSDictionary *)KQS_flatten; {
    return [[self KQS_reduceWithStart:[[NSMutableDictionary alloc] init] block:^id _Nullable(NSMutableDictionary * _Nullable sum, id _Nonnull key, NSDictionary * _Nonnull value) {
        [sum addEntriesFromDictionary:value];
        return sum;
    }] copy];
}
- (NSDictionary *)KQS_flattenMap:(id _Nullable(^)(id key, id value))block; {
    return [[self KQS_flatten] KQS_map:block];
}
- (BOOL)KQS_any:(BOOL(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    __block BOOL retval = NO;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(key,obj)) {
            retval = YES;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (BOOL)KQS_all:(BOOL(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    __block BOOL retval = YES;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (!block(key,obj)) {
            retval = NO;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (BOOL)KQS_none:(BOOL(^)(id key, id value))block; {
    NSParameterAssert(block);
    
    __block BOOL retval = YES;
    
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (block(key,obj)) {
            retval = NO;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (id)KQS_sumOfKeys {
    return [self.allKeys KQS_sum];
}
- (id)KQS_sumOfValues; {
    return [self.allValues KQS_sum];
}
- (id)KQS_productOfKeys {
    return [self.allKeys KQS_product];
}
- (id)KQS_productOfValues; {
    return [self.allValues KQS_product];
}
- (id)KQS_maximumKey {
    return [self.allKeys KQS_maximum];
}
- (id)KQS_maximumValue; {
    return [self.allValues KQS_maximum];
}
- (id)KQS_minimumKey {
    return [self.allKeys KQS_minimum];
}
- (id)KQS_minimumValue; {
    return [self.allValues KQS_minimum];
}

@end
