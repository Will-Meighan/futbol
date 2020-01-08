module Calculable

  def average_of(total, out_of)
    total / out_of.to_f
  end

  def game_team_ids_away_home(data_set)
    data_set.reduce({}) do |acc, game_team|
      acc[game_team.team_id] = {away: 0, home: 0}
      acc
    end
  end

  def game_team_ids_games_and_goals(data_set)
    data_set.reduce({}) do |acc, game_team|
      acc[game_team.team_id] = {:total_games => 0, :total_goals => 0}
      acc
    end
  end

  def game_team_ids(data_set, value)
    data_set.reduce({}) do |acc, game_team|
      acc[game_team.team_id] = value
      acc
    end
  end
end
