//
//  TimelineVC.m
//  twitter
//
//  Created by Timothy Lee on 8/4/13.
//  Copyright (c) 2013 codepath. All rights reserved.
//

#import "TimelineVC.h"
#import "TweetViewController.h"


@interface TimelineVC ()

@property (nonatomic, strong) NSMutableArray *tweets;

- (void)onSignOutButton;

@property (nonatomic, strong) UIBarButtonItem *composeButton;
@property (nonatomic, strong) UIBarButtonItem *signoutButton;

@end

@implementation TimelineVC


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Twitter";
        
        [self reload];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.signoutButton = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(onSignOutButton)];
    self.composeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(composeTweet)];
    NSArray *buttons = [[NSArray alloc] initWithObjects:self.composeButton, self.signoutButton, nil];
    self.navigationItem.rightBarButtonItems = buttons;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Create compose modal view

- (void)composeTweet{
    _composeVC = [[ComposeViewController alloc] initWithNibName:nil bundle:nil];
 //   [self.view addSubview:_composeVC.view];
    _composeVC.delegate = self;
    [self presentViewController:_composeVC animated:YES completion:nil];
    
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tweets.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];

    Tweet *tweet = self.tweets[indexPath.row];
    cell.textLabel.text = [[tweet.data objectForKey:@"user"] objectForKey:@"name"];
    cell.detailTextLabel.text = tweet.text;
    
    NSString *profileImage = [[tweet.data objectForKey:@"user"] objectForKey:@"profile_image_url_https"];
    NSLog(@"profileimage link = %@", profileImage);
    NSURL *url = [NSURL URLWithString:profileImage];
    NSData *data = [[NSData alloc]initWithContentsOfURL:url ];
    UIImage *profileImg = [[UIImage alloc]initWithData:data ];
    cell.imageView.image = profileImg;
    
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.detailTextLabel.numberOfLines = 0;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    Tweet *tweet = self.tweets[indexPath.row];
//    NSString *tweetText = tweet.text;
//    NSMutableDictionary *fontAtts = [[NSMutableDictionary alloc]init];
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UIFont *textlableFont = cell.textLabel.font;
//    [fontAtts setObject:textlableFont forKey:NSFontAttributeName];
//    
//    CGRect rect = [tweetText boundingRectWithSize:CGSizeMake(270, CGFLOAT_MAX)
//                                          options:NSStringDrawingUsesLineFragmentOrigin
//                                       attributes:fontAtts
//                                          context:nil];
//    NSLog(@"%f",rect.size.height);
    
    
    return 120;
    
}




// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TweetViewController *singleTweetVC = [[TweetViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:singleTweetVC animated:YES];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

#pragma mark - Private methods

- (void)onSignOutButton {
    [User setCurrentUser:nil];
}

- (void)reload {
    [[TwitterClient instance] homeTimelineWithCount:20 sinceId:0 maxId:0 success:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"%@", response);
        self.tweets = [Tweet tweetsWithArray:response];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        // Do nothing
    }];
}


-(void)updateTable {
    [self reload];
}
@end
