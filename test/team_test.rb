require_relative 'test_helper'
require_relative '../lib/team'

class TeamTest < Minitest::Test

  def setup
    @team = Team.from_csv('./data/dummy_team.csv')
  end

  def test_it_exists
    assert_instance_of Team, @team.first
  end

  def test_it_has_attributes
    assert_equal 1, @team.first.team_id
    assert_equal 23, @team.first.franchiseid
    assert_equal "Atlanta United", @team.first.teamname
    assert_equal "ATL", @team.first.abbreviation
    assert_equal "/api/v1/teams/1", @team.first.link
  end

  def test_it_can_calculate_total_teams
    assert_equal 16, Team.count_of_teams
  end

  def test_it_pulls_team_info
    expected = {"team_id"=>"14", "team_name"=>"DC United"}
    assert_equal expected, Team.team_info("14")
  end
end
