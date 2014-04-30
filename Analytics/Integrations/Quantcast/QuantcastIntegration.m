//
//  QuantcastProvider.m
//  Analytics
//
//  Created by Travis Jeffery on 4/26/14.
//  Copyright (c) 2014 Segment.io. All rights reserved.
//

#import "QuantcastIntegration.h"
#import "Analytics.h"
#import <Quantcast-Measure/QuantcastMeasurement.h>

@implementation QuantcastIntegration

+ (void)load {
    [Analytics registerIntegration:self withIdentifier:[self name]];
}

- (id)init {
    if (self = [super init]) {
        self.name = self.class.name;
    }
    return self;
}

- (void)validate {
    self.valid = self.settings[@"apiKey"] != nil;
}

- (void)start {
    [[QuantcastMeasurement sharedInstance] setupMeasurementSessionWithAPIKey:self.settings[@"apiKey"] userIdentifier:nil labels:nil];
}

- (void)track:(NSString *)event properties:(NSDictionary *)properties options:(NSDictionary *)options {
    [[QuantcastMeasurement sharedInstance] logEvent:event withLabels:options[@"labels"]];
}

- (void)screen:(NSString *)screenTitle properties:(NSDictionary *)properties options:(NSDictionary *)options {
    [[QuantcastMeasurement sharedInstance] logEvent:screenTitle withLabels:options[@"labels"]];
}

- (void)identify:(NSString *)userId traits:(NSDictionary *)traits options:(NSDictionary *)options {
    [[QuantcastMeasurement sharedInstance] recordUserIdentifier:userId withLabels:options[@"labels"]];
}

- (void)applicationDidFinishLaunching {
    [[QuantcastMeasurement sharedInstance] beginMeasurementSessionWithAPIKey:self.settings[@"apiKey"] userIdentifier:self.settings[@"userIdentifier"] labels:self.settings[@"labels"]];
}

- (void)applicationDidEnterBackground {
    [[QuantcastMeasurement sharedInstance] pauseSessionWithLabels:self.settings[@"labels"]];
}

- (void)applicationWillEnterForeground {
    [[QuantcastMeasurement sharedInstance] resumeSessionWithLabels:self.settings[@"labels"]];
}

- (void)applicationWillTerminate {
    [[QuantcastMeasurement sharedInstance] endMeasurementSessionWithLabels:self.settings[@"labels"]];
}

#pragma mark - Private

+ (NSString *)name {
    return @"Quantcast";
}

@end
