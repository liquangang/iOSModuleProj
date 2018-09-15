//
//  CodeTestViewController.m
//  IOSProgrammingFramework
//
//  Created by quangang on 2017/12/21.
//  Copyright © 2017年 liquangang. All rights reserved.
//

#import "CodeTestViewController.h"
#import <libkern/OSAtomic.h>
#import <pthread.h>
#import <AVFoundation/AVFoundation.h>

//定义链表结点结构体
struct node {
    int data;
    int id;
    struct node *next;
};

void quickSort(int a[],int low,int high);
void select_sort(int arr[],int size);
void bubbleSort(int arr[],int size);
int binary_search(int arrays[],int result,int length);

@interface CodeTestViewController ()

//nsstring 使用copy和strong的测试
@property (nonatomic, strong) NSMutableString *muStr;
@property (nonatomic, copy) NSString *cStr;
@property (nonatomic, strong) NSString *sStr;

@end

@implementation CodeTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self addTestButton];
//    [self addTestButton1];
//    [self testImageColorRecognition];
}

#pragma mark - testMethod

///**
// 合成图片测试
// */
//- (void)composeImage{
//    UIImage *tempImage1 = [UIImage imageNamed:@"jobs.png"];
//    //    UIImage *tempImage2 = [UIImage imageNamed:@"meiyan.jpg"]; //oc方式
//    UIImage *tempImage2 = ((UIImage *(*)(id, SEL, NSString *)) objc_msgSend)((id)objc_getClass("UIImage"), sel_registerName("imageNamed:"), @"meiyan.jpg"); //runtime方式
//    
//    UILabel *tempLabel = [[UILabel alloc] init];
//    tempLabel.font = [UIFont systemFontOfSize:78];
//    tempLabel.text = @"aaaaaaaaaa";
//    tempLabel.textColor = [UIColor redColor];
//    
//    UIImageView *tempImageView0 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"jobs.png"]];
//    
//    NSAttributedString *attri = [[NSAttributedString alloc] initWithString:@"fasdfasdf" attributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:72]}];
//    
//    CGRect tempImage1Rect = CGRectMake(0, 0, 1242, 1242/tempImage1.size.width*tempImage1.size.height);
//    CGRect tempImage2Rect = CGRectMake(0, CGRectGetMaxY(tempImage1Rect), 1242, 1242/tempImage2.size.width*tempImage2.size.height);
//    CGRect tempRect3 = CGRectMake(0, CGRectGetMaxY(tempImage2Rect), 1242, 100);
//    CGRect tempRect4 = CGRectMake(0, CGRectGetMaxY(tempRect3), 1242, 100);
//    
//    NSArray *modelArr = @[[[DrawModel alloc] initWithRect:tempImage1Rect object:tempImage1],
//                          [[DrawModel alloc] initWithRect:tempImage2Rect object:tempImage2],
//                          [[DrawModel alloc] initWithRect:tempRect3 object:attri],
//                          [[DrawModel alloc] initWithRect:tempRect4 object:tempImageView0]];
//    
//    UIImage *composeImage = [UIImage drawImageWithDrawModels:modelArr backgroundSize:CGSizeMake(1242, 2208) backgroundColor:[UIColor groupTableViewBackgroundColor]];
//    NSLogSize(StatusBarSize);
//    NSLogSize(NavgationBarSize);
//    UIImageView *tempImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, StatusBarSize.height + NavgationBarSize.height, SCREEN_WIDTH, SCREEN_HEIGHT - (StatusBarSize.height + NavgationBarSize.height))];
//    [self.view addSubview:tempImageView];
//    tempImageView.image = composeImage;
//}

/**
 GCD信号量测试
 */
- (void)testGCDSignl{
//    for (int i = 0; i < 10; i++) {
//        NSLog(@"11111111111111111111111");
//    }
//
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
//
//    asyncRunOnBackgroundQueue(^{
//        for (int i = 0; i < 10; i++) {
//            NSLog(@"2222222222222222222222");
//        }
//        dispatch_semaphore_signal(semaphore);
//    });
//    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//    for (int i = 0; i < 10; i++) {
//        NSLog(@"333333333333333333333");
//    }
    
}

