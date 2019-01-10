//
//  NSSet+KQSExtensions.m
//  Quicksilver
//
//  Created by William Towe on 3/8/17.
//  Copyright © 2019 Kosoku Interactive, LLC. All rights reserved.
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

#import "NSSet+KQSExtensions.h"

@implementation NSSet (KQSExtensions)

- (void)KQS_each:(void(^)(id object))block; {
    NSParameterAssert(block);
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        block(obj);
    }];
}
- (NSSet *)KQS_filter:(BOOL(^)(id object))block; {
    NSParameterAssert(block);
    
    NSMutableSet *retval = [[NSMutableSet alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (block(obj)) {
            [retval addObject:obj];
        }
    }];
    
    return [retval copy];
}
- (NSSet *)KQS_reject:(BOOL(^)(id object))block; {
    NSParameterAssert(block);
    
    NSMutableSet *retval = [[NSMutableSet alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        if (!block(obj)) {
            [retval addObject:obj];
        }
    }];
    
    return [retval copy];
}
- (id)KQS_find:(BOOL(^)(id object))block; {
    NSParameterAssert(block);
    
    __block id retval = nil;
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (block(obj)) {
            retval = obj;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (NSSet *)KQS_map:(id _Nullable(^)(id object))block; {
    NSParameterAssert(block);
    
    NSMutableSet *retval = [[NSMutableSet alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [retval addObject:block(obj) ?: [NSNull null]];
    }];
    
    return [retval copy];
}
- (id)KQS_reduceWithStart:(id)start block:(id(^)(id sum, id object))block; {
    NSParameterAssert(block);
    
    __block id retval = start;
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        retval = block(retval,obj);
    }];
    
    return retval;
}
- (CGFloat)KQS_reduceFloatWithStart:(CGFloat)start block:(CGFloat(^)(CGFloat sum, id _Nonnull object))block; {
    return [[self KQS_reduceWithStart:@(start) block:^id _Nonnull(NSNumber * _Nullable sum, id  _Nonnull object) {
        return @(block(sum.floatValue,object));
    }] floatValue];
}
- (NSInteger)KQS_reduceIntegerWithStart:(NSInteger)start block:(NSInteger(^)(NSInteger sum, id _Nonnull object))block; {
    return [[self KQS_reduceWithStart:@(start) block:^id _Nonnull(NSNumber * _Nullable sum, id  _Nonnull object) {
        return @(block(sum.integerValue,object));
    }] integerValue];
}
- (NSSet *)KQS_flatten; {
    return [[self KQS_reduceWithStart:[[NSMutableSet alloc] init] block:^id _Nonnull(NSMutableSet * _Nullable sum, id _Nonnull object) {
        if ([object isKindOfClass:NSSet.class]) {
            [sum unionSet:[object KQS_flatten]];
        }
        else {
            [sum addObject:object];
        }
        return sum;
    }] copy];
}
- (NSSet *)KQS_flattenMap:(id _Nullable(^)(id object))block; {
    return [[self KQS_flatten] KQS_map:block];
}
- (BOOL)KQS_any:(BOOL(^)(id object))block; {
    NSParameterAssert(block);
    
    __block BOOL retval = NO;
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (block(obj)) {
            retval = YES;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (BOOL)KQS_all:(BOOL(^)(id object))block; {
    NSParameterAssert(block);
    
    __block BOOL retval = YES;
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (!block(obj)) {
            retval = NO;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (BOOL)KQS_none:(BOOL(^)(id object))block; {
    NSParameterAssert(block);
    
    __block BOOL retval = YES;
    
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (block(obj)) {
            retval = NO;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (id)KQS_sum; {
    if (self.count > 0) {
        NSNumber *first = self.anyObject;
        
        if ([first isKindOfClass:[NSDecimalNumber class]]) {
            return [self KQS_reduceWithStart:[NSDecimalNumber zero] block:^id(NSDecimalNumber *sum, NSDecimalNumber *object) {
                return [sum decimalNumberByAdding:object];
            }];
        }
        else {
            NSString *type = [NSString stringWithUTF8String:first.objCType];
            
            if ([type isEqualToString:@"d"] ||
                [type isEqualToString:@"f"]) {
                
                return [self KQS_reduceWithStart:@0.0 block:^id(NSNumber *sum, NSNumber *object) {
                    return @(sum.doubleValue + object.doubleValue);
                }];
            }
            else {
                return [self KQS_reduceWithStart:@0 block:^id(NSNumber *sum, NSNumber *object) {
                    return @(sum.integerValue + object.integerValue);
                }];
            }
        }
    }
    return @0;
}
- (id)KQS_product; {
    if (self.count > 0) {
        NSNumber *first = self.anyObject;
        
        if ([first isKindOfClass:[NSDecimalNumber class]]) {
            return [self KQS_reduceWithStart:[NSDecimalNumber one] block:^id(NSDecimalNumber *sum, NSDecimalNumber *object) {
                return [sum decimalNumberByMultiplyingBy:object];
            }];
        }
        else {
            NSString *type = [NSString stringWithUTF8String:first.objCType];
            
            if ([type isEqualToString:@"d"] ||
                [type isEqualToString:@"f"]) {
                
                return [self KQS_reduceWithStart:@1.0 block:^id(NSNumber *sum, NSNumber *object) {
                    return @(sum.doubleValue * object.doubleValue);
                }];
            }
            else {
                return [self KQS_reduceWithStart:@1 block:^id(NSNumber *sum, NSNumber *object) {
                    return @(sum.integerValue * object.integerValue);
                }];
            }
        }
    }
    return @0;
}
- (id)KQS_maximum; {
    return [self KQS_reduceWithStart:self.anyObject block:^id(id sum, id object) {
        return [object compare:sum] == NSOrderedDescending ? object : sum;
    }];
}
- (id)KQS_minimum; {
    return [self KQS_reduceWithStart:self.anyObject block:^id(id sum, id object) {
        return [object compare:sum] == NSOrderedAscending ? object : sum;
    }];
}

@end
