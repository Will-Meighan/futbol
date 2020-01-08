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


end
