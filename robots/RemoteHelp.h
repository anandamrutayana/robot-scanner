//-------------------------------------------------------------------------------
// Copyright 2014 IBM Corp. All Rights Reserved
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//-------------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import <IBMData/IBMData.h>

@interface RemoteHelp : IBMDataObject <IBMDataObjectSpecialization>

@property(nonatomic, copy) NSMutableDictionary *help;

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *subtext;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *screen;
@property(nonatomic, copy) NSString *color;
@property(nonatomic, copy) NSString *size;
@property(nonatomic, copy) NSString *weight;
@property(nonatomic, copy) NSString *justification;

@end