/**
 获取网络时间测试
 */
- (void)netTimeTest{
    [NSString getInternetDate:^(NSString *string) {
        NSLog(@"%@", string);
    }];
}

- (void)respenserTest{
    
    //系统点击事件默认只有一个响应对象
    UIButton *button1 = [UIButton new];
    button1.frame = CGRectMake(0, 100, 100, 100);
    button1.backgroundColor = [UIColor redColor];
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(button1Action) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button2 = [UIButton new];
    button2.frame = CGRectMake(50, 150, 50, 50);
    button2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(button2Action) forControlEvents:UIControlEventTouchUpInside];
}

- (void)button1Action{
    NSLog(@"1234124");
}

- (void)button2Action{
    NSLog(@"67547567");
}

#pragma mark - 快速排序

void quickSort(int arr[], int left, int right){
    if (left >= right) return;
    int key = arr[left], begin = left, end = right;
    while (begin < end) {
        //找到比key小的数并且放到靠前的位置
        while (begin<end && arr[end]>=key) end--;
        if (begin < end) arr[begin] = arr[end];
        //找到比key大的数并且放到靠后的位置
        while (begin<end && arr[begin]<=key) begin++;
        if (begin < end) arr[end] = arr[begin];
    }
    arr[begin] = key;   //将key放到比key小的数后面 比key大的数前面
    quickSort(arr, left, begin-1);  //递归更小的范围 执行相同操作
    quickSort(arr, begin+1, right);
}

- (void)sortTest{
    void(^arrPrintfBlock)(int a[]) = ^(int a[]){
        for (int i = 0; i < 6; i++) {
            printf("%d", a[i]);
        }
    };
    
    int a[6] = {4, 1, 2, 3, 5, 6};
    arrPrintfBlock(a);
//    quickSort(a, 0, 5); //快速排序
//    select_sort(a, 6);  //选择排序
    bubbleSort(a, 6);   //冒泡排序
    arrPrintfBlock(a);
    
    int n = binary_search(a, 3, 6); //二分查找
    printf("\n%d", n);
}

#pragma mark - 选择排序

void select_sort(int arr[],int size)
{
    int i=0,j=0;
    int k=0;
    for(i=0;i<size;i++){
        k=i;
        for(j=i+1;j<size;j++){
            if(arr[k]>arr[j]){
                k=j;
            }
            
        }
        if(k!=i){
            int tmp=arr[k];
            arr[k]=arr[i];
            arr[i]=tmp;
        }
    }
}

#pragma mark - 冒泡排序

void bubbleSort(int arr[],int size)
{
    for(int i=0;i<size;i++)
    {
        // 第二层循环，随着外层循环次数的递增是递减的，因为排序一次，就已经把大的数放到后面了，就不需要再次排它了
        for(int j=0;j<size-i-1;j++)
        {
            if(arr[j]>arr[j+1])
            {
                int temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }
}

#pragma mark - 二分查找

int binary_search(int arrays[],int result,int length){
    int begin=0,end=length-1;
    int mid=0;
    while(begin<=end){
        mid=(begin+end)/2;
        if(arrays[mid]==result)break;
        else if(arrays[mid]<result)begin=mid+1;
        else if(arrays[mid]>result)end=mid-1;
    }
    return mid;
}

#pragma mark - NSString 的copy与strong问题

- (void)testCopy{
    self.muStr = [NSMutableString stringWithFormat:@"4321"];
    self.cStr = self.muStr;
    self.sStr = self.muStr;
    NSLog(@"muStr:%@, copyStr:%@, strongStr:%@", self.muStr, self.cStr, self.sStr);     //打印结果 muStr:4321, copyStr:4321, strongStr:4321
    [self.muStr replaceCharactersInRange:NSMakeRange(0, 1) withString:@"5"];
    NSLog(@"muStr:%@, copyStr:%@, strongStr:%@", self.muStr, self.cStr, self.sStr); //打印结果  muStr:5321, copyStr:4321, strongStr:5321
}

#pragma mark - oc中的锁

//@synchronized
- (void)synchronizedLockTest{
    __block int _tickets = 5;
    void(^testBlock)(void) = ^(){
        while (1) {
            @synchronized(self) {
                if (_tickets > 0) {
                    _tickets--;
                    NSLog(@"剩余票数= %d, Thread:%@",_tickets,[NSThread currentThread]);
                } else {
                    NSLog(@"票卖完了  Thread:%@",[NSThread currentThread]);
                    break;
                }
            }
        }
    };
    
    //线程1
    dispatch_async(dispatch_get_main_queue(), ^{
        testBlock();
    });
    
    //线程2
    dispatch_async(dispatch_get_main_queue(), ^{
        testBlock();
    });
}

//NSLock
- (void)NSLockTest{
    NSLock *lock = [NSLock new];
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 尝试加速ing...");
        [lock lock];
        sleep(3);//睡眠5秒
        NSLog(@"线程1");
        [lock unlock];
        NSLog(@"线程1解锁成功");
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 尝试加速ing...");
        BOOL x =  [lock lockBeforeDate:[NSDate dateWithTimeIntervalSinceNow:4]];
        if (x) {
            NSLog(@"线程2");
            [lock unlock];
        }else{
            NSLog(@"失败");
        }
    });
}

