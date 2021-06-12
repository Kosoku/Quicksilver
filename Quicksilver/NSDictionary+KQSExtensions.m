//
//  NSDictionary+KSOBlockExtensions.m
//  Quicksilver
//
//  Created by William Towe on 3/8/17.
//  Copyright © 2021 Kosoku Interactive, LLC. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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
