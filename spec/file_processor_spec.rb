require 'file_processor'

RSpec.describe FileProcessor do
  subject { FileProcessor.new("test_data.csv") }

  let(:output) {
    [
      {
        date: "2018-03-15",
        description: "unknown",
        credit: 649.85,
        balance: -283_365.90
      },
      {
        date: "2016-10-13",
        description: "direct deposit",
        credit: 649.85,
        balance: -303_350.15
      },
      {
        date: "2016-12-20",
        description: "extra deposit",
        credit: 2_000.00,
        balance: -299_247.08
      },
      {
        date: "2016-12-05",
        description: "interest",
        debit: -931.44,
        balance: -302_247.05
      }
    ]
  }

  describe '#normalize_original_file' do
    context "when file exist" do
      it 'should have file name' do
        result = subject.normalize_original_file
        expect(result).to_not eq(false)
        expect(result[0]).to eq("Date,Description,Debit,Credit,Balance\n")
        expect(result[1]).to eq("15 Mar 2018,TRANSACTION DETAILS AVAILABLE NEXT BUSINESS DAYClick for details,,$649.85,\"-$283,365.90\"\n")
        expect(result[2]).to eq("13 Oct 2016,DEPOSIT WESTPAC BANKCORPDIRECT DR754601232Click for details,,$649.85,\"-$303,350.15\"\n")
      end
    end

    context "when file does not exist" do
      subject { FileProcessor.new("test_dat.csv") }

      it 'should return false' do
        expect(subject.normalize_original_file).to eq(false)
      end
    end
  end

  describe '#process_csv' do
    context 'should create a hash' do
      it 'should return the right value' do

        result = subject.process_csv

        expect(result[0]).to eq(output[0])
        expect(result[1]).to eq(output[1])
        expect(result[2]).to eq(output[2])
        expect(result[3]).to eq(output[3])
      end
    end
  end
end
