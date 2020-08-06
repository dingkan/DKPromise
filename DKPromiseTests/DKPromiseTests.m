//
//  DKPromiseTests.m
//  DKPromiseTests
//
//  Created by 丁侃 on 2017/5/17.
//  Copyright © 2017年 丁侃. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DKPromise+Testing.h"
#import "DKPromises.h"
#import "DKPromiseHelper.h"

@interface DKPromiseTests : XCTestCase

@end

@implementation DKPromiseTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    DKPromise<NSNumber *> *promise = [DKPromise pendingPromise];
    
    XCTAssertTrue(promise.isPending);
    XCTAssertFalse(promise.isFulFilled);
    XCTAssertFalse(promise.isRejected);
    XCTAssertNil(promise.value);
    XCTAssertNil(promise.error);
}

- (void)testPromiseConstructorResolveWithValue {
    DKPromise<NSNumber *> *promise = [DKPromise resolvedWith:@42];
    
    XCTAssertFalse(promise.isPending);
    XCTAssertTrue(promise.isFulFilled);
    XCTAssertFalse(promise.isRejected);
    XCTAssertEqual(promise.value, @42);
    XCTAssertNil(promise.error);
}

- (void)testPromiseConstructorResolveWithError{
    NSError *error = [NSError errorWithDomain:DKPromiseErrorDomain code:DKPromiseErrorCodeValidationFailure userInfo:nil];
    
    DKPromise *promise = [DKPromise resolvedWith:error];
    
    XCTAssertFalse(promise.isPending);
    XCTAssertFalse(promise.isFulFilled);
    XCTAssertTrue(promise.isRejected);
    XCTAssertNil(promise.value);
    XCTAssertNotNil(promise.error);
}
- (void)testPromiseFulfill {
    DKPromise *promise = [DKPromise pendingPromise];
    
    [promise fulfill:@42];
    
    XCTAssertFalse(promise.isPending);
    XCTAssertFalse(promise.isRejected);
    XCTAssertTrue(promise.isFulFilled);
    XCTAssertEqual(promise.value, @42);
    XCTAssertNil(promise.error);
}

- (void)testPromiseNoDoubleFulfill {
    DKPromise *promise = [DKPromise pendingPromise];
    
    [promise fulfill:@43];
    [promise fulfill:@13];
    
    
    XCTAssertFalse(promise.isPending);
    XCTAssertFalse(promise.isRejected);
    XCTAssertTrue(promise.isFulFilled);
    XCTAssertEqual(promise.value, @43);
    XCTAssertNil(promise.error);
}

- (void)testPromiseFulfillWithError {
    
    DKPromise *promise = [DKPromise pendingPromise];
    [promise fulfill:(id)[NSError errorWithDomain:DKPromiseErrorDomain code:42 userInfo:nil]];
    
    XCTAssertFalse(promise.isPending);
    XCTAssertTrue(promise.isRejected);
    XCTAssertFalse(promise.isFulFilled);
    XCTAssertNil(promise.value);
    XCTAssertEqualObjects(promise.error.domain, DKPromiseErrorDomain);
    XCTAssertEqual(promise.error.code, 42);
}

- (void)testPromiseReject {
    
    DKPromise *promise = [DKPromise pendingPromise];
    [promise reject:[NSError errorWithDomain:DKPromiseErrorDomain code:42 userInfo:nil]];
    
    XCTAssertFalse(promise.isPending);
    XCTAssertTrue(promise.isRejected);
    XCTAssertFalse(promise.isFulFilled);
    XCTAssertNil(promise.value);
    XCTAssertEqualObjects(promise.error.domain, DKPromiseErrorDomain);
    XCTAssertEqual(promise.error.code, 42);
}


- (void)testPromiseNoDoubleReject {
    
    DKPromise *promise = [DKPromise pendingPromise];
    [promise reject:[NSError errorWithDomain:DKPromiseErrorDomain code:42 userInfo:nil]];
    [promise reject:[NSError errorWithDomain:DKPromiseErrorDomain code:43 userInfo:nil]];
    
    XCTAssertFalse(promise.isPending);
    XCTAssertTrue(promise.isRejected);
    XCTAssertFalse(promise.isFulFilled);
    XCTAssertNil(promise.value);
    XCTAssertEqualObjects(promise.error.domain, DKPromiseErrorDomain);
    XCTAssertEqual(promise.error.code, 42);
}


- (void)testPromiseNoRejectAfterFulfill {
    
    DKPromise *promise = [DKPromise pendingPromise];
    [promise fulfill:@42];
    [promise reject:[NSError errorWithDomain:DKPromiseErrorDomain code:43 userInfo:nil]];
    
    XCTAssertFalse(promise.isPending);
    XCTAssertFalse(promise.isRejected);
    XCTAssertTrue(promise.isFulFilled);
    XCTAssertNil(promise.error);
    XCTAssertEqual(promise.value, @42);
}


