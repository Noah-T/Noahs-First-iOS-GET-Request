//
//  ViewController.m
//  Noah'sFirstGetRequest
//
//  Created by Noah Teshu on 9/30/14.
//  Copyright (c) 2014 Noah Teshu. All rights reserved.
//

#import "ViewController.h"
#import "Recipe.h"

@interface ViewController ()
@property (strong, nonatomic) NSMutableArray *recipeList;

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return self.recipeList.count;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    
    Recipe *recipe = [self.recipeList objectAtIndex:indexPath.row];
    cell.textLabel.text = recipe.recipeName;
    NSURL *recipeURL = [NSURL URLWithString:recipe.recipeImageURL];
    NSData *imageData = [NSData dataWithContentsOfURL:recipeURL];
    UIImage *image = [UIImage imageWithData:imageData];
    
    
    cell.imageView.image = image;
    
    return cell;
}



@end
