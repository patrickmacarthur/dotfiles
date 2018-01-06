" .vim/after/syntax/c.vim

syn keyword cType pthread_t socklen_t

" Sockets
syn keyword cConstant AF_IB AF_INET AF_INET6 PF_IB PF_INET PF_INET6
syn keyword cConstant SOCK_DGRAM SOCK_SEQPACKET SOCK_STREAM

" EXS
syn keyword cType exs_acceptaddr_t exs_ahandle_t exs_event_t exs_fdvec_t
syn keyword cType exs_iovec_t exs_mhandle_t exs_msghdr_t exs_pollfd_t
syn keyword cType exs_qhandle_t exs_signal_t exs_xferfile_t
syn keyword cType exs_evt_accept_t exs_evt_poll_t exs_evt_xfer_t
syn keyword cType exs_evt_xferfile_t exs_evt_xfermsg_t
syn keyword cConstant EXS_VERSION EXS_VERSION1
syn keyword cConstant EXS_MRF_SHARED
syn keyword cConstant EXS_MHANDLE_INVALID EXS_MHANDLE_UNREGISTERED
syn keyword cConstant EXS_QHANDLE_INVALID
syn keyword cConstant EXS_QATTR_DEPTH EXS_QATTR_SIGNAL EXS_QATTR_EVENTS
syn keyword cConstant EXS_SIG_ENABLE EXS_SIG_DISABLE
syn keyword cConstant EXS_QATTR_WAIT
syn keyword cConstant EXS_WAIT_ADAPTIVE EXS_WAIT_NOTIFY EXS_WAIT_BUSY_POLL
syn keyword cConstant EXS_POLLIN EXS_POLLOUT
syn keyword cConstant EXS_IOVEC EXS_FDVEC
syn keyword cConstant EXS_SHUT_WR
syn keyword cConstant SO_ASYNC_RECV_ORDERED SO_ASYNC_SEND_TIMEOUT SO_ASYNC_RECV_TIMEOUT
syn keyword cConstant EXS_TIMEOUT_ONCE
syn keyword cConstant EXS_EVT_POLL EXS_EVT_CONNECT EXS_EVT_ACCEPT EXS_EVT_SEND
syn keyword cConstant EXS_EVT_RECV EXS_EVT_SENDMSG EXS_EVT_RECVMSG
syn keyword cConstant EXS_EVT_SENDFILE EXS_EVT_SENDTIMEOUT EXS_EVT_RECVTIMEOUT
syn keyword cConstant EXS_EVT_SHUTDOWN EXS_EVT_CLOSE
syn keyword cConstant EXS_EVTVEC_MAX
syn keyword cConstant EXS_CAF_FILDES EXS_CAF_AHANDLE
