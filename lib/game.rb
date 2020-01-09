require 'csv'
require_relative 'csv_loadable'
require_relative 'calculable'

class Game
  extend Calculable
  extend CsvLoadable

  attr_reader :game_id,
              :season,
              :type,
              :away_team_id,
              :home_team_id,
              :away_goals,
              :home_goals

  @@games = []

  def self.from_csv(file_path)
    create_instances(file_path, Game)
    @@games = @objects
  end

  def initialize(game_info)
    @game_id  = game_info[:game_id].to_i
    @season  = game_info[:season]
    @type  = game_info[:type]
    @away_team_id = game_info[:away_team_id].to_i
    @home_team_id = game_info[:home_team_id].to_i
    @away_goals = game_info[:away_goals].to_i
    @home_goals = game_info[:home_goals].to_i
  end

  def self.highest_total_score
    most_goals = @@games.max_by { |game| game.home_goals + game.away_goals }
    most_goals.home_goals + most_goals.away_goals
  end

  def self.lowest_total_score
    least_goals = @@games.min_by { |game| game.home_goals + game.away_goals }
    least_goals.home_goals + least_goals.away_goals
  end

  def self.count_of_games_by_season
    @@games.reduce(Hash.new(0)) do |acc, game_1|
      acc[game_1.season] += 1
      acc
    end
  end

  def self.average_goals_per_game
    total_games = 0
    total_goals = @@games.reduce(0) do |acc, game|
      total_games += 1
      acc += game.away_goals
      acc += game.home_goals
    end
    average_of(total_goals, total_games).round(2)
  end

  def self.average_goals_by_season
    goal_count_per_season = @@games.reduce(Hash.new(0)) do |acc, game|
      acc[game.season] += (game.home_goals + game.away_goals)
      acc
    end
    self.count_of_games_by_season.merge(goal_count_per_season) do |key, game_count, goal_count|
      average_of(goal_count, game_count).round(2)
    end
  end

  def self.biggest_blowout
    all_abs_vals = []
    @@games.each do |game|
      all_abs_vals << (game.home_goals - game.away_goals).abs
    end
    all_abs_vals.max
  end

  def self.percentage_ties
    total_games = 0
    total_ties = @@games.count do |game|
      total_games += 1
      game.away_goals == game.home_goals
    end
    average_of(total_ties, total_games).round(2)
  end

  def self.seasonal_summary_data(team_id)
    @@games.reduce({}) do |acc, game|
      if game.away_team_id.to_s == team_id || game.home_team_id.to_s == team_id
        acc[game.season] = {
          "Regular Season" => {:total_games => 0, :total_goals_scored => 0,
                              :total_goals_against => 0, :wins => 0},
          "Postseason" => {:total_games => 0, :total_goals_scored => 0,
                          :total_goals_against => 0,:wins => 0}}
      end
      acc
    end
  end

  def self.seasonal_accumulation_of_data(team_id, data)
    @@games.each do |game|
      if game.away_team_id.to_s == team_id
        data[game.season][game.type][:total_games] += 1
        data[game.season][game.type][:total_goals_scored] += game.away_goals
        data[game.season][game.type][:total_goals_against] += game.home_goals
        data[game.season][game.type][:wins] += 1 if game.away_goals > game.home_goals
      elsif game.home_team_id.to_s == team_id
        data[game.season][game.type][:total_games] += 1
        data[game.season][game.type][:total_goals_scored] += game.home_goals
        data[game.season][game.type][:total_goals_against] += game.away_goals
        data[game.season][game.type][:wins] += 1 if game.away_goals < game.home_goals
      end
    end
  end

  def self.seasonal_summary_assignment(data)
    data.reduce({}) do |acc, season|
      if acc[season[0]] == nil
        acc[season[0]] = {
          :regular_season =>
          {:win_percentage => 0.0, :total_goals_scored => 0, :total_goals_against => 0,  :average_goals_scored => 0.0, :average_goals_against => 0.0},
          :postseason =>
          {:win_percentage => 0.0, :total_goals_scored => 0, :total_goals_against => 0, :average_goals_scored => 0.0, :average_goals_against => 0.0}}
      end
      acc
    end
  end

  def self.seasonal_summary_value_assignment(summary, data)
    summary.each do |key, value|
      summary[key][:regular_season][:win_percentage] = (data[key]["Regular Season"][:wins].to_f / data[key]["Regular Season"][:total_games]).round(2) unless data[key]["Regular Season"][:total_games] == 0
      summary[key][:postseason][:win_percentage] = (data[key]["Postseason"][:wins].to_f / data[key]["Postseason"][:total_games]).round(2) unless data[key]["Postseason"][:total_games] == 0
      summary[key][:regular_season][:total_goals_scored] = data[key]["Regular Season"][:total_goals_scored]
      summary[key][:postseason][:total_goals_scored] = data[key]["Postseason"][:total_goals_scored]
      summary[key][:regular_season][:total_goals_against] = data[key]["Regular Season"][:total_goals_against]
      summary[key][:postseason][:total_goals_against] = data[key]["Postseason"][:total_goals_against]
      summary[key][:regular_season][:average_goals_scored] = (data[key]["Regular Season"][:total_goals_scored] / data[key]["Regular Season"][:total_games].to_f).round(2) unless data[key]["Regular Season"][:total_goals_scored] == 0
      summary[key][:postseason][:average_goals_scored] = (data[key]["Postseason"][:total_goals_scored] / data[key]["Postseason"][:total_games].to_f).round(2) unless data[key]["Postseason"][:total_games] == 0
      summary[key][:regular_season][:average_goals_against] = (data[key]["Regular Season"][:total_goals_against] / data[key]["Regular Season"][:total_games].to_f).round(2) unless data[key]["Regular Season"][:total_goals_against] == 0
      summary[key][:postseason][:average_goals_against] = (data[key]["Postseason"][:total_goals_against] / data[key]["Postseason"][:total_games].to_f).round(2) unless data[key]["Postseason"][:total_goals_against] == 0
    end
  end

  def self.seasonal_summary(team_id)
    data = seasonal_summary_data(team_id)
    seasonal_accumulation_of_data(team_id, data)
    summary = seasonal_summary_assignment(data)
    seasonal_summary_value_assignment(summary, data)
    summary
  end
end
