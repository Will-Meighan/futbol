require 'csv'
require_relative 'csv_loadable'

class Team
  extend CsvLoadable

  attr_reader :team_id,
              :teamname

  @@teams = []

  def self.from_csv(file_path)
    create_instances(file_path, Team)
    @@teams = @objects
  end

  def initialize(team_info)
    @team_id = team_info[:team_id].to_i
    @teamname = team_info[:teamname]
  end

  def self.count_of_teams
    @@teams.length
  end

  def self.team_info(team_id)
    final_team = @@teams.find do |team|
      team.team_id.to_s == team_id
    end
    { "team_id" => final_team.team_id.to_s,
      "team_name" => final_team.teamname
    }
  end
end
