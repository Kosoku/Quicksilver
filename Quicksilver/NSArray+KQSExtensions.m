//
//  NSArray+KQSExtensions.m
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

#import "NSArray+KQSExtensions.h"

@implementation NSArray (KQSExtensions)

- (void)KQS_each:(void(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj,idx);
    }];
}
- (NSArray *)KQS_filter:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj,idx)) {
            [retval addObject:obj];
        }
    }];
    
    return [retval copy];
}
- (NSArray *)KQS_reject:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!block(obj,idx)) {
            [retval addObject:obj];
        }
    }];
    
    return [retval copy];
}
- (id)KQS_find:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    __block id retval = nil;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj,idx)) {
            retval = obj;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (NSArray *)KQS_findWithIndex:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    __block id retval = nil;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj,idx)) {
            retval = @[obj,@(idx)];
            *stop = YES;
        }
    }];
    
    return retval;
}
- (NSArray *)KQS_map:(id _Nullable(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [retval addObject:block(obj,idx) ?: [NSNull null]];
    }];
    
    return [retval copy];
}
- (id)KQS_reduceWithStart:(id)start block:(id(^)(id sum, id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    __block id retval = start;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        retval = block(retval,obj,idx);
    }];
    
    return retval;
}
- (CGFloat)KQS_reduceFloatWithStart:(CGFloat)start block:(CGFloat(^)(CGFloat sum, id _Nonnull object, NSInteger index))block; {
    return [[self KQS_reduceWithStart:@(start) block:^id _Nonnull(NSNumber * _Nullable sum, id  _Nonnull object, NSInteger index) {
        return @(block(sum.floatValue,object,index));
    }] floatValue];
}
- (NSInteger)KQS_reduceIntegerWithStart:(NSInteger)start block:(NSInteger(^)(NSInteger sum, id _Nonnull object, NSInteger index))block; {
    return [[self KQS_reduceWithStart:@(start) block:^id _Nonnull(NSNumber * _Nullable sum, id  _Nonnull object, NSInteger index) {
        return @(block(sum.integerValue,object,index));
    }] integerValue];
}
- (NSArray *)KQS_flatten; {
    return [[self KQS_reduceWithStart:[[NSMutableArray alloc] init] block:^id _Nonnull(NSMutableArray * _Nullable sum, id _Nonnull object, NSInteger index) {
        if ([object isKindOfClass:NSArray.class]) {
            [sum addObjectsFromArray:[object KQS_flatten]];
        }
        else {
            [sum addObject:object];
        }
        return sum;
    }] copy];
}
- (NSString *)KQS_flattenStrings:(NSString *)joinString {
    return [[self KQS_flatten] componentsJoinedByString:joinString];
}
- (NSArray *)KQS_flattenMap:(id _Nullable(^)(id object, NSInteger index))block; {
    return [[self KQS_flatten] KQS_map:block];
}
- (BOOL)KQS_any:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    __block BOOL retval = NO;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj,idx)) {
            retval = YES;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (BOOL)KQS_all:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    __block BOOL retval = YES;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (!block(obj,idx)) {
            retval = NO;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (BOOL)KQS_none:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    __block BOOL retval = YES;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj,idx)) {
            retval = NO;
            *stop = YES;
        }
    }];
    
    return retval;
}
- (NSArray *)KQS_take:(NSInteger)count; {
    if (count > self.count) {
        return self;
    }
    else {
        return [self subarrayWithRange:NSMakeRange(0, count)];
    }
}
- (NSArray *)KQS_takeWhile:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (!block(obj,idx)) {
            *stop = YES;
            return;
        }
        
        [retval addObject:obj];
    }];
    
    return [retval copy];
}
- (NSArray *)KQS_drop:(NSInteger)count; {
    if (count > self.count) {
        return @[];
    }
    else {
        return [self subarrayWithRange:NSMakeRange(count, self.count - count)];
    }
}
- (NSArray *)KQS_dropWhile:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    __block NSInteger drop = self.count;
    
    [self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!block(obj,idx)) {
            drop = idx;
            *stop = YES;
        }
    }];
    
    return [self KQS_drop:drop];
}
- (NSArray *)KQS_zip:(NSArray *)array; {
    NSParameterAssert(array);
    
    NSMutableArray *retval = [[NSMutableArray alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx < array.count) {
            [retval addObject:@[obj,array[idx]]];
        }
    }];
    
    return [retval copy];
}
- (id)KQS_sum; {
    if (self.count > 0) {
        NSNumber *first = self.firstObject;
        
        if ([first isKindOfClass:[NSDecimalNumber class]]) {
            return [self KQS_reduceWithStart:[NSDecimalNumber zero] block:^id(NSDecimalNumber *sum, NSDecimalNumber *object, NSInteger index) {
                return [sum decimalNumberByAdding:object];
            }];
        }
        else {
            NSString *type = [NSString stringWithUTF8String:first.objCType];
            
            if ([type isEqualToString:@"d"] ||
                [type isEqualToString:@"f"]) {
                
                return [self KQS_reduceWithStart:@0.0 block:^id(NSNumber *sum, NSNumber *object, NSInteger index) {
                    return @(sum.doubleValue + object.doubleValue);
                }];
            }
            else {
                return [self KQS_reduceWithStart:@0 block:^id(NSNumber *sum, NSNumber *object, NSInteger index) {
                    return @(sum.integerValue + object.integerValue);
                }];
            }
        }
    }
    return @0;
}
- (id)KQS_product; {
    if (self.count > 0) {
        NSNumber *first = self.firstObject;
        
        if ([first isKindOfClass:[NSDecimalNumber class]]) {
            return [self KQS_reduceWithStart:[NSDecimalNumber one] block:^id(NSDecimalNumber *sum, NSDecimalNumber *object, NSInteger index) {
                return [sum decimalNumberByMultiplyingBy:object];
            }];
        }
        else {
            NSString *type = [NSString stringWithUTF8String:first.objCType];
            
            if ([type isEqualToString:@"d"] ||
                [type isEqualToString:@"f"]) {
                
                return [self KQS_reduceWithStart:@1.0 block:^id(NSNumber *sum, NSNumber *object, NSInteger index) {
                    return @(sum.doubleValue * object.doubleValue);
                }];
            }
            else {
                return [self KQS_reduceWithStart:@1 block:^id(NSNumber *sum, NSNumber *object, NSInteger index) {
                    return @(sum.integerValue * object.integerValue);
                }];
            }
        }
    }
    return @0;
}
- (id)KQS_maximum; {
    return [self KQS_reduceWithStart:self.firstObject block:^id(id sum, id object, NSInteger index) {
        return [object compare:sum] == NSOrderedDescending ? object : sum;
    }];
}
- (id)KQS_minimum; {
    return [self KQS_reduceWithStart:self.firstObject block:^id(id sum, id object, NSInteger index) {
        return [object compare:sum] == NSOrderedAscending ? object : sum;
    }];
}

@end
