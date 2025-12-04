# spec/board_spec.rb
require 'spec_helper'

RSpec.describe Board do
  let(:board) { Board.new }

  describe '#initialize' do
    it 'creates an empty 3x3 board' do
      expect(board.board_array.flatten.all? { |cell| cell == ' ' }).to be true
    end

    it 'has 9 cells' do
      expect(board.board_array.flatten.size).to eq(9)
    end

    it 'creates a 3x3 nested array' do
      expect(board.board_array.size).to eq(3)
      expect(board.board_array.all? { |row| row.size == 3 }).to be true
    end
  end

  describe '#make_play' do
    it 'places X marker at specified position' do
      result = board.make_play(:X, 0, 0)
      expect(result).to be true
      expect(board.board_array[0][0]).to eq('X')
    end

    it 'places O marker at specified position' do
      result = board.make_play(:O, 1, 1)
      expect(result).to be true
      expect(board.board_array[1][1]).to eq('O')
    end

    it 'does not overwrite existing marker' do
      board.make_play(:X, 0, 0)
      result = board.make_play(:O, 0, 0)
      expect(result).to be false
      expect(board.board_array[0][0]).to eq('X')
    end

    it 'returns true on successful move' do
      expect(board.make_play(:X, 2, 2)).to be true
    end

    it 'returns false when cell is occupied' do
      board.make_play(:X, 1, 1)
      expect(board.make_play(:O, 1, 1)).to be false
    end

    it 'converts player symbol to string' do
      board.make_play(:X, 0, 0)
      expect(board.board_array[0][0]).to be_a(String)
      expect(board.board_array[0][0]).to eq('X')
    end
  end

  describe '#blank?' do
    it 'returns true for empty cell' do
      expect(board.blank?(' ')).to be true
    end

    it 'returns false for cell with X' do
      expect(board.blank?('X')).to be false
    end

    it 'returns false for cell with O' do
      expect(board.blank?('O')).to be false
    end
  end

  describe '#lines' do
    it 'returns 8 lines (3 rows + 3 cols + 2 diagonals)' do
      expect(board.lines.size).to eq(8)
    end

    it 'includes all rows' do
      board.make_play(:X, 0, 0)
      board.make_play(:X, 0, 1)
      board.make_play(:X, 0, 2)
      
      expect(board.lines[0]).to eq(['X', 'X', 'X'])
    end

    it 'includes all columns' do
      board.make_play(:O, 0, 0)
      board.make_play(:O, 1, 0)
      board.make_play(:O, 2, 0)
      
      expect(board.lines[3]).to eq(['O', 'O', 'O'])
    end

    it 'includes main diagonal' do
      board.make_play(:X, 0, 0)
      board.make_play(:X, 1, 1)
      board.make_play(:X, 2, 2)
      
      expect(board.lines[6]).to eq(['X', 'X', 'X'])
    end

    it 'includes anti-diagonal' do
      board.make_play(:O, 0, 2)
      board.make_play(:O, 1, 1)
      board.make_play(:O, 2, 0)
      
      expect(board.lines[7]).to eq(['O', 'O', 'O'])
    end
  end

  describe '#check_victory' do
    context 'horizontal wins' do
      it 'detects X winner in top row' do
        # X X X
        # - - -
        # - - -
        board.make_play(:X, 0, 0)
        board.make_play(:X, 0, 1)
        board.make_play(:X, 0, 2)
        expect(board.check_victory).to eq('X')
      end

      it 'detects O winner in middle row' do
        # - - -
        # O O O
        # - - -
        board.make_play(:O, 1, 0)
        board.make_play(:O, 1, 1)
        board.make_play(:O, 1, 2)
        expect(board.check_victory).to eq('O')
      end

      it 'detects X winner in bottom row' do
        # - - -
        # - - -
        # X X X
        board.make_play(:X, 2, 0)
        board.make_play(:X, 2, 1)
        board.make_play(:X, 2, 2)
        expect(board.check_victory).to eq('X')
      end
    end

    context 'vertical wins' do
      it 'detects X winner in left column' do
        # X - -
        # X - -
        # X - -
        board.make_play(:X, 0, 0)
        board.make_play(:X, 1, 0)
        board.make_play(:X, 2, 0)
        expect(board.check_victory).to eq('X')
      end

      it 'detects O winner in middle column' do
        # - O -
        # - O -
        # - O -
        board.make_play(:O, 0, 1)
        board.make_play(:O, 1, 1)
        board.make_play(:O, 2, 1)
        expect(board.check_victory).to eq('O')
      end

      it 'detects X winner in right column' do
        # - - X
        # - - X
        # - - X
        board.make_play(:X, 0, 2)
        board.make_play(:X, 1, 2)
        board.make_play(:X, 2, 2)
        expect(board.check_victory).to eq('X')
      end
    end

    context 'diagonal wins' do
      it 'detects X winner in main diagonal' do
        # X - -
        # - X -
        # - - X
        board.make_play(:X, 0, 0)
        board.make_play(:X, 1, 1)
        board.make_play(:X, 2, 2)
        expect(board.check_victory).to eq('X')
      end

      it 'detects O winner in anti-diagonal' do
        # - - O
        # - O -
        # O - -
        board.make_play(:O, 0, 2)
        board.make_play(:O, 1, 1)
        board.make_play(:O, 2, 0)
        expect(board.check_victory).to eq('O')
      end
    end

    context 'no winner' do
      it 'returns nil when board is empty' do
        expect(board.check_victory).to be_nil
      end

      it 'returns nil when game is in progress' do
        board.make_play(:X, 0, 0)
        board.make_play(:O, 0, 1)
        expect(board.check_victory).to be_nil
      end

      it 'returns nil for almost-win scenario' do
        # X X -
        # - - -
        # - - -
        board.make_play(:X, 0, 0)
        board.make_play(:X, 0, 1)
        expect(board.check_victory).to be_nil
      end

      it 'returns nil for a tie game' do
        # X O X
        # O X X
        # O X O
        board.make_play(:X, 0, 0)
        board.make_play(:O, 0, 1)
        board.make_play(:X, 0, 2)
        board.make_play(:O, 1, 0)
        board.make_play(:X, 1, 1)
        board.make_play(:X, 1, 2)
        board.make_play(:O, 2, 0)
        board.make_play(:X, 2, 1)
        board.make_play(:O, 2, 2)
        expect(board.check_victory).to be_nil
      end
    end
  end

  describe 'edge cases' do
    it 'handles corner positions correctly' do
      expect(board.make_play(:X, 0, 0)).to be true
      expect(board.make_play(:O, 0, 2)).to be true
      expect(board.make_play(:X, 2, 0)).to be true
      expect(board.make_play(:O, 2, 2)).to be true
    end

    it 'handles center position correctly' do
      expect(board.make_play(:X, 1, 1)).to be true
      expect(board.board_array[1][1]).to eq('X')
    end

    it 'correctly rejects multiple plays on same position' do
      board.make_play(:X, 1, 1)
      expect(board.make_play(:O, 1, 1)).to be false
      expect(board.make_play(:X, 1, 1)).to be false
    end

    it 'detects victory immediately after winning move' do
      board.make_play(:X, 0, 0)
      board.make_play(:X, 0, 1)
      expect(board.check_victory).to be_nil
      board.make_play(:X, 0, 2)
      expect(board.check_victory).to eq('X')
    end

    it 'maintains board integrity after multiple operations' do
      board.make_play(:X, 0, 0)
      board.make_play(:O, 1, 1)
      board.make_play(:X, 2, 2)
      
      expect(board.board_array[0][0]).to eq('X')
      expect(board.board_array[1][1]).to eq('O')
      expect(board.board_array[2][2]).to eq('X')
      expect(board.board_array[0][1]).to eq(' ')
    end
  end
end