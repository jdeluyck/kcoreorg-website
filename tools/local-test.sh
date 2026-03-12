if [ $# -eq 1 ]; then
  if [ $1 == "full" ]; then
    JEKYLL_ENV=production bundle exec jekyll serve 
  fi
else
  JEKYLL_ENV=production bundle exec jekyll serve --limit=4 
fi
 
