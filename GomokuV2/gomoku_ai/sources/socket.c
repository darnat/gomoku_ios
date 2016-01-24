//
//  socket.c
//  GomokuV2
//
//  Created by Alexis DARNAT on 21/01/2016.
//  Copyright © 2016 Alexis DARNAT. All rights reserved.
//

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <errno.h>
#include "socket.h"

void		set_client(t_socket *so)
{
    FD_ZERO(&(so->readfs));
    FD_SET(so->fd, &(so->readfs));
    FD_SET(STDIN_FILENO, &(so->readfs));
}

t_socket        *create_socket()
{
    t_socket    *tmp;
    
    if ((tmp = malloc(sizeof(t_socket))) == NULL)
        return (NULL);
    tmp->is_running = 1;
    tmp->fd = -1;
    tmp->port = 8888;
    tmp->addr = strdup("149.202.179.97");
    return tmp;
}

int             init_socket(t_socket *so)
{
    struct protoent	*p;
    
    if ((p = getprotobyname("tcp")) == NULL)
    {
        fprintf(stderr, "Error : getprotobyname fail\n");
        return (1);
    }
    so->fd = socket(AF_INET, SOCK_STREAM, p->p_proto);
    if (so->fd == -1)
    {
        fprintf(stderr, "Error : %s\n", strerror(errno));
        return (1);
    }
    return (0);
}

int			connect_socket(t_socket *so)
{
    struct sockaddr_in	s_in;
    
    s_in.sin_family = AF_INET;
    s_in.sin_port = htons(so->port);
    s_in.sin_addr.s_addr = inet_addr(so->addr);
    if (connect(so->fd,
                (const struct sockaddr *)&s_in, sizeof(s_in)) == -1)
    {
        fprintf(stderr, "Error : connect : %s\n", strerror(errno));
        if (close(so->fd) == -1)
            fprintf(stderr, "Error : Close : %s\n", strerror(errno));
        return (1);
    }
    return (0);
}

int         server_write(t_socket *so)
{
    if (FD_ISSET(so->fd, &(so->readfs)))
        return (1);
    return (0);
}

char            *read_from_server(t_socket *so)
{
    char        buff[512];
    ssize_t     r;
    
    memset(&(*buff), 0, 512);
    if ((r = read(so->fd, buff, 511)) == -1)
    {
        fprintf(stderr, "Error : read : %s\n", strerror(errno));
        return NULL;
    }
    return strdup(buff);
}

void        write_to_serve(t_socket *so, char *msg)
{
    write(so->fd, msg, strlen(msg));
}

void        end_socket(t_socket *so)
{
    close(so->fd);
    if (so->addr)
        free(so->addr);
    free(so);
}

int         select_socket(t_socket *so)
{
    if ((select(so->fd + 1, &(so->readfs), NULL, NULL, NULL)) == -1)
    {
        fprintf(stderr, "Error : select : %s\n", strerror(errno));
        if (close(so->fd) == -1)
            fprintf(stderr, "Error : close : %s\n", strerror(errno));
        return (1);
    }
    return (0);
}
