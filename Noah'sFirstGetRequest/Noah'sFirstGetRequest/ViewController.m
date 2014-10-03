//
//  ViewController.m
//  Noah'sFirstGetRequest
//
//  Created by Noah Teshu on 9/30/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "ViewController.h"
#import "Recipe.h"
#import "CollectionViewCell.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *recipeList;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSURL *yumlyGetURL = [NSURL URLWithString:@"http://api.yummly.com/v1/api/recipes?_app_id=6e25394a&_app_key=7f3fb96de81493ba0a9418119a678901&q=kale"];
    NSError *error;
    NSData *jsonData = [NSData dataWithContentsOfURL:yumlyGetURL];
    
    NSDictionary *recipeDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    //NSLog(@"%@", recipeDictionary);
    NSDictionary *matchesList = [recipeDictionary objectForKey:@"matches"];
    //NSLog(@"These are the matches: \n%@", matchesList);
    
    
    


   
    
    self.recipeList = [NSMutableArray array];
    for (NSDictionary *recipeDictionary in matchesList) {
        Recipe *recipe = [[Recipe alloc]init];
        recipe.recipeImageURL = [[recipeDictionary objectForKey:@"imageUrlsBySize"]valueForKey:@"90"];
        recipe.recipeName = [recipeDictionary objectForKey:@"recipeName"];
        [self.recipeList addObject:recipe];
    }

    ;}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.recipeList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    Recipe *recipe = [self.recipeList objectAtIndex:indexPath.row];
    
    cell.recipeLabel.text = recipe.recipeName;

    NSData * imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:recipe.recipeImageURL ]];
    cell.recipeImage.image = [UIImage imageWithData:imageData];
    return cell;
}




@end
