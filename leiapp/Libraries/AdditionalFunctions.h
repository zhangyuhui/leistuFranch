//
//  AdditionalFunctions.h
//  NetWorkLib
//
//  Created by su.chuyang on 13-2-20.
//
//

#import <Foundation/Foundation.h>

@interface AdditionalFunctions : NSObject

/**
 * Description: 把域名解析为ip地址
 * Input:       hostName:域名
 * Output:
 * Return:      ip地址的字符串
 * Others:      使用getaddrinfo函数
 */
+ (NSString *)exchangeHostNameToIp:(NSString *)hostName;

#pragma mark - user code

/**
 * Description: 写入需要记录user code之类的信息到数据库
 * Input:       userCode:code数据
 *              cardNo:卡号
 * Output:
 * Return:
 * Others:      后台一般会需要客户端存储两个userCode之类的信息。这个函数现在只适用于光大信用卡掌上生活
 */
+ (BOOL)writeUserInfoToBaseWithUserCode:(NSString *)userCode andCardNo:(NSString *)cardNo;
 /**
 * Description: 获取用户的信息，信息可能包含很多东西
 * Input:
 * Output:
 * Return:      包含用户信息的字典
 * Others:
 */
+ (NSDictionary *)getUserInfoFromDataBase;

/**
 * Description: 请求后台时获取传递给后台的用户信息body体。
 * Input:
 * Output:      构建好的body体
 * Return:
 * Others:
 */
+ (BOOL)getUserInfoForHTTPBodyIntoString:(NSMutableString *)bodyString;

@end


#pragma mark 文件操作接口

/**
 * Description: 清空给定目录下的文件
 * Input:       directory:指定的目录
 * Output:
 * Return:
 * Others:      这个函数会把子目录也清除掉
 */
void clearDocumentsFiles(NSSearchPathDirectory directory);

#pragma mark check

/**
 * Description: 检查文件在documents目录下是否存在
 * Input:       fileName:要检查的文件
 * Output:
 * Return:      文件是否存在
 * Others:
 */
BOOL fileExitsAtDocumets(NSString *fileName);

#pragma mark move

/**
 * Description: 把一个目录下的文件移动到另一个目录
 * Input:       fromDirectory:要剪切的目录（老的位置）
 toDirectory:要复制的目录（新的位置）
 * Output:
 * Return:
 * Others:      只移动文件而不移动目录。这个函数基本上也是没有用的，做预备接口
 */
void moveFilesToDirectory(NSSearchPathDirectory fromDirectory,NSSearchPathDirectory toDirectory);

/**
 * Description: 把document目录下的文件移动到private中
 * Input:
 * Output:
 * Return:
 * Others:
 */
void moveFilesInDocumentToPrivate();

#pragma mark get

/**
 * Description: 获取Private目录的路径
 * Input:
 * Output:
 * Return:      private目录的路径
 * Others:
 */
NSString * getPrivatePath();


/**
 * Description: 输出目录下的所有文件
 * Input:       directory:要剪切的目录
 * Output:
 * Return:
 * Others:      以下三个get函数用以输出文件列表，调试时使用
 */
void getFilesInDirectory(NSSearchPathDirectory directory);

/**
 * Description: 输出Documents目录下某个文件夹里的所有文件
 * Input:       directory:要剪切的目录
 * Output:
 * Return:
 * Others:      共享Documents文件夹时，子文件夹也是可以用itunes获取到的，所以这个函数只做练手用
 */
void getFilesInSubDirectoryOfDocuments(NSString *adirectory);

/**
 * Description: 输出Private目录下所有的文件
 * Input:
 * Output:
 * Return:
 * Others:      Private目录是自己在Library目录下创建的，用以存放程序的数据库
 */
void getFilesInPrivate();
