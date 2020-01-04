require 'csv'
require_relative 'csv_loadable'

class Team
  extend CsvLoadable
  attr_reader :team_id,
              :franchiseid,
              :teamname,
              :abbreviation,
              :stadium,
              :link

  @@teams = []

  def self.from_csv(file_path)
    create_instances(file_path, Team)
    @@teams = @objects
  end

  def initialize(team_info)
    @team_id = team_info[:team_id].to_i
    @franchiseid = team_info[:franchiseid].to_i
    @teamname = team_info[:teamname]
    @abbreviation = team_info[:abbreviation]
    @stadium = team_info[:stadium]
    @link = team_info[:link]
  end

  def self.count_of_teams
    @@teams.length
  end

  def self.team_info(team_id)
    final_team = @@teams.find do |team|
      team.team_id == team_id
    end
    { team_id: final_team.team_id,
      franchise_id: final_team.franchiseid,
      team_name: final_team.teamname,
      abbreviation: final_team.abbreviation,
      link: final_team.link }
  end
end
