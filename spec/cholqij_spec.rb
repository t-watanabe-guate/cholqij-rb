RSpec.describe Cholqij do
  it "has a version number" do
    expect(Cholqij::VERSION).not_to be nil
  end

  describe '.lc_to_cal' do
    context 'default gmt_mode(gmt_584283) - historical_date' do
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

    context 'default gmt_mode(gmt_584283) - in quirigua' do
      subject{ described_class.lc_to_cal(lc) }
      date_list = YAML.load(File.new(File.expand_path(
        File.join(__FILE__, '..', '..', 'data', 'historical_date_in_quirigua_gmt584283.yml'))))
      date_list.each.with_index(1) do |dt,idx|
        context "case #{idx} - from long count to julian" do
          let(:lc){ dt['long_count'] }
          it{ expect(subject).to eql(Date.parse(dt['julian'])) }
        end
        context "case #{idx} - from long count to gregorian" do
          let(:lc){ dt['long_count'] }
          it{ expect(subject.gregorian.to_s).to eql(Date.parse(dt['gregorian']).to_s) }
        end
      end
    end

    context 'gmt_mode(gmt_584285)' do
      subject{ described_class.lc_to_cal(lc, described_class::BASE_GMT584285) }
      date_list = YAML.load(File.new(File.expand_path(
        File.join(__FILE__, '..', '..', 'data', 'historical_date_gmt584285.yml'))))
      date_list.each.with_index(1) do |dt,idx|
        context "case #{idx}" do
          let(:lc){ dt['long_count'] }
          it{ expect(subject).to eql(Date.parse(dt['gregorian'])) }
        end
      end
    end

  end
end
