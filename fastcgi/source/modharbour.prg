//----------------------------------------------------------------//

function AP_Args()

return ap_GetEnv( "QUERY_STRING" )   

//----------------------------------------------------------------//

function AP_FileName()

return ap_GetEnv( "SCRIPT_FILENAME" )

//----------------------------------------------------------------//

function AP_Method()

return ap_GetEnv( "REQUEST_METHOD" )

//----------------------------------------------------------------//

function AP_UserIP()

return ap_GetEnv( "REMOTE_ADDR" )

//----------------------------------------------------------------//

#pragma BEGINDUMP

#include <hbapi.h>
#include <fcgi_stdio.h>

static FCGX_Stream * g_in, * g_out, * g_err;
static FCGX_ParamArray g_envp;

HB_FUNC( FCGI_ACCEPT )
{
   hb_retnl( FCGX_Accept( &g_in, &g_out, &g_err, &g_envp ) );
}

HB_FUNC( AP_GETENV )
{
   hb_retc( FCGX_GetParam( hb_parc( 1 ), g_envp ) );
}

int mh_rputs( const char * szText )
{
   return FCGX_FPrintF( g_out, "%s", szText );
}

HB_FUNC( PRINTF )
{
   FCGX_FPrintF( g_out, "%s", hb_parc( 1 ) );
}

HB_FUNC( AP_BODY )
{
   char * szMethod = FCGX_GetParam( "REQUEST_METHOD", g_envp );

   if( ! strcmp( szMethod, "POST" ) ) 
   {
      int iLen = atoi( FCGX_GetParam( "CONTENT_LENGTH", g_envp ) );
      char * bufp = hb_xgrab( iLen + 1 );
      FCGX_GetStr( bufp, iLen, g_in );
      hb_retclen( bufp, iLen );
      hb_xfree( bufp );
   }
   else
      hb_retc( "" );   
}

HB_FUNC( SETEXITSTATUS )
{
   FCGI_SetExitStatus( hb_parni( 1 ) );   
}

HB_FUNC( AP_HEADERSOUTSET )
{
   FCGX_FPrintF( g_out, hb_parc( 1 ) );
   FCGX_FPrintF( g_out, "\r\n\r\n" );
}

HB_FUNC( AP_SETCONTENTTYPE )
{
}

int ap_headers_in_count( void )
{
   return 0;
}

HB_FUNC( AP_HEADERSINCOUNT )
{
   hb_retni( ap_headers_in_count() );
}

int ap_headers_out_count( void )
{
   return 0;
}

HB_FUNC( AP_HEADERSOUTCOUNT )
{
   hb_retni( ap_headers_out_count() );
}

const char * ap_headers_in_key( int iKey )
{
   iKey = iKey;
   return "";
}

HB_FUNC( AP_HEADERSINKEY )
{
   hb_retc( ap_headers_in_key( hb_parni( 1 ) ) );
}

const char * ap_headers_in_val( int iKey )
{
   iKey = iKey;
   return "";
}

HB_FUNC( AP_HEADERSINVAL )
{
   hb_retc( ap_headers_in_val( hb_parni( 1 ) ) );
}

const char * ap_headers_out_key( int iKey )
{
   iKey = iKey;
   return "";
}

HB_FUNC( AP_HEADERSOUTKEY )
{
   hb_retc( ap_headers_out_key( hb_parni( 1 ) ) );
}

const char * ap_headers_out_val( int iKey )
{
   iKey = iKey;
   return "";
}

HB_FUNC( AP_HEADERSOUTVAL )
{
   hb_retc( ap_headers_out_val( hb_parni( 1 ) ) );
}

#pragma ENDDUMP

//----------------------------------------------------------------//