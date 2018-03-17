require 'file_reader'

RSpec.describe FileReader do
  subject { FileReader.new("test_data.csv") }

  describe 'read' do
    context "when file exist" do

      it 'should have file name' do
        expect(subject.read).to_not eq(false)
      end
    end

    context "when file does not exist" do
      subject { FileReader.new("test_dat.csv") }

      it 'should return false' do
        expect(subject.read).to eq(false)
      end
    end
  end
end
