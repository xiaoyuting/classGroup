//
//  blumDetailList.m
//  ChuYouYun
//
//  Created by zhiyicx on 15/2/23.
//  Copyright (c) 2015年 ZhiYiForMac. All rights reserved.
//

#import "blumDetailList.h"
NSString * const kBlumStar =@"album_score";
NSString * const kBlumFirstTime = @"listingtime";
NSString * const kBlumSecondTime = @"uctime";
NSString * const kBlumOrderBuy = @"album_order_count";
NSString * const kBlumPrice = @"mzprice";
NSString * const kBlumTeacherName = @"name";
NSString * const kBlumTeacherInro = @"inro";
NSString * const kBlumTeacherHeadingImg = @"headimg";
@interface blumDetailList()
- (id)objectOrNilForKeys:(id)aKey fromDictionary:(NSDictionary *)dict;

@end
@implementation blumDetailList
@synthesize star = _star;
@synthesize firstTime = _firstTime;
@synthesize secondTime = _secondTime;
@synthesize peopleCount = _peopleCount;
@synthesize mzPrice = _mzPrice;
@synthesize name = _name;
@synthesize inro = _inro;
@synthesize headImg = _headImg;
+(instancetype)modelObjectWithDictionary:(NSDictionary *)dicts
{
    return [[self alloc] initWithDictionary:dicts];
}
- (instancetype)initWithDictionarys:(NSDictionary *)dict
{
    self = [super init];
    
    if(self && [dict isKindOfClass:[NSDictionary class]]) {
        self.star = [self objectOrNilForKeys: kBlumStar fromDictionary:dict];
        //self.uid = [self objectOrNilForKeys:kMaListCourseName fromDictionary:dict];
        self.firstTime = [self objectOrNilForKeys:kBlumFirstTime fromDictionary:dict];
        self.secondTime = [self objectOrNilForKeys:kBlumSecondTime fromDictionary:dict];
        self.peopleCount = [self objectOrNilForKeys:kBlumOrderBuy fromDictionary:dict];
        self.mzPrice = [self objectOrNilForKeys:kBlumPrice fromDictionary:dict];
        self.name = [self objectOrNilForKeys:kBlumTeacherName fromDictionary:dict];
        self.inro = [self objectOrNilForKeys:kBlumTeacherInro fromDictionary:dict];
        self.headImg = [self objectOrNilForKeys:kBlumTeacherHeadingImg fromDictionary:dict];
    }
    
    return self;
    
}

- (NSDictionary *)DictionaryRepresentation
{
    
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.star forKey:kBlumStar];
    [mutableDict setValue:self.peopleCount forKey:kBlumOrderBuy];
    [mutableDict setValue:self.firstTime forKey:kBlumFirstTime];
    [mutableDict setValue:self.secondTime forKey:kBlumSecondTime];
    [mutableDict setValue:self.mzPrice forKey:kBlumPrice];
    [mutableDict setValue:self.name forKey:kBlumTeacherName];
    [mutableDict setValue:self.inro forKey:kBlumTeacherInro];
    [mutableDict setValue:self.headImg forKey:kBlumTeacherHeadingImg];
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self DictionaryRepresentation]];
}

#pragma mark - Helper Method
- (id)objectOrNilForKeys:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.star = [aDecoder decodeObjectForKey:kBlumStar];
    self.peopleCount = [aDecoder decodeObjectForKey:kBlumOrderBuy];
    self.firstTime = [aDecoder decodeObjectForKey:kBlumFirstTime];
    self.secondTime = [aDecoder decodeObjectForKey:kBlumSecondTime];
    self.mzPrice = [aDecoder decodeObjectForKey:kBlumPrice];
    
    self.name = [aDecoder decodeObjectForKey:kBlumTeacherName];
    self.inro = [aDecoder decodeObjectForKey:kBlumTeacherInro];
    self.headImg = [aDecoder decodeObjectForKey:kBlumTeacherHeadingImg];

    
    
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    
    [aCoder encodeObject:_star forKey:kBlumStar];
    [aCoder encodeObject:_peopleCount forKey:kBlumOrderBuy];
    [aCoder encodeObject:_mzPrice forKey:kBlumPrice];
    [aCoder encodeObject:_firstTime forKey:kBlumFirstTime];
    [aCoder encodeObject:_secondTime forKey:kBlumSecondTime];

    [aCoder encodeObject:_name forKey:kBlumTeacherName];
    [aCoder encodeObject:_inro forKey:kBlumTeacherInro];
    [aCoder encodeObject:_headImg forKey:kBlumTeacherHeadingImg];
    
}

- (id)copyWithZone:(NSZone *)zone
{
    blumDetailList *copy = [[blumDetailList alloc] init];
    
    if (copy) {
        
        copy.star = [self.star copyWithZone:zone];
        copy.peopleCount = [self.peopleCount copyWithZone:zone];
        copy.firstTime = [self.firstTime copyWithZone:zone];
        copy.secondTime = [self.secondTime copyWithZone:zone];
        copy.mzPrice = [self.mzPrice copyWithZone:zone];
        copy.name = [self.name copyWithZone:zone];
        copy.inro = [self.inro copyWithZone:zone];
        copy.headImg = [self.headImg copyWithZone:zone];
    }
    
    return copy;
}

@end
