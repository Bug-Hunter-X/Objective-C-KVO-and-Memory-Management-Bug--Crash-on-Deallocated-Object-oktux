The solution is to always remove the observer before the observed object is deallocated:

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

        // Correctly remove the observer before releasing the object
        [observedObject removeObserver:observer forKeyPath:@"observedProperty"];
        [observedObject release];
        [observer release];
    }
    return 0;
}
```

By ensuring that `removeObserver:` is called before releasing the observed object, we prevent the crash and ensure proper memory management.