//
//  AudioSessionManager.m
//
//  Copyright 2011 Jawbone Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

#import "AudioSessionManager.h"

typedef enum:int
{
    Airpod = 0,
    Speaker,
    Phone,
    Headset
    
} AudioRoute;
@interface AudioSessionManager () {    // private
    
    NSString    *mMode;
    
    BOOL         mBluetoothDeviceAvailable;
    BOOL         mHeadsetDeviceAvailable;
    
    BOOL         didAddObserver;
    
    AudioRoute   currentRoute;
    
    NSArray        *mAvailableAudioDevices;
}

@property (nonatomic, assign)        BOOL             bluetoothDeviceAvailable;
@property (nonatomic, assign)        BOOL             headsetDeviceAvailable;
@property (nonatomic, strong)        NSArray            *availableAudioDevices;

@end

NSString *kAudioSessionManagerMode_Record       = @"AudioSessionManagerMode_Record";
NSString *kAudioSessionManagerMode_Playback     = @"AudioSessionManagerMode_Playback";

NSString *kAudioSessionManagerDevice_Headset    = @"AudioSessionManagerDevice_Headset";
NSString *kAudioSessionManagerDevice_Bluetooth  = @"AudioSessionManagerDevice_Bluetooth";
NSString *kAudioSessionManagerDevice_Phone      = @"AudioSessionManagerDevice_Phone";
NSString *kAudioSessionManagerDevice_Speaker    = @"AudioSessionManagerDevice_Speaker";

// use normal logging if custom macros don't exist
#ifndef NSLogWarn
#define NSLogWarn NSLog
#endif

#ifndef NSLogError
#define NSLogError NSLog
#endif

#ifndef NSLogDebug
#define LOG_LEVEL 3
#define NSLogDebug(frmt, ...)    do{ if(LOG_LEVEL >= 4) NSLog((frmt), ##__VA_ARGS__); } while(0)
#endif

@implementation AudioSessionManager

@synthesize headsetDeviceAvailable      = mHeadsetDeviceAvailable;
@synthesize bluetoothDeviceAvailable    = mBluetoothDeviceAvailable;
@synthesize availableAudioDevices       = mAvailableAudioDevices;

#pragma mark -
#pragma mark Singleton

#pragma mark - Singleton

#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname) \
+ (classname*)sharedInstance { \
static classname* __sharedInstance; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
__sharedInstance = [[classname alloc] init]; \
}); \
return __sharedInstance; \
}

SYNTHESIZE_SINGLETON_FOR_CLASS(AudioSessionManager);

- (id)init
{
    if ((self = [super init])) {
        mMode = kAudioSessionManagerMode_Playback;
    }
    
    return self;
}

#pragma mark private functions
- (BOOL)configureAudioSessionWithDesiredAudioRoute:(NSString *)desiredAudioRoute
{
    NSLogDebug(@"current mode: %@", mMode);
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err;
    
    if ((mMode == kAudioSessionManagerMode_Record) && !audioSession.inputAvailable) {
        NSLogWarn(@"device does not support recording");
        return NO;
    }
    
    /*
     * Need to always use AVAudioSessionCategoryPlayAndRecord to redirect output audio per
     * the "Audio Session Programming Guide", so we only use AVAudioSessionCategoryPlayback when
     * !inputIsAvailable - which should only apply to iPod Touches without external mics.
     */
    NSString *audioCat = ((mMode == kAudioSessionManagerMode_Playback) && !audioSession.inputAvailable) ?
    AVAudioSessionCategoryPlayback : AVAudioSessionCategoryPlayAndRecord;
    
    if (![audioSession setCategory:audioCat withOptions:((desiredAudioRoute == kAudioSessionManagerDevice_Bluetooth) ? AVAudioSessionCategoryOptionAllowBluetooth : 0) error:&err]) {
        NSLogWarn(@"unable to set audioSession category: %@", err);
        return NO;
    }
    
    // Set our session to active...
    if (![audioSession setActive:YES error:&err]) {
        NSLogWarn(@"unable to set audio session active: %@", err);
        return NO;
    }
    
    if (desiredAudioRoute == kAudioSessionManagerDevice_Speaker) {
        // replace AudiosessionSetProperty (deprecated from iOS7) with AVAudioSession overrideOutputAudioPort
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&err];
    }
    
    else
    {
        [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:&err];
    }
    if(!defaultToReceiver)
    {
        AVAudioSessionRouteDescription *newRoute = [audioSession currentRoute];
        
        if(newRoute.outputs.count > 0)
        {
            NSString *newOutput = [[newRoute.outputs objectAtIndex:0] portType];
            if([newOutput isEqualToString:AVAudioSessionPortBuiltInReceiver])
            {
                [audioSession overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&err];
            }
        }
    }
    // Display our current route...
    NSLogDebug(@"current route: %@", self.audioRoute);
    
    return YES;
}

