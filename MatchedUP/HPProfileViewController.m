//
//  HPProfileViewController.m
//  MatchedUP
//
//  Created by Phai Hoang on 9/2/14.
//  Copyright (c) 2014 HP. All rights reserved.
//

#import "HPProfileViewController.h"

@interface HPProfileViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *taglineLabel;

@end

@implementation HPProfileViewController

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
    // We pass a photo object from HomeViewController to self.photo in this ViewController
    // Get the picture File from photo object
    PFFile *pictureFile = self.photo[kCCPhotoPictureKey];
    
    // This is PFfile, so we need to download the photo
    [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        
        // download the photo and assign it to the profile picture
        self.profilePictureImageView.image = [UIImage imageWithData:data];
    }];
    
    // Get user
    PFUser *user = self.photo[kCCPhotoUserKey];
    self.locationLabel.text = user[kCCUserProfileKey][kCCUserProfileLocationKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", user[kCCUserProfileKey][kCCUserProfileAgeKey]];
    
    if (user[kCCUserProfileKey][kCCUserProfileRelationshipStatusKey] == nil) {
        self.statusLabel.text = @"Single";
    }
    else {
        self.statusLabel.text = user[kCCUserProfileKey][kCCUserProfileRelationshipStatusKey];
    }
    
    self.taglineLabel.text = user[kCCUserTagLineKey];
    
    self.title = user[kCCUserProfileKey][kCCUserProfileFirstNameKey];
    
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)likeButtonPressed:(UIButton *)sender {
    [self.delegate didPressLike];
}

- (IBAction)dislikeButtonPressed:(UIButton *)sender {
    [self.delegate didPressDislike];
}

@end
