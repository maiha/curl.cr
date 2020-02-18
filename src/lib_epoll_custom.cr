lib LibEpoll
  enum Event
    EPOLLIN = 0x001
    EPOLLPRI = 0x002
    EPOLLOUT = 0x004
    EPOLLRDNORM = 0x040
    EPOLLRDBAND = 0x080
    EPOLLWRNORM = 0x100
    EPOLLWRBAND = 0x200
    EPOLLMSG = 0x400
    EPOLLERR = 0x008
    EPOLLHUP = 0x010
    EPOLLRDHUP = 0x2000
    EPOLLEXCLUSIVE = 1_u32 << 28
    EPOLLWAKEUP = 1_u32 << 29
    EPOLLONESHOT = 1_u32 << 30
    EPOLLET = 1_u32 << 31
  end
end
