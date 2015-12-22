//
//  TaskManager.h
//  RYTong
//
//  Copyright 2011 RYTong. All rights reserved.
//

@class Task;
@class HTTPConnection;
@class Thread;

@interface TaskManager : NSObject {
    
    // asynchronous task list
    NSMutableArray                  *asynchronousTaskArray_;
    
    // synchronous task list
    NSMutableArray                  *synchronousTaskArray_;
    
    // the thread for synchronous task list
    Thread                          *thread_;
    
}


@property (nonatomic, retain) NSMutableArray *asynchronousTaskArray_;
@property (nonatomic, retain) NSMutableArray *synchronousTaskArray_;


/** return a instance of TaskManager    */
+ (TaskManager *) sharedTaskManager;

/** return a task from task list    */
- (Task *) getTaskFromAsynchrousAarrayByIndex:(int)index;
- (Task *) getTaskFromSynchrousAarrayByIndex:(int)index;
- (Task *) getTaskFromName:(NSString *)name;
- (Task *) getTaskFromURLConnection:(NSURLConnection *)connection;


/**  Create a new task and add it to array  */
- (void) addTaskToAsynchronousArray:(NSString *)name httpConnection:(HTTPConnection *)connection showWaitDialogFS:(BOOL)isFs showWaitDialogHS:(BOOL)isHs noCancel:(BOOL)noCancel;
- (void) addTaskToAsynchronousArrayInOneTask:(NSString *)name httpConnection:(HTTPConnection *)connection;
- (void) addTaskToSynchronousArray:(NSString *)name httpConnection:(HTTPConnection *)connection;
- (void) addTaskToSynchronousArrayInOneTask:(NSString *)name httpConnection:(HTTPConnection *)connection;

//- (void) startSynchronous

/**  Add a new task to array  */
- (void) addTaskToAsynchronousArray:(Task *)task;
- (void) addTaskToSynchronousArray:(Task *)task;


/**  Remove task  */
- (BOOL) removeTaskFromArray:(Task *)task;
- (BOOL) removeTaskFromAsynchronousArray:(Task *)task;
- (BOOL) removeTaskFromSynchronousArray:(Task *)task;
- (BOOL) removeTaskFromAsynchronousArrayById:(int)index;
- (BOOL) removeTaskFromSynchronousArrayById:(int)index;
- (BOOL) removeTaskFromAsynchronousArrayByName:(NSString *)name;
- (BOOL) removeTaskFromSynchronousArrayByName:(NSString *)name;
- (void) removeAllTaskFromSynchronousArray;

/** Notify the thread for synchronous task list **/
- (void) notifyThread:(BOOL)noCancel showFullSWaitD:(BOOL)showFWD showHalfSWaitD:(BOOL)showHWD;

@end
