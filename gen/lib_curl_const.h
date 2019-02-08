# https://github.com/curl/curl/blob/curl-7_64_0/include/curl/curl.h

#define CURLAUTH_NONE         ((unsigned long)0)
#define CURLAUTH_BASIC        (((unsigned long)1)<<0)
#define CURLAUTH_DIGEST       (((unsigned long)1)<<1)
#define CURLAUTH_NEGOTIATE    (((unsigned long)1)<<2)
/* Deprecated since the advent of CURLAUTH_NEGOTIATE */
#define CURLAUTH_GSSNEGOTIATE CURLAUTH_NEGOTIATE
/* Used for CURLOPT_SOCKS5_AUTH to stay terminologically correct */
#define CURLAUTH_GSSAPI CURLAUTH_NEGOTIATE
#define CURLAUTH_NTLM         (((unsigned long)1)<<3)
#define CURLAUTH_DIGEST_IE    (((unsigned long)1)<<4)
#define CURLAUTH_NTLM_WB      (((unsigned long)1)<<5)
#define CURLAUTH_ONLY         (((unsigned long)1)<<31)
#define CURLAUTH_ANY          (~CURLAUTH_DIGEST_IE)
#define CURLAUTH_ANYSAFE      (~(CURLAUTH_BASIC|CURLAUTH_DIGEST_IE))

#define CURLSSH_AUTH_ANY       ~0     /* all types supported by the server */
#define CURLSSH_AUTH_NONE      0      /* none allowed, silly but complete */
#define CURLSSH_AUTH_PUBLICKEY (1<<0) /* public/private key files */
#define CURLSSH_AUTH_PASSWORD  (1<<1) /* password */
#define CURLSSH_AUTH_HOST      (1<<2) /* host key files */
#define CURLSSH_AUTH_KEYBOARD  (1<<3) /* keyboard interactive */
#define CURLSSH_AUTH_AGENT     (1<<4) /* agent (ssh-agent, pageant...) */
#define CURLSSH_AUTH_GSSAPI    (1<<5) /* gssapi (kerberos, ...) */
#define CURLSSH_AUTH_DEFAULT CURLSSH_AUTH_ANY

#define CURLGSSAPI_DELEGATION_NONE        0      /* no delegation (default) */
#define CURLGSSAPI_DELEGATION_POLICY_FLAG (1<<0) /* if permitted by policy */
#define CURLGSSAPI_DELEGATION_FLAG        (1<<1) /* delegate always */

