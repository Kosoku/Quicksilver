//
//  NSString+KQSExtensions.h
//  Quicksilver
//
//  Created by William Towe on 3/8/18.
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

NS_ASSUME_NONNULL_BEGIN

@interface NSString (KQSExtensions)

/**
 If `length` < `self.length`, then returns `[self substringToIndex:length]`, otherwise returns self.
 
 @param length The length to which to create a substring
 @return The substring to length or self
 */
- (NSString *)KQS_take:(NSInteger)length;
/**
 If `length` < `self.length`, then returns `[self substringWithRange:NSMakeRange(length, self.length - length)]`, otherwise returns self.
 
 @param length The length from which to return a substring
 @return The substring from length or self
 */
- (NSString *)KQS_drop:(NSInteger)length;

@end

NS_ASSUME_NONNULL_END
