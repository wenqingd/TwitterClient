//
//  TimelineVC.h
//  twitter
//
//  Created by Timothy Lee on 8/4/13.
// 
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ComposeViewController.h"

@interface TimelineVC : UITableViewController <ComposeViewControllerDelegate>

@property (nonatomic, strong) ComposeViewController *composeVC;

- (void)reload;

@end
