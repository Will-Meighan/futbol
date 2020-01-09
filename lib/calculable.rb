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

  def teams_counter_hash_for_accuracy_methods(game_teams, game_ids)
    game_teams.reduce({}) do |acc, game_team|
      if game_ids.include?(game_team.game_id)
        acc[game_team.team_id] = {goals: 0, attempts: 0}
      end
      acc
    end
  end

  def game_teams_collection_total_goals_and_games(game_teams)
    game_teams.reduce({}) do |acc, game_team|
      acc[game_team.team_id] = {:total_games => 0, :total_goals => 0}
      acc
    end
  end

  def accuracy_incrementer(game_teams, game_ids, teams_counter)
    game_teams.each do |game_team|
      if game_ids.include?(game_team.game_id)
        teams_counter[game_team.team_id][:goals] += game_team.goals
        teams_counter[game_team.team_id][:attempts] += game_team.shots
      end
    end
  end

  def hash_creation_and_accumulation_total_goals_per_game(game_teams)
    game_teams.reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] +=1
      acc
    end
  end

  def count_of_games_by_season(games)
      games.reduce(Hash.new(0)) do |acc, game_1|
        acc[game_1.season] += 1
        acc
      end
    end
end
