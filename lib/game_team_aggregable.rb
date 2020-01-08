require_relative 'calculable'

module GameTeamAggregable
  extend Calculable

  def self.worst_defense(games, teams)
    teams_counter = games.reduce({}) do |acc, game|
      acc[game.home_team_id] = {games: 0, goals_allowed: 0}
      acc[game.away_team_id] = {games: 0, goals_allowed: 0}
      acc
    end
    games.each do |game|
      teams_counter[game.home_team_id][:games] += 1
      teams_counter[game.away_team_id][:games] += 1
      teams_counter[game.away_team_id][:goals_allowed] += game.home_goals
      teams_counter[game.home_team_id][:goals_allowed] += game.away_goals
    end
    final = teams_counter.max_by do |id, stats|
      stats[:goals_allowed].to_f / stats[:games]
    end[0]
    (teams.find { |team| team.team_id == final }).teamname
  end

  def self.best_defense(games, teams)
    teams_counter = games.reduce({}) do |acc, game|
      acc[game.home_team_id] = {games: 0, goals_allowed: 0}
      acc[game.away_team_id] = {games: 0, goals_allowed: 0}
      acc
    end
    games.each do |game|
      teams_counter[game.home_team_id][:games] += 1
      teams_counter[game.away_team_id][:games] += 1
      teams_counter[game.away_team_id][:goals_allowed] += game.home_goals
      teams_counter[game.home_team_id][:goals_allowed] += game.away_goals
    end
    final = teams_counter.min_by do |id, stats|
      stats[:goals_allowed].to_f / stats[:games]
    end[0]
    (teams.find { |team| team.team_id == final }).teamname
  end
end
