# with https://github.com/crystal-lang/crystal_lib
# ```console
# $ crystal src/main.cr -- lib_poll.cr
# ```

@[Include("sys/epoll.h", prefix: %w(epoll EPOLL), remove_prefix: false)]
lib LibEpoll
end
