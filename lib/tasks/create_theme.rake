task :create_theme => :environment do
  theme_params = {
    denomination: "Theme denomination",
	  colors: {
	    primary: "#007b80",
			black: "#0004567",
			primary_variant_1: "#003a3c",
			primary_variant_2: "#00aaaf",
			primary_variant_3: "#1ce7ee",
			primary_variant_4: "#344749",
			primary_variant_5: "#1f2b2c",
			secondary: "#7FFF00",
			black_variant_1: "#595959",
			grey_variant_1: "#ebebeb",
			white: "#ffffff"
    }
  }
  @user = ENV[:ADMIN_USER.to_s] ? User.find(ENV.fetch('ADMIN_USER')) : User.by_admin.first
  @theme = Theme.new(theme_params)
  @theme.save!
  update_monitor(@theme, Constant::RESOURCE_METHODS[:create], { user: @user, monitor_attributes: { status: 4 } })
end