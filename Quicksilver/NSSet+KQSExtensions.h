//
//  NSSet+KQSExtensions.h
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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSSet<__covariant ObjectType> (KQSExtensions)

/**
 Invokes block once for each object in the receiver.
 
 @param block The block to invoke
 @exception NSException Thrown if block is nil
 */
- (void)KQS_each:(void(^)(ObjectType object))block;
/**
 Create and return a new set by enumerating the receiver, invoking block for each object, and including it in the new set if block returns YES.
 
 @param block The block to invoke for each object in the receiver
 @return The new set
 @exception NSException Thrown if block is nil
 */
- (NSSet<ObjectType> *)KQS_filter:(BOOL(^)(ObjectType object))block;
/**
 Create and return a new set by enumerating the receiver, invoking block for each object, and including it in the new set if block returns NO.
 
 @param block The block to invoke for each object in the receiver
 @return The new set
 @exception NSException Thrown if block is nil
 */
- (NSSet<ObjectType> *)KQS_reject:(BOOL(^)(ObjectType object))block;
/**
 Return the first object in the receiver for which block returns YES, otherwise return nil.
 
 @param block The block to invoke for each object in the receiver
 @return The matching object or nil
 @exception NSException Thrown if block is nil
 */
- (nullable ObjectType)KQS_find:(BOOL(^)(ObjectType object))block;
/**
 Create and return a new set by enumerating the receiver, invoking block for each object, and including the return value of block in the new set.
 
 @param block The block to invoke for each object in the receiver
 @return The new set
 @exception NSException Thrown if block is nil
 */
- (NSSet *)KQS_map:(id _Nullable(^)(ObjectType object))block;
/**
 Return a new object that is the result of enumerating the receiver and invoking block, passing the current sum and the object. The return value of block is passed in as sum to the next invocation of block.
 
 @param start The starting value for the reduction
 @param block The block to invoke for each object in the receiver
 @return The result of the reduction
 @exception NSException Thrown if block is nil
 */
- (nullable id)KQS_reduceWithStart:(nullable id)start block:(id(^)(id _Nullable sum, ObjectType object))block;
/**
 Calls `[self KQS_reduceWithStart:block:]`, passing @(start) and a modified block respectively.
 
 @param start The starting float value for the reduction
 @block The float specific block to use during the reduction
 @return The final float value
 @exception NSException Thrown if block is nil
 */
- (CGFloat)KQS_reduceFloatWithStart:(CGFloat)start block:(CGFloat(^)(CGFloat sum, ObjectType object))block;
/**
 Calls `[self KQS_reduceWithStart:block:]`, passing @(start) and a modified block respectively.
 
 @param start The starting integer value for the reduction
 @block The integer specific block to use during the reduction
 @return The final integer value
 @exception NSException Thrown if block is nil
 */
- (NSInteger)KQS_reduceIntegerWithStart:(NSInteger)start block:(NSInteger(^)(NSInteger sum, ObjectType object))block;
/**
 Return a new set which is the result of recursively unioning all the objects in the receiver, which can be sets or other objects.
 
 @return The flattened set
 */
- (NSSet *)KQS_flatten;
/**
 Returns the result of calling `[[self KQS_flatten] KQS_map:block]`.
 
 @param block The block to map over the flattened set returned by KQS_flatten
 @return The flattened mapped set
 @exception NSException Thrown if block is nil
 */
- (NSSet *)KQS_flattenMap:(id _Nullable(^)(ObjectType object))block;
/**
 Return YES if block returns YES for any object in the receiver, otherwise NO.
 
 @param block The block to invoke for each object in the receiver
 @return YES if block returns YES for any object, otherwise NO
 @exception NSException Thrown if block is nil
 */
- (BOOL)KQS_any:(BOOL(^)(ObjectType object))block;
/**
 Return YES if block returns YES for all objects in the receiver, otherwise NO.
 
 @param block The block to invoke for each object in the receiver
 @return YES if block returns YES for all objects, otherwise NO
 @exception NSException Throw if block is nil
 */
- (BOOL)KQS_all:(BOOL(^)(ObjectType object))block;
/**
 Return YES if block returns NO for all objects in the receiver, otherwise NO.
 
 @param block The block to invoke for each object in the receiver
 @return YES if block returns NO for all objects, otherwise NO
 @exception NSException Throw if block is nil
 */
- (BOOL)KQS_none:(BOOL(^)(ObjectType object))block;
/**
 Returns the sum of the objects in the receiver, which should be NSNumber instances, as an NSNumber.
 
 @return The sum
 */
- (__kindof NSNumber *)KQS_sum;
/**
 Returns the product of the objects in the receiver, which should be NSNumber instances, as an NSNumber.
 
 @return The product
 */
- (__kindof NSNumber *)KQS_product;
/**
 Returns the maximum value of the objects in the receiver, which should all respond to the `compare:` method.
 
 @return The maximum value
 */
- (ObjectType)KQS_maximum;
/**
 Returns the minimum value of the objects in the receiver, which should all respond to the `compare`: method.
 
 @return The minimum value
 */
- (ObjectType)KQS_minimum;

@end

NS_ASSUME_NONNULL_END
