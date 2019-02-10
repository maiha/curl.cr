export LC_ALL=C

simple-static:
	gcc simple.c -static ../libcurl.a -lidn2 -lssl -lcrypto -lz -lpthread -ldl

simple:
	gcc simple.c -lcurl

