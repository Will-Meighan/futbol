require_relative 'calculable'

module GameteamGameTeamAggregable
  extend Calculable

  def self.accurate_team_calculation(season_id, game_teams, games, teams)
    game_ids = []
    games.each do |game|
      if game.season == season_id
        game_ids << game.game_id
      end
    end
    teams_counter = game_teams.reduce({}) do |acc, game_team|
      if game_ids.include?(game_team.game_id)
        acc[game_team.team_id] = {goals: 0, attempts: 0}
      end
      acc
    end
    game_teams.each do |game_team|
      if game_ids.include?(game_team.game_id)
        teams_counter[game_team.team_id][:goals] += game_team.goals
        teams_counter[game_team.team_id][:attempts] += game_team.shots
      end
    end
    teams_counter
  end

  def self.least_accurate_team(season_id, game_teams, games, teams)
    teams_counter = accurate_team_calculation(season_id, game_teams, games, teams)
    final = teams_counter.max_by do |key, value|
      value[:attempts].to_f / value[:goals]
    end[0]
    (teams.find { |team| final == team.team_id }).teamname
  end
end
