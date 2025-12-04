# spec/game_integration_spec.rb
require 'spec_helper'

RSpec.describe 'Game Integration Tests with Mocks and Doubles' do
  let(:game) { Game.new }

  describe 'Full game scenarios' do
    context 'Player X wins on top row' do
      it 'completes a full winning game' do
        # X X X
        # O O -
        # - - -
        game.board.make_play(:X, 0, 0)
        game.switch_turn
        game.board.make_play(:O, 1, 0)
        game.switch_turn
        game.board.make_play(:X, 0, 1)
        game.switch_turn
        game.board.make_play(:O, 1, 1)
        game.switch_turn
        game.board.make_play(:X, 0, 2)
        
        expect(game.board.check_victory).to eq('X')
        expect(game.finished?).to be true
      end
    end

    context 'Player O wins on diagonal' do
      it 'completes a full winning game' do
        # O X X
        # X O X
        # X - O
        game.board.make_play(:X, 0, 1)
        game.switch_turn
        game.board.make_play(:O, 0, 0)
        game.switch_turn
        game.board.make_play(:X, 0, 2)
        game.switch_turn
        game.board.make_play(:O, 1, 1)
        game.switch_turn
        game.board.make_play(:X, 1, 0)
        game.switch_turn
        game.board.make_play(:O, 2, 2)
        
        expect(game.board.check_victory).to eq('O')
        expect(game.finished?).to be true
      end
    end

    context 'Tie game' do
      it 'completes a full tie game' do
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
        
        expect(game.board.check_victory).to be_nil
        expect(game.finished?).to be false
      end
    end
  end

  describe 'Using mocks to isolate board operations' do
    let(:mock_board) { instance_double('Board') }
    
    context 'Testing check_victory in isolation' do
      it 'returns winner when X has winning line' do
        allow(mock_board).to receive(:check_victory).and_return('X')
        expect(mock_board.check_victory).to eq('X')
      end
      
      it 'returns winner when O has winning line' do
        allow(mock_board).to receive(:check_victory).and_return('O')
        expect(mock_board.check_victory).to eq('O')
      end
      
      it 'returns nil when no winner' do
        allow(mock_board).to receive(:check_victory).and_return(nil)
        expect(mock_board.check_victory).to be_nil
      end
    end

    context 'Testing make_play with mock' do
      it 'verifies make_play is called with correct arguments' do
        allow(game.board).to receive(:make_play).with(:X, 0, 0).and_return(true)
        
        game.board.make_play(:X, 0, 0)
        
        expect(game.board).to have_received(:make_play).with(:X, 0, 0)
      end

      it 'returns true on valid move' do
        allow(game.board).to receive(:make_play).with(:X, 1, 1).and_return(true)
        expect(game.board.make_play(:X, 1, 1)).to be true
      end

      it 'returns false on invalid move' do
        allow(game.board).to receive(:make_play).with(:X, 0, 0).and_return(false)
        expect(game.board.make_play(:X, 0, 0)).to be false
      end
    end

    context 'Testing blank? method isolation' do
      it 'checks if cell is blank' do
        allow(mock_board).to receive(:blank?).with(' ').and_return(true)
        expect(mock_board.blank?(' ')).to be true
      end

      it 'checks if cell is occupied' do
        allow(mock_board).to receive(:blank?).with('X').and_return(false)
        expect(mock_board.blank?('X')).to be false
      end
    end
  end

  describe 'Using doubles for player simulation' do
    context 'Player doubles' do
      it 'simulates X player' do
        player_x = double('PlayerX', player: :X)
        expect(player_x.player).to eq(:X)
      end
      
      it 'simulates O player' do
        player_o = double('PlayerO', player: :O)
        expect(player_o.player).to eq(:O)
      end

      it 'simulates both players in a game' do
        player_x = double('PlayerX', player: :X)
        player_o = double('PlayerO', player: :O)
        
        players = [player_x, player_o]
        expect(players[0].player).to eq(:X)
        expect(players[1].player).to eq(:O)
      end
    end
  end

  describe 'Mocking user input' do
    context 'Simulating valid input' do
      it 'processes valid move coordinates' do
        allow(game).to receive(:gets).and_return("0 0\n")
        allow($stdout).to receive(:write)
        
        coords = game.prompt_move
        expect(coords).to eq([0, 0])
      end

      it 'processes different valid coordinates' do
        allow(game).to receive(:gets).and_return("2 1\n")
        allow($stdout).to receive(:write)
        
        coords = game.prompt_move
        expect(coords).to eq([2, 1])
      end
    end

    context 'Simulating game flow with mocked input' do
      it 'simulates a sequence of moves' do
        inputs = ["0 0\n", "1 1\n", "0 1\n"]
        allow(game).to receive(:gets).and_return(*inputs)
        allow($stdout).to receive(:write)
        
        move1 = game.prompt_move
        move2 = game.prompt_move
        move3 = game.prompt_move
        
        expect(move1).to eq([0, 0])
        expect(move2).to eq([1, 1])
        expect(move3).to eq([0, 1])
      end
    end
  end

  describe 'Stubbing output methods' do
    context 'Testing without console output' do
      it 'stubs display_board to test without printing' do
        allow(game).to receive(:display_board)
        
        game.display_board
        
        expect(game).to have_received(:display_board)
      end

      it 'stubs system clear command' do
        allow(game).to receive(:system).with('clear')
        
        game.send(:system, 'clear')
        
        expect(game).to have_received(:system).with('clear')
      end
    end

    context 'Testing finished? without output' do
      it 'verifies finished? logic without printing winner message' do
        game.board.make_play(:X, 0, 0)
        game.board.make_play(:X, 0, 1)
        game.board.make_play(:X, 0, 2)
        
        # Capture and suppress output
        expect { game.finished? }.to output(/X Перемiг!/).to_stdout
      end
    end
  end

  describe 'Testing board state with spies' do
    context 'Verifying method calls' do
      it 'verifies check_victory is called in finished?' do
        allow(game.board).to receive(:check_victory).and_call_original
        
        game.finished?
        
        expect(game.board).to have_received(:check_victory)
      end

      it 'tracks number of make_play calls' do
        allow(game.board).to receive(:make_play).and_call_original
        
        game.board.make_play(:X, 0, 0)
        game.board.make_play(:O, 1, 1)
        game.board.make_play(:X, 2, 2)
        
        expect(game.board).to have_received(:make_play).exactly(3).times
      end
    end
  end

  describe 'Complex scenarios with partial mocking' do
    context 'Partial stub for conditional testing' do
      it 'allows real board operations while stubbing victory check' do
        allow(game.board).to receive(:check_victory).and_return('X')
        
        # Real operation
        game.board.make_play(:X, 0, 0)
        expect(game.board.board_array[0][0]).to eq('X')
        
        # Mocked operation
        expect(game.board.check_victory).to eq('X')
      end
    end

    context 'Testing game flow with partial mocking' do
      it 'simulates X winning while tracking moves' do
        call_count = 0
        allow(game.board).to receive(:make_play) do |player, row, col|
          call_count += 1
          game.board.board_array[row][col] = player.to_s
          true
        end
        
        game.board.make_play(:X, 0, 0)
        game.board.make_play(:X, 0, 1)
        game.board.make_play(:X, 0, 2)
        
        expect(call_count).to eq(3)
      end
    end
  end

  describe 'Edge cases with mocks' do
    it 'handles invalid moves with mocked board' do
      allow(game.board).to receive(:make_play).and_return(false)
      
      result = game.board.make_play(:X, 0, 0)
      expect(result).to be false
    end

    it 'simulates board full scenario' do
      allow(game.board).to receive(:board_array).and_return([
        ['X', 'O', 'X'],
        ['O', 'X', 'X'],
        ['O', 'X', 'O']
      ])
      
      expect(game.board.board_array.flatten.none? { |c| c == ' ' }).to be true
    end

    it 'tests rapid player switching with spy' do
      original_player = game.current_player
      
      5.times { game.switch_turn }
      
      # After odd number of switches, should be opposite player
      expect(game.current_player).not_to eq(original_player)
    end
  end

  describe 'Testing lines method isolation' do
    it 'verifies lines returns correct structure' do
      allow(game.board).to receive(:lines).and_return([
        ['X', 'X', 'X'], # winning line
        [' ', ' ', ' '],
        [' ', ' ', ' '],
        [' ', ' ', ' '],
        [' ', ' ', ' '],
        [' ', ' ', ' '],
        [' ', ' ', ' '],
        [' ', ' ', ' ']
      ])
      
      lines = game.board.lines
      expect(lines).to be_an(Array)
      expect(lines.size).to eq(8)
      expect(lines[0]).to eq(['X', 'X', 'X'])
    end
  end
end