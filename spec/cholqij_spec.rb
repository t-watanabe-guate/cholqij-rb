RSpec.describe Cholqij do
  it "has a version number" do
    expect(Cholqij::VERSION).not_to be nil
  end

  describe '.lc_to_cal' do
    context 'default gmt_mode' do
      subject{ described_class.lc_to_cal(lc) }
      context 'case 1' do
        let(:lc){ '13.0.0.0.0' }
        it{ expect(subject).to eql(Date.parse('2012-12-21')) }
      end
    end

  end
end
