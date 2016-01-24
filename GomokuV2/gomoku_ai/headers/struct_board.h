/*
** struct_board.h for Gomoku in /home/hirt_r/rendu/gomoku_ai
**
** Made by hirt_r
** Login   <hirt_r@epitech.net>
**
** Started on  Sat Jan 16 15:51:50 2016 hirt_r
** Last update Sat Jan 23 12:35:50 2016 hirt_r
*/

#ifndef STRUCT_BOARD_H_
# define STRUCT_BOARD_H_

typedef	struct		s_board
{
  int			width;
  int			height;
  t_pawn		*pawns;
  t_team		*teams;
  t_pawn		*lastp;
  int			level;
  int			depth;
}			t_board;

int	setPawn(t_board *, int, int, int);
t_board *getBoard(int);

#endif /* !STRUCT_BOARD_H_ */
