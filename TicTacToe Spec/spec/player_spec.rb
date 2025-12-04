# spec/player_spec.rb
require 'spec_helper'

RSpec.describe Player do
  describe '#initialize' do
    it 'creates a player with X marker' do
      player = Player.new(:X)
      expect(player.player).to eq(:X)
    end

    it 'creates a player with O marker' do
      player = Player.new(:O)
      expect(player.player).to eq(:O)
    end

    it 'stores the player marker' do
      player = Player.new(:X)
      expect(player.player).not_to be_nil
    end
  end

  describe '#player' do
    it 'returns the player marker' do
      player_x = Player.new(:X)
      player_o = Player.new(:O)
      
      expect(player_x.player).to eq(:X)
      expect(player_o.player).to eq(:O)
    end

    it 'is a readable attribute' do
      player = Player.new(:X)
      expect(player).to respond_to(:player)
    end

    it 'returns a symbol' do
      player = Player.new(:X)
      expect(player.player).to be_a(Symbol)
    end
  end

  describe 'player instances' do
    it 'creates distinct players' do
      player1 = Player.new(:X)
      player2 = Player.new(:O)
      
      expect(player1.player).not_to eq(player2.player)
    end

    it 'maintains player identity' do
      player = Player.new(:X)
      expect(player.player).to eq(:X)
      expect(player.player).to eq(:X) # should remain the same
    end
  end

  describe 'using doubles for Player' do
    it 'creates a double for player X' do
      player_double = double('Player', player: :X)
      expect(player_double.player).to eq(:X)
    end

    it 'creates a double for player O' do
      player_double = double('Player', player: :O)
      expect(player_double.player).to eq(:O)
    end

    it 'simulates player behavior with double' do
      player_mock = instance_double('Player', player: :X)
      allow(player_mock).to receive(:player).and_return(:X)
      
      expect(player_mock.player).to eq(:X)
    end
  end

  describe 'edge cases' do
    it 'can create player with any symbol' do
      player = Player.new(:TEST)
      expect(player.player).to eq(:TEST)
    end

    it 'stores the exact value provided' do
      player = Player.new('X')
      expect(player.player).to eq('X')
    end
  end
end