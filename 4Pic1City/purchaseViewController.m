//
//  purchaseViewController.m
//  4Pic1City
//
//  Created by unibera1 on 9/27/13.
//  Copyright (c) 2013 unibera. All rights reserved.
//

#import "purchaseViewController.h"
#import <StoreKit/StoreKit.h>
#import "Reachability.h"

@interface purchaseViewController ()<UITableViewDataSource,UITableViewDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProductsRequest *productsRequest;
    NSArray *coinsArray;
    NSArray *imageArray;
    NSArray *productIdentifier;
    NSArray *coins;
    Reachability *reach;
    BOOL canClose;
    int Tag;
}
@end

@implementation purchaseViewController
{
}

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
    [_indicator setHidden:YES];
    productIdentifier = @[@"com.unibera.Pic1City.Coins0",@"com.unibera.Pic1City.Coins1",@"com.unibera.Pic1City.Coins2",@"com.unibera.Pic1City.Coins3",@"com.unibera.Pic1City.Coins4",@"com.unibera.Pic1City.Coins5"];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:00 green:00 blue:00 alpha:0.7]];
    coins = @[@"500",@"1000",@"2500",@"5000",@"10000",@"20000"];
    coinsArray = @[@"$0.99",@"$1.99",@"$3.99",@"$6.99",@"$10.99",@"$19.99"];
    imageArray = @[@"500.png",@"1000.png",@"2500.png",@"5000.png",@"10000.png",@"20000.png"];
    [imageArray retain];
    [coinsArray retain];
    [productIdentifier retain];
    [coins retain];
    // Do any additional setup after loading the view from its nib.
}

-(BOOL)prefersStatusBarHidden{
    
    return YES;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell%d",indexPath.row]];
    if(cell == nil)
    {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"Cell%d",indexPath.row]]autorelease];
    }
    cell.imageView.image = [UIImage imageNamed:[imageArray objectAtIndex:indexPath.item]];
    cell.detailTextLabel.text = [coinsArray objectAtIndex:indexPath.item];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 6;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Tag = indexPath.item;
    [_indicator setHidden:NO];
    [_indicator startAnimating];
    NSSet *productIdentifiers = [NSSet setWithObjects:[productIdentifier objectAtIndex:indexPath.item],nil];
    productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus network = [reach currentReachabilityStatus];
    if(network==NotReachable)
    {
        UIAlertView *alert = [[[UIAlertView alloc]initWithTitle:@"" message:@"No Internet Connection found" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]autorelease];
        [alert show];
        [_indicator setHidden:YES];
        [_indicator stopAnimating];
    }
    else
    {
        canClose = YES;
        [productsRequest start];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    if (productsRequest) {
        [productsRequest release];
    }
    [_tableView release];
    [coinsArray release];
    [imageArray release];
    [productIdentifier release];
    [_indicator release];
    [coins release];
    [_cancel release];
    [super dealloc];
    
}
- (IBAction)cancelButton:(UIButton *)sender
{
    if(canClose)
    {
        [productsRequest cancel];
    }
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseMyProduct:(SKProduct*)product{
    if ([self canMakePurchases]) {
        canClose = NO;
        [_cancel setEnabled:NO];
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Purchases are disabled in your device" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}

#pragma mark StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    UIAlertView *failAlert;
    for (SKPaymentTransaction *transaction in transactions) {
        NSLog(@"transactions.count = %d",transactions.count);
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing:
                [_cancel setEnabled:NO];
                break;
            case SKPaymentTransactionStatePurchased:
                [_indicator stopAnimating];
                [_indicator setHidden:YES];
                if ([transaction.payment.productIdentifier isEqualToString:[productIdentifier objectAtIndex:Tag]]) {
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Purchase is completed succesfully" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alertView show];
                    [self.delegate increaseCoins:[coins objectAtIndex:Tag]];
                    [_cancel setEnabled:YES];
                }
                [queue finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [_indicator stopAnimating];
                [_indicator setHidden:YES];
                failAlert =[[UIAlertView alloc]initWithTitle:@"Purchase is completed Unsuccesfully.Try Again!!" message:nil delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                [failAlert show];
                [_cancel setEnabled:YES];
                [queue finishTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response

{
    SKProduct *validProduct = nil;
    int count = [response.products count];
    NSLog(@"count =%d",count);
    if (count>0) {
        validProduct = [response.products objectAtIndex:0];
        if ([validProduct.productIdentifier isEqualToString:[productIdentifier objectAtIndex:Tag]]) {
            NSLog(@"%@",[NSString stringWithFormat:@"Product Title: %@",validProduct.localizedTitle]);
            [self purchaseMyProduct:validProduct];
        }
    } else {
        [_indicator stopAnimating];
        [_indicator setHidden:YES];
        [productsRequest cancel];
        UIAlertView *tmp = [[UIAlertView alloc] initWithTitle:@"Not Available" message:@"No products to purchase" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [tmp show];
    }
}

@end
