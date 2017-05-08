//
//  ViewController.m
//  CoreAnimation
//
//  Created by huangshan on 2017/4/26.
//  Copyright © 2017年 huangshan. All rights reserved.
//

#import "ViewController.h"

#import "HeadView.h"

@interface ViewController ()<CALayerDelegate, CAAnimationDelegate>

@property (nonatomic, strong) HeadView *mainView;

@property (nonatomic, strong) CALayer *doorLayer;

@property (nonatomic, strong) CALayer *layer;

@property (nonatomic, strong) UIButton *mainButton;

@property (nonatomic, strong) UILabel *mainText;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainView = [[HeadView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    self.mainView.backgroundColor = [UIColor yellowColor];
    self.mainView.layer.borderColor = [UIColor redColor].CGColor;
    self.mainView.layer.borderWidth = 4.0f;
    [self.view addSubview:self.mainView];
    
    
    [self test1];
    
    
    
    //    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.frame = CGRectMake(0, 0, 20, 40);
    //    button.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:button];
    //    [button addTarget:self action:@selector(test141) forControlEvents:UIControlEventTouchUpInside];
    //
    //    self.mainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //    self.mainButton.frame = CGRectMake(0, 60, 80, 40);
    //    self.mainButton.backgroundColor = [UIColor grayColor];
    //    [self.mainButton setTitle:@"哈" forState:UIControlStateNormal];
    //    [self.mainButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //    [self.view addSubview:self.mainButton];
    //
    //    self.mainText = [[UILabel alloc] init];
    //    self.mainText.frame = CGRectMake(0, 120, 80, 40);
    //    self.mainText.backgroundColor = [UIColor grayColor];
    //    self.mainText.text = @"哈";
    //    self.mainText.textColor = [UIColor whiteColor];
    //    [self.view addSubview:self.mainText];
    //
    //    self.layer = [CALayer layer];
    //    self.layer.frame = CGRectMake(0, 0, 40, 40);
    //    self.layer.backgroundColor = [UIColor yellowColor].CGColor;
    //    self.layer.borderColor = [UIColor redColor].CGColor;
    //    self.layer.borderWidth = 4.0f;
    //    self.layer.delegate = self;
    //    [self.mainView.layer addSublayer:self.layer];
    
}

- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    
    return nil;
}


