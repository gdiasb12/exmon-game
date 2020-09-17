defmodule ExMon.GameTest do
  use ExUnit.Case

  alias ExMon.{Game, Player}

  describe "start/2" do
    test "start the game state" do
      player = Player.build("Gabriel", :armbar, :kneebar, :heal)
      computer = Player.build("Rodorfo", :cross, :uppercut, :heal)

      assert {:ok, _pid} = Game.start(computer, player)
    end
  end

  describe "info/0" do
    test "returns the current game state" do
      player = Player.build("Gabriel", :armbar, :kneebar, :heal)
      computer = Player.build("Rodorfo", :cross, :uppercut, :heal)

      Game.start(computer, player)

      expected_response = %{
        computer: %Player{
          life: 100,
          moves: %{move_avg: :cross, move_heal: :uppercut, move_rnd: :heal},
          name: "Rodorfo"
        },
        player: %Player{
          life: 100,
          moves: %{move_avg: :armbar, move_heal: :kneebar, move_rnd: :heal},
          name: "Gabriel"
        },
        status: :started,
        turn: :player
      }

      assert expected_response == Game.info()
    end
  end

  describe "update/1" do
    test "returns the game state updated" do
      player = Player.build("Gabriel", :armbar, :kneebar, :heal)
      computer = Player.build("Rodorfo", :cross, :uppercut, :heal)

      Game.start(computer, player)

      expected_response = %{
        computer: %Player{
          life: 100,
          moves: %{move_avg: :cross, move_heal: :uppercut, move_rnd: :heal},
          name: "Rodorfo"
        },
        player: %Player{
          life: 100,
          moves: %{move_avg: :armbar, move_heal: :kneebar, move_rnd: :heal},
          name: "Gabriel"
        },
        status: :started,
        turn: :player
      }

      assert expected_response == Game.info()

      new_state = %{
        computer: %Player{
          life: 85,
          moves: %{move_avg: :cross, move_heal: :uppercut, move_rnd: :heal},
          name: "Rodorfo"
        },
        player: %Player{
          life: 50,
          moves: %{move_avg: :armbar, move_heal: :kneebar, move_rnd: :heal},
          name: "Gabriel"
        },
        status: :started,
        turn: :player
      }

      Game.update(new_state)

      expected_response = %{new_state | turn: :computer, status: :continue}

      assert expected_response == Game.info()
    end
  end

  describe "player/0" do
    test "returns the player created" do
      player = Player.build("Gabriel", :armbar, :kneebar, :heal)
      computer = Player.build("Rodorfo", :cross, :uppercut, :heal)

      Game.start(computer, player)

      expected_response = %Player{
        life: 100,
        moves: %{move_avg: :armbar, move_heal: :kneebar, move_rnd: :heal},
        name: "Gabriel"
      }

      assert expected_response == Game.player()
    end
  end

  describe "turn/0" do
    test "returns whose turn it is" do
      player = Player.build("Gabriel", :armbar, :kneebar, :heal)
      computer = Player.build("Rodorfo", :cross, :uppercut, :heal)

      Game.start(computer, player)

      assert :player == Game.turn()
    end
  end

  describe "fetch_player/1" do
    test "returns info about a player" do
      player = Player.build("Gabriel", :armbar, :kneebar, :heal)
      computer = Player.build("Rodorfo", :cross, :uppercut, :heal)

      Game.start(computer, player)

      expected_response = %Player{
        life: 100,
        moves: %{move_rnd: :heal, move_avg: :armbar, move_heal: :kneebar},
        name: "Gabriel"
      }

      assert expected_response == Game.fetch_player(:player)
    end
  end
end
