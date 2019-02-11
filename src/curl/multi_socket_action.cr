class Curl::Multi::SocketAction
  include Api

  ######################################################################
  ### Internal variables

  var multi : LibCurlMulti::Curlm*
  var epollFd : Int32

  ######################################################################
  ### Public variables

  var timeout : Time::Span = 30.seconds

  def <<(easy : Easy)
  end

  ######################################################################
  ### Internal functions

  private def errno
    Errno.value
  end
  
  def initialize
    @multi = LibCurlMulti.curl_multi_init
    GC.add_finalizer(self)

    self.epollFd = LibEpoll.epoll_create(1)
    if epollFd == -1
      raise "epoll_create"
    end

    # pending: NOT working
    initialize_epoll(epollFd)
  end

  def finalize
    LibCurlMulti.curl_multi_cleanup(multi)
  end

  private def initialize_epoll(_epollFd : Int32)
    epollFd = _epollFd.as(LibC::Int)

    socket_callback = ->(easy : LibCurl::CURL*, fd : LibC::Int, action : LibC::Int, u : Void*, s : Void*) {

      datap = Pointer(LibEpoll::EpollData).malloc
      data = datap.value
      
      eventp = Pointer(LibEpoll::EpollEvent).malloc
      event = eventp.value.as(LibEpoll::EpollEvent)
      event.events = 0
      event.data = data
      event.data.fd = fd

      if (action == CURL_POLL_REMOVE)
        printf(">>> removing fd=%d\n", fd)

        res = LibEpoll.epoll_ctl(epollFd, LibEpoll::EPOLL_CTL_DEL, fd, eventp)
        if (res == -1 && errno != Errno::EBADF)
          abort "epoll_ctl(DEL)"
        end
      else
        if (action == CURL_POLL_IN || action == CURL_POLL_INOUT)
          event.events |= EPOLLIN.value
        end

        if (action == CURL_POLL_OUT || action == CURL_POLL_INOUT)
          event.events |= EPOLLOUT.value
        end

        printf(">>> adding fd=%d action=%d\n", fd, action)
        if (event.events != 0)
          res = LibEpoll.epoll_ctl(epollFd, LibEpoll::EPOLL_CTL_ADD, fd, eventp)
          if (res == -1)
            res = LibEpoll.epoll_ctl(epollFd, LibEpoll::EPOLL_CTL_MOD, fd, eventp)
          end
          if (res == -1)
            abort "epoll_ctl(MOD)"
          end
        end
      end
      0
    }

    empty_callback = ->(easy : LibCurl::CURL*, fd : LibC::Int, action : LibC::Int, u : Void*, s : Void*) {
      datap = Pointer(LibEpoll::EpollData).malloc
      data = datap.value
      
      eventp = Pointer(LibEpoll::EpollEvent).malloc
      event = eventp.value.as(LibEpoll::EpollEvent)
      event.events = 0
      event.data = data
      event.data.fd = fd

      if (action == CURL_POLL_REMOVE)
        printf(">>> removing fd=%d\n", fd)

        #, LibEpoll::EPOLL_CTL_DEL, fd, eventp)
        
        #res = LibEpoll.epoll_ctl(epollFd, LibEpoll::EPOLL_CTL_DEL, fd, eventp)
        res = -1
        if (res == -1 && LibC.errno != LibC::EBADF)
          abort "epoll_ctl(DEL)"
        end
      end
      0
    }

    curl_multi_setopt(multi, CURLMOPT_SOCKETFUNCTION, empty_callback)
#    curl_multi_setopt(multi, CURLMOPT_TIMERFUNCTION, timerCallback)
  end
end