- (void)test141 {
    
    [CATransaction begin];
    [CATransaction setAnimationDuration:4.0];
    [CATransaction setDisableActions:NO];
    
    //有actionForLayer函数，代理返回nil
    self.mainView.layer.backgroundColor = [UIColor cyanColor].CGColor;
    
    //做隐式动画
    self.layer.borderColor = [UIColor blueColor].CGColor;
    
    [self.mainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.mainText.textColor = [UIColor blackColor];
    
    [CATransaction commit];
}

#pragma mark - layer的属性值

- (void)test1 {
    
    //补充：这里的image.scale表示的是图片的比例，跟图片后面的名字 @2x  @3x有关系
    UIImage *image = [UIImage imageNamed:@"5"];
    
    self.mainView.layer.contents = (__bridge id _Nullable)(image.CGImage);
    
    //类似于imageViewMode，这是一个字符串
    self.mainView.layer.contentsGravity = kCAGravityCenter;
    
    //layer层图片的显示比例，如果设置了 contentsGravity = kCAGravityResizeAspect，设置比例则没有任何作用，因为本来就要适应图层的大小，比例没有用处了，如果没有设置了，则表示一个点显示多少个像素点。
    //self.mainView.layer.contentsScale = 4.0f;
    
    //contentsRect属性允许我们在图层边框里显示寄宿图的一个子域，它使用了单位坐标，单位坐标指定在0到1之间，默认的contentsRect是{0, 0, 1, 1}
    //contentsRect经常用来拼合图片，即载入一张大图片，然后分别取大图片的一部分区域来显示，这样比载入多张小图片高效
    //self.mainView.layer.contentsRect = CGRectMake(0.3, 0.3, 0.5, 0.5);
    
    //self.mainView.layer.contentsCenter = CGRectMake(0.5, 0.5, 0.5, 0.5);
    
    //设置阴影的时候，其会将寄宿图（包括子视图，如果有的话）考虑在内，然后通过这些来完美搭配图层形状从而创建一个阴影
    self.mainView.layer.shadowRadius = 10.0f;
    self.mainView.layer.shadowOpacity = 0.6;
    
}

#pragma mark - layer画图

- (void)test2 {
    
    //create sublayer
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    //set controller as layer delegate
    blueLayer.delegate = self;
    
    //ensure that layer backing image uses correct scale
    blueLayer.contentsScale = [UIScreen mainScreen].scale; //add layer to our view
    [self.mainView.layer addSublayer:blueLayer];
    
    //一定要加重绘制的操作，不然displayLayer或者drawLayer方法不会调用
    [blueLayer display];
}

- (void)displayLayer:(CALayer *)layer {
    
    
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    
    //draw a thick red circle
    CGContextSetLineWidth(ctx, 10.0f);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextStrokeEllipseInRect(ctx, layer.bounds);
    
}

//当图层的bounds发生改变，或者图层的-setNeedsLayout方法被调用的时候，这个函数将会被执行。
- (void)layoutSublayersOfLayer:(CALayer *)layer {
    
}

#pragma mark - 用zPosition显示图层的位置

- (void)test3 {
    
    //zPosition属性可以明显改变屏幕上图层的顺序，但不能改变事件传递的顺序。
    CALayer *blueLayer = [CALayer layer];
    blueLayer.frame = CGRectMake(50.0f, 50.0f, 100.0f, 100.0f);
    blueLayer.backgroundColor = [UIColor blueColor].CGColor;
    
    [self.view.layer addSublayer:blueLayer];
    
    CALayer *redLayer = [CALayer layer];
    redLayer.frame = CGRectMake(100.0f, 100.0f, 100.0f, 100.0f);
    redLayer.backgroundColor = [UIColor redColor].CGColor;
    
    [self.view.layer addSublayer:redLayer];
    
    CALayer *orangeLayer = [CALayer layer];
    orangeLayer.frame = CGRectMake(150.0f, 50.0f, 100.0f, 100.0f);
    orangeLayer.backgroundColor = [UIColor orangeColor].CGColor;
    
    [self.view.layer addSublayer:orangeLayer];
    
    blueLayer.zPosition = redLayer.zPosition + 1;
    orangeLayer.zPosition = redLayer.zPosition - 1;
}

#pragma mark - 图层边框

- (void)test4 {
    
    //这里可以看到就算红色的视图被遮挡了，其图层边框还是可以看到
    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(100.0f, 100.0f, 100.0f, 100.0f)];
    redView.layer.backgroundColor = [UIColor redColor].CGColor;
    redView.layer.borderWidth = 2.0f;
    
    [self.view addSubview:redView];
    
    UIView *blueView = [[UIView alloc] initWithFrame:CGRectMake(50.0f, 50.0f, 100.0f, 100.0f)];
    blueView.layer.backgroundColor = [UIColor blueColor].CGColor;
    blueView.layer.borderWidth = 2.0f;
    
    [redView addSubview:blueView];
    
}

#pragma mark - 使用mask蒙版，展示的是两个图层的重合部分

- (void)test5 {
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    imageView.image = [UIImage imageNamed:@"5"];
    [self.view addSubview:imageView];
    
    //create mask layer
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = imageView.bounds;
    UIImage *maskImage = [UIImage imageNamed:@"2.png"];
    maskLayer.contents = (__bridge id)maskImage.CGImage;
    
    //apply mask to image layer￼
    imageView.layer.mask = maskLayer;
}

#pragma mark - 组透明

