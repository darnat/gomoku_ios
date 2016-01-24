/*
** tree.c for Gomoku in /home/hirt_r/rendu/gomoku_ai
**
** Made by hirt_r
** Login   <hirt_r@epitech.net>
**
** Started on  Wed Jan 20 17:47:44 2016 hirt_r
** Last update Sat Jan 23 14:19:23 2016 hirt_r
*/

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include "struct_team.h"
#include "struct_pawn.h"
#include "struct_board.h"
#include "struct_tree.h"
#include "board.h"

void		affBoard(t_board *board)
{
  int		i;
  int		j;
  t_pawn	*pawn;

  i = -1;
  while (++i < 19)
    {
      j = -1;
      while (++j < 19)
	{
	  pawn = getPawnAt(board, i, j);
	  if (!pawn)
	    write(1, ".", 1);
	  else if (pawn->team->id == 1)
	    write(1, "X", 1);
	  else
	    write(1, "O", 1);
	}
      write(1, "\n", 1);
    }
  write(1, "-------------------\n\n", 21);
}

int		checkValid(t_board *board, int i, int j)
{
  int		x;
  int		y;
  t_pawn	*pawn;

  x = -3;
  while (++x < 3)
    {
      y = -3;
      while (++y < 3)
	{
	  pawn = getPawnAt(board, i + x, j + y);
	  if (pawn)
	    return (1);
	}
    }
  return (0);
}

void		addItemBranch(t_tree *tree, int i, int j)
{
  t_tree	*tmp;
  t_tree	*newtree;
  t_pawn	*pawn;
  t_team	*team;

  if (tree->level >= tree->board->depth
      || setPawn(tree->board, i, j, tree->level % 2 + 1))
    return;
  if ((newtree = malloc(sizeof(t_tree))) == NULL)
    return;
  newtree->x = i;
  newtree->y = j;
  if ((newtree->eaten = checkEaten(tree->board)))
    team = tree->board->lastp->team;
  /* affBoard(tree->board); */
  newtree->nextd = NULL;
  newtree->nextp = NULL;
  newtree->board = tree->board;
  newtree->prev = tree;
  newtree->level = tree->level + 1;
  if (checkWin(tree->board))
    {
      /* affBoard(tree->board); */
      newtree->value = (tree->level % 2) * - 700 + 400;
    }
    else
    newtree->value = calcValue(newtree);
  if (tree->nextd)
    {
      tmp = tree->nextd;
      while (tmp->nextp)
	tmp = tmp->nextp;
      tmp->nextp = newtree;
    }
  else
    tree->nextd = newtree;
  if (newtree->level < tree->board->depth)
    {
      addBranch(newtree);
    }
  removePawnAt(tree->board, i, j);
  pawn = newtree->eaten;
  while (pawn)
    {
      team->stones -= 1;
      setPawn(tree->board, pawn->x, pawn->y, (tree->level % 2) * - 1 + 2);
      pawn = pawn->next;
    }
  tree->board->level -= 1;
}

void		addBranch(t_tree *tree)
{
  int		i;
  int		j;

  i = -1;
  while (++i < tree->board->width)
    {
      j = -1;
      while (++j < tree->board->height)
	{
	  if (checkValid(tree->board, i, j))
	    addItemBranch(tree, i, j);
	}
    }
}

t_tree		*newTree(t_board *board)
{
  t_tree	*tree;

  if ((tree = malloc(sizeof(t_tree))) == NULL)
    return (NULL);
  tree->board = board;
  tree->prev = NULL;
  tree->nextd = NULL;
  tree->level = 0;
  addBranch(tree);
  return (tree);
}

int		calcValRec(t_tree *tree)
{
  t_tree	*tmp;
  int		max;
  int		val;

  tmp = tree->nextd;
  if (!tmp)
    return (tree->value);
  if (tree->value == -100 || tree->value == 200)
    return (tree->value);
  if (tree->level % 2)
    max = 100;
  else
    max = 0;
  while (tmp)
    {
      val = calcValRec(tmp);
      if (tree->level % 2 && val < max)
	max = val;
      else if (tree->level % 2 == 0 && val > max)
	max = val;
      tmp = tmp->nextp;
    }
  max = (tree->value + max * 6) / 7;
  return (max);
}

t_pawn		*makeAI(t_tree *tree)
{
  t_tree	*tmp;
  t_tree	*best;
  int		val;
  int		max;

  max = 0;
  tmp = tree->nextd;
  best = NULL;
  while (tmp)
    {
      val = calcValRec(tmp);
      if (val >= max)
  	{
  	  max = val;
  	  best = tmp;
  	}
      tmp = tmp->nextp;
    }
    if (best) {
       setPawn(tree->board, best->x, best->y, 1);
    } else {
        setPawn(tree->board, tree->nextd->x, tree->nextd->y, 1);
    }
  return (tree->board->lastp);
}

t_pawn		*setPawnAI(t_board *board)
{
  t_pawn	*pawn;
  t_tree	*tree;

  if (board->level == 0)
    {
      setPawn(board, 10, 10, 1);
      //affBoard(board);
      return (board->lastp);
    }
  if (board->level == 1)
    {
      setPawn(board, board->lastp->x + 1, board->lastp->y, 1);
      //affBoard(board);
      return (board->lastp);
    }
  tree = newTree(board);
  pawn = makeAI(tree);
  board->level += 1;
  return (pawn);
}
