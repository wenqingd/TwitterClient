//
//  ComposeViewController.m
//  twitter
//
//  Created by Wenqing Dai on 8/17/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "ComposeViewController.h"
#import "TimelineVC.h"

@interface ComposeViewController ()

@property (nonatomic, strong) UINavigationBar *navbarComposeTweet;
@property (nonatomic, strong) UIBarButtonItem *doneButton;
@property (nonatomic, strong) UIBarButtonItem *cancelButton;
@property (nonatomic, strong) UITextView *textField;

@end

@implementation ComposeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.navbarComposeTweet = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    UINavigationItem *navItem = [[UINavigationItem alloc] init];
 //   self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissComposeView)];
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Tweet" style:UIBarButtonItemStylePlain target:self action:@selector(publishTweet)];
//    self.doneButton.enabled = NO;
    navItem.rightBarButtonItem = self.doneButton;
    self.cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissComposeView)];
    navItem.leftBarButtonItem = self.cancelButton;
    NSArray *tmp = @[navItem];
    self.navbarComposeTweet.items = tmp;
    [self.view addSubview:self.navbarComposeTweet];
    //add textfield
    self.textField = [[UITextView alloc] initWithFrame:CGRectMake(10, 70, self.view.frame.size.width-20, 100)];
  //  self.textField.bounces =YES;
 //   self.textField.borderStyle = UITextBorderStyleRoundedRect;
    [self.textField setText:@"What's happening?"];
    [self.textField setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
    [self.textField setTextColor:[UIColor lightGrayColor]];

    [self.view addSubview:self.textField];
    self.textField.delegate = self;
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyBoard)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];

}

-(void)dismissKeyBoard{
    if(self.textField.isFirstResponder){
        [self.textField resignFirstResponder];
        if ([self.textField.text length]==0) {
            [self.textField setText:@"What's happening?"];
            [self.textField setFont:[UIFont fontWithName:@"HelveticaNeue" size:11]];
            [self.textField setTextColor:[UIColor lightGrayColor]];
        }
    }
    
}



-(void)dismissComposeView{
   
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)publishTweet{

    [[TwitterClient instance] postTweetWithText:self.textField.text success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        if ([_delegate respondsToSelector:@selector(updateTable)]) {
            [_delegate updateTable];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    NSString *textFieldText = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([textFieldText length] > 140)
    {
        return NO;
    }
    return YES;
    
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
 //   self.doneButton.enabled = YES;
    textView.text = @"";
    return YES;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
