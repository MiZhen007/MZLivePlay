
//
//  AllLiveViewController.m
//  XuanYan
//
//  Created by mz on 16/11/17.
//  Copyright © 2016年 mizhen. All rights reserved.
//

#import "AllLiveViewController.h"

@interface AllLiveViewController ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UICollectionViewDataSource>{
    //每个cell的大小
    CGSize cellSize;
    
    NSMutableArray *mainArray;
    //介绍视图
    SubIntroView *subIntroView;
    
}
@property(nonatomic,strong)UICollectionView *mainCollectionView;


@end

@implementation AllLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"全部直播";
    self.view.backgroundColor=LoginBackColor;
    cellSize=Adapt(VideoCellSize);
    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    mainArray=[[NSMutableArray alloc] init];
    
//    //创建返回按钮
//    UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,12,20)];
//    [returnButton addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
//    [returnButton setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
//    UIBarButtonItem *returnButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnButton];
//    self.navigationItem.leftBarButtonItem = returnButtonItem;
    
    [self setUpView];
    [self setUpIntroView];
    
}

-(void)setUpIntroView{
    
    subIntroView=[[SubIntroView alloc] init];
    [self.view addSubview:subIntroView];
    subIntroView.hidden=YES;
}

-(void)setUpView{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
    layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 10.0f);//头部视图的框架大小
    // 定义大小
    layout.itemSize = cellSize;
    // 设置最小行间距
    layout.minimumLineSpacing = 10;
    // 设置垂直间距
    layout.minimumInteritemSpacing = 5;
    
    layout.sectionInset = Adapt(VideoEdgeInsets);//网格视图的/上/左/下/右,的边距
    
    // 设置滚动方向（默认垂直滚动）
    //layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //////////////////////
    _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) collectionViewLayout:layout]; //初始化网格视图大小
    _mainCollectionView.backgroundColor=LoginBackColor;
    
    [_mainCollectionView registerClass:[LiveCollectionViewCell class] forCellWithReuseIdentifier:@"LiveCollectionViewCell"];//cell重用设置ID
    
    //[_mainCollectionView registerClass:[CalendarMonthHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:MonthHeader];
    
//    _mainCollectionView.bounces = NO;//将网格视图的下拉效果关闭
    
    _mainCollectionView.delegate = self;//实现网格视图的delegate
    
    _mainCollectionView.dataSource = self;//实现网格视图的dataSource
    
    _mainCollectionView.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:_mainCollectionView];
    //下拉刷新
    _mainCollectionView.mj_header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self downloadDataViaNet];
        [_mainCollectionView.mj_footer resetNoMoreData];
        [_mainCollectionView.mj_header endRefreshing];
        
    }];
    _mainCollectionView.mj_header.backgroundColor=StyleColor;

}

#pragma mark -网络数据加载

-(void)downloadDataViaNet{
    //加载
    [MZActivityIndicatorView loadingAnimationStart];
    //
    NSMutableDictionary *paraDic=[[NSMutableDictionary alloc] init];

    [MZNetwork MZNewPostRequest:ObtainAllLive Parameters:paraDic success:^(NSString *error, NSString *msg, id result) {
        [MZActivityIndicatorView loadingAnimationStop];
        if (error.integerValue==1) {
            [mainArray removeAllObjects];
            
            for (NSDictionary *tmpDic in result) {
                LiveRoomDetailModel *liveModel=[[LiveRoomDetailModel alloc] init];
                [liveModel setValuesForKeysWithDictionary:tmpDic];
                [mainArray addObject:liveModel];
                
            }
            [_mainCollectionView reloadData];
            [MZActivityIndicatorView loadingAnimationStop];

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *netError) {
        [MZActivityIndicatorView loadingAnimationStop];
        [MZTools confirmAlertViewAboveVC:self Title:@"失败" Message:@"网络请求失败" ActionTitle:@"确定" Action:^{
            [self returnBack];
        }];
    }];
    
//    [MZNetwork MZPostRequest:LiveListUrl Parameters:paraDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSError *error;
//        NSDictionary *jsonDic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
//        
//        if ([[jsonDic valueForKeyPath:@"errorCode"] isEqual:@0]) {
//            
//            //解析数据
//            NSDictionary *dataDic=[jsonDic valueForKeyPath:@"data"];
//            NSMutableArray *liveArray=[dataDic objectForKey:@"liveRoomsList"];
//            for (NSDictionary *tmpDic in liveArray) {
//                LiveRoomDetailModel *liveModel=[[LiveRoomDetailModel alloc] init];
//                [liveModel setValuesForKeysWithDictionary:tmpDic];
//                [mainArray addObject:liveModel];
//
//            }
//        }
//        
//        [_mainCollectionView reloadData];
//        [MZActivityIndicatorView loadingAnimationStop];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MZActivityIndicatorView loadingAnimationStop];
//        [MZTools confirmAlertViewAboveVC:self Title:@"失败" Message:@"网络请求失败" ActionTitle:@"确定" Action:^{
//            [self returnBack];
//        }];
//    }];
    
}

#pragma mark - CollectionView代理方法

//定义展示的Section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//定义展示的UICollectionViewCell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return mainArray.count;
}

