/*
** pawn.c for GOmoku in /home/hirt_r/rendu/gomoku_ai
**
** Made by hirt_r
** Login   <hirt_r@epitech.net>
**
** Started on  Sat Jan 16 15:59:05 2016 hirt_r
** Last update Tue Jan 19 19:37:24 2016 hirt_r
*/

#include "struct_team.h"
#include "struct_pawn.h"
#include "struct_board.h"
#include <stdlib.h>

t_team	*getTeam(t_board *board, int id)
{
  t_team	*tmp;

  tmp = board->teams;
  while (tmp)
    {
      if (tmp->id == id)
	return (tmp);
      tmp = tmp->next;
    }
  return (NULL);
}

t_team	*addTeamAt(t_board *board, int id)
{
  t_team	*tmp;

  if (getTeam(board, id))
    return (NULL);
  if ((tmp = malloc(sizeof(t_team))) == NULL)
    return (NULL);
  tmp->id = id;
  tmp->next = board->teams;
  board->teams = tmp;
  return (tmp);
}
