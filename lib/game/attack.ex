defmodule ExMon.Game.Attack do
  def attack_oponnent(turn, move) do
    case turn do
      :player -> "Atacar computador com #{move}"
      :computer -> "Atacar jogador com #{move}"
    end
  end
end