//OSSpinLock 自旋锁
- (void)OSSpinLockTest{
    __block OSSpinLock oslock = OS_SPINLOCK_INIT;
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 准备上锁");
        OSSpinLockLock(&oslock);
        sleep(1);
        NSLog(@"线程1");
        OSSpinLockUnlock(&oslock);
        NSLog(@"线程1 解锁成功");
        NSLog(@"--------------------------------------------------------");
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 准备上锁");
        OSSpinLockLock(&oslock);
        NSLog(@"线程2");
        OSSpinLockUnlock(&oslock);
        NSLog(@"线程2 解锁成功");
    });
}

//dispatch_semaphore 信号量
- (void)semTest{
    //dispatch_semaphore_create(1)： 传入值必须 >=0, 若传入为 0 则阻塞线程并等待timeout,时间到后会执行其后的语句
    //dispatch_semaphore_wait(signal, overTime)：可以理解为 lock,会使得 signal 值 -1
    //dispatch_semaphore_signal(signal)：可以理解为 unlock,会使得 signal 值 +1
    dispatch_semaphore_t signal = dispatch_semaphore_create(1); //传入值必须 >=0, 若传入为0则阻塞线程并等待timeout,时间到后会执行其后的语句
    dispatch_time_t overTime = dispatch_time(DISPATCH_TIME_NOW, 3.0f * NSEC_PER_SEC);
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 等待ing");
        dispatch_semaphore_wait(signal, overTime); //signal 值 -1
        NSLog(@"线程1");
        dispatch_semaphore_signal(signal); //signal 值 +1
        NSLog(@"线程1 发送信号");
        NSLog(@"--------------------------------------------------------");
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 等待ing");
        dispatch_semaphore_wait(signal, overTime);
        NSLog(@"线程2");
        dispatch_semaphore_signal(signal);
        NSLog(@"线程2 发送信号");
    });
}

//pthread_mutex 互斥锁
- (void)pthreadMutexTest{
    static pthread_mutex_t pLock;
    pthread_mutex_init(&pLock, NULL);
    //1.线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程1 准备上锁");
        pthread_mutex_lock(&pLock);
        sleep(1);
        NSLog(@"线程1");
        pthread_mutex_unlock(&pLock);
    });
    
    //1.线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"线程2 准备上锁");
        pthread_mutex_lock(&pLock);
        NSLog(@"线程2");
        pthread_mutex_unlock(&pLock);
    });
}

//pthread_mutex(recursive) 递归锁
- (void)pthreadRecursiveTest{
    static pthread_mutex_t pLock;
    pthread_mutexattr_t attr;
    pthread_mutexattr_init(&attr); //初始化attr并且给它赋予默认
    pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_RECURSIVE); //设置锁类型，这边是设置为递归锁
    pthread_mutex_init(&pLock, &attr);
    pthread_mutexattr_destroy(&attr); //销毁一个属性对象，在重新进行初始化之前该结构不能重新使用
    
    //1.线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value) {
            pthread_mutex_lock(&pLock);
            if (value > 0) {
                NSLog(@"value: %d", value);
                RecursiveBlock(value - 1);
            }
            pthread_mutex_unlock(&pLock);
        };
        RecursiveBlock(5);
    });
}

