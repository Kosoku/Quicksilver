//
//  NSOrderedSet+KQSExtensions.h
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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSOrderedSet<__covariant ObjectType> (KQSExtensions)

/**
 Invokes block once for each object in the receiver.
 
 @param block The block to invoke
 @exception NSException Thrown if block is nil
 */
- (void)KQS_each:(void(^)(ObjectType object, NSInteger idx))block;
/**
 Create and return a new ordered set by enumerating the receiver, invoking block for each object, and including it in the new ordered set if block returns YES.
 
 @param block The block to invoke for each object in the receiver
 @return The new array
 @exception NSException Thrown if block is nil
 */
- (NSOrderedSet<ObjectType> *)KQS_filter:(BOOL(^)(ObjectType object, NSInteger index))block;
/**
 Create and return a new ordered set by enumerating the receiver, invoking block for each object, and including it in the new ordered set if block returns NO.
 
 @param block The block to invoke for each object in the receiver
 @return The new array
 @exception NSException Thrown if block is nil
 */
- (NSOrderedSet<ObjectType> *)KQS_reject:(BOOL(^)(ObjectType object, NSInteger index))block;
/**
 Return the first object in the receiver for which block returns YES, or nil if block returns NO for all objects in the receiver.
 
 @param block The block to invoke for each object in the receiver
 @return The matching object or nil
 @exception NSException Thrown if block is nil
 */
- (nullable ObjectType)KQS_find:(BOOL(^)(ObjectType object, NSInteger index))block;
/**
 Return an array of the first object in the receiver along with its index for which block returns YES, or nil if block returns NO for all objects in the receiver.
 
 @param block The block to invoke for each object in the receiver
 @return An array where the first object is an object in the receiver and second object is the index of the object in the receiver, or nil
 @exception NSException Thrown if block is nil
 */
- (nullable NSArray *)KQS_findWithIndex:(BOOL(^)(ObjectType object, NSInteger index))block;
/**
 Create and return a new ordered set by enumerating the receiver, invoking block for each object, and including the return value of block in the new ordered set.
 
 @param block The block to invoke for each object in the receiver
 @return The new array
 */
- (NSOrderedSet *)KQS_map:(id _Nullable(^)(ObjectType object, NSInteger index))block;
/**
 Return a new object that is the result of enumerating the receiver and invoking block, passing the current sum, the object, and the index of object in the receiver. The return value of block is passed in as sum to the next invocation of block.
 
 @param start The starting value for the reduction
 @param block The block to invoke for each object in the receiver
 @return The result of the reduction
 @exception NSException Thrown if block is nil
 */
- (nullable id)KQS_reduceWithStart:(nullable id)start block:(id(^)(id _Nullable sum, ObjectType object, NSInteger index))block;
/**
 Calls `[self KQS_reduceWithStart:block:]`, passing @(start) and a modified block argument respectively.
 
 @param start The starting float value for the reduction
 @block The float specific block to use during the reduction
 @return The final float value
 @exception NSException Thrown if block is nil
 */
- (CGFloat)KQS_reduceFloatWithStart:(CGFloat)start block:(CGFloat(^)(CGFloat sum, ObjectType object, NSInteger index))block;
/**
 Calls `[self KQS_reduceWithStart:block:]`, passing @(start) and a modified block argument respectively.
 
 @param start The starting integer value for the reduction
 @block The integer specific block to use during the reduction
 @return The final integer value
 @exception NSException Thrown if block is nil
 */
- (NSInteger)KQS_reduceIntegerWithStart:(NSInteger)start block:(NSInteger(^)(NSInteger sum, ObjectType object, NSInteger index))block;
/**
 Return a new ordered set that is a result of recursively flattening the objects in the receiver, which can be ordered sets or other objects.
 
 @return The flattened ordered set
 */
- (NSOrderedSet *)KQS_flatten;
/**
 Returns the result of calling `[[self KQS_flatten] KQS_map:block]`.
 
 @param block The block to map over the flattened ordered set returned by KQS_flatten
 @return The flattened mapped ordered set
 @exception NSException Thrown if block is nil
 */
- (NSOrderedSet *)KQS_flattenMap:(id _Nullable(^)(ObjectType object, NSInteger index))block;
/**
 Return YES if block returns YES for any object in the receiver, otherwise NO.
 
 @param block The block to invoke for each object in the receiver
 @return YES if block returns YES for any object, otherwise NO
 @exception NSException Thrown if block is nil
 */
- (BOOL)KQS_any:(BOOL(^)(ObjectType object, NSInteger index))block;
/**
 Return YES if block returns YES for all objects in the receiver, otherwise NO.
 
 @param block The block to invoke for each object in the receiver
 @return YES if block returns YES for all objects, otherwise NO
 @exception NSException Throw if block is nil
 */
- (BOOL)KQS_all:(BOOL(^)(ObjectType object, NSInteger index))block;
/**
 Return YES if block returns NO for all objects in the receiver, otherwise NO.
 
 @param block The block to invoke for each object in the receiver
 @return YES if block returns NO for all objects, otherwise NO
 @exception NSException Throw if block is nil
 */
- (BOOL)KQS_none:(BOOL(^)(ObjectType object, NSInteger index))block;
/**
 Returns a new ordered set created by taking the first count objects in the receiver. If count > self.count, returns self.
 
 @param count The number of elements to take from the beginning of the receiver
 @return The new ordered set
 */
- (NSOrderedSet<ObjectType> *)KQS_take:(NSInteger)count;
/**
 Returns a new ordered set created by taking the remaining objects after dropping count objects from the receiver. If count > self.count, returns an empty ordered set.
 
 @param count The number of objects to drop from the end of the receiver
 @return The new ordered set
 */
- (NSOrderedSet<ObjectType> *)KQS_drop:(NSInteger)count;
/**
 Returns a new ordered set created by taking pairs of objects from the receiver and array. The behavior is identical to [NSArray KQS_zip:].
 
 @param orderedSet The ordered set to zip with
 @return The new ordered set
 @exception NSException Thrown if orderedSet is nil
 */
- (NSOrderedSet<NSOrderedSet *> *)KQS_zip:(NSOrderedSet *)orderedSet;
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
