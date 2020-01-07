require_relative 'test_helper'
require_relative '../lib/game_team'

class GameTeamTest < Minitest::Test

  def setup
    @game_team = GameTeam.from_csv('./data/dummy_game_team.csv')
  end

  def test_it_exists
    assert_instance_of GameTeam, @game_team.first
  end

  def test_it_has_attributes
    assert_equal 2012020087, @game_team.first.game_id
    assert_equal 24, @game_team.first.team_id
    assert_equal "away", @game_team.first.hoa
    assert_equal "TIE", @game_team.first.result
    assert_equal "Bruce Boudreau", @game_team.first.head_coach
    assert_equal 2, @game_team.first.goals
    assert_equal 7, @game_team.first.shots
    assert_equal 22, @game_team.first.tackles
  end

  def test_percentage_vistor_team_wins
    assert_equal 0.34, GameTeam.percentage_visitor_wins
  end

  def test_percentage_home_wins_calculation
    assert_equal 0.56, GameTeam.percentage_home_wins
  end

  def test_most_goals_scored
    assert_equal 4, GameTeam.most_goals_scored("6")
  end

  def test_fewest_goals_scored
    assert_equal 0, GameTeam.fewest_goals_scored("2")
  end

  def test_it_can_find_average_win_percentage
    assert_equal 0.73, GameTeam.average_win_percentage("16")
  end

end