- (void)testPromiseNoFulfillAfterReject {
    
    DKPromise *promise = [DKPromise pendingPromise];
    [promise reject:[NSError errorWithDomain:DKPromiseErrorDomain code:43 userInfo:nil]];
    [promise fulfill:@42];
    
    XCTAssertFalse(promise.isPending);
    XCTAssertTrue(promise.isRejected);
    XCTAssertFalse(promise.isFulFilled);
    XCTAssertNil(promise.value);
    XCTAssertEqualObjects(promise.error.domain, DKPromiseErrorDomain);
    XCTAssertEqual(promise.error.code, 43);
}

- (void)testPromisePendingDealloc {
    DKPromise __weak *weakPromise;
    @autoreleasepool {
        XCTAssertNil(weakPromise);
        weakPromise = [DKPromise pendingPromise];
        XCTAssertNotNil(weakPromise);
    }

    XCTAssertNil(weakPromise);
}


#pragma -------------------   all   -------------------
- (void)testPromiseAll {
    NSArray *expectedValues = @[@42, @"hello world", @[@42], [NSNull null]];
    
    DKPromise <NSNumber *>*promise1 = [DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(0.1, ^{
            fulfill(@42);
        });
    }];
    
    DKPromise <NSNumber *>*promise2 = [DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(1, ^{
            fulfill(@"hello world");
        });
    }];
    
    DKPromise <NSNumber *>*promise3 = [DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(2, ^{
            fulfill(@[@42]);
        });
    }];
    
    DKPromise <NSNumber *>*promise4 = [DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(3, ^{
            fulfill(nil);
        });
    }];
    
    DKPromise <NSArray *>*combinedPromise = [[DKPromise all:@[promise1, promise2, promise3, promise4]] then:^id _Nullable(NSArray * _Nullable value) {
        XCTAssertEqualObjects(value, expectedValues);
        return value;
    }];
    
    XCTAssert(DKWaitForPromisesWithTimeout(10));
    XCTAssertEqualObjects(combinedPromise.value, expectedValues);
    XCTAssertNil(combinedPromise.error);
    
}


- (void)testPromiseAllEmpty {
    DKPromise <NSArray *>*promise = [[DKPromise all:@[]] then:^id _Nullable(NSArray * _Nullable value) {
        XCTAssertEqualObjects(value, @[]);
        return value;
    }];
    
    XCTAssert(DKWaitForPromisesWithTimeout(10));
    XCTAssertEqualObjects(promise.value, @[]);
    XCTAssertNil(promise.error);
}


- (void)testPromiseAllRejectFirst {
    DKPromise <NSNumber *>*promise1 = [DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(1, ^{
            fulfill(@42);
        });
    }];
    
    DKPromise <NSNumber *>*promise2 = [DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(0.1, ^{
            reject([NSError errorWithDomain:DKPromiseErrorDomain code:42 userInfo:nil]);
        });
    }];
    
    DKPromise *combinedPromise = [[[DKPromise all:@[promise1, promise2]] then:^id _Nullable(NSArray * _Nullable value) {
        XCTFail();
        return nil;
    }] catch:^(NSError * _Nonnull error) {
        XCTAssertEqual(error.code, 42);
    }];
    
    XCTAssert(DKWaitForPromisesWithTimeout(10));
    XCTAssertEqual(combinedPromise.error.code, 42);
    XCTAssertNil(combinedPromise.value);
}


- (void)testPromiseAllRejectLast {
    DKPromise <NSNumber *>*promise1 = [DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(0.1, ^{
            fulfill(@42);
        });
    }];
    
    DKPromise <NSNumber *>*promise2 = [DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(1, ^{
            reject([NSError errorWithDomain:DKPromiseErrorDomain code:42 userInfo:nil]);
        });
    }];
    
    DKPromise <NSArray *>*combinePormise = [[[DKPromise all:@[promise1, promise2]] then:^id _Nullable(NSArray * _Nullable value) {
        XCTFail();
        return nil;
    }] catch:^(NSError * _Nonnull error) {
        XCTAssertEqual(error.code, 42);
    }];
    
    XCTAssert(DKWaitForPromisesWithTimeout(10));
    XCTAssertEqual(combinePormise.error.code, 42);
    XCTAssertNil(combinePormise.value);
}


- (void)testPromiseAllWithValues {
    NSArray *expectedValues = @[@42, @"hello world", @[@42], [NSNull null]];
    
    DKPromise <NSArray <NSNumber * >*>*promise = [DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(0.1, ^{
            fulfill(@[ @42 ]);
        });
    }];
    
    DKPromise *promise1 = [DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(1, ^{
            fulfill(nil);
        });
    }];
    
    DKPromise <NSArray *>*combinedPromises = [[DKPromise all:@[@42, @"hello world", promise, promise1]]then:^id _Nullable(NSArray * _Nullable value) {
        XCTAssertEqualObjects(value, expectedValues);
        return value;
    }];
    
    XCTAssert(DKWaitForPromisesWithTimeout(10));
    XCTAssertEqualObjects(combinedPromises.value, expectedValues);
    XCTAssertNil(combinedPromises.error);
}

