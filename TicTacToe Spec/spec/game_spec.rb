# spec/game_spec.rb
require 'spec_helper'

RSpec.describe Game do
  let(:game) { Game.new }

  describe '#initialize' do
    it 'creates a new game with a board' do
      expect(game.board).to be_a(Board)
    end

    it 'sets current player to X by default' do
      expect(game.current_player).to eq(:X)
    end
  end

  describe '#current_player' do
    it 'returns X at the start of game' do
      expect(game.current_player).to eq(:X)
    end

    it 'returns the current turn symbol' do
      expect(game.current_player).to be_a(Symbol)
      expect([:X, :O]).to include(game.current_player)
    end
  end

  describe '#switch_turn' do
    it 'switches from X to O' do
      expect(game.current_player).to eq(:X)
      game.switch_turn
      expect(game.current_player).to eq(:O)
    end

    it 'switches from O to X' do
      game.switch_turn
      expect(game.current_player).to eq(:O)
      game.switch_turn
      expect(game.current_player).to eq(:X)
    end

    it 'alternates players correctly over multiple turns' do
      expect(game.current_player).to eq(:X)
      game.switch_turn
      expect(game.current_player).to eq(:O)
      game.switch_turn
      expect(game.current_player).to eq(:X)
      game.switch_turn
      expect(game.current_player).to eq(:O)
    end
  end

  describe '#finished?' do
    it 'returns false when game just started' do
      expect(game.finished?).to be false
    end

    it 'returns true and announces winner when X wins' do
      game.board.make_play(:X, 0, 0)
      game.board.make_play(:X, 0, 1)
      game.board.make_play(:X, 0, 2)
      
      expect { game.finished? }.to output(/X Перемiг!/).to_stdout
      expect(game.finished?).to be true
    end

    it 'returns true and announces winner when O wins' do
      game.board.make_play(:O, 1, 0)
      game.board.make_play(:O, 1, 1)
      game.board.make_play(:O, 1, 2)
      
      expect { game.finished? }.to output(/O Перемiг!/).to_stdout
      expect(game.finished?).to be true
    end

    it 'returns false when game is in progress' do
      game.board.make_play(:X, 0, 0)
      game.board.make_play(:O, 1, 1)
      expect(game.finished?).to be false
    end

    it 'returns false for almost-win scenario' do
      game.board.make_play(:X, 0, 0)
      game.board.make_play(:X, 0, 1)
      expect(game.finished?).to be false
    end
  end

  describe '#display_board' do
    it 'displays the board' do
      expect { game.display_board }.to output(/\-{13}/).to_stdout
    end

    it 'shows empty board initially' do
      output = capture_stdout { game.display_board }
      expect(output).to match(/\|   \|   \|   \|/)
    end

    it 'shows markers after placement' do
      game.board.make_play(:X, 0, 0)
      game.board.make_play(:O, 1, 1)
      output = capture_stdout { game.display_board }
      expect(output).to include('X')
      expect(output).to include('O')
    end
  end

  describe '#prompt_move' do
    it 'prompts for move input' do
      allow(game).to receive(:gets).and_return("0 0\n")
      expect { game.prompt_move }.to output(/Введи свій хiд/).to_stdout
    end

    it 'returns array of two integers' do
      allow(game).to receive(:gets).and_return("1 2\n")
      allow($stdout).to receive(:write)
      result = game.prompt_move
      expect(result).to eq([1, 2])
      expect(result).to all(be_an(Integer))
    end

    it 'parses space-separated input correctly' do
      allow(game).to receive(:gets).and_return("2 1\n")
      allow($stdout).to receive(:write)
      expect(game.prompt_move).to eq([2, 1])
    end
  end

  describe 'victory detection integration' do
    context 'X wins scenarios' do
      it 'detects X winning on top row' do
        game.board.make_play(:X, 0, 0)
        game.board.make_play(:X, 0, 1)
        game.board.make_play(:X, 0, 2)
        expect(game.finished?).to be true
      end

      it 'detects X winning on main diagonal' do
        game.board.make_play(:X, 0, 0)
        game.board.make_play(:X, 1, 1)
        game.board.make_play(:X, 2, 2)
        expect(game.finished?).to be true
      end
    end

    context 'O wins scenarios' do
      it 'detects O winning on left column' do
        game.board.make_play(:O, 0, 0)
        game.board.make_play(:O, 1, 0)
        game.board.make_play(:O, 2, 0)
        expect(game.finished?).to be true
      end

      it 'detects O winning on anti-diagonal' do
        game.board.make_play(:O, 0, 2)
        game.board.make_play(:O, 1, 1)
        game.board.make_play(:O, 2, 0)
        expect(game.finished?).to be true
      end
    end
  end

  describe 'edge cases' do
    it 'handles full board with no winner' do
      # X O X
      # O X X
      # O X O
      game.board.make_play(:X, 0, 0)
      game.board.make_play(:O, 0, 1)
      game.board.make_play(:X, 0, 2)
      game.board.make_play(:O, 1, 0)
      game.board.make_play(:X, 1, 1)
      game.board.make_play(:X, 1, 2)
      game.board.make_play(:O, 2, 0)
      game.board.make_play(:X, 2, 1)
      game.board.make_play(:O, 2, 2)
      
      expect(game.finished?).to be false
    end

    it 'correctly switches players after each turn' do
      expect(game.current_player).to eq(:X)
      game.switch_turn
      expect(game.current_player).to eq(:O)
      game.switch_turn
      expect(game.current_player).to eq(:X)
    end
  end
end

# Helper method to capture stdout
def capture_stdout
  original_stdout = $stdout
  $stdout = StringIO.new
  yield
  $stdout.string
ensure
  $stdout = original_stdout
end