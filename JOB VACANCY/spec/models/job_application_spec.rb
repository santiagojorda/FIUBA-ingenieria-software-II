require 'spec_helper'

describe JobApplication do
  let(:job_offer) { JobOffer.new(title: 'a title', remuneration: 1000) }

  describe 'valid?' do
    it 'should be invalid when email is blank' do
      check_validation(:applicant_email, "Applicant email can't be blank") do
        described_class.create_for(nil, job_offer)
      end
    end

    it 'should be invalid when offer is blank' do
      check_validation(:job_offer, "Job offer can't be blank") do
        described_class.create_for('applicant@test.com', nil)
      end
    end
  end

  describe 'create_for' do
    it 'should set applicant_email' do
      email = 'applicant@test.com'
      ja = described_class.create_for(email, job_offer)
      expect(ja.applicant_email).to eq(email)
    end

    it 'should set job_offer' do
      offer = job_offer
      ja = described_class.create_for('applicant@test.com', offer)
      expect(ja.job_offer).to eq(offer)
    end
  end

  describe 'process' do
    it 'should deliver contact info notification' do
      ja = described_class.create_for('applicant@test.com', job_offer)
      expect(JobVacancy::App).to receive(:deliver).with(:notification, :contact_info_email, ja)
      ja.process
    end
  end
end
