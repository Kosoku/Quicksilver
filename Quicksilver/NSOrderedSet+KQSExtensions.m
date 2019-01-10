//
//  NSOrderedSet+KQSExtensions.m
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

#import "NSOrderedSet+KQSExtensions.h"

@implementation NSOrderedSet (KQSExtensions)

- (void)KQS_each:(void(^)(id object, NSInteger idx))block; {
    NSParameterAssert(block);
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        block(obj,idx);
    }];
}
- (NSOrderedSet *)KQS_filter:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    NSMutableOrderedSet *retval = [[NSMutableOrderedSet alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (block(obj,idx)) {
            [retval addObject:obj];
        }
    }];
    
    return [retval copy];
}
- (NSOrderedSet *)KQS_reject:(BOOL(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    NSMutableOrderedSet *retval = [[NSMutableOrderedSet alloc] init];
    
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
- (NSOrderedSet *)KQS_map:(id _Nullable(^)(id object, NSInteger index))block; {
    NSParameterAssert(block);
    
    NSMutableOrderedSet *retval = [[NSMutableOrderedSet alloc] init];
    
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
- (NSOrderedSet *)KQS_flatten; {
    return [[self KQS_reduceWithStart:[[NSMutableOrderedSet alloc] init] block:^id _Nonnull(NSMutableOrderedSet * _Nullable sum, id _Nonnull object, NSInteger index) {
        if ([object isKindOfClass:NSOrderedSet.class]) {
            [sum addObjectsFromArray:[object KQS_flatten].array];
        }
        else {
            [sum addObject:object];
        }
        return sum;
    }] copy];
}
- (NSOrderedSet *)KQS_flattenMap:(id _Nullable(^)(id object, NSInteger index))block; {
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
- (NSOrderedSet *)KQS_take:(NSInteger)count; {
    if (count > self.count) {
        return self;
    }
    else {
        return [NSOrderedSet orderedSetWithArray:[self objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, count)]]];
    }
}
- (NSOrderedSet *)KQS_drop:(NSInteger)count; {
    if (count > self.count) {
        return [NSOrderedSet orderedSet];
    }
    else {
        return [NSOrderedSet orderedSetWithArray:[self objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.count - count)]]];
    }
}
- (NSOrderedSet *)KQS_zip:(NSOrderedSet *)orderedSet; {
    NSParameterAssert(orderedSet);
    
    NSMutableOrderedSet *retval = [[NSMutableOrderedSet alloc] init];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (idx < orderedSet.count) {
            [retval addObject:[NSOrderedSet orderedSetWithArray:@[obj,orderedSet[idx]]]];
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
