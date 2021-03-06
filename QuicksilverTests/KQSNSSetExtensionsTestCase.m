//
//  KQSNSSetExtensionsTestCase.m
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

#import <Quicksilver/NSSet+KQSExtensions.h>

@interface KQSNSSetExtensionsTestCase : XCTestCase

@end

@implementation KQSNSSetExtensionsTestCase

- (void)testEach {
    NSSet *begin = [NSSet setWithArray:@[@1,@2,@3]];
    NSSet *end = [NSSet setWithArray:@[@2,@3,@4]];
    NSMutableSet *temp = [[NSMutableSet alloc] init];
    
    [begin KQS_each:^(NSNumber *object) {
        [temp addObject:@(object.integerValue + 1)];
    }];
    
    XCTAssertEqualObjects(temp, end);
}
- (void)testFilter {
    NSSet *begin = [NSSet setWithArray:@[@1,@2,@3,@4]];
    NSSet *end = [NSSet setWithArray:@[@2,@4]];
    
    XCTAssertEqualObjects([begin KQS_filter:^BOOL(NSNumber *object) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testReject {
    NSSet *begin = [NSSet setWithArray:@[@1,@2,@3,@4]];
    NSSet *end = [NSSet setWithArray:@[@1,@3]];
    
    XCTAssertEqualObjects([begin KQS_reject:^BOOL(NSNumber *object) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testFind {
    NSSet *begin = [NSSet setWithArray:@[@1,@2,@3]];
    NSNumber *end = @2;
    
    XCTAssertEqualObjects([begin KQS_find:^BOOL(NSNumber *object) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testMap {
    NSSet *begin = [NSSet setWithArray:@[@1,@2,@3]];
    NSSet *end = [NSSet setWithArray:@[@"1",@"2",@"3"]];
    
    XCTAssertEqualObjects([begin KQS_map:^id(NSNumber *object) {
        return object.stringValue;
    }], end);
}
- (void)testReduce {
    NSSet *begin = [NSSet setWithObjects:[NSSet setWithObject:@1],[NSSet setWithObject:@2],[NSSet setWithObject:@3], nil];
    NSSet *end = [NSSet setWithArray:@[@1,@2,@3]];
    
    XCTAssertEqualObjects([begin KQS_reduceWithStart:[[NSMutableSet alloc] init] block:^id(NSMutableSet *sum, id object) {
        [sum unionSet:object];
        return sum;
    }], end);
}
- (void)testFlatten {
    NSSet *begin = [NSSet setWithObjects:[NSSet setWithObject:@1],[NSSet setWithObject:@2],[NSSet setWithObject:@3],@4, nil];
    NSSet *end = [NSSet setWithArray:@[@1,@2,@3,@4]];
    
    XCTAssertEqualObjects([begin KQS_flatten], end);
}
- (void)testFlattenMap {
    NSSet *begin = [NSSet setWithObjects:[NSSet setWithObject:@1],[NSSet setWithObject:@2],[NSSet setWithObject:@3],@4, nil];
    NSSet *end = [NSSet setWithArray:@[@2,@3,@4,@5]];
    
    XCTAssertEqualObjects([begin KQS_flattenMap:^id _Nullable(NSNumber * _Nonnull object) {
        return @(object.integerValue + 1);
    }], end);
}
- (void)testAny {
    NSSet *begin = [NSSet setWithArray:@[@1,@3,@2]];
    
    XCTAssertTrue([begin KQS_any:^BOOL(NSNumber *object) {
        return object.integerValue % 2 == 0;
    }]);
    
    begin = [NSSet setWithArray:@[@1,@3,@5]];
    
    XCTAssertFalse([begin KQS_any:^BOOL(NSNumber *object) {
        return object.integerValue % 2 == 0;
    }]);
}
- (void)testAll {
    NSSet *begin = [NSSet setWithArray:@[@2,@4,@6]];
    
    XCTAssertTrue([begin KQS_all:^BOOL(NSNumber *object) {
        return object.integerValue % 2 == 0;
    }]);
    
    begin = [NSSet setWithArray:@[@2,@4,@5]];
    
    XCTAssertFalse([begin KQS_all:^BOOL(NSNumber *object) {
        return object.integerValue % 2 == 0;
    }]);
}
- (void)testNone {
    NSSet *begin = [NSSet setWithArray:@[@3,@5,@7]];
    
    XCTAssertTrue([begin KQS_none:^BOOL(NSNumber *object) {
        return object.integerValue % 2 == 0;
    }]);
    
    begin = [NSSet setWithArray:@[@3,@5,@6]];
    
    XCTAssertFalse([begin KQS_none:^BOOL(NSNumber *object) {
        return object.integerValue % 2 == 0;
    }]);
}
- (void)testSum {
    NSSet *begin = [NSSet setWithArray:@[@1,@2,@3]];
    NSNumber *end = @6;
    
    XCTAssertEqualObjects([begin KQS_sum], end);
    
    begin = [NSSet setWithArray:@[@1.0,@2.0,@3.0]];
    end = @6.0;
    
    XCTAssertEqualObjects([begin KQS_sum], end);
    
    begin = [NSSet setWithArray:@[[NSDecimalNumber decimalNumberWithString:@"1"],[NSDecimalNumber decimalNumberWithString:@"2"],[NSDecimalNumber decimalNumberWithString:@"3"]]];
    end = [NSDecimalNumber decimalNumberWithString:@"6"];
    
    XCTAssertEqualObjects([begin KQS_sum], end);
}
- (void)testProduct {
    NSSet *begin = [NSSet setWithArray:@[@2,@3,@4]];
    NSNumber *end = @24;
    
    XCTAssertEqualObjects([begin KQS_product], end);
    
    begin = [NSSet setWithArray:@[@2.0,@3.0,@4.0]];
    end = @24.0;
    
    XCTAssertEqualObjects([begin KQS_product], end);
    
    begin = [NSSet setWithArray:@[[NSDecimalNumber decimalNumberWithString:@"2"],[NSDecimalNumber decimalNumberWithString:@"3"],[NSDecimalNumber decimalNumberWithString:@"4"]]];
    end = [NSDecimalNumber decimalNumberWithString:@"24"];
    
    XCTAssertEqualObjects([begin KQS_product], end);
}
- (void)testMaximum {
    NSSet *begin = [NSSet setWithArray:@[@1,@3,@2]];
    NSNumber *end = @3;
    
    XCTAssertEqualObjects([begin KQS_maximum], end);
}
- (void)testMinimum {
    NSSet *begin = [NSSet setWithArray:@[@1,@-1,@2]];
    NSNumber *end = @-1;
    
    XCTAssertEqualObjects([begin KQS_minimum], end);
}

@end
