module Core
  class Game
    def flags_board
      begin
        @flags_board
      rescue NoMethodError
        raise Core::Exceptions::GameNotStarted
      end
    end

    def user_board
      begin
        @user_board
      rescue NoMethodError
        raise Core::Exceptions::GameNotStarted
      end
    end

    def mines_board
      begin
        @mines_board
      rescue NoMethodError
        raise Core::Exceptions::GameNotStarted
      end
    end

    def new_game(width:, heigth:, mines:)
      @user_board = Core::UserBoard.new(width, heigth)
      unless mines.between?(1, @user_board.one_third)
        raise Core::Exceptions::MinesExceeded
      end
      @mines_board = Core::InternalBoard.new(width, heigth)
      @flags_board = Core::InternalBoard.new(width, heigth)
      mines.times { add_mine }
    end

    private

    def add_mine
      while true
        x = rand(@user_board.width)
        y = rand(@user_board.heigth)
        if @mines_board.cell_is_void?(x, y)
          @mines_board[x, y] = Core::Cells::MINE
          break
        end
      end
    end
  end
end