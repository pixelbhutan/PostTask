//
//  MainViewController.m
//  PostTask
//
//  Created by GK Reddy on 3/13/14.
//  Copyright (c) 2014 gkSolutions. All rights reserved.
//

#import "MainViewController.h"
#import "WebServiceMethods.h"

@interface MainViewController ()

@end

@implementation MainViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 320, 44)];
    bgImageView.image = [UIImage imageNamed: @"nab_bar.png"];
    
    [self.view addSubview:bgImageView];
    
    global_dicationary = [[NSMutableDictionary alloc] init];
    
    UITextField *textField1= [[UITextField alloc]initWithFrame:
                              CGRectMake(10, 85, 280, 30)];
    textField1.delegate = self;
    textField1.font =[UIFont systemFontOfSize:16];
    textField1.tag = 3001;
    textField1.borderStyle = UITextBorderStyleRoundedRect;
    textField1.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField1.placeholder = @"Enter Message here";
    [self.view addSubview:textField1];
    
    UITextField *textField2 = [[UITextField alloc]initWithFrame:
                               CGRectMake(10, 125, 280, 30)];
    textField2.delegate = self;
    textField2.font =[UIFont systemFontOfSize:16];
    textField2.tag = 3002;
    textField2.borderStyle = UITextBorderStyleRoundedRect;
    //textField2.keyboardType = UIKeyboardTypeASCIICapable;
    textField2.clearButtonMode=UITextFieldViewModeWhileEditing;
    textField2.placeholder = @"Enter your mail-id";
    [self.view addSubview:textField2];
    
    button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(10, 165, 230, 30)];
    button.tag = 3003;
    [button setTitle:@"Select Date" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(datePickerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *postButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [postButton setFrame:CGRectMake(70, 215, 100, 40)];
    postButton.tag = 3004;
    [postButton setBackgroundImage:[UIImage imageNamed:@"contact_book_this_trip_button.png"] forState:UIControlStateNormal];
    [postButton setTitle:@"Submit" forState:UIControlStateNormal];
    [postButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    postButton.userInteractionEnabled = YES;
    [self.view addSubview:postButton];
    
    //Creation of Date picker
    
    datePickerBGView = [[UIView alloc] initWithFrame:CGRectMake(0.0, [[UIScreen mainScreen] bounds].size.height- 256, self.view.frame.size.width, 256)];
    datePickerBGView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:datePickerBGView];
    
    dobPicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0.0, 40.0, self.view.frame.size.width, 216)];
    dobPicker.datePickerMode = UIDatePickerModeDate;
    dobPicker.tag = 1;
    dobPicker.minimumDate = [NSDate date];
    [datePickerBGView addSubview:dobPicker];
    
    UIToolbar* toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0.0, 320.0, 40)];
    NSMutableArray *btnsarray = [[NSMutableArray alloc] init];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(action_method:)];
    doneBtn.tag = 1;
    
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(action_method:)];
    cancelBtn.tag = 2;
    
    UIBarButtonItem *alertFlexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [btnsarray addObject:cancelBtn];
    [btnsarray addObject:alertFlexibleSpaceItem];
    [btnsarray addObject:doneBtn];
    
    [toolbar setItems:btnsarray animated:YES];
    [datePickerBGView addSubview:toolbar];
    
    datePickerBGView.hidden = YES;
    
    

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    navBar = self.navigationController.navigationBar;
    //UIImage *image = [UIImage imageNamed:@"nab_bar.png"];
    UIImage *image = [UIImage imageNamed:@"navigationBackground-7.png"];
    [navBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
}




-(void)action_method:(UIBarButtonItem *)sender
{
    
    
	if(sender.tag == 1) {//Done Action
        
        //[yearDetailDictionary setValue:@"August 1, 2011" forKey:@"startDate"]
        NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
        [dateformater setDateFormat:@"dd-MMM-yyyy"];
        [button setTitle:[dateformater stringFromDate:[dobPicker date]] forState:UIControlStateNormal];
        
        [global_dicationary setObject:[dateformater stringFromDate:[dobPicker date]] forKey:@"date"];
	}
	else {//Cancel Action
        
	}
    
    datePickerBGView.hidden = YES;
}

-(void)datePickerButtonClicked
{
    [tempTf resignFirstResponder];
    datePickerBGView.hidden = NO;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    tempTf = textField;

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    datePickerBGView.hidden = YES;

    
    [textField resignFirstResponder];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    NSString *tempStr = [textField.text stringByReplacingCharactersInRange:range withString:string];

    if(textField.tag == 3001)
        [global_dicationary setObject: tempStr forKey: @"message"];

    if(textField.tag == 3002)
        [global_dicationary setObject: tempStr forKey: @"mail-id"];
     

    return YES;
}
//NSString *urlString = [NSString stringWithFormat:@“doomain_url”];


-(void)submitButtonClicked
{
    NSString *urlString = [NSString stringWithFormat:@"http://google.com"];
    
    WebServiceMethods *wsMethodsDetails = [[WebServiceMethods alloc] init];
    wsMethodsDetails.target = self;
    wsMethodsDetails.action = @selector(getRefugeDataResponse:);

    [wsMethodsDetails formPostRequestAndGetResponseData:urlString withDetailsDictionary:global_dicationary];

}
-(void)getRefugeDataResponse:(id)sender
{
    
}





@end
