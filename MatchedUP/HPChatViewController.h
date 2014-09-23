//
//  HPChatViewController.h
//  MatchedUP
//
//  Created by Phai Hoang on 9/11/14.
//  Copyright (c) 2014 HP. All rights reserved.
//

#import "JSMessagesViewController.h"

@interface HPChatViewController : JSMessagesViewController<JSMessagesViewDataSource, JSMessagesViewDelegate>
@property (strong, nonatomic) PFObject *chatRoom;
@end
