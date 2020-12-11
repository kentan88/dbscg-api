pg_restore --verbose --clean --no-acl --no-owner -h localhost -U postgres -d dbscg_api_development latest.dump
http://localhost:3001/api/cards.json?q[title_cont]=Goku
http://localhost:3001/api/cards.json?q[color_matches_any][]=Red&q[color_matches_any][]=Blue