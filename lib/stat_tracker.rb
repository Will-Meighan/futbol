require_relative 'game_team'
require_relative 'game'
require_relative 'team'
require_relative 'calculable'
require_relative 'gameteam_team_aggregable'
require_relative 'game_team_aggregable'
require_relative 'gameteam_game_aggregable'
require_relative 'gameteam_game_team_aggregable'

class StatTracker
  include Calculable
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
    Game.average_goals_per_game.round(2)
  end

  def percentage_home_wins
    GameTeam.percentage_home_wins.round(2)
  end

  def percentage_visitor_wins
    GameTeam.percentage_visitor_wins.round(2)
  end

  def percentage_ties
    Game.percentage_ties.round(2)
  end

  def count_of_games_by_season
    Game.count_of_games_by_season
  end

  def average_goals_by_season
    Game.average_goals_by_season
  end

  def count_of_teams
    Team.count_of_teams
  end

  def most_goals_scored(team_id)
    GameTeam.most_goals_scored(team_id)
  end

  def fewest_goals_scored(team_id)
    GameTeam.fewest_goals_scored(team_id)
  end

  def average_win_percentage(id)
    GameTeam.average_win_percentage(id)
  end

  def team_info(id)
    Team.team_info(id)
  end

  def worst_fans
    GameteamTeamAggregable.worst_fans(@game_teams, @teams)
  end

  def best_fans
    GameteamTeamAggregable.best_fans(@game_teams, @teams)
  end

  def best_offense
    GameteamTeamAggregable.best_offense(@game_teams, @teams)
  end

  def worst_offense
    GameteamTeamAggregable.worst_offense(@game_teams, @teams)
  end

  def highest_scoring_home_team
    GameteamTeamAggregable.highest_scoring_home_team(@game_teams, @teams)
  end

  def lowest_scoring_home_team
    GameteamTeamAggregable.lowest_scoring_home_team(@game_teams, @teams)
  end

  def winningest_team
    GameteamTeamAggregable.winningest_team(@game_teams, @teams)
  end

  def highest_scoring_visitor
    GameteamTeamAggregable.highest_scoring_visitor(@game_teams, @teams)
  end

  def lowest_scoring_visitor
    GameteamTeamAggregable.lowest_scoring_visitor(@game_teams, @teams)
  end

  def worst_defense
    GameTeamAggregable.worst_defense(@games, @teams)
  end

  def best_defense
    GameTeamAggregable.best_defense(@games, @teams)
  end

  def winningest_coach(season_id)
    GameteamGameAggregable.winningest_coach(season_id, @game_teams, @games)
  end

  def accurate_team_calculation(season_id)
    GameteamGameTeamAggregable.accurate_team_calculation(season_id, @game_teams, @games, @teams)
  end

  def least_accurate_team(season_id)
    GameteamGameTeamAggregable.least_accurate_team(season_id, @game_teams, @games, @teams)
  end

  def most_accurate_team(season_id)
    GameteamGameTeamAggregable.most_accurate_team(season_id, @game_teams, @games, @teams)
  end

  def worst_coach(season_id)
    GameteamGameAggregable.worst_coach(season_id, @game_teams, @games)
  end

  def most_tackles(season_id)
    GameteamGameTeamAggregable.most_tackles(season_id, @game_teams, @games, @teams)
  end

  def fewest_tackles(season_id)
    GameteamGameTeamAggregable.fewest_tackles(season_id, @game_teams, @games, @teams)
  end

  def game_teams_postseason(season_type)
    GameteamGameAggregable.game_teams_postseason(season_type, @game_teams, @games)
  end

  def game_teams_regular_season(season_type)
    GameteamGameAggregable.game_teams_regular_season(season_type, @game_teams, @games)
  end
  # def game_teams_regular_season(season_type)
  #   regular_season = @games.find_all { |game| game.type == "Regular Season" && game.season == season_type}
  #   regular_season_ids = regular_season.map { |game| game.game_id }
  #   @game_teams.find_all { |game_team| regular_season_ids.include?(game_team.game_id) }
  # end

  def biggest_bust(season_type)
    postseason_games_per_team = game_teams_postseason(season_type).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] +=1
      acc
    end
    postseason_team_wins = game_teams_postseason(season_type).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] += 1 if game_team.result == "WIN"
      acc
    end
    postseason_win_percentage = postseason_games_per_team.merge(postseason_team_wins) do |game_team, games, wins|
      (wins.to_f/games)
    end
    regular_season_games_per_team = game_teams_regular_season(season_type).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] +=1
      acc
    end
    regular_season_team_wins = game_teams_regular_season(season_type).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] += 1 if game_team.result == "WIN"
      acc
    end
    regular_season_win_percentage = regular_season_games_per_team.merge(regular_season_team_wins) do |game_team, games, wins|
      (wins.to_f/games)
    end
    difference = regular_season_win_percentage.merge(postseason_win_percentage) do |game_team, regular_percentage, post_percentage|
      post_percentage - regular_percentage
    end
    postseason_teams_only = difference.find_all do |team|
      postseason_team_wins.keys.include?(team.first)
    end
    team_with_biggest_bust = difference.max_by { |team| team.last }
    (@teams.find {|team| team.team_id == team_with_biggest_bust.first}).teamname
  end

  def biggest_surprise(season_type)
    postseason_games_per_team = game_teams_postseason(season_type).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] +=1
      acc
    end
    postseason_team_wins = game_teams_postseason(season_type).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] += 1 if game_team.result == "WIN"
      acc
    end
    postseason_win_percentage = postseason_games_per_team.merge(postseason_team_wins) do |game_team, games, wins|
      (wins.to_f/games)
    end
    regular_season_games_per_team = game_teams_regular_season(season_type).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] +=1
      acc
    end
    regular_season_team_wins = game_teams_regular_season(season_type).reduce(Hash.new(0)) do |acc, game_team|
      acc[game_team.team_id] += 1 if game_team.result == "WIN"
      acc
    end
    regular_season_win_percentage = regular_season_games_per_team.merge(regular_season_team_wins) do |game_team, games, wins|
      (wins.to_f/games)
    end
    difference = regular_season_win_percentage.merge(postseason_win_percentage) do |game_team, regular_percentage, post_percentage|
      post_percentage - regular_percentage
    end
    postseason_teams_only = difference.find_all do |team|
      postseason_team_wins.keys.include?(team.first)
    end
    team_biggest_surprise = postseason_teams_only.max_by {|team| team.last}
    (@teams.find {|team| team.team_id == team_biggest_surprise.first}).teamname
  end

  def worst_loss(team_id)
    needed_game_ids = []
    @game_teams.find_all do |game_team|
      if game_team.team_id.to_s == team_id && game_team.result == "LOSS"
        needed_game_ids << game_team.game_id
      end
    end
    all_abs_vals = []
    @games.each do |game|
      if needed_game_ids.include?(game.game_id)
        all_abs_vals << (game.home_goals - game.away_goals).abs
      end
    end
    all_abs_vals.max
  end

  def biggest_team_blowout(team_id)
    needed_game_ids = []
    @game_teams.find_all do |game_team|
      if game_team.team_id.to_s == team_id && game_team.result == "WIN"
          needed_game_ids << game_team.game_id
      end
    end
    all_abs_vals = []
    @games.each do |game|
      if needed_game_ids.include?(game.game_id)
        all_abs_vals << (game.home_goals - game.away_goals).abs
      end
    end
    all_abs_vals.max
  end

  def best_season(team_id)
    all_seasons = @games.reduce({}) do |acc, game|
      if acc[game.season] == nil
        acc[game.season] = {game_ids: [], wins: 0, games: 0}
      end
      acc[game.season][:game_ids] << game.game_id
      acc
    end
    @game_teams.each do |game_team|
      season = all_seasons.find do |key, value|
        value[:game_ids].include?(game_team.game_id)
      end
      season[1][:games] += 1 if game_team.team_id.to_s == team_id
      season[1][:wins] += 1 if game_team.result == "WIN" && game_team.team_id.to_s == team_id
    end
    all_seasons = all_seasons.reject { |key, value| value[:games] == 0 }
    (all_seasons.max_by { |key, value| value[:wins].to_f / value[:games] })[0]
  end

  def worst_season(team_id)
    all_seasons = @games.reduce({}) do |acc, game|
      if acc[game.season] == nil
        acc[game.season] = {game_ids: [], wins: 0, games: 0}
      end
      acc[game.season][:game_ids] << game.game_id
      acc
    end
    @game_teams.each do |game_team|
      season = all_seasons.find do |key, value|
        value[:game_ids].include?(game_team.game_id)
      end
      season[1][:games] += 1 if game_team.team_id.to_s == team_id
      season[1][:wins] += 1 if game_team.result == "WIN" && game_team.team_id.to_s == team_id
    end
    all_seasons = all_seasons.reject { |key, value| value[:games] == 0 }
    (all_seasons.min_by { |key, value| value[:wins].to_f / value[:games] })[0]
  end

  def head_to_head(id)
    opponent_hash = Hash.new
    relavent_games = @games.find_all do |game|
      game.away_team_id == id.to_i || game.home_team_id == id.to_i
    end
    relavent_games.each do |game|
      opponent_id = game.home_team_id if game.home_team_id != id.to_i
      opponent_id = game.away_team_id if game.home_team_id == id.to_i
      opponent_hash[opponent_id] ||= opponent_hash[opponent_id] = {"Wins" => [], "Losses" => []}
      if game.home_team_id == id.to_i
        opponent_hash[opponent_id]["Wins"] << game if game.home_goals > game.away_goals
        opponent_hash[opponent_id]["Losses"] << game if game.home_goals < game.away_goals || game.home_goals == game.away_goals
      elsif game.away_team_id == id.to_i
        opponent_hash[opponent_id]["Wins"] << game if game.away_goals > game.home_goals
        opponent_hash[opponent_id]["Losses"] << game if game.away_goals < game.home_goals || game.away_goals == game.home_goals
      end
    end
    win_perc_hash = Hash.new
    opponent_hash.each do |opponent_id, win_loss_hash|
      @teams.find do |team|
        if team.team_id == opponent_id
          win_perc_hash[team.teamname] = (win_loss_hash["Wins"].length / win_loss_hash.values.flatten.length.to_f).round(2)
        end
      end
    end
    win_perc_hash
  end

  def rival(id)
    (head_to_head(id).min_by { |team| team.last }).first
  end

  def favorite_opponent(id)
    (head_to_head(id).max_by { |team| team.last }).first
  end

  def seasonal_summary(team_id)
    data = @games.reduce({}) do |acc, game|
      if game.away_team_id.to_s == team_id || game.home_team_id.to_s == team_id
        acc[game.season] = {
          "Regular Season" => {:total_games => 0,
                              :total_goals_scored => 0,
                              :total_goals_against => 0,
                              :wins => 0},
          "Postseason" => {:total_games => 0,
                          :total_goals_scored => 0,
                          :total_goals_against => 0,
                          :wins => 0}
        }
      end
      acc
    end
    @games.each do |game|
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
    summary = data.reduce({}) do |acc, season|
      if acc[season[0]] == nil
        acc[season[0]] = {
          :regular_season =>
          {:win_percentage => 0.0, :total_goals_scored => 0, :total_goals_against => 0,  :average_goals_scored => 0.0, :average_goals_against => 0.0},
          :postseason =>
          {:win_percentage => 0.0, :total_goals_scored => 0, :total_goals_against => 0, :average_goals_scored => 0.0, :average_goals_against => 0.0}}
      end
      acc
    end
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
    summary
  end
end