- (UIButton *)customButton
{
    //create button
    CGRect frame = CGRectMake(0, 0, 150, 50);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 10;
    
    //add label
    frame = CGRectMake(20, 10, 110, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = @"Hello World";
    label.backgroundColor = [UIColor blueColor];
    label.textAlignment = NSTextAlignmentCenter;
    [button addSubview:label];
    label.tag = 2000;
    return button;
}

- (void)test6
{
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
    containerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:containerView];
    
    //create opaque button
    UIButton *button1 = [self customButton];
    button1.center = CGPointMake(100, 250);
    button1.alpha = 0.5;
    [containerView addSubview:button1];
    
    //create translucent button
    UIButton *button2 = [self customButton];
    button2.center = CGPointMake(300, 250);
    button2.layer.opacity = 0.5;
    UILabel *label = [button2 viewWithTag:2000];
    label.layer.opacity = 0.5f;
    [containerView addSubview:button2];
    
    //enable rasterization for the translucent button
    button2.layer.shouldRasterize = YES;
    button2.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

#pragma mark - 变换

- (void)test7 {
    
    UIImage *image = [UIImage imageNamed:@"5"];
    
    self.mainView.layer.contents = (__bridge id _Nullable)(image.CGImage);
    
    //本质上是对图层做变换
    
    //缩放
    //self.mainView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    
    //旋转
    //self.mainView.transform = CGAffineTransformMakeRotation(M_2_PI);
    
    //平移
    //self.mainView.transform = CGAffineTransformMakeTranslation(50.0f, 50.0f);
    
    //对应layer的属性为affineTransform
    //self.mainView.layer.affineTransform = CGAffineTransformMakeTranslation(50.0f, 50.0f);
    
    //初始生成一个什么都不做的变换很重要--也就是创建一个CGAffineTransform类型的空值，矩阵论中称作单位矩阵
    //CGAffineTransformIdentity
    
    //变换组合
    CGAffineTransform t1 = CGAffineTransformMakeTranslation(50.0f, 50.0f);
    CGAffineTransform t2 = CGAffineTransformMakeRotation(M_2_PI);
    
    CGAffineTransform t = CGAffineTransformConcat(t1, t2);
    //self.mainView.transform = t;
    
    UIView *tranView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    tranView.layer.contents = (__bridge id _Nullable)(image.CGImage);
    [self.view addSubview:tranView];
    
    CGAffineTransform transform = CGAffineTransformIdentity; //create a new transform
    transform = CGAffineTransformRotate(transform, M_2_PI);
    transform = CGAffineTransformTranslate(transform, 50.0f, 50.0f);
    
    //变换的顺序会影响最终的结果，也就是说旋转之后的平移和平移之后的旋转结果可能不同。
    tranView.transform = transform;
    
    //斜切变换
    CGAffineTransform transform1 = CGAffineTransformIdentity;
    //transform1.c = 1;
    //transform1.b = 1;
    self.mainView.layer.affineTransform = transform1;
    
}

#pragma mark - 3D变换

- (void)test8 {
    
    UIImage *image = [UIImage imageNamed:@"5"];
    
    self.mainView.layer.contents = (__bridge id _Nullable)(image.CGImage);
    
    
    //create a new transform
    CATransform3D transform = CATransform3DIdentity;
    
    //m34的默认值是0，我们可以通过设置m34为-1.0 / d来应用透视效果，d代表了想象中视角相机和屏幕之间的距离，以像素为单位
    transform.m34 = - 1.0 / 500.0;
    
    //rotate by 45 degrees along the Y axis
    transform = CATransform3DRotate(transform, M_PI_4, 0, 1, 0);
    
    //apply to layer
    self.mainView.layer.transform = transform;
    
    /** 关于灭点
     
     灭点
     
     当在透视角度绘图的时候，远离相机视角的物体将会变小变远，当远离到一个极限距离，它们可能就缩成了一个点，于是所有的物体最后都汇聚消失在同一个点。
     
     在现实中，这个点通常是视图的中心，于是为了在应用中创建拟真效果的透视，这个点应该聚在屏幕中点，或者至少是包含所有3D对象的视图中点。
     
     Core Animation定义了这个点位于变换图层的anchorPoint（通常位于图层中心，但也有例外，见第三章）。这就是说，当图层发生变换时，这个点永远位于图层变换之前anchorPoint的位置。
     
     当改变一个图层的position，你也改变了它的灭点，做3D变换的时候要时刻记住这一点，当你视图通过调整m34来让它更加有3D效果，应该首先把它放置于屏幕中央，然后通过平移来把它移动到指定位置（而不是直接改变它的position），这样所有的3D图层都共享一个灭点。
     */
}

#pragma mark - sublayerTransform属性

- (void)test9 {
    
    /** CALayer有一个属性叫做sublayerTransform。它也是CATransform3D类型，但和对一个图层的变换不同，它影响到所有的子图层。这意味着你可以一次性对包含这些图层的容器做变换，于是所有的子图层都自动继承了这个变换方法。
     */
    
    UIImage *image = [UIImage imageNamed:@"5"];
    
    UIView *containerView = [[UIView alloc] initWithFrame:self.view.frame];
    containerView.backgroundColor = [UIColor grayColor];
    [self.view addSubview:containerView];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 100, 100)];
    leftView.layer.contents = (__bridge id _Nullable)(image.CGImage);
    [containerView addSubview:leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(200, 50, 100, 100)];
    rightView.layer.contents = (__bridge id _Nullable)(image.CGImage);
    [containerView addSubview:rightView];
    
    
    //apply perspective transform to container
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = - 1.0 / 800.0;
    containerView.layer.sublayerTransform = perspective;
    
    //rotate layerView1 by 45 degrees along the Y axis
    CATransform3D transform1 = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
    leftView.layer.transform = transform1;
    
    //rotate layerView2 by 45 degrees along the Y axis
    CATransform3D transform2 = CATransform3DMakeRotation(-M_PI_4, 0, 1, 0);
    rightView.layer.transform = transform2;
}


