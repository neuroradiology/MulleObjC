/*
 *  MulleFoundation - A tiny Foundation replacement
 *
 *  NSObjectCArray.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#include "MulleObjCFunctions.h"

#include <mulle_objc_runtime/mulle_objc_runtime.h>
#include "ns_rootconfiguration.h"


char   *NSGetSizeAndAlignment( char *type, NSUInteger *size, NSUInteger *alignment)
{
   struct mulle_objc_typeinfo   info;
   char                         *next;
   
   assert( type);
   
   if( ! size && ! alignment)
      return( mulle_objc_signature_supply_next_typeinfo( type, NULL));
   
   next = mulle_objc_signature_supply_next_typeinfo( type, &info);
   
   if( size)
      *size      = info.bits_size >> 3;
   if( alignment)
      *alignment = info.natural_alignment;
   
   return( next);
}


void   MulleObjCMakeObjectsPerformSelector( id *objects, unsigned int n, SEL sel, id argument)
{
   mulle_objc_methodimplementation_t   lastSelIMP[ 16];
   struct _mulle_objc_class            *lastIsa[ 16];
   struct _mulle_objc_class            *thisIsa;
   unsigned int                        i;
   id                                  p;
   id                                  *sentinel;
   mulle_objc_methodimplementation_t   (*lookup)( struct _mulle_objc_class *, mulle_objc_methodid_t);
   mulle_objc_methodimplementation_t   imp;
   
   memset( lastIsa, 0, sizeof( lastIsa));
   
   lookup   = _mulle_objc_class_lookup_or_search_methodimplementation_no_forward;
   sentinel = &objects[ n];
   
   while( objects < sentinel)
   {
      p = *objects++;
      assert( p);
      
      // our IMP cacheing thing
      thisIsa = _mulle_objc_object_get_isa( p);
      i       = ((uintptr_t) thisIsa >> 4) & 15;
      
      if( lastIsa[ i] != thisIsa)
      {
         imp = (*lookup)( thisIsa, sel);
         if( ! imp)
            imp = mulle_objc_object_call;
         
         lastIsa[ i]    = thisIsa;
         lastSelIMP[ i] = imp;
      }
      
      (*lastSelIMP[ i])( p, sel, argument);
   }
}


void   MulleObjCMakeObjectsPerformSelector2( id *objects, unsigned int n, SEL sel, id argument, id argument2)
{
   IMP            lastSelIMP[ 16];
   Class          lastIsa[ 16];
   Class          thisIsa;
   unsigned int   i;
   id             p;
   id             *sentinel;
   mulle_objc_methodimplementation_t   (*lookup)( struct _mulle_objc_class *, mulle_objc_methodid_t);
   mulle_objc_methodimplementation_t    imp;
   struct { id a; id b; }  _param = { .a = argument, .b = argument2 };
   
   memset( lastIsa, 0, sizeof( lastIsa));
   
   // assume compiler can do unrolling
   lookup   = _mulle_objc_class_lookup_or_search_methodimplementation_no_forward;
   sentinel = &objects[ n];
   
   while( objects < sentinel)
   {
      p = *objects++;
      assert( p);
      
      // our IMP cacheing thing
      thisIsa = _mulle_objc_object_get_isa( p);
      i       = ((uintptr_t) thisIsa >> 4) & 15;
      
      if( lastIsa[ i] != thisIsa)
      {
         imp = (*lookup)( thisIsa, sel);
         if( ! imp)
            imp = mulle_objc_object_call;
         
         lastIsa[ i]    = thisIsa;
         lastSelIMP[ i] = imp;
      }
      
      (*lastSelIMP[ i])( p, sel, &_param);
   }
}


# pragma mark -
# pragma mark String Functions

void   *MulleObjCStringFromClass( Class cls)
{
   if( ! cls)
      return( NULL);
   return( _ns_string( _mulle_objc_class_get_name( cls)));
}


void   *MulleObjCStringFromSelector( SEL sel)
{
   char                                  *s;
   struct _mulle_objc_methoddescriptor   *desc;
   struct _mulle_objc_runtime            *runtime;
   
   runtime = mulle_objc_get_runtime();
   desc    = _mulle_objc_runtime_lookup_methoddescriptor( runtime, (mulle_objc_methodid_t) sel);
   s       = desc ? _mulle_objc_methoddescriptor_get_name( desc) : "<invalid selector>";
   
   return( _ns_string( s));
}


Class   MulleObjCClassFromString( void *obj)
{
   char                         *s;
   struct _mulle_objc_runtime   *runtime;
   struct _mulle_objc_class     *cls;
   mulle_objc_classid_t         classid;
   
   if( ! obj)
      return( Nil);
   
   s       = _ns_characters( obj);
   classid = mulle_objc_classid_from_string( s);

   runtime = mulle_objc_get_runtime();
   cls     = _mulle_objc_runtime_lookup_class( runtime, classid);
   
   return( (Class) cls);
}


SEL     MulleObjCSelectorFromString( void *obj)
{
   char                    *s;
   mulle_objc_methodid_t   methodid;
   
   if( ! obj)
      return( 0);
   
   s        = _ns_characters( obj);
   methodid = mulle_objc_classid_from_string( s);
   
   return( (SEL) methodid);
}