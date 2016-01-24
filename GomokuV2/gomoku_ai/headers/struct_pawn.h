/*
** struct_pawn.h for GOmoku in /home/hirt_r/rendu/gomoku_ai
**
** Made by hirt_r
** Login   <hirt_r@epitech.net>
**
** Started on  Sat Jan 16 15:54:18 2016 hirt_r
** Last update Sun Jan 17 17:06:44 2016 hirt_r
*/

#ifndef STRUCT_PAWN_H_
# define STRUCT_PAWN_H_

typedef struct	s_pawn
{
  int		x;
  int		y;
  t_team	*team;
  struct s_pawn	*next;
  struct s_pawn	*prev;
}		t_pawn;

#endif /* !STRUCT_PAWN_H_ */
