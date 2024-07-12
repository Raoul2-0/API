require "#{Rails.root}/lib/utils"
include Utils
task :populate_news => :environment do
  NUMBER_OF_RECORDS = ENV.fetch('NUMBER_OF_RECORDS')
  news_params = {
    foreground: true,
    sidebar: false, 
    denomination: "",
    sub_denomination: "Visite du ministre de l'enseignement secondaire1",
    date: "12 Gen 20221",
    description: "Lorem Ipsum Dolor Sit Amet Consec Lorem Ipsum Dolor Sit Amet ConsecLorem Ipsum Dolor Sit Amet ConsecLorem 1ssssssssssssssss111111111111"
  }
  user = User.find(ENV.fetch('ADMIN_USER')) # this user shoud be and admin user in the db
  school = School.find(ENV.fetch('SCHOOL_ID')) # school in which to population de news
  (1..NUMBER_OF_RECORDS.to_i).each {|i|
    news_params[:denomination] = "Visite du ministre de l'enseignement secondaire" + "_" + i.to_s
    news = News.new(news_params)
    school.institutions.create(institutionalisable: news)
    save_resource_update_monitor(news, "create", { user: user }) #, new_parameters = nil, nested_denomination=nil
  } 
end