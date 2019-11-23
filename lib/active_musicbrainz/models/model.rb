module ActiveMusicbrainz
  module Model
    def self.build_models
      Factory.define do
        Base.connection.tables.each do |table_name|
          model table_name
        end
      end
      true
    end

    ##
    # Please note that the association name cannot match the foreign key name
    # https://github.com/rails/rails/issues/26778#issuecomment-255592061
    #
    Factory.define do
      model :artist do
        has_many    :credit_names, foreign_key: :artist, class_name: 'ArtistCreditName'
        has_many    :credits, through: :credit_names, class_name: 'ArtistCredit'
        has_many    :release_groups, through: :credits
        has_many    :releases, through: :release_groups
        has_many    :recordings, through: :credits
        has_many    :tracks, through: :credits
        has_many    :aliases, foreign_key: :artist, class_name: 'ArtistAlias'
        has_many    :l_artist_urls, foreign_key: :entity0
        has_many    :urls, through: :l_artist_urls
        belongs_to  :gender, foreign_key: :gender, optional: true
        belongs_to  :type, foreign_key: :type, class_name: 'ArtistType', optional: true
        belongs_to  :area, foreign_key: :area, optional: true
        has_gid
      end

      model :l_artist_url do
        belongs_to  :artist, foreign_key: :entity0
        belongs_to  :url, foreign_key: :entity1
      end

      model :artist_credit_name do
        belongs_to  :credit, foreign_key: :artist_credit, class_name: 'ArtistCredit'
        belongs_to  :credit_artist, foreign_key: :artist
      end

      model :artist_credit do
        has_many    :credit_names, foreign_key: :artist_credit, class_name: 'ArtistCreditName'
        has_many    :artists, through: :credit_names
        has_many    :recordings, foreign_key: :artist_credit
        has_many    :tracks, foreign_key: :artist_credit
        has_many    :releases, foreign_key: :artist_credit
        has_many    :release_groups, foreign_key: :artist_credit
      end

      model :artist_alias do
        belongs_to :alias_artist, foreign_key: :artist, class_name: 'Artist'
        belongs_to :alias_type, foreign_key: :type, class_name: 'ArtistAliasType'
      end

      model :artist_alias_type do
        has_many    :aliases, foreign_key: :type, class_name: 'ArtistAlias'
      end

      model :artist_type do
        has_many    :artists, foreign_key: :type
      end

      model :gender do
        has_many    :artists, foreign_key: :gender
      end

      model :area do
        has_many    :artists, foreign_key: :area
        belongs_to  :area_type, foreign_key: :type, class_name: 'AreaType', optional: true
      end

      model :area_type do
        has_many    :areas, foreign_key: :type
      end

      model :url do
        has_many    :l_artist_urls, foreign_key: :entity1
        has_many    :artists, through: :l_artist_urls
      end

      model :track do
        belongs_to  :recording, foreign_key: :recording
        belongs_to  :medium, foreign_key: :medium
        has_one     :release, through: :medium
        has_artist_credits
        has_gid
      end

      model :release_group_secondary_type do
        has_many    :release_group_secondary_type_joins, foreign_key: :secondary_type
        has_many    :release_groups, through: :release_group_secondary_type_joins
      end

      model :release_group_secondary_type_join do
        belongs_to  :release_group_secondary_type_join_release_group, foreign_key: :release_group
        belongs_to  :type, class_name: 'ReleaseGroupSecondaryType', foreign_key: :secondary_type
      end

      model :release_group do
        has_many    :releases, foreign_key: :release_group
        has_many    :recordings, through: :releases
        belongs_to  :meta, class_name: 'ReleaseGroupMeta', foreign_key: :id
        belongs_to  :release_group_type, class_name: 'ReleaseGroupPrimaryType', foreign_key: :type
        has_many    :release_group_secondary_type_joins, foreign_key: :release_group
        has_many    :secondary_types, through: :release_group_secondary_type_joins, source: :type
        has_many    :l_release_group_urls, foreign_key: :entity0
        has_many    :urls, through: :l_release_group_urls
        has_artist_credits
        has_gid
      end

      model :l_release_group_url do
        belongs_to  :release_group, foreign_key: :entity0
        belongs_to  :url, foreign_key: :entity1
      end

      model :release do
        belongs_to  :release_release_group, foreign_key: :release_group
        belongs_to  :meta, class_name: 'ReleaseMeta', foreign_key: :id
        has_many    :mediums, -> { order('medium.position') }, foreign_key: :release
        has_many    :recordings, through: :mediums
        has_many    :tracks, through: :mediums
        belongs_to  :release_status, class_name: 'ReleaseStatus', foreign_key: :status
        belongs_to  :release_packaging, class_name: 'ReleasePackaging', foreign_key: :packaging
        has_many    :release_countries, foreign_key: :release

        has_artist_credits
        has_gid
      end

      model :medium do
        belongs_to  :medium_release, foreign_key: :release
        has_many    :tracks, -> { order('track.position') }, foreign_key: :medium
        has_many    :recordings, through: :tracks
        belongs_to  :medium_format, class_name: 'MediumFormat', foreign_key: :format
      end

      model :recording do
        has_many    :tracks, foreign_key: :recording
        has_many    :release_groups, through: :tracks
        has_many    :releases, through: :mediums
        has_many    :release_groups, through: :releases
        has_many    :mediums, through: :tracks
        has_artist_credits
        has_gid
      end
    end
  end
end
