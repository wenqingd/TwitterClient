//
//  ComposeViewController.h
//  twitter
//
//  Created by Wenqing Dai on 8/17/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ComposeViewControllerDelegate <NSObject>

-(void) updateTable;

@end

@interface ComposeViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, strong) id <ComposeViewControllerDelegate> delegate;

@end
