require_relative 'calculable'

module GameTeamAggregable
  extend Calculable

  def self.defense_accumulator(games)
    teams_counter = games.reduce({}) do |acc, game|
      acc[game.home_team_id] = {games: 0, goals_allowed: 0}
      acc[game.away_team_id] = {games: 0, goals_allowed: 0}
      acc
    end
  end

  def self.worst_defense(games, teams)
    teams_counter = defense_accumulator(games)
    games.each do |game|
      teams_counter[game.home_team_id][:games] += 1
      teams_counter[game.away_team_id][:games] += 1
      teams_counter[game.away_team_id][:goals_allowed] += game.home_goals
      teams_counter[game.home_team_id][:goals_allowed] += game.away_goals
    end
    final = teams_counter.max_by do |id, stats|
      stats[:goals_allowed].to_f / stats[:games]
    end[0]
    (teams.find { |team| team.team_id == final }).teamname
  end

  def self.best_defense(games, teams)
    teams_counter = defense_accumulator(games)
    games.each do |game|
      teams_counter[game.home_team_id][:games] += 1
      teams_counter[game.away_team_id][:games] += 1
      teams_counter[game.away_team_id][:goals_allowed] += game.home_goals
      teams_counter[game.home_team_id][:goals_allowed] += game.away_goals
    end
    final = teams_counter.min_by do |id, stats|
      stats[:goals_allowed].to_f / stats[:games]
    end[0]
    (teams.find { |team| team.team_id == final }).teamname
  end

  def self.relavent_games(id, games, teams)
    games.find_all do |game|
      game.away_team_id == id.to_i || game.home_team_id == id.to_i
    end
  end

  def self.oppo_hash(id, games, teams)
    opponent_hash = Hash.new
    relavent_games(id, games, teams).each do |game|
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
    opponent_hash
  end

  def self.head_to_head(id, games, teams)
    win_perc_hash = Hash.new
    oppo_hash(id, games, teams).each do |opponent_id, win_loss_hash|
      teams.find do |team|
        if team.team_id == opponent_id
          win_perc_hash[team.teamname] = (win_loss_hash["Wins"].length / win_loss_hash.values.flatten.length.to_f).round(2)
        end
      end
    end
    win_perc_hash
  end
end
