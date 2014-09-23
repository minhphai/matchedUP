//
//  HPMatchViewController.h
//  MatchedUP
//
//  Created by Phai Hoang on 9/10/14.
//  Copyright (c) 2014 HP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HPMatchViewControllerDelegate <NSObject>

- (void)presentMatchesViewController;

@end

@interface HPMatchViewController : UIViewController
@property (weak)id <HPMatchViewControllerDelegate>delegate;

@property (strong, nonatomic) IBOutlet UIImageView *matchedUserImageView;
@property (strong, nonatomic) IBOutlet UIImageView *currentUserImageView;
@property (strong, nonatomic) IBOutlet UIButton *viewChats;
@property (strong, nonatomic) IBOutlet UIButton *keepSearching;


@property (strong, nonatomic) UIImage *matchedUserImage;
@end
