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
git status # .env should not be there, we don't want to push it to Github.
git add .
git commit -m "Add dotenv - Protect my secret data in .env file"

Cloudinary & Environment
# Gemfile
gem 'cloudinary', '~> 1.12.0'
bundle install
# .env
# variable d'environnement, hash en clé: valeur
CLOUDINARY_URL=cloudinary://298522699261255:Qa1ZfO4syfbOC-***********************8

>ENV["CLOUDINARY_KEY"]
# to vizualize our key !!! ASK teacher if cannot see

Let’s upload two pictures
curl https://c1.staticflickr.com/3/2889/33773377295_3614b9db80_b.jpg > san_francisco.jpg
curl https://pbs.twimg.com/media/DC1Xyz3XoAAv7zB.jpg > boris_retreat_2017.jpg
# rails c !!!
Cloudinary::Uploader.upload("san_francisco.jpg")
Cloudinary::Uploader.upload("boris_retreat_2017.jpg")

rm san_francisco.jpg boris_retreat_2017.jpg
And then go to cloudinary.com/console/media_library

Let’s display them (EVEN if not present localy !!)
<!-- app/views/articles/index.html.erb -->
<%= cl_image_tag("THE_IMAGE_ID_FROM_LIBRARY",
      width: 400, height: 300, crop: :fill) %>

<!-- for face detection -->
<%= cl_image_tag("IMAGE_WITH_FACE_ID",
      width: 150, height: 150, crop: :thumb, gravity: :face) %>


Active Storage
It was a gem, but is now included in rails (versions 5.2 and above).
It allows you to upload files to cloud storage
(like cloudinary) and attach those files to Models!

rails active_storage:install
rails db:migrate
# add two tables
# many to many entre notre model et cloudinary
# activate storage blobs stock nos clés
This creates two tables in the database to handle the
associations between our pictures uploaded on Cloudinary
and any Model in our app.

Config
# config/storage.yml
cloudinary:
  service: Cloudinary
Replace :local by :cloudinary in the config:

# config/environments/development.rb
config.active_storage.service = :cloudinary

Model
class Article < ApplicationRecord
  has_one_attached :photo
end
And that is all you need! 🤓

View & Controller
<!-- app/views/articles/_form.html.erb -->
<%= simple_form_for(article) do |f| %>
  <!-- [...] -->
  <%= f.input :photo, as: :file %>
  <!-- [...] -->
<% end %>

# app/controllers/articles_controller.rb
def article_params
  params.require(:article).permit(:title, :body, :photo)
end
