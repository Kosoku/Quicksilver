//
//  NSDictionary+KSOBlockExtensions.h
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

#import <Foundation/Foundation.h>
#import <CoreGraphics/CGBase.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary<__covariant KeyType, __covariant ObjectType> (KQSExtensions)

/**
 Invokes block once for each key/value pair in the receiver.
 
 @param block The block to invoke for each key/value pair
 @exception NSException Thrown if block is nil
 */
- (void)KQS_each:(void(^)(KeyType key, ObjectType value))block;
/**
 Create and return a new dictionary by enumerating the receiver, invoking block for each key/value pair, and including it in the new dictionary if block returns YES.
 
 @param block The block to invoke for each key/value pair
 @return The new dictionary
 @exception NSException Thrown if block is nil
 */
- (NSDictionary<KeyType, ObjectType> *)KQS_filter:(BOOL(^)(KeyType key, ObjectType value))block;
/**
 Create and return a new dictionary by enumerating the receiver, invoking block for each key/value pair, and including it in the new dictionary if block returns NO.
 
 @param block The block to invoke for each key/value pair
 @return The new dictionary
 @exception NSException Thrown if block is nil
 */
- (NSDictionary<KeyType, ObjectType> *)KQS_reject:(BOOL(^)(KeyType key, ObjectType value))block;
/**
 Return the value member of the first key/value pair in the receiver for which block returns YES, or nil if block returns NO for all key/value pairs.
 
 @param block The block to invoke for each key/value pair
 @return The value member of the matching key/value pair
 @exception NSException Thrown if block is nil
 */
- (nullable ObjectType)KQS_find:(BOOL(^)(KeyType key, ObjectType value))block;
/**
 Return a dictionary containing the first key/value pair in the receiver for which block returns YES, or nil if block returns NO for all key/value pairs.
 
 @param block The block to invoke for each key/value pair
 @return The dictionary containing the matching key/value pair, or nil
 @exception NSException Thrown if block is nil
 */
- (nullable NSDictionary<KeyType, ObjectType> *)KQS_findWithKey:(BOOL(^)(KeyType key, ObjectType value))block;
/**
 Create and return a new dictionary containing all keys from the receiver mapped to new values that block returns. If block returns nil for a key/value pair, [NSNull null] is used as the value in the new dictionary.
 
 @param block The block to invoke for each key/value pair
 @return The dictionary containing new key/value pairs
 @exception NSException Thrown if block is nil
 */
- (NSDictionary *)KQS_map:(id _Nullable(^)(KeyType key, ObjectType value))block;
/**
 Return a new object that is the result of invoking block for each key/value pair in the receiver, passing the current sum, the key, and value. The return value of one invocation is passed as the sum argument to the next invocation.
 
 @param start The starting value for the reduction
 @param block The block to invoke for each key/value pair
 @return The result of the reduction
 @exception NSException Thrown if block is nil
 */
- (nullable id)KQS_reduceWithStart:(nullable id)start block:(id _Nullable(^)(id _Nullable sum, KeyType key, ObjectType value))block;
/**
 Calls `[self KQS_reduceWithStart:block:]`, passing @(start) and a modified block respectively.
 
 @param start The starting float value for the reduction
 @param block The float specific block to invoke for each key/value pair
 @return The final float value
 @exception NSException Thrown if block is nil
 */
- (CGFloat)KQS_reduceFloatWithStart:(CGFloat)start block:(CGFloat(^)(CGFloat sum, KeyType key, ObjectType value))block;
/**
 Calls `[self KQS_reduceWithStart:block:]`, passing @(start) and a modified block respectively.
 
 @param start The starting integer value for the reduction
 @param block The integer specific block to invoke for each key/value pair
 @return The final integer value
 @exception NSException Thrown if block is nil
 */
- (NSInteger)KQS_reduceIntegerWithStart:(NSInteger)start block:(NSInteger(^)(NSInteger sum, KeyType key, ObjectType value))block;
/**
 Return a new dictionary which is the result of flattening all the values of the receiver, which should be dictionaries, into a single dictionary.
 
 @return The flattened dictionary
 @exception NSException Thrown if the receiver contains any non-dictionary objects
 */
- (NSDictionary *)KQS_flatten;
/**
 Returns the result of calling `[[self KQS_flatten] KQS_map:block]`.
 
 @param block The block to map over the flattened dictionary returned by KQS_flatten
 @return The flattened mapped dictionary
 @exception NSException Thrown if block is nil
 */
- (NSDictionary *)KQS_flattenMap:(id _Nullable(^)(KeyType key, ObjectType value))block;
/**
 Returns YES if block returns YES for any key/value pair in the receiver, otherwise NO.
 
 @param block The block to invoke for every key/value pair
 @return YES if block returns YES once, otherwise NO
 @exception NSException Thrown if block is nil
 */
- (BOOL)KQS_any:(BOOL(^)(KeyType key, ObjectType value))block;
/**
 Returns YES if block returns YES for all key/value pairs in the receiver, otherwise NO.
 
 @param block The block to invoke for every key/value pair
 @return YES if block returns YES for all key/value pairs, otherwise NO
 @exception NSException Thrown if block is nil
 */
- (BOOL)KQS_all:(BOOL(^)(KeyType key, ObjectType value))block;
/**
 Returns YES if block returns NO for all key/value pairs in the receiver, otherwise NO.
 
 @param block The block to invoke for every key/value pair
 @return YES if block returns NO for all key/value pairs, otherwise NO
 @exception NSException Thrown if block is nil
 */
- (BOOL)KQS_none:(BOOL(^)(KeyType key, ObjectType value))block;
/**
 Returns the result of `[self.allKeys KQS_sum]`.
 
 @return The sum of all keys in the receiver
 */
- (__kindof NSNumber *)KQS_sumOfKeys;
/**
 Returns the result of `[self.allValues KQS_sum]`.
 
 @return The sum of all values in the receiver
 */
- (__kindof NSNumber *)KQS_sumOfValues;
/**
 Returns the result of `[self.allKeys KQS_product]`.
 
 @return The product of all keys in the receiver
 */
- (__kindof NSNumber *)KQS_productOfKeys;
/**
 Returns the result of `[self.allValues KQS_product]`.
 
 @return The product of all values in the receiver
 */
- (__kindof NSNumber *)KQS_productOfValues;
/**
 Returns the result of `[self.allKeys KQS_maximum]`.
 
 @return The maximum of all keys in the receiver
 */
- (KeyType)KQS_maximumKey;
/**
 Returns the result of `[self.allValues KQS_maximum]`.
 
 @return The maximum of all values in the receiver
 */
- (ObjectType)KQS_maximumValue;
/**
 Returns the result of `[self.allKeys KQS_minimum]`.
 
 @return The minimum of all keys in the receiver
 */
- (KeyType)KQS_minimumKey;
/**
 Returns the result of `[self.allValues KQS_minimum]`.
 
 @return The minimum of all values in the receiver
 */
- (ObjectType)KQS_minimumValue;

@end

NS_ASSUME_NONNULL_END
