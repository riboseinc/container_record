# frozen_string_literal: true

RSpec.describe 'Container Record' do
  let(:google_company) { Company.find_by!(name: 'Google') }
  let(:facebook_company) { Company.find_by!(name: 'Facebook') }

  def create_employees(amount, company)
    Array.new(amount).map do
      company.create_external_record(
        Employee,
        {
          first_name: FFaker::Name.first_name,
          last_name: FFaker::Name.last_name
        }
      )
    end
  end

  def create_attachments(amount, company, employee)
    Array.new(amount).map do
      company.create_external_record(
        Attachment,
        {
          employee: employee,
          filename: FFaker::Internet.domain_name,
          s3_url:   FFaker::Internet.uri('https')
        }
      )
    end
  end

  after(:each) do
    Company.find_each do |company|
      company.employees.destroy_all
      company.attachments.destroy_all
    end
  end

  context 'test database' do
    it 'contains records of 2 companies' do
      expect(Company.count).to eq(2)
      expect(Company.pluck(:name)).to eq(%w[Google Facebook])
    end
  end

  it 'does not raise errors while accessing external database fields' do
    expect { google_company.employees }.not_to raise_error
  end

  it 'creates external records' do
    employees = create_employees(2, google_company)
    expect(google_company.employees).to be_present
    expect(google_company.employees).to eq(employees)
  end

  context 'when there is data in several companies' do
    let(:google_employees) { create_employees(2, google_company) }
    let(:facebook_employees) { create_employees(3, facebook_company) }

    before { google_employees && facebook_employees }

    it 'retrieves external records correctly' do
      expect(google_company.employees).to eq(google_employees)
      expect(facebook_company.employees).to eq(facebook_employees)
    end
  end

  describe 'joins inside of external database' do
    let(:google_employees) { create_employees(2, google_company) }
    let!(:attachments) do
      google_employees.flat_map do |employee|
        create_attachments(2, google_company, employee)
      end
    end

    subject do
      google_company.employees.joins(:attachments).where(attachments: { id: 1 })
    end

    it 'allows joins' do
      expect { subject }.not_to raise_error
      expect(subject).to eq([google_employees.first])
    end
  end
end
