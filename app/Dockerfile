FROM rails:onbuild
RUN bundle config --global frozen 0
RUN RAILS_ENV=development rake db:create db:migrate
RUN RAILS_ENV=test rake db:create db:migrate
RUN RAILS_ENV=production rake db:create db:migrate
RUN RAILS_ENV=production rake assets:precompile --trace