// NSCondition
- (void)NSConditionTest{
    
    {
    //线程等待2秒
    NSCondition *cLock = [NSCondition new];
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"start");
        [cLock lock];
        [cLock waitUntilDate:[NSDate dateWithTimeIntervalSinceNow:2]];
        NSLog(@"线程1");
        [cLock unlock];
    });
    }
    
    {
        //唤醒一个线程
        NSCondition *cLock = [NSCondition new];
        //线程1
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [cLock lock];
            NSLog(@"线程1加锁成功");
            [cLock wait];
            NSLog(@"线程1");
            [cLock unlock];
        });
        
        //线程2
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [cLock lock];
            NSLog(@"线程2加锁成功");
            [cLock wait];
            NSLog(@"线程2");
            [cLock unlock];
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(2);
            NSLog(@"唤醒一个等待的线程");
            [cLock signal];
        });
    }
    
    {
        //唤醒所有线程
        NSCondition *cLock = [NSCondition new];
        //线程1
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [cLock lock];
            NSLog(@"线程1加锁成功");
            [cLock wait];
            NSLog(@"线程1");
            [cLock unlock];
        });
        
        //线程2
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [cLock lock];
            NSLog(@"线程2加锁成功");
            [cLock wait];
            NSLog(@"线程2");
            [cLock unlock];
        });
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            sleep(2);
            NSLog(@"唤醒所有等待的线程");
            [cLock broadcast];
        });
    }
}

//NSRecursiveLock 递归锁 适合循环使用
- (void)NSRecursiveLockTest{
    NSRecursiveLock *rLock = [NSRecursiveLock new];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        static void (^RecursiveBlock)(int);
        RecursiveBlock = ^(int value) {
            [rLock lock];
            if (value > 0) {
                NSLog(@"线程%d", value);
                RecursiveBlock(value - 1);
            }
            [rLock unlock];
        };
        RecursiveBlock(4);
    });
}

//NSConditionLock 相比于 NSLock 多了个 condition 参数，我们可以理解为一个条件标示
- (void)ConditionLockTest{
    
    //NSConditionLock 还可以实现任务之间的依赖 根据后面的Condition参数值
    NSConditionLock *cLock = [[NSConditionLock alloc] initWithCondition:0];
    
    //线程1
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([cLock tryLockWhenCondition:0]){
            NSLog(@"线程1");
            [cLock unlockWithCondition:1];
        }else{
            NSLog(@"失败");
        }
    });
    
    //线程2
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:3];
        NSLog(@"线程2");
        [cLock unlockWithCondition:2];
    });
    
    //线程3
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [cLock lockWhenCondition:1];
        NSLog(@"线程3");
        [cLock unlockWithCondition:3];
    });
    
}

#pragma mark - 静态库动态库测试

- (void)libraryTest{
//    [StaticLibraryTest testPrintf]; //静态库测试
}

#pragma mark - 算法测试

- (void)algorithmTest{
    
}

#pragma mark - 多线程

- (void)threadTest{
    
}

#pragma mark - 链表

/**
 创建单个结点

 @param data 结点数据
 @return 结点指针
 */
- (struct node *)createSingleLinkListNode:(int)data id:(int)id{
    struct node *tmpNode = NULL;
    tmpNode = (struct node *)malloc(sizeof(struct node));
    if (!tmpNode) {
        NSLog(@"malloc fail!");
    }
    memset(tmpNode, 0, sizeof(struct node));
    tmpNode->data = data;
    tmpNode->id = id;
    tmpNode->next = NULL;
    return tmpNode;
}

/**
 创建链表
 
 @return head结点
 */
