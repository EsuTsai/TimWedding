//
//  PMMapVC.m
//  TimWedding
//
//  Created by Esu Tsai on 2015/9/19.
//  Copyright (c) 2015年 Esu Tsai. All rights reserved.
//

#import "PMMapVC.h"
@import GoogleMaps;

static CLLocationManager *locationManager;

@interface PMMapVC () <CLLocationManagerDelegate, GMSMapViewDelegate>
{
    GMSMapView *mapView_;
    UIButton *mapInfoBtn;
    UIImageView *bgImg;
}
@end

@implementation PMMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (nil == locationManager){
        locationManager = [[CLLocationManager alloc]init];
    }
        
    [locationManager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
        
    if( [CLLocationManager locationServicesEnabled] ) {
        locationManager.delegate        = self;
        locationManager.distanceFilter  = kCLDistanceFilterNone;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            
        [locationManager startUpdatingLocation];
    }
        
    self.view.backgroundColor = [UIColor blackColor];
    bgImg           = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width,300)];
    bgImg.contentMode            = UIViewContentModeScaleAspectFill;
    bgImg.clipsToBounds          = YES;
    bgImg.userInteractionEnabled = YES;
    [bgImg setImage:[UIImage imageNamed:@"photos01.jpg"]];
    [self.view addSubview:bgImg];
    
    UIView *layer = [[UIView alloc] initWithFrame:bgImg.bounds];
    layer.backgroundColor = [UIColor blackColor];
    layer.alpha = 0.3;
    [bgImg addSubview:layer];
    
    
    UILabel *busTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, 30, SCREEN_BOUNDS.size.width-40, 20)];
    busTitle.font = [UIFont fontWithName:defaultFont size:18];
    busTitle.text = @"大眾運輸";
    busTitle.textColor = [UIColor colorWithRed:233.0/255.0 green:215.0/255.0 blue:154.0/255.0 alpha:1.000];
    [bgImg addSubview:busTitle];
    
    UILabel *busInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, busTitle.frame.origin.y + busTitle.frame.size.height + 2, SCREEN_BOUNDS.size.width-40, 40)];
    busInfo.font = [UIFont fontWithName:defaultFont size:13];
    busInfo.text = @"公車 - 環球購物中心、板橋監理站\n可搭乘藍31 57 307 796 1032";
    busInfo.numberOfLines = 0;
    busInfo.textColor = [UIColor whiteColor];
    busInfo.layer.shadowColor = [UIColor blackColor].CGColor;
    busInfo.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    busInfo.layer.shadowRadius = 3.0;
    busInfo.layer.shadowOpacity = 1.0;
    [bgImg addSubview:busInfo];
    
    UILabel *sutterBusTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, busInfo.frame.origin.y + busInfo.frame.size.height+10, SCREEN_BOUNDS.size.width-40, 20)];
    sutterBusTitle.font = [UIFont fontWithName:defaultFont size:18];
    sutterBusTitle.text = @"接駁專車";
    sutterBusTitle.textColor = [UIColor colorWithRed:233.0/255.0 green:215.0/255.0 blue:154.0/255.0 alpha:1.000];
    [bgImg addSubview:sutterBusTitle];
    
    UILabel *sutterBusInfo = [[UILabel alloc] initWithFrame:CGRectMake(20, sutterBusTitle.frame.origin.y + sutterBusTitle.frame.size.height + 2, SCREEN_BOUNDS.size.width-40, 160)];
    sutterBusInfo.font = [UIFont fontWithName:defaultFont size:13];
    sutterBusInfo.text = @"1. 景安線 / 平均班距30-45分\n環球購物中心 - 中和稅捐站 - (美麗時代站) - 中和市公所站 - 捷運景安站 - (遠東世紀站)\n2. 新埔線 / 平均班距15-20分\n環球購物中心 - 正隆廣場站 - 捷運新埔站3號出口 - 捷運新埔站1號出口\n3. 板橋線 / 平均班距15-20分\n環球購物中心 - 板橋火車站西出口站 - 環球購物中心";
    sutterBusInfo.numberOfLines = 0;
    sutterBusInfo.textColor = [UIColor whiteColor];
    sutterBusInfo.layer.shadowColor = [UIColor blackColor].CGColor;
    sutterBusInfo.layer.shadowOffset = CGSizeMake(3.0, 3.0);
    sutterBusInfo.layer.shadowRadius = 3.0;
    sutterBusInfo.layer.shadowOpacity = 1.0;
    [bgImg addSubview:sutterBusInfo];
    
    mapInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_BOUNDS.size.width, 350)];
    mapInfoBtn.backgroundColor = [UIColor blackColor];
    mapInfoBtn.alpha = 0.0;
    [mapInfoBtn addTarget:self action:@selector(openTrafficWay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:mapInfoBtn];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:25.0065836
                                                            longitude:121.4748252
                                                                 zoom:17];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 300, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height - 49 -300) camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.buildingsEnabled = NO;
    mapView_.delegate = self;
    mapView_.settings.myLocationButton = YES;
    [self.view addSubview:mapView_];
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(25.0065836, 121.4748252);
    marker.title = @"華漾環球 4F 福漾廳";
    marker.snippet = @"104年 11月 1日 (日) 18:00 晚宴";
    marker.map = mapView_;
    
    [mapView_ setSelectedMarker:marker];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapView:(GMSMapView *)mapView willMove:(BOOL)gesture
{
    dispatch_async(dispatch_get_main_queue(), ^{
    if(mapView.frame.origin.y >= 300){
        [UIView animateWithDuration:.45 animations:^{
            mapView.frame = CGRectMake(0, 100, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height-49-100);
            mapInfoBtn.alpha = 0.5;
            bgImg.transform = CGAffineTransformMakeScale(0.9,0.9);
        } completion:^(BOOL finished) {
            
        }];
    }
    });

}

- (void)openTrafficWay:(UIButton *)sender
{
    [UIView animateWithDuration:.45 animations:^{
        mapView_.frame = CGRectMake(0, 300, SCREEN_BOUNDS.size.width, SCREEN_BOUNDS.size.height-49-300);
        mapInfoBtn.alpha = 0.0;
        bgImg.transform = CGAffineTransformMakeScale(1.0,1.0);

    } completion:^(BOOL finished) {
        
    }];
}
@end
