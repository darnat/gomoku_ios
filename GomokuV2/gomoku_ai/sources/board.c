/*
** board.c for Gomoku in /home/hirt_r/rendu/gomoku_ai
**
** Made by hirt_r
** Login   <hirt_r@epitech.net>
**
** Started on  Sat Jan 16 16:31:40 2016 hirt_r
** Last update Sat Jan 23 12:39:03 2016 hirt_r
*/

#include "struct_team.h"
#include "struct_pawn.h"
#include "struct_board.h"
#include <stdlib.h>

t_team			*newTeam(int id)
{
  t_team		*team;

  if ((team = malloc(sizeof(t_team))) == NULL)
    return (NULL);
  team->id = id;
  team->stones = 0;
  team->next = NULL;
  return (team);
}

t_team			*newTeams()
{
  t_team		*teams;

  if ((teams = newTeam(1)) == NULL)
    return (NULL);
  if ((teams->next = newTeam(2)) == NULL)
    return (NULL);
  return (teams);
}

t_board			*newBoard()
{
  t_board		*tmp;

  if ((tmp = malloc(sizeof(t_board))) == NULL)
    return (NULL);
  tmp->width = 19;
  tmp->height = 19;
  tmp->pawns = NULL;
  tmp->level = 0;
  tmp->depth = 2;
  if ((tmp->teams = newTeams()) == NULL)
    return (NULL);
  return (tmp);
}

t_board			*getBoard(__attribute__((unused))int reset)
{
  static t_board	*tmp = NULL;

  if (tmp == NULL)
    {
      if ((tmp = newBoard()) == NULL)
	return (NULL);
    }
  return (tmp);
}
