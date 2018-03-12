bundle exec rake assets:precompile
exec ./restart_daemons.sh
sudo service nginx restart



