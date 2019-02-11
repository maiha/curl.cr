lib LibEpoll
  EPOLL_CTL_ADD = 1
  EPOLL_CTL_DEL = 2
  EPOLL_CTL_MOD = 3
  EPOLL_CLOEXEC = 524288_i64
  union EpollData
    ptr : Void*
    fd : LibC::Int
    u32 : Uint32T
    u64 : Uint64T
  end
  alias X__Uint32T = LibC::UInt
  alias Uint32T = X__Uint32T
  alias X__Uint64T = LibC::ULong
  alias Uint64T = X__Uint64T
  struct EpollEvent
    events : Uint32T
    data : EpollData  # changed from 'EpollDataT' by hand
  end
  type EpollDataT = EpollData
  fun epoll_create(__size : LibC::Int) : LibC::Int
  fun epoll_create1(__flags : LibC::Int) : LibC::Int
  fun epoll_ctl(__epfd : LibC::Int, __op : LibC::Int, __fd : LibC::Int, __event : EpollEvent*) : LibC::Int
  fun epoll_wait(__epfd : LibC::Int, __events : EpollEvent*, __maxevents : LibC::Int, __timeout : LibC::Int) : LibC::Int
  fun epoll_pwait(__epfd : LibC::Int, __events : EpollEvent*, __maxevents : LibC::Int, __timeout : LibC::Int, __ss : X__SigsetT*) : LibC::Int
  struct X__SigsetT
    __val : LibC::ULong[16]
  end
end