/** 背面
 
 CALayer有一个叫做doubleSided的属性来控制图层的背面是否要被绘制。这是一个BOOL类型，默认为YES，如果设置为NO，那么当图层正面从相机视角消失的时候，它将不会被绘制。
 */

#pragma mark - CAShapeLayer图层

- (void)test10 {
    
    /** CAShapeLayer是一个通过矢量图形而不是bitmap来绘制的图层子类。
     CATextLayer是Core Animation提供了一个CALayer的子类CATextLayer，它以图层的形式包含了UILabel几乎所有的绘制特性，并且额外提供了一些新的特性。
     
     CATransformLayer图层
     */
    
    //create a text layer
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = self.mainView.bounds;
    [self.mainView.layer addSublayer:textLayer];
    
    //set text attributes
    textLayer.foregroundColor = [UIColor blackColor].CGColor;
    textLayer.alignmentMode = kCAAlignmentJustified;
    textLayer.wrapped = YES;
    
    //决定图层内容应该以怎样的分辨率来渲染，不然会像素化
    textLayer.contentsScale = [UIScreen mainScreen].scale;
    
    //choose a font
    UIFont *font = [UIFont systemFontOfSize:15];
    
    //set layer font
    CFStringRef fontName = (__bridge CFStringRef)font.fontName;
    CGFontRef fontRef = CGFontCreateWithFontName(fontName);
    textLayer.font = fontRef;
    textLayer.fontSize = font.pointSize;
    CGFontRelease(fontRef);
    
    //choose some text
    NSString *text = @"Lorem ipsum";
    
    //set layer text
    textLayer.string = text;
    
}

#pragma mark - CAGradientLayer图层

- (void)test11 {
    
    /** CAGradientLayer是用来生成两种或更多颜色平滑渐变的。用Core Graphics复制一个CAGradientLayer并将内容绘制到一个普通图层的寄宿图也是有可能的，但是CAGradientLayer的真正好处在于绘制使用了硬件加速。 */
    
    //create gradient layer and add it to our container view
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.mainView.bounds;
    [self.mainView.layer addSublayer:gradientLayer];
    
    //这些渐变色彩放在一个数组中，并赋给colors属性。这个数组成员接受CGColorRef类型的值（并不是从NSObject派生而来），所以我们要用通过bridge转换以确保编译正常
    gradientLayer.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id) [UIColor yellowColor].CGColor, (__bridge id)[UIColor greenColor].CGColor];
    
    //但是我们可以用locations属性来调整空间。locations属性是一个浮点数值的数组（以NSNumber包装）。这些浮点数定义了colors属性中每个不同颜色的位置，同样的，也是以单位坐标系进行标定。0.0代表着渐变的开始，1.0代表着结束。
    gradientLayer.locations = @[@0.0, @0.25, @0.5];
    
    //startPoint和endPoint属性，他们决定了渐变的方向。这两个参数是以单位坐标系进行的定义，所以左上角坐标是{0, 0}，右下角坐标是{1, 1}。
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 1);
    
}

#pragma mark - CAReplicatorLayer图层

- (void)test12 {
    
    /** CAReplicatorLayer的目的是为了高效生成许多相似的图层。它会绘制一个或多个图层的子图层，并在每个复制体上应用不同的变换。看上去演示能够更加解释这些，我们来写个例子吧。 */
    
    //instanceTransform指定了一个CATransform3D3D变换（这种情况下，下一图层的位移和旋转将会移动到圆圈的下一个点）。
    
    //create a replicator layer and add it to our view
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = self.mainView.bounds;
    [self.view.layer addSublayer:replicator];
    //instanceCount属性指定了图层需要重复多少次。
    replicator.instanceCount = 10;
    
    //instanceTransform指定了一个CATransform3D3D变换（这种情况下，下一图层的位移和旋转将会移动到圆圈的下一个点）。
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 20, 0);
    //    transform = CATransform3DRotate(transform, M_PI / 5.0, 0, 0, 1);
    //    transform = CATransform3DTranslate(transform, 0, -20, 0);
    replicator.instanceTransform = transform;
    
    //这是用instanceBlueOffset和instanceGreenOffset属性实现的。通过逐步减少蓝色和绿色通道，我们逐渐将图层颜色转换成了红色。
    replicator.instanceBlueOffset = -0.1;
    replicator.instanceGreenOffset = -0.1;
    
    //起始位置的layer
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100.0f, 100.0f, 100.0f, 100.0f);
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    [replicator addSublayer:layer];
    
}

