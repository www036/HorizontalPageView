//
//  ViewController.m
//  HorizontanPageView
//
//  Created by CJW on 16/10/20.
//  Copyright © 2016年 Datong. All rights reserved.
//

#import "ViewController.h"
#import "HorizontalPageFlowlayout.h"
#import "HorizontalPageCell.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define Random(X) arc4random_uniform(X)/255.0
#define RandomColor [UIColor colorWithRed:Random(255) green:Random(255) blue:Random(255) alpha:1.0]

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

static NSString * const identifier = @"HorizontalPageCell";
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.collectionView];
}

#pragma mark - Lazy
- (UICollectionView *)collectionView
{
    if (!_collectionView) {   
        
//        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        HorizontalPageFlowlayout *layout = [[HorizontalPageFlowlayout alloc] initWithRowCount:3 itemCountPerRow:5];
        [layout setColumnSpacing:10 rowSpacing:15 edgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        
        // 注意,此处设置的item的尺寸是理论值，实际是由行列间距、collectionView的内边距和宽高决定
        layout.itemSize = CGSizeMake(ScreenWidth / 5, 60);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth, 200) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor yellowColor];
        _collectionView.bounces = YES;
        _collectionView.pagingEnabled = YES; 
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([HorizontalPageCell class]) bundle:nil] forCellWithReuseIdentifier:identifier];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 19;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HorizontalPageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.contentView.backgroundColor = RandomColor;
    NSInteger row = indexPath.row;
    cell.titleLbl.text = [NSString stringWithFormat:@"第%ld个", row];
    
    return cell;
}

@end
