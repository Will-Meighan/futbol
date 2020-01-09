require_relative 'test_helper'
require_relative '../lib/game'
require_relative '../lib/calculable'

class GameTest < Minitest::Test

  def setup
    @game = Game.from_csv('./data/dummy_game.csv')
  end

  def test_it_exists
    assert_instance_of Game, @game.first
  end

  def test_it_has_attributes
    assert_equal 2012030221, @game.first.game_id
    assert_equal "20122013", @game.first.season
    assert_equal "Postseason", @game.first.type
    assert_equal 3, @game.first.away_team_id
    assert_equal 6, @game.first.home_team_id
    assert_equal 2, @game.first.away_goals
    assert_equal 3, @game.first.home_goals
  end

  def test_it_can_find_highest_total_score
    assert_equal 501, Game.highest_total_score
  end

  def test_it_can_find_lowest_total_score
    assert_equal 0, Game.lowest_total_score
  end

  def test_it_can_count_the_number_of_games_in_a_season
    game1 = mock("game")
    game2 = mock("game")
    game3 = mock("game")
    game1.stubs(:season).returns("20122013")
    game2.stubs(:season).returns("20122013")
    game3.stubs(:season).returns("20142015")

    attributes = [game1, game2, game3]
    assert_equal ({"20122013"=>2, "20142015"=>1}), Game.count_of_games_by_season(attributes)
    assert_instance_of Hash, Game.count_of_games_by_season(attributes)
  end

  def test_it_can_calcualte_the_average_number_of_goals_per_game_accross_all_games
    assert_equal 16.28, Game.average_goals_per_game
  end

  def test_it_can_find_average_goals_by_season
    expected = {"20122013"=>22.04, "20142015"=>4.0, "20162017"=>4.75, "20152016"=>4.0, "20132014"=>5.0}
    assert_equal expected, Game.average_goals_by_season
    assert_instance_of Hash, Game.average_goals_by_season
  end

  def test_biggest_blowout
    assert_equal 499, Game.biggest_blowout
  end

  def test_it_can_calculate_the_percentage_of_games_that_end_in_a_tie
    assert_equal 0.13, Game.percentage_ties
  end

  def test_seasonal_summary_data
    assert_equal ({}), Game.seasonal_summary_data("23")
  end

  def test_seasonal_accumulation_of_data
    assert_equal 2012030221, Game.seasonal_accumulation_of_data("23", Game.seasonal_summary_data("23"))[0].game_id
  end

  def test_seasonal_summary_assignment
    data = mock("data")
    data.stubs(:hash).returns({})
    assert_equal ({}), Game.seasonal_summary_assignment(data.hash)
  end

  def test_seasonal_summary_value_assignment
    summary = mock("summary")
    data = mock("data")
    summary.stubs(:summary).returns({"20122013" => {:regular_season=>{:win_percentage=>0.0, :total_goals_scored=>0, :total_goals_against=>0, :average_goals_scored=>0.0,:average_goals_against=>0.0}, :postseason=>{:win_percentage=>0.0, :total_goals_scored=>0, :total_goals_against=>0, :average_goals_scored=>0.0, :average_goals_against=>0.0}}})
    data.stubs(:data).returns({"20122013" => {"Regular Season"=>{:total_games=>1, :total_goals_scored=>2, :total_goals_against=>2, :wins=>0}, "Postseason"=>{:total_games=>4, :total_goals_scored=>8, :total_goals_against=>6, :wins=>3}}})

    result = {"20122013"=>{:regular_season=>{:win_percentage=>0.0, :total_goals_scored=>2, :total_goals_against=>2, :average_goals_scored=>2.0, :average_goals_against=>2.0}, :postseason=>{:win_percentage=>0.75, :total_goals_scored=>8, :total_goals_against=>6, :average_goals_scored=>2.0, :average_goals_against=>1.5}}}

    assert_equal result, Game.seasonal_summary_value_assignment(summary.summary, data.data)
  end
end
