require "#{Rails.root}/lib/utils"
include Utils
task :populate_schools => :environment do
  NUMBER_OF_RECORDS = ENV.fetch('NUMBER_OF_RECORDS')
  school_params = {
    theme_id: "",
    root_id: "",
    parent_id: "",
    denomination: "IPM",
    identification_number: "",
    sub_denomination: "PAUL MOMO INSTITUTION",
    slogan: "Be the actor of your destiny",
    history: "we are with us since the year of 2000",
    admission_generality: "Welcome",
    sub_description: "Message related to sub description",
    terms_condition: "Terms and condition",
    privacy_policy: "Privacz policy",
    protocol: "The Protocol goes here",
    cookies_policy: "cookies policy",
    social: "social offer describes here",
    contacts_info: {
      email: "institutpaulmomo@gmail.com",
      address: "Total Ebom, à 400 Mètre du Rond Point Damas en direction de la barrière, juste avant la, Yaoundé, Camerun",
      telephone_1: "telephone_1",
      telephone_2: "telephone_2",
      mobile_phone: "+49 015206450219",
      whatApp_number: "00393271882673",
      secondary_email: "helpdesk@institutpaulmomo2.com",
      registration_number: "4444 33333 32323 233"
    },
    social_media: {
      twitter: "twitter",
      youtube: "youtube",
      appStore: "https://www.apple.com/it/store",
      facebook: "https://www.facebook.com/GroupeIPM/",
      instagram: "instagram",
      linkedIn: "https://www.linkedin.com/in/ipm-institut-paul-momo-9a55791aa/",
      playStore: "https://play.google.com/store/books/details/New_School_New_School_Un_anno_alla_Mc_Gaffin?id=VfuRDwAAQBAJ&gl=IT",
      windowsStore: "https://www.microsoft.com/it-it/store/apps/windows"
    }
  }
  user = ENV[:ADMIN_USER.to_s] ? User.find(ENV.fetch('ADMIN_USER')) : User.by_admin.first # this user shoud be and admin user in the db
  root_school = School.find_by_identification_number(School::SUPER_IDENTIFICATION_NUMBER)
  
  if root_school.nil?
    root_school = School.new({identification_number: School::SUPER_IDENTIFICATION_NUMBER, denomination: "SDS", sub_denomination: "SYSTEM Afrik Information & Technology"})
    root_school.save!(:validate => false)
  end

  school_params[:root_id] = root_school[:id]
  school_params[:parent_id] = root_school[:id]
  school_params[:theme_id] = Theme.first.id
  (1..NUMBER_OF_RECORDS.to_i).each {|i|
    school_params[:identification_number] = rand.to_s[2..12]
    school_params[:denomination] = "School-#{rand.to_s[0..4]}#{i.to_s}"
    school = School.new(school_params)
    school.save!
    update_monitor(school, "create", { user: user, monitor_attributes: { status: 4 } })
  } 
end