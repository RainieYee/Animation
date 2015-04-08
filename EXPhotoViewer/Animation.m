//
//  EXPhotoViewer.m
//  EXPhotoViewerDemo
//


#import "Animation.h"

@interface Animation ()

@property (nonatomic, retain) UIScrollView *zoomeableScrollView;
@property (nonatomic, retain) UIImageView *theImageView;
@property (nonatomic, retain) UIView* tempViewContainer;
@property (nonatomic, assign) CGRect originalImageRect;
@property (nonatomic, retain) UIViewController* controller;
@property (nonatomic, retain) UIViewController* selfController;
@property (nonatomic, retain) UIImageView* originalImage;

@property (strong,nonatomic) UILabel *label3;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *buyBtn;

@property (strong, nonatomic) UIView *buyView;
@property (strong, nonatomic) UIView *navView;
@property (strong, nonatomic) UIView *bkView;
@property (strong,nonatomic) UILabel *label1;
@property (strong,nonatomic) UILabel *label2;

@end

static CGFloat s_backgroundScale = 0.8f;

@implementation Animation

+ (void) showImageFrom:(UIImageView*) imageView {
    if (imageView.image) {
        Animation* viewer = [Animation new];
        [viewer showImageFrom:imageView];
    }
}

-(void)loadView {
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.maximumZoomScale = 10.f;
    scrollView.minimumZoomScale = 1.f;
    scrollView.delegate = self;
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview: scrollView];
    self.zoomeableScrollView = scrollView;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.clipsToBounds = YES;
    [self.zoomeableScrollView addSubview: imageView];
    self.theImageView = imageView;
}

-(UIViewController *) rootViewController{
    UIViewController* controller = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([controller presentedViewController]) {
        controller = [controller presentedViewController];
    }
    return controller;
}

- (void) showImageFrom:(UIImageView*) imageView {
    UIViewController * controller = [self rootViewController];
    
    self.tempViewContainer = [[UIView alloc] initWithFrame:controller.view.bounds];
    self.tempViewContainer.backgroundColor = controller.view.backgroundColor;
    controller.view.backgroundColor = [UIColor whiteColor];
    
    for (UIView* subView in controller.view.subviews) {
        [self.tempViewContainer addSubview:subView];
    }
    
    [controller.view addSubview:self.tempViewContainer];
    
    self.controller = controller;
    
    self.view.frame = controller.view.bounds; //CGRectZero;
    self.view.backgroundColor = [UIColor redColor];
    
    [controller.view addSubview:self.view];

    self.theImageView.image = imageView.image;
    self.originalImageRect = [imageView convertRect:imageView.bounds toView:self.view];

    self.theImageView.frame = self.originalImageRect;
    
    //listen to the orientation change notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, -80, self.view.bounds.size.width, 80)];
    self.navView.backgroundColor = [UIColor blackColor];
    self.buyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height + 20, self.view.bounds.size.width, 80)];
    self.buyView.backgroundColor = [UIColor whiteColor];
    self.bkView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200)];
    self.bkView.backgroundColor = [UIColor blackColor];
    self.bkView.layer.opacity = 0.5;
    
    
    self.label1 = [[UILabel alloc] initWithFrame:CGRectMake(320, self.view.frame.size.height - 210, 120, 30)];
    self.label1.text = @"Balmain";
    [self.label1 setFont:[UIFont fontWithName:@"Arial" size:17]];
    self.label1.textColor = [UIColor whiteColor];
    
    /////////////
    
    self.buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-20, 50)];
    [self.buyBtn setBackgroundColor:[UIColor whiteColor]];
    [self.buyBtn setTitle:@"Buy Now" forState:UIControlStateNormal];
    [self.buyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.buyBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.buyBtn.backgroundColor = [UIColor whiteColor];
    
    [self.buyView addSubview:self.buyBtn];
    //////////////
    
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 15, 50, 60)];
    [self.backBtn setBackgroundColor:[UIColor whiteColor]];
    [self.backBtn setTitle:@"Back" forState:UIControlStateNormal];
    [self.backBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backBtn setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.backBtn.backgroundColor = [UIColor clearColor];
    
    [self.navView addSubview:self.backBtn];
    ///////////////
    self.label3 = [[UILabel alloc] initWithFrame:CGRectMake(130, 25, 120, 40)];
    self.label3.text = @"Balmain";
    [self.label3 setFont:[UIFont fontWithName:@"Arial" size:17]];
    self.label3.textColor = [UIColor whiteColor];
    [self.navView addSubview:self.label3];
    
    self.label2 = [[UILabel alloc] initWithFrame:CGRectMake(320, self.view.frame.size.height - 180, 120, 30)];
    self.label2.text = @"$1135.00";
    [self.label2 setFont:[UIFont fontWithName:@"Arial" size:17]];
    self.label2.textColor = [UIColor whiteColor];
    
    
    [UIView animateWithDuration:5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        self.tempViewContainer.layer.transform = CATransform3DMakeScale(s_backgroundScale, s_backgroundScale, s_backgroundScale);
  
        self.theImageView.frame = self.view.frame;//[self centeredOnScreenImage:self.theImageView.image];
        
        self.navView.frame = CGRectMake(0, -10, self.view.bounds.size.width, 70);
        self.buyView.frame = CGRectMake(0, self.view.bounds.size.height - 50, self.view.bounds.size.width, 60);
        self.bkView.frame = CGRectMake(0, self.view.bounds.size.height - 230, self.view.bounds.size.width, 200);
        self.label1.frame = CGRectMake(20, self.view.frame.size.height - 210, 120, 30);
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(delayTime) userInfo:nil repeats:nil];
        
        [self.view addSubview:self.bkView];
        [self.view addSubview:self.label1];
        [self.view addSubview:self.buyView];
        [self.view addSubview:self.navView];
        
        
    } completion:^(BOOL finished) {
        [self adjustScrollInsetsToCenterImage];
        [self.backBtn addTarget:self action:@selector(onBackgroundTap) forControlEvents:UIControlEventTouchUpInside];

    }];
    

    
    self.selfController = self; //Stupid ARC I need to do this to avoid being dealloced :P
    self.originalImage = imageView;
    imageView.image = nil;
}

