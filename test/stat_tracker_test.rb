require_relative 'test_helper'
require_relative '../lib/stat_tracker'

class StatTrackerTest < Minitest::Test
  def setup
    @stat_tracker = StatTracker.from_csv({games: './data/dummy_game.csv', teams: './data/dummy_team.csv', game_teams: './data/dummy_game_team.csv'})
  end

  def test_it_exists
    assert_instance_of StatTracker, @stat_tracker
  end

  def test_it_has_attributes
    assert_equal './data/dummy_game.csv', @stat_tracker.game_path
    assert_equal './data/dummy_team.csv', @stat_tracker.team_path
    assert_equal './data/dummy_game_team.csv', @stat_tracker.game_teams_path
  end

  def test_it_creates_an_array_of_all_objects
    assert_instance_of Array, @stat_tracker.game_teams
    assert_instance_of GameTeam, @stat_tracker.game_teams[0]
    assert_instance_of Array, @stat_tracker.games
    assert_instance_of Game, @stat_tracker.games[0]
    assert_instance_of Array, @stat_tracker.teams
    assert_instance_of Team, @stat_tracker.teams[0]
  end

  def test_it_can_find_highest_total_score
    assert_equal 501, @stat_tracker.highest_total_score
  end

  def test_it_can_find_lowest_total_score
    assert_equal 0, @stat_tracker.lowest_total_score
  end

  def test_it_can_find_average_goals_per_game
    assert_equal 16.28, @stat_tracker.average_goals_per_game
  end

  def test_it_can_find_percentage_home_wins
    assert_equal 0.56, @stat_tracker.percentage_home_wins
  end

  def test_it_can_find_percentage_ties
    assert_equal 0.13, @stat_tracker.percentage_ties
  end

  def test_it_can_count_the_number_of_games_in_a_season
    assert_equal ({"20122013"=>27, "20142015"=>6, "20162017"=>4, "20152016"=>2, "20132014"=>1}), @stat_tracker.count_of_games_by_season
  end

  def test_it_can_find_average_goals_by_season
    assert_equal ({"20122013"=>27, "20142015"=>6, "20162017"=>4, "20152016"=>2, "20132014"=>1}), @stat_tracker.count_of_games_by_season
  end

  def test_it_can_find_count_of_teams
    assert_equal 16, Team.count_of_teams
  end

  def test_it_can_pull_all_teams_with_the_worst_fans
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})
    assert_equal ["Houston Dynamo", "Utah Royals FC"], stat_tracker.worst_fans
    assert_equal ["Los Angeles FC", "LA Galaxy", "Atlanta United", "DC United"], @stat_tracker.worst_fans
  end

  def test_it_can_pull_teams_with_the_best_fans
    stat_tracker = StatTracker.from_csv({games: './data/dummy_game.csv', teams: './data/dummy_team.csv', game_teams: './data/dummy_game_team.csv'})

    assert_equal "Orlando City SC", stat_tracker.best_fans
  end

  def test_team_with_best_offense
    assert_equal "Real Salt Lake", @stat_tracker.best_offense
  end

  def test_team_with_worst_offense
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})

    assert_equal "Utah Royals FC", stat_tracker.worst_offense
  end

  def test_highest_scoring_home_team
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})

    assert_equal "Reign FC", stat_tracker.highest_scoring_home_team
  end

  def test_lowest_scoring_home_team
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})

    assert_equal "Utah Royals FC", stat_tracker.lowest_scoring_home_team
  end

  def test_lowest_scoring_visitor
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})

    assert_equal "San Jose Earthquakes", stat_tracker.lowest_scoring_visitor
  end

  def test_winningest_team
    assert_equal "Toronto FC", @stat_tracker.winningest_team
  end

  def test_highest_scoring_visitor
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})

    assert_equal "FC Dallas", stat_tracker.highest_scoring_visitor
  end

  def test_worst_defense
    assert_equal "Sporting Kansas City", @stat_tracker.worst_defense
  end

  def test_best_defense
    assert_equal "FC Dallas", @stat_tracker.best_defense
  end

  def test_least_accurate_team
    assert_equal "Seattle Sounders FC", @stat_tracker.least_accurate_team("20122013")
  end

  def test_most_accurate_team
    assert_equal "Los Angeles FC", @stat_tracker.most_accurate_team("20122013")
  end

  def test_most_tackles
    assert_equal "FC Dallas", @stat_tracker.most_tackles("20122013")
  end

  def test_fewest_tackles
    assert_equal "DC United", @stat_tracker.fewest_tackles("20122013")
  end

  def test_most_goals_scored
    assert_equal 4, @stat_tracker.most_goals_scored("6")
  end

  def test_fewest_goals_scored
    assert_equal 0, @stat_tracker.fewest_goals_scored("2")
  end

  def test_winningest_coach
    assert_equal "Peter Laviolette", @stat_tracker.winningest_coach("20122013")
  end

  def test_worst_coach
    assert_equal "Todd McLellan", @stat_tracker.worst_coach("20122013")
  end

  def test_biggest_bust
    assert_equal "Houston Dynamo", @stat_tracker.biggest_bust("20132014")
  end

  def test_biggest_surprise
    assert_equal "New England Revolution", @stat_tracker.biggest_surprise("20142015")
  end

  def test_average_win_percentage
    assert_equal 0.73, @stat_tracker.average_win_percentage("16")
  end


  def test_worst_loss
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})

    assert_equal 5, stat_tracker.worst_loss("6")
  end

  def test_biggest_team_blowout
    stat_tracker = StatTracker.from_csv({games: './data/game.csv', teams: './data/team.csv', game_teams: './data/game_team.csv'})

    assert_equal 6, stat_tracker.biggest_team_blowout("24")
  end

  def test_best_season
    assert_equal "20142015", @stat_tracker.best_season("16")
  end

  def test_worst_season
    assert_equal "20122013", @stat_tracker.worst_season("16")
  end

  def test_head_to_head
    expected = {"LA Galaxy"=>0.5, "DC United"=>0.8, "Orlando City SC"=>0.67}
    assert_equal expected, @stat_tracker.head_to_head("16")
  end

  def test_rival
    assert_equal "LA Galaxy", @stat_tracker.rival("16")
  end

  def test_favorite_opponent
    assert_equal "DC United", @stat_tracker.favorite_opponent("16")
  end

  def test_seasonal_summary
    expected = {"20122013"=>{:regular_season=>{:win_percentage=>0.0, :total_goals_scored=>2,
                :total_goals_against=>2, :average_goals_scored=>2.0, :average_goals_against=>2.0},
                :postseason=>{:win_percentage=>0.75, :total_goals_scored=>8, :total_goals_against=>6,
                :average_goals_scored=>2.0, :average_goals_against=>1.5}},
                "20142015"=>{:regular_season=>{:win_percentage=>0.0, :total_goals_scored=>0,
                :total_goals_against=>0, :average_goals_scored=>0.0, :average_goals_against=>0.0},
                :postseason=>{:win_percentage=>0.8, :total_goals_scored=>11, :total_goals_against=>8,
                :average_goals_scored=>2.2, :average_goals_against=>1.6}}}
    assert_equal expected, @stat_tracker.seasonal_summary("16")
  end
end
