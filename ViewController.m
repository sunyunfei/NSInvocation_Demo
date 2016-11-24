//
//  ViewController.m
//  NSInvocation_Demo
//
//  Created by 孙云飞 on 16/11/24.
//  Copyright © 2016年 孙云飞. All rights reserved.
//
/*
 IOS中有一个类型是SEL，它的作用很相似与函数指针，通过performSelector:withObject:函数可以直接调用这个消息。但是perform相关的这些函数，有一个局限性，其参数数量不能超过2个，否则要做很麻烦的处理，与之相对，NSInvocation也是一种消息调用的方法，并且它的参数没有限制。这两种直接调用对象消息的方法，在IOS4.0之后，大多被block结构所取代，只有在很老的兼容性系统中才会使用
 */
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
    [self test2];
    [self test3];
}


- (void)test1{

    //demo1
    SEL method1 = @selector(myMethod);
    //创建,创建一个函数签名，这个签名可以是任意的,但需要注意，签名函数的参数数量要和调用的一致。
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:@selector(init)];
    //通过签名初始化
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    //设置tag
    [invocation setTarget:self];
    //设置selector
    [invocation setSelector:method1];
    //消息的调用
    [invocation invoke];

}

- (void)myMethod{

    NSLog(@"this is one test");
}

#pragma mark --------test2
- (void)test2{

    //方法
    SEL method2 = @selector(myMthod2:);
    //创建一个函数签名
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:method2];
    //通过签名初始化
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    //设置
    [invocation setTarget:self];
    [invocation setSelector:method2];
    //参数
    int a = 10;
    [invocation setArgument:&a atIndex:2];
    [invocation invoke];
}

- (void)myMthod2:(int )a{

    NSLog(@"this is second test,value=%i",a);
}

#pragma mark -----test3
//有返回值.
- (void)test3{

    SEL mythod3 = @selector(myMthod3:andB:);
    NSMethodSignature *sig = [[self class] instanceMethodSignatureForSelector:mythod3];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:sig];
    [invocation setTarget:self];
    [invocation setSelector:mythod3];
    
    int a =100;
    int b = 200;
    [invocation setArgument:&a atIndex:2];
    [invocation setArgument:&b atIndex:3];
    [invocation retainArguments];//- (void)retainArguments;这个方法，它会将传入的所有参数以及target都retain一遍。retain所有参数，防止参数被释放dealloc
    [invocation invoke];
    
    int d;
    [invocation getReturnValue:&d];
    NSLog(@"d= %i",d);
    
}

- (int)myMthod3:(int )a andB:(int)b{

    NSLog(@"a=%i,b=%i",a,b);
    return a+b;
}
@end
