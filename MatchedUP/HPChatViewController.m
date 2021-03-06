//
//  HPChatViewController.m
//  MatchedUP
//
//  Created by Phai Hoang on 9/11/14.
//  Copyright (c) 2014 HP. All rights reserved.
//

#import "HPChatViewController.h"


@interface HPChatViewController ()
@property (strong, nonatomic) PFUser *withUser;

@property (strong, nonatomic) PFUser *currentUser;

@property (strong, nonatomic) NSTimer *chatsTimer;

@property (nonatomic) BOOL initialLoadComplete;

@property (strong, nonatomic) NSMutableArray *chats;

@end

@implementation HPChatViewController

-(NSMutableArray *)chats

{
    
    if (!_chats){
        
        _chats = [[NSMutableArray alloc] init];
        
    }
    
    return _chats;
    
}
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
    // Do any additional setup after loading the view.
    self.delegate = self;
    self.dataSource = self;
    
    [[JSBubbleView appearance] setFont:[UIFont systemFontOfSize:16.0f]];
    self.messageInputView.textView.placeHolder = @"New Message";
    [self setBackgroundColor:[UIColor whiteColor]];
    
    self.currentUser = [PFUser currentUser];
    
    PFUser *testUser1 = self.chatRoom[kCCChatRoomUser1Key];
    if ([testUser1.objectId isEqual:self.currentUser.objectId]) {
        self.withUser = self.chatRoom[kCCChatRoomUser2Key];
    }
    else self.withUser = self.chatRoom[kCCChatRoomUser1Key];
    
    self.title = self.withUser[kCCUserProfileKey][kCCUserProfileFirstNameKey];
    
    self.initialLoadComplete = NO;
    
    // Set the time the system fetch new message i.e, send request to Parse
    self.chatsTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(checkForNewChats) userInfo:nil repeats:YES];
    
    
}

-(void)viewDidDisappear:(BOOL)animated

{
    
    [self.chatsTimer invalidate];
    
    self.chatsTimer = nil;
    
}

#pragma mark - tableview datasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chats.count;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSendText:(NSString *)text

{
    
    if (text.length != 0) {
       
        PFObject *chat = [PFObject objectWithClassName:kCCChatClassKey];
        
        [chat setObject:self.chatRoom forKey:kCCChatChatroomKey];
        
        [chat setObject:[PFUser currentUser] forKey:kCCChatFromUserKey];
        
        [chat setObject:self.withUser forKey:kCCChatToUserKey];
        
        [chat setObject:text forKey:kCCChatTextKey];
        
        [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            NSLog(@"save complete");
            
            [self.chats addObject:chat];
            
            [JSMessageSoundEffect playMessageSentSound];
            
            [self.tableView reloadData];
            
            [self finishSend];
            
            [self scrollToBottomAnimated:YES];
            
        }];
        
    }
    
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    /* If we are doing the sending return JSBubbleMessageTypeOutgoing
     
     else JSBubbleMessageTypeIncoming
     
     */
    
    PFObject *chat = self.chats[indexPath.row];
    
    PFUser *currentUser = [PFUser currentUser];
    
    PFUser *testFromUser = chat[kCCChatFromUserKey];
    
    if ([testFromUser.objectId isEqual:currentUser.objectId])
        
    {
        
        return JSBubbleMessageTypeOutgoing;
        
        ;
        
    }
    
    else{
        
        return JSBubbleMessageTypeIncoming;
        
    }
    
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type

                       forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    PFObject *chat = self.chats[indexPath.row];
    
    PFUser *currentUser = [PFUser currentUser];
    
    PFUser *testFromUser = chat[kCCChatFromUserKey];
    
    if ([testFromUser.objectId isEqual:currentUser.objectId])
        
    {
        
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                
                                                          color:[UIColor js_bubbleGreenColor]];
        
    }
    
    else{
        
        return [JSBubbleImageViewFactory bubbleImageViewForType:type
                
                                                          color:[UIColor js_bubbleLightGrayColor]];
        
    }
    
}



- (JSMessagesViewTimestampPolicy)timestampPolicy

{
    
    return JSMessagesViewTimestampPolicyAll
    
    ;
    
}

- (JSMessagesViewAvatarPolicy)avatarPolicy

{
    
    /* JSMessagesViewAvatarPolicyNone */
    
    return JSMessagesViewAvatarPolicyAll;
    
}

- (JSMessagesViewSubtitlePolicy)subtitlePolicy

{
    
    return JSMessagesViewSubtitlePolicyAll;
    
}



- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath

{
    
    if([cell messageType] == JSBubbleMessageTypeOutgoing) {
        
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
        
    }
    
}
- (BOOL)shouldPreventScrollToBottomWhileUserScrolling

{
    
    return YES;
    
}



#pragma mark - Messages view data source: REQUIRED

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    PFObject *chat = self.chats[indexPath.row];
    
    NSString *message = chat[kCCChatTextKey];
    
    return message;
    
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return nil;
    
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return nil;
    
}

- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    return nil;
    
}

#pragma mark - Helper methods

-(void)checkForNewChats
{
    int oldChatCount = [self.chats count];
    
    PFQuery *queryForChat = [PFQuery queryWithClassName:kCCChatClassKey];
    
    [queryForChat whereKey:kCCChatChatroomKey equalTo:self.chatRoom];
    
    [queryForChat orderByAscending:@"createdAt"];
    
    [queryForChat findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            if (self.initialLoadComplete == NO || oldChatCount != [objects count] ) {
                self.chats = [objects mutableCopy];
                
                [self.tableView reloadData];
                
                if (self.initialLoadComplete == YES) {
                    [JSMessageSoundEffect playMessageReceivedSound];
                }
                self.initialLoadComplete = YES;
                [self scrollToBottomAnimated:YES];
            }
        }
        
        
    }];
    
    
    
}






@end
