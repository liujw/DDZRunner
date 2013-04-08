//
//  DDZUrlViewController.m
//  DDZUrl
//
//  Created by liujw on 13-3-28.
//  Copyright 2011年 flhs. All rights reserved.
//

#import "DDZUrlViewController.h"

BOOL g_isIPADType = FALSE;
BOOL g_isHDType = FALSE;

//当前屏幕是否为竖屏
BOOL g_isVertical = FALSE;

@implementation DDZUrlViewController

#pragma mark - View lifecycle

static bool isIPADDevice(){
    return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
}

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen  mainScreen].applicationFrame] ;
    self.view = view;
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    [self updateView];
    [view release];
}

-(void)updateView
{
    bool isIPAD = isIPADDevice();
    bool isPortrait = g_isVertical;
    CGSize sizebounds = self.view.bounds.size;
    
    int nWidth = isPortrait ? sizebounds.width : sizebounds.height;
    int nHeight = isPortrait ? sizebounds.height : sizebounds.width;
    
    int nBarHeight = isIPAD ? 40 : 30;
    CGRect barRect = CGRectMake(0, 0, nWidth, nBarHeight);
    
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:barRect];
    
    //创建一个导航栏集合
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:nil];
    
    //创建一个关闭按钮
    UIBarButtonItem *normalDDZButton = [[UIBarButtonItem alloc] initWithTitle:@"正常启动斗地主"
                                                                        style:UIBarButtonItemStyleDone
                                                                       target:self
                                                                       action:@selector(normalDDZButtonClicked)];
    //设置导航栏内容
    [navigationItem setTitle:@"斗地主测试工具"];
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    
    [navigationItem setRightBarButtonItem:normalDDZButton];
    
    //把导航栏添加到视图中
    [self.view addSubview:navigationBar];
    
    float offset = 35.0;
    CGRect rectLabel = CGRectMake(30, 40, 120, 30);
    if(isIPAD)
    {
        rectLabel = CGRectMake(120, 80, 240, 45);
        offset = 60.0;
    }
    
    
    UILabel *labelSetTestVersion = [[UILabel alloc]initWithFrame:rectLabel];
    rectLabel.origin.y += offset;
    UILabel *labelGameVerion = [[UILabel alloc]initWithFrame:rectLabel];
    rectLabel.origin.y += offset;
    UILabel *labelGamePublicVerion = [[UILabel alloc]initWithFrame:rectLabel];
    rectLabel.origin.y += offset;
    UILabel *labelIPAdderss = [[UILabel alloc]initWithFrame:rectLabel];
    rectLabel.origin.y += 1.5*offset;
    UILabel *labelRecordVersion = [[UILabel alloc]initWithFrame:rectLabel];
    
    if(isIPAD)
    {
        UIFont* font = [UIFont fontWithName:@"Arial" size:30];
        labelSetTestVersion.font = font;
        labelSetTestVersion.font = font;
        labelGameVerion.font = font;
        labelGamePublicVerion.font = font;
        labelIPAdderss.font = font;
        labelRecordVersion.font = font;
    }
    
    //设置显示文字
    labelSetTestVersion.text = @"测试模式:";
    labelGameVerion.text = @"游戏版本:";
    labelGamePublicVerion.text = @"显示版本:";
    labelIPAdderss.text = @"测试服务器:";
    labelRecordVersion.text = @"回放模式:";
    
    //设置label的背景色，这里设置为透明色。
    labelSetTestVersion.backgroundColor = [UIColor clearColor];
    labelGameVerion.backgroundColor = [UIColor clearColor];
    labelGamePublicVerion.backgroundColor = [UIColor clearColor];
    labelIPAdderss.backgroundColor = [UIColor clearColor];
    labelRecordVersion.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:labelSetTestVersion];
    [self.view addSubview:labelGameVerion];
    [self.view addSubview:labelGamePublicVerion];
    [self.view addSubview:labelIPAdderss];
    [self.view addSubview:labelRecordVersion];
    
    CGRect rectContext = CGRectMake(135, 40, 150, 30);
    if(isIPAD)
    {
        rectContext = CGRectMake(300, 85, 300, 45);
    }
    
    CGRect rectSwitch;
    rectSwitch.origin = rectContext.origin;
    rectSwitch.origin.x += (rectContext.size.width - 20)/2;
    switchTestVersion = [[UISwitch alloc] initWithFrame:rectSwitch];
    [switchTestVersion setOn:NO];
    [switchTestVersion addTarget:self action:@selector(testVersionSwitchClicked) forControlEvents:UIControlEventValueChanged];
    
    rectContext.origin.y += offset;
    textGameVerion = [[UITextField alloc] initWithFrame:rectContext];
    [textGameVerion setBorderStyle:UITextBorderStyleRoundedRect];
    textGameVerion.delegate = self;
    
    rectContext.origin.y += offset;
    textGamePublicVerion = [[UITextField alloc] initWithFrame:rectContext];
    [textGamePublicVerion setBorderStyle:UITextBorderStyleRoundedRect];
    textGamePublicVerion.delegate = self;
    
    rectContext.origin.y += offset;
    textIPAdress = [[UITextField alloc] initWithFrame:rectContext];
    [textIPAdress setBorderStyle:UITextBorderStyleRoundedRect];
    textIPAdress.delegate = self;
    
    rectContext.origin.y += 1.5*offset;
    
    rectSwitch.origin = rectContext.origin;
    rectSwitch.origin.x += (rectContext.size.width -20)/2;
    switchReplayMode = [[UISwitch alloc] initWithFrame:rectSwitch];
    [switchReplayMode setOn:NO];
    [switchReplayMode addTarget:self action:@selector(replayModeSwitchClicked) forControlEvents:UIControlEventValueChanged];
    
    int nLastPosY = rectContext.origin.y + rectContext.size.height;
    
    if(isIPAD)
    {
        UIFont* font = [UIFont fontWithName:@"Arial" size:30];
        textGameVerion.font = font;
        textGamePublicVerion.font = font;
        textIPAdress.font = font;
    }
    
    [self.view addSubview:switchTestVersion];
    [self.view addSubview:textGameVerion];
    [self.view addSubview:textGamePublicVerion];
    [self.view addSubview:textIPAdress];
    [self.view addSubview:switchReplayMode];
    
    //创建按钮
    UIButton *testDDZButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    const int nBtnWidth = 200,nBtnHeight = isIPAD ? 40 :30;
    int nBtnPosX = (nWidth - nBtnWidth)/2;
    int nBtnPosY = (nHeight + nLastPosY - nBtnHeight)/2;
    CGRect ddzBtnRect = CGRectMake(nBtnPosX, nBtnPosY, nBtnWidth, nBtnHeight);

    [testDDZButton setFrame:ddzBtnRect];
    [testDDZButton setTitle:@"测试启动斗地主" forState:UIControlStateNormal];
    [testDDZButton.titleLabel setFont:[UIFont boldSystemFontOfSize:20]];
    [testDDZButton setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
    [testDDZButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,0)];
    //添加点击按钮所执行的程式
    [testDDZButton addTarget:self action:@selector(testDDZButtonClicked)forControlEvents:UIControlEventTouchUpInside];
    
    //在 View 中加入按钮
    [self.view addSubview:testDDZButton];
   
    //释放对象
    [navigationItem release];
    [normalDDZButton release];
    [testDDZButton release];
    
    [labelSetTestVersion release];
    [labelGameVerion release];
    [labelGamePublicVerion release];
    [labelIPAdderss release];
    [labelRecordVersion release];
}

