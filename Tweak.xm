#import"JumpHeader.h"
#import"SimulateTouch.h"
%hook WAGameViewController
%property(retain,nonatomic) UIView * cheatView;
-(void)viewWillAppear:(BOOL)arg1{
	%orig;
	UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    view.backgroundColor=[UIColor clearColor];
    view.tag=66;
    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    tap.delegate=self;
    [view addGestureRecognizer:tap];
    [self.view addSubview:view];
    view.userInteractionEnabled=NO;
    UIButton * startBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    UIButton * jumpBtn=[UIButton buttonWithType:UIButtonTypeSystem];
    [startBtn setTitle:@"start" forState:UIControlStateNormal];
    [jumpBtn setTitle:@"jump!" forState:UIControlStateNormal];
    [startBtn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-100,[UIScreen mainScreen].bounds.size.height/6, 100, 40)];
    [jumpBtn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-100,[UIScreen mainScreen].bounds.size.height/6+50, 100, 60)];
    startBtn.backgroundColor=[UIColor lightGrayColor];
    startBtn.layer.cornerRadius=8.f;
    startBtn.alpha=0.8;
    jumpBtn.backgroundColor=[UIColor lightGrayColor];
    jumpBtn.layer.cornerRadius=8.f;
    jumpBtn.alpha=0.8;
    [startBtn addTarget:self action:@selector(startCheat) forControlEvents:UIControlEventTouchUpInside];
    [jumpBtn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startBtn];
    [self.view addSubview:jumpBtn];
}

%new
-(void)startCheat{
	for (UIView * view in self.view.subviews) {
        if (view.tag==66) {
            if (view.userInteractionEnabled==NO) {
                view.userInteractionEnabled=YES;
            }
            else{
                view.userInteractionEnabled=NO;
            }
        }
    }
}

%new
-(void)jump{
	UIView * cheatView;
    for (UIView * view in self.view.subviews) {
        if (view.tag==66) {
            cheatView=view;
        }
    }
    if (cheatView.subviews.count==2)
    {
    	cheatView.userInteractionEnabled=NO;
	    CGFloat x=cheatView.subviews[1].frame.origin.x-cheatView.subviews[0].frame.origin.x;
	    CGFloat y=cheatView.subviews[1].frame.origin.y-cheatView.subviews[0].frame.origin.y;
	    CGFloat length=sqrt(powf(x, 2.f)+powf(y, 2.f));
	    CGFloat duration=length/245;
	    CGPoint center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
	    int r = [SimulateTouch simulateTouch:0 atPoint:center withType:STTouchDown];
	    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
	        [SimulateTouch simulateTouch:r atPoint:center withType:STTouchUp];
	        cheatView.userInteractionEnabled=YES;
	    });
	    for (UIView * subview in cheatView.subviews) {
	    	[subview removeFromSuperview];
		}
    }
    else{

    }
}
%new
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint p = [touch locationInView:self.view];
    UIView * cheatView;
    for (UIView * view in self.view.subviews) {
        if (view.tag==66) {
            cheatView=view;
        }
    }
    if (cheatView.subviews.count>=2)
    {
        for (UIView * view in self.view.subviews) {
            if (view.tag==66) {
                for (UIView * subview in view.subviews) {
                    [subview removeFromSuperview];
                }
            }
        }
    }
    else{
        UIView * view =[[UIView alloc]initWithFrame:CGRectMake(p.x-2.5,p.y-2.5,5,5)];
        view.layer.cornerRadius=2.5;
        view.backgroundColor=[UIColor redColor];
        [cheatView addSubview:view];
    }
    return NO;
}
%end
