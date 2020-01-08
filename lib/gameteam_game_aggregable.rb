require_relative 'calculable'

module GameteamGameAggregable
  extend Calculable

  def self.winningest_coach(season_id, game_teams, games)
    needed_game_ids = []
    games.find_all do |game|
      if game.season == season_id
        needed_game_ids << game.game_id
      end
    end
    stats_repo = game_teams.reduce({}) do |acc, game_team|
      if needed_game_ids.include?(game_team.game_id)
        acc[game_team.head_coach] = {:total_wins => 0, :total_games => 0 }
      end
      acc
    end
    game_teams.each do |game_team|
      if needed_game_ids.include?(game_team.game_id) && game_team.result == "WIN"
        stats_repo[game_team.head_coach][:total_wins] += 1
      elsif needed_game_ids.include?(game_team.game_id)
        stats_repo[game_team.head_coach][:total_games] += 1
      end
    end
    (stats_repo.max_by { |k,v|v[:total_wins] / v[:total_games].to_f })[0]
  end

  def self.worst_coach(season_id, game_teams, games)
    needed_game_ids = []
    games.find_all do |game|
      if game.season == season_id
        needed_game_ids << game.game_id
      end
    end
    stats_repo = game_teams.reduce({}) do |acc, game_team|
      if needed_game_ids.include?(game_team.game_id)
        acc[game_team.head_coach] = {:total_wins => 0, :total_games => 0 }
      end
      acc
    end
    game_teams.each do |game_team|
      if needed_game_ids.include?(game_team.game_id) && game_team.result == "WIN"
        stats_repo[game_team.head_coach][:total_wins] += 1
      elsif needed_game_ids.include?(game_team.game_id)
        stats_repo[game_team.head_coach][:total_games] += 1
      end
    end
    stats_repo.min_by do |k,v|
      v[:total_wins] / v[:total_games].to_f
    end[0]
  end

  def self.worst_loss(team_id, game_teams, games)
    needed_game_ids = []
    game_teams.find_all do |game_team|
      if game_team.team_id.to_s == team_id && game_team.result == "LOSS"
        needed_game_ids << game_team.game_id
      end
    end
    all_abs_vals = []
    games.each do |game|
      if needed_game_ids.include?(game.game_id)
        all_abs_vals << (game.home_goals - game.away_goals).abs
      end
    end
    all_abs_vals.max
  end

  def self.biggest_team_blowout(team_id, game_teams, games)
    needed_game_ids = []
    game_teams.find_all do |game_team|
      if game_team.team_id.to_s == team_id && game_team.result == "WIN"
          needed_game_ids << game_team.game_id
      end
    end
    all_abs_vals = []
    games.each do |game|
      if needed_game_ids.include?(game.game_id)
        all_abs_vals << (game.home_goals - game.away_goals).abs
      end
    end
    all_abs_vals.max
  end

  def self.best_season(team_id, game_teams, games)
    all_seasons = games.reduce({}) do |acc, game|
      if acc[game.season] == nil
        acc[game.season] = {game_ids: [], wins: 0, games: 0}
      end
      acc[game.season][:game_ids] << game.game_id
      acc
    end
    game_teams.each do |game_team|
      season = all_seasons.find do |key, value|
        value[:game_ids].include?(game_team.game_id)
      end
      season[1][:games] += 1 if game_team.team_id.to_s == team_id
      season[1][:wins] += 1 if game_team.result == "WIN" && game_team.team_id.to_s == team_id
    end
    all_seasons = all_seasons.reject { |key, value| value[:games] == 0 }
    (all_seasons.max_by { |key, value| value[:wins].to_f / value[:games] })[0]
  end

  def self.worst_season(team_id, game_teams, games)
    all_seasons = games.reduce({}) do |acc, game|
      if acc[game.season] == nil
        acc[game.season] = {game_ids: [], wins: 0, games: 0}
      end
      acc[game.season][:game_ids] << game.game_id
      acc
    end
    game_teams.each do |game_team|
      season = all_seasons.find do |key, value|
        value[:game_ids].include?(game_team.game_id)
      end
      season[1][:games] += 1 if game_team.team_id.to_s == team_id
      season[1][:wins] += 1 if game_team.result == "WIN" && game_team.team_id.to_s == team_id
    end
    all_seasons = all_seasons.reject { |key, value| value[:games] == 0 }
    (all_seasons.min_by { |key, value| value[:wins].to_f / value[:games] })[0]
  end
end
