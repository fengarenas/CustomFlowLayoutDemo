//
//  ViewController.m
//  customFlowLayout
//
//  Created by FengJ on 16/11/14.
//  Copyright © 2016年 fengj. All rights reserved.
//

#import "ViewController.h"
#import "CustomLayout.h"
#import "XRImage.h"
#import "UIImageView+WebCache.h"
#import "CollectionViewCell.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, CustomLayoutDelegate>
@property (nonatomic, strong) UICollectionView *cv;
@property (nonatomic, strong) CustomLayout *layout;
@property (nonatomic, copy) NSMutableArray <XRImage *>*images;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.cv];
}
#pragma mark - CustomLayoutDelegate

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth {
    XRImage *image = self.images[indexPath.item];
    return image.imageH / image.imageW * itemWidth;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:self.images[indexPath.item].imageURL];
    return cell;
}

- (UICollectionView *)cv {
    if (!_cv) {
        _cv = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.layout];
        _cv.delegate = self;
        _cv.dataSource = self;
        [_cv registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        _cv.backgroundColor = [UIColor whiteColor];
    }
    return _cv;
}

- (CustomLayout *)layout {
    if (!_layout) {
        CustomLayoutSetting *setting = [CustomLayoutSetting settingWithColumnCount:3
                                                                     columnSpacing:10
                                                                        rowSpacing:10
                                                                      sectionInset:UIEdgeInsetsMake(20, 20, 20, 20)];
        _layout = [[CustomLayout alloc]initWithLayoutSetting:setting delegate:self];
    }
    return _layout;
}

- (NSMutableArray *)images {
    //从plist文件中取出字典数组，并封装成对象模型，存入模型数组中
    if (!_images) {
        _images = [NSMutableArray array];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"1.plist" ofType:nil];
        NSArray *imageDics = [NSArray arrayWithContentsOfFile:path];
        for (NSDictionary *imageDic in imageDics) {
            XRImage *image = [XRImage imageWithImageDic:imageDic];
            [_images addObject:image];
        }
    }
    return _images;
}

@end
