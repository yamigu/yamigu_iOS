//
//  UIWebVIewGuide.h
//  GuideApp
//
//  Created by iOSDev on 2018. 8. 29..
//  Copyright © 2018년 Nice. All rights reserved.
//

#import "UIWebVIewGuide.h"



@implementation UIWebVIewGuide
- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *url =  [NSString stringWithFormat:@"%@", @"http://106.10.39.154:5000/checkplus_main"];	//회원사의 휴대폰본인확인 호출url을 입력해 주세요.
    
  
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0f];
  
    [request setHTTPMethod:@"POST"];
    
    
    
    [_webView loadRequest:request];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
	
	//일반 적인 링크이동 처리(http 또는 https로 시작)
    if ([urlString hasPrefix:@"http"]) {
		//앱설치 링크로 진입시 별도 처리(https://itunes.apple.com/kr/app/id~~~~~~)
        if ([urlString hasPrefix:@"https://itunes.apple.com"]) {
			//앱스토어 연결
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            return NO;	//반드시 NO로 설정해주세요.
        }
        else {
            //일반 웹 페이지 링크 처리
            return YES;	//반드시 YES로 설정해 주셔야합니다.
        }
    } else {
        if ( [urlString hasPrefix:@"tauthlink"] || [urlString hasPrefix:@"ktauthexternalcall"] || [urlString hasPrefix:@"upluscorporation"] || [urlString hasPrefix:@"niceipin2"] ) {
			//외부 앱 Scheme로 URL이 시작되는 경우
			//tauthLink(SKT PASS 인증앱)
			//ktauthexternalcall(KT PASS 인증앱)
			//upluscorporation(LGU+ PASS 인증앱)
			//회원사에서 추가로 연동하고 싶은 앱스키마가 있다면 or 조건에 추가 해주세요. (예시 : niceipin2 )
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            return NO;	//반드시 NO로 설정해 주셔야합니다.
        }
    }
    return YES; //반드시 YES로 설정해주세요.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidFinishLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{

}


//상단 좌측 버튼 세팅
-(IBAction)closeBtn:(id)sender {
    [self dismissViewControllerAnimated:NO completion:^{
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
