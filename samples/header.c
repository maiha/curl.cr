/* https://curl.haxx.se/libcurl/c/CURLOPT_HTTPHEADER.html */

#include <stdio.h>
#include <curl/curl.h>

int main(void)
{
  CURL *curl = curl_easy_init();

  struct curl_slist *list = NULL;

  if(curl) {
    curl_easy_setopt(curl, CURLOPT_URL, "http://example.com");

    list = curl_slist_append(list, "Shoesize: 10");
    list = curl_slist_append(list, "Accept:");

    curl_easy_setopt(curl, CURLOPT_HTTPHEADER, list);

    curl_easy_perform(curl);

    curl_slist_free_all(list); /* free the list again */
  }

  return 0;
}
