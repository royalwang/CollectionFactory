#import "CollectionFactoryTestCase.h"
#import "SomeObject.h"

#define EXPECTED_JSON @"{\"string\":\"abc\",\"number\":123,\"obj\":{\"arr\":[1,\"foo\"]}}"

@interface ObjectTests : XCTestCase

@end

@implementation ObjectTests

- (void)testObjectToJSONString
{
    SomeObject1 *obj = [SomeObject1 new];
    assertThat([obj jsonString], equalTo(EXPECTED_JSON));
}

- (void)testObjectToJSONData
{
    SomeObject1 *obj = [SomeObject1 new];
    NSString *json = [[NSString alloc] initWithData:[obj jsonData]
                                           encoding:NSUTF8StringEncoding];
    assertThat(json, equalTo(EXPECTED_JSON));
}

- (void)testJSONStringToSomeObject
{
    SomeObject1 *obj = [SomeObject1 objectWithJSONString:EXPECTED_JSON];
    assertThat(obj.string, equalTo(@"abc"));
    assertThatInt(obj.number, equalToInt(123));
    assertThat(obj.obj.arr, equalTo(@[@1, @"foo"]));
}

- (void)testObjectToJSONDictionaryShouldBeSensitiveToNil
{
    SomeObject1 *obj = [SomeObject1 new];
    obj.string = nil;
    assertThat([obj jsonDictionary], hasEntry(@"string", [NSNull null]));
}

- (void)testJSONToObjectContainingNilProperties
{
    SomeObject1 *obj = [SomeObject1 objectWithJSONString:@"{\"string\":null}"];
    assertThat(obj.string, nilValue());
}

- (void)testExtraPropertyIsIgnored
{
    [SomeObject1 objectWithJSONString:@"{\"abc\":123}"];
}

@end