//每个UICollectionView展示的内容
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    LiveCollectionViewCell *cell = [_mainCollectionView dequeueReusableCellWithReuseIdentifier:@"LiveCollectionViewCell" forIndexPath:indexPath];
//
//    LiveCollectionViewCell *cell=[[LiveCollectionViewCell alloc] init];
    cell.liveModel=(LiveRoomDetailModel *)[mainArray objectAtIndex:indexPath.row];
 
    return cell;
}

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if (subIntroView.isHidden==YES) {
//        subIntroView.hidden=NO;
//    }
//    else{
//        subIntroView.hidden=YES;
//    }
//    return;
    LiveRoomDetailModel *tmpModel=[[LiveRoomDetailModel alloc] init];
    tmpModel=[mainArray objectAtIndex:indexPath.row];

    //根据购买状态判定弹出什么视图
    if (tmpModel.purchaseStatus.integerValue==1) {
        LiveVideoVC *liveVC=[[LiveVideoVC alloc] init];
        liveVC.liveRoomModel=tmpModel;
        //        [liveVC downloadDataViaNet];
        [liveVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:liveVC animated:YES];
        
    }
    else{
        CourseModel *courseModel=[[CourseModel alloc] init];
        courseModel.courseID=tmpModel.courseID;
        
        CourseViewController *courseVC=[[CourseViewController alloc] init];
        courseVC.courseModel=courseModel;
        [courseVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:courseVC animated:YES];
    }

//    LiveRoomDetailModel *tmpModel=(LiveRoomDetailModel *)[mainArray objectAtIndex:indexPath.row];
//    //判断是未开始还是正在进行
//    LiveVideoVC *liveVC=[[LiveVideoVC alloc] init];
//    liveVC.liveRoomModel=tmpModel;
////    [liveVC downloadDataViaNet];
//    [liveVC setHidesBottomBarWhenPushed:YES];
//    [self.navigationController pushViewController:liveVC animated:YES];
//    if (tmpModel.roomStatus==2) {
//        //直播已开始，正在进行中
//        LiveVideoVC *liveVC=[[LiveVideoVC alloc] init];
//        liveVC.liveRoomModel=(LiveRoomModel *)[mainArray objectAtIndex:indexPath.row];
//        [liveVC downloadDataViaNet];
//        [self.navigationController pushViewController:liveVC animated:YES];
//    }
//    
//    else{
//        //直播未开始
//        LiveIntroductionViewController *liveIntroVC=[[LiveIntroductionViewController alloc] init];
//        [liveIntroVC setUpDataWithVideoType:LiveVideo WebcastID:tmpModel.playID];
//        [self.navigationController pushViewController:liveIntroVC animated:YES];
//    }
    
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
#pragma mark --按钮点击事件
-(void)returnBack{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [MZActivityIndicatorView loadingAnimationStop];
}
//- (void)viewWillLayoutSubviews {
//    self.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    
//}
//-(void)viewDidLayoutSubviews{
//    
//    self.view.frame=CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//
//}

@end















