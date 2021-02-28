//
//  QKChoosePhotoController.m
//  HuaHong
//
//  Created by 华宏 on 2017/12/4.
//  Copyright © 2017年 huahong. All rights reserved.
//

#import "QKChoosePhotoController.h"
#import "QKPhotoCell.h"
#import "HHAlbumManager.h"


#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface QKChoosePhotoController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSMutableArray *selectedPhotos;

@end

static NSString *cellId = @"CollectionId";

@implementation QKChoosePhotoController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _maxImageCount = 1;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    
    [HHAlbumManager searchAllImagesWithHandle:^(NSArray<UIImage *> * array) {
        if (array.count) {
            self.dataArray = array;
            [self.collectionView reloadData];
        }
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"所有照片";

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(done)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
   
    [self.view addSubview:self.collectionView];

}

- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)done
{
    
    if (_finishBlock){
        _finishBlock(_selectedPhotos.copy);
     }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//MARK: - getter
-(NSMutableArray *)selectedPhotos
{
    if (_selectedPhotos == nil) {
        _selectedPhotos = [NSMutableArray array];
    }
    
    return _selectedPhotos;
}

-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    
    return _dataArray;
}

//MARK: - collectionView
-(UICollectionView *)collectionView
{
  
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake((kScreenWidth-30)/4.0, (kScreenWidth-30)/4.0);
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[QKPhotoCell class] forCellWithReuseIdentifier:cellId];
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    
    return _collectionView;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    QKPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.contentImgView.image = [self.dataArray objectAtIndex:indexPath.item];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    UIImage *selectedImage = [self.dataArray objectAtIndex:indexPath.item];

       if (![self.selectedPhotos containsObject:selectedImage])
       {
           
           if (self.selectedPhotos.count >= self.maxImageCount)
              {
                  NSString *message = [NSString stringWithFormat:@"最多只能选择%ld张照片",(long)_maxImageCount];
                  
                  UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
                  
                  [alertCtrl addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                      
                  }]];
                  
                  
                  [self presentViewController:alertCtrl animated:YES completion:nil];
                  
                  return;
              }
           
           [self.selectedPhotos addObject:selectedImage];
           
           QKPhotoCell *cell = (QKPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
            NSBundle *imageBundle = [self getBundle];
           UIImage *image = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"common_select@2x" ofType:@"png"]];
           cell.checkView.image = image;
           
       }else
       {
           [self.selectedPhotos removeObject:selectedImage];
           
           QKPhotoCell *cell = (QKPhotoCell *)[collectionView cellForItemAtIndexPath:indexPath];
            NSBundle *imageBundle = [self getBundle];
           UIImage *image = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"common_unselect@2x" ofType:@"png"]];
           cell.checkView.image = image;
       }
    
   
    
   
}



//MARK: -
- (NSBundle *)getBundle
{
    NSBundle *podBundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [podBundle URLForResource:@"QKAlbumPhotos" withExtension:@"bundle"];
    NSBundle *bundle = url?[NSBundle bundleWithURL:url]:[NSBundle mainBundle];
    return bundle;
    
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}
@end
