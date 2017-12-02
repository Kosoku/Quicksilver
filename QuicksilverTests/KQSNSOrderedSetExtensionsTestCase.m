//
//  KQSNSOrderedSetExtensionsTestCase.m
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

#import <Quicksilver/NSOrderedSet+KQSExtensions.h>

@interface KQSNSOrderedSetExtensionsTestCase : XCTestCase

@end

@implementation KQSNSOrderedSetExtensionsTestCase

- (void)testEach {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3]];
    NSOrderedSet *end = [NSOrderedSet orderedSetWithArray:@[@2,@3,@4]];
    NSMutableOrderedSet *temp = [[NSMutableOrderedSet alloc] init];
    
    [begin KQS_each:^(NSNumber *object, NSInteger index) {
        [temp addObject:@(object.integerValue + 1)];
    }];
    
    XCTAssertEqualObjects(temp, end);
}
- (void)testFilter {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3,@4]];
    NSOrderedSet *end = [NSOrderedSet orderedSetWithArray:@[@2,@4]];
    
    XCTAssertEqualObjects([begin KQS_filter:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testReject {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3,@4]];
    NSOrderedSet *end = [NSOrderedSet orderedSetWithArray:@[@1,@3]];
    
    XCTAssertEqualObjects([begin KQS_reject:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testFind {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3]];
    NSNumber *end = @2;
    
    XCTAssertEqualObjects([begin KQS_find:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testFindWithIndex {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3]];
    NSArray *end = @[@2,@1];
    
    XCTAssertEqualObjects([begin KQS_findWithIndex:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }], end);
}
- (void)testMap {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3]];
    NSOrderedSet *end = [NSOrderedSet orderedSetWithArray:@[@"1",@"2",@"3"]];
    
    XCTAssertEqualObjects([begin KQS_map:^id(NSNumber *object, NSInteger index) {
        return object.stringValue;
    }], end);
    
    end = [NSOrderedSet orderedSetWithArray:@[@"1",[NSNull null],@"3"]];
    
    XCTAssertEqualObjects([begin KQS_map:^id(NSNumber *object, NSInteger index) {
        return index % 2 == 1 ? nil : object.stringValue;
    }], end);
}
- (void)testReduce {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithObjects:[NSOrderedSet orderedSetWithObject:@1],[NSOrderedSet orderedSetWithObject:@2],[NSOrderedSet orderedSetWithObject:@3], nil];
    NSOrderedSet *end = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3]];
    
    XCTAssertEqualObjects([begin KQS_reduceWithStart:[[NSMutableOrderedSet alloc] init] block:^id(NSMutableOrderedSet *sum, NSOrderedSet *object, NSInteger index) {
        [sum unionOrderedSet:object];
        return sum;
    }], end);
}
- (void)testReduceFloat {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1.5,@2.5,@3.5]];
    CGFloat end = 7.5;
    
    XCTAssertEqual([begin KQS_reduceFloatWithStart:0.0 block:^CGFloat(CGFloat sum, id  _Nonnull object, NSInteger index) {
        return sum + [object floatValue];
    }], end);
}
- (void)testReduceInteger {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3]];
    NSInteger end = 6;
    
    XCTAssertEqual([begin KQS_reduceIntegerWithStart:0 block:^NSInteger(NSInteger sum, id  _Nonnull object, NSInteger index) {
        return sum + [object integerValue];
    }], end);
}
- (void)testFlatten {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithObjects:[NSOrderedSet orderedSetWithObject:@1],[NSOrderedSet orderedSetWithObject:@2],[NSOrderedSet orderedSetWithObject:@3],@4, nil];
    NSOrderedSet *end = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3,@4]];
    
    XCTAssertEqualObjects([begin KQS_flatten], end);
}
- (void)testFlattenMap {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithObjects:[NSOrderedSet orderedSetWithObject:@1],[NSOrderedSet orderedSetWithObject:@2],[NSOrderedSet orderedSetWithObject:@3],@4, nil];
    NSOrderedSet *end = [NSOrderedSet orderedSetWithArray:@[@2,@3,@4,@5]];
    
    XCTAssertEqualObjects([begin KQS_flattenMap:^id _Nullable(NSNumber * _Nonnull object, NSInteger index) {
        return @(object.integerValue + 1);
    }], end);
}
- (void)testAny {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@3,@2]];
    
    XCTAssertTrue([begin KQS_any:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
    
    begin = [NSOrderedSet orderedSetWithArray:@[@1,@3,@5]];
    
    XCTAssertFalse([begin KQS_any:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
}
- (void)testAll {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@2,@4,@6]];
    
    XCTAssertTrue([begin KQS_all:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
    
    begin = [NSOrderedSet orderedSetWithArray:@[@2,@4,@5]];
    
    XCTAssertFalse([begin KQS_all:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
}
- (void)testNone {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@3,@5,@7]];
    
    XCTAssertTrue([begin KQS_none:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
    
    begin = [NSOrderedSet orderedSetWithArray:@[@3,@5,@6]];
    
    XCTAssertFalse([begin KQS_none:^BOOL(NSNumber *object, NSInteger index) {
        return object.integerValue % 2 == 0;
    }]);
}
- (void)testTake {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3]];
    NSOrderedSet *end = [NSOrderedSet orderedSetWithArray:@[@1,@2]];
    
    XCTAssertEqualObjects([begin KQS_take:2], end);
    
    end = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3]];
    
    XCTAssertEqualObjects([begin KQS_take:begin.count], end);
    
    XCTAssertEqualObjects([begin KQS_take:begin.count + 1], begin);
}
- (void)testDrop {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3]];
    NSOrderedSet *end = [NSOrderedSet orderedSetWithArray:@[@1,@2]];
    
    XCTAssertEqualObjects([begin KQS_drop:1], end);
    
    end = [NSOrderedSet orderedSet];
    
    XCTAssertEqualObjects([begin KQS_drop:begin.count], end);
    
    XCTAssertEqualObjects([begin KQS_drop:begin.count + 1], end);
}
- (void)testZip {
    NSOrderedSet *first = [NSOrderedSet orderedSetWithArray:@[@1,@2]];
    NSOrderedSet *second = [NSOrderedSet orderedSetWithArray:@[@3,@4]];
    NSOrderedSet *end = [NSOrderedSet orderedSetWithArray:@[[NSOrderedSet orderedSetWithArray:@[@1,@3]],[NSOrderedSet orderedSetWithArray:@[@2,@4]]]];
    
    XCTAssertEqualObjects([first KQS_zip:second], end);
    
    second = [NSOrderedSet orderedSetWithArray:@[@3,@4,@5]];
    
    XCTAssertEqualObjects([first KQS_zip:second], end);
}
- (void)testSum {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@2,@3]];
    NSNumber *end = @6;
    
    XCTAssertEqualObjects([begin KQS_sum], end);
    
    begin = [NSOrderedSet orderedSetWithArray:@[@1.0,@2.0,@3.0]];
    end = @6.0;
    
    XCTAssertEqualObjects([begin KQS_sum], end);
    
    begin = [NSOrderedSet orderedSetWithArray:@[[NSDecimalNumber decimalNumberWithString:@"1"],[NSDecimalNumber decimalNumberWithString:@"2"],[NSDecimalNumber decimalNumberWithString:@"3"]]];
    end = [NSDecimalNumber decimalNumberWithString:@"6"];
    
    XCTAssertEqualObjects([begin KQS_sum], end);
    
    begin = [NSOrderedSet orderedSet];
    end = @0;
    
    XCTAssertEqualObjects([begin KQS_sum], end);
}
- (void)testProduct {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@2,@3,@4]];
    NSNumber *end = @24;
    
    XCTAssertEqualObjects([begin KQS_product], end);
    
    begin = [NSOrderedSet orderedSetWithArray:@[@2.0,@3.0,@4.0]];
    end = @24.0;
    
    XCTAssertEqualObjects([begin KQS_product], end);
    
    begin = [NSOrderedSet orderedSetWithArray:@[[NSDecimalNumber decimalNumberWithString:@"2"],[NSDecimalNumber decimalNumberWithString:@"3"],[NSDecimalNumber decimalNumberWithString:@"4"]]];
    end = [NSDecimalNumber decimalNumberWithString:@"24"];
    
    XCTAssertEqualObjects([begin KQS_product], end);
    
    begin = [NSOrderedSet orderedSet];
    end = @0;
    
    XCTAssertEqualObjects([begin KQS_product], end);
}
- (void)testMaximum {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@3,@2]];
    NSNumber *end = @3;
    
    XCTAssertEqualObjects([begin KQS_maximum], end);
}
- (void)testMinimum {
    NSOrderedSet *begin = [NSOrderedSet orderedSetWithArray:@[@1,@-1,@2]];
    NSNumber *end = @-1;
    
    XCTAssertEqualObjects([begin KQS_minimum], end);
}

@end
