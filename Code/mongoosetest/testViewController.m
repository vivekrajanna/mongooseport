//
//  testViewController.m
//  mongoosetest
//
//  Created by vivek Rajanna on 10/04/13.
//  Copyright (c) 2013 vivek Rajanna. All rights reserved.
//

#import "testViewController.h"
#import "Mongoosewrapper.h"

@interface testViewController ()
{
    UITableView *urltableView ;
}
@property (nonatomic, strong) NSArray *tableDataSource;
@end

@implementation testViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    urltableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    [urltableView  setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    [urltableView setDataSource:self];
    [urltableView setDelegate:self];
    
    [self.view addSubview:urltableView];
 	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    if( !_tableDataSource)
    {
        _tableDataSource = [[MongooseWrapper sharedInstance] serverContactURL];
        
    }

    [urltableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    NSLog(@"%d",[_tableDataSource count]);
    return [_tableDataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if(cell == Nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    
    }
    NSURL *url = [_tableDataSource objectAtIndex:[indexPath row]];
        [[cell textLabel]setText:[url absoluteString] ];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [[UIApplication sharedApplication]openURL:[_tableDataSource objectAtIndex:indexPath.row]];

}
@end