-(void)delayTime
{
    [UIView animateWithDuration:0.4 delay:0.1 usingSpringWithDamping:0.7 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
          self.label2.frame = CGRectMake(20, self.view.frame.size.height - 180, 120, 30);
        [self.view addSubview:self.label2];
    } completion:^(BOOL finished)
     {
         
     }];
    
}
-(void)delayTimer1
{
    [UIView animateWithDuration:0.2 delay:0 usingSpringWithDamping:0.6 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.label2.frame = CGRectMake(320, self.view.frame.size.height - 180, 120, 30);
         } completion:^(BOOL finished)
     {
         
     }];
}
-(void) dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)orientationDidChange:(NSNotification *)note
{
    self.theImageView.frame = [self centeredOnScreenImage:self.theImageView.image];

    CGRect newFrame = [self rootViewController].view.bounds;
    self.tempViewContainer.frame = newFrame;
    self.view.frame = newFrame;
    [self adjustScrollInsetsToCenterImage];

}

- (void) onBackgroundTap {
    CGRect absoluteCGRect = [self.view convertRect:self.theImageView.frame fromView:self.theImageView.superview];
    self.zoomeableScrollView.contentOffset = CGPointZero;
    self.zoomeableScrollView.contentInset = UIEdgeInsetsZero;
    self.theImageView.frame = absoluteCGRect;
    
    CGRect originalImageRect = [self.originalImage convertRect:self.originalImage.frame toView:self.view];
    //originalImageRect is now scaled down, need to adjust
    CGFloat scaleBack = 1.0/s_backgroundScale;
    CGFloat x = originalImageRect.origin.x;
    CGFloat y = originalImageRect.origin.y;
    CGFloat maxX = self.view.frame.size.width;
    CGFloat maxY = self.view.frame.size.height;
    
    y = (y - (maxY / 2.0) ) * scaleBack + (maxY / 2.0);
    x= (x - (maxX / 2.0) ) * scaleBack + (maxX / 2.0);
    originalImageRect.origin.x = x;
    originalImageRect.origin.y = y;
    
    originalImageRect.size.width *= 1.0/s_backgroundScale;
    originalImageRect.size.height *= 1.0/s_backgroundScale;
    //done scaling
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.theImageView.frame = originalImageRect;
        self.view.backgroundColor = [UIColor clearColor];
        self.tempViewContainer.layer.transform = CATransform3DIdentity;
        self.navView.frame = CGRectMake(0, -60, self.view.bounds.size.width, 60);
        self.buyView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 60);
        self.bkView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 200);
        self.label1.frame = CGRectMake(320, self.view.frame.size.height - 210, 120, 30);
         [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(delayTimer1) userInfo:nil repeats:nil];
    
        
    }completion:^(BOOL finished) {
        self.originalImage.image = self.theImageView.image;
        self.controller.view.backgroundColor = self.tempViewContainer.backgroundColor;
        for (UIView* subView in self.tempViewContainer.subviews) {
            [self.controller.view addSubview:subView];
        }
        [self.view removeFromSuperview];
        [self.tempViewContainer removeFromSuperview];
    }];
    
    self.selfController = nil;//Ok ARC you can kill me now.
}

