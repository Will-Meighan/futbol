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

  def self.most_accurate_team(season_id, game_teams, games, teams)
     teams_counter = accurate_team_calculation(season_id, game_teams, games, teams)

     final = teams_counter.min_by do |key, value|
       value[:attempts].to_f / value[:goals]
     end[0]

     teams.find do |team|
       final == team.team_id
     end.teamname
  end

  def self.most_tackles(season_id, game_teams, games, teams)
    game_ids = []
    games.find_all do |game|
      if game.season == season_id
        game_ids << game.game_id
      end
    end
    all_teams = game_teams.reduce({}) do |acc, game_team|
      acc[game_team.team_id] = {total_tackles: 0}
      acc
    end
    game_teams.each do |game_team|
      if game_ids.include?(game_team.game_id)
    all_teams[game_team.team_id][:total_tackles] += game_team.tackles
      end
    end
    team_with_most_tackles = all_teams.max_by do |team|
      team.last[:total_tackles]
    end
    (teams.find {|team| team.team_id == team_with_most_tackles.first}).teamname
  end

  def self.fewest_tackles(season_id, game_teams, games, teams)
    game_ids = []
    games.find_all do |game|
      if game.season == season_id
        game_ids << game.game_id
      end
    end
    all_teams = game_teams.reduce({}) do |acc, game_team|
      if game_ids.include?(game_team.game_id)
        acc[game_team.team_id] = {total_tackles: 0}
      end
      acc
    end
    game_teams.each do |game_team|
      if all_teams[game_team.team_id] && game_ids.include?(game_team.game_id)
        all_teams[game_team.team_id][:total_tackles] += game_team.tackles
      end
    end
    team_with_least_tackles = all_teams.min_by do |team|
      team.last[:total_tackles]
    end
    (teams.find {|team| team.team_id == team_with_least_tackles.first}).teamname
  end
end
