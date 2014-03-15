//
//  MainViewController.h
//  PostTask
//
//  Created by GK Reddy on 3/13/14.
//  Copyright (c) 2014 gkSolutions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<UITextFieldDelegate>
{
    UIButton *button;
    UIDatePicker *dobPicker;
    UIView *datePickerBGView;
    NSMutableDictionary *global_dicationary;
    UITextField *tempTf;
    UINavigationBar *navBar;
    
}


@property(nonatomic, assign) id delegate;


@end
