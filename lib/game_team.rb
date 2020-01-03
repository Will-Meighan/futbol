require 'csv'
require_relative 'csv_loadable'

class GameTeam
  extend CsvLoadable

  attr_reader :game_id,
              :team_id,
              :hoa,
              :result,
              :settled_in,
              :head_coach,
              :goals,
              :shots,
              :tackles,
              :pim,
              :powerplayopportunities,
              :powerplaygoals,
              :faceoffwinpercentage,
              :giveaways,
              :takeaways

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
      @settled_in = game_team_info[:settled_in]
      @head_coach = game_team_info[:head_coach]
      @goals = game_team_info[:goals].to_i
      @shots = game_team_info[:shots].to_i
      @tackles = game_team_info[:tackles].to_i
      @pim = game_team_info[:pim].to_i
      @powerplayopportunities = game_team_info[:powerplayopportunities].to_i
      @powerplaygoals = game_team_info[:powerplaygoals].to_i
      @faceoffwinpercentage = game_team_info[:faceoffwinpercentage].to_f
      @giveaways = game_team_info[:giveaways].to_i
      @takeaways = game_team_info[:takeaways].to_i
    end


    def self.percentage_visitor_wins
      away_games = @@game_teams.count do |game_team|
         game_team.hoa == "away"
      end
      away_wins = @@game_teams.count do |game_team|
        game_team.result == "WIN" && game_team.hoa == "away"
      end
      (away_wins.to_f / away_games).round(2)

  def self.percentage_visitor_wins
    away_games = @@game_teams.count do |game_team|
        game_team.hoa == "away"
    end
    away_wins = @@game_teams.count do |game_team|
      game_team.result == "WIN" && game_team.hoa == "away"

    end
      (away_wins.to_f / away_games * 100).round(2)
  end

  def self.percentage_home_wins
      total_wins = 0
      total_games = 0
      @@game_teams.each do |game|
        if game.hoa == "home" && game.result == "WIN"
          total_wins += 1
        end
      end
      @@game_teams.each do |game|
        if game.hoa == "home"
          total_games += 1
        end
      end

      (total_wins.to_f / total_games).round(2)

      ((total_wins.to_f / total_games) * 100).round(2)
  end

  def self.best_offense
    team_goals = @@game_teams.reduce({}) do |acc, game_team|
      acc[game_team.team_id] = 0
      acc

    end
     @@game_teams.each do |game_team|
      team_goals[game_team.team_id] += game_team.goals
    end
    team_goals
    end
    total_games = @@game_teams.count do |game_team|
      game_team.team_id
    end
    total_games
  end
