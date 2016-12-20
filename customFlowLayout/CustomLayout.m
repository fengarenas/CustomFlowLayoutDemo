//
//  CustomLayout.m
//  customFlowLayout
//
//  Created by FengJ on 16/11/14.
//  Copyright © 2016年 fengj. All rights reserved.
//

#import "CustomLayout.h"

@implementation CustomLayout {
    NSMutableArray *columnHeights;
    NSMutableArray <UICollectionViewLayoutAttributes *> *attributes;
}

- (instancetype)initWithLayoutSetting:(CustomLayoutSetting *)setting delegate:(id<CustomLayoutDelegate>)delegate {
    self = [super init];
    if (self) {
        NSParameterAssert(setting);
        NSParameterAssert(delegate);
        _setting = setting;
        _delegate = delegate;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    CGFloat height = self.setting.sectionInset.top;
    columnHeights = [[NSMutableArray alloc]initWithCapacity:self.setting.columnCount];
    for (int i = 0; i<self.setting.columnCount; i++) {
        [columnHeights addObject:@(height)];
    }
    attributes = @[].mutableCopy;
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<count; i++) {
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [attributes addObject:attr];
    }
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, [self longestColumnHeight].floatValue);
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return attributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    CGFloat width = [self itemWidth];
    CGFloat height = [self.delegate heightForRowAtIndexPath:indexPath itemWidth:width];
    CGPoint point = [self shortestColumnXY];
    CGRect rect = CGRectMake(point.x, point.y, width, height);
    attr.frame = rect;
    
    //更新列高度
    BOOL isLastLine = ([self.collectionView numberOfItemsInSection:0] - indexPath.row - 1) < _setting.columnCount;
    NSNumber *newHeight = @(CGRectGetMaxY(rect) + (isLastLine ? _setting.sectionInset.bottom : _setting.rowSpacing));
    NSNumber *shortestColumnHeight = [self shortestColumeHeight];
    NSInteger shortestColumnIndex = [columnHeights indexOfObject:shortestColumnHeight];
    columnHeights[shortestColumnIndex] = newHeight;
    return attr;
}

- (CGPoint)shortestColumnXY {
    NSNumber *shortColumnHeight = [self shortestColumeHeight];
    CGFloat x,y;
    NSUInteger rowIndex = [columnHeights indexOfObject:shortColumnHeight];
    CGFloat itemWidth = [self itemWidth];
    x =  _setting.sectionInset.left + ((itemWidth + _setting.rowSpacing) * rowIndex);
    y = shortColumnHeight.floatValue;
    return CGPointMake(x, y);
}

- (NSNumber *)shortestColumeHeight {
    __block NSNumber *shortestColumn = columnHeights[0];
    [columnHeights enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.floatValue < shortestColumn.floatValue) {
            shortestColumn = obj;
        } else if (obj.floatValue == shortestColumn.floatValue) {
            shortestColumn = [columnHeights indexOfObject:obj] > [columnHeights indexOfObject:shortestColumn] ? shortestColumn : obj;
        }
    }];
    return shortestColumn;
}

- (NSNumber *)longestColumnHeight {
    __block NSNumber *longestColumn = columnHeights[0];
    [columnHeights enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.floatValue > longestColumn.floatValue) {
            longestColumn = obj;
        } else if (obj.floatValue == longestColumn.floatValue) {
            longestColumn = [columnHeights indexOfObject:obj] > [columnHeights indexOfObject:longestColumn] ? longestColumn : obj;
        }
    }];
    return longestColumn;
}

- (CGFloat)itemWidth {
    return (self.collectionView.bounds.size.width - _setting.sectionInset.left - _setting.sectionInset.right - _setting.columnSpacing * (_setting.columnCount - 1))/self.setting.columnCount;
}

@end


@implementation CustomLayoutSetting

+ (instancetype)settingWithColumnCount:(NSInteger)count
                         columnSpacing:(CGFloat)columnSpace
                            rowSpacing:(CGFloat)rowSpace
                          sectionInset:(UIEdgeInsets)sectionInset {
    CustomLayoutSetting *setting = [[[self class]alloc]init];
    setting.columnCount = count;
    setting.columnSpacing = columnSpace;
    setting.rowSpacing = rowSpace;
    setting.sectionInset = sectionInset;
    return setting;
}

@end

