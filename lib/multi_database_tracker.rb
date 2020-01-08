require_relative 'game_team'
require_relative 'game'
require_relative 'team'

class MultiDatabaseTracker
  attr_reader :game_path, :team_path, :game_teams_path, :game_teams, :games, :teams

  def self.from_csv(locations)
    game_path = locations[:games]
    team_path = locations[:teams]
    game_teams_path = locations[:game_teams]
    MultiDatabaseTracker.new(game_path, team_path, game_teams_path)
  end

  def initialize(game_path, team_path, game_teams_path)
    @game_teams = GameTeam.from_csv(game_teams_path)
    @games = Game.from_csv(game_path)
    @teams = Team.from_csv(team_path)
  end

  def worst_fans
    unique_teams = @game_teams.reduce({}) do |acc, game_team|
      acc[game_team.team_id] = {away: 0, home: 0}
      acc
    end

    @game_teams.each do |game_team|
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
      @teams.find do |team1|
        team2 == team1.team_id
      end
    end

    finnalist = final.map do |team|
      team.teamname
    end
  end
end
