module OrganisationLoader
  DATA_FILE = Rails.root.join('data', 'github_orgs.yml')
  Organisation = Struct.new(:group, :github_name)

  def self.load(organisations_by_group: YAML.load_file(DATA_FILE))
    organisations = []

    organisations_by_group.each do |group, github_names|
      github_names.each do |github_name|
        organisations << Organisation.new(group, github_name)
      end
    end

    organisations
  end
end
