/**
 * Copyright (c) 2015 Seth Benjamin
 * All rights reserved.

 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
@interface ComAnimecycAnimatorModuleAssets : NSObject

- (NSData*)moduleAsset;
- (NSData*)resolveModuleAsset:(NSString*)path;

@end
