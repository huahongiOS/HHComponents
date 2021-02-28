//
//  QKPhotoContainerController.m
//  HuaHong
//
//  Created by 华宏 on 2018/6/29.
//  Copyright © 2018年 huahong. All rights reserved.
//

#import "QKPhotoContainerController.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface QKPhotoContainerController ()<UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) id imagePath;

@end

@class HHPhotoContentController;
@implementation QKPhotoContainerController

- (instancetype)initWithImagePath:(id)imagePath
{
    self = [super init];
    if (self)
    {
        
        [self.view addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        self.scrollView.backgroundColor = [UIColor clearColor];
        self.imagePath = imagePath;
    }
    
    return self;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
        _scrollView.contentSize = self.view.bounds.size;
        _scrollView.delegate = self;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.maximumZoomScale = 3.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_scrollView addGestureRecognizer:tap];
    }
    
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView)
    {
        _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _imageView.center = self.scrollView.center;
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
        [_imageView addGestureRecognizer:tap];
        
        
    }
    
    return _imageView;
}

- (void)setImagePath:(id)imagePath
{
    _imagePath = imagePath;
    
      if ([imagePath isKindOfClass:[UIImage class]]) {
          
          self.imageView.image = (UIImage *)imagePath;
          
      }else if ([imagePath isKindOfClass:[NSString class]]){
          
          NSString *string = (NSString *)imagePath;
          if ([string hasPrefix:@"http"]) {
              [self.imageView sd_setImageWithURL:[NSURL URLWithString:string]];
          }else
          {
              self.imageView.image = [UIImage imageWithContentsOfFile:imagePath];
          }
      }
}
- (void)dismiss
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//MARK: - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    _imageView.center = scrollView.center;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
