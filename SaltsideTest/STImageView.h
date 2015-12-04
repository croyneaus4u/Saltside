//
//  STImageView.h
//  Orobind
//
//  Created by Luv Singh on 02/12/15.
//  Copyright (c) 2015 Luv Singh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STImageView : UIImageView

- (void) setImageWithURLString:(NSString *)urlString;

- (void) setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *) placeholderImage;

- (void) setImageWithURLString:(NSString *)urlString
              placeholderImage:(UIImage *)placeholderImage
               completionBlock:(void(^) (BOOL success, UIImage * image))completionBlock;

- (void) setImageWithURLString:(NSString *)urlString 
              placeholderImage:(UIImage *)placeholderImage
                   progressBar:(void(^)(CGFloat progress))progressBlock
               completionBlock:(void(^) (BOOL success, UIImage * image))completionBlock;
@end
