/* https://curl.haxx.se/libcurl/c/simple.html */

#include <stdio.h>
#include <curl/curl.h>

int main(void)
{
  CURL *curl;
  CURLcode res;

  curl = curl_easy_init();
  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "https://example.com");
    /* example.com is redirected, so we tell libcurl to follow redirection */
    curl_easy_setopt(curl, CURLOPT_FOLLOWLOCATION, 1L);

    /* Perform the request, res will get the return code */
    res = curl_easy_perform(curl);

    if(res == CURLE_OK) {
      double total;
      res = curl_easy_getinfo(curl, CURLINFO_TOTAL_TIME, &total);
      if(CURLE_OK == res) {
	printf("Time: %.1f\n", total);
      }

      char *ct = NULL;
      res = curl_easy_getinfo(curl, CURLINFO_CONTENT_TYPE, &ct);
      if(!res && ct) {
	printf("Content-Type: %d\n", CURLINFO_CONTENT_TYPE);
	printf("Content-Type: %s\n", ct);
      }
      
    } else {
      /* Check for errors */
      fprintf(stderr, "curl_easy_perform() failed: %s\n",
	      curl_easy_strerror(res));
      /* always cleanup */
      curl_easy_cleanup(curl);
    }
  
    /* always cleanup */
    curl_easy_cleanup(curl);
  }
  return 0;
}
