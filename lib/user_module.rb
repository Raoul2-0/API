require "#{Rails.root}/lib/utils"
module UserModule
  include Utils
  STUDENT = 'Student'
  STAFF = 'Staff'
  PARENT = 'Parent'
  CATEGORIES = [STUDENT, STAFF, PARENT]

  # Refresh a token
  def token_refresh(user)
    token = user.encode_token
    #bearer_token = token.prepend("Bearer  ")
    if response
      response.headers['Authorization'] = token  # remove bearer token
    end
    return token
  end
  # Manage role: add and remove
  def manage_role(action, user)
    if user.has_role? :admin
      @user_to_assign_role = params.has_key?(:id_user) ? get_user_by_id(params[:id_user]): user
      if @user_to_assign_role
        if @user_to_assign_role.has_role? params[:role]
          case action
          when "add"
            mesg = I18n.t('users.add_role.role_exist')
            flag = Flag::WARMING
          when "remove"
            @user_to_assign_role.remove_role params[:role]
            mesg = I18n.t('users.remove_role.role_removed')
            flag = Flag::SUCCESS
          else
            mesg = "The action #{action} cannot be process."
            flag = Flag::ERROR
          end
        else
          case action
          when "add"
            @user_to_assign_role.add_new_role(params[:role])
            mesg = I18n.t('users.add_role.role_added')
            flag = Flag::SUCCESS
          when "remove"
            mesg = I18n.t('users.remove_role.non_existent_role')
            flag = Flag::WARMING
          else
            mesg = "The action #{action} cannot be process."
            flag = Flag::ERROR
          end
        end
        render json: { :success =>  mesg, flag: flag}
      else
        mesg = action.eql?("add") ? I18n.t('users.add_role.error'): I18n.t('users.remove_role.non_existent_role')
        flag = Flag::ERROR
        render json: { errors:  mesg, flag: flag}, status: :unprocessable_entity
      end
    else
      mesg = action.eql?("add") ? I18n.t('users.add_role.not_admin_user'): I18n.t('users.remove_role.not_admin_user')
      flag = Flag::ERROR
      render json: { errors:  mesg, flag: flag}, status: :unprocessable_entity
    end
  end

  def generate_access_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(confirmation_token: token).first
    end
  end

  def sign_up_params(sign_up_extra = {})
  cod = Random.new_seed.to_s[0, 5]
    first_name = "FirstName#{cod}"
    last_name = "LastName#{cod}"
    email = "#{first_name}.#{last_name}@gmail.com"
    {
      email: email,
      password: "Password1234",
      first_name: first_name,
      last_name: last_name,
      sex: ["male", "female"][[0, 1].sample], 
      identification_number: (0...14).map {[*'0'..'9',*'A'..'Z',*'a'..'z'].sample }.join.upcase,
      avatar_url: "https://lh3.googleusercontent.com/fife/AGXqzDltPtTVWUGNL1iGQPMYz_gb2OUc0ncf3xm96rRWMuLhZ4P7B4MFE9A5ciwzRh1E_vqvNK7gBFleqdhD-m65NbVWKofzYUPgHY3PQsbowzUK2o2zrh4ae-wfTsitQzDEEdfndolzw2wrU7bPIO0eqOKYDv7W0IeD6kbNNidbFPpbxvPLCGkxTpouaU-aneMXwa-wfjbr8SjB98bdHbxL029hkISCS_U9ty4hbUf4CuxB1ESBD-mnKrexxoNHbE6qtQWhjxYhlHVY47i7XiMDOtWnXvsaBITqFjrszC9NZtxu35V2E_C0i3-N1E2_GANe9zKkJ9XoRMX9vaBKzXSG9jXrlMwYuOgrUjkHky9-e_263o3U_YAjlQmpXhz3hTTPysiGzqcgQHxF9aNuI2pRUdWQ2irOuFQ00oaXawD1MpB89E3EBeowpC9DNtVsrRut6RtG9_u8_zxdaLk1ll0L0KrDFFksio1ASkGb2O_aA7CYWfpaAxQz_-xoFj44w675PnVoTLHswILchMi3SmepmZ4XNYvbAILjGDBH6gRk3fXVMnF9l6peZxIwULVj0UaziO3a0JUx82iXGDSxmLMHmSt1WfV8pY1ADSGXiqsQ4ddrJIkm7Gy8itp1dqgPUSlhhN9hwNuePV229OygRd5m1xEvSyHtTwMoVbjqIWljNVOroDs7JvujrLnWgsP2F2Os47_mi5vGYHnkaGunetfBChixYyuhuRX4yhSFPpQUX-b8WQ71faxk935npx-b_-CgQRHd7bwoVmkMIrJJJdKUu7QHHg5mGCH_WPciAdKXBPa3_gbh8M8eDztyDaO9AHElCWw9fAnO_Vq7FwMf6OQIoYEYMTJ51K4-oSfKXV2Vzax2bQiyo6rDOiuILoBSXrytiOQgelQjP8UoCdWqtnZLHDQtiTwdqUUFIwlFy6tKA1ncVeLeOL3i4uosQlm8iChsktNWbTgbJ_TjeWo0O7i9Hx24eenrdfyF5dRhnxDztI2fSiWe5OsLP9oHoehA3QZ6kpz5TAz3kGX-6GiYb2JFHxOEyYh99Z1CIaCQbjdDvRhK9e5ynQfHE67Cnge7VlCA0emqnCdR-qY77027rKKdtzvm7SdulKQs4WGkZL4RA36T5GT73p3DnMPqm7gi0AOSgLocqB_v2qm0frYpjHutjh-kYhrC88wssXEcgk2bpMgbTR7aZBc-1GST2vljeNdwyxaalYOtZCCJyD0hjWszBV3rEp1QW--306c8fOxTrSMEzfO__dRciwjkrzUaeqBvGsZjKVPFELKvaqXxIoqBG9UlZJQ0kvk1dChVzVHPZX3w224nQ6IU2g29dKaMI1XCBb_6bNE06Na0-gsntjD_S40cUS2TKuRND_h-etuXUeFYChpUtOF4LDDOPqR0a_UHtxXpLur5Gln5d2Psi-EN89ftaPjNnJa2sr1OTlME6WmoAl5garBbuhcHRErXHTtJX0hFFMz-z0itH01aHW2bB_-oyA7fFnM_spl8nCspNkQTS0Q-oc8ZSZNVoY6nL0uNZHFjWMpdzM71zzKqN66JUF3nK7VO49h6d7jKvykkMJgVDOrW_5Powpkbr4amn_w4IG27NHraetaWGmmmabMiOZn22kCr7ms-9GRWq02UDLjbXD8cyUp4bMuP",
      birthday: {
        date: (Date.current - 1000).to_s,
        country: "Cameroon", 
        city: "Douala"
      },
      phones: {
        phone_1: "+39 3271852672", 
        phone_2: "+49 15206657219", 
        landline: ""
      },
      address: {
        country: "Cameroon", 
        region: "West",
        city: "Tonga", 
        street: "Quartier 5",
        po_box: "218"
      }
    }.merge(sign_up_extra)
  end

end
