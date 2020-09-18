defmodule ExMonTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.{Player, Game}

  describe "create_player/4" do
    test "returns a player" do
      expected_response = %Player{
        life: 100,
        moves: %{move_avg: :armbar, move_heal: :heal, move_rnd: :kneebar},
        name: "Gabriel"
      }

      assert expected_response == ExMon.create_player("Gabriel", :armbar, :kneebar, :heal)
    end
  end

  describe "start_game/1" do
    test "when the game is started, returns a message" do
      player = Player.build("Gabriel", :armbar, :kneebar, :heal)

      messages =
        capture_io(fn ->
          assert ExMon.start_game(player) == :ok
        end)

      assert messages =~ "The game is started!"
      assert messages =~ "status: :started"
      assert messages =~ "turn: :player"
    end
  end

  describe "make_move/1" do
    setup do
      player = Player.build("Gabriel", :armbar, :kneebar, :heal)

      capture_io(fn ->
        ExMon.start_game(player)
      end)

      :ok
    end

    test "when the move is valid, do the move and the computer makes a move" do
      messages =
        capture_io(fn ->
          ExMon.make_move(:kneebar)
        end)

      assert messages =~ "The Player attacked the computer"
      assert messages =~ "It's computer turn"
      assert messages =~ "It's player turn"
      assert messages =~ "status: :continue"
    end

    test "when the move is invalid, returns a error message" do
      messages =
        capture_io(fn ->
          ExMon.make_move(:supermanpunch)
        end)

      assert messages =~ "Inválid move: supermanpunch!"
    end

    test "when the game is over, returns a message" do
      new_state = %{
        computer: %Player{
          life: 85,
          name: "Rodorfo",
          moves: %{move_avg: :cross, move_heal: :heal, move_rnd: :uppercut}
        },
        player: %Player{
          life: 0,
          name: "Gabriel",
          moves: %{move_avg: :armbar, move_heal: :heal, move_rnd: :kneebar}
        },
        status: :started,
        turn: :player
      }

      Game.update(new_state)

      expected_response = %{new_state | status: :game_over}

      messages =
        capture_io(fn ->
          ExMon.make_move(:kneebar)
        end)

      assert expected_response == Game.info()
      assert messages =~ "The game is over!"
    end
  end
end
