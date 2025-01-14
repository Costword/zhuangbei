//
//  JShareApp.m
//  guoziyunparent
//
//  Created by LIU JIA on 2019/8/14.
//  Copyright © 2019 xuxianwang. All rights reserved.
//

#import "JShareApp.h"

static NSUInteger JSHAREPlatformOpenSafari = 12;
static NSUInteger JSHAREPlatformCopy = 13;

@implementation JShareApp

+ (void)shareWebURLWithPlatform:(JSHAREPlatform)platform title:(NSString *)title text:(NSString *)text url:(NSString *)url icon:(NSString *)iconUrl success:(ShareHandle)successHandle fail:(ShareHandle)failHandle {
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHARELink;
    message.url = url;
    message.text = text;
    message.title = title;
    if (platform == JSHAREPlatformCopy) {
        [[UIPasteboard generalPasteboard] setString:url];
        UIAlertView *Alert = [[UIAlertView alloc] initWithTitle:@"复制成功" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [Alert show];
        return;
    }
    if (platform == JSHAREPlatformOpenSafari) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        return;
    }
    message.platform = platform;
    NSData *imageData;
    if (iconUrl.length == 0) {
        imageData = UIImagePNGRepresentation([UIImage imageNamed:@"storeIMage"]);
    }else
    {
        imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:iconUrl]];
    }
    message.image = imageData;
    
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        if (error) {
            if (failHandle) {
                if (error.code == 40009) {
                    if (platform == JSHAREPlatformQQ) {
                        [[zHud shareInstance]showMessage:@"未安装QQ户端"];
                    }else
                    {
                        [[zHud shareInstance]showMessage:@"未安装微信客户端"];
                    }
                    failHandle(@(JShareAppErrorNotInstall));
                } else {
                    failHandle(@"");
                }
            }
        } else {
            if (state == JSHAREStateSuccess) {
                if (successHandle) {
                    successHandle(@"");
                }
            } else {
                if (failHandle) {
                    failHandle(@(state));
                }
            }
            
        }
    }];
}

+ (void)shareImageWithPlatform:(JSHAREPlatform)platform imageUrl:(NSString *)url OrImage:(UIImage*)image success:(ShareHandle)successHandle fail:(ShareHandle)failHandle {
    JSHAREMessage *message = [JSHAREMessage message];
    message.mediaType = JSHAREImage;
    message.title = @"邀请好友";
    [message setPlatform:(platform)];
    if (image != nil) {
//        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        NSData * imgData = UIImagePNGRepresentation(image);
        message.image = imgData;
    }else
    {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        message.image = imageData;
    }
    
    
    [JSHAREService share:message handler:^(JSHAREState state, NSError *error) {
        if (error) {
            if (failHandle) {
                if (error.code == 40009) {
                    if (platform == JSHAREPlatformQQ) {
                        [[zHud shareInstance]showMessage:@"未安装QQ户端"];
                    }else
                    {
                        [[zHud shareInstance]showMessage:@"未安装微信客户端"];
                    }
                    failHandle(@(JShareAppErrorNotInstall));
                } else {
                    if (error.code == 40003) {
                        [[zHud shareInstance]showMessage:@"配置有误"];
                    }
                    failHandle(@"");
                }
            }
        } else {
            if (state == JSHAREStateSuccess) {
                if (successHandle) {
                    successHandle(@"");
                }
            } else {
                if (failHandle) {
                    failHandle(@(state));
                }
            }
            
        }
    }];
}

@end
