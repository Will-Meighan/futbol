require 'csv'
require_relative 'csv_loadable'
require_relative 'calculable'

class GameTeam
  extend CsvLoadable
  extend Calculable

  attr_reader :game_id,
              :team_id,
              :hoa,
              :result,
              :head_coach,
              :goals,
              :shots,
              :tackles

  @@game_teams = []

  def self.from_csv(file_path)
    create_instances(file_path, GameTeam)
    @@game_teams = @objects
  end

  def initialize(game_team_info)
    @game_id = game_team_info[:game_id].to_i
    @team_id = game_team_info[:team_id].to_i
    @hoa = game_team_info[:hoa]
    @result = game_team_info[:result]
    @head_coach = game_team_info[:head_coach]
    @goals = game_team_info[:goals].to_i
    @shots = game_team_info[:shots].to_i
    @tackles = game_team_info[:tackles].to_i
  end

  def self.percentage_visitor_wins
    away_games = @@game_teams.count do |game_team|
      game_team.hoa == "away"
    end
    away_wins = @@game_teams.count do |game_team|
      game_team.result == "WIN" && game_team.hoa == "away"
    end
    average_of(away_wins, away_games)
  end

  def self.percentage_home_wins
    total_wins = 0
    total_games = 0
    @@game_teams.each do |game|
      total_wins += 1 if game.hoa == "home" && game.result == "WIN"
    end
    @@game_teams.each do |game|
      total_games += 1 if game.hoa == "home"
    end
    average_of(total_wins, total_games)
  end

  def self.most_goals_scored(team_id)
    team = []
    @@game_teams.map do |game|
      if game.team_id.to_s == team_id
        team << game.goals
      end
    end
    team.max
  end

  def self.fewest_goals_scored(team_id)
    team = []
    @@game_teams.map do |game|
      if game.team_id.to_s == team_id
        team << game.goals
      end
    end
    team.min
  end

  def self.average_win_percentage(id)
    total_games = @@game_teams.find_all { |game_team| game_team.team_id == id.to_i }
    games_won = total_games.find_all { |game_team| game_team.result == "WIN" }
    (games_won.length / total_games.length.to_f).round(2)
  end
end