//textField要实现的Delegate方法,关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//保证测试模式和回放模式互斥
-(void)testVersionSwitchClicked
{
    BOOL isEnable = !switchTestVersion.isOn;
    switchReplayMode.enabled = isEnable;
}

-(void)replayModeSwitchClicked
{
    BOOL isEnable = !switchReplayMode.isOn;
    switchTestVersion.enabled = isEnable;
    textGameVerion.enabled = isEnable;
    textGamePublicVerion.enabled = isEnable;
    textIPAdress.enabled = isEnable;
}

-(void)normalDDZButtonClicked
{
    NSString * param = @"-I&-V&-S";
    NSString * urlString = [NSString stringWithFormat:@"volcano.ddz.com.ios.TestVersion://com.basecity.ddzHD/?%@",
							[param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL* myUrl = [NSURL URLWithString:urlString];

    [[UIApplication sharedApplication] openURL:myUrl];
}

-(NSString*) string:(NSString*)str append:(NSString*)appendString
{
    str = [str stringByAppendingString:appendString];
    return str;
}

-(void)testDDZButtonClicked
{
    NSString * param = [[NSString alloc]init];  //@"-I&-i&-V&-v4.45&-p4.5.0"
    //回放模式
    if(switchReplayMode.isOn)  {
        param = [self string:param append:@"-R"];
    }
    else  {
        //TestVersion设置
        param = [self string:param append:@"-I"];
        if(switchTestVersion.isOn)
        {
            param = [self string:param append:@"&-i"];
        }
        
        NSString* ipAdress = textIPAdress.text;
        
        //测试服务器地址设置
        param = [self string:param append:@"&-S"];
        if(ipAdress && ![ipAdress isEqualToString:@""])
        {
            param = [self string:param append:@"&-s"];
            param = [self string:param append:textIPAdress.text];
        }

        NSString* gameVerion = textGameVerion.text;
        NSString* gamePublicVerion = textGamePublicVerion.text;
        
        //版本设置
        param = [self string:param append:@"&-V"];
        if(gameVerion || gamePublicVerion)
        {
            if(![gameVerion isEqualToString:@""])
            {
                param = [self string:param append:@"&-v"];
                param = [self string:param append:gameVerion];
            }
            if(![gamePublicVerion isEqualToString:@""])
            {
                param = [self string:param append:@"&-p"];
                param = [self string:param append:gamePublicVerion];
            }
        }
    }
    
    NSLog(@"param = %@",param);
    
    NSString * urlString = [NSString stringWithFormat:@"volcano.ddz.com.ios.TestVersion://com.basecity.ddzHD/?%@",
							[param stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSURL* myUrl = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:myUrl];
}

-(void)showDialog:(NSString *) str
{
     UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"这是一个对话框" message:str delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
   
    [alert show];      
    [alert release];
}

//旋转支持
//for ios 4 and 5
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    //return TRUE;
    //return UIInterfaceOrientationIsPortrait(interfaceOrientation) || UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

//for ios 6
// 支持的旋转方向
-(NSUInteger)supportedInterfaceOrientations{
    //return (1 << UIInterfaceOrientationPortrait) | (1 << UIInterfaceOrientationLandscapeLeft)|(1 << UIInterfaceOrientationLandscapeRight);
    return (1 << UIInterfaceOrientationLandscapeLeft)|(1 << UIInterfaceOrientationLandscapeRight);
}

- (BOOL)shouldAutorotate{
    return YES;
}

// 一开始的屏幕旋转方向 
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    if(g_isVertical)
        return UIInterfaceOrientationPortrait;
    else
        return UIInterfaceOrientationLandscapeRight;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    if(UIInterfaceOrientationIsPortrait(toInterfaceOrientation) != g_isVertical)
    {
        g_isVertical = !g_isVertical;
        UIView *view = [[UIView alloc] initWithFrame:[UIScreen  mainScreen].applicationFrame] ;
        //[self.view removeFromSuperview];
        //[self.view setNeedsDisplay];
        self.view = view;        
        [view release];
        [self updateView];
    }
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc {
    [switchReplayMode release];
    [switchTestVersion  release];
    [textGameVerion  release];
    [textGamePublicVerion  release];
    [textIPAdress release];
    
    [super dealloc];
}

@end
