//
//  CustomLayout.h
//  customFlowLayout
//
//  Created by FengJ on 16/11/14.
//  Copyright © 2016年 fengj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomLayoutDelegate <NSObject>
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth;
@end

@class CustomLayoutSetting;

@interface CustomLayout : UICollectionViewLayout

@property (nonatomic, weak) id <CustomLayoutDelegate> delegate;
@property (nonatomic, strong) CustomLayoutSetting *setting;

- (instancetype)initWithLayoutSetting:(CustomLayoutSetting *)setting delegate:(id<CustomLayoutDelegate>)delegate;

@end




@interface CustomLayoutSetting : NSObject
//总共多少列
@property (nonatomic, assign) NSInteger columnCount;
//列间距
@property (nonatomic, assign) CGFloat columnSpacing;
//行间距
@property (nonatomic, assign) CGFloat rowSpacing;
//section与collectionView的间距
@property (nonatomic, assign) UIEdgeInsets sectionInset;

+ (instancetype)settingWithColumnCount:(NSInteger)count
                         columnSpacing:(CGFloat)columnSpace
                            rowSpacing:(CGFloat)rowSpace
                          sectionInset:(UIEdgeInsets)sectionInset;
@end
