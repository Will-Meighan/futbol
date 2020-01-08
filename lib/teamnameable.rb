module Teamnameable
  def id_to_teamname(id, teams)
    teams.find do |team|
      id == team.team_id
    end.teamname
  end
end
