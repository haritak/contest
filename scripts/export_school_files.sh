#!/usr/bin/env fish

cd ~/contest
set SHELL /usr/bin/fish

tmux new-session -s contest_exports -d
tmux send-keys -t contest_exports 'RAILS_ENV=production ./scripts/export_school_files.rb' C-m


