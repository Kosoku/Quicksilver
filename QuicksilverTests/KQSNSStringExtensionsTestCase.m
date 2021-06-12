//
//  KQSNSStringExtensionsTestCase.m
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

#import <XCTest/XCTest.h>

#import <Quicksilver/NSString+KQSExtensions.h>

@interface KQSNSStringExtensionsTestCase : XCTestCase

@end

@implementation KQSNSStringExtensionsTestCase

- (void)testTake {
    NSString *start = @"abc";
    NSString *end = @"ab";
    
    XCTAssertEqualObjects([start KQS_take:2], end);
    XCTAssertEqualObjects([start KQS_take:3], start);
}
- (void)testDrop {
    NSString *start = @"abc";
    NSString *end = @"c";
    
    XCTAssertEqualObjects([start KQS_drop:2], end);
    XCTAssertEqualObjects([start KQS_drop:3], start);
}

@end