- (CGRect) centeredOnScreenImage:(UIImage*) image {
    CGSize imageSize = [self imageSizesizeThatFitsForImage:self.theImageView.image];
    CGPoint imageOrigin = CGPointMake(0, 0);
    return CGRectMake(imageOrigin.x, imageOrigin.y, imageSize.width, imageSize.height);
}

- (CGSize) imageSizesizeThatFitsForImage:(UIImage*) image {
    if (!image)
        return CGSizeZero;
    
    CGSize imageSize = image.size;
    CGFloat ratio = MIN(self.view.frame.size.width/imageSize.width, self.view.frame.size.height/imageSize.height);
    ratio = MIN(ratio, 1.0);//If the image is smaller than the screen let's not make it bigger
    return CGSizeMake(imageSize.width*ratio, imageSize.height*ratio);
}

#pragma mark - ZOOM
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.theImageView;
}

- (void) adjustScrollInsetsToCenterImage {
//    CGSize imageSize = [self imageSizesizeThatFitsForImage:self.theImageView.image];
    self.zoomeableScrollView.zoomScale = 100.0;
    self.theImageView.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
    self.zoomeableScrollView.contentSize = self.theImageView.frame.size;
    
    CGRect innerFrame = self.theImageView.frame;
    CGRect scrollerBounds = self.zoomeableScrollView.bounds;
    CGPoint myScrollViewOffset = self.zoomeableScrollView.contentOffset;
    
    if ( ( innerFrame.size.width < scrollerBounds.size.width ) || ( innerFrame.size.height < scrollerBounds.size.height ) )
    {
        CGFloat tempx = self.theImageView.center.x - ( scrollerBounds.size.width / 2 );
        CGFloat tempy = self.theImageView.center.y - ( scrollerBounds.size.height / 2 );
        myScrollViewOffset = CGPointMake( tempx, tempy);
    }
    
    UIEdgeInsets anEdgeInset = { 0, 0, 0, 0};
    if ( scrollerBounds.size.width > innerFrame.size.width )
    {
        anEdgeInset.left = (scrollerBounds.size.width - innerFrame.size.width) / 2;
        anEdgeInset.right = -anEdgeInset.left; // I don't know why this needs to be negative, but that's what works
    }
    if ( scrollerBounds.size.height > innerFrame.size.height )
    {
        anEdgeInset.top = (scrollerBounds.size.height - innerFrame.size.height) / 2;
        anEdgeInset.bottom = -anEdgeInset.top; // I don't know why this needs to be negative, but that's what works
    }
    
    self.zoomeableScrollView.contentOffset = myScrollViewOffset;
    self.zoomeableScrollView.contentInset = anEdgeInset;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    UIView* view = self.theImageView;
    
    CGRect innerFrame = view.frame;
    CGRect scrollerBounds = scrollView.bounds;
    CGPoint myScrollViewOffset = scrollView.contentOffset;
    
    if ( ( innerFrame.size.width < scrollerBounds.size.width ) || ( innerFrame.size.height < scrollerBounds.size.height ) )
    {
        CGFloat tempx = view.center.x - ( scrollerBounds.size.width / 2 );
        CGFloat tempy = view.center.y - ( scrollerBounds.size.height / 2 );
        myScrollViewOffset = CGPointMake( tempx, tempy);
    }
    
    UIEdgeInsets anEdgeInset = { 0, 0, 0, 0};
    if ( scrollerBounds.size.width > innerFrame.size.width )
    {
        anEdgeInset.left = (scrollerBounds.size.width - innerFrame.size.width) / 2;
        anEdgeInset.right = -anEdgeInset.left; // I don't know why this needs to be negative, but that's what works
    }
    if ( scrollerBounds.size.height > innerFrame.size.height )
    {
        anEdgeInset.top = (scrollerBounds.size.height - innerFrame.size.height) / 2;
        anEdgeInset.bottom = -anEdgeInset.top; // I don't know why this needs to be negative, but that's what works
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        scrollView.contentOffset = myScrollViewOffset;
        scrollView.contentInset = anEdgeInset;
    }];
}

@end