#pragma mark - CAEmitterLayer图层

- (void)test13 {
    
    /** CAEmitterLayer是一个高性能的粒子引擎 */
    
    //create particle emitter layer
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.frame = self.mainView.bounds;
    [self.mainView.layer addSublayer:emitter];
    
    //configure emitter
    emitter.renderMode = kCAEmitterLayerAdditive;
    emitter.emitterPosition = CGPointMake(emitter.frame.size.width / 2.0, emitter.frame.size.height / 2.0);
    
    //create a particle template
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    cell.contents = (__bridge id)[UIImage imageNamed:@"2.png"].CGImage;
    cell.birthRate = 150;
    cell.lifetime = 5.0;
    cell.color = [UIColor colorWithRed:1 green:0.5 blue:0.1 alpha:1.0].CGColor;
    cell.alphaSpeed = -0.4;
    cell.velocity = 50;
    cell.velocityRange = 50;
    cell.emissionRange = M_PI * 2.0;
    
    //add particle template to emitter
    emitter.emitterCells = @[cell];
}

#pragma mark - CATransaction动画

- (void)test14 {
    
    //otherwise (slowly) move the layer to new position
    [CATransaction begin];
    [CATransaction setAnimationDuration:4.0];
    self.mainView.layer.position = CGPointMake(400, 400);
    [CATransaction commit];
}

#pragma mark - CABasicAnimation

- (void)test15
{
    /** 这是因为动画并没有改变图层的模型，而只是呈现（第七章）。一旦动画结束并从图层上移除之后，图层就立刻恢复到之前定义的外观状态。我们从没改变过backgroundColor属性，所以图层就返回到原始的颜色。
     
     当之前在使用隐式动画的时候，实际上它就是用例子中CABasicAnimation来实现的（回忆第七章，我们在-actionForLayer:forKey:委托方法打印出来的结果就是CABasicAnimation）。但是在那个例子中，我们通过设置属性来打开动画。在这里我们做了相同的动画，但是并没有设置任何属性的值（这就是为什么会立刻变回初始状态的原因）。
     
     这里有两个方法来更新动画结束后的属性状态
     1、在动画之前设置动画结束后的属性值
     2、使用CAAnimationDelegate设置动画结束后的值-animationDidStop:finished:
     */
    
    //create a new random color
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    //create a basic animation
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"backgroundColor";
    animation.toValue = (__bridge id)color.CGColor;
    animation.duration = 2.0f;
    animation.delegate = self;
    //apply animation to layer
    [self.mainView.layer addAnimation:animation forKey:nil];
    
}

//- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
//
//    //委托传入的动画参数是原始值的一个深拷贝，从而不是同一个值。这里的ani是原始动画的深拷贝
//
//}

#pragma mark - CAKeyframeAnimation

- (void)test16 {
    
    //create a path
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(0, 150)];
    [bezierPath addCurveToPoint:CGPointMake(300, 150) controlPoint1:CGPointMake(75, 0) controlPoint2:CGPointMake(225, 300)];
    //draw the path using a CAShapeLayer
    CAShapeLayer *pathLayer = [CAShapeLayer layer];
    pathLayer.path = bezierPath.CGPath;
    pathLayer.fillColor = [UIColor clearColor].CGColor;
    pathLayer.strokeColor = [UIColor redColor].CGColor;
    pathLayer.lineWidth = 3.0f;
    [self.mainView.layer addSublayer:pathLayer];
    //add the ship
    CALayer *shipLayer = [CALayer layer];
    shipLayer.frame = CGRectMake(0, 0, 64, 64);
    shipLayer.position = CGPointMake(0, 150);
    shipLayer.contents = (__bridge id)[UIImage imageNamed: @"2.png"].CGImage;
    [self.mainView.layer addSublayer:shipLayer];
    //create the keyframe animation
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"position";
    animation.duration = 4.0;
    animation.path = bezierPath.CGPath;
    
    //设置它为常量kCAAnimationRotateAuto，图层将会根据曲线的切线自动旋转
    animation.rotationMode = kCAAnimationRotateAuto;
    [shipLayer addAnimation:animation forKey:nil];
}

