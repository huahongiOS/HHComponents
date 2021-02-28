//
//  ChoisePhotoCell.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/4.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "QKPhotoCell.h"

@implementation QKPhotoCell

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _contentImgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _contentImgView.contentMode = UIViewContentModeScaleAspectFill;
        _contentImgView.layer.masksToBounds = YES;
        [self addSubview:_contentImgView];
        
        _checkView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width-22-5, 5, 22, 22)];
        _checkView.layer.cornerRadius = 22/2;
        
         NSBundle *imageBundle = [self getBundle];
//        UIImage *image = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"common_unselect@2x" ofType:@"png"]];
    UIImage *image = [UIImage imageNamed:@"common_unselect@2x.png" inBundle:imageBundle compatibleWithTraitCollection:nil];


        _checkView.image = image;
       
        _checkView.layer.masksToBounds = YES;
        [_contentImgView addSubview:_checkView];
        
    }
    
    return self;
}

- (NSBundle *)getBundle
{
    NSBundle *podBundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [podBundle URLForResource:@"QKAlbumPhotos" withExtension:@"bundle"];
    NSBundle *bundle = url?[NSBundle bundleWithURL:url]:[NSBundle mainBundle];
    return bundle;
    
}

//- (void)dealloc
//{
//    NSLog(@"%s",__func__);
//}
@end
