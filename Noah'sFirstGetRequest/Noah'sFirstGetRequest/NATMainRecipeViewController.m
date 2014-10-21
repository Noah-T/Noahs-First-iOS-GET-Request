//
//  ViewController.m
//  Noah'sFirstGetRequest
//
//  Created by Noah Teshu on 9/30/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "NATMainRecipeViewController.h"
#import "Recipe.h"
#import "CollectionViewCell.h"
#import "NATLargeRecipeViewController.h"

@interface NATMainRecipeViewController ()
@property (strong, nonatomic) NSMutableArray *recipeList;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *searchTermArray;
- (IBAction)optionsButtonPressed:(id)sender;

@end

@implementation NATMainRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self searchWithIngredient:@"kale"];
    [self searchWithIngredient:@"avocado"];
    [self searchWithIngredient:@"eggs"];
    [self searchWithIngredient:@"berries"];
    [self searchWithIngredient:@"oatmeal"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //note for work tomorrow:
    //make the search process into a method
    //it should take the search ingredient as a parameter
    //it should add the results to the shared recipe list at the end
    //must be done using some async calls, so items can be loaded as they come in
    
}



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
    dispatch_async(dispatch_get_main_queue(), ^{
        
        cell.recipeImage.image = recipe.recipeImage;
    });
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier  isEqualToString:@"LargeRecipeView"]) {
        NSLog(@"button pressed");
        NSArray *indexPaths = [self.collectionView indexPathsForSelectedItems];
        NATLargeRecipeViewController *destinationViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [indexPaths objectAtIndex:0]; //the first selected item
        
        Recipe *recipe = self.recipeList[indexPath.row] ;
        destinationViewController.recipe = recipe;
        destinationViewController.recipeLabeltext = recipe.recipeName;
        NSData * imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:recipe.recipeImageURL ]];
        destinationViewController.recipeImageImage = [UIImage imageWithData:imageData];
    }
    
}

-(void)searchWithIngredient:(NSString *)searchIngredient
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *yumlyGetURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.yummly.com/v1/api/recipes?_app_id=6e25394a&_app_key=7f3fb96de81493ba0a9418119a678901&q=%@&requirePictures=true", searchIngredient]];
        
        NSError *error;
        NSData *jsonData = [NSData dataWithContentsOfURL:yumlyGetURL];
        
        
        NSDictionary *recipeDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        
        
        
        //NSLog(@"%@", recipeDictionary);
        NSDictionary *matchesList = [recipeDictionary objectForKey:@"matches"];
        //NSLog(@"These are the matches: \n%@", matchesList);
        
        if (!self.recipeList) {
            self.recipeList = [NSMutableArray array];
        }
        
        for (NSDictionary *recipeDictionary in matchesList) {
            Recipe *recipe = [[Recipe alloc]init];
            
            recipe.recipeName = [recipeDictionary objectForKey:@"recipeName"];
            recipe.recipeId = [recipeDictionary objectForKey:@"id"];
            
            
            recipe.recipeImageURL = [[recipeDictionary objectForKey:@"imageUrlsBySize"]valueForKey:@"90"];
            recipe.recipeImageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:recipe.recipeImageURL ]];
            recipe.recipeImage = [UIImage imageWithData:recipe.recipeImageData];
            
            
            [self.recipeList addObject:recipe];
        };
        [self.collectionView reloadData];
        
        
    });
    
    
    
    
}





- (IBAction)optionsButtonPressed:(id)sender {
   
    
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(100, 250, 300, 200)];
    backgroundView.backgroundColor = [UIColor yellowColor];
    
    
    NSLayoutConstraint *centering = [NSLayoutConstraint constraintWithItem:backgroundView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:backgroundView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:200];
    
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:backgroundView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:300];
    [backgroundView addConstraint:height];
    [backgroundView addConstraint:width];
    
    
    CGRect buttonFrame = CGRectMake(100, 300, 250, 44);
    UIButton *kaleButton = [[UIButton alloc]initWithFrame:buttonFrame];
    [kaleButton setTitle:@"Kale" forState:UIControlStateNormal];
    
    UIButton *oatmealButton = [[UIButton alloc]initWithFrame:buttonFrame];
    [oatmealButton setTitle:@"Oatmeal" forState:UIControlStateNormal];
    [self.view addSubview:backgroundView];
    [self.view addConstraint:centering];
    [self.view addSubview:kaleButton];
    [self.view addSubview:oatmealButton];

}

@end
