RSpec.describe Cholqij do
  it "has a version number" do
    expect(Cholqij::VERSION).not_to be nil
  end

  describe '.lc_to_cal' do
    context 'default gmt_mode(gmt_584283)' do
      subject{ described_class.lc_to_cal(lc) }
      date_list = YAML.load(File.new(File.expand_path(
        File.join(__FILE__, '..', '..', 'data', 'historical_date.yml'))))
      date_list.each.with_index(1) do |dt,idx|
        context "case #{idx}" do
          let(:lc){ dt['long_count'] }
          it{ expect(subject).to eql(Date.parse(dt['gregorian'])) }
        end
      end
    end

  end
end
