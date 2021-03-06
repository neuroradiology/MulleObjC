//
//  main.m
//  test-rval
//
//  Created by Nat! on 09/11/15.
//  Copyright © 2015 Mulle kybernetiK. All rights reserved.
//
#include <mulle_objc/mulle_objc.h>


#include <limits.h>
#include <float.h>


typedef uintptr_t   NSUInteger;
typedef intptr_t    NSInteger;

#define NSIntegerMax    ((NSInteger) (((NSUInteger) -1) >> 1))
#define NSIntegerMin    (-((NSInteger) (((NSUInteger) -1) >> 1)) - 1)
#define NSUIntegerMax   ((NSUInteger) -1)
#define NSUIntegerMin   0

#define NSINTEGER_DEFINED



typedef struct   _NSRange
{
   NSUInteger   location;
   NSUInteger   length;
} NSRange;


typedef NSRange   *NSRangePointer;


static inline NSRange   NSMakeRange( NSUInteger location, NSUInteger length)
{
    NSRange    range;

    range.location = location;
    range.length   = length;
    return( range);
}


static inline int   NSEqualRanges( NSRange range1, NSRange range2)
{
    return( range1.location == range2.location && range1.length == range2.length);
}


@interface Foo

+ (id) new;

@end


@implementation Foo

+ (id) new
{
   return( mulle_objc_class_alloc_instance( self, NULL));
}


- (char) returnAChar          { return( CHAR_MAX); }
- (short) returnAShort        { return( SHRT_MIN); }
- (int) returnAnInt           { return( INT_MAX); }
- (long) returnALong          { return( LONG_MIN); }
- (long long) returnALongLong { return( LLONG_MAX); }
- (float) returnAFloat        { return( FLT_MIN); }
- (double) returnADouble      { return( DBL_MAX); }
- (NSRange) returnARange      { return( NSMakeRange( LONG_MAX, LONG_MIN)); }

- (char) returnSameChar:(char) v                   { return( v); }
- (short) returnSameShort:(short) v                { return( v); }
- (int) returnSameInt:(int) v                      { return( v); }
- (long) returnSameLong:(long) v                   { return( v); }
- (long long) returnSameLongLong:(long long) v     { return( v); }
- (float) returnSameFloat:(float) v                { return( v); }
- (double) returnSameDouble:(double) v             { return( v); }
- (NSRange) returnSameRange:(NSRange) v            { return( v); }
- (NSRange) returnJuxtaposedRange:(NSRange) v      { return( NSMakeRange( v.length, v.location)); }

@end


static void   print_assert( int a)
{
   printf( "%s\n", a ? "PASS" : "FAIL");
}


int main(int argc, const char * argv[])
{
   Foo   *foo;

   foo = [Foo new];

   {
      NSRange   a;
      NSRange   b;

      a = [foo returnARange];
      b = NSMakeRange( 0, 0);
      print_assert( a.location == LONG_MAX);
      print_assert( a.length == (NSUInteger) LONG_MIN);
   }

   print_assert( [foo returnAChar] == CHAR_MAX);
   print_assert( [foo returnAShort] == SHRT_MIN);
   print_assert( [foo returnAnInt] == INT_MAX);
   print_assert( [foo returnALong] == LONG_MIN);
   print_assert( [foo returnALongLong] == LLONG_MAX);
   print_assert( [foo returnAFloat] == FLT_MIN);
   print_assert( [foo returnADouble] == DBL_MAX);

   print_assert( [foo returnSameChar:CHAR_MIN] == CHAR_MIN);
   print_assert( [foo returnSameShort:SHRT_MAX] == SHRT_MAX);
   print_assert( [foo returnSameInt:INT_MIN] == INT_MIN);
   print_assert( [foo returnSameLong:LONG_MAX] == LONG_MAX);
   print_assert( [foo returnSameLongLong:LLONG_MIN] == LLONG_MIN);
   print_assert( [foo returnSameFloat:FLT_MAX] == FLT_MAX);
   print_assert( [foo returnSameDouble:DBL_MIN] == DBL_MIN);

   print_assert( NSEqualRanges( [foo returnARange], NSMakeRange( LONG_MAX, LONG_MIN)));
   print_assert( NSEqualRanges( [foo returnSameRange:NSMakeRange( LONG_MIN, LONG_MAX)], NSMakeRange( LONG_MIN, LONG_MAX)));

   print_assert( NSEqualRanges( [foo returnJuxtaposedRange:NSMakeRange( LONG_MAX, LONG_MIN)], NSMakeRange( LONG_MIN, LONG_MAX)));
   return 0;
}
