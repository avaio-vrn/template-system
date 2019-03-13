1. production: RAILS_ENV=production RBENV_VERSION=2.3.0 rbenv exec bundle exec rake migrate_to_0_06_40:start

2. dont't forget change content[0].part_content_text[0] -> content[0].part_content_text[:alt]
and other symbols
