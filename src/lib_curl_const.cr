# This file is managed by 'gen/const.cr'. Do not edit.
#
# src: https://github.com/curl/curl/blob/curl-7_64_0/include/curl/curl.h
# src: https://github.com/curl/curl/blob/curl-7_64_0/include/curl/multi.h
#
# Run 'make gen' to update
#
module LibCurlConst
  # found 'CURL_SOCKET_BAD' has 2 definitions
  # CURL_SOCKET_BAD INVALID_SOCKET 
  # CURL_SOCKET_BAD -1 

  CURLSSLBACKEND_LIBRESSL  = CURLSSLBACKEND_OPENSSL
  CURLSSLBACKEND_BORINGSSL = CURLSSLBACKEND_OPENSSL
  CURLSSLBACKEND_CYASSL    = CURLSSLBACKEND_WOLFSSL

  CURL_HTTPPOST_FILENAME    = (1<<0)    
  CURL_HTTPPOST_READFILE    = (1<<1)    
  CURL_HTTPPOST_PTRNAME     = (1<<2)    
  CURL_HTTPPOST_PTRCONTENTS = (1<<3)    
  CURL_HTTPPOST_BUFFER      = (1<<4)    
  CURL_HTTPPOST_PTRBUFFER   = (1<<5)    
  CURL_HTTPPOST_CALLBACK    = (1<<6)    
  CURL_HTTPPOST_LARGE       = (1<<7)    
  CURL_MAX_READ_SIZE        = 524288    
  CURL_MAX_WRITE_SIZE       = 16384     
  CURL_MAX_HTTP_HEADER      = (100*1024)
  CURL_WRITEFUNC_PAUSE      = 0x10000001

  CURLFINFOFLAG_KNOWN_FILENAME   = (1<<0)
  CURLFINFOFLAG_KNOWN_FILETYPE   = (1<<1)
  CURLFINFOFLAG_KNOWN_TIME       = (1<<2)
  CURLFINFOFLAG_KNOWN_PERM       = (1<<3)
  CURLFINFOFLAG_KNOWN_UID        = (1<<4)
  CURLFINFOFLAG_KNOWN_GID        = (1<<5)
  CURLFINFOFLAG_KNOWN_SIZE       = (1<<6)
  CURLFINFOFLAG_KNOWN_HLINKCOUNT = (1<<7)

  CURL_CHUNK_BGN_FUNC_OK         = 0         
  CURL_CHUNK_BGN_FUNC_FAIL       = 1          # tell the lib to end the task
  CURL_CHUNK_BGN_FUNC_SKIP       = 2          # skip this chunk over
  CURL_CHUNK_END_FUNC_OK         = 0         
  CURL_CHUNK_END_FUNC_FAIL       = 1          # tell the lib to end the task
  CURL_FNMATCHFUNC_MATCH         = 0          # string corresponds to the pattern
  CURL_FNMATCHFUNC_NOMATCH       = 1          # pattern doesn't match the string
  CURL_FNMATCHFUNC_FAIL          = 2          # an error occurred
  CURL_SEEKFUNC_OK               = 0         
  CURL_SEEKFUNC_FAIL             = 1          # fail the entire transfer
  CURL_SEEKFUNC_CANTSEEK         = 2          # tell libcurl seeking can't be done, so
  CURL_READFUNC_ABORT            = 0x10000000
  CURL_READFUNC_PAUSE            = 0x10000001
  CURL_TRAILERFUNC_OK            = 0         
  CURL_TRAILERFUNC_ABORT         = 1         
  CURL_SOCKOPT_OK                = 0         
  CURL_SOCKOPT_ERROR             = 1          # causes libcurl to abort and return
  CURL_SOCKOPT_ALREADY_CONNECTED = 2         

  CURLE_OBSOLETE16 = CURLE_HTTP2             
  CURLE_OBSOLETE10 = CURLE_FTP_ACCEPT_FAILED 
  CURLE_OBSOLETE12 = CURLE_FTP_ACCEPT_TIMEOUT

  CURLOPT_ENCODING = CURLOPT_ACCEPT_ENCODING

  CURLE_FTP_WEIRD_SERVER_REPLY      = CURLE_WEIRD_SERVER_REPLY      
  CURLE_SSL_CACERT                  = CURLE_PEER_FAILED_VERIFICATION
  CURLE_UNKNOWN_TELNET_OPTION       = CURLE_UNKNOWN_OPTION          
  CURLE_SSL_PEER_CERTIFICATE        = CURLE_PEER_FAILED_VERIFICATION
  CURLE_OBSOLETE                    = CURLE_OBSOLETE50               # no one should be using this!
  CURLE_BAD_PASSWORD_ENTERED        = CURLE_OBSOLETE46              
  CURLE_BAD_CALLING_ORDER           = CURLE_OBSOLETE44              
  CURLE_FTP_USER_PASSWORD_INCORRECT = CURLE_OBSOLETE10              
  CURLE_FTP_CANT_RECONNECT          = CURLE_OBSOLETE16              
  CURLE_FTP_COULDNT_GET_SIZE        = CURLE_OBSOLETE32              
  CURLE_FTP_COULDNT_SET_ASCII       = CURLE_OBSOLETE29              
  CURLE_FTP_WEIRD_USER_REPLY        = CURLE_OBSOLETE12              
  CURLE_FTP_WRITE_ERROR             = CURLE_OBSOLETE20              
  CURLE_LIBRARY_NOT_FOUND           = CURLE_OBSOLETE40              
  CURLE_MALFORMAT_USER              = CURLE_OBSOLETE24              
  CURLE_SHARE_IN_USE                = CURLE_OBSOLETE57              
  CURLE_URL_MALFORMAT_USER          = CURLE_NOT_BUILT_IN            
  CURLE_FTP_ACCESS_DENIED           = CURLE_REMOTE_ACCESS_DENIED    
  CURLE_FTP_COULDNT_SET_BINARY      = CURLE_FTP_COULDNT_SET_TYPE    
  CURLE_FTP_QUOTE_ERROR             = CURLE_QUOTE_ERROR             
  CURLE_TFTP_DISKFULL               = CURLE_REMOTE_DISK_FULL        
  CURLE_TFTP_EXISTS                 = CURLE_REMOTE_FILE_EXISTS      
  CURLE_HTTP_RANGE_ERROR            = CURLE_RANGE_ERROR             
  CURLE_FTP_SSL_FAILED              = CURLE_USE_SSL_FAILED          
  CURLE_OPERATION_TIMEOUTED         = CURLE_OPERATION_TIMEDOUT      
  CURLE_HTTP_NOT_FOUND              = CURLE_HTTP_RETURNED_ERROR     
  CURLE_HTTP_PORT_FAILED            = CURLE_INTERFACE_FAILED        
  CURLE_FTP_COULDNT_STOR_FILE       = CURLE_UPLOAD_FAILED           
  CURLE_FTP_PARTIAL_FILE            = CURLE_PARTIAL_FILE            
  CURLE_FTP_BAD_DOWNLOAD_RESUME     = CURLE_BAD_DOWNLOAD_RESUME     
  CURLE_ALREADY_COMPLETE            = 99999                         

  CURLOPT_FILE        = CURLOPT_WRITEDATA  # name changed in 7.9.7
  CURLOPT_INFILE      = CURLOPT_READDATA   # name changed in 7.9.7
  CURLOPT_WRITEHEADER = CURLOPT_HEADERDATA
  CURLOPT_WRITEINFO   = CURLOPT_OBSOLETE40
  CURLOPT_CLOSEPOLICY = CURLOPT_OBSOLETE72

  CURLAUTH_NONE         = (0)                                   
  CURLAUTH_BASIC        = ((1)<<0)                              
  CURLAUTH_DIGEST       = ((1)<<1)                              
  CURLAUTH_NEGOTIATE    = ((1)<<2)                              
  CURLAUTH_GSSNEGOTIATE = CURLAUTH_NEGOTIATE                    
  CURLAUTH_GSSAPI       = CURLAUTH_NEGOTIATE                    
  CURLAUTH_NTLM         = ((1)<<3)                              
  CURLAUTH_DIGEST_IE    = ((1)<<4)                              
  CURLAUTH_NTLM_WB      = ((1)<<5)                              
  CURLAUTH_BEARER       = ((1)<<6)                              
  CURLAUTH_ONLY         = ((1)<<31)                             
  CURLAUTH_ANY          = (~CURLAUTH_DIGEST_IE)                 
  CURLAUTH_ANYSAFE      = (~(CURLAUTH_BASIC|CURLAUTH_DIGEST_IE))

  CURLSSH_AUTH_ANY       = ~0               # all types supported by the server
  CURLSSH_AUTH_NONE      = 0                # none allowed, silly but complete
  CURLSSH_AUTH_PUBLICKEY = (1<<0)           # public/private key files
  CURLSSH_AUTH_PASSWORD  = (1<<1)           # password
  CURLSSH_AUTH_HOST      = (1<<2)           # host key files
  CURLSSH_AUTH_KEYBOARD  = (1<<3)           # keyboard interactive
  CURLSSH_AUTH_AGENT     = (1<<4)           # agent (ssh-agent, pageant...)
  CURLSSH_AUTH_GSSAPI    = (1<<5)           # gssapi (kerberos, ...)
  CURLSSH_AUTH_DEFAULT   = CURLSSH_AUTH_ANY

  CURLGSSAPI_DELEGATION_NONE        = 0       # no delegation (default)
  CURLGSSAPI_DELEGATION_POLICY_FLAG = (1<<0)  # if permitted by policy
  CURLGSSAPI_DELEGATION_FLAG        = (1<<1)  # delegate always

  CURL_ERROR_SIZE = 256

  CURLSSLOPT_ALLOW_BEAST = (1<<0)
  CURLSSLOPT_NO_REVOKE   = (1<<1)

  CURL_HET_DEFAULT             = 200  
  CURL_UPKEEP_INTERVAL_DEFAULT = 60000

  CURLFTPSSL_NONE    = CURLUSESSL_NONE   
  CURLFTPSSL_TRY     = CURLUSESSL_TRY    
  CURLFTPSSL_CONTROL = CURLUSESSL_CONTROL
  CURLFTPSSL_ALL     = CURLUSESSL_ALL    
  CURLFTPSSL_LAST    = CURLUSESSL_LAST   

  CURLHEADER_UNIFIED  = 0     
  CURLHEADER_SEPARATE = (1<<0)

  CURLPROTO_HTTP   = (1<<0) 
  CURLPROTO_HTTPS  = (1<<1) 
  CURLPROTO_FTP    = (1<<2) 
  CURLPROTO_FTPS   = (1<<3) 
  CURLPROTO_SCP    = (1<<4) 
  CURLPROTO_SFTP   = (1<<5) 
  CURLPROTO_TELNET = (1<<6) 
  CURLPROTO_LDAP   = (1<<7) 
  CURLPROTO_LDAPS  = (1<<8) 
  CURLPROTO_DICT   = (1<<9) 
  CURLPROTO_FILE   = (1<<10)
  CURLPROTO_TFTP   = (1<<11)
  CURLPROTO_IMAP   = (1<<12)
  CURLPROTO_IMAPS  = (1<<13)
  CURLPROTO_POP3   = (1<<14)
  CURLPROTO_POP3S  = (1<<15)
  CURLPROTO_SMTP   = (1<<16)
  CURLPROTO_SMTPS  = (1<<17)
  CURLPROTO_RTSP   = (1<<18)
  CURLPROTO_RTMP   = (1<<19)
  CURLPROTO_RTMPT  = (1<<20)
  CURLPROTO_RTMPE  = (1<<21)
  CURLPROTO_RTMPTE = (1<<22)
  CURLPROTO_RTMPS  = (1<<23)
  CURLPROTO_RTMPTS = (1<<24)
  CURLPROTO_GOPHER = (1<<25)
  CURLPROTO_SMB    = (1<<26)
  CURLPROTO_SMBS   = (1<<27)
  CURLPROTO_ALL    = (~0)    # enable everything

  CURLOPTTYPE_LONG          = 0    
  CURLOPTTYPE_OBJECTPOINT   = 10000
  CURLOPTTYPE_STRINGPOINT   = 10000
  CURLOPTTYPE_FUNCTIONPOINT = 20000
  CURLOPTTYPE_OFF_T         = 30000

  CURLOPT_XFERINFODATA            = CURLOPT_PROGRESSDATA        
  CURLOPT_SERVER_RESPONSE_TIMEOUT = CURLOPT_FTP_RESPONSE_TIMEOUT
  CURLOPT_POST301                 = CURLOPT_POSTREDIR           
  CURLOPT_SSLKEYPASSWD            = CURLOPT_KEYPASSWD           
  CURLOPT_FTPAPPEND               = CURLOPT_APPEND              
  CURLOPT_FTPLISTONLY             = CURLOPT_DIRLISTONLY         
  CURLOPT_FTP_SSL                 = CURLOPT_USE_SSL             
  CURLOPT_SSLCERTPASSWD           = CURLOPT_KEYPASSWD           
  CURLOPT_KRB4LEVEL               = CURLOPT_KRBLEVEL            

  CURL_IPRESOLVE_WHATEVER = 0  # default, resolves addresses to all IP
  CURL_IPRESOLVE_V4       = 1  # resolve to IPv4 addresses
  CURL_IPRESOLVE_V6       = 2  # resolve to IPv6 addresses

  CURLOPT_RTSPHEADER = CURLOPT_HTTPHEADER

  CURL_HTTP_VERSION_2  = CURL_HTTP_VERSION_2_0                                        
  CURL_REDIR_GET_ALL   = 0                                                            
  CURL_REDIR_POST_301  = 1                                                            
  CURL_REDIR_POST_302  = 2                                                            
  CURL_REDIR_POST_303  = 4                                                            
  CURL_REDIR_POST_ALL  = (CURL_REDIR_POST_301|CURL_REDIR_POST_302|CURL_REDIR_POST_303)
  CURL_ZERO_TERMINATED = ((size_t) -1)                                                

  CURLINFO_STRING    = 0x100000              
  CURLINFO_LONG      = 0x200000              
  CURLINFO_DOUBLE    = 0x300000              
  CURLINFO_SLIST     = 0x400000              
  CURLINFO_PTR       = 0x400000               # same as SLIST
  CURLINFO_SOCKET    = 0x500000              
  CURLINFO_OFF_T     = 0x600000              
  CURLINFO_MASK      = 0x0fffff              
  CURLINFO_TYPEMASK  = 0xf00000              
  CURLINFO_HTTP_CODE = CURLINFO_RESPONSE_CODE

  CURL_GLOBAL_SSL       = (1<<0)                              # no purpose since since 7.57.0
  CURL_GLOBAL_WIN32     = (1<<1)                             
  CURL_GLOBAL_ALL       = (CURL_GLOBAL_SSL|CURL_GLOBAL_WIN32)
  CURL_GLOBAL_NOTHING   = 0                                  
  CURL_GLOBAL_DEFAULT   = CURL_GLOBAL_ALL                    
  CURL_GLOBAL_ACK_EINTR = (1<<2)                             

  CURLVERSION_NOW = CURLVERSION_FIFTH

  CURL_VERSION_IPV6         = (1<<0)   # IPv6-enabled
  CURL_VERSION_KERBEROS4    = (1<<1)   # Kerberos V4 auth is supported
  CURL_VERSION_SSL          = (1<<2)   # SSL options are present
  CURL_VERSION_LIBZ         = (1<<3)   # libz features are present
  CURL_VERSION_NTLM         = (1<<4)   # NTLM auth is supported
  CURL_VERSION_GSSNEGOTIATE = (1<<5)   # Negotiate auth is supported
  CURL_VERSION_DEBUG        = (1<<6)   # Built with debug capabilities
  CURL_VERSION_ASYNCHDNS    = (1<<7)   # Asynchronous DNS resolves
  CURL_VERSION_SPNEGO       = (1<<8)   # SPNEGO auth is supported
  CURL_VERSION_LARGEFILE    = (1<<9)   # Supports files larger than 2GB
  CURL_VERSION_IDN          = (1<<10)  # Internationized Domain Names are
  CURL_VERSION_SSPI         = (1<<11)  # Built against Windows SSPI
  CURL_VERSION_CONV         = (1<<12)  # Character conversions supported
  CURL_VERSION_CURLDEBUG    = (1<<13)  # Debug memory tracking supported
  CURL_VERSION_TLSAUTH_SRP  = (1<<14)  # TLS-SRP auth is supported
  CURL_VERSION_NTLM_WB      = (1<<15)  # NTLM delegation to winbind helper
  CURL_VERSION_HTTP2        = (1<<16)  # HTTP2 support built-in
  CURL_VERSION_GSSAPI       = (1<<17)  # Built against a GSS-API library
  CURL_VERSION_KERBEROS5    = (1<<18)  # Kerberos V5 auth is supported
  CURL_VERSION_UNIX_SOCKETS = (1<<19)  # Unix domain sockets support
  CURL_VERSION_PSL          = (1<<20)  # Mozilla's Public Suffix List, used
  CURL_VERSION_HTTPS_PROXY  = (1<<21)  # HTTPS-proxy support built-in
  CURL_VERSION_MULTI_SSL    = (1<<22)  # Multiple SSL backends available
  CURL_VERSION_BROTLI       = (1<<23)  # Brotli features are present.

  CURLPAUSE_RECV      = (1<<0)                                   
  CURLPAUSE_RECV_CONT = (0)                                      
  CURLPAUSE_SEND      = (1<<2)                                   
  CURLPAUSE_SEND_CONT = (0)                                      
  CURLPAUSE_ALL       = (CURLPAUSE_RECV|CURLPAUSE_SEND)          
  CURLPAUSE_CONT      = (CURLPAUSE_RECV_CONT|CURLPAUSE_SEND_CONT)

  CURLM_CALL_MULTI_SOCKET = CURLM_CALL_MULTI_PERFORM

  CURLPIPE_NOTHING   = 0
  CURLPIPE_HTTP1     = 1
  CURLPIPE_MULTIPLEX = 2

  CURL_WAIT_POLLIN    = 0x0001         
  CURL_WAIT_POLLPRI   = 0x0002         
  CURL_WAIT_POLLOUT   = 0x0004         
  CURL_POLL_NONE      = 0              
  CURL_POLL_IN        = 1              
  CURL_POLL_OUT       = 2              
  CURL_POLL_INOUT     = 3              
  CURL_POLL_REMOVE    = 4              
  CURL_SOCKET_TIMEOUT = CURL_SOCKET_BAD
  CURL_CSELECT_IN     = 0x01           
  CURL_CSELECT_OUT    = 0x02           
  CURL_CSELECT_ERR    = 0x04           
  CURL_PUSH_OK        = 0              
  CURL_PUSH_DENY      = 1              
end