#pragma mark - CATransition过渡动画

- (void)test17 {
    
    /** 你可以从代码中看出，过渡动画和之前的属性动画或者动画组添加到图层上的方式一致，都是通过-addAnimation:forKey:方法。但是和属性动画不同的是，对指定的图层一次只能使用一次CATransition，因此，无论你对动画的键设置什么值，过渡动画都会对它的键设置成“transition”，也就是常量kCATransition。 */
    
    UIImage *image = [UIImage imageNamed:@"5"];
    self.mainView.layer.contents = (__bridge id _Nullable)(image.CGImage);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        CATransition *transition = [CATransition animation];
        transition.type = kCATransitionFade;
        transition.duration = 2.0f;
        UIImage *image1 = [UIImage imageNamed:@"2"];
        self.mainView.layer.contents = (__bridge id _Nullable)(image1.CGImage);
        [self.mainView.layer addAnimation:transition forKey:nil];
        
    });
    
}

#pragma mark - 动画结束后模型树的值并没有改变，layer的属性值并没有改变

- (void)test18 {
    
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position";
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(300, 300)];
    animation.duration = 2.0f;
    animation.delegate = self;
    
    //如果fillMode=kCAFillModeForwards和removedOnComletion=NO，那么在动画执行完毕后，图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.mainView.layer addAnimation:animation forKey:nil];
}

#pragma mark - timeOffset使用

- (void)test19 {
    
    /** timeOffset一个很有用的功能在于你可以它可以让你手动控制动画进程，通过设置speed为0，可以禁用动画的自动播放，然后来使用timeOffset来来回显示动画序列。这可以使得运用手势来手动控制动画变得很简单。
     
     举个简单的例子：还是之前关门的动画，修改代码来用手势控制动画。我们给视图添加一个UIPanGestureRecognizer，然后用timeOffset左右摇晃。
     
     因为在动画添加到图层之后不能再做修改了，我们来通过调整layer的timeOffset达到同样的效果（清单9.4）。
     */
    
    //add the door
    self.doorLayer = [CALayer layer];
    self.doorLayer.frame = CGRectMake(0, 0, 128, 256);
    self.doorLayer.position = CGPointMake(150 - 64, 150);
    self.doorLayer.anchorPoint = CGPointMake(0, 0.5);
    self.doorLayer.contents = (__bridge id)[UIImage imageNamed:@"5"].CGImage;
    [self.view.layer addSublayer:self.doorLayer];
    //apply perspective transform
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    self.mainView.layer.sublayerTransform = perspective;
    //add pan gesture recognizer to handle swipes
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] init];
    [pan addTarget:self action:@selector(pan:)];
    [self.view addGestureRecognizer:pan];
    //pause all layer animations
    self.doorLayer.speed = 0.0;
    //apply swinging animation (which won't play because layer is paused)
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.y";
    animation.toValue = @(-M_PI_2);
    animation.duration = 1.0;
    [self.doorLayer addAnimation:animation forKey:nil];
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    //get horizontal component of pan gesture
    CGFloat x = [pan translationInView:self.view].x;
    //convert from points to animation duration //using a reasonable scale factor
    x /= 200.0f;
    //update timeOffset and clamp result
    CFTimeInterval timeOffset = self.doorLayer.timeOffset;
    timeOffset = MIN(0.999, MAX(0.0, timeOffset - x));
    self.doorLayer.timeOffset = timeOffset;
    //reset pan gesture
    [pan setTranslation:CGPointZero inView:self.view];
}

#pragma mark - CAMediaTimingFunction

- (void)test20 {
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position";
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(300, 300)];
    animation.duration = 2.0f;
    animation.delegate = self;
    
    //设置动画缓冲函数
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    
    //如果fillMode=kCAFillModeForwards和removedOnComletion=NO，那么在动画执行完毕后，图层会保持显示动画执行后的状态。但在实质上，图层的属性值还是动画执行前的初始值，并没有真正被改变。
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    [self.mainView.layer addAnimation:animation forKey:nil];
}



#pragma mark - Init

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
