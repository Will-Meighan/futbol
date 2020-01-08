require_relative 'game_team'
require_relative 'game'
require_relative 'team'
require_relative 'calculable'
require_relative 'gameteam_team_aggregable'
require_relative 'game_team_aggregable'
require_relative 'gameteam_game_aggregable'
require_relative 'gameteam_game_team_aggregable'
require_relative 'teamnameable'

class StatTracker
  include Calculable
  include Teamnameable
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
    GameteamGameTeamAggregable.game_teams_postseason(season_type, @game_teams, @games, @teams)
  end

  def game_teams_regular_season(season_type)
    GameteamGameTeamAggregable.game_teams_regular_season(season_type, @game_teams, @games, @teams)
  end

  def biggest_bust(season_type)
    GameteamGameTeamAggregable.biggest_bust(season_type, @game_teams, @games, @teams)
  end

  def biggest_surprise(season_type)
    GameteamGameTeamAggregable.biggest_surprise(season_type, @game_teams, @games, @teams)
  end

  def worst_loss(team_id)
    GameteamGameAggregable.worst_loss(team_id, @game_teams, @games)
  end

  def biggest_team_blowout(team_id)
    GameteamGameAggregable.biggest_team_blowout(team_id, @game_teams, @games)
  end

  def best_season(team_id)
    GameteamGameAggregable.best_season(team_id, @game_teams, @games)
  end

  def worst_season(team_id)
    GameteamGameAggregable.worst_season(team_id, @game_teams, @games)
  end

  def head_to_head(id)
    GameTeamAggregable.head_to_head(id, @games, @teams)
  end

  def rival(id)
    (head_to_head(id).min_by { |team| team.last }).first
  end

  def favorite_opponent(id)
    (head_to_head(id).max_by { |team| team.last }).first
  end

  def seasonal_summary(team_id)
    Game.seasonal_summary(team_id)
  end
end
