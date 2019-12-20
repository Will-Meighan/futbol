require_relative 'game_team'
require_relative 'game'
require_relative 'team'

class StatTracker
  attr_reader :game_path, :team_path, :game_teams_path, :game_teams, :games, :teams

  def self.from_csv(locations)
    game_path = locations[:games]
    team_path = locations[:teams]
    game_teams_path = locations[:game_teams]
    StatTracker.new(game_path, team_path, game_teams_path)
  end

  def initialize(game_path, team_path, game_teams_path)
    @game_path = game_path
    @team_path = team_path
    @game_teams_path = game_teams_path
    @game_teams = GameTeam.from_csv(@game_teams_path)
    @games = Game.from_csv(@game_path)
    @teams = Team.from_csv(@team_path)
  end

  def highest_total_score
    Game.highest_total_score
  end

  def lowest_total_score
    Game.lowest_total_score
  end

  def biggest_blowout
    Game.biggest_blowout
  end

  def average_goals_per_game
    Game.average_goals_per_game
  end

  def percentage_home_wins
    GameTeam.percentage_home_wins
  end

  def percentage_visitor_wins
    GameTeam.percentage_visitor_wins
  end

  def percentage_ties
    Game.percentage_ties
  end

  def count_of_games_by_season
    Game.count_of_games_by_season
  end

  def best_offense
    team_goals = @game_teams.reduce({}) do |acc, game_team|
      acc[game_team.team_id] = 0
      acc
    end
     @game_teams.each do |game_team|
      team_goals[game_team.team_id] += game_team.goals
    end
    team_goals

    total_games = @game_teams.reduce({}) do |acc, game_team|
      acc[game_team.team_id] = 0
      acc
    end
    @game_teams.each do |game_team|
      total_games[game_team.team_id] += 1
    end
    total_games

    average = team_goals.merge(total_games) do |key, team_goals, total_games|
      team_goals / total_games.to_f
    end
    best_o = average.max_by do |k, v|
      v
    end
    final = @teams.find do |team|
      team.team_id == best_o[0]
    end
    final.teamname
  end
end
