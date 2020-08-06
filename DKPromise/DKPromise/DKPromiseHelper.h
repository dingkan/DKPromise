//
//  DKPromiseHelper.h
//  DKPromise
//
//  Created by 丁侃 on 2020/5/27.
//  Copyright © 2020 丁侃. All rights reserved.
//

#ifndef DKPromiseHelper_h
#define DKPromiseHelper_h

static inline void DKDelay(NSTimeInterval interval, void (^work)(void)) {
  int64_t const timeToWait = (int64_t)(interval * NSEC_PER_SEC);
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, timeToWait),
                 dispatch_get_main_queue(), ^{
                   work();
                 });
}

#endif /* DKPromiseHelper_h */
