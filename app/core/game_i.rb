module Core
  # Game interface
  class GameI
    def user_board
      # TODO: Refactor using meta-programming
      begin
        @user_board
      rescue NoMethodError
        raise Core::Exceptions::GameNotStarted
      end
    end

    def mines_board
      # TODO: Refactor using meta-programming
      begin
        @mines_board
      rescue NoMethodError
        raise Core::Exceptions::GameNotStarted
      end
    end

    def is_over
      # TODO: Refactor using meta-programming
      begin
        @is_over
      rescue NoMethodError
        raise Core::Exceptions::GameNotStarted
      end
    end

    def new_game!(width:, heigth:, mines:)
      @user_board = Core::UserBoard.new
      @is_over = false
      @user_board.mount_new_board!(width, heigth)
      unless mines.between?(1, @user_board.one_third)
        raise Core::Exceptions::MinesExceeded
      end

      @mines_board = Core::InternalBoard.new
      @mines_board.mount_new_board!(width, heigth)
      mines.times { add_mine }
    end

    def resume_game!(user_board, mine_board, is_over: false)
      @user_board = Core::UserBoard.new
      @user_board.mount_board!(user_board)
      @is_over = is_over

      @mines_board = Core::InternalBoard.new
      @mines_board.mount_board!(mine_board)
    end

    def render_board
      if @is_over
        ignore_cells = [@mines_board.def_cell]
      else
        ignore_cells = [@mines_board.def_cell, Core::Cells::MINE]
      end
      @user_board.merge_and_transfor_to_s(@mines_board, ignore_cells)
    end

    def exec(type_cell:, x:, y:)
      case type_cell.to_sym
      when Core::Cells::SHOW
        explorer_cell(x, y)
      when Core::Cells::QUESTION_FLAG
        toggle_flag(x, y, Core::Cells::QUESTION_FLAG)
      when Core::Cells::RED_FLAG
        toggle_flag(x, y, Core::Cells::RED_FLAG)
      else
        raise Core::Exceptions::InvalidCell
      end
    end

    private

    def explorer_cell(x, y)
      if mines_board[x, y].eql?(Core::Cells::MINE)
        @is_over = true
        raise Core::Exceptions::GameOver
      else
        mines_board.explore_position!(x, y)
        if mines_board.count(mines_board.def_cell).zero?
          @is_over = true
        end
      end
    end

    def toggle_flag(x, y, flag)
      @user_board.toggle_flag!(x: x, y: y, flag: flag)
    end

    def add_mine
      loop do
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