- (BOOL)detectAvailableDevices
{
    // called on startup to initialize the devices that are available...
    NSLogDebug(@"detectAvailableDevices");
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err;
    
    // close down our current session...
    //    [audioSession setActive:NO error:nil];
    
    // start a new audio session. Without activation, the default route will always be (inputs: null, outputs: Speaker)
    [audioSession setActive:YES error:nil];
    
    // Open a session and see what our default is...
    if (![audioSession setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:&err]) {
        NSLogWarn(@"unable to set audioSession category: %@", err);
        return NO;
    }
    
    // Check for a wired headset...
    AVAudioSessionRouteDescription *currentRoute = [audioSession currentRoute];
    for (AVAudioSessionPortDescription *output in currentRoute.outputs) {
        if ([[output portType] isEqualToString:AVAudioSessionPortHeadphones]) {
            self.headsetDeviceAvailable = YES;
        } else if ([self isBluetoothDevice:[output portType]]) {
            self.bluetoothDeviceAvailable = YES;
        }
    }
    // In case both headphones and bluetooth are connected, detect bluetooth by inputs
    // Condition: iOS7 and Bluetooth input available
    if ([audioSession respondsToSelector:@selector(availableInputs)]) {
        for (AVAudioSessionPortDescription *input in [audioSession availableInputs]){
            if ([self isBluetoothDevice:[input portType]]){
                self.bluetoothDeviceAvailable = YES;
                break;
            }
        }
    }
    
    if (self.headsetDeviceAvailable) {
        NSLogDebug(@"Found Headset");
    }
    
    if (self.bluetoothDeviceAvailable) {
        NSLogDebug(@"Found Bluetooth");
    }
    
    return YES;
}

- (void)currentRouteChanged:(NSNotification *)notification
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    
    NSInteger changeReason = [[notification.userInfo objectForKey:AVAudioSessionRouteChangeReasonKey] integerValue];
    
    AVAudioSessionRouteDescription *oldRoute = [notification.userInfo objectForKey:AVAudioSessionRouteChangePreviousRouteKey];
    NSArray *oldOuputArr = oldRoute.outputs;
    
    if(oldOuputArr.count == 0)
        return;
    
    NSString *oldOutput = [[oldRoute.outputs objectAtIndex:0] portType];
    AVAudioSessionRouteDescription *newRoute = [audioSession currentRoute];
    NSArray *output = newRoute.outputs;
    
    if(output.count == 0)
        return;
    
    NSString *newOutput = [[newRoute.outputs objectAtIndex:0] portType];
    switch (changeReason) {
        case AVAudioSessionRouteChangeReasonOldDeviceUnavailable:
        {
            if ([oldOutput isEqualToString:AVAudioSessionPortHeadphones]) {
                
                self.headsetDeviceAvailable = NO;
                if([self isBluetoothDevice:newOutput])
                    currentRoute = Airpod;
                
                else if(defaultToReceiver)
                    currentRoute = Phone;
                
                else
                    currentRoute = Speaker;
            } else if ([self isBluetoothDevice:oldOutput]) {
                BOOL showBluetooth = NO;
                // Additional checking for iOS7 devices (more accurate)
                // when multiple blutooth devices connected, one is no longer available does not mean no bluetooth available
                if ([audioSession respondsToSelector:@selector(availableInputs)]) {
                    NSArray *inputs = [audioSession availableInputs];
                    for (AVAudioSessionPortDescription *input in inputs){
                        if ([self isBluetoothDevice:[input portType]]){
                            showBluetooth = YES;
                            break;
                        }
                    }
                }
                if (!showBluetooth) {
                    currentRoute = Speaker;
                    self.bluetoothDeviceAvailable = NO;
                }
            }
        }
            break;
            
        case AVAudioSessionRouteChangeReasonNewDeviceAvailable:
        {
            if ([self isBluetoothDevice:newOutput]) {
                currentRoute = Airpod;
                self.bluetoothDeviceAvailable = YES;
            } else if ([newOutput isEqualToString:AVAudioSessionPortHeadphones]) {
                self.headsetDeviceAvailable = YES;
                currentRoute = Headset;
            }
        }
            break;
            
        case AVAudioSessionRouteChangeReasonOverride:
        {
            if ([self isBluetoothDevice:oldOutput]) {
                if ([audioSession respondsToSelector:@selector(availableInputs)]) {
                    BOOL showBluetooth = NO;
                    NSArray *inputs = [audioSession availableInputs];
                    for (AVAudioSessionPortDescription *input in inputs){
                        if ([self isBluetoothDevice:[input portType]]){
                            showBluetooth = YES;
                            break;
                        }
                    }
                    if (!showBluetooth) {
                        currentRoute = Speaker;
                        self.bluetoothDeviceAvailable = NO;
                    }
                } else if ([newOutput isEqualToString:AVAudioSessionPortBuiltInReceiver]) {
                    currentRoute = Speaker;
                    self.bluetoothDeviceAvailable = NO;
                }
            }
            else if ([newOutput isEqualToString:AVAudioSessionPortBuiltInSpeaker]) {
                currentRoute = Speaker;
            }
        }
            break;
        case AVAudioSessionRouteChangeReasonCategoryChange:
        {
            if([newOutput isEqual:AVAudioSessionPortBuiltInReceiver])
            {
                currentRoute = Phone;
            }
            else if([newOutput isEqual:AVAudioSessionPortBuiltInSpeaker])
            {
                currentRoute = Speaker;
            }
            else if([self isBluetoothDevice:newOutput])
            {
                currentRoute = Airpod;
            }
            else if ([oldOutput isEqualToString:AVAudioSessionPortHeadphones])
            {
                currentRoute = Headset;
            }
        }
            break;
        default:
            break;
    }
    //    [self.delegate AudioSessionManagerRouteDidChangeTo:self.audioRoute];
    [self monitorProximity];
}