- (void)testPromiseAllWithError {
    NSError *error = [NSError errorWithDomain:DKPromiseErrorDomain code:42 userInfo:nil];
    DKPromise <NSArray <NSNumber *>*>*promise = [DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(0.1, ^{
            fulfill(@[ @42 ]);
        });
    }];

    DKPromise <NSArray *>*combinedPromises = [[[DKPromise all:@[@42, error, promise]] then:^id _Nullable(NSArray * _Nullable value) {
        XCTFail();
        return nil;
    }] catch:^(NSError * _Nonnull error) {
        XCTAssertEqual(error.code, 42);
    }];

    XCTAssert(DKWaitForPromisesWithTimeout(10));
    XCTAssertEqual(combinedPromises.error.code, 42);
    XCTAssertNil(combinedPromises.value);
}


- (void)testPromiseAllNoDeallocUntilResolved {
    DKPromise *promise = [DKPromise pendingPromise];
    DKPromise __weak *weakPromise1;
    DKPromise __weak *weakPromise2;
    
    @autoreleasepool {
        XCTAssertNil(weakPromise1);
        XCTAssertNil(weakPromise2);
        
        weakPromise1 = [DKPromise all:@[promise]];
        weakPromise2 = [DKPromise all:@[promise]];
        
        XCTAssertNotNil(weakPromise1);
        XCTAssertNotNil(weakPromise2);
    }
    

    XCTAssertNotNil(weakPromise1);
    XCTAssertNotNil(weakPromise2);
    
    [promise fulfill:@42];
    XCTAssert(DKWaitForPromisesWithTimeout(10));
    XCTAssertNil(weakPromise1);
    XCTAssertNil(weakPromise2);
}

#pragma -------------------   always   -------------------

- (void)testPromiseAlwaysOnFulfilled {
    NSUInteger __block count = 0;
    NSUInteger const expectedCount = 3;
    
    DKPromise <NSNumber *>*promise = [[[[DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(0.1, ^{
            fulfill(@42);
        });
    }] always:^{
        ++ count;
    }] then:^id _Nullable(NSNumber *value) {
        XCTAssertEqualObjects(value, @42);
        ++count;
        return  value;
    }] always:^{
        ++count;
    }];
    
    XCTAssert(DKWaitForPromisesWithTimeout(10));
    XCTAssertEqual(count, expectedCount);
    XCTAssertEqualObjects(promise.value, @42);
    XCTAssertNil(promise.error);
}

- (void)testPromiseAlwaysOnRejected {
    NSUInteger __block count = 0;
    NSUInteger const expectedCount = 3;
    DKPromise <NSNumber *>*promise = [[[[DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(0.1, ^{
            reject([NSError errorWithDomain:DKPromiseErrorDomain code:42 userInfo:nil]);
        });
    }] always:^{
        ++count;
    }] catch:^(NSError * _Nonnull error) {
        XCTAssertEqual(error.code, 42);
        ++count;
    }] always:^{
        ++count;
    }];
    
    XCTAssert(DKWaitForPromisesWithTimeout(10));
    XCTAssertEqual(count, expectedCount);
    XCTAssertEqual(promise.error.code, 42);
    XCTAssertNil(promise.value);
}

- (void)testPromiseAlwaysNoDeallocUntilResolved {
    DKPromise *promise = [DKPromise pendingPromise];
    DKPromise __weak *weakPromise1;
    DKPromise __weak *weakPromise2;
    
    @autoreleasepool {
        XCTAssertNil(weakPromise1);
        XCTAssertNil(weakPromise2);
        
        weakPromise1 = [promise always:^{}];
        weakPromise2 = [promise always:^{}];
        
        XCTAssertNotNil(weakPromise1);
        XCTAssertNotNil(weakPromise2);
    }
    
    XCTAssertNotNil(weakPromise1);
    XCTAssertNotNil(weakPromise2);
    
    [promise fulfill:@42];
    XCTAssert(DKWaitForPromisesWithTimeout(10));
    
    XCTAssertNil(weakPromise1);
    XCTAssertNil(weakPromise2);
}

#pragma -------------------   any   -------------------
- (void)testPromiseAny {
    NSArray *expectedValues = @[@42, @"hello world", @[ @42 ], [NSNull null]];
    
    DKPromise <NSNumber *>*promise1 = [DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(0.1, ^{
            fulfill(@42);
        });
    }];
    
    DKPromise <NSString *>*promise2 = [DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(1, ^{
            fulfill(@"hello world");
        });
    }];
    
    DKPromise <NSArray <NSNumber *>*>*promise3 = [DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(2, ^{
            fulfill(@[ @42 ]);
        });
    }];
    
    DKPromise *promise4 = [DKPromise async:^(DKPromiseFulFillBlock  _Nonnull fulfill, DKPromiseRejcetBlock  _Nonnull reject) {
        DKDelay(3, ^{
            fulfill(nil);
        });
    }];
    
    
    DKPromise <NSArray *>*combinePormise = [[DKPromise any:@[promise1, promise2, promise3, promise4]] then:^id _Nullable(NSArray * _Nullable value) {
        XCTAssertEqualObjects(value, expectedValues);
        return value;
    }];
    
    XCTAssert(DKWaitForPromisesWithTimeout(10));
    XCTAssertEqualObjects(combinePormise.value, expectedValues);
    XCTAssertNil(combinePormise.error);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
