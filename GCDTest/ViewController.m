//
//  ViewController.m
//  GCDTest
//
//  Created by Pandora on 13. 7. 1..
//  Copyright (c) 2013년 Jinsik Jung. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (NSString *)fetchSomethingFromSserver
{
    [NSThread sleepForTimeInterval:1];
    
    return @"Hi there";
}

- (NSString *)processData:(NSString *)data
{
    [NSThread sleepForTimeInterval:2];
    
    return [data uppercaseString];
}

- (NSString *)calculateFirstResult:(NSString *)data
{
    [NSThread sleepForTimeInterval:3];
    
    return [NSString stringWithFormat:@"Number of chars: %d", [data length]];
}

- (NSString *)calculateSecondfResult:(NSString *)data
{
    [NSThread sleepForTimeInterval:4];
    
    return [data stringByReplacingOccurrencesOfString:@"E" withString:@"e"];
}

- (void)saesjjdsfmndbfmndbfnmsb
{
    
}

- (IBAction)doWork:(id)sender
{
    NSDate *startTime = [NSDate date];
    _startButton.enabled = NO;
    _startButton.alpha = 0.5;
    [_spinner startAnimating];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
    NSString *fetchedData = [self fetchSomethingFromSserver];
    NSString *processData = [self processData:fetchedData];
//    NSString *firstResult = [self calculateFirstResult:processData];
//    NSString *secondResult = [self calculateSecondfResult:processData];
        
    __block NSString *firstResult;
    __block NSString *secondResult;
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        
        firstResult =[self calculateFirstResult:processData];
        
    });
    
    dispatch_group_async(group, dispatch_get_global_queue(0, 0), ^{
        secondResult = [self calculateSecondfResult:processData];
    });
        
    dispatch_group_notify(group, dispatch_get_global_queue(0, 0), ^{
        NSString *resultsSummary = [NSString stringWithFormat:@"First: [%@]\nSecond: [%@]", firstResult, secondResult];
    
        dispatch_async(dispatch_get_main_queue(), ^{
            _startButton.enabled = YES;
            _startButton.alpha = 1.0f;
            [_spinner stopAnimating];
            _resultsTextView.text = resultsSummary;
        });

        NSDate *endTime = [NSDate date];
        NSLog(@"Completed in %f seconds", [endTime timeIntervalSinceDate:startTime]);
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
