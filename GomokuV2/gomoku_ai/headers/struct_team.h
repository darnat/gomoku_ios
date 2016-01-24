/*
** struct_pawn.h for GOmoku in /home/hirt_r/rendu/gomoku_ai
**
** Made by hirt_r
** Login   <hirt_r@epitech.net>
**
** Started on  Sat Jan 16 15:54:18 2016 hirt_r
** Last update Sun Jan 17 16:59:35 2016 hirt_r
*/

#ifndef STRUCT_TEAM_H_
# define STRUCT_TEAM_H_

typedef struct	s_team
{
  int		stones;
  int		id;
  struct s_team	*next;
}		t_team;

#endif /* !STRUCT_TEAM_H_ */
