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
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) NSArray *buttonArray;

@end

@implementation NATMainRecipeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self searchWithIngredient:@"kale"];
    //[self searchWithIngredient:@"avocado"];
    //[self searchWithIngredient:@"eggs"];
    //[self searchWithIngredient:@"berries"];
    //[self searchWithIngredient:@"oatmeal"];
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
        NSDictionary *matchesList = [recipeDictionary objectForKey:@"matches"];

        
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
    
    
    //creation of background view for popover menu
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(100, 250, 300, 400)];
    self.backgroundView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height /2);
    self.backgroundView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.backgroundView];
    
    
    //kale button
    
    UIButton *kaleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 290, 60)];
    [kaleButton setTitle:@"kale" forState:UIControlStateNormal];
    [kaleButton setImage:[UIImage imageNamed:@"kaleNoCheck"] forState:UIControlStateNormal];
    [kaleButton setImage:[UIImage imageNamed:@"kaleCheck"] forState:UIControlStateSelected];
    kaleButton.center = CGPointMake(self.backgroundView.frame.size.width / 2, (self.backgroundView.frame.size.height - self.backgroundView.frame.size.height)+(kaleButton.frame.size.height/2)+20) ;
    [self styleButton:kaleButton];
    
    //oatmeal button
    UIButton *oatmealButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 290, 60)];
    [oatmealButton setTitle:@"oatmeal" forState:UIControlStateNormal];
    [oatmealButton setImage:[UIImage imageNamed:@"oatmealNoCheck"] forState:UIControlStateNormal];
    [oatmealButton setImage:[UIImage imageNamed:@"oatmealCheck"] forState:UIControlStateSelected];
    oatmealButton.center = CGPointMake(self.backgroundView.frame.size.width / 2, (self.backgroundView.frame.size.height - self.backgroundView.frame.size.height)+(kaleButton.frame.size.height/2)+80) ;
    [self styleButton:oatmealButton];
    
    //avocado button
    UIButton *avocadoButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 290, 60)];
    [avocadoButton setTitle:@"avocado" forState:UIControlStateNormal];
    [avocadoButton setImage:[UIImage imageNamed:@"avocadoNoCheck"] forState:UIControlStateNormal];
    [avocadoButton setImage:[UIImage imageNamed:@"avocadoCheck"] forState:UIControlStateSelected];
    avocadoButton.center = CGPointMake(self.backgroundView.frame.size.width / 2, (self.backgroundView.frame.size.height - self.backgroundView.frame.size.height)+(kaleButton.frame.size.height/2)+140) ;
    [self styleButton:avocadoButton];
    
    //berries button
    UIButton *berriesButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 290, 60)];
    [berriesButton setTitle:@"berries" forState:UIControlStateNormal];
    [berriesButton setImage:[UIImage imageNamed:@"berriesNoCheck"] forState:UIControlStateNormal] ;
     [berriesButton setImage:[UIImage imageNamed:@"berriesCheck"] forState:UIControlStateSelected];
    berriesButton.center = CGPointMake(self.backgroundView.frame.size.width / 2, (self.backgroundView.frame.size.height - self.backgroundView.frame.size.height)+(kaleButton.frame.size.height/2)+200) ;
    [self styleButton:berriesButton];
    
    //eggs button
    UIButton *eggsButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 290, 60)];
    [eggsButton setTitle:@"eggs" forState:UIControlStateNormal];
    [eggsButton setImage:[UIImage imageNamed:@"eggsNoCheck"] forState:UIControlStateNormal];
    [eggsButton setImage:[UIImage imageNamed:@"eggsCheck"] forState:UIControlStateSelected];
    eggsButton.center = CGPointMake(self.backgroundView.frame.size.width / 2, (self.backgroundView.frame.size.height - self.backgroundView.frame.size.height)+(kaleButton.frame.size.height/2)+260) ;
    [self styleButton:eggsButton];
    
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 290, 60)];
    [searchButton setTitle:@"Search" forState:UIControlStateNormal];
    searchButton.center = CGPointMake(self.backgroundView.frame.size.width / 2, (self.backgroundView.frame.size.height - self.backgroundView.frame.size.height)+(kaleButton.frame.size.height/2)+320) ;
    [searchButton addTarget:self action:@selector(search) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.buttonArray = @[kaleButton, oatmealButton, avocadoButton, berriesButton, eggsButton];
    [self.backgroundView addSubview:kaleButton];
    [self.backgroundView addSubview:oatmealButton];
    [self.backgroundView addSubview:avocadoButton];
    [self.backgroundView addSubview:berriesButton];
    [self.backgroundView addSubview:eggsButton];
    [self.backgroundView addSubview:searchButton];
    
    
}

-(void)styleButton:(UIButton *)sender
{

    sender.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [sender addTarget:self action:@selector(filterButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)search
{
    self.recipeList = nil;
    self.searchTermArray = nil;
    self.searchTermArray = [NSMutableArray array];
    for (UIButton *button in self.buttonArray) {
        
        if ([button isSelected]) {
            NSLog(@"found a selected button");
            NSLog(@"button title is: %@", button.currentTitle);
            [self.searchTermArray addObject:button.currentTitle];
        }
    }
    [self.backgroundView removeFromSuperview];
    for (NSString *ingredient in self.searchTermArray) {
        [self searchWithIngredient:ingredient];
    }
    [self.collectionView reloadData];
    NSLog(@"search terms are: %@", self.searchTermArray);
}

-(void)filterButtonPressed:(UIButton *)sender {
    NSLog(@"button pressed");
    if ([sender isSelected]) {
        [sender setSelected:NO];
    } else {
        [sender setSelected:YES];
    }
    
}


@end
