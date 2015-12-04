//
//  STImageView.m
//  Orobind
//
//  Created by Luv Singh on 02/12/15.
//  Copyright (c) 2015 Luv Singh. All rights reserved.
//

#import "STImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface STImageView()
@property(nonatomic, strong)UIActivityIndicatorView *activity;
@end

@implementation STImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _activity =
    [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addSubview:self.activity];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect rect = self.activity.frame;
    rect.origin.x = (self.frame.size.width - rect.size.width) / 2;
    rect.origin.y = (self.frame.size.height - rect.size.height) / 2;
    self.activity.frame = rect;
}

- (void)startLoader {
    self.activity.hidden = NO;
    [self.activity startAnimating];
}

- (void)stopLoader {
    self.activity.hidden = YES;
    [self.activity stopAnimating];
}

#pragma mark - Public

- (void) setImageWithURLString:(NSString *)urlString {
    [self setImageWithURLString:urlString
               placeholderImage:nil
                    progressBar:nil
                completionBlock:nil];
}

- (void) setImageWithURLString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    [self setImageWithURLString:urlString
               placeholderImage:placeholderImage
                    progressBar:nil
                completionBlock:nil];
}


- (void) setImageWithURLString:(NSString *)urlString
              placeholderImage:(UIImage *)placeholderImage
               completionBlock:(void(^) (BOOL success, UIImage * image))completionBlock {
    [self setImageWithURLString:urlString
               placeholderImage:placeholderImage
                    progressBar:nil
                completionBlock:completionBlock];
}

- (void) setImageWithURLString:(NSString *)urlString
              placeholderImage:(UIImage *)placeholderImage
                   progressBar:(void(^)(CGFloat progress))progressBlock
               completionBlock:(void(^) (BOOL success, UIImage * image))completionBlock {
    if (!urlString) {
        if (progressBlock) {
            progressBlock(0);
        }
        if (completionBlock) {
            completionBlock (NO, nil);
        }
        return;
    }
    
    NSURL *imageUrl = [NSURL URLWithString:urlString];
    [self startLoader];
    [self sd_setImageWithURL:imageUrl
            placeholderImage:placeholderImage
                     options:SDWebImageRefreshCached|SDWebImageRetryFailed
                    progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        CGFloat progress = 0.0f;
                        if (expectedSize > 0) {
                            progress = (CGFloat)receivedSize / expectedSize;
                        }
                        if (progressBlock) {
                            progressBlock(progress);
                        }
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                        [self stopLoader];
                        if (completionBlock) {
                            completionBlock ((error == nil), image);
                        }
                    }
     ];
}

@end
