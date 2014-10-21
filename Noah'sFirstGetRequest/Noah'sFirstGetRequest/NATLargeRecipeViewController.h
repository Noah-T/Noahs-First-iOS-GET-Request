//
//  NATLargeRecipeViewController.h
//  Breakfast Superfoods
//
//  Created by Noah Teshu on 9/19/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@class Recipe;


@interface NATLargeRecipeViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *recipeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;

@property (nonatomic, strong) NSString *recipeLabeltext;

@property (nonatomic, strong) UIImage *recipeImageImage;
@property (nonatomic, strong) Recipe *recipe;

//- (IBAction)postToTwitter:(id)sender;
//- (IBAction)postToFacebook:(id)sender;
//- (IBAction)sendEmail:(id)sender;

@end
