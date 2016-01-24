/*
** referee.c for Gomoku in /home/hirt_r/rendu/gomoku_ai
**
** Made by hirt_r
** Login   <hirt_r@epitech.net>
**
** Started on  Sat Jan 16 16:17:15 2016 hirt_r
** Last update Sat Jan 23 12:41:38 2016 hirt_r
*/

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include "struct_team.h"
#include "struct_pawn.h"
#include "struct_board.h"
#include "struct_tree.h"
#include "board.h"

t_pawn	*getPawnAt(t_board *, int, int);
t_pawn	*addPawnAt(t_board *, int, int);
t_team	*getTeam(t_board *, int);
void	removePawnAt(t_board *, int, int);

void		ptc(char c)
{
  write(1, &c, 1);
}

int		checkDirection(t_board *board, t_pawn *pawn, int x, int y, int i, int j)
{
  int		a;
  int		b;
  int		tmp;
  int		fail;
  int		min;
  int		max;
  t_pawn	*pawntmp;

  a = -4;
  while (++a < 1)
  {
    tmp = 0;
    b = -1;
    fail = 0;
    min = 4;
    max = -1;
    while (++b < 4)
      {
	pawntmp = getPawnAt(board, pawn->x + x + (a + b) * i,
			    pawn->y + y + (a + b) * j);
	if (pawntmp && pawntmp->team->id != pawn->team->id)
	  fail = 1;
	else if (pawntmp)
	  {
	    if (b < min)
	      min = b;
	    if (b > max)
	      max = b;
	    ++tmp;
	  }
      }
    if (!fail && tmp == 3)
      {
	if (getPawnAt(board, pawn->x + x + (a + min - 1) * i,
		      pawn->y + y + (a + min - 1) * j) == NULL &&
	    getPawnAt(board, pawn->x + x + (a + max + 1) * i,
		      pawn->y + y + (a + max + 1) * j) == NULL)
	  return (1);
      }
  }
  return (0);
}

int		checkPawn(t_board *board, t_pawn *pawn, int x, int y)
{
  int		i;
  int		j;
  int		tmp;

  tmp = 0;
  i = -1;
  while (++i < 2)
    {
      j = -1;
      while (++j < 2)
	{
	  if ((i || j) && checkDirection(board, pawn, x, y, i, j))
	    ++tmp;
	}
    }
  return (tmp);
}

int		checkThreeRule(t_board *board, t_pawn *pawn)
{
  int		i;
  int		j;

  i = -4;
  while (++i < 4)
    {
      j = -4;
      while (++j < 4)
	{
	  if (checkPawn(board, pawn, i, j) >= 2)
	    return (1);
	}
    }
  return (0);
}

int		setPawn(t_board *board, int x, int y, int id)
{
  t_pawn	*tmp;

  if (getPawnAt(board, x, y))
    return (1);
  if ((tmp = addPawnAt(board, x, y)) == NULL)
    return (1);
  tmp->team = getTeam(board, id);
  if (checkThreeRule(board, tmp))
    {
      removePawnAt(board, x, y);
      return (1);
    }
  board->lastp = tmp;
  board->level += 1;
  return (0);
}

int		checkEatenDirection(t_board *board, int i, int j, t_pawn **list)
{
  t_pawn	*p1;
  t_pawn	*p2;
  t_pawn	*p3;
  t_team	*team;

  p1 = getPawnAt(board, board->lastp->x + i, board->lastp->y + j);
  p2 = getPawnAt(board, board->lastp->x + i * 2, board->lastp->y + j * 2);
  p3 = getPawnAt(board, board->lastp->x + i * 3, board->lastp->y + j * 3);
  if (!(p1 && p2 && p3))
    return (0);
  if (board->lastp->team->id == p3->team->id &&
      board->lastp->team->id != p1->team->id &&
      board->lastp->team->id != p2->team->id)
    {
      addPawn(list, board->lastp->x + i, board->lastp->y + j);
      addPawn(list, board->lastp->x + i * 2, board->lastp->y + j * 2);
      removePawnAt(board, board->lastp->x + i, board->lastp->y + j);
      removePawnAt(board, board->lastp->x + i * 2, board->lastp->y + j * 2);
      team = getTeam(board, board->lastp->team->id);
      team->stones += 2;
      return (1);
    }
  return (0);
}

t_pawn		*checkEaten(t_board *board)
{
  t_pawn	*list;
  int		i;
  int		j;

  list = NULL;
  i = -2;
  while (++i < 2)
    {
      j = -2;
      while (++j < 2)
	{
	  if (i || j)
	    {
	      checkEatenDirection(board, i, j, &list);
	    }
	}
    }
  return (list);
}

int		checkWinDirection(t_board *board, int i, int j)
{
  t_pawn	*p1;
  t_pawn	*p2;
  t_pawn	*p3;
  t_pawn	*p4;
  t_pawn	*p5;
  int		x;
  int		id;

  x = -5;
  id = board->lastp->team->id;
  while (++x < 0)
    {
      p1 = getPawnAt(board, board->lastp->x + i * (x), board->lastp->y + j * (x));
      p2 = getPawnAt(board, board->lastp->x + i * (x + 1), board->lastp->y + j * (x + 1));
      p3 = getPawnAt(board, board->lastp->x + i * (x + 2), board->lastp->y + j * (x + 2));
      p4 = getPawnAt(board, board->lastp->x + i * (x + 3), board->lastp->y + j * (x + 3));
      p5 = getPawnAt(board, board->lastp->x + i * (x + 4), board->lastp->y + j * (x + 4));
      if (p1 && p2 && p3 && p4 && p5)
	{
	  if (p1->team->id == id &&
	      p2->team->id == id &&
	      p3->team->id == id &&
	      p4->team->id == id &&
	      p5->team->id == id)
	    {
	      return (1);
	    }
	}
    }
  return (0);
}

int		checkWin(t_board *board)
{
  int		i;
  int		j;
  t_team	*team;
  int		id;

  i = -2;
  id = board->lastp->team->id;
  team = getTeam(board, id);
  if (team->stones >= 10)
    return (1);
  while (++i < 2)
    {
      j = -2;
      while (++j < 2)
	{
	  if ((i || j) && checkWinDirection(board, i, j))
	    {
	      return (1);
	    }
	}
    }
  return (0);
}
