In Objective-C, a tricky bug can arise from the interaction between KVO (Key-Value Observing) and memory management, especially when dealing with weak references. If an object is deallocated while it's still being observed, it can lead to crashes or unexpected behavior.  For example:

```objectivec
@interface MyObservedObject : NSObject
@property (nonatomic, strong) NSString *observedProperty;
@end

@implementation MyObservedObject
- (void)dealloc {
    NSLog(@"MyObservedObject deallocated");
}
@end

@interface MyObserver : NSObject
@end

@implementation MyObserver
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"observedProperty"]) {
        NSLog(@"Observed property changed: %@
", change[NSKeyValueChangeNewKey]);
    }
}
@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        MyObservedObject *observedObject = [[MyObservedObject alloc] init];
        observedObject.observedProperty = @"Initial Value";

        MyObserver *observer = [[MyObserver alloc] init];
        [observedObject addObserver:observer forKeyPath:@"observedProperty" options:NSKeyValueObservingOptionNew context:nil];

        observedObject.observedProperty = @"New Value";

        //Here's the problem: if we release observedObject before removing the observer, it will cause the crash when the object is deallocated.
        [observedObject removeObserver:observer forKeyPath:@"observedProperty"];
        [observedObject release];
        [observer release];
    }
    return 0;
}
```

This code will crash if the line `[observedObject release]` is executed before `[observedObject removeObserver:observer forKeyPath:@"observedProperty"];` because the observer is still trying to access a deallocated object.