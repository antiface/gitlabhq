require 'spec_helper'

describe Projects::ImportExport::MembersMapper, services: true do
  describe :map do

    let(:user) { create(:user) }
    let(:project) { create(:project, :public, name: 'searchable_project') }
    let(:user2) { create(:user) }
    let(:exported_members) { [
      {
        "id" => 2,
        "access_level" => 40,
        "source_id" => 14,
        "source_type" => "Project",
        "user_id" => 19,
        "notification_level" => 3,
        "created_at" => "2016-03-11T10:21:44.822Z",
        "updated_at" => "2016-03-11T10:21:44.822Z",
        "created_by_id" => nil,
        "invite_email" => nil,
        "invite_token" => nil,
        "invite_accepted_at" => nil,
        "user" => { "email" => user2.email, "username" => user2.username } }] }

    let(:members_mapper) do
      Projects::ImportExport::MembersMapper.new(
        exported_members: exported_members, user: user, project_id: project.id)
    end

    it 'maps a project member' do
      expect(project_member_map_id(user2.id)).to eq(user2.id)
    end

    it 'defaults to importer project member if it does not exist' do
      expect(project_member_map_id(-1)).to eq(user.id)
    end
  end

  def project_member_map_id(id)
    members_mapper.map[id]['id']
  end
end
