//
//  DDZUrlViewController.h
//  DDZUrl
//
//  Created by liujw on 13-3-28.
//  Copyright 2011年 flhs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDZUrlViewController : UIViewController<UITextFieldDelegate> {
    UISwitch *switchTestVersion;
    UITextField* textGameVerion;
    UITextField* textGamePublicVerion;
    UITextField* textIPAdress;
    UISwitch *switchReplayMode;    
}

-(void)showDialog:(NSString *) str;

-(void)updateView;

-(NSString*)string:(NSString*)str append:(NSString*)delim;

@end
