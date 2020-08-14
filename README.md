Home made tuto, v0

I - Initialization
look at: https://kitt.lewagon.com/camps/435/lectures/05-Rails%2F05-Rails-MC-with-images#
git add .
git commit -m "Initial commit"
hub create
git push origin master
verify you have psql
>psql -d postgres

New Rails application
Generate a blog with the --database flag:
>cd ~/code/$YOUR_GITHUB_USERNAME
>rails new blog --database=postgresql
>cd blog


Create the database on PostgreSQL
>rails db:create

Init and push your git repo
>git add .
>git commit -m "Initial commit"
>hub create
>git push origin master
# origin is the name of the branch on github
# master is our local branch


bundle install
rails generate simple_form:install --bootstrap
rm app/assets/stylesheets/application.css
touch app/assets/stylesheets/application.scss
# in config/initializers
# add some front code to get options for our buttons

Scaffold a Post model
Open Gemfile, and comment out the jbuilder gem.

# gem 'jbuilder'
Then generate a scaffold of article.

bundle install
rails generate scaffold article title body:text
rails db:migrate

Heroku
Cela utilise les servers Amazon

Login
heroku login
Create an Heroku app
heroku create $YOUR_APP_NAME --region eu
# Project name uniq worldwide ! so add digits..
# region : where in the world ?! europe if your clients are in europe...

➜  blog git:(master) ✗ heroku create blog-435-5 --region eu
Creating ⬢ blog-435-5... done, region is eu
https://blog-435-5.herokuapp.com/ | https://git.heroku.com/blog-435-5.git

git remote -v
# check our branches

Let’s deploy!
Push your code to Heroku

git push heroku master
Useful commands

heroku open         # open in your browser
heroku logs --tail  # show the app logs and keep listening

Run a command on Heroku

heroku run <command>         # Syntax
heroku run rails db:migrate  # Run pending migrations in prod
heroku run rails c           # Run the production console


Image Upload
User-side upload. Not assets.

Uploading / Storing to Heroku?
You can’t: the dyno file system is ephemeral.
If there is an issue, heroku clear all and change server ?!

We need an external service.
-> Cloudinary
Where do we put our secret keys?
We don’t want to share those secret keys on Github, we can use the dotenv gem for security.

# Gemfile
gem 'dotenv-rails', groups: [:development, :test]
bundle install
touch .env
echo '.env*' >> .gitignore # we tell Git not to push this file !
