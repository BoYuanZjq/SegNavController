
#SegNavController<br>
##编译环境<br>
Xcode 6＋<br>
##运行效果<br>
![image](https://github.com/BoYuanZjq/SegNavController/tree/master/screenshots/hot.png)<br>
![image](https://github.com/BoYuanZjq/SegNavController/tree/master/screenshots/new.png)<br>
##使用方法<br>


    PaggingViewController *page = [[PaggingViewController alloc] init];
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:2];
    
    NSArray *titles = @[@"最新", @"最热"];
    
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {
        ViewController *viewController = [[ViewController alloc] init];
        if (idx ==0) {
            viewController.view.backgroundColor = [UIColor redColor];
        }else{
            viewController.view.backgroundColor = [UIColor blueColor];
        }
        [viewControllers addObject:viewController];
    }];
    page.viewControllers = viewControllers;
    page.titles = titles;
    
    page.didChangedPageCompleted = ^(NSInteger cuurentPage) {
        NSLog(@"cuurentPage : %ld", (long)cuurentPage);
    };

##开源协议<br>
SegNavController under the Apache license. See the LICENSE file for more details.
