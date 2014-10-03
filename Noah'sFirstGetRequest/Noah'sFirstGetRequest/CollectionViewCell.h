//
//  CollectionViewCell.h
//  Noah'sFirstGetRequest
//
//  Created by Noah Teshu on 10/3/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *recipeImage;
@property (weak, nonatomic) IBOutlet UILabel *recipeLabel;


@end
