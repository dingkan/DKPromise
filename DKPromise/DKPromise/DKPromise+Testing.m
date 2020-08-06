//
//  DKPromise+Testing.m
//  DKPromise
//
//  Created by 丁侃 on 2020/5/22.
//  Copyright © 2020 丁侃. All rights reserved.
//

#import "DKPromise+Testing.h"

BOOL DKWaitForPromisesWithTimeout(NSTimeInterval timeout) {
  BOOL isTimedOut = NO;
  NSDate *timeoutDate = [NSDate dateWithTimeIntervalSinceNow:timeout];
  static NSTimeInterval const minimalTimeout = 0.01;
  static int64_t const minimalTimeToWait = (int64_t)(minimalTimeout * NSEC_PER_SEC);
  dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW, minimalTimeToWait);
  dispatch_group_t dispatchGroup = DKPromise.dispatchGroup;
  NSRunLoop *runLoop = NSRunLoop.currentRunLoop;
  while (dispatch_group_wait(dispatchGroup, waitTime)) {
    isTimedOut = timeoutDate.timeIntervalSinceNow < 0.0;
    if (isTimedOut) {
      break;
    }
    [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:minimalTimeout]];
  }
  return !isTimedOut;
}


@implementation DKPromise (Testing)

+(dispatch_group_t)dispatchGroup{
    static dispatch_group_t gDispatchGroup;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gDispatchGroup = dispatch_group_create();
    });
    
    return gDispatchGroup;
}

@end
