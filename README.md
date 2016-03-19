
导航条上的选项卡，扩展性好


#SegNavController<br>
##编译环境<br>
Xcode 6＋<br>
##运行效果<br>
![image](https://github.com/BoYuanZjq/SegNavController/tree/master/screenshots/hot.png)<br>
![image](https://github.com/BoYuanZjq/SegNavController/tree/master/screenshots/new.png)<br>
##使用方法<br>
PaggingViewController *page = [[PaggingViewController alloc] init];<br>
    
    NSMutableArray *viewControllers = [[NSMutableArray alloc] initWithCapacity:2];<br>
    
    NSArray *titles = @[@"最新", @"最热"];<br>
    
    [titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL *stop) {<br>
        ViewController *viewController = [[ViewController alloc] init];<br>
        if (idx ==0) {<br>
            viewController.view.backgroundColor = [UIColor redColor];<br>
        }else{<br>
            viewController.view.backgroundColor = [UIColor blueColor];<br>
        }<br>
        [viewControllers addObject:viewController];<br>
    }];<br>
    page.viewControllers = viewControllers;<br>
    page.titles = titles;<br>
    
    page.didChangedPageCompleted = ^(NSInteger cuurentPage) {<br>
        NSLog(@"cuurentPage : %ld", (long)cuurentPage);<br>
    };<br>

##开源协议<br>
Teameeting iOS app is under the Apache license. See the LICENSE file for more details.
