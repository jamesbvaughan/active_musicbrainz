lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_musicbrainz/version'

Gem::Specification.new do |spec|
  spec.name          = 'active_musicbrainz'
  spec.version       = ActiveMusicbrainz::VERSION
  spec.authors       = ['Andrea Franz', 'Florian Dejonckheere', 'James Vaughan']
  spec.email         = [
    'andrea@gravityblast.com',
    'florian@floriandejonckheere.be',
    'james@jamesbvaughan.com',
  ]
  spec.description   = 'ActiveRecord models for the MusicBrainz database.'
  spec.summary       = 'ActiveRecord models the MusicBrainz database'
  spec.homepage      = 'https://github.com/pilu/active_musicbrainz'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'

  spec.add_dependency 'activerecord'
end
