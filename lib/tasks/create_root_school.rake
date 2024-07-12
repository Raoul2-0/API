task :create_root_school => :environment do
  school_params = {
    theme_id: Theme.first.id,
    root_id: "",
    parent_id: "",
    category_id: 3,
    denomination: "SYSAIT DIGITAL SCHOOL",
    identification_number: School::SUPER_IDENTIFICATION_NUMBER,
    sub_denomination: "DIGITAL SCHOOL",
    slogan: "LET US CREATE A NEW FUTURE, A NEW DIGITAL  AND SMART WORLD.",
    history: "We are an innovator company that develops digital products to improve the quality of our life. We provide high-quality solutions to our customers and we do it by relying on our skills and talents which we improve over time.",
    admission_generality: "Welcome",
    sub_description: "Message related to sub description",
    terms_condition: "Terms and condition",
    privacy_policy: "Privacy policy",
    protocol: "The Protocol goes here",
    cookies_policy: "cookies policy",
    social: "social offer describes here",
    contacts_info: {
      email: "sysaitechnology@gmail.com",
      address: "Via Antonio Fortunato Oroboni, 80, 44122 Ferrara FE",
      telephone_1: "00393271852672",
      telephone_2: "+49 015206657219",
      mobile_phone: "+49 015206657219",
      whatApp_number: "00393271852672",
      secondary_email: "helpdesk@institutpaulmomo2.com",
      registration_number: "00000000000000"
    },
    social_media: {
      youtube: "https://www.youtube.com/channel/UCvUFn_Ciw80DJs3U0Mz1a2A",
      appStore: "https://www.apple.com/it/store",
      facebook: "https://www.facebook.com/sysaitechnology/",
      linkedIn: "https://www.linkedin.com/company/system-afrik-information-technology/",
    }
  }
  

  user = ENV[:ADMIN_USER.to_s] ? User.find(ENV.fetch('ADMIN_USER')) : User.by_admin.first
  root_school = School.find_by_identification_number(school_params[:identification_number])
  if root_school.nil?
    root_school = School.new(school_params)
  else
    root_school.assign_attributes(school_params)
  end

  root_school.save!(validate: false)
  root_school.assign_attributes({root_id: root_school.id, parent_id: root_school.id})
  root_school.save!(validate: false)

  update_monitor(root_school, "create", { user: user, monitor_attributes: { status: 4 } }) if root_school.monitoring.blank?
end