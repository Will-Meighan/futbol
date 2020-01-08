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

  def self.game_teams_postseason(season_type, game_teams, games)
    postseason = games.find_all { |game| game.type == "Postseason" && game.season == season_type }
    postseason_ids = postseason.map { |game| game.game_id }
    game_teams.find_all { |game_team| postseason_ids.include?(game_team.game_id) }
  end

  def self.game_teams_regular_season(season_type, game_teams, games)
    regular_season = games.find_all { |game| game.type == "Regular Season" && game.season == season_type}
    regular_season_ids = regular_season.map { |game| game.game_id }
    game_teams.find_all { |game_team| regular_season_ids.include?(game_team.game_id) }
  end
end
