/*
 *  MulleFoundation - the mulle-objc class library
 *
 *  MulleObjCException.h is a part of MulleFoundation
 *
 *  Copyright (C) 2011 Nat!, Mulle kybernetiK.
 *  All rights reserved.
 *
 *  Coded by Nat!
 *
 *  $Id$
 *
 */
#ifndef ns_exception__h__
#define ns_exception__h__

// the "C" interface to NSException
// by default these all just call abort

#include "ns_type.h"
#include "ns_range.h"

#include "ns_rootconfiguration.h"


static inline struct _ns_exceptionhandlertable   *MulleObjCExceptionHandlersGetTable( void)
{
   return( &_ns_get_rootconfiguration()->exception.vectors);
}

__attribute__ ((noreturn))
void   MulleObjCThrowAllocationException( size_t bytes);

__attribute__ ((noreturn))
void   MulleObjCThrowInvalidArgumentException( id format, ...);

__attribute__ ((noreturn))
void   MulleObjCThrowInvalidIndexException( NSUInteger index);

__attribute__ ((noreturn))
void   MulleObjCThrowInternalInconsistencyException( id format, ...);

__attribute__ ((noreturn))
void   MulleObjCThrowInvalidRangeException( NSRange range);

__attribute__ ((noreturn))
void   MulleObjCThrowErrnoException( id s, ...);


#pragma mark -
#pragma mark Some C Interfaces with char * (and some just for completeness)

__attribute__ ((noreturn))
void   mulle_objc_throw_allocation_exception( size_t bytes);

__attribute__ ((noreturn))
void   mulle_objc_throw_invalid_index_exception( NSUInteger index);

__attribute__ ((noreturn))
void   mulle_objc_throw_invalid_range_exception( NSRange range);

__attribute__ ((noreturn))
void   mulle_objc_throw_invalid_argument_exception( char *format, ...);

__attribute__ ((noreturn))
void   mulle_objc_throw_errno_exception( char *format, ...);

__attribute__ ((noreturn))
void   mulle_objc_throw_internal_inconsistency_exception( char *format, ...);


#pragma mark -
#pragma mark Uncaught Exceptions

typedef void   NSUncaughtExceptionHandler( void *exception);

NSUncaughtExceptionHandler *NSGetUncaughtExceptionHandler( void);
void   NSSetUncaughtExceptionHandler( NSUncaughtExceptionHandler *handler);

#endif
