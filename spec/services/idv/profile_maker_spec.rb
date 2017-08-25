require 'rails_helper'

describe Idv::ProfileMaker do
  describe '#save_profile' do
    it 'creates Profile with encrypted PII' do
      applicant = Proofer::Applicant.new first_name: 'Some', last_name: 'One'
      normalized_applicant = Proofer::Applicant.new first_name: 'Somebody', last_name: 'Oneatatime'
      user = create(:user, :signed_up)
      user.unlock_user_access_key(user.password)

      profile_maker = described_class.new(
        applicant: applicant,
        user: user,
        normalized_applicant: normalized_applicant,
        vendor: :mock,
        phone_confirmed: false
      )

      profile = profile_maker.save_profile
      pii = profile_maker.pii_attributes

      expect(profile).to be_a Profile
      expect(profile.id).to_not be_nil
      expect(profile.encrypted_pii).to_not be_nil
      expect(profile.encrypted_pii).to_not match 'Some'

      expect(pii).to be_a Pii::Attributes
      expect(pii.first_name.raw).to eq 'Some'
      expect(pii.first_name.norm).to eq 'Somebody'

      otp = pii.otp.raw
      expect(otp.length).to eq(10)
      expect(otp).to eq(Base32::Crockford.normalize(otp))
    end
  end
end
