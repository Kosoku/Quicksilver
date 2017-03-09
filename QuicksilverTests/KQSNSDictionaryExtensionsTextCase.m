//
//  KQSNSDictionaryExtensionsTextCase.m
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

#import <XCTest/XCTest.h>

#import <Quicksilver/NSDictionary+KQSExtensions.h>

@interface KQSNSDictionaryExtensionsTextCase : XCTestCase

@end

@implementation KQSNSDictionaryExtensionsTextCase

- (void)testEach {
    NSDictionary *begin = @{@1: @"one", @2: @"two", @3: @"three"};
    NSDictionary *end = @{@1: @"ONE", @2: @"TWO", @3: @"THREE"};
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    
    [begin KQS_each:^(NSNumber * _Nonnull key, NSString * _Nonnull value) {
        [temp setObject:value.uppercaseString forKey:key];
    }];
    
    XCTAssertEqualObjects(temp, end);
}
- (void)testFilter {
    NSDictionary *begin = @{@1: @"one", @2: @"two", @3: @"three", @4: @"four"};
    NSDictionary *end = @{@2: @"two", @4: @"four"};
    
    XCTAssertEqualObjects([begin KQS_filter:^BOOL(NSNumber * _Nonnull key, NSString * _Nonnull value) {
        return key.integerValue % 2 == 0;
    }], end);
}
- (void)testReject {
    NSDictionary *begin = @{@1: @"one", @2: @"two", @3: @"three", @4: @"four"};
    NSDictionary *end = @{@1: @"one", @3: @"three"};
    
    XCTAssertEqualObjects([begin KQS_reject:^BOOL(NSNumber * _Nonnull key, NSString * _Nonnull value) {
        return key.integerValue % 2 == 0;
    }], end);
}
- (void)testFind {
    NSDictionary *begin = @{@1: @"one", @2: @"two", @3: @"three"};
    NSString *end = @"two";
    
    XCTAssertEqualObjects([begin KQS_find:^BOOL(NSNumber * _Nonnull key, id  _Nonnull value) {
        return key.integerValue % 2 == 0;
    }], end);
}
- (void)testFindWithKey {
    NSDictionary *begin = @{@1: @"one", @2: @"two", @3: @"three"};
    NSDictionary *end = @{@2: @"two"};
    
    XCTAssertEqualObjects([begin KQS_findWithKey:^BOOL(NSNumber * _Nonnull key, id  _Nonnull value) {
        return key.integerValue % 2 == 0;
    }], end);
}
- (void)testMap {
    NSDictionary *begin = @{@1: @"one", @2: @"two", @3: @"three"};
    NSDictionary *end = @{@1: @"ONE", @2: @"TWO", @3: @"THREE"};
    
    XCTAssertEqualObjects([begin KQS_map:^id _Nullable(NSNumber * _Nonnull key, NSString * _Nonnull value) {
        return value.uppercaseString;
    }], end);
}
- (void)testReduce {
    NSDictionary *begin = @{@1: @"one", @2: @"two", @3: @"three"};
    NSNumber *end = @6;
    
    XCTAssertEqualObjects([begin KQS_reduceWithStart:@0 block:^id _Nullable(NSNumber *_Nullable sum, NSNumber * _Nonnull key, NSString * _Nonnull value) {
        return @(sum.integerValue + key.integerValue);
    }], end);
}
- (void)testFlatten {
    NSDictionary *begin = @{@1: @{@1: @"one"}, @2: @{@2: @"two"}, @3: @{@3: @"three"}};
    NSDictionary *end = @{@1: @"one", @2: @"two", @3: @"three"};
    
    XCTAssertEqualObjects([begin KQS_flatten], end);
}
- (void)testFlattenMap {
    NSDictionary *begin = @{@1: @{@1: @"one"}, @2: @{@2: @"two"}, @3: @{@3: @"three"}};
    NSDictionary *end = @{@1: @"ONE", @2: @"TWO", @3: @"THREE"};
    
    XCTAssertEqualObjects([begin KQS_flattenMap:^id _Nullable(id  _Nonnull key, NSString * _Nonnull value) {
        return value.uppercaseString;
    }], end);
}
- (void)testAny {
    NSDictionary *begin = @{@1: @"one", @2: @"two", @3: @"three"};
    
    XCTAssertTrue([begin KQS_any:^BOOL(NSNumber *_Nonnull key, id  _Nonnull value) {
        return key.integerValue % 2 == 0;
    }]);
    
    begin = @{@1: @"one", @3: @"three", @5: @"five"};
    
    XCTAssertFalse([begin KQS_any:^BOOL(NSNumber *_Nonnull key, id  _Nonnull value) {
        return key.integerValue % 2 == 0;
    }]);
}
- (void)testAll {
    NSDictionary *begin = @{@2: @"two", @4: @"four", @6: @"six"};
    
    XCTAssertTrue([begin KQS_all:^BOOL(NSNumber *_Nonnull key, id  _Nonnull value) {
        return key.integerValue % 2 == 0;
    }]);
    
    begin = @{@2: @"two", @4: @"four", @5: @"five"};
    
    XCTAssertFalse([begin KQS_all:^BOOL(NSNumber *_Nonnull key, id  _Nonnull value) {
        return key.integerValue % 2 == 0;
    }]);
}
- (void)testNone {
    NSDictionary *begin = @{@3: @"two", @5: @"four", @7: @"six"};
    
    XCTAssertTrue([begin KQS_none:^BOOL(NSNumber *_Nonnull key, id  _Nonnull value) {
        return key.integerValue % 2 == 0;
    }]);
    
    begin = @{@3: @"two", @5: @"four", @6: @"five"};
    
    XCTAssertFalse([begin KQS_none:^BOOL(NSNumber *_Nonnull key, id  _Nonnull value) {
        return key.integerValue % 2 == 0;
    }]);
}
- (void)testSumOfKeys {
    NSDictionary *begin = @{@1: @"one", @2: @"two", @3: @"three"};
    NSNumber *end = @6;
    
    XCTAssertEqualObjects([begin KQS_sumOfKeys], end);
    
    begin = @{@1.0: @"one", @2.0: @"two", @3.0: @"three"};
    end = @6.0;
    
    XCTAssertEqualObjects([begin KQS_sumOfKeys], end);
    
    begin = @{[NSDecimalNumber decimalNumberWithString:@"1"]: @"one", [NSDecimalNumber decimalNumberWithString:@"2"]: @"two", [NSDecimalNumber decimalNumberWithString:@"3"]: @"three"};
    end = [NSDecimalNumber decimalNumberWithString:@"6"];
    
    XCTAssertEqualObjects([begin KQS_sumOfKeys], end);
}
- (void)testSumOfValues {
    NSDictionary *begin = @{@"one": @1, @"two": @2, @"three": @3};
    NSNumber *end = @6;
    
    XCTAssertEqualObjects([begin KQS_sumOfValues], end);
    
    begin = @{@"one": @1.0, @"two": @2.0, @"three": @3.0};
    end = @6.0;
    
    XCTAssertEqualObjects([begin KQS_sumOfValues], end);
    
    begin = @{@"one": [NSDecimalNumber decimalNumberWithString:@"1"], @"two": [NSDecimalNumber decimalNumberWithString:@"2"], @"three": [NSDecimalNumber decimalNumberWithString:@"3"]};
    end = [NSDecimalNumber decimalNumberWithString:@"6"];
    
    XCTAssertEqualObjects([begin KQS_sumOfValues], end);
}
- (void)testProductOfKeys {
    NSDictionary *begin = @{@2: @"one", @3: @"two", @4: @"three"};
    NSNumber *end = @24;
    
    XCTAssertEqualObjects([begin KQS_productOfKeys], end);
    
    begin = @{@2.0: @"one", @3.0: @"two", @4.0: @"three"};
    end = @24.0;
    
    XCTAssertEqualObjects([begin KQS_productOfKeys], end);
    
    begin = @{[NSDecimalNumber decimalNumberWithString:@"2"]: @"one", [NSDecimalNumber decimalNumberWithString:@"3"]: @"two", [NSDecimalNumber decimalNumberWithString:@"4"]: @"three"};
    end = [NSDecimalNumber decimalNumberWithString:@"24"];
    
    XCTAssertEqualObjects([begin KQS_productOfKeys], end);
}
- (void)testProductOfValues {
    NSDictionary *begin = @{@"one": @2, @"two": @3, @"three": @4};
    NSNumber *end = @24;
    
    XCTAssertEqualObjects([begin KQS_productOfValues], end);
    
    begin = @{@"one": @2.0, @"two": @3.0, @"three": @4.0};
    end = @24.0;
    
    XCTAssertEqualObjects([begin KQS_productOfValues], end);
    
    begin = @{@"one": [NSDecimalNumber decimalNumberWithString:@"2"], @"two": [NSDecimalNumber decimalNumberWithString:@"3"], @"three": [NSDecimalNumber decimalNumberWithString:@"4"]};
    end = [NSDecimalNumber decimalNumberWithString:@"24"];
    
    XCTAssertEqualObjects([begin KQS_productOfValues], end);
}
- (void)testMaximumKey {
    NSDictionary *begin = @{@1: @"one", @3: @"two", @2: @"three"};
    NSNumber *end = @3;
    
    XCTAssertEqualObjects([begin KQS_maximumKey], end);
}
- (void)testMaximumValue {
    NSDictionary *begin = @{@"one": @1, @"two": @3, @"three": @2};
    NSNumber *end = @3;
    
    XCTAssertEqualObjects([begin KQS_maximumValue], end);
}
- (void)testMinimumKey {
    NSDictionary *begin = @{@1: @"one", @-1: @"two", @2: @"three"};
    NSNumber *end = @-1;
    
    XCTAssertEqualObjects([begin KQS_minimumKey], end);
}
- (void)testMinimumValue {
    NSDictionary *begin = @{@"one": @1, @"two": @-1, @"three": @2};
    NSNumber *end = @-1;
    
    XCTAssertEqualObjects([begin KQS_minimumValue], end);
}

@end
