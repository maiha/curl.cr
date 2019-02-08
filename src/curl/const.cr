## Automatically generated from gen/lib_curl_const.h
module Curl::Const
  
  CURLAUTH_NONE         = (0)
  CURLAUTH_BASIC        = ((1)<<0)
  CURLAUTH_DIGEST       = ((1)<<1)
  CURLAUTH_NEGOTIATE    = ((1)<<2)
  # Deprecated since the advent of CURLAUTH_NEGOTIATE 
  CURLAUTH_GSSNEGOTIATE = CURLAUTH_NEGOTIATE
  # Used for CURLOPT_SOCKS5_AUTH to stay terminologically correct 
  CURLAUTH_GSSAPI = CURLAUTH_NEGOTIATE
  CURLAUTH_NTLM         = ((1)<<3)
  CURLAUTH_DIGEST_IE    = ((1)<<4)
  CURLAUTH_NTLM_WB      = ((1)<<5)
  CURLAUTH_ONLY         = ((1)<<31)
  CURLAUTH_ANY          = (~CURLAUTH_DIGEST_IE)
  CURLAUTH_ANYSAFE      = (~(CURLAUTH_BASIC|CURLAUTH_DIGEST_IE))
  
  CURLSSH_AUTH_ANY       = ~0     # all types supported by the server 
  CURLSSH_AUTH_NONE      = 0      # none allowed, silly but complete 
  CURLSSH_AUTH_PUBLICKEY = (1<<0) # public/private key files 
  CURLSSH_AUTH_PASSWORD  = (1<<1) # password 
  CURLSSH_AUTH_HOST      = (1<<2) # host key files 
  CURLSSH_AUTH_KEYBOARD  = (1<<3) # keyboard interactive 
  CURLSSH_AUTH_AGENT     = (1<<4) # agent (ssh-agent, pageant...) 
  CURLSSH_AUTH_GSSAPI    = (1<<5) # gssapi (kerberos, ...) 
  CURLSSH_AUTH_DEFAULT = CURLSSH_AUTH_ANY
  
  CURLGSSAPI_DELEGATION_NONE        = 0      # no delegation (default) 
  CURLGSSAPI_DELEGATION_POLICY_FLAG = (1<<0) # if permitted by policy 
  CURLGSSAPI_DELEGATION_FLAG        = (1<<1) # delegate always 
  
end
