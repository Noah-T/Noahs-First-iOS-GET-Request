//
//  Recipe.h
//  Noah'sFirstGetRequest
//
//  Created by Noah Teshu on 9/30/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Recipe : NSObject
@property (strong, nonatomic) NSString *recipeImageURL;
@property (strong, nonatomic) NSString *recipeName;
@property (strong, nonatomic) NSString *recipeId;
@property (strong, nonatomic) NSData *recipeImageData;
@property (strong, nonatomic) UIImage *recipeImage;

@end
