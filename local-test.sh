if [ $# -eq 1 ]; then
  if [ $1 == "full" ]; then
    JEKYLL_ENV=production bundle exec jekyll serve 2>&1 | grep -E -v 'deprecated'
  fi
else
  JEKYLL_ENV=production bundle exec jekyll serve --limit=4 2>&1 | grep -E -v 'deprecated'
fi
 
