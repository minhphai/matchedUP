//
//  HPProfileViewController.h
//  MatchedUP
//
//  Created by Phai Hoang on 9/2/14.
//  Copyright (c) 2014 HP. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HPProfileViewControllerDelegate <NSObject>

-(void)didPressLike;
-(void)didPressDislike;
@end

@interface HPProfileViewController : UIViewController

@property (weak, nonatomic) id <HPProfileViewControllerDelegate>delegate;
@property (strong, nonatomic) PFObject *photo;
@end
