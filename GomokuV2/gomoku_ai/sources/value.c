/*
** tree.c for Gomoku in /home/hirt_r/rendu/gomoku_ai
**
** Made by hirt_r
** Login   <hirt_r@epitech.net>
**
** Started on  Wed Jan 20 17:47:44 2016 hirt_r
** Last update Sat Jan 23 02:06:37 2016 hirt_r
*/

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include "struct_team.h"
#include "struct_pawn.h"
#include "struct_board.h"
#include "struct_tree.h"
#include "board.h"

void		my_putchar(char c)
{
  write(1, &c, 1);
}

void		my_putnbr(int n)
{
  if (n >= 10)
    my_putnbr(n / 10);
  my_putchar(n % 10 + 48);
}

int		poww(int n, int p)
{
  int		i;
  int		tmp;

  if (p == 8)
    return (10000);
  i = -1;
  tmp = 1;
  while (++i < p - 1)
    {
      tmp *= n;
    }
  return (tmp);
}

int		calcValueRow(t_board *board, int id)
{
  int		i;
  int		j;
  int		tmp;
  int		res;
  t_pawn	*p1;
  t_pawn	*p2;

  res = 0;
  i = -1;
  while (++i < board->width)
    {
      j = -1;
      tmp = 0;
      while (++j < board->height)
	{
	  p1 = getPawnAt(board, i, j);
	  if (p1 && p1->team->id == id)
	    tmp += 1;
	  else if (tmp >= 2)
	    {
	      p2 = getPawnAt(board, i, j - tmp - 1);
	      tmp *= 2;
	      if (p1 && p2)
		tmp = 0;
	      else if (p1 || p2)
		tmp -= 1;
	      res += poww(3, tmp);
	      tmp = 0;
	    }
	  else
	    tmp = 0;
	}
    }
  return (res);
}

int		calcValueCol(t_board *board, int id)
{
  int		i;
  int		j;
  int		tmp;
  int		res;
  t_pawn	*p1;
  t_pawn	*p2;

  res = 0;
  i = -1;
  while (++i < board->width)
    {
      j = -1;
      tmp = 0;
      while (++j < board->height)
	{
	  p1 = getPawnAt(board, j, i);
	  if (p1 && p1->team->id == id)
	    tmp += 1;
	  else if (tmp >= 2)
	    {
	      p2 = getPawnAt(board, j - tmp - 1, i);
	      tmp *= 2;
	      if (p1 && p2)
		tmp = 0;
	      else if (p1 || p2)
		tmp -= 1;
	      res += poww(3, tmp);
	      tmp = 0;
	    }
	  else
	    tmp = 0;
	}
    }
  return (res);
}

int		calcValueDiag1(t_board *board, int id)
{
  int		a;
  int		i;
  int		j;
  int		tmp;
  int		res;
  t_pawn	*p1;
  t_pawn	*p2;

  res = 0;
  a = -1;
  while (++a < board->width * 2)
    {
    tmp = 0;
      if (a < board->width)
	{
	  i = board->width - 1 - a;
	  j = 0;
	}
      else
	{
	  i = 0;
	  j = a - board->width + 1;
	}
      while (i < board->width && j < board->width)
	{
	  p1 = getPawnAt(board, j, i);
	  if (p1 && p1->team->id == id)
	    tmp += 1;
	  else if (tmp >= 2)
	    {
	      p2 = getPawnAt(board, j - tmp - 1, i - tmp - 1);
	      tmp *= 2;
	      if (p1 && p2)
		tmp = 0;
	      else if (p1 || p2)
		tmp -= 1;
	      res += poww(3, tmp);
	      tmp = 0;
	    }
	  else
	    tmp = 0;
	  i += 1;
	  j += 1;
	}
    }
  return (res);
}

int		calcValueDiag2(t_board *board, int id)
{
  int		a;
  int		i;
  int		j;
  int		tmp;
  int		res;
  t_pawn	*p1;
  t_pawn	*p2;

  res = 0;
  a = -1;
  while (++a < board->width * 2)
    {
        tmp = 0;
      if (a < board->width)
	{
	  i = 0;
	  j = a;
	}
      else
	{
	  i = a - board->width + 1;
	  j = board->width - 1;
	}
      while (i < board->width && j < board->width)
	{
	  p1 = getPawnAt(board, j, i);
	  if (p1 && p1->team->id == id)
	    tmp += 1;
	  else if (tmp >= 2)
	    {
	      p2 = getPawnAt(board, j + tmp + 1, i - tmp - 1);
	      tmp *= 2;
	      if (p1 && p2)
		tmp = 0;
	      else if (p1 || p2)
		tmp -= 1;
	      res += poww(3, tmp);
	      tmp = 0;
	    }
	  else
	    tmp = 0;
	  i += 1;
	  j -= 1;
	}
    }
  return (res);
}

int		calcValue(t_tree *tree)
{
  double	tmp1;
  double	tmp2;
  int		res;
  t_board	*board;

  board = tree->board;
  tmp1 = calcValueRow(board, 1) +
    calcValueCol(board, 1) +
    calcValueDiag1(board, 1) +
    calcValueDiag2(board, 1);
  tmp2 = calcValueRow(board, 2) +
    calcValueCol(board, 2) +
    calcValueDiag1(board, 2) +
    calcValueDiag2(board, 2);
  if (tree->eaten && tree->level % 2)
    tmp1 += 50;
  else if (tree->eaten)
    tmp2 += 50;
  if (tmp1 > 10000 && tmp2 < 10000)
    return (300);
  if (tmp1 < 10000 && tmp2 > 10000)
    return (-200);
  if (tmp1 == 0 && tmp2 == 0)
    res = 50;
  else
    res = tmp1 / (tmp1 + tmp2) * 100;
  return (res);
}