- (BOOL)isBluetoothDevice:(NSString*)portType {
    
    return ([portType isEqualToString:AVAudioSessionPortBluetoothA2DP] ||
            [portType isEqualToString:AVAudioSessionPortBluetoothHFP]);
}

- (void)redirectAudio
{
    AVAudioSessionRouteDescription *currentRoute = [[AVAudioSession sharedInstance] currentRoute];
    NSString *output = [[currentRoute.outputs objectAtIndex:0] portType];
    
    if ([output isEqualToString:AVAudioSessionPortBuiltInReceiver]) {
        if(currentRoute == Airpod)
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        else
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    } else if ([output isEqualToString:AVAudioSessionPortBuiltInSpeaker]) {
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    }
    // Airpods Routing
    else {
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    }
}
// Detect when the iPhone is near the ear
-(void) monitorProximity
{
    if(currentRoute == Airpod)
    {
        // If Airpods connected while Sound was at the Receiver, Don't Stop Monitoring
        AVAudioSessionRouteDescription *currentRoute = [[AVAudioSession sharedInstance] currentRoute];
        NSString *output = [[currentRoute.outputs objectAtIndex:0] portType];
        
        if ([output isEqualToString:AVAudioSessionPortBuiltInReceiver]) {
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
            
            if(!proximityDisabled)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
                });
            }
        }
        else if ([self isBluetoothDevice:output]) {
            if(!proximityDisabled)
            {
                if([UIDevice currentDevice].proximityState)
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIDevice currentDevice].proximityMonitoringEnabled = YES;
                    });
                else
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [UIDevice currentDevice].proximityMonitoringEnabled = YES;
                    });
            }
        }
    }
    else if(currentRoute == Headset)
    {
        if(!proximityDisabled)
        {
            if([UIDevice currentDevice].proximityState)
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
                });
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
                });
            }
        }
    }
    else if(currentRoute == Speaker)
    {
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        
        if(!proximityDisabled)
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [UIDevice currentDevice].proximityMonitoringEnabled = YES;
                });
            });
    }
    else if(currentRoute == Phone)
    {
        [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
        if(!proximityDisabled)
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIDevice currentDevice].proximityMonitoringEnabled = YES;
            });
    }
    else
    {
        if(!proximityDisabled)
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIDevice currentDevice].proximityMonitoringEnabled = YES;
            });
    }
    
}