- (struct node *)createLinkList:(int)nodeNum{
    
    //创建链表 一起创建
//    struct node *p, *p1, *head;
//    head = p = (struct node *)malloc(sizeof(struct node));
//    p->data = Random(1, 100);
//    while (nodeNum-- != 0) {
//        p1 = p;
//        p = (struct node *)malloc(sizeof(struct node));
//        p->data = Random(1, 100);
//        p1->next = p;
//    }
//    p->next = NULL;
    
    //创建链表 单个创建
    struct node *head, *tmpNode;
    head = tmpNode = [self createSingleLinkListNode:Random(1, 100) id:nodeNum];
    while (nodeNum-- != 0) {
        tmpNode = tmpNode->next = [self createSingleLinkListNode:Random(1, 100) id:nodeNum];
    }
    return head;
}

/**
 遍历链表

 @param head 链表头结点
 */
- (void)traverseLinkList:(struct node *)head{
    struct node *p = head;
    while (p->next) {
        NSLog(@"%d %d", p->id, p->data);
        p = p->next;
    }
    NSLog(@"%d %d", p->id, p->data);
}

/**
 链表测试
 */
- (void)linkListTest{
    
    //创建链表
    struct node *head = [self createLinkList:10];
    
    //打印链表 遍历链表
    [self traverseLinkList:head];

//    //更新某个结点的值
//    [self alter:1 data:1000 head:head];
//    [self traverseLinkList:head];
    
    //在尾部增加一个结点
    [self add:&head node:[self createSingleLinkListNode:11111 id:111111]];
    [self traverseLinkList:head];
}

/**
 增 尾部插入
 */
- (void)add:(struct node **)head node:(struct node *)addNode{
    if(NULL == head){
        *head = addNode;
        addNode->next = NULL;
    }else{
        struct node *tmp = *head;
        while (tmp) {
            if (NULL == tmp->next) {
                tmp->next = addNode;
                addNode->next = NULL;
            }
            tmp = tmp->next;
        }
    }
}

/**
 删
 */
- (void)delete{
    
}

/**
 改
 */
- (void)alter:(int)id data:(int)data head:(struct node *)head{
    struct node *tmpNode = head;
    while (tmpNode) {
        if(tmpNode->id == id){
            tmpNode->data = data;
            break;
        }
        tmpNode = tmpNode->next;
    }
}

/**
 查
 */
- (void)select{
    
}

/**
 16进制中随机取6个数组成新的数字
 */
- (NSString *)composeNewNum:(NSString *)str{
    NSMutableString *tmpMuStr = [NSMutableString stringWithString:str];
    NSMutableString *newStr = [NSMutableString new];
    
    for (int i = 0; i < 6; i++) {
        int index = Random(0, [@(tmpMuStr.length) intValue]);
        NSRange tmpRange = NSMakeRange(index, 1);
        NSString *tmpStr = [tmpMuStr substringWithRange:tmpRange];
        [newStr appendString:tmpStr];
        [tmpMuStr deleteCharactersInRange:tmpRange];
    }
    
    return [newStr copy];
}


/**
 view测试
 */
- (void)testScrollView{
//    UIScrollView *tempScrollView = [UIScrollView new];
    
//    [self.view insertSubview:动画view aboveSubview:列表view];
    
    //view.text 有可能为“” 但不是nil
    UITextField *tempTextField = [[UITextField alloc] init];
    if (tempTextField.text) {
        NSLog(@"tempTextField.text：%@", tempTextField.text);
    }
}

- (void)testBranch2{
    NSLog(@"fasdfdas");
}

#pragma mark - UI布局测试

