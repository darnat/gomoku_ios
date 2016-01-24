//
//  socket.h
//  GomokuV2
//
//  Created by Alexis DARNAT on 21/01/2016.
//  Copyright © 2016 Alexis DARNAT. All rights reserved.
//

#ifndef socket_h
#define socket_h

#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>

typedef struct          s_socket
{
    int                 fd;
    int                 is_running;
    int                 port;
    char                *addr;
    fd_set              readfs;
}                       t_socket;

#endif /* socket_h */
