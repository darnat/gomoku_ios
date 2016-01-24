/*
** pawn.c for GOmoku in /home/hirt_r/rendu/gomoku_ai
**
** Made by hirt_r
** Login   <hirt_r@epitech.net>
**
** Started on  Sat Jan 16 15:59:05 2016 hirt_r
** Last update Fri Jan 22 16:46:38 2016 hirt_r
*/

#include "struct_team.h"
#include "struct_pawn.h"
#include "struct_board.h"
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

t_pawn	*getPawnAt(t_board *board, int x, int y)
{
  t_pawn	*tmp;

  tmp = board->pawns;
  if (x < 0 || y < 0 || x >= board->width || y >= board->height)
    return (NULL);
  while (tmp)
    {
      if (tmp->x == x && tmp->y == y)
	return (tmp);
      tmp = tmp->next;
    }
  return (NULL);
}

void	removePawnAt(t_board *board, int x, int y)
{
  t_pawn	*tmp;

  tmp = board->pawns;
  while (tmp)
    {
      if (tmp->x == x && tmp->y == y)
	{
	  if (tmp == board->pawns)
	    board->pawns = tmp->next;
	  else
	    tmp->prev->next = tmp->next;
	  if (tmp->next)
	    tmp->next->prev = tmp->prev;
	  free(tmp);
	  return;
	}
      tmp = tmp->next;
    }
}

t_pawn		*addPawn(t_pawn **list, int x, int y)
{
  t_pawn	*tmp;

  if ((tmp = malloc(sizeof(t_pawn))) == NULL)
    return (NULL);

  tmp->x = x;
  tmp->y = y;
  tmp->prev = NULL;
  tmp->next = *list;
  if (*list)
    (*list)->prev = tmp;
  *list = tmp;
  return (tmp);
}

t_pawn	*addPawnAt(t_board *board, int x, int y)
{
  t_pawn	*tmp;

  if (getPawnAt(board, x, y))
    return (NULL);
  if ((tmp = malloc(sizeof(t_pawn))) == NULL)
    return (NULL);
  tmp->x = x;
  tmp->y = y;
  tmp->prev = NULL;
  tmp->next = board->pawns;
  if (board->pawns)
    board->pawns->prev = tmp;
  board->pawns = tmp;
  return (tmp);
}
