//
//  FirstPageViewController.m
//  IOSProgrammingFramework
//
//  Created by liquangang on 2017/2/16.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "FirstPageViewController.h"

static NSString *const FirstPageViewControllerCellResuableID = @"FirstPageViewControllerCellResuableID";

static NSString *VcListPath(){
    return [[NSBundle mainBundle] pathForResource:@"VcList" ofType:@"plist"];
}

@interface FirstVcModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *class; ///< 类名
@end

@implementation FirstVcModel

@end

@interface FirstPageViewController ()
<
    UITableViewDelegate,
    UITableViewDataSource
>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation FirstPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource && UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FirstPageViewControllerCellResuableID];
    FirstVcModel *model = self.dataSource[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FirstVcModel *model = self.dataSource[indexPath.row];
    UIViewController *tempVc = [[NSClassFromString(model.class) alloc] init];
    [self.navigationController pushViewController:tempVc animated:YES];
}

#pragma mark - getter & setter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:FirstPageViewControllerCellResuableID];
    }
    return _tableView;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *tempMuArr = [[NSMutableArray alloc] initWithContentsOfFile:VcListPath()];
        for (NSDictionary *dic in tempMuArr) {
            FirstVcModel *model = [FirstVcModel yy_modelWithDictionary:dic];
            model ? [_dataSource addObject:model] : nil;
        }
    }
    return _dataSource;
}

@end
