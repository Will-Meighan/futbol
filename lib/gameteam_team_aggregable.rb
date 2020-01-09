require_relative 'calculable'

module GameteamTeamAggregable
  extend Calculable

  def self.worst_fans(game_teams, teams)
    unique_teams = game_team_ids_away_home(game_teams)

    game_teams.each do |game_team|
      if game_team.hoa == "away" && game_team.result == "WIN"
        unique_teams[game_team.team_id][:away] += 1
      elsif game_team.hoa == "home" && game_team.result == "WIN"
        unique_teams[game_team.team_id][:home] += 1
      end
    end

    worst_fans_are = unique_teams.find_all do |key, value|
      value[:away] > value[:home]
    end.to_h

    worst_teams = worst_fans_are.to_h.keys

    final = worst_teams.map do |team2|
      teams.find do |team1|
        team2 == team1.team_id
      end
    end

    final.map { |team| team.teamname }
  end

  def self.best_fans(game_teams, teams)
    unique_teams = game_team_ids(game_teams, 0)
    game_teams.each do |game_team|
      unique_teams[game_team.team_id] += 1 if game_team.hoa == "away" && game_team.result == "WIN"
    end

    best_fans = unique_teams.min_by do |team|
      team[1]
    end

    teams.find do |team|
      team.team_id == best_fans[0]
    end.teamname
  end

  def self.best_offense(game_teams, teams)
    team_goals = game_team_ids(game_teams, 0)

     game_teams.each do |game_team|
      team_goals[game_team.team_id] += game_team.goals
    end
    total_games = game_teams.reduce({}) do |acc, game_team|
      acc[game_team.team_id] = 0
      acc
    end
    game_teams.each { |game_team| total_games[game_team.team_id] += 1 }
    average = team_goals.merge(total_games) do |key, team_goal, game|
      team_goal / game.to_f
    end
    best_o = average.max_by { |k, v| v }
    teams.find do |team|
      team.team_id == best_o[0]
    end.teamname
  end

  def self.worst_offense(game_teams, teams)
    team_goals = game_team_ids(game_teams, 0)

     game_teams.each do |game_team|

      team_goals[game_team.team_id] += game_team.goals
    end
    total_games = game_teams.reduce({}) do |acc, game_team|
      acc[game_team.team_id] = 0
      acc
    end
    game_teams.each { |game_team| total_games[game_team.team_id] += 1 }
    average = team_goals.merge(total_games) do |key, team_goal, game|
      team_goal / game.to_f
    end
    worst_o = average.min_by { |k, v|  v }
    (teams.find { |team| team.team_id == worst_o[0] }).teamname
  end

  def self.highest_scoring_home_team(game_teams, teams)
    team_goals = game_teams.reduce({}) do |acc, game_team|
      acc[game_team.team_id] = {:total_games => 0, :total_goals => 0}
      acc
    end
    game_teams.each do |game_team|
      if game_team.hoa == "home"
        team_goals[game_team.team_id][:total_games] += 1
        team_goals[game_team.team_id][:total_goals] += game_team.goals
      end
    end
    highest_team_id = team_goals.max_by do |k , v|
      v[:total_goals] / v[:total_games].to_f
    end[0]
    (teams.find { |team| team.team_id == highest_team_id }).teamname
  end

  def self.lowest_scoring_home_team(game_teams, teams)
    team_goals = game_teams.reduce({}) do |acc, game_team|
      acc[game_team.team_id] = {:total_games => 0, :total_goals => 0}
      acc
    end
    game_teams.each do |game_team|
      if game_team.hoa == "home"
        team_goals[game_team.team_id][:total_games] += 1
        team_goals[game_team.team_id][:total_goals] += game_team.goals
      end
    end
    lowest_team_id = team_goals.min_by do |k , v|
      v[:total_goals] / v[:total_games].to_f
    end[0]
    (teams.find { |team| team.team_id == lowest_team_id }).teamname
  end

  def self.total_games_per_team(game_teams, teams)
    game_teams.reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] +=1
      acc
    end
  end

  def self.total_team_wins(game_teams, teams)
    game_teams.reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] += 1 if game_team.result == "WIN"
      acc
    end
  end

  def self.team_win_percentage(game_teams, teams)
    total_team_wins(game_teams, teams).merge(total_games_per_team(game_teams, teams)) do |game_team, wins, games|
      (wins.to_f/games).round(2)
    end
  end

  def self.winningest_team(game_teams, teams)
    winningest_team_id = team_win_percentage(game_teams, teams).max_by do |game_team, percentage|
      percentage
    end.first
    (teams.find { |team| team.team_id == winningest_team_id }).teamname
  end

  def self.highest_scoring_visitor(game_teams, teams)
    team_goals = game_team_ids_games_and_goals(game_teams)

    game_teams.each do |game_team|
      if game_team.hoa == "away"
        team_goals[game_team.team_id][:total_games] += 1
        team_goals[game_team.team_id][:total_goals] += game_team.goals
      end
    end
      highest_team_id = team_goals.max_by do |k , v|
      v[:total_goals] / v[:total_games].to_f
    end[0]
    (teams.find { |team| team.team_id == highest_team_id }).teamname
  end

  def self.lowest_scoring_visitor(game_teams, teams)
    all_teams = game_team_ids_games_and_goals(game_teams)

    game_teams.each do |game_team|
      if game_team.hoa == "away"
        all_teams[game_team.team_id][:total_games] += 1
        all_teams[game_team.team_id][:total_goals] += game_team.goals
      end
    end
    worst_team = all_teams.min_by do |key, value|
      value[:total_goals] / value[:total_games].to_f
    end[0]
    (teams.find { |team| team.team_id == worst_team }).teamname
  end
end