- (void)testLayoutUI{
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor redColor];
    [view1 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:view1];
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor redColor];
    [view2 setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:view2];
    
    //view1布局
    NSLayoutConstraint *view1Constraint1 = [NSLayoutConstraint constraintWithItem:view1 attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeLeft) multiplier:1.0 constant:20];
    NSLayoutConstraint *view1Constraint2 = [NSLayoutConstraint constraintWithItem:view1 attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeTop) multiplier:1.0 constant:88];
    NSLayoutConstraint *view1Constraint3 = [NSLayoutConstraint constraintWithItem:view1 attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationGreaterThanOrEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1.0 constant:200];
    NSLayoutConstraint *view1Constraint4 = [NSLayoutConstraint constraintWithItem:view1 attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationGreaterThanOrEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1.0 constant:100];
    
    //view2布局
    NSLayoutConstraint *view2Constraint1 = [NSLayoutConstraint constraintWithItem:view2 attribute:(NSLayoutAttributeLeft) relatedBy:(NSLayoutRelationEqual) toItem:self.view attribute:(NSLayoutAttributeLeft) multiplier:1.0 constant:20];
    NSLayoutConstraint *view2Constraint2 = [NSLayoutConstraint constraintWithItem:view2 attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:view1 attribute:(NSLayoutAttributeBottom) multiplier:1.0 constant:20];
    NSLayoutConstraint *view2Constraint3 = [NSLayoutConstraint constraintWithItem:view2 attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationGreaterThanOrEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1.0 constant:200];
    NSLayoutConstraint *view2Constraint4 = [NSLayoutConstraint constraintWithItem:view2 attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationGreaterThanOrEqual) toItem:nil attribute:(NSLayoutAttributeNotAnAttribute) multiplier:1.0 constant:100];
    
    //add布局
    [self.view addConstraints:@[view1Constraint1, view1Constraint2, view1Constraint3, view1Constraint4, view2Constraint1, view2Constraint2, view2Constraint3, view2Constraint4]];
}

#pragma mark - 图片颜色识别测试

static void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v )
{
    float min, max, delta;
    min = MIN( r, MIN( g, b ));
    max = MAX( r, MAX( g, b ));
    *v = max;               // v
    delta = max - min;
    if( max != 0 )
        *s = delta / max;       // s
    else {
        // r = g = b = 0        // s = 0, v is undefined
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;     // between yellow & magenta
    else if( g == max )
        *h = 2 + ( b - r ) / delta; // between cyan & yellow
    else
        *h = 4 + ( r - g ) / delta; // between magenta & cyan
    *h *= 60;               // degrees
    if( *h < 0 )
        *h += 360;
}

-(UIColor*)mostColor:(UIImage*)image{
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_6_1
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
#else
    int bitmapInfo = kCGImageAlphaPremultipliedLast;
#endif
    
    //第一步 先把图片缩小 加快计算速度. 但越小结果误差可能越大
    CGSize thumbSize=CGSizeMake(40, 40);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
    CGContextDrawImage(context, drawRect, image.CGImage);
    CGColorSpaceRelease(colorSpace);
    
    //第二步 取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    
    if (data == NULL) return nil;
    NSArray *MaxColor=nil;
    // NSCountedSet *cls=[NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    float maxScore=0;
    for (int x=0; x<thumbSize.width*thumbSize.height; x++) {
        
        int offset = 4*x;
        int red = data[offset];
        int green = data[offset+1];
        int blue = data[offset+2];
        int alpha =  data[offset+3];
        
        if (alpha<25)continue;
        
        float h,s,v;
        
        RGBtoHSV(red, green, blue, &h, &s, &v);
        
        float y = MIN(abs(red*2104+green*4130+blue*802+4096+131072)>>13, 235);
        y= (y-16)/(235-16);
        if (y>0.9) continue;
        
        float score = (s+0.1)*x;
        if (score>maxScore) {
            maxScore = score;
        }
        MaxColor=@[@(red),@(green),@(blue),@(alpha)];
        
    }
    
    CGContextRelease(context);
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f) green:([MaxColor[1] intValue]/255.0f) blue:([MaxColor[2] intValue]/255.0f) alpha:([MaxColor[3] intValue]/255.0f)];
}

/**
 图片颜色识别测试
 */
- (void)testImageColorRecognition {
    for (int i = 0; i<5; i++) {
        UIButton *btn = [UIButton new];
        btn.backgroundColor = RandomColor;
        btn.frame = CGRectMake(200, 100*(i+1), 80, 80);
        [btn addTarget:self action:@selector(testImageColorRecognitionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
}

- (void)testImageColorRecognitionBtnClick:(UIButton *)button {
    UIColor *tmpColor = [self mostColor:[UIImage drawImageWithView:button]];
    self.view.backgroundColor = tmpColor;
}

#pragma mark - runtime学习

- (void)runtimeTest{
//    FOUNDATION_EXTERN
}

NS_INLINE char test() {
    return 'a';
}

@end

