- (void)proximityChanged:(NSNotification *)notification
{
    UIDevice *device = [notification object];
    
    if(currentRoute == Airpod)
    {
        device.proximityMonitoringEnabled = NO;
    }
    else if(currentRoute == Headset)
    {
        device.proximityMonitoringEnabled = NO;
    }
    else
    {
        if(device.proximityState)
        {
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
        }
        else
        {
            [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
        }
    }
}

#pragma mark public method

- (void)startWithDefaultToReceiver
{
    defaultToReceiver = YES;
    proximityDisabled = YES;
    [self start];
}
- (void)startWithProximityDisabled
{
    proximityDisabled = YES;
    [self start];
}
- (void)start
{
    if(didAddObserver)
    {
        if(!proximityDisabled)
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIDevice currentDevice].proximityMonitoringEnabled = YES;
            });
        return;
    }
    
    didAddObserver = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(proximityChanged:)
                                                 name:@"UIDeviceProximityStateDidChangeNotification"
                                               object:[UIDevice currentDevice]];
    
    if(myQueue == nil)
        myQueue = dispatch_queue_create("AudioKit", nil);
    dispatch_async(myQueue, ^{
        [self detectAvailableDevices];
        
        [self monitorProximity];
        
        [self configureAudioSessionWithDesiredAudioRoute:kAudioSessionManagerDevice_Bluetooth];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(currentRouteChanged:)
                                                     name:AVAudioSessionRouteChangeNotification object:nil];
    });
    
}

- (void)end
{
    didAddObserver = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIDevice currentDevice].proximityMonitoringEnabled = NO;
    });
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pause
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIDevice currentDevice].proximityMonitoringEnabled = YES;
    });
}

#pragma mark public methods/properties

- (BOOL)changeMode:(NSString *)value
{
    if (mMode == value)
        return YES;
    
    mMode = value;
    
    return [self configureAudioSessionWithDesiredAudioRoute:kAudioSessionManagerDevice_Bluetooth];
}

- (NSString *)audioRoute
{
    AVAudioSessionRouteDescription *currentRoute = [[AVAudioSession sharedInstance] currentRoute];
    
    if(currentRoute.outputs.count == 0)
        return @"Unknown Device";
    
    NSString *output = [[currentRoute.outputs objectAtIndex:0] portType];
    
    if ([output isEqualToString:AVAudioSessionPortBuiltInReceiver]) {
        return kAudioSessionManagerDevice_Phone;
    } else if ([output isEqualToString:AVAudioSessionPortBuiltInSpeaker]) {
        return kAudioSessionManagerDevice_Speaker;
    } else if ([output isEqualToString:AVAudioSessionPortHeadphones]) {
        return kAudioSessionManagerDevice_Headset;
    } else if ([self isBluetoothDevice:output]) {
        return kAudioSessionManagerDevice_Bluetooth;
    } else {
        return @"Unknown Device";
    }
}

- (void)setBluetoothDeviceAvailable:(BOOL)value
{
    if (mBluetoothDeviceAvailable == value) {
        return;
    }
    
    mBluetoothDeviceAvailable = value;
    
    self.availableAudioDevices = nil;
}

- (void)setHeadsetDeviceAvailable:(BOOL)value
{
    if (mHeadsetDeviceAvailable == value) {
        return;
    }
    
    mHeadsetDeviceAvailable = value;
    
    self.availableAudioDevices = nil;
}

- (void)setAudioRoute:(NSString *)audioRoute
{
    if ([self audioRoute] == audioRoute) {
        return;
    }
    
    [self configureAudioSessionWithDesiredAudioRoute:audioRoute];
}

- (BOOL)phoneDeviceAvailable
{
    return YES;
}

- (BOOL)speakerDeviceAvailable
{
    return YES;
}

- (NSArray *)availableAudioDevices
{
    if (!mAvailableAudioDevices) {
        NSMutableArray *devices = [[NSMutableArray alloc] initWithCapacity:4];
        
        if (self.bluetoothDeviceAvailable)
            [devices addObject:kAudioSessionManagerDevice_Bluetooth];
        
        if (self.headsetDeviceAvailable)
            [devices addObject:kAudioSessionManagerDevice_Headset];
        
        if (self.speakerDeviceAvailable)
            [devices addObject:kAudioSessionManagerDevice_Speaker];
        
        if (self.phoneDeviceAvailable)
            [devices addObject:kAudioSessionManagerDevice_Phone];
        
        self.availableAudioDevices = devices;
    }
    
    return mAvailableAudioDevices;
}
@end
